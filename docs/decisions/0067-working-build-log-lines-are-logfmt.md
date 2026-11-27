# 0067. Working-build log lines are logfmt

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: working build

## Context

The working-build log is how the owner's play becomes data, and the owner reads it as well as the assistant. Its lines had grown into prose: "UNLEARNED profession 171: 38 known recipes marked met at Self Found, 38 new; 15 newly known without a trainer source", sixteen "UI row … skill-up none: above skill 215 > 206" lines per list, and development-tool lines ("LAYOUT not recorded: Open a profession, then run it again.") written on their own.

## Decision

Every log line is logfmt: a short lowercase event name, then `key=value` facts. Keys are lowercase snake_case; a value with a space, a quote or `=` is quoted (`lib.LogValue`); IDs are keys; times are `ms=`/`frames=`. No sentences and no per-row lines: one summary line per build or pass. A development tool logs only when its button is pressed. Rule and examples: `docs/standards.md`, "Working build".

## Reasons

- logfmt is the common practice for logs both people and tools read: [Brandur, logfmt](https://brandur.org/logfmt) (Heroku's internal standard, recommended by Splunk), Better Stack's logfmt guide, and Grafana's Loki logging best practices (a readable event plus key-value context).
- `tools/perf-deck` reads keys instead of prose regexes, and still reads the older prose lines kept in saved logs.

## Owner's words

On a plain-sentence draft: "This still reads like AI slop, look up simple, clear debugging style notes". Choosing between logfmt and "event name + short reason": "logfmt".

## Rejected

- Plain sentences with IDs at the end (the first draft).
- An event name plus a short prose reason.

## Versions

- Kit MINOR 82: the kit's own lines (session, device, zone, events, cvar, pad, blocked, tainted fields, Lua errors, sharing, timings, CPU, memory).
- Recipe Vacuum: every trace line, the per-row skill-up lines replaced by one `skillups` summary.
- Other modules convert their own lines (asked 2026-11-27).

## Tests

- Kit specs in `tests/loadorder_spec.lua` assert the logfmt forms of tainted fields, timings, blame owners and event counts.
- `tools/perf-deck` parses both formats (checked on sample lines; the Deck was offline at the time).

## Reopen if

A reader, the owner or a tool, cannot find what it needs in a line without the prose.
