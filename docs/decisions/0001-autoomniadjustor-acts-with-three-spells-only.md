# 0001. AutoOmniadjustor acts with three spells only

- Date: 2026-11-25
- Status: accepted
- Scope: AutoOmniadjustor
- Kind: scope

## Context

The owner asked for a module that acts on bag items for professions.

## Decision

The module acts on bag items with Disenchant (13262), Pick Lock (1804) or a key that opens the lock, and Comprehend Scroll (1296017). Nothing else.

## Reasons

- These three are the Forever 1.60.1 spells that take a bag item as their target (AutoOmniadjustor `docs/data.md`).

## Owner's words

- "anything that happens on items in the inventory from a profession, maybe mage comprehension"
- "Research scrap, I don't know about it, but o expect skip to start"

## Rejected

- Scrap Item.

## Versions

- AutoOmniadjustor `74e119e` (`Actions.lua`; seed tables from build 1.60.1.71139 by `tools/seed.py`)
- client 1.60.1 (71139)

## Tests

- Offline: conformance loads the addon on the toolkit stand-ins without errors (`scripts/check` at `4e2dd83`).
- Deck: pending; the module is off until its taint fix lands.

## Reopen if

The owner asks for another on-item spell, or Scrap Item turns out to fit.
