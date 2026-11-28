# 0031. StaticPopup_Show is banned

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: gamepad and taint

## Context

Buffulator showed a Yes/No popup for its PvP prompt.

## Decision

Conformance refuses `StaticPopup_Show`; tell the player in chat instead.

## Reasons

- A popup shown from addon code activates the Gamepad UI's popup bindings tainted (`StaticPopupGamepad.lua`, through `InputBindingManager`), the path that blocks the gamepad interact target (Buffulator session).

## Rejected

- A Yes/No dialog (Buffulator `9bb71fb`).

## Versions

- JigBoltgripToolkit `55c58ba`
- client 1.60.1 (71139)

## Tests

- Conformance check in `tests/conformance.lua`.

## Reopen if

A popup is proven untainted on the Deck.
