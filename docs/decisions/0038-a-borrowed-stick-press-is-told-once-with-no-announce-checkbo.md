# 0038. A borrowed stick press is told once, with no Announce checkbox

- Date: 2026-11-27
- Status: accepted
- Scope: Omniadjustor
- Kind: chat

## Context

The module borrows L3 and R3 without telling the player.

## Decision

One line, once ever, per borrowed stick press.

## Reasons

- The toolkit's Game settings rule asks for one line the first time a module changes something the player didn't set; once-ever lines need no Announce checkbox (0043).

## Rejected

- No line.

## Versions

- AutoOmniadjustor `798ccdd`, `d9343c0`
- client 1.60.1 (71139)

## Tests

- Offline: conformance passes both lines' voice checks (noise with no end mark, report beats ending "!") (`scripts/check` at `d9343c0`).
- Deck: pending; the module is off.

## Reopen if

The line repeats in play.
