#!/usr/bin/env ruby
# frozen_string_literal: true

# Finds helpers for bin/inchworm (stdlib only).
# Usage: inchworm_finds.rb <command> [args...]

require "json"
require "digest"
require "fileutils"

SCOUT_SOURCES = %w[smell lint errors backlog].freeze

SOURCE_PREFIX_RE = /\A(?:#{SCOUT_SOURCES.join('|')})-/.freeze
ISSUE_KEY_RE = /\b([A-Z]{2,6}-\d+)\b/.freeze
HB_FAULT_RE = /\bHB[#\s]*(\d{6,})\b/i.freeze
# Uppercase-dash-number pairs that look like issue keys but are not.
NON_ISSUE_PREFIXES = %w[
  UTF SHA MD5 AES RFC ISO HTTP HTTPS RGB RGBA UTC IPV X86 ARM SSE AVX BASE
].freeze

def path_hash(abs_path)
  Digest::SHA256.hexdigest(abs_path)[0, 16]
end

def finds_dir_for(data_dir, repo_path)
  File.join(data_dir, path_hash(repo_path))
end

def normalize_status(raw)
  status = raw.to_s.strip.downcase
  return "open" if status.empty? || status == "new"

  status
end

def normalize_candidate(raw)
  return nil unless raw.is_a?(Hash)

  id = (raw["id"] || raw[:id]).to_s.strip
  return nil if id.empty?

  id = id.sub(/\AF-/i, "")
  {
    "id" => id,
    "status" => normalize_status(raw["status"] || raw[:status]),
    "source" => (raw["source"] || raw[:source] || "smell").to_s,
    "rank" => Integer(raw["rank"] || raw[:rank] || 99),
    "title" => (raw["title"] || raw[:title] || id).to_s,
    "summary" => (raw["summary"] || raw[:summary] || "").to_s,
    "evidence" => (raw["evidence"] || raw[:evidence]).to_s
  }
rescue ArgumentError, TypeError
  nil
end

# Extract a JSON array from agent stdout (raw JSON, fenced block, or prose-wrapped).
def extract_json_array(text)
  text = text.to_s.strip
  return [] if text.empty?

  try_parse = lambda do |blob|
    parsed = JSON.parse(blob)
    parsed.is_a?(Array) ? parsed : nil
  rescue JSON::ParserError, TypeError
    nil
  end

  parsed = try_parse.call(text)
  return parsed if parsed

  unfenced = text.sub(/\A```(?:json)?\s*/i, "").sub(/\s*```\z/, "").strip
  parsed = try_parse.call(unfenced)
  return parsed if parsed

  start_idx = text.index("[")
  end_idx = text.rindex("]")
  if start_idx && end_idx && end_idx > start_idx
    parsed = try_parse.call(text[start_idx..end_idx])
    return parsed if parsed
  end

  nil
end

def load_fixture_candidates(fixture_dir)
  return [] if fixture_dir.nil? || fixture_dir.empty?
  return [] unless File.directory?(fixture_dir)

  candidates = []
  SCOUT_SOURCES.each do |source|
    path = File.join(fixture_dir, "#{source}.json")
    next unless File.file?(path)

    parsed = extract_json_array(File.read(path))
    next unless parsed.is_a?(Array)

    parsed.each do |item|
      candidate = normalize_candidate(item)
      candidates << candidate if candidate
    end
  end
  candidates
end

def parse_finds_md(path)
  return [] unless File.file?(path)

  finds = []
  current = nil
  File.foreach(path) do |line|
    if (match = line.match(/\A##\s+F-(.+)\s*\z/))
      finds << current if current
      current = {
        "id" => match[1].strip,
        "status" => "open",
        "source" => "smell",
        "rank" => 99,
        "title" => match[1].strip,
        "summary" => "",
        "evidence" => ""
      }
      next
    end
    next unless current

    if (field = line.match(/\A-\s*status:\s*(.+)\s*\z/i))
      current["status"] = normalize_status(field[1])
    elsif (field = line.match(/\A-\s*source:\s*(.+)\s*\z/i))
      current["source"] = field[1].strip
    elsif (field = line.match(/\A-\s*rank:\s*(.+)\s*\z/i))
      begin
        current["rank"] = Integer(field[1].strip)
      rescue ArgumentError
        current["rank"] = 99
      end
    elsif (field = line.match(/\A-\s*title:\s*(.+)\s*\z/i))
      current["title"] = field[1].strip
    elsif (field = line.match(/\A-\s*summary:\s*(.+)\s*\z/i))
      current["summary"] = field[1].strip
    elsif (field = line.match(/\A-\s*evidence:\s*(.+)\s*\z/i))
      current["evidence"] = field[1].strip
    end
  end
  finds << current if current
  finds
end

# Scouts reach the same work from different angles — one Linear issue surfaced by
# both the backlog and lint scouts, one Honeybadger fault reported twice — so
# exact-id dedupe leaves near-duplicate finds that get picked on consecutive days.
# Identity is therefore any strong shared marker, not just the id.
def identity_tokens(find)
  tokens = []
  base = find["id"].to_s.downcase.sub(SOURCE_PREFIX_RE, "")
  tokens << "id:#{base}" unless base.empty?

  haystack = [find["id"], find["title"], find["summary"], find["evidence"]].join(" ")
  haystack.upcase.scan(ISSUE_KEY_RE) do |key,|
    next if NON_ISSUE_PREFIXES.include?(key.split("-").first)

    tokens << "issue:#{key}"
  end
  haystack.scan(HB_FAULT_RE) { |fault_id,| tokens << "hb:#{fault_id}" }
  tokens.uniq
end

# First occurrence wins, so stored finds keep their status (in_pr, deferred) over
# an incoming duplicate. A dropped duplicate still aliases its own tokens onto the
# survivor, so a third variant sharing only the duplicate's id collapses too.
def merge_finds(existing, candidates)
  merged = []
  token_index = {}

  claim = lambda do |find|
    tokens = identity_tokens(find)
    existing_idx = tokens.map { |token| token_index[token] }.compact.first
    idx = existing_idx
    unless idx
      merged << find
      idx = merged.length - 1
    end
    tokens.each { |token| token_index[token] ||= idx }
  end

  existing.each { |find| claim.call(find) }
  candidates.each { |candidate| claim.call(candidate) }
  merged
end

# After merge: drop deferred/too_large; keep all in_pr (and other non-open); cap open at 20.
def tidy_finds(finds)
  kept = finds.reject do |find|
    status = find["status"].to_s.downcase
    status == "deferred" || status == "too_large"
  end

  open_finds, other_finds = kept.partition { |find| find["status"].to_s.downcase == "open" }
  open_capped = open_finds
    .sort_by { |find| [find["rank"].to_i, find["id"].to_s] }
    .first(20)

  other_finds + open_capped
end

def render_finds_md(finds)
  lines = [
    "# Inchworm finds",
    "",
    "<!-- inchworm:finds-version:1 -->",
    ""
  ]
  finds.each do |find|
    lines << "## F-#{find['id']}"
    lines << ""
    lines << "- status: #{find['status']}"
    lines << "- source: #{find['source']}"
    lines << "- rank: #{find['rank']}"
    lines << "- title: #{find['title']}"
    lines << "- summary: #{find['summary']}"
    if find["evidence"] && !find["evidence"].empty?
      lines << "- evidence: #{find['evidence']}"
    end
    lines << ""
  end
  lines.join("\n")
end

def write_finds_md(path, finds)
  ordered = finds.sort_by { |find| [find["rank"].to_i, find["id"].to_s] }
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, render_finds_md(ordered))
end

def pick_open(finds)
  open_finds = finds.select { |find| find["status"].to_s.downcase == "open" }
  return nil if open_finds.empty?

  open_finds.min_by { |find| [find["rank"].to_i, find["id"].to_s] }
end

def set_find_status(repo_path, data_dir, find_id, new_status)
  id = find_id.to_s.sub(/\AF-/i, "").strip
  dir = finds_dir_for(data_dir, repo_path)
  finds_md = File.join(dir, "finds.md")
  finds = parse_finds_md(finds_md)
  target = finds.find { |find| find["id"] == id }
  return false unless target

  target["status"] = normalize_status(new_status)
  write_finds_md(finds_md, finds)
  true
end

command = ARGV.fetch(0)

case command
when "path_hash"
  puts path_hash(ARGV.fetch(1))

when "extract_json_array"
  parsed = extract_json_array(STDIN.read)
  if parsed.nil?
    warn "could not extract JSON array from scout output"
    exit 1
  end
  puts JSON.generate(parsed)

when "set_status"
  # set_status <repo_abs_path> <data_dir> <id> <status>
  repo_path = ARGV.fetch(1)
  data_dir = ARGV.fetch(2)
  find_id = ARGV.fetch(3)
  new_status = ARGV.fetch(4)
  unless set_find_status(repo_path, data_dir, find_id, new_status)
    warn "find not found: #{find_id}"
    exit 1
  end

when "discover"
  # discover <repo_abs_path> <data_dir> [fixture_dir]
  repo_path = ARGV.fetch(1)
  data_dir = ARGV.fetch(2)
  fixture_dir = ARGV[3]

  dir = finds_dir_for(data_dir, repo_path)
  FileUtils.mkdir_p(dir)
  finds_md = File.join(dir, "finds.md")

  existing = parse_finds_md(finds_md)
  candidates = load_fixture_candidates(fixture_dir)
  merged = tidy_finds(merge_finds(existing, candidates))
  write_finds_md(finds_md, merged)

  selected = pick_open(merged)
  if selected
    printf "inchworm: selected F-%s — %s\n", selected["id"], selected["title"]
  else
    puts "inchworm: selected none — no eligible find"
  end

else
  warn "unknown command: #{command}"
  exit 1
end
