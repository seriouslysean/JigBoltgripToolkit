# 0066. Recipe Vacuum's details scroll as one, header included

- Date: 2026-11-27
- Status: accepted
- Scope: Recipe Vacuum
- Kind: panel

## Context

The details box under Recipe Vacuum's list is half the panel's height, so a recipe with many reagents scrolls. Until now the made item's icon, name and requirement stayed fixed at the box's top, and only the reagents scrolled beneath them in their own slim scroll frame.

## Decision

Everything under the hanging icon scrolls as one: the name, the requirement line, "Reagents:" and the reagent rows, in one slim scroll frame whose view starts at the box's frame line. A new recipe opens scrolled to the top. The d-pad reaching the made item scrolls back to the top; a mouse hovering it does not. The Map Pin strip stays pinned under the box, and the thumb hides while everything fits.

The icon stays on the box, not in the scroll: a scroll frame clips its content, and the icon's ring hangs off the box's frame line, as the window's portrait ring hangs off the window and stays put.

## Reasons

- Blizzard's one details pane that scrolls, the quest log's (`QuestMapFrame.xml:801`, `QuestMapDetailsScrollFrame`), keeps its title inside the scrolled content (`QuestInfo.lua:112` parents each shown element, the title header included, to the scroll child it is given). The profession window's own recipe pane (`Blizzard_ProfessionsRecipeSchematicForm.xml`) never scrolls, so it has no fixed-header precedent.
- One scroll area instead of a fixed part over a scrolled part, and the reagents get the header's room once scrolled.

## Rejected

- Keeping the icon, name and requirement fixed above a reagents-only scroll (the layout before this).
- Moving the icon into the scroll: the clip would cut off its hanging ring, an approved part of the look.

## Versions

- Recipe Vacuum 0da0a28 (`Panel.lua`, `tests/simulate_spec.lua`, `docs/client-notes.md` "Panel"). Kit MINOR 81. Client 1.60.1 (71139).

## Tests

- Spec: "the details' header scrolls with the reagents, and a new recipe opens at the top" (Recipe Vacuum `tests/simulate_spec.lua`). It fails with the name back on the box, and with no reset to the top.
- Deck: pending. Pick a recipe with many reagents, scroll down, pick another recipe, then d-pad up to the made item.

## Icon stays fixed (2026-11-27)

The made-item icon stays outside the scroll, since its ring hangs over the box edge and a scroll frame clips it. Keep the icon fixed.

## Reopen if

The Deck shows the scrolled header hard to read beside the fixed icon, or the made item's focus jump fights the d-pad.
