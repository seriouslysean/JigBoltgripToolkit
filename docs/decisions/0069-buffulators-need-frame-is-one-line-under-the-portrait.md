# 0069. Buffulator's need frame is one line under the portrait

- Date: 2026-11-27
- Status: accepted, check in game pending
- Scope: Buffulator
- Kind: look

## Context

The need frame, shown only while someone needs a buff of yours and you are out of combat, was two lines under the portrait: your buff's icon and the player's name, then the buff's name, or "Buffed you" when that player had just buffed you. The owner asked whether a pet would cover it, and for a slimmer one-line form that still shows both who to buff and with what, and who just buffed you and with what, the second going away after a while.

## Decision

One line under the portrait, below whatever Blizzard stacks there (pet frame, class bars, totems in `PlayerBottomManagedFrameContainer`): your buff's icon, then the player's name in class color. When that player just buffed you, their buff's icon shows first, desaturated and dimmed, for 30 seconds after it landed, then goes. The frame still shows only when there is a buff to give.

## Reasons

- The pet frame does not cover it: `PetFrame` inherits `PlayerBottomManagedFrameTemplate` and sits in the portrait's managed container (`Blizzard_UnitFrame/Mainline/PetFrame.xml`, Gethe/wow-ui-source `forever`), and the frame anchors below that container whenever it is shown and taller than empty.
- The incoming icon explains the order Buff Next already uses (`ns.NextNeed` in `Buffs.lua` puts a player who buffed you first), without a second row that would show when nothing needs a press.
- One line is half the old height; the icon already names the buff to give, so the buff's name line carried little.

## Owner's words

"under my portrait is ok"; "are there more slim versions we can make that are one line?"; "we need name and what to buff, or name and what they buffed us with (that eventually fades away since it's temporary)"; choosing the one-line form with the extra icon: "Yeah that seems good to me, less friction".

## Rejected

- Above the action bar, on the Buff Next button only (no tooltip hover on a gamepad), or a position the player moves (no Edit Mode for addons without a third-party library; a kit-wide job).
- Two stacked rows, one for the buff to give and one for the buff received: shows more often and is two lines tall.
- One row that switches to the incoming buff for a few seconds: hides the next player while it shows.
- The buff to give only, with nothing for incoming buffs.

## Versions

- Buffulator after kit MINOR 82: `NeedFrame.lua`; `Thanks.lua` keeps the incoming buff's spell in `ns.buffedBy`.

## Tests

- `tests/behavior_spec.lua`, "shows the buff a player gave you beside them for 30 seconds": the icon shows the incoming spell, then hides after 30 s (fails with the time limit removed, checked by mutation).
- In game: Buffulator `docs/client-notes.md` checks 11 and 20.

## Reopen if

30 seconds proves too short or too long in play, or the dimmed icon cannot be told apart from your own buff's icon on the Deck's screen.
