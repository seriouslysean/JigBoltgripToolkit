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

- Local printing and tint samples (`cc6c860`).

## Versions

- Tackletron `90ca2b0`, `0b3bff5`, `b73200f`, `a5e8628`, `100e40b`, `1940efa`, `ec73028`, `8baaaa1`
- kit MINOR 9, 18

## Tests

- Specs "a fish got away: chat says a lure goes on next", "combat starts with the pole on: chat says so once", "other sounds lowered: said the first time only".

## Reopen if

A line repeats and annoys; 0043 and 0063 say what happens then.
