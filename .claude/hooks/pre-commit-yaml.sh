#!/usr/bin/env bash
# Pre-commit YAML syntax guard for Claude Code.
# Invoked via .claude/settings.json PreToolUse hook with if: "Bash(git commit*)"
# Exits 0 if no staged YAML or all staged YAML parses cleanly; exits 2 to block
# the git commit when any staged .yaml/.yml file fails yaml.safe_load_all.

set -u

cd "${CLAUDE_PROJECT_DIR:-$(pwd)}" 2>/dev/null || true

staged=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null | grep -E '\.(yaml|yml)$' || true)
[ -z "$staged" ] && exit 0

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

failed=0
while IFS= read -r f; do
  [ -z "$f" ] && continue
  if ! python3 -c "import sys,yaml
# Use compose_all — parses YAML structure but does not resolve constructors,
# so ESPHome/HA custom tags like !include don't fail the syntax check.
try:
    list(yaml.compose_all(open(sys.argv[1])))
except yaml.YAMLError as e:
    print(e, file=sys.stderr); sys.exit(1)" "$f" 2>"$tmp"; then
    echo "YAML parse error in $f:" >&2
    cat "$tmp" >&2
    failed=1
  fi
done <<< "$staged"

if [ "$failed" -ne 0 ]; then
  echo "Commit blocked: fix YAML syntax above and re-stage." >&2
  exit 2
fi

exit 0
