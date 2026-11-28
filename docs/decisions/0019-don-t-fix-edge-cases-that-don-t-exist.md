# 0019. Don't fix edge cases that don't exist

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: performance

## Context

Recipe Vacuum's difficulty re-read had a give-up cap added for a recipe that might never report.

## Decision

An unseen failure is recorded as a known risk, not built against.

## Reasons

- The cap broke the spec "a skill change is read again until every candidate answers" and guarded a case never seen.

## Rejected

- Building guards for cases not seen in a log or a report.

## Versions

- n/a

## Tests

- n/a

## Reopen if

The case shows up in a log or a report.
