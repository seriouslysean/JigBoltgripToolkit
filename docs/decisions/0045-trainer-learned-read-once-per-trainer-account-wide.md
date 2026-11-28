# 0045. Trainer learned read: once per trainer, account-wide

- Date: 2026-11-27
- Status: accepted
- Scope: Recipe Vacuum
- Kind: trainers

## Context

At a trainer, the default "used" filter hides services the character already learned.

## Decision

The learned services are read after the visible scan, once a visit. A read that finds no rows is done, and done is saved per trainer for the whole account. A trainer is read again only when the visiting character knows a recipe of that profession with no trainer source. No profession gate, no purchase hook.

## Reasons

- Each read flips Blizzard's "used" filter, and each flip rebuilds its list: 26 to 32 ms a pass on the Deck (log 2026-11-27 10:41, npc 1241).
- Three passes over two visits found nothing, because the trainer taught Blacksmithing and the character had none.
- The read is still needed, so its cost is cut instead of the read: once a visit, saved per trainer, no retry.
- A gate adds nothing: the read happens once, gathers data, and lets a player look before switching professions. Account-wide needs no per-character copy and costs less.
- Review agreed: the 0 was correct, the same-visit retry and the pre-scan trigger were bugs, and a hook adds nothing because the scan records rows before a purchase.

## Rejected

- Dropping the read: the learned rows are still wanted.
- A profession gate.
- A `BuyTrainerService` hook.
- Skipping when every known recipe has a source: a character that learns no new recipes now can still learn them later.

## Versions

- RecipeVacuum `cac62e6` (schema 14)
- `cairn:mq5g8`
- client 1.60.1 (71139)

## Tests

- Specs: "a read that finds no learned rows is done: a later visit reads nothing", "an unfinished read runs once a visit, and again on a later visit", "a done trainer is read again for a newly known recipe without a trainer source", "a trainer showing no services reads no learned services" (`tests/simulate_spec.lua`).
- Deck: the automatic read at a trainer whose recipes the character knows passed 2026-11-27 10:59 (Yarr Hammerstone, npc 5392, Mining: 2 used rows, 1 saved, 23.5 ms, once; the next open skipped as done). The Engineering trainer retest after a save reset is pending.

## Reopen if

That Deck test finds 0 rows (the read itself is broken), or flips show up as a measured cost.
