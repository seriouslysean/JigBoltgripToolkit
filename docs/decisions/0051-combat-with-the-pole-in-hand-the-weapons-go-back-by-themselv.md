# 0051. Combat with the pole in hand: the weapons go back by themselves, the key is the fallback

- Date: 2026-11-25
- Status: accepted
- Scope: Tackletron
- Kind: safety

## Context

A fight can start with the pole in hand, or the pole can go on mid-fight, and insecure code cannot change the button or hide the row once combat starts.

## Decision

Combat has three states. `armed` is a fight with a pole equipped, whether it started that way or the pole went on during it. `combat` is a fight without one, and `peace` is everything else. Just before combat lockdown, on `PLAYER_REGEN_DISABLED`, Tackletron puts the weapons back with no key press and hides the row. Not while the line is out, where the swap would cut the cast; there the fishing key swaps. If the swap cannot happen, the button's next press puts the weapons back, from the default key too, and then every key has its usual job. The secure owner holds the hook override and drops it in combat, which only restricted code can do; Tackletron puts it back after combat. Swap Automatically is a setting, on by default.

## Reasons

- The game lets an addon equip weapons until combat lockdown begins, "Combat lockdown begins after the PLAYER_REGEN_DISABLED event fires" (warcraft.wiki.gg, `API_InCombatLockdown`).
- The `item:ID` form worked in game, 2026-11-26.
- A state driver is how restricted code follows combat: `RegisterStateDriver` (`Blizzard_RestrictedAddOnEnvironment/SecureStateDriver.lua:26`).

## Rejected

- Leaving the row up until the fight ends (seen in play, 2026-11-25).

## Versions

- Tackletron `1192256`, `ec73028`, `8d87ef5`, `a647d9f`, `f07199c`, `4dc1001`, `09d8a60`, `da1fad7`

## Tests

- Specs "combat starts: the button's macro puts the weapons back, and F presses it", "a pole put on mid-fight: the swap is armed and the row shows", "combat starts with the pole on: the weapons are equipped by the addon, the row hides, no tip shows", "line out as combat starts: no automatic swap, the key does it", "a pole put on mid-fight: the row shows once the fight ends".
- Seen working in game 2026-11-26.

## Reopen if

Blizzard lets addon code hide a secure frame in combat, or stops allowing the equip before lockdown.
