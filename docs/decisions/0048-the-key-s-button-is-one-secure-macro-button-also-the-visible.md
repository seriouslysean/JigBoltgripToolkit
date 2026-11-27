# 0048. The key's button is one secure macro button, also the visible one

- Date: 2026-11-23
- Status: accepted
- Scope: Tackletron
- Kind: panel

## Context

The key must equip, use a lure and cast on one press, and the same button shows above the cast bar.

## Decision

One `SecureActionButtonTemplate` button that is also an `ActionButtonTemplate` check button. It registers `AnyDown` and `AnyUp`, so it follows the player's Cast on Key Down setting. Every step is a macro (`/equipslot`, `/use`, `/cast`), and the macro is emptied after each press so a combat press cannot repeat a stale step. The secure template comes last.

## Reasons

- Templates apply in order, and `ActionButtonTemplate`'s flyout template sets its own `OnClick`, which would replace the secure click and leave a button that does nothing (Blizzard `Flyout.xml`; fixed in `a2445a4`).
- Blizzard names the pair "barebones combo of ActionButtonTemplate + SecureActionButtonTemplate" (`ActionButton.lua:1668`).
- `AnyDown` and `AnyUp` follow `ActionButtonUseKeyDown` (`SecureTemplates.lua`).

## Owner's words

- none recorded; the choice came from the first working build and a bug fix.

## Rejected

- none recorded.

## Versions

- Tackletron `1f18f9b` (first build), `a2445a4` (secure template last), `eff4b0d` (macro emptied after each press)
- Tackletron `55ea658` (comment moved here)

## Tests

- Specs (`tests/behavior_spec.lua`) "no pole in hand: the key equips the pole from its bag slot", "pole in hand: the key casts", "Cast on Key Down off: the press leaves the swap armed and the release swaps".

## Reopen if

Blizzard changes the secure templates or the flyout template.
