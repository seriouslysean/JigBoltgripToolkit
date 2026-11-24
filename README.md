# Jig Boltgrip's Toolkit

The shared library behind Jig Boltgrip's Toolkit, a set of small WoW Forever addons. It is one Lua file that each addon embeds. It is not an addon on its own.

Modules: [Recipe Vacuum](https://github.com/seriouslysean/RecipeVacuum).

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
local module = toolkit:RegisterModule(addonName)
-- add rows to module.category and module.layout with Blizzard's Settings functions
toolkit:RegisterCommands(module, "mymodule", {
	{ action = "", description = "Open the options", run = function() end },
})
toolkit:FinishModule(module)
```

A command entry is `{ action, description, run, troubleshooting }`. Entries marked `troubleshooting = true` show in the chat help only.

## Versions

Every module carries its own copy, and LibStub keeps the newest one loaded. Any change to the file raises `MINOR`, and every module then takes the identical new file.

## Checks

```sh
luac -p JigBoltgripToolkit.lua
luacheck .
luajit tests/loadorder.lua JigBoltgripToolkit.lua <path to LibStub.lua>
```

## License

GPL-3.0. See `LICENSE`.
