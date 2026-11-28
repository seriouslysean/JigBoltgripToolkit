# 0074 No tutorial tips; modules log only through Trace

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: voice and logging

## Context

Two kit gaps found the same afternoon. Tutorial tips (HelpTipTemplate frames, HelpTip calls) never show on the Gamepad UI, and HelpTip:Show already tainted the action bar (Tackletron). Kit MINOR 83 made Trace build logfmt from event and pairs, but lib:Log still takes a finished line: Tackletron's `toolkit:Log(ns.module, "pad", "style", x, ...)` wrote only "pad", with no time, and conformance passed it.

## Decision

- No tutorial tips in any module: first-use guidance is a once-only voiced chat line through lib:SayOnce on every device. Conformance fails `HelpTip` anywhere in a module.
- A module logs only through lib:Trace(module, "event", key, value, ...). Conformance fails a module's `toolkit:Log(` or `toolkit:LogAll(`.

## Reasons

- The Gamepad UI shows no tips, so first-use guidance moves to chat for every device: one way, held in the kit.
- One way to log keeps every line in one format (decision 0067: all logs pipe through the kit).

## Rejected

- Letting Log build pairs too: two entry points for one job.

## Versions

- Kit conformance and standards: this commit. Tackletron removed its two tips and moved to Trace (060483f and after).

## Tests

- Conformance rules, run by every module's scripts/check.

## Reopen if

- Blizzard's Gamepad UI starts showing HelpTip frames.
