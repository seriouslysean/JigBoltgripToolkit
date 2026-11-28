# 0002. AutoOmniadjustor never acts on equipment set items; no other gate yet

- Date: 2026-11-25
- Status: accepted
- Scope: AutoOmniadjustor
- Kind: safety

## Context

A use key acting on bag items needs guards against acting on the wrong item.

## Decision

Items in an equipment set are never acted on. No other gate (ignore list, quality cap) for now.

## Reasons

- The game itself refuses a disenchant above the player's skill, with its own error.

## Rejected

- An ignore list and a quality cap, deferred; see 0036 for the gate that replaced the need.

## Versions

- AutoOmniadjustor `0a2883d` (`Actions.lua`, `C_Container.GetContainerItemEquipmentSetInfo`)
- client 1.60.1 (71139)

## Tests

- none yet
- Deck: pending; the module is off.

## Reopen if

A wrong item is ever acted on.
