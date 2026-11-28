# 0055. One lure per escape, and Use Lures steps Always, Auto, Never

- Date: 2026-11-23
- Status: accepted
- Scope: Tackletron
- Kind: fishing gear

## Context

A fish that gets away says a lure may help, but a lure should not be pushed all day.

## Decision

The zones where a fish got away since the last lure went on are kept for the session. One lure answers it. The mark clears when a lure lands on the pole, so after it wears off nothing is suggested until a fish gets away again, and an escape with a lure on marks the zone for the next one. The key applies a lure by the Use Lures setting, always, when a fish gets away, or never. Right-click on the lure square steps through them, shown the way the pet bar shows autocast, with corner marks while the key may use it and circling lights for always. The middle stop is named Auto and explained in its tooltip. The change is said in chat.

## Reasons

- The pet bar's autocast overlay is the pattern for a setting a button toggles (`PetActionBar.lua`).

## Rejected

- A worn-off lure replaced at once (`0342354`).

## Versions

- Tackletron `0342354`, `1aec96c`, `d46ebb3`, `fa6a2cb`, `a44740e`, `4f96cdc`, `8818b42`

## Tests

- Specs "a second escape before the lure goes on says nothing more", "right-click on the lure steps never to always, lights on, and says so in chat", "lure worn off, no fish got away since: the key casts and nothing is highlighted", "lures set to always: the key applies one with no fish lost".

## Reopen if

Players ask for lures on a timer, or the client says what a lure's length is.
