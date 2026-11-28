# 0077 The panel steps aside while the map holds the profession window's slot

- Date: 2026-11-27
- Status: accepted; mouse and keyboard to measure, Deck with decision 0068
- Scope: Recipe Vacuum
- Kind: gamepad and taint

## Context

With mouse and keyboard Map Pin opens the world map (decision 0068). Blizzard's panel layout gives the map the left slot and pushes the profession window to the center, and Recipe Vacuum's panel, beside that window, ran off the screen (owner's Mac screenshot, 2026-11-27). The panel already stepped aside when another window took the center slot, as Looking For Group does.

## Decision

The panel steps aside whenever the profession window is not in the left slot or another window holds the center (`UpdateVisibility`, `Panel.lua`, read after Blizzard's `UpdateUIPanelPositions`). Map Pin leaves the profession window open; when the map closes, the window returns to the left slot and the panel with it.

## Reasons

- Owner, 2026-11-27, on Looking For Group: "Group finde rsubsumes our window, that's a decent pattern"; chose the panel stepping aside over closing the profession window.
- One rule for every window that shares the profession window's slots, from Blizzard's own layout; no call into Blizzard's windows.

## Rejected

- Closing the profession window first through `C_TradeSkillUI.CloseTradeSkill()` (this decision's first version, the same day): it worked, but the player loses their place in the profession.
- Keeping the panel on screen: it would cover part of the profession window.

## Versions

- Recipe Vacuum: the commit that names this decision in `Panel.lua`'s `UpdateVisibility`.

## Tests

- Mac: Map Pin on a recipe with a place; the map opens on the zone, the profession window stays open beside it, our panel is hidden; close the map and the panel returns. Pending.
- Deck: with decision 0068's test.

## Reopen if

- The panel fails to return when the map closes, or the owner wants the window closed.
