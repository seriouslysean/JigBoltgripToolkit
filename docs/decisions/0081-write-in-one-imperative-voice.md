# 0081. Write in one imperative voice

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: process

## Context

Docs, decision records and comments across the toolkit and its modules carried third-person narration: attributions with a date and a quote of who said it, records with a section of quoted words, and lines naming an assistant or a reviewer. The rule sat in the quote, not in the text, and the same rule read differently from file to file.

## Decision

Write docs, decision records and comments imperatively in one voice: no third person, no attributions or quotes of who decided. A record states what we chose and why; a doc states the rule and its reason. Dates, status, options and reasons stay. The records lose their quoted-words section, and every existing text is rewritten to this voice.

## Reasons

- The toolkit reads as one author (standards.md, Ethos 7); a quote of who decided is a second voice.
- The reason is what a reader needs. Where a quote carried the only reason, the reason is now written out in plain words.
- Comments already give the reason only, never history or who decided (standards.md, "Comments"); docs now follow the same rule.

## Rejected

- Keeping quotes as evidence in decision records: the record's reasons and data are the evidence.

## Versions

- Kit docs and comments, this commit; every module's docs, comments and AGENTS.md the same day.

## Tests

- `tests/conformance.lua`, "docs and comments carry no attributions" (and `--voice`, a step of the kit's `scripts/check`): fails a tracked doc line or Lua comment with an `owner` followed by a date or a quote, `(owner`, an assistant named as a source, or a quoted-words section. API names and log keys (`SetOwner`, `owner=`) never match.

## Reopen if

- A record needs a quote that no plain reason can replace.
