# 0064. The fishing-data probe stays a working-build command

- Date: 2026-11-23
- Status: accepted
- Scope: Tackletron
- Kind: scope

## Context

Detecting lures and Fishing food without a list needed to see what the client reports for each usable consumable in the bags.

## Decision

The probe lists what the client reports for the player's fishing food and lures. It began as a temporary research aid and was to be removed once detection was settled. Detection settled on ID tables (0056), and the probe remains a working-build command, with taint, shown as a button there and stripped from releases. `/tackletron status` ships in every build.

## Reasons

- The kit's standard keeps research commands out of releases and status in every build.

## Owner's words

- "we need to research a way to get it" (2026-11-23)
- "Ship it in releases" (2026-11-27, on status only)

## Rejected

- Shipping the probe in releases.

## Versions

- Tackletron `952861b`, `a8a7174`, `82d04c0`
- kit MINOR 51, 54

## Tests

- Spec "status ships in every build".

## Reopen if

Tables stop needing a check against the client, so the probe can go.
