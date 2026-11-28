# 0030. Canvas pages stay banned, measured

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: gamepad and taint

## Context

A paragraph intro was wanted on the toolkit page; no list row shows a paragraph.

## Decision

Every page, the toolkit's included, uses Blizzard's list rows; `Settings.RegisterCanvasLayoutCategory` stays banned.

## Reasons

- A heading is one large line with no width (`Blizzard_SettingControls.xml:12`).
- A canvas About page (MINOR 72) came up empty on the Deck and broke the controller ("Interface action failed because of an AddOn", 2026-11-27).

## Rejected

- The canvas About page (MINOR 72).
- A one-line heading intro.

## Versions

- JigBoltgripToolkit `75e3a14` (MINOR 72, reverted), `744ae0a` (MINOR 73)
- client 1.60.1 (71139)

## Tests

- Spec: ": no canvas page" (`tests/loadorder_spec.lua`); conformance bans the call for modules (`tests/conformance.lua`).
- Deck: canvas page failed, 2026-11-27.

## Reopen if

A canvas page is proven on the Deck with the Gamepad UI and other addons off.
