# 0063. Zone fishing levels ship built in, with Self Found or Friends

- Date: 2026-11-27
- Status: accepted in part
- Scope: Tackletron
- Kind: data

## Context

A zone's fishing level is hidden from the client, and the owner wants the community's levels on for everyone without an opt-in, with the player's own play correcting them. Forever's new zones (Riverglades, Zephras Isle) have no data and must be learned from play.

## Decision

Zone levels ship built in and are on for everyone, using only the current zone's level. This is the built-in exception to the toolkit's self found first rule (`standards.md` rule 11), beside Sparklescope's chests (0022). The source choice becomes Learn Fishing Levels From, Self Found or Friends, default Friends, with Share My Finds through the kit's `NewShare` as Sparklescope does. Public goes away. The player's own catches, escapes and refusals augment or correct the shipped level, and so do friends' reports. A chat line prints when the pole is on in a new zone, either entering a zone with it on or equipping it there, once per zone per login. One Chat Alerts checkbox, on by default, covers Tackletron's repeating lines (need a lure, fight with pole on, new zone). Open, the rating name and form, since the owner does not want raw numbers in the line. Candidates are a percent, a fraction or a fish difficulty rating in the gnomish voice, and the owner asked for an example of each. Not built yet.

## Reasons

- The data is cmangos/classic-db commit `13e9337`, table `skill_fishing_base_level`, GPL-3.0 like Tackletron; its README asks that its LICENSE travel with redistributions, so the license text must travel with the data.
- Zone and subzone mapping comes from wago.tools Forever 1.60.1.71037, `AreaTable` and `UiMapAssignment`.
- Sparklescope's chest list is the precedent for built-in data on for everyone (0022), and Sparklescope's sharing is the model for Share My Finds.
- Recipe Vacuum's Announce New Finds is the model for the checkbox (0043).

## Owner's words

- "I think standing there is probably ok, but like chests we need the concept of shared, and self reported augmentation. I think first cast is probably better, but since it's a device being in the area might be ok. Is there a way we can send an alert in the chat from the Tackletron"
- "Is due is a stupid non human phrase, lean on simple, clean explanations"
- "Specific numbers is kind of weird. We could say a rating of, or some other fnomish nonsense. Line tension? Hook fidelity? I think we could relate it to how hard they fight, like a fish difficukty rating lol"
- "Show me example of each, we could make it a percent, some sort of fraction, gnomish it up"
- The owner chose "Pole on in a new zone" for when the alert prints, and "Chat Alerts" for the checkbox name (2026-11-27).

## Rejected

- Public as a source (goes away).
- The alert on first cast (the owner chose the pole on in a new zone).

## Versions

- none yet; not built.
- Supersedes in part 0062 (Public, the Self Found default); data tools live in Tackletron `tools/fishing_levels.py` (`7fdb81f`).

## Tests

- none yet; specs come with the build.

## Reopen if

The rating name and form are chosen, or the data's license terms change.
