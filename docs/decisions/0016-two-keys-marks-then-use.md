# 0016. Two keys: marks, then use

- Date: 2026-11-26
- Status: accepted
- Scope: AutoOmniadjustor
- Kind: keys and marks

## Context

Finding which bag items an action applies to.

## Decision

The marks key shows every item the use key can act on, and the use key acts on the selected item. On a controller, with the bags open and no key of the player's own, the left stick press is the marks key and the right stick press the use key.

## Reasons

- Acting by hover is friction; two keys need none.
- The gamepad bags leave both stick presses free (AutoOmniadjustor `docs/client-notes.md`).

## Rejected

- Hover-to-reveal, as another addon does it.

## Versions

- AutoOmniadjustor `74e119e` (keys and stick defaults), `adc5296` (stick keys dropped in combat by a secure state owner)
- client 1.60.1 (71139)

## Tests

- Offline: conformance "a keybinding row has no note or tooltip" passes (`scripts/check` at `4e2dd83`).
- Deck: pending; the module is off until its taint fix lands.

## Reopen if

The stick press overrides lose to the gamepad bags' focus on the Deck.
