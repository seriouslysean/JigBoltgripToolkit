# 0032. Buff Next is a secure button, a key binding and a /click macro

- Date: 2026-11-27
- Status: accepted
- Scope: Buffulator
- Kind: buffing

## Context

Buff Next was a character macro whose whole text was rewritten.

## Decision

The button holds the macro text, set out of combat. A Keybindings row presses it, and the Buff Next Macro [Make] row makes a one-line `/click` character macro. The macro's icon still follows the buff.

## Reasons

- Every press-to-act module offers both, the same way (0041).

## Rejected

- The rewritten character macro (`758843f`).
- A raised controller key (`776e9b7`; "This isn't the same as fishing").

## Versions

- Buffulator `6a8f2f7`
- client 1.60.1 (71139)

## Tests

- Deck: Buffulator `docs/client-notes.md` checks 17 to 19, pending.

## Reopen if

Those Deck checks fail.
