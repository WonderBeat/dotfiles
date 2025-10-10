#!/bin/sh

# jump-to-error.sh - Interactive file:line:column reference navigator
#
# DESCRIPTION:
#   Parses input (from stdin or pipe) to extract file:line:column references
#   (e.g., "src/main.c:42:10") and presents them in an interactive fzf menu.
#   Selected files are opened directly in Zed editor at the specified location.
#
# USAGE:
#   # From compiler output
#   make 2>&1 | jump-to-error.sh
#
#   # From linter/formatter output
#   eslint . | jump-to-error.sh
#   pylint myfile.py | jump-to-error.sh
#
#   # From grep results with line numbers
#   grep -rn "TODO" . | jump-to-error.sh
#
#   # From saved log files
#   jump-to-error.sh < build.log
#   cat test-results.txt | jump-to-error.sh
#
# FEATURES:
#   - Extracts and deduplicates file:line:col references from any text input
#   - Interactive fzf selection with fuzzy search and filtering
#   - Live preview shows the error context (matching line + 7 following lines)
#   - Opens selected file in Zed editor positioned at exact line:column
#   - Handles multiple references to same file (shows unique entries only)
#   - Supports standard file path formats and relative/absolute paths
#
# REQUIREMENTS:
#   - fzf (fuzzy finder)
#   - zed (editor)
#   - Standard POSIX shell utilities (awk, sed, sort, cut)

set -eu

# Read all input into a temp file
tmp=$(mktemp) || exit 1
trap 'rm -f "$tmp"' EXIT
cat >"$tmp"

# Extract unique file:line:col references with their line numbers
# Format: "line_number:file:line:col"
refs=$(awk '
    match($0, /([a-zA-Z_\/.][a-zA-Z0-9._\/-]*:[0-9]+:[0-9]+)/, m) {
        print NR ":" m[1]
    }
' "$tmp" | sort -t: -k2,2 -u | cut -d: -f1,2-)

# If no matches
if [ -z "$refs" ]; then
  echo "No file:line:column references found" >&2
  exit 1
fi

# Extract just the file:line:col for fzf list
file_refs=$(printf '%s\n' "$refs" | cut -d: -f2-)

# Save refs with line numbers for preview lookup
ref_file=$(mktemp)
printf '%s\n' "$refs" >"$ref_file"
trap 'rm -f "$tmp" "$ref_file"' EXIT

# Launch fzf
selected=$(printf '%s\n' "$file_refs" | fzf \
  --height=20 \
  --reverse \
  --prompt="Open in Zed: " \
  --preview="
        line_num=\$(awk -v ref={+} -F: '{
            split(\$0, a, \":\");
            file_part = substr(\$0, index(\$0, \":\") + 1);
            if (file_part == ref) { print a[1]; exit }
        }' '$ref_file');
        if [ -n \"\$line_num\" ]; then
            sed -n \"\${line_num},\$((line_num + 7))p\" '$tmp'
        fi
    " \
  --preview-window='right:60%:wrap' \
  --exit-0)

[ -z "$selected" ] && exit 0

$EDITOR "$selected"
