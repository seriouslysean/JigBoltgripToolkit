# 0079. Sparklescope says a line when it learns an unknown chest

- Date: 2026-11-27
- Status: accepted
- Scope: Sparklescope 6000
- Kind: chat

## Context

Sparklescope said one line, once: the object plates line on keyboard. Chests on its shipped list sparkle from the start; a chest on no list is learned when the player opens it, which is rare.

## Decision

When an opened chest was on no list, found or shared, Sparklescope says "chirps. Unknown container logged! Added to the lens array!" It can repeat, so it sits behind a Show Chat Alerts checkbox, on by default, in Chest Sources (0043). No first-run greeting: no module has one, and the plates line is the only setting change to tell.

## Reasons

- The device noticing a new object is what a gadget would report (owner).
- A repeating line gets one Chat Alerts checkbox (0043).

## Owner's words

- "Is there like a first time turning it on message? The new chest seems nice to have since it's registering it and a bot would notice"

## Rejected

- No new lines (the assistant's recommendation).
- A first-run greeting on login.

## Versions

- Sparklescope6000 5bf567b

## Tests

- scripts/check passes; not yet heard in game.

## Reopen if

The line shows for chests the player already sees sparkle, or players find it noisy.
