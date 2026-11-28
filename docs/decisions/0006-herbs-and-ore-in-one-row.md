# 0006. Herbs and ore in one row

- Date: 2026-11-26
- Status: accepted
- Scope: Sparklescope 6000
- Kind: options pages

## Context

Sparkles for herbs and for ore could each have a checkbox.

## Decision

One "Herbs and Ore" checkbox; each kind shows only while the player knows its profession, so one row serves herbalists and miners alike.

## Reasons

- A player who knows only one of the two professions never sees the other kind.

## Rejected

- Two checkboxes.

## Versions

- client 1.60.1 (71139)
- Sparklescope6000 69099b8 (one checkbox, 2026-11-26); kit options standard at 55318d0 (labels name the thing)

## Tests

- Spec: "shows on a picked herb for a herbalist" (Sparklescope6000 `tests/learn_spec.lua`).
- In game: herbs and ore sparkled on the Deck under the one row, each with its profession (2026-11-26 and 2026-11-27).

## Reopen if

A player wants one without the other while knowing both.
