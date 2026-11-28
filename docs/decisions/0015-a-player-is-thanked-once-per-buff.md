# 0015. A player is thanked once per buff

- Date: 2026-11-26
- Status: accepted
- Scope: Buffulator
- Kind: thanks

## Context

A rebuff could be thanked every time.

## Decision

A player counts as thanked until the buff they gave runs out; your death clears it.

## Reasons

- A timed repeat was still too often.

## Rejected

- Once a minute.

## Versions

- Buffulator `c1dbcb8` (thanked until the buff runs out; death clears it)
- Buffulator `22fc97a` (thanked only once the emote went out)
- client 1.60.1 (71139)

## Tests

- Spec: "thanks a player's next buff when the game refused the last thanks" (`tests/behavior_spec.lua`).

## Reopen if

Players expect a thanks on every rebuff.
