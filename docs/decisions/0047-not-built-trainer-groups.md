# 0047. Not built: trainer groups

- Date: 2026-11-27
- Status: not built
- Scope: Recipe Vacuum
- Kind: trainers

## Context

Trainers of one tier usually teach the same list.

## Decision

Not built. If built: group trainers by identical spell-ID lists, never title text, so one read or source covers the whole group.

## Reasons

- Groups save little, so they are skipped while they would be complicated.
- Only one trainer's list is saved so far (npc 1241), so grouping can't be checked yet.

## Rejected

- Grouping by title text.

## Versions

- n/a

## Tests

- n/a

## Confirmed, still not built (2026-11-27)

- Data: an Ironforge run (Deck save 2026-11-27 11:23, Recipe Vacuum `d504a36`) read 16 trainers. Every same-profession pair seen teaches an identical spell list: Cooking 1699 and 5159 (8 of 8), Engineering 1702 and 11028 (11 of 11), First Aid 2326 and 5150 (11 of 11), Mining 5392 and 4254 (12 of 12).
- Gain if built: about one 22 ms flip saved per extra trainer of a group, once per account (about 90 ms across that run), plus learned-row sources copied to the group's other trainers, which only alts read. No new trainers: a trainer's group is known only after a visit, and that visit's scan records what it shows.
- Cost: matching each character's visible list against the group's full list, minus known recipes, with faction and odd trainers handled; a group table and a schema bump; about 100 to 150 lines plus specs in the trainer code proven on the Deck the same day.
- Given that: not built; the data is recorded.

## Reopen if

A feature needs groups, such as listing trainers not yet visited (which would need shipped group data; see 0046), or trainer flips show up as a measured cost.
