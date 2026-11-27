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

## Owner's words

- "Sounds herbs and ores be combined in settings?"

## Rejected

- Two checkboxes.

## Versions

- client 1.60.1 (71139)

## Tests

- Spec: "shows on a picked herb for a herbalist" (`tests/learn_spec.lua`).

## Reopen if

A player wants one without the other while knowing both.
