# 0038. A borrowed stick press is told once, with no Announce checkbox

- Date: 2026-11-27
- Status: accepted
- Scope: AutoOmniadjustor
- Kind: chat

## Context

The module borrows L3 and R3 without telling the player.

## Decision

One line, once ever, per borrowed stick press.

## Reasons

- The toolkit's Game settings rule asks for one line the first time a module changes something the player didn't set; once-ever lines need no Announce checkbox (0043).

## Owner's words

- "Keep the draft"

## Rejected

- No line.

## Versions

- AutoOmniadjustor `adc5296`, `f43f5b1`
- client 1.60.1 (71139)

## Tests

- none yet

## Reopen if

The line repeats in play.
