# frozen_string_literal: true

# Shared helpers for rubocop-changed (check) and rubocop-fix-changed (fix).

require "json"
require "open3"
require "set"
require "tempfile"

module RubocopChangedCommon
  Hunk = Struct.new(
    :old_start, :old_count, :new_start, :new_count, :old_lines, :new_lines,
    keyword_init: true
  )

  # Git unified diffs always use this path, including on Windows.
  GIT_DEV_NULL = "/dev/null" # rubocop:disable Style/FileNull
  SYNTAX_COP = "Lint/Syntax"
  FILE_HEADER = /\A\+\+\+ (.+?)(?:\t.*)?\n?\z/
  HUNK_HEADER = /\A@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@/

  module_function

  def repo_root
    @repo_root ||= begin
      output, status = Open3.capture2("git", "rev-parse", "--show-toplevel")
      abort "not inside a Git repository" unless status.success?

      output.strip
    end
  end

  def git_base
    ["git", "-c", "color.ui=never", "-c", "core.quotepath=false", "-C", repo_root]
  end

  def git_path(name)
    output, status = Open3.capture2(*git_base, "rev-parse", "--git-path", name)
    abort "git rev-parse --git-path failed" unless status.success?

    File.expand_path(output.strip, repo_root)
  end

  def merge_or_rebase_in_progress?
    return "merge" if File.exist?(git_path("MERGE_HEAD"))
    return "rebase" if File.directory?(git_path("rebase-merge"))
    return "rebase" if File.directory?(git_path("rebase-apply"))

    nil
  end

  def skip_if_merge_or_rebase!
    operation = merge_or_rebase_in_progress?
    return unless operation

    warn "rubocop-changed: skipping during #{operation}"
    exit 0
  end

  def normalize_path(path)
    File.expand_path(path, repo_root)
  end

  def relative_path(path)
    abs = normalize_path(path)
    abs.delete_prefix("#{repo_root}/")
  end

  def staged_ruby_files
    output, status = Open3.capture2(
      *git_base, "diff", "--cached", "--name-only", "--diff-filter=ACMR",
      "--no-color", "--no-ext-diff", "--", "*.rb", "*.rake"
    )
    abort "git diff failed" unless status.success?

    output.lines.map(&:chomp).reject(&:empty?)
  end

  def strip_diff_noise(line)
    line.delete("\r").gsub(/\e\[[\d;]*[A-Za-z]/, "")
  end

  def parse_diff_path(raw_path)
    path = raw_path.strip
    if path.start_with?('"') || path.match?(/\\[0-9]{3}/)
      abort "refusing to parse quoted git path #{path.inspect} (core.quotepath=false should prevent this)"
    end

    path
  end

  # Parse unified diff; return { absolute_path => Set<line_number> } for '+' sides.
  # Does not strip a/ or b/ prefixes: with --no-prefix, `app/models/foo.rb` must
  # stay intact (stripping `a/` would yield `pp/models/foo.rb`).
  def changed_lines_from_diff(diff_text, path_hint: nil)
    result = {}
    current_file = path_hint && normalize_path(path_hint)
    result[current_file] ||= Set.new if current_file
    saw_hunk = false
    saw_file_header = false
    pending_hunk_without_file = false

    diff_text.each_line do |raw_line|
      line = strip_diff_noise(raw_line)

      if (match = line.match(FILE_HEADER))
        saw_file_header = true
        pending_hunk_without_file = false
        path = parse_diff_path(match[1])
        if path == GIT_DEV_NULL
          current_file = nil
        else
          current_file = normalize_path(path)
          result[current_file] ||= Set.new
        end
        next
      end

      if line.start_with?("+++")
        abort "unrecognized diff file header: #{line.rstrip.inspect}"
      end

      next unless (match = line.match(HUNK_HEADER))

      saw_hunk = true
      unless current_file
        pending_hunk_without_file = true
        next
      end

      start_line = match[1].to_i
      count = (match[2] || 1).to_i
      next if count.zero?

      start_line.upto(start_line + count - 1) { |line_number| result[current_file] << line_number }
    end

    if pending_hunk_without_file && !saw_file_header && path_hint.nil?
      abort "diff hunk without a file header; refusing to pass"
    end

    if saw_hunk && result.empty? && path_hint.nil? && saw_file_header
      # Only deleted files (+++ /dev/null): nothing to lint.
      return result
    end

    if saw_hunk && result.empty? && path_hint.nil?
      abort "failed to parse changed lines from diff; refusing to pass"
    end

    result
  end

  def indexed_file?(rel_path)
    _output, status = Open3.capture2(*git_base, "cat-file", "-e", ":#{rel_path}")
    status.success?
  end

  def git_diff_command(rel_files, line_source:)
    args = git_base + ["diff"]
    args << (line_source == :staged ? "--cached" : "HEAD")
    args + ["-U0", "--no-color", "--no-ext-diff", "--no-prefix", "--", *rel_files]
  end

  def index_blob(rel_path)
    output, status = Open3.capture2(*git_base, "show", ":#{rel_path}")
    abort "git show failed for :#{rel_path}" unless status.success?

    output
  end

  def source_for(rel, line_source:)
    if line_source == :staged && indexed_file?(rel)
      index_blob(rel)
    else
      abs = normalize_path(rel)
      abort "not a file: #{rel}" unless File.file?(abs)

      File.read(abs)
    end
  end

  def changed_lines_by_file(files, line_source:)
    return {} if files.empty?

    rel_files = files.map { |file| relative_path(file) }
    command = git_diff_command(rel_files, line_source: line_source)
    output, status = Open3.capture2(*command)
    abort "git diff failed" unless status.success?

    if output.match?(/Binary files .* differ/)
      abort "binary diff is not parseable as changed lines; refusing to pass"
    end

    result = changed_lines_from_diff(output)
    assert_diff_paths_match!(result, rel_files, output)

    # Untracked / not-in-index files: every line counts as changed.
    rel_files.each do |rel|
      next if indexed_file?(rel)

      abs = normalize_path(rel)
      next unless File.file?(abs)

      result[abs] = Set.new(1..File.foreach(abs).count)
    end

    result
  end

  def assert_diff_paths_match!(result, rel_files, diff_text)
    return if rel_files.empty?
    return unless diff_text.match?(/^@@ /)

    known = rel_files.map { |rel| normalize_path(rel) }
    return if result.keys.any? { |path| known.include?(path) }

    only_deletes = diff_text.match?(%r{^\+\+\+ #{Regexp.escape(GIT_DEV_NULL)}}) &&
                   !diff_text.match?(%r{^\+\+\+ (?!#{Regexp.escape(GIT_DEV_NULL)})})
    return if only_deletes

    abort "failed to parse git diff paths for #{rel_files.join(', ')}; refusing to pass"
  end

  def head_content(rel_path)
    output, status = Open3.capture2(*git_base, "show", "HEAD:#{rel_path}")
    return nil unless status.success?

    output
  end

  def unified_diff_u0(old_content, new_content, label)
    Tempfile.create(["rubocop-changed-old", ".rb"]) do |old_file|
      Tempfile.create(["rubocop-changed-new", ".rb"]) do |new_file|
        old_file.write(old_content)
        old_file.flush
        new_file.write(new_content)
        new_file.flush

        output, _status = Open3.capture2(
          "diff", "-U0",
          "--label", label,
          "--label", label,
          old_file.path, new_file.path
        )
        # diff exits 1 when files differ
        output
      end
    end
  end

  def changed_lines_for_stdin(path, buffer_content)
    abs = normalize_path(path)
    rel = relative_path(path)
    old = head_content(rel)

    if old.nil?
      line_count = buffer_content.lines.size
      return { abs => Set.new(1.upto(line_count)) }
    end

    diff = unified_diff_u0(old, buffer_content, rel)
    changed_lines_from_diff(diff, path_hint: abs)
  end

  def rubocop_bin
    candidate = File.join(repo_root, "bin/rubocop")
    File.executable?(candidate) ? candidate : "rubocop"
  end

  # Untracked per-developer overrides (see ~/dots-private). The file inherits the
  # project's .rubocop.yml, so selecting it only adds personal settings.
  def personal_config_args
    config = File.join(repo_root, ".rubocop_personal.yml")
    File.exist?(config) ? ["--config", config] : []
  end

  def run_rubocop(files, rubocop_args, line_source:)
    combined = { "files" => [] }

    files.each do |file|
      rel = relative_path(file)
      contents = source_for(rel, line_source: line_source)
      check_args = rubocop_args.reject { |argument| argument == "--parallel" }
      stdout, stderr, _status = run_rubocop_stdin(
        rel,
        contents,
        ["--format", "json", *check_args],
        autocorrect: false
      )
      combined["files"].concat(parse_rubocop_json(stdout, stderr).fetch("files", []))
    end

    combined
  end

  def parse_rubocop_json(stdout, stderr)
    if stdout.strip.empty?
      warn stderr unless stderr.strip.empty?
      abort "rubocop produced no JSON output"
    end

    JSON.parse(stdout)
  rescue JSON::ParserError => error
    warn stdout
    warn stderr
    abort "failed to parse rubocop JSON: #{error.message}"
  end

  def run_rubocop_stdin(path, content, rubocop_args, autocorrect:)
    cmd = [
      rubocop_bin,
      "--force-exclusion",
      *personal_config_args,
      *rubocop_args,
      "--stdin", relative_path(path)
    ]
    cmd.insert(2, "--auto-correct-all") if autocorrect

    Open3.capture3(*cmd, chdir: repo_root, stdin_data: content)
  end

  def offense_on_changed_line?(offense, changed_lines)
    return true if offense["cop_name"] == SYNTAX_COP

    location = offense.fetch("location")
    start_line = location["start_line"] || location["line"]
    return false unless start_line

    # Only the line the offense is anchored on counts. Scope-level cops such as
    # Metrics/ClassLength report a range covering the whole class, so matching the
    # full range would flag them for any edit inside the file.
    changed_lines.include?(start_line)
  end

  def strip_rubocop_stdin_payload(stdout)
    lines = stdout.lines
    separator_index = lines.index { |line| line.match?(/^=+$/) }
    return stdout if separator_index.nil?

    lines[(separator_index + 1)..].join
  end

  def parse_hunks(diff_text)
    hunks = []
    current = nil

    diff_text.each_line do |raw_line|
      line = strip_diff_noise(raw_line)
      if (match = line.match(/\A@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@/))
        current = Hunk.new(
          old_start: match[1].to_i,
          old_count: (match[2] || 1).to_i,
          new_start: match[3].to_i,
          new_count: (match[4] || 1).to_i,
          old_lines: [],
          new_lines: []
        )
        hunks << current
        next
      end

      next unless current

      case line[0]
      when "-"
        current.old_lines << line[1..].chomp
      when "+"
        current.new_lines << line[1..].chomp
      when " "
        current.old_lines << line[1..].chomp
        current.new_lines << line[1..].chomp
      when "\\"
        next
      end
    end

    hunks
  end

  def hunk_touches_changed_lines?(hunk, changed_lines)
    if hunk.old_count.positive?
      old_end = hunk.old_start + hunk.old_count - 1
      return true if (hunk.old_start..old_end).any? { |line_number| changed_lines.include?(line_number) }
    end

    # Pure insertion: anchor is "after old_start"; also check the following line.
    changed_lines.include?(hunk.old_start) || changed_lines.include?(hunk.old_start + 1)
  end

  def apply_hunks_selectively(original_content, corrected_content, changed_lines, label:)
    return original_content if original_content == corrected_content
    return original_content if changed_lines.nil? || changed_lines.empty?

    diff = unified_diff_u0(original_content, corrected_content, label)
    hunks = parse_hunks(diff)
    return original_content if hunks.empty?

    original_lines = original_content.lines.map(&:chomp)

    hunks.reverse_each do |hunk|
      # Adjacent single-line edits often collapse into one hunk with -U0
      # (e.g. two string-literal fixes on consecutive lines). Apply those
      # line-by-line so untouched neighbors stay untouched.
      if hunk.old_count.positive? && hunk.old_count == hunk.new_count
        hunk.old_count.times do |offset|
          line_number = hunk.old_start + offset
          next unless changed_lines.include?(line_number)

          original_lines[line_number - 1] = hunk.new_lines.fetch(offset)
        end
        next
      end

      next unless hunk_touches_changed_lines?(hunk, changed_lines)

      if hunk.old_count.positive?
        start_index = hunk.old_start - 1
        original_lines[start_index, hunk.old_count] = hunk.new_lines
      else
        # @@ -N,0 +M,K @@ inserts K lines after line N.
        original_lines.insert(hunk.old_start, *hunk.new_lines)
      end
    end

    rebuilt = original_lines.join("\n")
    rebuilt += "\n" if corrected_content.end_with?("\n")
    rebuilt
  end

  def split_files_and_rubocop_args(args)
    split_at = args.index("--")
    if split_at
      [args[0...split_at], args[(split_at + 1)..]]
    else
      [args, []]
    end
  end
end
