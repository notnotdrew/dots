#!/usr/bin/env ruby
# frozen_string_literal: true

# Small YAML helpers for bin/inchworm (stdlib only).
# Usage: inchworm_yaml.rb <command> [args...]

require "yaml"
require "json"
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
        "days" => %w[mon tue wed thu fri],
        "window_local" => "08:00-15:00",
        "catch_up_missed_days" => false,
        "poll_interval_hint" => "1h"
      }
    },
    "repos" => []
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

# Same recognition as the create-window draft gate: open draft whose URL is the
# recorded active_draft_pr, or whose head matches <prefix>/.+-<YYYYMMDD>.
def matching_drafts(prs, branch_prefix, recorded_url)
  recorded_url = "" if recorded_url.nil? || recorded_url == "null"
  managed_branch = /\A#{Regexp.escape(branch_prefix)}\/.+-\d{8}\z/
  Array(prs).select do |pr|
    next false unless pr.is_a?(Hash)
    next false unless pr["isDraft"] == true

    url = pr["url"].to_s
    head = pr["headRefName"].to_s
    next true if !recorded_url.empty? && url == recorded_url

    !branch_prefix.empty? && managed_branch.match?(head)
  end
end

def parse_gh_pr_list(raw)
  prs = JSON.parse(raw)
  prs.is_a?(Array) ? prs : []
rescue JSON::ParserError
  []
end

def repo_paths(data)
  repos = data["repos"] || data[:repos] || []
  Array(repos).map do |entry|
    entry.is_a?(Hash) ? (entry["path"] || entry[:path]).to_s : entry.to_s
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
  repo_path = ARGV.fetch(2)
  data = load_yaml(config_path)
  data["version"] ||= 1
  data["defaults"] ||= default_global["defaults"]
  repos = data["repos"]
  repos = [] unless repos.is_a?(Array)
  paths = repo_paths("repos" => repos)
  unless paths.include?(repo_path)
    repos << { "path" => repo_path }
    data["repos"] = repos
    dump_yaml(config_path, data)
  end

when "ensure_repo_yml"
  repo_yml = ARGV.fetch(1)
  unless File.file?(repo_yml)
    dump_yaml(
      repo_yml,
      {
        "version" => 1,
        # Plain-text notes for agents (scouts, implementer, fixer). Optional.
        "guidance" => "",
        # Branch namespace, e.g. "drew" → drew/<slug>-<date>. Blank uses git user.name.
        "branch_prefix" => "",
        "state" => {
          "last_run_date" => nil,
          "active_draft_pr" => nil
        }
      }
    )
  end

when "list_repos"
  config_path = ARGV.fetch(1)
  data = load_yaml(config_path)
  repo_paths(data).each { |path| puts path }

when "get"
  path = ARGV.fetch(1)
  keys = ARGV.fetch(2).split(".")
  data = load_yaml(path)
  value = keys.reduce(data) do |current, key|
    break nil unless current.is_a?(Hash)

    current.key?(key) ? current[key] : current[key.to_sym]
  end
  case value
  when nil
    print "null"
  when true
    print "true"
  when false
    print "false"
  else
    print value
  end

when "set_state"
  repo_yml = ARGV.fetch(1)
  key = ARGV.fetch(2)
  raw_value = ARGV.fetch(3)
  data = load_yaml(repo_yml)
  data["version"] ||= 1
  data["state"] ||= {}
  value =
    case raw_value
    when "null", ""
      nil
    else
      raw_value
    end
  data["state"][key] = value
  dump_yaml(repo_yml, data)

when "find_blocking_draft"
  # find_blocking_draft <branch_prefix> [recorded_url]; reads gh JSON from stdin
  # and prints the first blocking PR url or empty. Malformed JSON → not blocking.
  #
  # Two ways to recognise our own draft, both checked against the live PR list so
  # a merged or closed PR never blocks:
  #   1. the URL recorded in state — exact, and survives a branch-naming change
  #   2. the branch shape — the recovery path when state was lost or wiped
  # The prefix belongs to the human, so it also covers branches they cut by hand.
  # The trailing date is what separates a generated branch from those.
  branch_prefix = ARGV[1].to_s
  recorded_url = ARGV[2].to_s
  blocking = matching_drafts(parse_gh_pr_list($stdin.read), branch_prefix, recorded_url).first
  if blocking
    url = blocking["url"].to_s
    number = blocking["number"]
    head = blocking["headRefName"].to_s
    puts [url.empty? ? "PR##{number}" : url, head].join("\t")
  end

when "list_matching_drafts"
  # list_matching_drafts <branch_prefix> [recorded_url]; stdin gh JSON.
  # One TSV line per matching draft: number, url, headRefName.
  branch_prefix = ARGV[1].to_s
  recorded_url = ARGV[2].to_s
  matching_drafts(parse_gh_pr_list($stdin.read), branch_prefix, recorded_url).each do |pr|
    number = pr["number"]
    url = pr["url"].to_s
    head = pr["headRefName"].to_s
    puts [number, url.empty? ? "PR##{number}" : url, head].join("\t")
  end

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
