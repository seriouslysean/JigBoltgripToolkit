# 0073 Recipe Vacuum keeps its details split over the overview's line

- Date: 2026-11-27
- Status: not built (rejected)
- Scope: Recipe Vacuum
- Kind: layout

## Context

The question was whether Recipe Vacuum's list/details split should line up with the professions overview's bottom row (Cooking, Fishing, First Aid). Measured on the Mac with `/recipevacuum layout` (RecipeVacuum `c3cb053`, 2026-11-27 14:49 and 14:54, screen pixels from the bottom): the overview's bottom row starts at 491.5 (Camelot `Blizzard_ProfessionsBookTemplates.xml`: 316 units below the window top); our details box starts at 508.2, our list ends at 513.3. The outer edges already match Blizzard's to the pixel (window 693.8/313.6, list top 647.7, details bottom 337.9, Map Pin = Create button 336.0-318.1).

## Decision

Keep the current split: the details box keeps its 266-unit floor, which shows three reagents without scrolling.

## Reasons

- Aligning would cut the details box to 240 units, so every recipe with three or more reagents scrolls, and the line it matches exists only on the overview tab, not beside the crafting page.
- Showing 3 reagents matters more than lining up.

## Rejected

- Details top at the overview line (491.5), list one row taller.

## Versions

- Measurements: RecipeVacuum `c05fc91`, `c3cb053` (recorder); no layout change.

## Tests

- None: no change.

## Reopen if

- The details box gains room another way (fewer header lines), so three reagents still fit at 240 units.
