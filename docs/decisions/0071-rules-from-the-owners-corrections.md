# 0071 Rules from repeated corrections

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: process

## Context

A read of every correction from 2026-11-25 to 11-27 found 197 friction items in 16 themes: 65 product bugs the checks missed (gamepad and taint 31, layout 10, detection 10, performance 9), 28 layout corrections by guess, 25 unverified claims or misread premises, 15 explanations that did not explain, 7 test-protocol slips (one, "press every Run", turned logging off). Most themes already had a rule in session memory that sat past the index's load limit and never loaded.

## Decision

Adopted as worded after three separate reviews reached consensus (all four proposals adopted, three with changes):
- P1, quality-bar.md "Proven": the gate before any Deck copy.
- P2, standards.md "Side panels": measure live, diff by script, stop on the second same-kind correction.
- P3 and P4, standards.md "Working in a session": read data first, restate, explain in game terms, the test-step protocol, and write the rule on the first costly correction.

## Reasons

- Friction repeats when the rules that answer it never load; a full read of the corrections finds the themes, and separate reviews keep the wording honest.
- The rules live in kit text every module's AGENTS.md loads, not only in memory (module sessions drifted, #297, #461).

## Rejected

- A Deck-side sweep and timing table as the gate (they are measured on the Deck, so the gate uses what runs before the copy).
- A "cite Blizzard's file" clause in the test protocol (all three: already in Ethos 1 and the quality bar).

## Versions

- Kit docs: this commit. Session memory index trimmed under its load limit the same day.

## Tests

- None: process rules. Read against the next friction pass.

## Reopen if

- A later friction read shows a theme recurring despite these rules.
