# 0044. The copy window opens unfocused on the gamepad

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: gamepad and taint

## Context

On the Deck the log window kept focus, so B could not close it.

## Decision

Under the Gamepad UI the copy window opens unfocused, so B closes it through UISpecialFrames.

## Reasons

- A focused edit box took B (Deck, 2026-11-27).

## Owner's words

- "may need to rethink the log, it doesn't work on controller and I had to manually close it"

## Rejected

- Leaving it focused.

## Versions

- JigBoltgripToolkit `87d6989` (MINOR 75)
- client 1.60.1 (71139)

## Tests

- Deck: retest pending.

## Reopen if

B still fails to close it.
