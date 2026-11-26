# Quality bar

The checklist every Jig Boltgrip's Toolkit addon meets before a release. Each line is something to check, not something to agree with. How to meet it is in [standards.md](standards.md).

## Fits the game

- [ ] Every frame, control, icon, font, color and label is Blizzard's own, or is on a list of what is custom and why.
- [ ] It looks and behaves like part of the game's own window. Nothing native is replaced or restyled.
- [ ] Wording and capitalization follow Blizzard's. Labels use the game's own strings where one exists.
- [ ] Its chat lines never use one of the game's own chat colors (whisper, emote, system), and it changes nothing in normal chat or play outside its feature.
- [ ] Each pattern names the Blizzard code or established addon it follows.
- [ ] Where standing out and matching the game pull apart, it matches the game.

## Every way to play

- [ ] Every feature works with mouse and keyboard, and with a gamepad, both as first-class ways to play: nothing is reachable only one way, and neither feels like an afterthought.
- [ ] Both were checked in game before the release: mouse and keyboard on a desktop, and a gamepad (the Steam Deck).

## Does one job

- [ ] It has one purpose a player can say in a sentence.
- [ ] Every option, dependency, command and thing on screen can say what needs it.
- [ ] No setting exists for a taste few will change.
- [ ] Nothing is added to a Blizzard window that makes it busier than it has to be.
- [ ] It stores only what a feature reads.

## Quiet

- [ ] It says something only when it did something the player wants to know: one line, and it can be turned off.
- [ ] No window opens by itself.
- [ ] Diagnostics go to a log, not to chat.
- [ ] Development commands are stripped from releases and removed once their question is answered.

## Correct and honest

- [ ] Everything is identified by ID. Nothing depends on English text, so it works in every client language.
- [ ] What is not known shows as unknown, under the game's own word for it. Nothing is guessed.
- [ ] Facts are read only from data that has loaded. Nothing is saved from data that may be incomplete.
- [ ] Shipped data, saved data and caches each have one home. Shipped data is generated, never edited by hand.
- [ ] The edge cases are checked: several of a thing, the not-yet state, the long name, the other faction, no data at all.

## Resilient

- [ ] Missing, late or bad data, and a game update, make it slower, never broken.
- [ ] Every loop is bounded, and nothing is asked twice of something that will not answer.
- [ ] It decides before acting. It never hides what the game shows the player.
- [ ] It sits beside other addons: hooks run after Blizzard's code, nothing is stored on Blizzard's frames, and its few globals are listed.

## Fast

- [ ] Speed is measured in the game, not judged from the code. The working build logs its own timings.
- [ ] Nothing of ours takes a frame, measured on the first open as well as later ones.
- [ ] Every cache has a named reason it refreshes. Work per row and per redraw is cached or done only for what is on screen.
- [ ] Ordinary play costs next to nothing.

## Voice

- [ ] Every chat line is in one file and printed by the library: one action, exact facts, nothing that explains what the addon will do.
- [ ] The lines are modeled on real in-game text and copy none of it.
- [ ] A voiced line is the kit's: the gear mark, "Boltgrip's", the device name in its class color, the noise, then the report, in the family's teal (standards.md, "Voice").
- [ ] Settings and tooltips are in Blizzard's wording, not in the voice.

## Proven

- [ ] `luac`, `luacheck` and the offline tests pass, and a stripped release build still compiles.
- [ ] Tests run the addon's real code and each names the breakage it would catch.
- [ ] Everything has been seen working in the game. What has not is reported as untested.

## Kept in order

- [ ] Comments are a line or two. Explanations are in `docs/`.
- [ ] Working notes are not in the repository, and nothing in it is private.
- [ ] It carries the same library file, license, layout and standards as its sibling addons.

## How it was built

- [ ] Prior art and the game's own way were researched and cited before designing.
- [ ] Design questions were talked through with the owner before anything was built.
- [ ] Small requests got small changes, and what the owner approved was left alone.
- [ ] The owner's part of each test was kept short: the addon collects its own data.
- [ ] The owner always had a current, ordered list of what was needed from them.
- [ ] Nothing was committed, pushed or released without the owner's word.
