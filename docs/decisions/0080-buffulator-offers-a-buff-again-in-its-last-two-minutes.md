# 0080. Buffulator offers a buff again in its last two minutes

- Date: 2026-11-27
- Status: accepted
- Scope: Buffulator
- Kind: buffing

## Context

Buffulator offered a buff only once it was gone. A threshold to rebuff before it runs out was needed, set from research on how people respond to reminders rather than a guess, for every buff length. Forever's buffs last 60 min (Mark of the Wild, Arcane Intellect, Fortitude, Divine Spirit), 20 min (Prayer of Shadow Protection) and 10 min (Thorns, Shadow Protection), read from `SpellMisc` and `SpellDuration` for build 1.60.1.71139.

## Decision

- You and your group are offered a buff again in its last 2 minutes, whatever its length.
- Within 30 seconds of a Buff Next cast that landed, the window widens to 5 minutes, so top-ups come in one run.
- Strangers are offered a buff only once it is gone.
- Anyone wearing a weaker single rank than the one you would cast for their level is offered the upgrade at once. A group version is never cast over.
- A buff whose time left is hidden counts as plenty left.

## Reasons

- The line is itself the reminder and names the player and the buff. In four experiments, the delay between a reminder and the moment to act did not change performance; naming the target and the action did (Guynn, McDaniel and Einstein 1998, PMID 9584436).
- Each extra reminder per encounter cut acceptance by 30%, and repeats cut it further (Ancker et al. 2017, doi 10.1186/s12911-017-0430-8). Early top-ups are low-value prompts, so the window is short.
- Prompts at a natural breakpoint caused 43 to 56% less annoyance (Adamczyk and Bailey, CHI 2004) and 33 to 46% less load (Okoshi et al. 2015). The line shows only out of combat, which is that breakpoint.
- A share of the duration fits poorly: 10% gives Thorns 1 minute and the 60 min buffs 6. The window should track the spacing of breaks, not buff length.
- The 2 minutes is our own choice, not yet measured: long enough that a buff offered at a break outlasts the next fight, short enough that the 10 min buffs prompt once a run of fights, not every break. The working log's `shown_s` checks it (Reopen if).
- Batching follows the per-encounter effect above and Nielsen Norman Group's advice to send fewer notifications. It is an inference, not a tested result.

## Rejected

- 10% of the duration, capped at 5 minutes.
- A quarter of the duration, held between 1 and 5 minutes: it still tracks buff length, not the spacing of breaks.
- Tiers by buff length, capped at 3 minutes: the same fault, in steps.
- A flat 5 minutes.
- Topping up strangers in the window.

## Versions

- Buffulator after kit MINOR 85: `Buffs.lua` (`Lead`, `Wants`, `WatchWindow`, `ReadBuffs`).

## Tests

- `tests/behavior_spec.lua`, "Rebuff": a table of group member at 119 s and 121 s, group version, hidden time, stranger at 30 s, stranger with a weaker rank, stranger with none; the window opening on its own timer; the 5 minute window after a cast. Each rule's removal fails a test, checked by mutation.

## Reopen if

- The working log's `press ... shown_s` shows prompts waiting long for a press, or top-ups being missed.
- `scan ... time_hidden` shows the client hides a group member's time left, which would mean no top-up is ever offered.
