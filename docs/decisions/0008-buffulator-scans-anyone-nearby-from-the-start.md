# 0008. Buffulator scans anyone nearby from the start

- Date: 2026-11-26
- Status: accepted
- Scope: Buffulator
- Kind: scope

## Context

The need scan could start with the group only.

## Decision

The need scan covers you, your group, your target, your mouseover and players with friendly nameplates.

## Reasons

- Buffing strangers is part of the job from the first version.

## Rejected

- Group only, widened later.

## Versions

- Buffulator `eaa3f3d` (nameplates scanned from the first build)
- Buffulator `d9c04fb` (one cheap scan: a set of shown plates, stop at the first need)
- client 1.60.1 (71139)

## Tests

- Spec: "buffs a level 9 player outside the group at the rank they can take" (`tests/behavior_spec.lua`).

## Reopen if

Nameplate scanning costs too much in a busy city (perf-deck).
