# Jig Boltgrip's Toolkit library

One Lua file, `JigBoltgripToolkit.lua`, embedded by every toolkit addon through LibStub (`JigBoltgripToolkit-1.0`). Client: WoW Forever 1.60.1 (Interface 16001). Blizzard's UI source for this client: [Gethe/wow-ui-source, `forever` branch](https://github.com/Gethe/wow-ui-source/tree/forever).

How every toolkit addon is written, this library included: [docs/standards.md](docs/standards.md). The checklist each addon meets before a release: [docs/quality-bar.md](docs/quality-bar.md). Every choice across the toolkit and its modules, one file each with dates, cited reasons, versions and tests: [docs/decisions/](docs/decisions/README.md); module sessions add theirs there.

## Rules

- Any change to the file raises `MINOR`. Every addon then takes the identical file; copies never differ at the same `MINOR`.
- A newer copy can load after an older one has modules and commands registered. State lives on the library table (`lib.modules`, `lib.commands`) and is kept with `lib.x = lib.x or {}`; behavior that older registrations rely on goes in methods, so it runs the newest code.
- Blizzard's templates, Settings initializers, global strings and chat colors only. Mark any copied value with the file it came from.
- The only globals are the slash commands, the binding header and one named frame (see `.luacheckrc`).
- Comments say why, briefly.

## Checks

Run before every commit; see `README.md`, "Checks". `luacheck` comes from LuaRocks, `luajit` from Homebrew; both match the client's Lua 5.1.
