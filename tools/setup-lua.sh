#!/usr/bin/env bash
# Builds the Lua the checks run on: PUC Lua 5.1, the client's Lua and CI's, with the same busted and
# luacheck as .github/workflows/module-ci.yml. Homebrew ships no Lua 5.1, so hererocks builds it into one
# folder that the checks put first on PATH.
#   tools/setup-lua.sh
set -euo pipefail

dir=$HOME/.local/share/lua51
command -v hererocks >/dev/null || uv tool install hererocks
hererocks "$dir" --lua 5.1 --luarocks latest
"$dir/bin/luarocks" install --tree "$dir" luacheck 1.2.0-1
"$dir/bin/luarocks" install --tree "$dir" busted 2.3.0-1
"$dir/bin/lua" -e 'assert(_VERSION == "Lua 5.1" and not jit)' && echo "Lua 5.1 ready in $dir"
