# 0033. PvP-flagged strangers are buffed by default, told once

- Date: 2026-11-27
- Status: accepted
- Scope: Buffulator
- Kind: buffing

## Context

Buffing a flagged player outside your group flags you.

## Decision

Buff PvP-Flagged Players is on by default. The first time the next player would flag you, one chat line says so before the press and names the setting. Turned off, flagged strangers are skipped while you are unflagged. Group members are always buffed.

## Reasons

- On PvP servers players are nearly always flagged, so skipping would hide most of them.
- A popup taints (0031); a settings link taints (0039).

## Rejected

- Skipping flagged strangers by default.
- A one-time Yes/No dialog (`7efed80`).
- A chat link that opens the options.

## Versions

- Buffulator `afaf8a7`
- `cairn:5rkag`
- client 1.60.1 (71139)

## Tests

- Specs: "buffs a flagged stranger by default and says so once before the press", "passes over flagged strangers once the setting is turned off", "never warns a player who chose on the options page" (`tests/behavior_spec.lua`).
- Deck: pending.

## Reopen if

A safe way to open Settings from a link is proven on the Deck.
