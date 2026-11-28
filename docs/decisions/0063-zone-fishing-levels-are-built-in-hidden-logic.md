# 0063. Zone fishing levels are built in, as hidden logic

- Date: 2026-11-27
- Status: accepted in part
- Scope: Tackletron
- Kind: data

## Context

A zone's fishing level is hidden from the client. The community's levels are wanted on for everyone without an opt-in, with the player's own play correcting them. Forever's new zones (Riverglades, Zephras Isle) have no data and must be learned from play.

## Decision

Zone levels ship built in and are on for everyone, using only the level of the zone the player stands in. This is the built-in exception to the toolkit's self found first rule (`standards.md` rule 11), beside Sparklescope's chests (0022). The page has no Fishing Sources rows. The level is hidden logic.

The player's own casts correct the shipped level and fill zones with no data. A refused cast puts the zone's level above that skill, a landed cast puts it at or below, and escapes and catches narrow it to one of the six Classic tiers.

The kit's share (`NewShare`) sends only zones with no built-in level. It is on by default, with one Share My Finds checkbox as in Sparklescope, and sends nothing until there is something new.

A chat line prints when the pole is on in a new zone, either entering a zone with it on or equipping it there, once per zone per login. It names one of three states for the player's skill, never a number. Possible means casts land and some fish get away. Impossible means the cast is refused. No data means the zone is uncharted. Easy, where no fish get away, prints nothing. A lure hint names the player's best lure when it would move them up a state. One Chat Alerts checkbox, on by default, covers Tackletron's repeating lines (need a lure, fight with pole on, new zone).

Open: the line's wording, modeled on the game's own gnome machines (Homing Robot OOX-17/TN, "Sensors detect spatial anomaly -- danger imminent!"). Not built yet.

## Reasons

- A zone's level is one server rule for every player, so a Self Found choice protects nothing. Every cast seen on Forever fits the shipped table. Dustwallow Marsh (130) refused at 53, Wetlands (55) landed at 53, Darkshore (-20) let fish get away at 27 (`docs/data.md` in Tackletron).
- Catch chance is skill minus zone base plus 5 percent (vmangos `GameObject.cpp`, case `GAMEOBJECT_TYPE_FISHINGNODE`). Forever refuses a cast below base minus 4 (seen in game). The tiers are 75 apart, so one refusal settles Impossible and about 20 casts without an escape settle Easy.
- The line names one of three states in simple words (easy, possible, impossible; only Possible and Impossible print, and zones with no data print too): a number adds nothing.
- Sharing only zones with no built-in level keeps most players from ever sending a row; the kit's share offers a revision number and sends rows only when a peer asks (`docs/sharing.md`).
- The data is cmangos/classic-db commit `13e9337`, table `skill_fishing_base_level`, GPL-3.0 like Tackletron; its README asks that its LICENSE travel with redistributions, so the license text must travel with the data.
- Zone and subzone mapping comes from wago.tools Forever 1.60.1.71037, `AreaTable` and `UiMapAssignment`.
- Sparklescope's chest list is the precedent for built-in data on for everyone (0022), and its sharing is the model for Share My Finds. Recipe Vacuum's Announce New Finds is the model for the checkbox (0043).

## Rejected

- A source choice, Learn Fishing Levels From, Self Found or Friends (no visible row; the level is the same for everyone).
- Public as a source.
- Sharing every zone (only zones with no built-in level need it).
- A percent, a fraction or a rating number in the line (three states are enough).
- The alert on first cast (the alert prints when a pole goes on in a new zone).

## Versions

- none yet; not built.
- Supersedes 0062 once built. Data tools live in Tackletron `tools/fishing_levels.py` (`7fdb81f`).

## Tests

- none yet; specs come with the build.

## Reopen if

Forever changes a zone's level, or the data's license terms change.
