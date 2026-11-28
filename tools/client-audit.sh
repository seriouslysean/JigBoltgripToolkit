#!/usr/bin/env bash
# Audits a WoW Forever client update in one report, so every update is read the same way: what Blizzard's source
# changed between two forever commits, and where the kit and every module meet it (.claude/skills/client-audit).
#   tools/client-audit.sh [-o report.md] [--strings] [old-ref [new-ref]]
# old-ref defaults to the last audited commit (docs/client-notes.md, "Audited source"), new-ref to origin/forever.
# WOW_UI_SOURCE names a Gethe/wow-ui-source clone (default: the cache, cloned when missing); TOOLKIT_MODULES lists
# module roots (default: each folder beside the kit that embeds it). --strings reads Ketho's global strings online.
set -euo pipefail

kit=$(cd "$(dirname "$0")/.." && pwd)
[[ -d $HOME/.local/share/lua51/bin ]] && PATH="$HOME/.local/share/lua51/bin:$PATH"
lua=$(command -v lua5.1 || command -v lua)

out=/dev/stdout strings=0 refs=()
while (($#)); do
	case $1 in
	-o)
		out=$2
		shift
		;;
	--strings) strings=1 ;;
	*) refs+=("$1") ;;
	esac
	shift
done

src=${WOW_UI_SOURCE:-${XDG_CACHE_HOME:-$HOME/.cache}/wow-ui-source}
if [[ ! -d $src/.git ]]; then
	git clone -q --branch forever --single-branch https://github.com/Gethe/wow-ui-source.git "$src"
fi
recorded=$(grep -E '^- Last audited: ' "$kit/docs/client-notes.md" | grep -oE '[0-9a-f]{40}' || true)
from=${refs[0]:-$recorded}
to=${refs[1]:-origin/forever}
[[ -n $from ]] || {
	echo "no old ref given and none recorded in docs/client-notes.md" >&2
	exit 2
}
# A ref the clone lacks is fetched, all history at once when the clone is shallow; a default new ref is always fresh.
have() { git -C "$src" cat-file -e "$1^{commit}" 2>/dev/null; }
if ((${#refs[@]} < 2)) || ! have "$from" || ! have "$to"; then
	if [[ -f $src/.git/shallow ]]; then
		git -C "$src" fetch -q --unshallow origin forever
	else
		git -C "$src" fetch -q origin forever
	fi
fi
from=$(git -C "$src" rev-parse "$from^{commit}")
to=$(git -C "$src" rev-parse "$to^{commit}")

modules=()
if [[ -n ${TOOLKIT_MODULES:-} ]]; then
	read -ra modules <<<"$TOOLKIT_MODULES"
else
	for lib in "$kit"/../*/Libs/JigBoltgripToolkit/JigBoltgripToolkit.lua; do
		[[ -f $lib ]] && modules+=("$(cd "${lib%/Libs/*}" && pwd)")
	done
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
# Only the API docs and the deprecated addons are read as files; everything else comes from git.
extract() {
	local dirs
	mkdir -p "$tmp/$1"
	mapfile -t dirs < <(git -C "$src" ls-tree --name-only "$2" Interface/AddOns/ | grep '/Blizzard_Deprecated')
	git -C "$src" archive "$2" -- Interface/AddOns/Blizzard_APIDocumentationGenerated "${dirs[@]}" | tar -x -C "$tmp/$1"
}
extract old "$from"
extract new "$to"
version() { git -C "$src" show "$1:version.txt" 2>/dev/null | tr -d '\r\n' || echo unknown; }
label() { version "$1" | sed -E 's/^([0-9]+\.[0-9]+\.[0-9]+)\.([0-9]+)$/\1 (\2)/'; }
git -C "$src" diff --name-only "$from" "$to" >"$tmp/changed"

"$lua" "$kit/tools/deprecated.lua" "$tmp/new/Interface/AddOns" "$(label "$to")" "$tmp/deprecated.lua"
stringsArg=()
if ((strings)); then
	ketho=$(git ls-remote https://github.com/Ketho/BlizzardInterfaceResources.git refs/heads/forever | cut -f1)
	(cd "$kit" && "$lua" tools/global-strings.lua "$ketho" "$tmp/globalstrings.lua")
	stringsArg=("strings=$tmp/globalstrings.lua")
fi

{
	echo "# Client audit: $(label "$from") to $(label "$to")"
	echo
	echo "Gethe/wow-ui-source forever, \`$from\` to \`$to\`. Kit and modules: $(basename "$kit")$(printf ', %s' "${modules[@]##*/}")."
	echo
	echo "## 1. Source changes"
	echo
	echo "Client: $(version "$from") to $(version "$to"). Commits: $(git -C "$src" rev-list --count "$from..$to")."
	echo
	echo "| AddOn | Added | Modified | Deleted | Renamed |"
	echo "|---|---|---|---|---|"
	git -C "$src" diff --name-status "$from" "$to" -- Interface/AddOns | awk -F'\t' '
		{ split($NF, p, "/"); a = p[3]; k = substr($1, 1, 1); n[a, k]++; seen[a] = 1 }
		END { for (a in seen) printf "| %s | %d | %d | %d | %d |\n", a, n[a, "A"], n[a, "M"], n[a, "D"], n[a, "R"] }' | LC_ALL=C sort
	echo
	"$lua" "$kit/tools/client-audit.lua" "old=$tmp/old/Interface/AddOns" "new=$tmp/new/Interface/AddOns" "source=$src" \
		"from=$from" "to=$to" "changed=$tmp/changed" "kit=$kit" "deprecated=$tmp/deprecated.lua" "${stringsArg[@]}" "${modules[@]}"
} >"$out"
