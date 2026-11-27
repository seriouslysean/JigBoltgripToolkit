# 0056. Lures and Fishing food come from the client's data, by ID

- Date: 2026-11-23
- Status: accepted
- Scope: Tackletron
- Kind: data

## Context

No API says what a food's buff gives, and a food's use text cannot be matched across languages.

## Decision

The Fishing food table is built from Blizzard's data tables for build 1.60.1.71037 (wago.tools DB2). `SpellEffect` rows with the skill aura (30) on Fishing (356) give the Well Fed buff 1249521. The use spells that trigger it, through `ItemEffect` and `ItemXItemEffect`, give the items, and the levels come from `ItemSparse`. Bonuses are the amounts the owner's client printed for the same six items. The lure table was re-sourced from the client's tables. Things are identified by ID or game data and never by words in localized text.

## Reasons

- Locales differ, so only IDs and game data hold (rule in Tackletron `AGENTS.md`).
- The query and the open work to drop the tables are in `docs/data.md`.

## Owner's words

- "That doesn't work for locales, we need to use game data"
- Rule recorded 2026-11-23: identify by ID or game data, never by localized text.

## Rejected

- Finding food from its use text (`9a2034f`).

## Versions

- Tackletron `82d04c0`, `b92e884`, `c632cf2`, `952861b`

## Tests

- Specs "Fishing food above the character's level: no food square", "Fishing food in the bags: its square shows left of the lure's, and a click eats it".

## Reopen if

An API names a food's buff or a lure's bonus, so the tables can go.
