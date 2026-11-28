#!/usr/bin/env bash
# Collects what a review reads, so the judging starts from facts: the checks, the changed files, and every changed line
# that touches Blizzard's UI, timers, voiced lines or protected frames (docs/clean-paths.md, standards.md).
#   tools/review-collect.sh <module-root> [base-ref]   (base defaults to the upstream branch, else HEAD~1)
set -uo pipefail

root=${1:?module root}
cd "$root" || exit 2
base=${2:-$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || echo HEAD~1)}

echo "# Review facts: $(basename "$PWD") $(git rev-parse --short HEAD) against $base"
echo
echo "## Checks"
if [[ -x scripts/check ]]; then
	scripts/check 2>&1 | grep -E '^(ok|FAIL|SKIP)'
	echo "exit ${PIPESTATUS[0]}"
fi
echo
echo "## Changed files"
git diff --stat "$base" -- . ':!Libs' | tail -n 50
echo
# Each pattern names what the review checks it against.
patterns=(
	'(ShowUIPanel|HideUIPanel|ToggleFrame|Toggle[A-Z][A-Za-z]*|Open[A-Z][A-Za-z]*|Close[A-Z][A-Za-z]*)\(:open or close a Blizzard window (clean-paths A, D)'
	'SecureActionButtonTemplate|SetAttribute|RegisterForClicks|PreClick|PostClick:secure button (clean-paths B, combat rule 0083)'
	'PLAYER_REGEN_(DISABLED|ENABLED)|InCombatLockdown:combat handling (0083)'
	'hooksecurefunc|HookScript|SetScript:hooks and scripts (standards "Code")'
	'C_Timer|OnUpdate|RunNextFrame:timers; events first (standards "Performance")'
	'SmartNavigation|SetNav:gamepad navigation (standards "Gamepad UI")'
	'toolkit:Say|voice\.|L\["[A-Z][^"]*!"\]:voiced lines (standards "Voice", 0084)'
	'SetUserWaypoint|SuperTrack|SLASH_[A-Z]+1:map and slash commands (clean-paths C)'
)
echo "## Changed lines by topic"
for entry in "${patterns[@]}"; do
	pattern=${entry%%:*}
	topic=${entry#*:}
	hits=$(git diff -U0 "$base" -- '*.lua' ':!Libs' | grep -E '^\+[^+]' | grep -E "$pattern" || true)
	[[ -z $hits ]] && continue
	echo "### $topic"
	echo "$hits" | head -n 40
	echo
done
