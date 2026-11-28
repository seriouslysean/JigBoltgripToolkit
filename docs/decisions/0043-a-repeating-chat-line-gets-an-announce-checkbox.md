# 0043. A repeating chat line gets an Announce checkbox

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: options pages

## Context

Tackletron repeats lines each lure and each fight with no way to quiet them.

## Decision

A chat line that repeats gets one Announce checkbox, on by default; a once-ever line needs none.

## Reasons

- Superseded label (2026-11-27): the checkbox is "Chat Alerts" in every module; Recipe Vacuum's Announce New Finds was renamed. Recipe Vacuum's Announce New Finds was the model.

## Rejected

- Repeating lines always on.

## Versions

- JigBoltgripToolkit `642e478`

## Tests

- none yet; Tackletron's checkbox is not built yet.

## Reopen if

n/a
