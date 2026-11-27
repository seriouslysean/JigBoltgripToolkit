# 0035. No thanks while away or stealthed

- Date: 2026-11-27
- Status: accepted
- Scope: Buffulator
- Kind: thanks

## Context

A delayed thanks could go out while AFK or give away a stealthed druid.

## Decision

A thanks is dropped while you are AFK or stealthed. Combat still thanks.

## Reasons

- An emote reaches everyone in range; stealth does not hide chat (unverified on Forever).

## Owner's words

- "Combat seems ok to me, no afk, stealth seems ok but better to avoid it"

## Rejected

- A setting for it.

## Versions

- Buffulator `bb440df`
- client 1.60.1 (71139)

## Tests

- Specs: "drops a waiting thanks when you go away or stealth", "still thanks in combat" (`tests/behavior_spec.lua`).
- Deck: pending.

## Reopen if

A stealthed emote proves hidden from others on Forever.
