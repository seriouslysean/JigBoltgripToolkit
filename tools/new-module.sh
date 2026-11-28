#!/usr/bin/env bash
# Starts a new toolkit module from skeleton/: the smallest addon that passes every shared check, with the
# kit embedded, the pre-push hook on and CI calling the shared workflow at this kit's commit.
#   tools/new-module.sh <Addon> "<Title>" <command> "<one sentence on what it does>" <new folder>
#   tools/new-module.sh Tackletron "Tackletron" tackletron "One key to fish." ../Tackletron
set -euo pipefail
[[ $# -eq 5 ]] || {
	echo 'usage: tools/new-module.sh <Addon> "<Title>" <command> "<one sentence>" <new folder>' >&2
	exit 2
}
kit=$(cd "$(dirname "$0")/.." && pwd)
target=$5
[[ ! -e $target ]] || {
	echo "new-module: $target already exists" >&2
	exit 1
}
# Ace3 at the commit every module embeds (docs/standards.md, "Versions").
ACE3_COMMIT=075bafb435f950f940e10c620510b3bd66ec9695

cp -R "$kit/skeleton" "$target"
cd "$target"
mv __ADDON__.toc "$1.toc"
cat AGENTS.md.head "$kit/tests/agents-opening.md" >AGENTS.md
rm AGENTS.md.head
cat "$kit/tests/readme-license.md" >>README.md
ADDON=$1 TITLE=$2 COMMAND=$3 NOTES=$4 KIT_COMMIT=$(git -C "$kit" rev-parse HEAD) \
	find . -type f -exec perl -pi -e 's/__ADDON__/$ENV{ADDON}/g; s/__TITLE__/$ENV{TITLE}/g;
		s/__COMMAND__/$ENV{COMMAND}/g; s/__NOTES__/$ENV{NOTES}/g; s/__KIT_COMMIT__/$ENV{KIT_COMMIT}/g' {} +

mkdir -p Libs/JigBoltgripToolkit/tests Libs/LibStub Libs/AceLocale-3.0 .githooks
cp "$kit/JigBoltgripToolkit.lua" Libs/JigBoltgripToolkit/
cp "$kit"/tests/{stubs.lua,conformance.lua,module-check.sh,deploy-deck.sh,agents-opening.md,readme-license.md,deprecated.lua,globalstrings.lua} Libs/JigBoltgripToolkit/tests/
cp "$kit/tests/LibStub.lua" Libs/LibStub/
cp "$kit/.githooks/pre-push" .githooks/
ace=$(mktemp -d)
git -C "$ace" init -q
git -C "$ace" fetch -q --depth 1 https://github.com/WoWUIDev/Ace3.git "$ACE3_COMMIT"
git -C "$ace" show FETCH_HEAD:AceLocale-3.0/AceLocale-3.0.lua >Libs/AceLocale-3.0/AceLocale-3.0.lua
git -C "$ace" show FETCH_HEAD:LICENSE.txt >Libs/Ace3-LICENSE.txt
rm -rf "$ace"

git init -q
git config core.hooksPath .githooks
git add -A
# The index holds the execute bit for the scripts and nothing else, whatever the folder's modes become.
git update-index --chmod=+x scripts/check scripts/deploy-deck .githooks/pre-push Libs/JigBoltgripToolkit/tests/module-check.sh Libs/JigBoltgripToolkit/tests/deploy-deck.sh
scripts/check
echo "new-module: $target is ready; commit it, then add the GitHub repository when the owner says so."
echo "new-module: once it is symlinked into the game's AddOns folder, and only then: git -C $target config core.fileMode false"
