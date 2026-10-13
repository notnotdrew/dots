#!/usr/bin/env ruby
# frozen_string_literal: true

# Small YAML helpers for bin/untangle (stdlib only).
# Usage: untangle_yaml.rb <command> [args...]

require "yaml"
require "fileutils"
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
