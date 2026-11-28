# 0077 Map Pin closes the profession window before the map opens

- Date: 2026-11-27
- Status: accepted; mouse and keyboard to measure, Deck with decision 0068
- Scope: Recipe Vacuum
- Kind: gamepad and taint

## Context

With mouse and keyboard Map Pin opens the world map (decision 0068). Blizzard's panel layout gives the map the left slot and pushes the profession window right, and Recipe Vacuum's panel, beside that window, runs off the screen (owner's Mac screenshot, 2026-11-27).

## Decision

Before opening the map, Map Pin calls `C_TradeSkillUI.CloseTradeSkill()`. Blizzard's own `TRADE_SKILL_CLOSE` handler then hides the window (`Camelot/Blizzard_ProfessionsFrame.lua:128`), so no addon code calls `HideUIPanel`, which stays banned. On the overview tab that handler only refreshes the tabs and the window stays open (same lines).

## Reasons

- Owner, 2026-11-27: "can we close the profession tab? Any other way to handle this?"; chose closing over keeping the panel on screen or leaving it cut off.
- Pressing Map Pin means going there now; the map gets the screen.

## Rejected

- Keeping the panel on screen: it would cover part of the profession window, and it is layout of our own.
- `HideUIPanel(ProfessionsFrame)`: banned by conformance (standards, "Gamepad UI"); the client API needs no exception.

## Versions

- Recipe Vacuum: the commit that adds this record's reference in `RecipePanel.lua`.

## Tests

- Mac: Map Pin on a recipe with a place; the profession window closes, the map opens on the zone, nothing is blocked in the log. Pending.
- Deck: with decision 0068's test.

## Reopen if

- The close blocks or taints anything, or the owner wants the window kept.
