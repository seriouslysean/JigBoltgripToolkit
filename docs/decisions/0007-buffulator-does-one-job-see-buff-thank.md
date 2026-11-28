# 0007. Buffulator does one job: see, buff, thank

- Date: 2026-11-26
- Status: accepted
- Scope: Buffulator
- Kind: scope

## Context

A way to see and return buffs that fits the game's UI was wanted.

## Decision

A line naming who needs a buff of yours, one press that buffs them at the rank they can take, and an emote for players who buff you. Nothing else.

## Reasons

- The three asks: see who needs a buff and buff them back in a way that fits the game, cast the highest rank each player can take, and thank with an emote.

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

A job is added.
