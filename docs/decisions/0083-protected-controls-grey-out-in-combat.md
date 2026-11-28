# 0083. Protected controls grey out in combat

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: gamepad and taint

## Context

Recipe Vacuum's Map Pin opens the map through a secure button (decision 0068). In combat a protected frame can be neither shown, hidden, moved nor given attributes, and a protected child makes its parents protected too. The first build kept a combat fallback: the plain control set the pin without the map. That left two behaviours for one button and code to keep both working.

## Decision

A control that needs a protected frame has one behaviour, and in combat it is off:

- On `PLAYER_REGEN_DISABLED`, while changes are still allowed, hide and unanchor the protected frame and grey out the control. Its tooltip gives the game's `ERR_NOT_IN_COMBAT`.
- On `PLAYER_REGEN_ENABLED`, place the protected frame again and restore the control.
- If the control's window is open when combat starts, the device says why once a session, in its voice. Recipe Vacuum: "Hostiles detected! Refusing to triangulate under fire!"
- Parent the protected frame to `UIParent` and lay it over our control, so none of our frames becomes protected.

## Reasons

- One behaviour: no fallback path to build, test and keep in step.
- The game greys out its own controls in combat with the same message; ours read the same.
- The gamepad cannot land on a greyed-out control, so the chat line is the only place a gamepad player learns why; once a session keeps it from repeating every pull.

## Rejected

- A combat fallback that does part of the job (the pin without the map): two behaviours for one control.
- A secure state driver that shows and hides the frame in combat: restricted code for one button.
- A line every combat, or once ever: every pull is noise; once ever is missed after the first day.

## Versions

- RecipeVacuum a827735 (Map Pin and the place list).

## Tests

- Steam Deck, RecipeVacuum f8a497a: Map Pin greyed out in combat, the line came once, no blocked action; after combat the map opened on Westfall again (decision 0068).

## Reopen if

- A control has to work in combat.
