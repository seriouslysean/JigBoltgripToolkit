# 0054. A needed lure is a steady highlight, and the button stays Fishing's icon

- Date: 2026-11-23
- Status: accepted
- Scope: Tackletron
- Kind: look

## Context

The animated spell alert on a suggested lure was loud, and the cast button's icon needs one steady meaning.

## Decision

A needed lure is marked on its own square with the template's steady `NewActionTexture` frame, which Blizzard shows on a newly added action (`ActionButton.lua`, `UpdateHighlightMark`). It is marked whether or not the key applies lures; the setting only decides that. The fishing button is always Fishing's icon and unmarked, and the line being out shows only on the cast bar below.

## Reasons

- Blizzard uses the same steady mark for a newly added action.

## Owner's words

- "The glow is pretty annoying though, can it just be highlighted"
- "we need the bauble to glow when it's needed, and then auto apply based on the setting"
- The owner chose "Nothing" for how the button shows the line being out (2026-11-23).

## Rejected

- The animated spell alert glow (`acbb8a1`).
- A bobber icon or a checked button while the line is out (`4933d75`, then `f1e9b5b`).

## Versions

- Tackletron `acbb8a1`, `769b43c`, `f1e9b5b`

## Tests

- Specs "after a fish got away: the lure's square is highlighted and the key applies the lure, then the pole", "lures set to never: the key casts; the lure's square stays highlighted".

## Reopen if

Blizzard retires `NewActionTexture`.
