# Adopting MINOR 57

For a module that embeds an older kit: what changed, the call to use, what to delete. Recipe Vacuum's commit for this MINOR is the worked example (`git show` its "adopt kit MINOR 57" commit). Do the steps in this order; run `scripts/check` after each. Behavior for the player stays the same, and an old call keeps working until you move it (a `-1.0` call never changes what it takes or returns).

| # | Change | Call | Delete in the module |
|---|---|---|---|
| 1 | One module record, one `Say`, `Trace` with format arguments | `ns.module = toolkit:NewModule(addonName, class, command)`; `toolkit:Say(ns.module, line, ...)`; `toolkit:Trace(ns.module, "fmt %s", x)` | `ns.device`, `ns.logModule`, the local `device` stand-ins in `Troubleshooting.lua`, `ns.title`, `ns.Say`, `ns.Trace`, `ns.Log` (use `toolkit:Print`), every `if ns.module` guard, `ns.module = ...` in `Settings.lua` |
| 2 | Secret values and GUIDs | `toolkit.Readable(v)`, `toolkit.Describe(v)`, `toolkit.GUID(guid)` | bare `issecretvalue` tests, `ns.Readable`, `ns.Hidden`, `Describe`/`Text`/`Is` helpers, hand-made `strsplit("-", guid)` plus `tonumber` |
| 3 | Gamepad check | `toolkit.IsGamepadUI()` | `GamepadStyle`, unguarded `InputUtil.IsGamepadUIEnabled()` |
| 4 | Options command and slash word | `toolkit:RegisterCommands(module, entries)` | the `{ action = "" }` entry, `L["Open the options"]` in `Locales/enUS.lua`, the slash word argument (pass it once as `NewModule`'s third argument when it is not the addon's name in lower case, as Sparklescope's `sparklescope`) |
| 5 | Say once | `toolkit:SayOnce(ns.module, db, "soundTold", ns.voice.sound)` | the `if not db.xTold then db.xTold = true; Say(...)` blocks |
| 6 | Working build starts itself | `toolkit:StartLog(...)` calls `EnableWorkingBuild` | every `EnableWorkingBuild()` call in the module |
| 7 | Saved data | `db = toolkit:LoadSaved(ns.module, addonName .. "DB", spec)` | the schema loop, the defaults loop, the newer-save guard |
| 8 | Event frames | `toolkit:EventFrame(ns.module, handlers, options)` | every `CreateFrame("Frame")` made to listen, its `RegisterEvent` lines, its `SetScript("OnEvent")`, every `WatchEvents` block |

## 1. Module record, Say, Trace

Create the record at the top of `Core.lua`, once:

```lua
ns.module = toolkit:NewModule(addonName, "DRUID")      -- command defaults to the addon's name in lower case
```

`RegisterModule(addonName)` in `Settings.lua` adopts the same table and adds the category, so `ns.module` is the one handle from file load on (the class argument to `RegisterModule` is not needed). Change every `ns.device`, `ns.logModule` and local `device` to `ns.module`.

`Say` takes the `Voice.lua` entry and the format arguments. A first argument of 1 picks the entry's `reportOne` when it has one:

```lua
-- before
ns.Say(intake.noise, (count == 1 and intake.reportOne or intake.report):format(count, name))
-- after
toolkit:Say(ns.module, ns.voice.intake, count, name)
```

An entry written `{ noise, report }` positionally becomes `{ noise = ..., report = ... }`. The old `Say(module, noise, report)` still works. `Trace` formats only while logging, as Recipe Vacuum's wrapper did, so call it directly and delete the wrapper: `toolkit:Trace(ns.module, "SEEN %s closed", window)`. A trace with no arguments is written as is, so a literal `%` in it is fine.

## 2. Secret values and GUIDs

```lua
-- before
local unitType, _, _, _, _, npcID = strsplit("-", guid and not issecretvalue(guid) and guid or "")
npcID = tonumber(npcID)
-- after
local unitType, npcID = toolkit.GUID(guid)   -- nothing when the GUID is nil or hidden; npcID is a number or nil
```

`Readable(v)` is false for nil and for a hidden value, so `if v and not issecretvalue(v)` becomes `if Readable(v)`. Note the difference: a nil that was passed on before is now skipped.

## 4. Commands

Delete the `{ action = "", ... run = OpenOptions }` entry and its locale key, and call `RegisterCommands(module, entries)`. The kit inserts the entry first; a table that has its own `""` entry keeps it. A table other files add to (`ns.commands = ns.commands or {}` in `Troubleshooting.lua`) works as before.

## 7. Saved data

```lua
EventUtil.ContinueOnAddOnLoaded(addonName, function()
	local db = toolkit:LoadSaved(ns.module, addonName .. "DB", {
		schema = SCHEMA, migrations = migrations, defaults = defaults,
		legacy = function(saved) return saved.sources and 1 end,   -- only for a save with no schema number
	})
```

`migrations[step](db, characterDb)` run for each step above the saved number, in order, and the number is saved after each. `character = "GlobalName"` and `characterDefaults` load a second, per-character table (Tackletron) and pass it as the second argument; steps that only touch the character table go in `characterMigrations[step](characterDb)`, which each character runs from its own saved number. Delete the module's own loop. Two behaviors to know:

- A save from a newer build is left alone: the module runs on an empty copy, the saved variable keeps its schema number, and the player gets one line (the kit's, or `newer = "..."`). Tackletron and Buffulator rewrote the number downward in that case; this closes it.
- The saved variable's name comes from the addon's name (`addonName .. "DB"`), because the conformance rule keeps the addon's name out of strings. Keep post-load cleanup (seed overlap, layers) in the module, after the call.

## 8. Event frames

One style: a table keyed by event, each value `function(...)` taking the event's own arguments.

```lua
-- before: frame, registrations, an if-chain on event, a debug block
local frame = CreateFrame("Frame")
frame:RegisterEvent("LOOT_CLOSED") ...
frame:SetScript("OnEvent", function(_, event, ...) if event == "LOOT_CLOSED" then ... end end)
--@debug@
toolkit:WatchEvents(ns.module, frame)
--@end-debug@
-- after
toolkit:EventFrame(ns.module, { LOOT_CLOSED = function() ... end })
```

- Several events with one body: put the same function under each key. When the body needs the event's name, build the handlers in a loop and capture it: `for _, event in ipairs(NAMES) do handlers[event] = function(...) Body(event, ...) end end`.
- `options.later = { EVENT = true }` for an event the module registers and unregisters while something waits (`frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")`); keep the returned frame for that. Declare the frame `local frame` above the functions that use it and assign it where the handlers exist.
- `options.unit = { UNIT_AURA = "player" }` for a unit event.
- A frame that is also a window (has a parent, textures, other scripts) is not an event frame: move its events to an `EventFrame` and register them from its `OnShow`/`OnHide`, as Recipe Vacuum's place menu does with `GLOBAL_MOUSE_DOWN`.
- Per-event timing in a debug block wraps the handlers table before the call (`for event, handler in pairs(handlers) do handlers[event] = function(...) ... end end`).

The kit counts events for the working-build log inside its own dispatcher. `lib:WatchEvents` hooks `OnEvent`, and a later `SetScript("OnEvent")` drops the hook: Tackletron called it before `SetScript` and logged no `EVENT` lines, and Recipe Vacuum's detail-item frame had the same order. Conformance now fails a module file that contains `SetScript("OnEvent"` or `WatchEvents(`, so delete all of them, debug blocks included. The kit's own share frame is counted the same way.

## Check

`scripts/check` in the module, only `ok` lines. Copy the kit's `JigBoltgripToolkit.lua` and the five files in `tests/` byte for byte into `Libs/JigBoltgripToolkit` first. Update the module's specs that replaced `ns.Say`, `ns.Trace` or a frame's `script`: replace `ns.toolkit` on the spec's namespace with a proxy (`setmetatable({ Say = ... }, { __index = ns.toolkit })`), as Recipe Vacuum's `tests/simulate_spec.lua` does.
