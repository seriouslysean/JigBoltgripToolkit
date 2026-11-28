# 0041. Each action gets a key binding and a /click macro

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: options pages

## Context

Tackletron used a key binding; Buffulator wrote a macro for a bar.

## Decision

Each press-to-act action gets a key binding row plus an "<Action> Macro" [Make] row that makes a one-line `/click` macro.

## Reasons

- Gamepad players can't drag a key binding onto a bar or radial; keyboard players expect a binding.

## Rejected

- Key binding only.
- Each module its own way.

## Versions

- JigBoltgripToolkit `fe118c1`
- Buffulator `8b51628`
- client 1.60.1 (71139)

## Tests

- Deck: a `/click` macro from a gamepad bar slot, no taint; pending. `/click` sends down=false, so a secure button needs `useOnKeyDown` false or AnyDown handling (`SecureActionButton_OnClick`, `SecureTemplates.lua`; Buffulator session), also pending.

## Reopen if

A `/click` macro from a gamepad bar slot taints or fails on the Deck.
