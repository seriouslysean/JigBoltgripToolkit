# 0012. Thanks emotes are checkboxes, picked at random

- Date: 2026-11-26
- Status: accepted
- Scope: Buffulator
- Kind: thanks

## Context

The thanks emote could be one fixed emote, a dropdown or typed names.

## Decision

Eight game emotes, each a checkbox labeled with the game's own slash command. Each thanks picks one checked emote at random, never the same twice in a row. On the page: `/thank` first, then the game's chat-menu order.

## Reasons

- A dropdown breaks the controller (`docs/options.md`, "Banned controls").
- The order follows the toolkit's options standard (Buffulator `docs/emotes.md`).

## Owner's words

- "I do like the multi select option if we could organize and design them properly and choose randomly"
- "I'd rather show and allow organizing them better with in game strings"
- "Collaborate with all the addon agents"

## Rejected

- A dropdown.
- Typed emote names ("prone to error and I don't like that").
- Several checkboxes across one row (no Blizzard control for it).

## Versions

- Buffulator `78355dd` (checkboxes, random pick, never twice in a row)
- Buffulator `b674d34` (in the Thanks section, under its switch)
- Buffulator `4f8e2eb` (`/thank` first, then the game's chat-menu order)
- client 1.60.1 (71139)

## Tests

- No spec for the random pick.
- Seen in game: `/thank` from the timer (Buffulator `cb118f2`).
- Deck: emote order check pending.

## Reopen if

Blizzard's controls gain a several-across checkbox row, or a custom `/me` thanks is wanted.
