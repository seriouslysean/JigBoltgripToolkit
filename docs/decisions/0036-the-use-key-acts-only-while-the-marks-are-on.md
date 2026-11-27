# 0036. The use key acts only while the marks are on

- Date: 2026-11-27
- Status: accepted
- Scope: AutoOmniadjustor
- Kind: safety

## Context

One stray right stick press with the bags open would start Disenchant on an unmarked item (Fable review, finding 4).

## Decision

With the marks off, the use key does nothing and the working log says "marks off". With them on, it acts on the selected or hovered item, which always carries the circling lights.

## Reasons

- The only gate was equipment sets (0002).

## Owner's words

- "Only with marks on"

## Rejected

- Acting with the marks off.
- An ignore list and a quality cap, deferred.

## Versions

- AutoOmniadjustor `154ccec`
- client 1.60.1 (71139)

## Tests

- Specs: "does nothing while the marks are off", "casts the marked item's action while the marks are on" (`tests/usekey_spec.lua`).
- Deck: pending; the module is off.

## Reopen if

The extra press each bag open is felt as friction in play.
