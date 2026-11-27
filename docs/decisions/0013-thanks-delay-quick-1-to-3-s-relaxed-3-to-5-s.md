# 0013. Thanks delay: Quick 1 to 3 s, Relaxed 3 to 5 s

- Date: 2026-11-26
- Status: accepted
- Scope: Buffulator
- Kind: thanks

## Context

An instant emote reads as a bot.

## Decision

Two delays, each with jitter: Quick 1 to 3 s and Relaxed 3 to 5 s.

## Reasons

- A person needs about 0.2 to 0.5 s to react and choose, and about 1.2 s to type `/ty` and Enter (sources in Buffulator `docs/emotes.md`).

## Owner's words

- "I also want to think about a jitter in response times"
- "We may only need two"
- "Quick 1-3 is good, relaxed should be 3-5 probably"

## Rejected

- A fixed delay.
- Three choices.

## Versions

- client 1.60.1 (71139)

## Tests

- Spec: "thanks a player once when their buff lands, after the delay" (`tests/behavior_spec.lua`).

## Reopen if

Players read the delays as unnatural.
