# 0069 Rules from the owner's corrections

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: process

## Context

A read of every owner message from 2026-11-25 to 11-27 (reports/owner-friction-2026-11-27.md, untracked) found 197 friction items in 16 themes: 65 product bugs the checks missed (gamepad and taint 31, layout 10, detection 10, performance 9), 28 layout corrections by guess, 25 unverified claims or misread premises, 15 explanations that did not explain, 7 test-protocol slips (one, "press every Run", turned logging off). Most themes already had a rule in the assistant's memory that sat past the index's load limit and never loaded.

## Decision

Adopted, as worded by the consensus of Fable, Astra and Grok (each reviewed the four proposals separately; all four adopted, three with changes):
- P1, quality-bar.md "Proven": the gate before any Deck copy.
- P2, standards.md "Side panels": measure live, diff by script, stop on the second same-kind correction.
- P3 and P4, standards.md "Working with the owner": read data first, restate, explain in game terms, the test-step protocol, and write the rule on the first costly correction.

## Reasons

- Owner: "I want a subagent to go through all friction I've commented on, all my corrections, bugs, specificity and come back with a list we can use to adjust our rules and documentation"; "Have astra and grok and fable group concensus first"; "Adopt all as worded".
- The rules live in kit text every module's AGENTS.md loads, not only in memory (Astra and Grok: module sessions drifted, #297, #461).

## Rejected

- A Deck-side sweep and timing table as the gate (Fable, Astra: they are measured on the Deck, so the gate uses what runs before the copy).
- A "cite Blizzard's file" clause in the test protocol (all three: already in Ethos 1 and the quality bar).

## Versions

- Kit docs: this commit. Assistant memory index trimmed under its load limit the same day.

## Tests

- None: process rules. Read against the next owner-friction pass.

## Reopen if

- A later friction read shows a theme recurring despite these rules.
