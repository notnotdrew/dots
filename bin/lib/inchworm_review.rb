#!/usr/bin/env ruby
# frozen_string_literal: true

# Review helpers for bin/inchworm (stdlib only).
# Usage: inchworm_review.rb <command> [args...]
#
# Blocking for fixer = findings with Class: blocking AND Disposition: verified.

require "digest"
require "fileutils"

LEDGER_HEADER = <<~HEADER.freeze
  # Findings Ledger

  ## Identity

  - Mode: Standard
  - UnresolvedMaterialDecisions: none

  ## Findings
HEADER

FIXTURE_FINDINGS = {
  "none" => "No findings.\n",
  "advisory" => <<~FINDINGS,
    ### Finding F001

    - ID: F001
    - Claim: Prefer clearer naming in helper
    - Impact: Maintainability only
    - Principle: Clarity
    - Class: advisory
    - Disposition: verified
  FINDINGS
  "blocking" => <<~FINDINGS
    ### Finding F001

    - ID: F001
    - Claim: Missing nil guard breaks callers
    - Impact: Runtime failure on empty input
    - Principle: Reliability
    - Class: blocking
    - Disposition: verified

    ### Finding F002

    - ID: F002
    - Claim: Candidate blocker not yet verified
    - Impact: Should not drive fixer alone
    - Principle: Reliability
    - Class: blocking
    - Disposition: candidate

    ### Finding F003

    - ID: F003
    - Claim: Style preference
    - Impact: None
    - Principle: Taste
    - Class: advisory
    - Disposition: verified
  FINDINGS
}.freeze

def path_hash(abs_path)
  Digest::SHA256.hexdigest(abs_path)[0, 16]
end

def repo_data_dir(data_dir, repo_path)
  File.join(data_dir, path_hash(repo_path))
end

def review_dir_for(data_dir, repo_path)
  File.join(repo_data_dir(data_dir, repo_path), "review")
end

def fix_dir_for(data_dir, repo_path)
  File.join(repo_data_dir(data_dir, repo_path), "fix")
end

# Parse findings-ledger.md into finding hashes with class + disposition.
def parse_findings_ledger(path)
  return [] unless File.file?(path)

  findings = []
  current = nil
  File.foreach(path) do |line|
    if line.match?(/\A###\s+Finding\b/i)
      findings << current if current
      current = { "class" => "", "disposition" => "" }
      next
    end
    next unless current

    if (match = line.match(/\A-\s*Class:\s*(.+)\s*\z/i))
      current["class"] = match[1].strip.downcase
    elsif (match = line.match(/\A-\s*Disposition:\s*(.+)\s*\z/i))
      current["disposition"] = match[1].strip.downcase
    end
  end
  findings << current if current
  findings
end

def blocking_verified_findings(ledger_path)
  parse_findings_ledger(ledger_path).select do |finding|
    finding["class"] == "blocking" && finding["disposition"] == "verified"
  end
end

def findings_ledger_body(findings_section)
  "#{LEDGER_HEADER}\n#{findings_section}"
end

def write_empty_ledger(review_dir)
  FileUtils.mkdir_p(review_dir)
  File.write(File.join(review_dir, "findings-ledger.md"), findings_ledger_body(FIXTURE_FINDINGS.fetch("none")))
end

def write_review_fixture(fixture, review_dir)
  findings_section = FIXTURE_FINDINGS[fixture]
  unless findings_section
    warn "unknown review fixture: #{fixture}"
    exit 1
  end

  FileUtils.mkdir_p(review_dir)
  File.write(File.join(review_dir, "findings-ledger.md"), findings_ledger_body(findings_section))
  File.write(File.join(review_dir, "context-brief.md"), "# Context brief (fixture stub)\n")
  File.write(File.join(review_dir, "perfect-review.md"), "# PERFECT review (fixture stub)\n")
end

if $PROGRAM_NAME == __FILE__
  command = ARGV.fetch(0)

  case command
  when "review_dir"
    # review_dir <repo_abs_path> <data_dir>
    puts review_dir_for(ARGV.fetch(2), ARGV.fetch(1))

  when "fix_dir"
    # fix_dir <repo_abs_path> <data_dir>
    puts fix_dir_for(ARGV.fetch(2), ARGV.fetch(1))

  when "blocking_count"
    # blocking_count <ledger_path>
    puts blocking_verified_findings(ARGV.fetch(1)).length

  when "write_fixture"
    # write_fixture <none|advisory|blocking> <review_dir>
    write_review_fixture(ARGV.fetch(1), ARGV.fetch(2))

  when "write_empty_ledger"
    # write_empty_ledger <review_dir> — none-shaped ledger only (soft-fail stub)
    write_empty_ledger(ARGV.fetch(1))

  else
    warn "unknown command: #{command}"
    exit 1
  end
end
