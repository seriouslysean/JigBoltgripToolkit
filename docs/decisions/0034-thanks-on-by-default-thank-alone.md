# 0034. Thanks on by default, /thank alone

- Date: 2026-11-27
- Status: accepted
- Scope: Buffulator
- Kind: thanks

## Context

Thanks started off, as the toolkit says for anything that speaks for the player.

## Decision

Thank Players Who Buff You starts on with only `/thank` checked. Party and raid thanks start off.

## Reasons

- The owner's call overrides the toolkit default here.

## Owner's words

- "Buff pvp, and thank with the default thank emote should be the default"
- "Party should be off by default"

## Rejected

- Thanks off by default ("The thank needs to be off by default", 2026-11-26).

## Versions

- Buffulator `bcabf00` (schema 4 resets a saved off)
- client 1.60.1 (71139)

## Tests

- The Thanks specs run on the default since `bcabf00`, with no switch turned on by the spec: "thanks a player once when their buff lands, after the delay" (`tests/behavior_spec.lua`).

## Reopen if

Players find the default thanks unwelcome.
