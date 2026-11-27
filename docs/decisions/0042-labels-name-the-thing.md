# 0042. Labels name the thing

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: options pages

## Context

Some labels started with a verb, some named the thing.

## Decision

A label names the thing; a verb only when the thing alone would be unclear. Existing verb labels stay. A Blizzard heading may hold the module's own feature where the player would look for it ("Combat").

## Reasons

- Blizzard uses both shapes (`docs/options.md`, "Labels" 3).

## Owner's words

- "Simple, dry, kiss, adding a verb does nothing but add cognitive load here"
- "Keep 'Combat'"

## Rejected

- A verb-first rule.
- Renaming "Combat" to "Weapons".

## Versions

- JigBoltgripToolkit `55318d0`

## Tests

- Conformance checks the label text rules (`tests/conformance.lua`); the noun rule itself is review only.

## Reopen if

n/a
