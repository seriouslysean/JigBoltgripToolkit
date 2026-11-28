# 0058. Tips are Tackletron's own frames, said once

- Date: 2026-11-23
- Status: accepted
- Scope: Tackletron
- Kind: panel

## Context

A first pole takes over F, and a fight with the pole on needs a note.

## Decision

The first time a pole is in hand, one Blizzard-style tutorial tip on the button names the key that fishes, so F is never taken over unannounced. It stays until the player closes it, presses the key or right-clicks to open the options. A fight with the pole in hand shows one tip on the leave arrow while combat lasts. Once the weapons have gone back mid-fight the tip stops for good. Tips come from Tackletron's own frames, never the shared tip pool, show a frame later so they measure right, and skip a pad.

## Reasons

- Tip frames are not protected, so they may show and hide in combat.
- The wording follows the game's own tips ("Right-click to favorite a toy. Favorite toys are pinned to the first page.", the Toy Box).

## Rejected

- Calls to Blizzard's shared tips (the kit's conformance check bans them, `4405683`).

## Versions

- Tackletron `9177968`, `b90a15e`, `856eb90`, `2eed1d5`, `4405683`

## Tests

- Specs "first pole: the tip names F", "combat starts with the pole on: a tip on the leave arrow says so", "weapons back in combat: the tip goes, and is marked as learned", "tips come from Tackletron's own frames, never Blizzard's shared pool".

## Reopen if

The first-press tip hides text the player needs.
