# 0025. The sparkle is fireflies

- Date: 2026-11-27
- Status: accepted
- Scope: Sparklescope 6000
- Kind: look

## Context

The effect is drawn in a frame over the picked object's nameplate, not in the world.

## Decision

The world's fireflies (file 190731), two copies, slowed.

## Reasons

- Anything that should sit on the object slides off it as the camera turns; drifting fireflies hide that (Sparklescope6000 `docs/development.md`, "Effects").

## Rejected

- Eleven other small effects.
- The game's loot glitter (`particles/lootfx.m2`).

## Versions

- Sparklescope6000 `74f2f48`
- client 1.60.1 (71139)

## Tests

- Spec: "shows on a picked herb for a herbalist" (`tests/learn_spec.lua`).
- Deck: fireflies seen, 2026-11-27.

## Reopen if

An addon can draw on an object in the world, or read the camera's tilt.
