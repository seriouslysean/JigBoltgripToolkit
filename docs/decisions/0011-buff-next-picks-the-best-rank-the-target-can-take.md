# 0011. Buff Next picks the best rank the target can take

- Date: 2026-11-26
- Status: accepted
- Scope: Buffulator
- Kind: buffing

## Context

A top-rank buff fails on low-level players.

## Decision

The highest rank you know whose learn level is no more than 10 above theirs. A player whose level is unknown is passed over, never offered the top rank.

## Reasons

- Seen in play: a level 29 druid's top Mark of the Wild fails on players under 10 (Buffulator `docs/data.md`).

## Rejected

- Always the top rank.

## Versions

- Buffulator `93cd6d2`
- client 1.60.1 (71139)

## Tests

- Spec: "buffs a level 9 player outside the group at the rank they can take", "passes over a player whose level is not known yet" (`tests/behavior_spec.lua`).

## Reopen if

A cast at the picked rank fails in play.
