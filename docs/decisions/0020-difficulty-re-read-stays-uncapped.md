# 0020. Difficulty re-read stays uncapped

- Date: 2026-11-27
- Status: accepted
- Scope: Recipe Vacuum
- Kind: data

## Context

After a skill change, recipes are asked for their difficulty again.

## Decision

A skill change is read again until every candidate answers. A recipe that never reports a difficulty would keep being re-read in 2 ms slices, accepted as a known risk.

## Reasons

- All 89 of Corvus's recipes answered (Deck, 2026-11-26).
- A cap was tried and reverted, since it broke the spec (0019).

## Rejected

- A give-up cap.

## Versions

- RecipeVacuum `ea0319d`
- client 1.60.1 (71139)

## Tests

- none yet

## Reopen if

A recipe that never reports a difficulty is seen in a log.
