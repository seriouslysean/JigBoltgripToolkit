# Jig Boltgrip's Toolkit

The shared library behind Jig Boltgrip's Toolkit, a set of small WoW Forever addons. It is one Lua file that each addon embeds. It is not an addon on its own.

Modules: [Recipe Vacuum](https://github.com/seriouslysean/RecipeVacuum).

Standards shared by every module (code, data, resilience, performance, voice): [docs/standards.md](docs/standards.md). The checklist every module meets before a release: [docs/quality-bar.md](docs/quality-bar.md).

## What it gives a module

- One "Jig Boltgrip's Toolkit" category in Blizzard's Settings panel, with a page per installed module.
- Slash commands: `/boltgrip <module> <command>` and `/<module> <command>`, with a `help` command built from the module's command table.
- A Commands section and a Links section on each module's page, built from the same table and from the TOC's `X-Website` and `X-Curse-Project-ID` fields.
- A window with selectable text, for copying text out of the game.
- A shared key binding header, `BINDING_HEADER_JIGBOLTGRIPTOOLKIT`.

## Using it in a module

Embed `LibStub` and this file, and load them before the module's own files:

```
Libs\LibStub\LibStub.lua
Libs\JigBoltgripToolkit\JigBoltgripToolkit.lua
```

Set `## Category: Jig Boltgrip's Toolkit` in the TOC. Then, once saved variables have loaded:

```lua
local toolkit = LibStub("JigBoltgripToolkit-1.0")
-- The class (a RAID_CLASS_COLORS key) colors the module's name in chat.
local module = toolkit:RegisterModule(addonName, "DRUID")
-- The whole page is data: the kit builds every row, in one order, from Blizzard's controls.
toolkit:BuildOptions(module, savedTable, {
	{ heading = L["Thing Sources"], place = "sources", rows = {
		{ kind = "cards", key = "level", label = L["Thing Sources"], default = toolkit.SOURCE_LEVEL.FRIENDS,
			values = toolkit:SourceCards({ self = L["Tracks only things you see for yourself."], friends = true,
				public = L["Also tracks things people link in chat."] }) },
	} },
	{ heading = L["Things"], place = "features", rows = {
		{ kind = "checkbox", key = "record", label = L["Record Things"], default = true, tooltip = L["Remembers the things you see."] },
	} },
})
toolkit:RegisterCommands(module, "mymodule", {
	{ action = "", description = L["Open the options"], run = function() end },
})
toolkit:FinishModule(module)
```

Rows are never added by hand: the conformance check rejects it. Row kinds, fields and the section order are in [docs/standards.md](docs/standards.md), "Options". A command entry is `{ action, description, note, run, troubleshooting }`; entries marked `troubleshooting = true` show in the chat help only.

## Translations

How a module is translated, and the tool that reads the game's own translated terms: [docs/translations.md](docs/translations.md).

## Versions

Every module carries its own copy, and LibStub keeps the newest one loaded. Any change to the file raises `MINOR`, and every module then takes the identical new file.

## Checks

The specs in `tests/*_spec.lua` run on [busted](https://lunarmodules.github.io/busted/) under LuaJIT (`luarocks --lua-version 5.1 install busted`). `.busted` sets the folder and the file pattern.

```sh
luac -p JigBoltgripToolkit.lua
luacheck .
JBT_LIBSTUB=<path to LibStub.lua> busted
```

Each module also runs the kit's conformance check on its own files, from its embedded copy: `luajit Libs/JigBoltgripToolkit/tests/conformance.lua .`

## License

GPL-3.0. See `LICENSE`.
