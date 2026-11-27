# 0039. No chat link that opens Settings

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: gamepad and taint

## Context

Buffulator considered a chat link to its options for the PvP line.

## Decision

No addon chat link opens Settings; the line names the setting in plain text.

## Reasons

- An addon link runs addon code (`LinkTypes.AddOn` to EventRegistry "SetItemRef", `ItemRefHandlersShared.lua:279`), and `Settings.OpenToCategory` from there is the same panel taint; Blizzard's own settings link calls it from Blizzard code (`ItemRefHandlers.lua:247`) (Buffulator session).

## Owner's words

- "Plain text line"

## Rejected

- A link that opens the options.

## Versions

- client 1.60.1 (71139)

## Tests

- none yet

## Reopen if

A safe way is proven on the Deck.
