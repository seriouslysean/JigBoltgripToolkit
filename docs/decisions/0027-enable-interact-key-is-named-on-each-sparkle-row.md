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

- The controller picks without it (owner, 2026-11-27: "Enable interact key was never on in our tests").
- Each tooltip must read alone in search (`docs/options.md`, "Labels" 7).

## Owner's words

- "Enable interact key was never on in our tests, and if off for people by default"

## Rejected

- The note once per section.

## Versions

- client 1.60.1 (71139)

## Tests

- none yet

## Reopen if

Search stops showing rows alone.
