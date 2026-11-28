---
name: client-audit
description: Audit a WoW Forever client update across the kit and every module - new and removed API, new restrictions, deprecations, global strings, changed hook targets and moved source citations. Use on each client update and whenever Gethe/wow-ui-source's forever branch moves.
---

# Client audit

Audit each client update the same way every time. A script collects what Blizzard's source changed and where our code meets it; you judge each item against the source and the kit's docs, and report with sources.

## When

- Each Forever client update (a new build in `version.txt` on Gethe/wow-ui-source `forever`).
- Each new commit on that branch, even within one build: Blizzard's UI files change between builds too.

## Read first

From the kit repository (`~/Developer/JigBoltgripToolkit`), the current versions:

- `docs/client-notes.md`: the client facts, and "Audited source", the last audited commit.
- `docs/clean-paths.md`: the taint-free patterns and the Blizzard lines they rest on.
- `docs/standards.md`, "Conformance": what `tests/deprecated.lua` feeds.
- `docs/decisions/README.md`: never reopen a decision without new evidence.
- Each module's own `docs/client-notes.md`.

## Steps

1. Collect the facts:

   ```sh
   ~/Developer/JigBoltgripToolkit/tools/client-audit.sh -o reports/client-audit-<new build>.md [--strings] [old-ref [new-ref]]
   ```

   Expected: one report in five sections, in a few seconds. With no refs it runs from the recorded commit to `origin/forever`. `WOW_UI_SOURCE` names the source clone (default `${XDG_CACHE_HOME:-~/.cache}/wow-ui-source`, cloned when missing); `--strings` reads Ketho's global strings over the network. `reports/` is not tracked.

2. Read the report top down. Section 1 says how big the update is; sections 2 and 3 are what changed; section 4 is what of it we use; section 5 is what to check again in game.

3. Judge each row of section 4 and each section 3 change, citing the Blizzard `file:line` at the new ref for every answer:
   - **Calls:** a removed function is a break; a new argument, return or flag (`HasRestrictions`, `SecretArguments` tightened to `AllowedWhenUntainted`, `IsProtectedFunction`) is a break where our call meets it. Say which.
   - **Hooks:** for a target whose file changed, read the function at both refs: does it still run at the moment we rely on, with the same arguments? "Find by hand" rows are engine functions or set on a frame; check that they still exist.
   - **Citations:** fix the line numbers the report maps ("now 1783-1796"); a citation "inside a changed hunk" needs the cited code read again, and a clean-paths row resting on it goes back to SRC until a Deck test confirms it.
   - **Deprecations:** a name added to the list is a call conformance now rejects; a removed one is gone from the client or native now.
   - **New API:** note only what replaces something we do by hand or what a standards rule would prefer (Ethos 1 and 8).

4. Update the generated lists, never by hand, and run `scripts/check`:

   ```sh
   lua tools/deprecated.lua <source>/Interface/AddOns "<version, e.g. 1.60.1 (71139)>"
   lua tools/global-strings.lua <Ketho forever commit>
   ```

5. Fix the kit's own items in the kit. For each module, send one message to that module's session with its rows: the finding, the source line and the fix; never edit a module from the kit.

6. Move "Audited source" in `docs/client-notes.md` to the new commit and build, and commit it with the regenerated lists.

7. Each section 5 row stays as it is until the next Deck or Mac session measures it again on the new build; that session updates the note's build and date.

## Report

One table, breaks first. Never paste the whole report.

| # | Where we use it | What changed | Source at the new ref | Impact | Action |
|---|---|---|---|---|---|

- Impact is break, risk, citation only or none, from the source read at both refs, never an impression.
- Action names the owner: the kit, a module (with the message sent), or a Deck test (the smallest one).
- End with the commit range audited, the counts per section, and the new "Audited source" line.
