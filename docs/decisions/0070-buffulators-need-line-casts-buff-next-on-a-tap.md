# 0070. Buffulator's need line casts Buff Next on a tap

- Date: 2026-11-27
- Status: accepted, check in game pending
- Scope: Buffulator
- Kind: buffing

## Context

The one-line need frame under the portrait (decision 0069) names the next player to buff. Casting took a press of the Buff Next key binding or its `/click` macro on a bar. The owner asked whether tapping the line could do it.

## Decision

The line is a secure button (`SecureActionButtonTemplate`, `type` = `click`, `clickbutton` = the Buff Next button), so a tap, a mouse click or the gamepad cursor casts exactly what Buff Next would, once, on release. A secure state driver (`[combat] on; off`) hides it as a fight starts; addon code shows, hides and moves it only out of combat. The name on it is in class color only while Blizzard's Use Class Color for Names (`nameplateUseClassColorForFriendlyPlayerUnitNames`) is on.

## Reasons

- `SECURE_ACTIONS.click` clicks the delegate only when it has no access constraints, so the line casts Buff Next's own text and nothing else (`Blizzard_FrameXML/SecureTemplates.lua`, Gethe/wow-ui-source `forever`).
- The template's `OnClick` passes no mouse flag, so `SecureActionButton_OnClick` treats a tap as a key press and, with Action Button Use Key Down on (the default), acts only on the down (`Blizzard_FrameXML/SecureTemplates.xml` and `.lua`). The line registers only `AnyUp` and sets `useOnKeyDown` false, so it casts once, on release. The first build lacked `useOnKeyDown` and a tap did nothing (owner, 2026-11-27: "tapping the buff icon doesn't work yet either").
- A protected frame cannot be shown, hidden or moved by addon code in combat; a state driver is Blizzard's way to hide one then.
- Following Blizzard's own class color choice adds no Buffulator setting.

## Owner's words

"Can I also tap that frame under my name to do the action?"; on the proposal, chose "Make it castable". On colors: "if we have show class colors on, we should show them as their name", choosing "Follow Blizzard's box".

## Rejected

- Display only, casting from the key or macro alone.
- Always class color, or a Buffulator class color setting.

## Versions

- Buffulator after kit MINOR 83: `NeedFrame.lua`.

## Tests

- `tests/behavior_spec.lua`, "colors the name by class only when Blizzard's setting is on/off" (table, two rows).
- The tap and the combat hide run in the game's secure code, so they are checked in game: Buffulator `docs/client-notes.md` checks 21 and 22.

## Reopen if

A tap casts twice or not at all, the hide in combat leaves a blocked-action line, or Interact stops working after a tap.
