# 0052. The leave arrow puts the weapons back, and the addon remembers them

- Date: 2026-11-23
- Status: accepted
- Scope: Tackletron
- Kind: panel

## Context

A fishing pole replaces the weapons, and the player needs a way back however the pole went on.

## Decision

Blizzard's red leave arrow (the vehicle and taxi button, same size, textures and highlight) sits beside the fishing button. It is secure, so its click can equip. The addon remembers the weapons in hand whenever no pole is, so the arrow works when the pole went on by the key or by hand. The arrow is centered on the button and anchored to the button's frame. It also works with the line out, where it stops the cast first, and a mount-up puts the weapons back since a pad cannot press the arrow. With no remembered weapons left in the bags there is no swap, and the arrow only dismisses the row.

## Reasons

- A protected frame cannot anchor to a texture such as the button's icon ("Cannot anchor protected frames to regions"), so the arrow anchors to the frame.
- The vehicle leave button is the model for size, textures and highlight (`VehicleLeaveButton.xml`).

## Owner's words

- "The x is weird in the icon" (the owner chose "Leave-vehicle arrow", 2026-11-23)
- "open a frame and on close will the gear again"
- "It's not aligned" (owner's screenshot)

## Rejected

- An X on the fishing button (`2b8803b`).
- Lining up the bottoms, which left the smaller arrow sitting low.

## Versions

- Tackletron `2b8803b`, `9e8bc29`, `960d921`, `ba08df6`, `b3a145c`, `f99c8b0`

## Tests

- Specs "close after a hand equip: sword and shield come back", "close is ready before any click, for combat", "close with the line out: the cast stops first", "remembered weapons gone from the bags: no swap, so the leave arrow dismisses the row".

## Reopen if

Blizzard changes the leave button or its anchoring rules.
