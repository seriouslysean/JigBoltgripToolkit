# 0029. Button rows name the thing, verb on the button

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: options pages

## Context

Command rows were labelled with the slash command and a "Run" button.

## Decision

A button row names the thing, with the verb on its button ("Export Recipe Sources" [Export]), never a slash command. A command entry gives `label` and `button`.

## Reasons

- Blizzard's button rows name the thing and put the verb on the button ("Reset Chat Position", "Reset", `Frame/Social.lua:281`); no Blizzard row shows a slash command.

## Rejected

- Slash-command labels with "Run".

## Versions

- JigBoltgripToolkit `9cc141e` (MINOR 67)
- RecipeVacuum `412e7cc`, `2da4de2`
- client 1.60.1 (71139)

## Tests

- Deck: Recipe Vacuum and Tackletron pages passed, 2026-11-27.

## Reopen if

n/a
