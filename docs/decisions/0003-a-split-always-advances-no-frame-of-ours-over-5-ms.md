# 0003. A split always advances; no frame of ours over 5 ms

- Date: 2026-11-26
- Status: accepted
- Scope: all modules
- Kind: performance

## Context

Work too big for one frame is spread across frames. An earlier draft gave up after a time cap.

## Decision

Work spread across frames moves forward at least one item a frame, sized to the 5 ms bar, and never gives up on a timer. A Blizzard call that must stay in one frame is a named atomic exception, logged as such.

## Reasons

- A time cap starves slower hardware: the work never finishes there (`docs/standards.md`, "Performance").

## Owner's words

- "Capping is weird, slower computers would never get it"

## Rejected

- A give-up cap on time or attempts for splits.

## Versions

- JigBoltgripToolkit `23effaa`, `26daf10`
- client 1.60.1 (71139)

## Tests

- `tools/perf-deck` exits 1 for any logged frame over 5 ms. Deck run: pending.

## Reopen if

A frame budget other than 5 ms is shown to matter on the Deck.
