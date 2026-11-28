# 0028. Toolkit page: no module rows, no reload, no clear, no watch switch

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: options pages

## Context

The toolkit page had an Open row per module and working-build rows for reload, watch and clear.

## Decision

The page holds, in working builds, one row: Working Log (Show). No Open rows, no Reload UI row, no Clear Working Log row, no watch switch; a working build always logs.

## Reasons

- Under the Gamepad UI an Open button can only print where the page is; the AddOns list already shows each page.
- A one-press wipe and a watch-off switch lost test data (Sparklescope's log, 2026-11-27 07:56).

## Rejected

- Open rows sorted by title (MINOR 66 to 69).
- A one-line intro heading (MINOR 71).
- A canvas About page (0030).

## Versions

- JigBoltgripToolkit `b953c96` (MINOR 66), `0231da2` (68), `97b1600` (69), `59d9faf` (70), `1615149` (73)
- client 1.60.1 (71139)

## Tests

- Specs: ": no Open row per addon", ": no canvas page", "a working build always logs, even after an older build turned it off" (`tests/loadorder_spec.lua`).
- Deck: toolkit page passed, 2026-11-27.

## Reopen if

The page needs to hold more.
