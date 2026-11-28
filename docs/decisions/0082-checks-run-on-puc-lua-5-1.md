# 0082. Checks run on PUC Lua 5.1

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: process

## Context

The Mac ran the specs under LuaJIT (the local busted's interpreter) and syntax through `luajit -bl`; CI runs PUC Lua 5.1. LuaJIT's `string.format` turns `nil` into "nil" for `%s` where PUC Lua 5.1, like the client, raises an error. RecipeVacuum b524bf7 passed every local check and failed CI: a spec's profession stand-in had no name. The kit's stand-ins also answered `IsInInstance` with one value where the client gives two, which only PUC Lua 5.1 exposed.

## Decision

Run every check on PUC Lua 5.1, the client's Lua and CI's: syntax through Lua 5.1's `luac -p`, conformance and specs on its `lua` (`busted --lua`). `scripts/check` and `tests/module-check.sh` refuse to run on any other interpreter and name the fix. `tools/setup-lua.sh` builds it on a machine with hererocks into `~/.local/share/lua51`, with CI's luacheck 1.2.0 and busted 2.3.0; the checks put that folder first on PATH.

## Reasons

- One interpreter locally and in CI: a check that passes at home passes in CI.
- PUC Lua 5.1 refuses what the client refuses; LuaJIT accepts more and hides bugs.
- Homebrew ships no Lua 5.1; hererocks builds PUC Lua and LuaRocks into one folder, the usual way to pin a Lua version per machine.

## Rejected

- Keeping LuaJIT locally and relying on CI: failures surface after the push.
- A Lua 5.1 container per run: slower, and CI already pins the versions this matches.

## Versions

- Kit `scripts/check`, `tests/module-check.sh`, `tests/stubs.lua` (`IsInInstance`, zone texts), `tools/setup-lua.sh`; every module takes the new `tests/module-check.sh` and `tests/stubs.lua`.
- `.github/workflows/module-ci.yml` no longer installs LuaJIT, which no check used (2026-11-28).

## Tests

- The guard: `HOME=/nonexistent PATH=/opt/homebrew/bin:/usr/bin:/bin scripts/check` exits 1 with the setup message.
- A spec stand-in without `professionName` (RecipeVacuum before f7154b7) fails the local specs, as it failed CI.

## Reopen if

- The client's Lua changes from 5.1.
