# 0057. Chat lines are a noise and a report, once where they repeat

- Date: 2026-11-24
- Status: accepted
- Scope: Tackletron
- Kind: chat

## Context

Tackletron talks in the toolkit's device voice, and some lines would repeat.

## Decision

Every line is the library's `Say` with a noise that has no end mark, then a report whose beats end in "!". Lines live in `Voice.lua`. A line that says what the next press does is said once when the mark is new, and the combat line once per combat. The first time other sounds are lowered, one line says so and where to turn it off.

## Reasons

- The toolkit's `docs/standards.md`, "Voice", sets the shape.

## Rejected

- Local printing and tint samples (`e40d121`).

## Versions

- Tackletron `aca2a08`, `f0c2236`, `3877a0a`, `c7beb9b`, `b44ed5a`, `b8090fc`, `5fe0807`, `9f17d8a`
- kit MINOR 9, 18

## Tests

- Specs "a fish got away: chat says a lure goes on next", "combat starts with the pole on: chat says so once", "other sounds lowered: said the first time only".

## Reopen if

A line repeats and annoys; 0043 and 0063 say what happens then.
