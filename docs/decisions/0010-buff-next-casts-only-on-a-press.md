# 0010. Buff Next casts only on a press

- Date: 2026-11-26
- Status: accepted
- Scope: Buffulator
- Kind: buffing

## Context

Buffing other players could be automated.

## Decision

Buff Next casts only when the player presses it. Group members, you and your target are cast on directly; anyone else through `/targetexact`, the cast, then `/cleartarget`.

## Reasons

- Buff Next is purely additive: it takes over nothing and never gets in the way.
- Casting needs a hardware press; the game refuses a cast on a timer or an event (Buffulator `docs/client-notes.md`).

## Rejected

- Casting on a timer or an event.

## Versions

- Buffulator `eaeab70` (one character macro, rewritten out of combat)
- Buffulator `7c830f5` (the secure button, key binding and `/click` macro)
- client 1.60.1 (71139)

## Tests

- Spec: "buffs a level 9 player outside the group at the rank they can take", "gives Thorns to a group member you target" (`tests/behavior_spec.lua`).

## Reopen if

n/a; the game rule decides it.
