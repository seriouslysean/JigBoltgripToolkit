# 0084. Devices speak in the terms of their work

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: voice

## Context

Recipe Vacuum's map pin needed a line for a refusal in combat. Plain refusals ("not in combat") read as an error, not as the device at work, and the pin line already spoke as a gnomish locator: "Coordinates locked! %s triangulated in %s! Pin deployed!"

## Decision

Each device speaks in the terms of what it does, taken from the game's own machines. Before naming a new action, read the game's escort robots and gnomish devices for those terms: the OOX homing robots, the Target Acquisition Device copters of Gnomeregan's Train Depot. Recipe Vacuum's pin locks coordinates, triangulates a place and deploys a pin; in combat it refuses to triangulate under fire.

## Reasons

- A line in the device's own terms reads as the device at work, which is the toolkit's voice (standards.md, "Voice").
- Terms taken from the game's machines fit the world; invented jargon does not.
- One set of terms per device keeps its lines consistent with each other.

## Rejected

- Plain status words ("disabled", "unavailable"): the system's voice, not the device's.

## Versions

- RecipeVacuum 52e8d0a (`underFire`); 3694d56 (`pinned`).

## Tests

- Review: a new voiced line uses its device's terms and cites the game text it models.

## Reopen if

- A device's job has no counterpart among the game's machines.
