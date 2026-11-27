# 0014. Many buffs get one thanks

- Date: 2026-11-26
- Status: accepted
- Scope: Buffulator
- Kind: thanks

## Context

Several players can buff you at once.

## Decision

Each new buff restarts the wait, up to 10 s after the first. One player gets the emote aimed at them; two or more get one emote at nobody, with the same random pick.

## Reasons

- A run of emotes reads as spam (Buffulator `docs/emotes.md`).

## Owner's words

- "If we get multiples in N time do a generic non targets emote?"
- "buffs within n time reset the timer to thank, then you hit everyone with a thanks"
- "We emote to a specific unit, and without a selection it just happens"

## Rejected

- A cap on thanks ("I don't know about a cap, that feels weird").
- Preferring `/thank` for groups ("That's not for you to decide").

## Versions

- client 1.60.1 (71139)

## Tests

- none yet

## Reopen if

The 10 s limit is wrong in a busy hub (a guess to check).
