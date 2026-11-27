# 0075 Key binding rows carry no search tag of ours

- Date: 2026-11-27
- Status: accepted; not the cause (tested 2026-11-27)
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

## Result (2026-11-27)

Not the cause: with every module on MINOR 85 the owner's search still blocked `IsUserOAuthed`. The Mac's Logs/taint.log (15:15:43) names the real path: Blizzard builds its own Keybindings category at load and reads each binding's header with `_G[cat]` (Keybindings.lua:221, not securecall'd) and its name through GetBindingName (BindingUtil.lua:143). Any addon that sets BINDING_HEADER_ or BINDING_NAME_ globals taints the values Blizzard stores, and search later reads them: "Execution tainted by Buffulator while reading global BINDING_HEADER_JIGBOLTGRIPTOOLKIT", BINDING_NAME_CLICK BuffulatorBuffNext, TackletronButton, and another addon's own. The search-tag removal stays (it was redundant with Blizzard's own tags); the block is a Blizzard gap any addon with named bindings triggers. Found by the Buffulator session.
