# 0023. Quest loot teaches no chest

- Date: 2026-11-27
- Status: accepted
- Scope: Sparklescope 6000
- Kind: data

## Context

A quest crate was learned as a chest and sparkled.

## Decision

Loot that is only quest items teaches nothing, and a quest object learned before is forgotten when it is opened again.

## Reasons

- Flintfire's Shipment (672508) was learned when looted at 08:34 on the Deck (Sparklescope `found.chests`).

## Rejected

- Leaving quest objects to a manual forget.

## Versions

- Sparklescope6000 `5d4601d`
- client 1.60.1 (71139)

## Tests

- Specs: "loot of only quest items teaches nothing", "a quest item beside other loot still teaches the chest" (`tests/learn_spec.lua`).
- Deck: the next Shipment loot should clear it; pending.

## Reopen if

A real chest's loot turns out to be only quest items.
