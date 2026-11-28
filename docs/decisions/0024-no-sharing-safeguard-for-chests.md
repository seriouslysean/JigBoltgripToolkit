# 0024. No sharing safeguard for chests

- Date: 2026-11-27
- Status: accepted
- Scope: Sparklescope 6000
- Kind: data

## Context

A wrong chest shared by a friend would stay.

## Decision

A shared chest is kept as sent, with no "seen twice" rule, cap or forget button.

## Reasons

- Only friends, guild members and group members running the addon can send one (the kit's `Share:IsTrusted`; review finding 11).

## Rejected

- Sharing only after opening a kind twice, a cap, a forget button.

## Versions

- client 1.60.1 (71139)
- Sparklescope6000 f532861 (sharing through the kit share, MINOR 49); unchanged since

## Tests

- None: nothing was built; sharing between two players is not yet seen in game.

## Reopen if

A wrong shared sparkle shows up.
