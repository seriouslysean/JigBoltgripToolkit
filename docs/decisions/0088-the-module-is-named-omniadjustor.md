# 0088. The module is named Omniadjustor

- Date: 2026-11-28
- Status: accepted
- Scope: Omniadjustor
- Kind: name

## Context

0018 named the module Auto-Omniadjustor. The module acts only when the player presses its key; nothing about it is automatic, so the "Auto" prefix misdescribes it.

## Decision

The module is Omniadjustor: folder, TOC title, saved variables `OmniadjustorDB`, bindings `OmniadjustorButton` and `OmniadjustorMarksButton`, slash command `/omniadjustor`, chat name "Boltgrip's Omniadjustor", repository seriouslysean/Omniadjustor. Saved data under the old name is not migrated.

## Reasons

- The name says what the device is, a gnomish adjustor, without promising automation it does not do.
- The module is unreleased, so no player has saved data to carry over.

## Rejected

- Keeping Auto-Omniadjustor: misleading.
- Migrating `AutoOmniadjustorDB`: no released data exists.

## Versions

- Omniadjustor 927280a (the rename).

## Tests

- The AddOns list shows Omniadjustor once on the Deck and the Mac (the old AutoOmniadjustor folder removed), and `/omniadjustor` answers.

## Reopen if

- The module gains a mode that acts without a key press.
