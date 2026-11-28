# 0060. The button sits where the cast bar appears

- Date: 2026-11-23
- Status: accepted
- Scope: Tackletron
- Kind: panel

## Context

The cast bar is one of Blizzard's managed bottom frames, so anchoring to it made the button jump after every cast.

## Decision

The container places the bar only while it shows (`ManagedFrameSystem.lua`, `AddManagedFrame` and `RemoveManagedFrame`). The button is pinned where the bar appears, read each time the bar shows after Blizzard's layout, and saved per character so the next login starts there. Until the first cast ever it sits on top of the container the bar shows in, since a hidden managed bar has no points and anything anchored to it is not drawn. Leaving Edit Mode drops the saved spot so the row follows a moved bar. In controller mode the row sits above the gamepad bars.

## Reasons

- `HookScript` runs after the bar's own `OnShow`, so the layout is final.

## Rejected

- Anchoring to the bar.

## Versions

- Tackletron `8f16d0f`, `6ce928e`, `dac5a5b`, `eb485d8`

## Tests

- Specs "first login, no cast yet: the button sits on the cast bar's container", "button pinned 12 px above where the cast bar shows, and stays when it hides", "next login: the button starts at the saved spot", "leaving Edit Mode drops the saved spot".

## Reopen if

Blizzard moves the cast bar out of the managed frames.
