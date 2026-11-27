# Decisions

Choices that hold for every toolkit module, grouped by kind, so each can be revisited with its reasons in hand. A module's own choices live in its own `docs/decisions.md`; a choice that turns out to apply to every module moves here. Each entry gives the decision, why (with its data), what was rejected and what would reopen it. The detail lives in the doc the entry points to.

## Options pages

The goal (owner, 2026-11-27): "our goal is one person wrote all these addons, tools, they need to fit together and be similar in configuration." Rules in [options.md](options.md).

- **Page order** (2026-11-27): sources, features, game settings, Keybindings, Commands, Working Build. No written addon convention exists; Blizzard puts addon key bindings on its own Keybindings page near the bottom. Owner: "Adopt it".
- **Actions** (2026-11-27): each press-to-act action gets a key binding row plus an "<Action> Macro" [Make] row that makes a `/click` macro. Owner: "Both, the same way". Reopen if a `/click` macro from a gamepad bar slot taints or fails on the Deck.
- **Labels** (2026-11-27): name the thing, with no verb added. Owner: "Simple, dry, kiss, adding a verb does nothing but add cognitive load here". Rejected: a verb-first rule; renaming "Combat" to "Weapons" (owner: "Keep 'Combat'").
- **Chat** (2026-11-27): a line that repeats gets one Announce checkbox, on by default; a once-ever line needs none. Owner: "Yes, one checkbox".
- **Button rows** (2026-11-27): a row names the thing with the verb on its button, never a slash command.
- **Toolkit page** (2026-11-27):
  - No Open rows. Owner: "Why do we have those open buttons if they don't do anything?"
  - No Reload UI row, no Clear row.
  - No watch switch. Owner: "We also shouldn't be able to turn off the logging on my debug build".
  - Built from list rows only; see "Gamepad and taint".

## Gamepad and taint

Rules in [standards.md](standards.md), "Gamepad UI".

- **Canvas pages banned, measured** (2026-11-27, MINOR 73):
  - A canvas About page with the owner's intro paragraph (MINOR 72) came up empty on the Deck and broke the controller ("Interface action failed because of an AddOn"). No list row can show a paragraph: a heading is one large line with no width (`Blizzard_SettingControls.xml:12`).
  - Rejected: a one-line heading intro (owner: "I don't like any of that").
  - Reopen if a canvas page is proven on the Deck with the Gamepad UI and other addons off.
- **`StaticPopup_Show` banned** (2026-11-27): a popup shown from addon code activates the Gamepad UI's popup bindings tainted (`StaticPopupGamepad.lua`, through `InputBindingManager`), the path that blocks the gamepad interact target. Tell the player in chat instead.
- **Copy window on the gamepad** (2026-11-27, MINOR 75): it opens unfocused, so B closes it. A focused edit box kept B from closing it on the Deck.

## Data

- **Self found first, with built-in exceptions** (2026-11-27, [standards.md](standards.md) rule 11): shipped data shows only at the Public level. A module may ship data on for everyone where the owner names it, with a source choice of Self Found and Friends that augments it. Named so far: Sparklescope 6000's chest list and Tackletron's zone fishing levels. Owner: "for this one we ship with a list and everyone gets it"; "like chests we need the concept of shared, and self reported augmentation".

## Performance

- **No frame of ours over 5 ms; splits always advance** (2026-11-26): work spread across frames moves forward at least one item a frame, sized to the bar, and never gives up on a timer. Owner: "Capping is weird, slower computers would never get it". A Blizzard call that must stay in one frame is a named atomic exception, logged as such.
- **Don't fix edge cases that don't exist** (2026-11-27): an unseen failure is recorded as a known risk, not built against. Owner: "Don't fix edge cases that don't exist".
