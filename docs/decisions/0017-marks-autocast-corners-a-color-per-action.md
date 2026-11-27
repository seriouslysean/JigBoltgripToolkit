# 0017. Marks: autocast corners, a color per action

- Date: 2026-11-26
- Status: accepted
- Scope: AutoOmniadjustor
- Kind: keys and marks

## Context

Marked items need to show which action applies.

## Decision

Corners on every usable item, circling lights on the selected one. Disenchant uses the epic purple, Pick Lock and keys the rogue color, Comprehend Scroll the mage color.

## Reasons

- The pet bar's autocast look is Blizzard's own pattern for "this acts".

## Owner's words

- "Maybe a slightly different color per thing"

## Rejected

- One color for all.

## Versions

- AutoOmniadjustor `74e119e` (`Marks.lua`, `AutoCastOverlayTemplate`), `adc5296` (cached actions, two-item redraw)
- client 1.60.1 (71139)

## Tests

- none yet
- Deck: pending; the module is off.

## Reopen if

The open questions on color-blind players and on purple against epic borders (the Grok and Fable reviews) are decided.
