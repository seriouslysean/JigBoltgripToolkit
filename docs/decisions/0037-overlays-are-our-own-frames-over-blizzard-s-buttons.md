# 0037. Overlays are our own frames over Blizzard's buttons

- Date: 2026-11-27
- Status: accepted
- Scope: AutoOmniadjustor
- Kind: keys and marks

## Context

The first marks were children of Blizzard's item buttons.

## Decision

The marks are our own frames, positioned over the buttons and drawn just above them.

## Reasons

- The toolkit's Gamepad UI rule puts nothing of ours on Blizzard's frames (`docs/standards.md`, "Gamepad UI").

## Rejected

- Children of the item buttons.

## Versions

- AutoOmniadjustor `798ccdd`
- client 1.60.1 (71139)

## Tests

- Deck: pending; the module is off.

## Reopen if

The marks don't sit on top or follow a raised bag on the Deck.
