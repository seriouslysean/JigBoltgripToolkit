# 0049. One key setting: the binding; F fishes when none is bound; Interact is the last choice

- Date: 2026-11-23
- Status: accepted
- Scope: Tackletron
- Kind: keys and marks

## Context

Fishing needs a key, and players should not have to learn a setting for it.

## Decision

Tackletron has one key setting, its own binding in Keybindings, shown as Blizzard's row. A bound key is always active and equips the pole. With none bound, F fishes while a pole is equipped, and with a pole in hand F only fishes. Since 2026-11-26 a bound Interact key is the last choice, and it fishes only when Interact has nothing to loot, use or attack. The keys are read with Tackletron's overrides cleared, because an override hides a key from `GetBindingKey`.

## Reasons

- Blizzard's Interact Key and Extra Action Button have one binding and no key checkboxes.
- F targeted nearby players when it kept its usual job, so with a pole it must only fish (owner 2026-11-23).

## Owner's words

- "Use f when a rod is equipped and supercede the key"
- "With a pole we need it to only fish"
- The owner chose F as the default key (2026-11-23) and chose the Interact key as the last choice (2026-11-26); no quote was kept.

## Rejected

- Key checkboxes, Interact Key borrowing and key capture of our own (`0b60f0c`).
- F with its usual job while a pole is in hand.

## Versions

- Tackletron `0b60f0c`, `09bfe9e`, `051611b`, `b8b66f6`
- kit MINOR 8 (library shared with Recipe Vacuum)

## Tests

- Specs "bound in Keybindings: F is released right away, J fishes", "controller mode, pole on: the Interact button presses Tackletron's button".

## Reopen if

Blizzard binds F or Interact to something that cannot yield to the fishing key.
