# 0076. Buffulator's buffs go to everyone, each with a switch

- Date: 2026-11-27
- Status: accepted
- Scope: Buffulator
- Kind: buffing

## Context

Buffulator offered every buff it knew to anyone missing it, Thorns only to your group's tanks and your target. A druid has Mark of the Wild and Thorns, but not everyone needs both, so each buff gets a switch with logical defaults.

## Decision

Every buff goes to anyone missing it. Thorns goes to you, your group's tanks and your target. The options page has one checkbox per buff your class casts, all on by default, labeled with the spell's own name. No per-class rule and no per-class grid.

## Reasons

- Forever's own stat tooltips say Intellect raises weapon skill gain for warriors and rogues (`WARRIOR_INTELLECT_TOOLTIP`, `ROGUE_INTELLECT_TOOLTIP`) and Spirit raises health and mana regeneration for everyone (`SPIRIT_TOOLTIP`), so no buff is wasted on a class.
- Thorns adds threat, which healers and damage dealers do not want (vanilla wiki, "Druid tactics", read through a search summary; unverified in game).
- One checkbox per buff is the shape a Forever druid buff addon uses, and checkboxes are the gamepad-safe control (kit `docs/options.md`). A per-class grid, as another addon has, is too many d-pad stops.

## Rejected

- Arcane Intellect and Divine Spirit to mana users only, with a checkbox for warriors and rogues.
- The research's table: also Shadow Protection on your target only and off by default.
- A "group only" switch.

## Versions

- Buffulator after kit MINOR 85: `Buffs.lua` (`Allowed`), `Settings.lua` (`BuffRows`).

## Tests

- `tests/behavior_spec.lua`: "offers Thorns to yourself" and "offers no buff the player turned off" (each fails with its rule removed, checked by mutation).

## Reopen if

Players report a buff as unwanted on some class, or Thorns on yourself pulls threat you did not want.
