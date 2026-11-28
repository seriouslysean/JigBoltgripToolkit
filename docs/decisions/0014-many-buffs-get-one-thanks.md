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

## Rejected

- A cap on thanks ("I don't know about a cap, that feels weird").
- Preferring `/thank` for groups ("That's not for you to decide").

## Versions

- Buffulator `2beb4b5` (one emote at nobody for several players)
- Buffulator `bf094dd` (each buff restarts the wait, at most 10 s)
- client 1.60.1 (71139)

## Tests

- No spec for the shared thanks.
- Not yet seen in a busy hub; the 10 s limit is a guess to check there.

## Reopen if

The 10 s limit is wrong in a busy hub (a guess to check).
