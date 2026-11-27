# 0007. Buffulator does one job: see, buff, thank

- Date: 2026-11-26
- Status: accepted
- Scope: Buffulator
- Kind: scope

## Context

The owner wanted a way to see and return buffs that fits the game.

## Decision

A line naming who needs a buff of yours, one press that buffs them at the rank they can take, and an emote for players who buff you. Nothing else.

## Reasons

- The owner's three asks, listed below.

## Owner's words

- "I need a way to know who needs a buff and to buff back that fits in with wow's ui/ux"
- "Can we auto rank to the highest a person is allowed to get?"
- "an emote to thank is fine"
- "Create it, my list only"

## Rejected

- Any feature beyond the three.

## Versions

- Buffulator `0113c99` (first build: the who-needs line, the buff key with rank picking, the thanks emote)
- Buffulator `9e21089` (renamed)
- client 1.60.1 (71139)

## Tests

- Specs, one per job: "names on the line the player the macro buffs", "buffs a level 9 player outside the group at the rank they can take", "thanks a player once when their buff lands, after the delay" (`tests/behavior_spec.lua`).
- Seen in game: the thanks emote from the timer (Buffulator `cb118f2`, docs/client-notes.md).

## Reopen if

The owner adds a job.
