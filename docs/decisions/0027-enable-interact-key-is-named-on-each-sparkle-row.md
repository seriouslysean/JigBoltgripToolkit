# 0027. Enable Interact Key is named on each sparkle row

- Date: 2026-11-27
- Status: accepted
- Scope: Sparklescope 6000
- Kind: options pages

## Context

Keyboard and mouse players need Enable Interact Key for sparkles; controller players don't.

## Decision

Each sparkle row's tooltip says it is needed with keyboard and mouse only.

## Reasons

- The controller picks without it (it was never on in our tests, and it is off by default).
- Each tooltip must read alone in search (`docs/options.md`, "Labels" 7).

## Rejected

- The note once per section.

## Versions

- client 1.60.1 (71139)
- Sparklescope6000 255efde (the note names keyboard and mouse only)

## Tests

- In game: the controller picks objects with Enable Interact Key off (Deck, every 2026-11-27 session); the options page passed the Deck d-pad check (2026-11-27).
- Keyboard and mouse with it off: not yet seen in game.

## Reopen if

Search stops showing rows alone.
