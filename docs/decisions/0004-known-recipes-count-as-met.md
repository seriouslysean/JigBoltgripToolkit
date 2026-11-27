# 0004. Known recipes count as met

- Date: 2026-11-26
- Status: accepted
- Scope: Recipe Vacuum
- Kind: data

## Context

A recipe the account already knows has no source of its own until one is seen.

## Decision

A recipe the account knows counts as discovered, with nothing shared. Shipped data shows only at the Public level.

## Reasons

- Knowing a recipe proves the player came across it (RecipeVacuum `docs/data.md`).

## Owner's words

- "If I know 75 recipes from the trainer ... Me knowing them means public doesn't matter, it's assumed since I learned it"

## Rejected

- Backfilling known recipes from shipped trainer data below the Public level.

## Versions

- RecipeVacuum `fac4789`
- client 1.60.1 (71139)

## Tests

- none yet (no spec names this rule)

## Reopen if

Known recipes are found to show sources the player never met.
