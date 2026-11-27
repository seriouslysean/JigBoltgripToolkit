# 0075 Key binding rows carry no search tag of ours

- Date: 2026-11-27
- Status: accepted (test pending)
- Scope: all modules
- Kind: gamepad and taint

## Context

On the owner's Mac (Buffulator 7858054, kit 83), typing in Blizzard's Options search raised ADDON_ACTION_FORBIDDEN for `IsUserOAuthed`, blamed on Buffulator (source=game), repeatedly. `C_Discord.IsUserOAuthed` runs in Social.lua's Discord setting predicates while search walks every category (Blizzard_SettingsDefinitions_Frame/Social.lua:290-338). The kit's key binding row added `GetBindingName(row.binding)` as a search tag from addon code; Blizzard's own Keybindings page reads binding names through `securecallfunction(GetBindingName, action)` (Keybindings.lua:204). Only modules with a key binding row have one (Buffulator, Tackletron, AutoOmniadjustor); Buffulator sorts first, which fits the blame. Lead from the Buffulator session; unproven.

## Decision

The kit's key binding row adds no search tag (MINOR 85). The binding stays findable on Blizzard's Keybindings page under the toolkit's header.

## Reasons

- Owner, via the Buffulator session: "Go, fix it now".

## Rejected

- Keeping the tag through a secure call: addon code cannot make Blizzard's securecallfunction result secure.

## Versions

- Kit MINOR 85.

## Tests

- Mac: with every module on 85, type in Options search (e.g. "nameplates", "discord"); pass is no ADDON_ACTION_FORBIDDEN and no blocked entry in the log. Pending.

## Reopen if

- The block persists on 85: the tag was not the cause; read the blocked entry's tainted fields.
