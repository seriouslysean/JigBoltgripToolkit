# 0001. AutoOmniadjustor acts with three spells only

- Date: 2026-11-25
- Status: accepted
- Scope: AutoOmniadjustor
- Kind: scope

## Context

A module was wanted that acts on bag items for professions.

## Decision

The module acts on bag items with Disenchant (13262), Pick Lock (1804) or a key that opens the lock, and Comprehend Scroll (1296017). Nothing else.

## Reasons

- These three are the Forever 1.60.1 spells that take a bag item as their target (AutoOmniadjustor `docs/data.md`).

## Rejected

- Scrap Item.

## Versions

- AutoOmniadjustor `105a481` (`Actions.lua`; seed tables from build 1.60.1.71139 by `tools/seed.py`)
- client 1.60.1 (71139)

## Tests

- Offline: conformance loads the addon on the toolkit stand-ins without errors (`scripts/check` at `cedabe0`).
- Deck: pending; the module is off until its taint fix lands.

## Reopen if

Another on-item spell is wanted, or Scrap Item turns out to fit.
