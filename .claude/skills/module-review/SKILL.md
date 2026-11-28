---
name: module-review
description: Review a toolkit module's change or release candidate against the kit's standards, clean paths and quality bar - performance, security (taint), the preferred way, and why. Use after each committed batch and before every release or Deck copy.
---

# Module review

Review a Jig Boltgrip's Toolkit module the same way every time. A script collects the facts; you judge them against the kit's docs and report findings with their sources.

## Read first

From the kit repository (`~/Developer/JigBoltgripToolkit`), the current versions:

- `docs/standards.md`: the rules, each with its evidence and how it is enforced.
- `docs/clean-paths.md`: what makes Blizzard's UI act without taint, measured (DECK), read in source (SRC) or unverified, and the traps.
- `docs/quality-bar.md`: the release checklist.
- `docs/decisions/README.md`: every choice made; never reopen one without new evidence.
- The module's own `AGENTS.md` and `docs/client-notes.md`.

## Steps

1. Collect the facts:

   ```sh
   ~/Developer/JigBoltgripToolkit/tools/review-collect.sh <module-root> [base-ref]
   ```

   Expected: the checks with their exit code, the changed files, and changed lines grouped by topic. A failing check is the first finding.

2. Judge each changed line the script groups, then the rest of the diff, on five questions. Cite the rule, decision or `file:line` for each answer:
   - **Correct:** does it do what the change says, in every state (none, one, several, the other faction, no data, in combat, under the Gamepad UI and with mouse and keyboard)?
   - **Secure:** does any Blizzard call, open, click or write start in our code? Match it to a clean-paths row. A DECK row is settled; an SRC or UNVERIFIED row needs its section E Deck test before release; a trap (section D) is a finding.
   - **Fast:** is per-row or per-redraw work cached, events used over timers, and the work timed in the working build?
   - **Preferred:** is there a Blizzard API, template, global string or established pattern that does this, and does a standards rule name one? A custom solution needs a stated reason.
   - **Why:** does each comment give the reason only, and do docs and records read in one imperative voice?

3. For a release, also walk `docs/quality-bar.md` line by line, marking each met, not met, or untested in game.

## Report

One table, most severe first. Never print the whole diff.

| # | File:line | Finding | Rule or source | Evidence | Fix |
|---|---|---|---|---|---|

- Evidence is a measurement, a source line or a check's output, never an impression. What has not been seen in game is "untested", with the smallest Deck or Mac test that would settle it.
- A finding outside the change is listed apart, as existing, not as part of this change.
- End with the verdict: ready, ready after the listed fixes, or blocked (by what).
