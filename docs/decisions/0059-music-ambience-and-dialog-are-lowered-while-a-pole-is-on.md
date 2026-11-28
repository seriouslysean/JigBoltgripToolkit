# 0059. Music, ambience and dialog are lowered while a pole is on

- Date: 2026-11-23
- Status: accepted
- Scope: Tackletron
- Kind: game settings

## Context

The splash is a sound effect, which no setting can single out.

## Decision

While a pole is equipped, music, ambience and dialog play lower, so the splash stands out. The share kept is a fifth. It is set with temporary CVars, so a crash or disconnect cannot leave saved volumes lowered, and only Tackletron's own leftover values are dropped after a reload. It is not changed during combat lockdown, where CVar changes from addon code are a likely source of taint for the action bars, and waits for the fight to end.

## Reasons

- Sound is in scope for the splash (Tackletron `AGENTS.md`).
- Standards review 2026-11-25 on CVar taint.

## Rejected

- Muting; lowering effects.

## Versions

- Tackletron `3224969`, `f85b43c`, `93e09f3`, `d5d11cd`, `9ab60e2`, `4734864`

## Tests

- Specs "pole on: music, ambience, dialog at 20%, effects untouched", "reload with the pole on: still 20% of the saved volume, not 20% of 20%", "a fight ends with the pole on: other sounds stay lowered", "another addon's temporary music volume survives Tackletron's login".

## Reopen if

A setting lets one sound effect be singled out.
