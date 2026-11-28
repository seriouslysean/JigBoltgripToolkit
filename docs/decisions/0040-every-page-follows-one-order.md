# 0040. Every page follows one order

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: options pages

## Context

Module pages ordered their sections differently.

## Decision

Sources, features, game settings, Keybindings, Commands, Working Build. The kit sorts a Blizzard section headed `SETTINGS_KEYBINDINGS_LABEL` after the others.

## Reasons

- The addons read as one person's work, so they fit together and configure alike.
- No written addon convention exists; Blizzard puts addon key bindings on its own Keybindings page near the bottom (warcraft.wiki.gg, "Bindings.xml"; WoWInterface thread 296612).

## Rejected

- Keybindings right after Sources.

## Versions

- JigBoltgripToolkit `df63d17` (MINOR 74)
- client 1.60.1 (71139)

## Tests

- Spec: "sections follow the toolkit's order whatever order a module lists them in" (`tests/loadorder_spec.lua`).

## Reopen if

An addon convention turns up that most players expect.
