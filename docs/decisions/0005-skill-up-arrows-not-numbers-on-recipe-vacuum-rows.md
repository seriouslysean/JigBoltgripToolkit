# 0005. Skill-up arrows, not numbers, on Recipe Vacuum rows

- Date: 2026-11-26
- Status: accepted
- Scope: Recipe Vacuum
- Kind: panel

## Context

Rows first showed the required skill number, colored by skill-up.

## Decision

Rows show Blizzard's skill-up arrows from `GetRecipeInfo().relativeDifficulty` and `canSkillUp`; the required skill is in the details pane; the list sorts by required skill.

## Reasons

- This matches the vanilla presentation.
- Corvus gave 0 mismatches against the seed, and `canSkillUp` was false at a 150 cap (Deck, 2026-11-26).

## Rejected

- A skill number on rows (`6367694`, `7a88221`).

## Versions

- RecipeVacuum `c7a5dc8`, `f8cfac5`
- client 1.60.1 (71139)

## Tests

- Spec: "a row shows the client's skill-up arrow and no number" (`tests/simulate_spec.lua`).
- Deck: passed on Corvus, 2026-11-26.

## Reopen if

The client's difficulty disagrees with what the trainer shows.
