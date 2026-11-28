# 0061. Zone fishing facts are kept, never guessed into a level

- Date: 2026-11-25
- Status: accepted
- Scope: Tackletron
- Kind: data

## Context

The game keeps zone fishing levels on the server and the client has no table of them.

## Decision

Tackletron keeps facts per zone (`uiMapID`) and per subzone (area ID, read by position as Recipe Vacuum does), in `TackletronDB.zoneFishing` and `areaFishing`. Each holds the lowest catch, the lowest landed cast, the highest escape, the highest refusal, and catches and escapes per 5-point skill bucket so counts can be pooled later. The subzone's record is looked up first, then the zone's. Forever refuses a cast below base minus 4, the first skill with a catch chance above zero. Many escapes mean the skill is close to the minimum. No range is opened and the text uses game terms.

## Reasons

- On Classic-era rules as rebuilt by the emulators, a catch at effective skill s means the minimum is at most s, an escape means the no-escape level is above s, and the catch chance is skill minus base plus 5 percent (vmangos `GameObject.cpp`, `GAMEOBJECT_TYPE_FISHINGNODE`).
- The server looks up a subzone's own level first, then the zone's (same code).
- WCLBox's Forever fishing page lists "From 51 / 126 / 201 / 326", which fits every refusal and landed cast seen 2026-11-25; unverified at the edge.
- "Skill not high enough" (`SPELL_FAILED_LOW_CASTLEVEL`, no number) was seen at Theramore Isle at skill 28+25.

## Rejected

- Estimating a level from the zone's level range (`83714a8`, dropped in `086219b`).

## Versions

- Tackletron `2a3ee8f`, `a470f2d`, `70cc219`, `8ff6bd5`, `83714a8`, `086219b`

## Tests

- Specs "an escape at skill 68 (60 plus 8 from food) is kept for the zone", "a cast refused for low skill is kept: the zone's minimum is above 53", "in a subzone, a hook is kept under its area ID as well as the zone", "a catch below a refused skill: the refusal is dropped as wrong".
- Seen in game 2026-11-25.

## Reopen if

A cast lands below base minus 4, or Forever's thresholds differ from the community table.
