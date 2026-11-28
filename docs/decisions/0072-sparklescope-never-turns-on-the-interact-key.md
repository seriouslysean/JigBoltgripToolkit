# 0072. Sparklescope never turns on the Interact Key

- Date: 2026-11-27
- Status: accepted
- Scope: Sparklescope 6000
- Kind: game settings

## Context

On keyboard and mouse, sparkles need Enable Interact Key (`softTargetInteract` with its keyboard flag); with it off the game picks nothing. Blizzard's checkbox switches the value between Any and Gamepad (`Blizzard_SettingsDefinitions_Frame/Controls.lua:72-86`). A module could hold it as a temporary value, as Tackletron does while a pole is equipped (0050).

## Decision

Sparklescope never sets it. The options page says sparkles need it on with keyboard and mouse (0027), and the module reads the player's own value.

## Reasons

- Sparklescope would hold it whenever a keyboard player plays, not for a short task as Tackletron does, so it would stand in for the player's own choice in Blizzard's menu: the checkbox reads the temporary value, and a player who unticks it would have it set again.
- Blizzard shows a "no interact key assigned" tip when the value is above Gamepad and Interact has no binding (`Blizzard_Tutorials/Blizzard_Tutorials_Frame_Tutorials.lua:94-116`); hiding it means writing the saved `interactKeyWarningTutorial`, which the kit's game-settings rule forbids.

## Rejected

- A temporary value with a one-time line, as Sparklescope holds object plates.
- A temporary value plus an override binding of Interact to satisfy the tip: unverified that the tip's `GetBinding` sees override bindings.

## Versions

- client 1.60.1
- Sparklescope6000 d2d7ea7

## Tests

- In game, Mac, 2026-11-27, level 29 character, keyboard: Interact Key on, no Interact binding, `interactKeyWarningTutorial` reset to 0, relogged: no tip showed. The tutorial's load gating for this character was not read, so the tip's risk is not ruled out for every player.

## Reopen if

Players report keyboard sparkles missing because the key is off, or the tip is shown never to appear for a temporary value.
