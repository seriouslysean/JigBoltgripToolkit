# 0086. Nothing names another addon as a source

- Date: 2026-11-28
- Status: accepted
- Scope: all modules
- Kind: process

## Context

Docs, decision records and comments across the toolkit and its modules cited other addons as the model for a pattern, as a comparison, or as the origin of a value. The rules asked for it: a comment named the Blizzard file or the addon it followed. The suite is unreleased, and its sources are public.

## Decision

Never name another addon as a source, model, pattern or comparison, in any tracked file or commit message. Patterns follow Blizzard's own code, cited by file. The evidence for a choice is Blizzard's UI source, the client's data, game text, and our own measurements and tests. Where none of those is the reason, state the rule and its reason in plain words.

Allowed, because none is a source for our design:

| What | Examples |
|---|---|
| Embedded libraries, with their licenses | LibStub, AceLocale, AceComm, CallbackHandler, ChatThrottleLib |
| Build and development tools | the BigWigs packager, busted, luacheck, ShellCheck, shfmt, hererocks |
| Game-data sites and lists | warcraft.wiki.gg, wago.tools, Wowhead, cmangos classic-db, the community listfile (wowdev/wow-listfile) |
| Compatibility at run time | a check that another addon is loaded; wording such as "sits beside other addons" or "another addon clears the value" |

## Reasons

- An unreleased suite whose sources name other addons reads as copied from them, and each name raises a license question that the code does not have.
- Blizzard's file is the evidence that lasts: it is what the client runs, it can be read at the cited line, and the client audit (0085) checks it after each update.
- A reason in our own words can be judged; "as that addon does" cannot.

## Rejected

- Naming other addons in docs only, never in comments: the docs are as public as the code.
- Review alone: the names had spread through six repositories under review.

## Versions

- Kit `MINOR` 86 (one comment in `JigBoltgripToolkit.lua`); every module's docs, comments and AGENTS.md the same day.

## Tests

- `tests/conformance.lua`, "docs and comments name no other addon as a source" (and `--voice`, a step of the kit's `scripts/check`): fails a tracked doc line or a comment that holds a phrase that cites another addon. The phrases are listed in that file; `Libs/`, license files, `THIRD-PARTY-NOTICES.md` and `tests/globalstrings.lua` are exempt.
- `tests/conformance.lua`, "no tracked file holds another addon's name" (and `--voice`): fails any tracked text file, code included, that holds a listed name. The list is kept as SHA-256 hashes of each name in lowercase, its words joined by one space, so the file names none; the plain list stays out of every repository. A line is split into words (runs of letters and digits), and each word and each run of two or three words parted only by spaces or hyphens is hashed and looked up. The hashes keep the names out of reading and search; a short name can be guessed, so they are not secret. Names that are ordinary English words in lowercase are left out and stay with review. A new name is added by hashing it the same way.
- A planted line holding a listed name failed the kit's `--voice` step and a module's conformance, in a doc and in code; both pass with the line removed.
- A planted doc line with a citing phrase failed the kit's check, and a planted Lua comment with one failed a module's; both pass with the lines removed. Compatibility wording ("another addon clears the value") passes.

## Reopen if

- A pattern has no Blizzard source, no game data and no measurement of ours behind it, and cannot be stated without naming where it came from.
