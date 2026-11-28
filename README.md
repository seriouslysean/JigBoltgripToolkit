# Jig Boltgrip's Toolkit

The shared library behind Jig Boltgrip's Toolkit, a set of small WoW Forever addons. It is one Lua file that each addon embeds. It is not an addon on its own.

## Modules

| Module | What it does | Repository |
|---|---|---|
| Recipe Vacuum | Tracks the recipes you don't know yet, and where they come from | https://github.com/seriouslysean/RecipeVacuum |
| Tackletron | One key to fish | https://github.com/seriouslysean/Tackletron |
| Buffulator | Buffs players who need it and thanks those who buff you | https://github.com/seriouslysean/Buffulator |
| Omniadjustor | Disenchants, picks locks and reads scrolls from your bags with one key | https://github.com/seriouslysean/Omniadjustor |
| Sparklescope 6000 | Sparkles on the herb, ore, chest or fishing bobber the Interact Key has picked | https://github.com/seriouslysean/Sparklescope6000 |

None is released yet. Each module's README has the same short shape (what it is, the link back here, Install, License) and the same License section, `tests/readme-license.md`, which conformance compares word for word.

Standards shared by every module (code, data, resilience, performance, voice): [docs/standards.md](docs/standards.md). The checklist every module meets before a release: [docs/quality-bar.md](docs/quality-bar.md).

## What it gives a module

- One "Jig Boltgrip's Toolkit" category in Blizzard's Settings panel, with a page per installed module.
- Slash commands: `/boltgrip <module> <command>` and `/<module> <command>`, with a `help` command built from the module's command table.
- A Commands section and a Links section on each module's page, built from the same table and from the TOC's `X-Website` and `X-Curse-Project-ID` fields.
- A window with selectable text, for copying text out of the game.
- Moving a module to a newer kit: what changed, the call to use and what to delete ([docs/adopting.md](docs/adopting.md)).
- Sharing between players of one module (party, raid, guild and friends): the transport, probes, requests, limits and logging, with the module supplying only its row shape ([docs/sharing.md](docs/sharing.md)).
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
local module = toolkit:RegisterModule(addonName) -- the record NewModule made at file load, so a file can name the module before settings
-- The whole page is data: the kit builds every row, in one order, from Blizzard's controls.
toolkit:BuildOptions(module, savedTable, {
	{ heading = L["Thing Sources"], place = "sources", rows = {
		{ kind = "choice", key = "level", label = L["Thing Sources"], default = toolkit.SOURCE_LEVEL.FRIENDS,
			values = toolkit:SourceChoices({ self = L["Tracks only things you see for yourself."], friends = true,
				public = L["Also tracks things people link in chat."] }) },
	} },
	{ heading = L["Things"], place = "features", rows = {
		{ kind = "checkbox", key = "record", label = L["Record Things"], default = true, tooltip = L["Remembers the things you see."] },
	} },
})
toolkit:RegisterCommands(module, { -- the kit adds the "open the options" entry and help
	{ action = "go", description = L["Do the thing"], run = function() end },
})
toolkit:FinishModule(module)
```

Rows are never added by hand: the conformance check rejects it. Row kinds, fields and the section order are in [docs/standards.md](docs/standards.md), "Options". A command entry is `{ action, description, note, run, troubleshooting }`; entries marked `troubleshooting = true` show in the chat help only.

## Translations

How a module is translated, and the tool that reads the game's own translated terms: [docs/translations.md](docs/translations.md).

## Versions

Every module carries its own copy, and LibStub keeps the newest one loaded. Any change to the file raises `MINOR`, and every module then takes the identical new file.

## Checks

`scripts/check` runs every check: Lua 5.1 syntax, ShellCheck and shfmt, file modes (the execute bit is for scripts only), luacheck, the comment rule on the library, the voice and other-addon checks, and the specs (busted). The pre-push hook and CI run it too; turn the hook on once per clone with `git config core.hooksPath .githooks`.

Each module runs the kit's shared check from its embedded copy, `Libs/JigBoltgripToolkit/tests/module-check.sh`, through its own `scripts/check`, and its CI calls the shared workflow `.github/workflows/module-ci.yml` at a pinned commit. A new module starts from `skeleton/` (see below).

## License

GPL-3.0; the full text is in `LICENSE`. As section 7 of that license allows, three terms are added: a modified version must be marked as changed and must not be presented as the original (7c); the authors' names may not be used to publicize a modified version (7d); and no trademark right is granted to the name Jig Boltgrip's Toolkit or to the name of any of its addons (7e).
