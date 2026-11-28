# 0050. The hook waits for the soft-targeted bobber, on temporary CVars

- Date: 2026-11-23
- Status: accepted
- Scope: Tackletron
- Kind: game settings

## Context

The Interact Key action reaches the bobber only with soft interact on, and Enable Interact Key is off by default.

## Decision

While the line is out, the key hooks only when the bobber is soft-targeted and is inert before. While a pole is equipped, soft interact is on for keyboard and mouse, and while the line is out Blizzard's interact icon for game objects marks the bobber. Both are temporary CVars (`C_CVar.SetTempCVar`), never saved, and removed with `RemoveTempCVar`. Another addon that clears the value gets it set again. In controller mode Tackletron leaves the soft-target CVars alone and sets them again on a mode switch.

## Reasons

- Blizzard's gamepad code sets and removes temporary CVars the same way (`Blizzard_Gamepad/Core.lua`), so a crash or disconnect leaves nothing changed and players need not touch a setting.
- Soft interact is the Interact Key, which the controller already turns on whatever Enable Interact Key says (`docs/client-notes.md`).

## Rejected

- Saving the CVars; changing a setting for the player.

## Versions

- Tackletron `d0dd9d3`, `b533cff`, `94cf80d`, `f33b9e5`
- Tackletron `2d931c5` (comment moved here)

## Tests

- Specs "interact on while the pole is on, bobber icon for the cast, all temporary values gone with the pole", "another addon clears the temporary interact value: Tackletron sets it again", "switching to keyboard mode with the pole on: soft interact comes back at once".

## Reopen if

Casts land out of Interact Key range often enough to matter.
