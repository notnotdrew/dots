#!/usr/bin/env ruby
# frozen_string_literal: true

# Small YAML helpers for bin/untangle (stdlib only).
# Usage: untangle_yaml.rb <command> [args...]

require "yaml"
require "fileutils"
require "json"
require "time"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

def default_global
  {
    "version" => 1,
    "defaults" => {
      "runtime" => "cursor-cli",
      "schedule" => {
        "days" => %w[wed],
        "window_local" => "08:00-16:00",
        "catch_up_missed_days" => false
      }
    },
    "repos" => []
  }
end

def initial_repo_config
  {
    "version" => 1,
    # Blank means main. Git is not consulted here.
    "trunk" => ""
  }
end

def load_yaml(path)
  return {} unless File.file?(path)

  data = YAML.load_file(path)
  data.is_a?(Hash) ? data : {}
end

def dump_yaml(path, data)
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, YAML.dump(data))
end

def repo_paths(data)
  repos = data["repos"] || data[:repos] || []
  Array(repos).map do |entry|
    entry.is_a?(Hash) ? (entry["path"] || entry[:path]).to_s : entry.to_s
  end
end

# Blank or missing trunk means main. The file itself is left unchanged.
def trunk_name(data)
  return "main" unless data.is_a?(Hash)

  key =
    if data.key?("trunk")
      "trunk"
    elsif data.key?(:trunk)
      :trunk
    end
  return "main" if key.nil?

  text = data[key].nil? ? "" : data[key].to_s
  text.empty? ? "main" : text
end

def json_load(path)
  JSON.parse(File.read(path))
rescue JSON::ParserError, Errno::ENOENT
  nil
end

def herdr_create_path(data)
  return "" unless data.is_a?(Hash)

  result = data["result"]
  return "" unless result.is_a?(Hash)

  worktree = result["worktree"]
  return "" unless worktree.is_a?(Hash)

  worktree["path"].to_s
end

def herdr_list_path(data, branch)
  return "" unless data.is_a?(Hash)

  result = data["result"]
  return "" unless result.is_a?(Hash)

  worktrees = result["worktrees"]
  return "" unless worktrees.is_a?(Array)

  worktrees.each do |entry|
    next unless entry.is_a?(Hash)
    next unless entry["branch"].to_s == branch

    return entry["path"].to_s
  end
  ""
end

def protected_identities(path)
  idents = []
  listed = File.lstat(path)
  idents << [listed.dev, listed.ino]
  followed = File.stat(path)
  idents << [followed.dev, followed.ino]
  idents.uniq
end

def protected_stat?(stat, idents)
  idents.any? { |dev, ino| stat.dev == dev && stat.ino == ino }
end

# Delete a copied directory without walking a symlink into the registered tree.
# A trailing slash is never added: on macOS, rm follows that into the target.
def remove_copied_dir(dest, protected)
  dest_real = File.realpath(dest)
  protected_real = File.realpath(protected)
  same = dest_real == protected_real
  inside = dest_real.start_with?(protected_real + File::SEPARATOR)
  if same || inside
    abort "refusing to remove registered untangle tree: #{dest}"
  end

  idents = protected_identities(protected)
  remove_nofollow(dest, idents)
end

def remove_nofollow(path, idents)
  listed = File.lstat(path)
  if protected_stat?(listed, idents)
    abort "refusing to remove registered untangle tree: #{path}"
  end

  if listed.symlink?
    File.unlink(path)
    return
  end

  if listed.directory?
    followed = File.stat(path)
    if protected_stat?(followed, idents)
      abort "refusing to remove registered untangle tree: #{path}"
    end

    children = []
    Dir.foreach(path) do |name|
      next if name == "." || name == ".."

      children << name
    end
    children.each do |name|
      remove_nofollow(File.join(path, name), idents)
    end
    Dir.rmdir(path)
    return
  end

  File.unlink(path)
end

BUCKETS = %w[
  Language
  Ownership
  Boundaries
  Representation
  Flow
  Dependencies
  Consolidation
  Removal
].freeze

# Missing or blank prints Language. A known bucket prints its name.
# Anything else prints invalid. This does not write the file.
def cursor_bucket(data)
  return "Language" unless data.is_a?(Hash)

  key =
    if data.key?("cursor")
      "cursor"
    elsif data.key?(:cursor)
      :cursor
    end
  return "Language" if key.nil?

  text = data[key].nil? ? "" : data[key].to_s
  return "Language" if text.empty?
  return text if BUCKETS.include?(text)

  "invalid"
end

# First word after leading whitespace, when it is exactly plan or quiet.
def note_word(path)
  return "" unless File.file?(path)

  text = File.read(path)
  stripped = text.sub(/\A[[:space:]]+/, "")
  word = stripped[/\A\S+/]
  return word if word == "plan" || word == "quiet"

  ""
end

def open_plan_value(data, key = "open_plan")
  return "" unless data.is_a?(Hash)

  string_key = key.to_s
  symbol_key = string_key.to_sym
  found =
    if data.key?(string_key)
      string_key
    elsif data.key?(symbol_key)
      symbol_key
    end
  return "" if found.nil?

  value = data[found]
  value.is_a?(String) ? value : ""
end

# Store an absolute path string. Other keys stay.
def store_open_plan(data, note_path, key = "open_plan")
  data = {} unless data.is_a?(Hash)
  data[key.to_s] = File.expand_path(note_path.to_s)
  data
end

# Drop the named plan key. Other keys stay. The cursor is not touched.
def clear_open_plan(data, key = "open_plan")
  data = {} unless data.is_a?(Hash)
  string_key = key.to_s
  data.delete(string_key)
  data.delete(string_key.to_sym)
  data
end

# Missing or blank cursor counts as Language. Removal wraps to Language.
# Other keys stay. open_plan is not touched.
# Returns nil when the cursor is not one of the eight buckets.
def advance_cursor(data)
  data = {} unless data.is_a?(Hash)
  index = BUCKETS.index(cursor_bucket(data))
  return nil if index.nil?

  data["cursor"] = BUCKETS[(index + 1) % BUCKETS.length]
  data
end

# absent | pid:<positive integer> | stale
def progress_pid_state(data)
  return "absent" unless data.is_a?(Hash)

  key =
    if data.key?("progress_pid")
      "progress_pid"
    elsif data.key?(:progress_pid)
      :progress_pid
    end
  return "absent" if key.nil?

  value = data[key]
  if value.is_a?(Integer) && value.positive?
    "pid:#{value}"
  else
    "stale"
  end
end

command = ARGV.fetch(0)

case command
when "ensure_global"
  config_path = ARGV.fetch(1)
  data = load_yaml(config_path)
  if data.empty?
    dump_yaml(config_path, default_global)
  end

when "register_repo"
  config_path = ARGV.fetch(1)
  repo_path = File.expand_path(ARGV.fetch(2))
  data = load_yaml(config_path)
  data["version"] ||= 1
  data["defaults"] ||= default_global["defaults"]
  repos = data["repos"]
  repos = [] unless repos.is_a?(Array)
  paths = repos.map do |entry|
    entry.is_a?(Hash) ? (entry["path"] || entry[:path]).to_s : entry.to_s
  end
  unless paths.include?(repo_path)
    repos << { "path" => repo_path }
    data["repos"] = repos
    dump_yaml(config_path, data)
  end

when "ensure_repo_config"
  repo_yml = ARGV.fetch(1)
  unless File.file?(repo_yml)
    dump_yaml(repo_yml, initial_repo_config)
  end

when "list_repos"
  config_path = ARGV.fetch(1)
  data = load_yaml(config_path)
  repo_paths(data).each { |path| puts path }

when "progress_pid_state"
  repo_yml = ARGV.fetch(1)
  puts progress_pid_state(load_yaml(repo_yml))

when "set_progress_pid"
  repo_yml = ARGV.fetch(1)
  pid = Integer(ARGV.fetch(2))
  raise ArgumentError, "pid must be positive" unless pid.positive?

  data = load_yaml(repo_yml)
  data["progress_pid"] = pid
  dump_yaml(repo_yml, data)

when "clear_progress_pid"
  repo_yml = ARGV.fetch(1)
  data = load_yaml(repo_yml)
  data.delete("progress_pid")
  data.delete(:progress_pid)
  dump_yaml(repo_yml, data)

when "trunk_name"
  repo_yml = ARGV.fetch(1)
  puts trunk_name(load_yaml(repo_yml))

when "herdr_create_path"
  puts herdr_create_path(json_load(ARGV.fetch(1)))

when "herdr_list_path"
  json_path = ARGV.fetch(1)
  branch = ARGV.fetch(2)
  puts herdr_list_path(json_load(json_path), branch)

when "remove_copied_dir"
  remove_copied_dir(ARGV.fetch(1), ARGV.fetch(2))

when "cursor_bucket"
  puts cursor_bucket(load_yaml(ARGV.fetch(1)))

when "note_word"
  puts note_word(ARGV.fetch(1))

when "open_plan_value"
  puts open_plan_value(load_yaml(ARGV.fetch(1)))

when "set_open_plan"
  repo_yml = ARGV.fetch(1)
  data = store_open_plan(load_yaml(repo_yml), ARGV.fetch(2))
  dump_yaml(repo_yml, data)

when "clear_open_plan"
  repo_yml = ARGV.fetch(1)
  data = clear_open_plan(load_yaml(repo_yml))
  dump_yaml(repo_yml, data)

when "clear_open_change_plan"
  repo_yml = ARGV.fetch(1)
  data = clear_open_plan(load_yaml(repo_yml), "open_change_plan")
  dump_yaml(repo_yml, data)

when "open_change_plan_value"
  puts open_plan_value(load_yaml(ARGV.fetch(1)), "open_change_plan")

when "set_open_change_plan"
  repo_yml = ARGV.fetch(1)
  data = store_open_plan(load_yaml(repo_yml), ARGV.fetch(2), "open_change_plan")
  dump_yaml(repo_yml, data)

when "advance_cursor"
  repo_yml = ARGV.fetch(1)
  data = advance_cursor(load_yaml(repo_yml))
  if data.nil?
    warn "invalid cursor"
    exit 1
  end
  dump_yaml(repo_yml, data)

when "parse_now"
  # Print: date weekday hour minute  (weekday: 1=Mon .. 7=Sun)
  now = ARGV.fetch(1)
  time = Time.strptime(now, "%Y-%m-%dT%H:%M:%S")
  # Ruby wday: 0=Sun..6=Sat → ISO 1=Mon..7=Sun
  iso_weekday = time.wday == 0 ? 7 : time.wday
  printf "%s %d %02d %02d\n", time.strftime("%Y-%m-%d"), iso_weekday, time.hour, time.min

else
  warn "unknown command: #{command}"
  exit 1
end
