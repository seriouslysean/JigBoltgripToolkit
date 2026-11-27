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

## Owner's words

- "once a minute is still annoying imo"
- "Individuals should get a time equivalent to their buff time applied, unless the player dies or something?"

## Rejected

- Once a minute.

## Versions

- Buffulator `8c17ddb` (thanked until the buff runs out; death clears it)
- Buffulator `8e8afdc` (thanked only once the emote went out)
- client 1.60.1 (71139)

## Tests

- Spec: "thanks a player's next buff when the game refused the last thanks" (`tests/behavior_spec.lua`).

## Reopen if

Players expect a thanks on every rebuff.
