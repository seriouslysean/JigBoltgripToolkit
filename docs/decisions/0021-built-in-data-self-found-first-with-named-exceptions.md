# 0021. Built-in data: self found first, with named exceptions

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: data

## Context

The toolkit's rule 11 makes public data opt-in.

## Decision

Shipped data shows only at the Public level. A module may ship data on for everyone where a decision names it, with a source choice of Self Found and Friends that augments it. Named so far: Sparklescope 6000's chest list (0022) and Tackletron's zone fishing levels.

## Reasons

- Fixed world data is not what other players found; Tackletron's levels are used only for the zone the player stands in (`docs/standards.md`, rule 11).

## Rejected

- Public as the only way to get shipped data.

## Versions

- JigBoltgripToolkit `410e7a7`, `1b2b518`

## Tests

- none yet

## Reopen if

A third module needs shipped data.
