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

- The gamepad bags leave both stick presses free (AutoOmniadjustor `docs/client-notes.md`).

## Owner's words

- "With bags open I want a key to show me all eligible items"
- "2: L3 toggles, R3 acts"
- "Molina makes me hover and I hate it"

## Rejected

- Hover-to-reveal, as another addon does it.

## Versions

- client 1.60.1 (71139)

## Tests

- Deck: pending; the module is off until its taint fix lands.

## Reopen if

The stick press overrides lose to the gamepad bags' focus on the Deck.
