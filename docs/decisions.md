# Decisions

Every choice across the toolkit and its modules, in one place, grouped by kind of choice, so each can be revisited with its reasons in hand (owner, 2026-11-27: "a lot of these are the same class of choices and I don't like fragmentation"). Sections without a module name hold for every module; a module's own sections carry its name. Each entry gives the decision, why (with its data), what was rejected and what would reopen it, and the owner's words. Module sessions add their own entries here directly; it is docs only, so no `MINOR` change. The detail lives in the doc each entry points to.

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
- **No chat link that opens Settings** (2026-11-27, Buffulator): an addon link runs addon code (`LinkTypes.AddOn` to EventRegistry "SetItemRef", `ItemRefHandlersShared.lua:279`), and `Settings.OpenToCategory` from there is the same panel taint; Blizzard's own settings link calls it from Blizzard code (`ItemRefHandlers.lua:247`). Owner chose "Plain text line". Reopen if a safe way is proven on the Deck.
- **`/click` needs key-up handling, unproven** (2026-11-27, Buffulator): `/click` sends down=false, so a secure button with `ActionButtonUseKeyDown` on drops it unless `useOnKeyDown` is false or it handles AnyDown (`SecureActionButton_OnClick`, `SecureTemplates.lua`). Belongs with "Actions" above; check on the Deck.
- **Copy window on the gamepad** (2026-11-27, MINOR 75): it opens unfocused, so B closes it. A focused edit box kept B from closing it on the Deck.

## Data

- **Self found first, with built-in exceptions** (2026-11-27, [standards.md](standards.md) rule 11): shipped data shows only at the Public level. A module may ship data on for everyone where the owner names it, with a source choice of Self Found and Friends that augments it. Named so far: Sparklescope 6000's chest list and Tackletron's zone fishing levels. Owner: "for this one we ship with a list and everyone gets it"; "like chests we need the concept of shared, and self reported augmentation".

## Performance

- **No frame of ours over 5 ms; splits always advance** (2026-11-26): work spread across frames moves forward at least one item a frame, sized to the bar, and never gives up on a timer. Owner: "Capping is weird, slower computers would never get it". A Blizzard call that must stay in one frame is a named atomic exception, logged as such.
- **Don't fix edge cases that don't exist** (2026-11-27): an unseen failure is recorded as a known risk, not built against. Owner: "Don't fix edge cases that don't exist".

## Trainers (Recipe Vacuum)

- **Learned read: once per trainer, account-wide** (2026-11-27, `4dcc30e`, RecipeVacuum `docs/client-notes.md` "Trainers"):
  - **Decision:**
    - The learned ("used") services are read after the visible scan, once a visit.
    - A read that finds no rows is done, and done is saved per trainer for the whole account.
    - A trainer is read again only when the visiting character knows a recipe of that profession with no trainer source.
    - No profession gate, no purchase hook.
  - **Why:**
    - Each read flips Blizzard's "used" filter, and each flip rebuilds its list: 26 to 32 ms a pass on the Deck (log 2026-11-27 10:41, npc 1241).
    - Three passes over two visits found nothing, because the trainer taught Blacksmithing and the character had none.
    - Fable, Grok and Astra agreed on three things: the 0 was correct, the same-visit retry and the pre-scan trigger were bugs, and a hook adds nothing because the scan records rows before a purchase.
    - Owner: "I still think we need it"; "I don't think the gate is useful, it's only once anyway and is good for data gathering and if I want to switch professions by looking first"; "Does per character matter? I'd argue not".
  - **Rejected:**
    - Dropping the read (Astra).
    - A profession gate.
    - A `BuyTrainerService` hook.
    - Skipping when every known recipe has a source. Owner: "Not learning new recipes doesn't mean they'll never have them".
  - **Reopen if:**
    - The Learned Services [Read] test at a trainer whose recipes the character knows finds 0 rows; then the read itself is broken.
    - Flips show up as a measured cost.
- **Not built: trainer seed list** (2026-11-27): ship each trainer's spell IDs, flip only when a hidden seed spell lacks a source, and flag visible spells missing from the seed as new content. Owner: "I'd prefer not to, but worth thinking through". Reopen if flips become a measured cost.
- **Not built: trainer groups** (2026-11-27):
  - Trainers of one tier teach the same list. Owner: "journey man never teach different stuff usually ... The westfall odd girl is different".
  - Grouping them by identical spell-ID lists, never title text, would let one read or source cover the whole group.
  - Owner: "If it's too complicated we skip, it's a very minor cost".
  - Reopen if saved lists from several same-profession trainers turn out identical.

## Data (Recipe Vacuum)

- **Known recipes count as met** (2026-11-26): a recipe the account knows counts as discovered, with nothing shared. Owner: "If I know 75 recipes from the trainer ... Me knowing them means public doesn't matter, it's assumed since I learned it".
- **Difficulty re-read uncapped** (2026-11-27): a skill change is read again until every candidate answers. A recipe that never reports a difficulty would keep being re-read in 2 ms slices. All 89 of Corvus's recipes answered, so this is a known risk, not built against.

## Panel (Recipe Vacuum)

- **Skill-up arrows, not numbers** (2026-11-26): rows show Blizzard's arrows from `GetRecipeInfo().relativeDifficulty`; the required skill is in the details pane; the list sorts by required skill. Corvus gave 0 mismatches against the seed. Owner: "Arrows only, as now".

## Chests (Sparklescope 6000)

- **A shipped chest list, on for everyone** (2026-11-27, `d808714`, Sparklescope6000 `docs/data.md` "Chest list"):
  - **Decision:** `Data/Chests.lua` holds 642 object IDs of lootable world objects that are not herbs or ore, generated by `tools/chests.py` from cmangos classic-db (GPL-3.0) and Forever's `Lock` table. It counts for every player. Learn Chests From (Self Found, Friends) covers only what the list lacks: chests Forever added.
  - **Why:**
    - No in-game signal tells a chest before it is opened. The cursor (chests share the plain interact one with chairs), tooltips, vignettes, the Opening spell's range, the loot and world-loot checks, objects coming into range and the object's model all came back empty. A second sweep from Fable, Grok and Astra (the cursor with low-priority objects left out and in its other style, loot by GUID, the active-quest check, range, selection type, classification, level, the world and link tooltips) read the same for a chest, a chair, a mailbox and a quest crate (Sparklescope6000 `docs/design.md` "Chests").
    - It is an exception to the toolkit's rule 11 (public data is opt-in) because it lists fixed world objects, not what other players found. Owner: "Also public opting in to the public data set here doesn't make sense to me. I think for this one we ship with a list and everyone gets it".
  - **Rejected:**
    - The list as a Public stop of Learn Chests From (built first, `7c2b7cd`).
    - Guessing from English name words (precision 0.90, recall 0.30). Owner: "Duck typing in English only is rough".
    - Guessing from IDs near a known chest (precision 0.73). Owner: "Duck typing the ids feels even worse".
    - Model shapes: an object's model cannot be read in game.
  - **Reopen if:** a game build adds chests in bulk (rebuild the list), or a client update exposes an object's type, lock or model.
- **Quest loot teaches no chest** (2026-11-27, `5d4601d`, Sparklescope6000 `docs/design.md` "Chests"): loot that is only quest items teaches nothing, and a quest object learned before is forgotten when it is opened again. Why: Flintfire's Shipment, a quest crate, was learned on opening and sparkled. Owner: "a quest crate was getting our fireflies- flintfire shipment". Reopen if a real chest's loot turns out to be only quest items.
- **No sharing safeguard** (2026-11-27): a shared chest is kept as sent, with no "seen twice" rule, cap or forget button. Only friends running the addon can send one. Owner: "No, keep it as a known gap". Reopen if a wrong shared sparkle shows up.

## Look (Sparklescope 6000)

- **Fireflies** (2026-11-27, `467d4ed`, Sparklescope6000 `docs/development.md` "Effects"):
  - **Decision:** the sparkle is the world's fireflies (file 190731), two copies, slowed.
  - **Why:** the effect is drawn in a frame over the picked object's nameplate, not in the world, so anything that should sit on the object slides off it as the camera turns. Drifting fireflies hide that.
  - **Rejected:**
    - Eleven other small effects. Owner: "I still think fireflies are the best".
    - The game's own loot glitter (`particles/lootfx.m2`), even drawn as the game draws it with a size and drop per kind. Owner: "Various camera angles mess with it and I still think fireflies are better"; asked again, "Fireflies by default".
  - **Reopen if:** an addon can draw on an object in the world, or read the camera's tilt.
- **Open: zoom sizing and the scene camera** (2026-11-27): the zoom formula and the scene camera's angle match another addon Sparkles, which ships no licence. Owner: "I don't want their exact code, that's weird and has a smell, and they'd be able to tell". How to replace them is not decided ("TBD"). Every Deck log reads one zoom (5.55), but the owner never zoomed there, so a Mac session with the mouse wheel decides.

## Game settings (Sparklescope 6000)

- **No outlines** (2026-11-27, `2c14664`, Sparklescope6000 `docs/design.md` "Drawing"): Outline 0 to 3 and the engine's outline modes 1 and 2 each took effect, and none outlined the Interact Key's pick. Owner: "Outlines are dead to me". Reopen if a client update outlines the soft-interact target.
- **Enable Interact Key named on each row** (2026-11-27): the note says it is needed with keyboard and mouse only, since the controller picks without it, and it sits on every sparkle row so each tooltip reads alone in search. The toolkit holds the labels rule ("labels name the thing", owner 2026-11-27).

## Options (Sparklescope 6000)

- **Herbs and ore in one row** (2026-11-26): one "Herbs and Ore" checkbox, each kind shown only with its profession, so one row serves herbalists and miners alike. Owner: "Sounds herbs and ores be combined in settings?". Reopen if a player wants one without the other while knowing both.

## Scope (Buffulator)

- **One job: see, buff, thank** (2026-11-26):
  - **Decision:** a line naming who needs a buff of yours, one press that buffs them at the rank they can take, and an emote for players who buff you. Nothing else.
  - **Why:** the owner's three asks: "I need a way to know who needs a buff and to buff back that fits in with wow's ui/ux"; "Can we auto rank to the highest a person is allowed to get?"; "an emote to thank is fine". Owner: "Create it, my list only".
  - **Reopen if:** the owner adds a job.
- **Anyone nearby, from the start** (2026-11-26): the need scan covers you, your group, your target, your mouseover and players with friendly nameplates. Owner: "Anyone nearby from the start".
- **Name** (2026-11-26): Buffulator. Owner: "What about just Buffulator", then "Yeah". Rejected: Enhance-o-Scanner (the first build's name), and names about anything but seeing buffs. Owner: "the goal is a device to let the user see the buffs and be aware of them".

## Buffing (Buffulator)

- **One press, one cast, never on its own** (2026-11-26, Buffulator `docs/client-notes.md`):
  - **Decision:** Buff Next casts only when the player presses it. Group members, you and your target are cast on directly; anyone else through `/targetexact`, the cast, then `/cleartarget`.
  - **Why:** casting needs a hardware press. Owner: "It isn't taking over anything, but should purely be additive and not get in the way."
  - **Rejected:** casting on a timer or an event (the game refuses it).
- **Buff Next is a secure button, a key binding and a `/click` macro** (2026-11-27, `6251afb`):
  - **Decision:** the button holds the macro text, set out of combat. A Keybindings row presses it, and the Buff Next Macro [Make] row makes a one-line `/click` character macro for any bar. The macro's icon still follows the buff.
  - **Why:** every press-to-act module offers both, the same way (toolkit decision "Actions"). Owner: "Both, the same way".
  - **Rejected:** the character macro whose whole text was rewritten (`56ee88c`; owner then: "I think the macro makes the most sense right now considering our goals"), now replaced. A raised controller key (`c1061e1`; owner: "This isn't the same as fishing").
  - **Reopen if:** Buffulator `docs/client-notes.md` checks 17 to 19 fail on the Deck.
- **Rank: the best one they can take** (2026-11-26, Buffulator `docs/data.md`): the highest rank you know whose learn level is no more than 10 above theirs. A player whose level is unknown is passed over, never offered the top rank (`93cd6d2`). From the owner's report: a level 29 druid's top Mark of the Wild fails on players under 10.
- **PvP-flagged strangers: buffed by default, told once** (2026-11-27, `afaf8a7`, `cairn:5rkag`):
  - **Decision:** Buff PvP-Flagged Players is on by default. The first time the next player would flag you, one chat line says so before the press and names the setting. Turned off, flagged strangers are skipped while you are unflagged. Group members are always buffed.
  - **Why:** Owner: "PvP servers are essentially always on"; "Just make sure it allows buffing by default"; on the warning: "I think the first time it happens we log a chat message and point them to the settings maybe?", then "Plain text line".
  - **Rejected:**
    - Skipping flagged strangers by default.
    - A one-time Yes/No dialog (`7efed80`): it sets the controller's bindings tainted (toolkit decision "`StaticPopup_Show` banned").
    - A chat link that opens the options: an addon link runs addon code, and opening Settings from there is the same taint.
  - **Reopen if:** a safe way to open Settings from a link is proven on the Deck.

## Thanks (Buffulator)

- **On by default, `/thank` alone** (2026-11-27, `bcabf00`):
  - **Decision:** Thank Players Who Buff You starts on with only `/thank` checked. Party and raid thanks start off.
  - **Why:** Owner: "Buff pvp, and thank with the default thank emote should be the default". Earlier, party: "Party should be off by default".
  - **Rejected:** thanks off by default (owner, 2026-11-26: "The thank needs to be off by default"), replaced by the decision above. The toolkit's rule that anything speaking for the player starts off; the owner's call overrides it here.
- **Emotes: checkboxes, picked at random** (2026-11-26, Buffulator `docs/emotes.md`):
  - **Decision:** eight game emotes, each a checkbox labeled with the game's own slash command. Each thanks picks one checked emote at random, never the same twice in a row. On the page: `/thank` first, then the game's chat-menu order.
  - **Why:** Owner: "I do like the multi select option if we could organize and design them properly and choose randomly"; "I'd rather show and allow organizing them better with in game strings". The order follows the toolkit's options standard (owner: "Collaborate with all the addon agents").
  - **Rejected:** a dropdown (it breaks the controller; toolkit decision on dropdowns). Typed emote names ("prone to error and I don't like that"). Several checkboxes across one row (no Blizzard control for it).
  - **Reopen if:** Blizzard's controls gain a several-across checkbox row, or a custom `/me` thanks is wanted (the emote test button is still open).
- **Delay: Quick 1 to 3 s, Relaxed 3 to 5 s** (2026-11-26, Buffulator `docs/emotes.md`):
  - **Why:** a person needs about 0.2 to 0.5 s to react and choose, and about 1.2 s to type `/ty` and Enter (sources in emotes.md). Owner: "I also want to think about a jitter in response times"; "We may only need two"; "Quick 1-3 is good, relaxed should be 3-5 probably".
  - **Rejected:** a fixed delay, and three choices.
- **Many buffs, one thanks** (2026-11-26, Buffulator `docs/emotes.md`):
  - **Decision:** each new buff restarts the wait, up to 10 s after the first. One player gets the emote aimed at them; two or more get one emote at nobody, with the same random pick.
  - **Why:** Owner: "If we get multiples in N time do a generic non targets emote?"; "buffs within n time reset the timer to thank, then you hit everyone with a thanks"; "We emote to a specific unit, and without a selection it just happens".
  - **Rejected:** a cap on thanks ("I don't know about a cap, that feels weird"), and preferring `/thank` for groups ("That's not for you to decide").
  - **Reopen if:** the 10 s limit is wrong in a busy hub (a guess to check).
- **Once per buff** (2026-11-26): a player counts as thanked until the buff they gave runs out; your death clears it. Owner: "once a minute is still annoying imo"; "Individuals should get a time equivalent to their buff time applied, unless the player dies or something?"
- **Not while away or stealthed** (2026-11-27, `bb440df`): a thanks is dropped while you are AFK or stealthed. Combat still thanks. Owner: "Combat seems ok to me, no afk, stealth seems ok but better to avoid it". Rejected: a setting for it.

## Open questions (Buffulator)

The overnight review's questions still with the owner: skip a player after a failed cast, rebuff early, a voiced macro line, the macro on mouse and keyboard, full character macros, a fail-closed stranger macro.

## Scope (AutoOmniadjustor)

- **Three actions: Disenchant, Pick Lock and keys, Comprehend Scroll** (2026-11-25):
  - **Decision:** the module acts on bag items with Disenchant (13262), Pick Lock (1804) or a key that opens the lock, and Comprehend Scroll (1296017). Nothing else.
  - **Why:** the owner asked for "anything that happens on items in the inventory from a profession, maybe mage comprehension". These three are the Forever 1.60.1 spells that take a bag item as their target (AutoOmniadjustor `docs/data.md`).
  - **Rejected:** Scrap Item. Owner: "Research scrap, I don't know about it, but o expect skip to start".
  - **Reopen if:** the owner asks for another on-item spell, or Scrap Item turns out to fit.

## Safety (AutoOmniadjustor)

- **The use key acts only while the marks are on** (2026-11-27, `154ccec`):
  - **Decision:** with the marks off, the use key does nothing, and the working log says "marks off". With them on, it acts on the selected or hovered item, which always carries the circling lights.
  - **Why:** the Fable review (finding 4) showed one stray right stick press with the bags open would start Disenchant on an unmarked item. The only gate was equipment sets. Owner: "Only with marks on".
  - **Rejected:** acting with the marks off (the first flow). An ignore list, and a quality cap: both are deferred, and not needed once the mark gate holds.
  - **Reopen if:** the extra press each bag open is felt as friction in play.
- **Equipment set items are never acted on; no other gate yet** (2026-11-25): owner: "TBD, for now no gate other than equipment sets". The game itself refuses a disenchant above the player's skill, with its own error. Reopen if a wrong item is ever acted on.

## Keys and marks (AutoOmniadjustor)

- **Two keys: marks, then use** (2026-11-26):
  - **Decision:** the marks key shows every item the use key can act on, and the use key acts on the selected item. On a controller, with the bags open and no key of the player's own, the left stick press is the marks key and the right stick press is the use key.
  - **Why:** owner: "With bags open I want a key to show me all eligible items"; "2: L3 toggles, R3 acts". The gamepad bags leave both stick presses free (AutoOmniadjustor `docs/client-notes.md`).
  - **Rejected:** hover-to-reveal, as another addon does it. Owner: "Molina makes me hover and I hate it".
  - **Reopen if:** the stick press overrides lose to the gamepad bags' focus on the Deck.
- **Marks: autocast corners, a color per action** (2026-11-26): corners on every usable item, circling lights on the selected one. Disenchant uses the epic purple, Pick Lock and keys the rogue color, Comprehend Scroll the mage color. Owner: "Maybe a slightly different color per thing". Reopen with the open questions on color-blind players and on purple against epic borders (the Grok and Fable reviews).
- **Overlays are our own frames, anchored over Blizzard's buttons** (2026-11-27, `adc5296`): the toolkit's Gamepad UI rule puts nothing of ours on Blizzard's frames. The first version made each mark a child of the item button. Reopen if the marks don't sit on top or follow a raised bag on the Deck.

## Chat (AutoOmniadjustor)

- **One line, once ever, per borrowed stick press; no Announce checkbox** (2026-11-27, `adc5296`, `f43f5b1`): the toolkit's Game settings rule asks for one line the first time a module changes something the player didn't set. Owner: "Keep the draft". Once-ever lines need no Announce checkbox (toolkit options.md, 55318d0).

## Name (AutoOmniadjustor)

- **Auto-Omniadjustor** (2026-11-26): owner: "In game gnomish engineering terms", then "AutoOmniadjustor". The spelling matches the in-game Gyromatic Micro-Adjustor.
  - **Rejected:** Octo-names, Omnispanner, Discombobulator, Decombobulator, Auto-Omnitool.

## Open (AutoOmniadjustor)

- **Deck taint: SetPreferredGamepadInteractTarget blocked** (2026-11-27):
  - **Seen:** "blocked because of taint from AutoOmniadjustor" at login, on the first Options open, when the game menu closed, and when a radial opened (Deck `Logs/taint.log`, 07:02 and 07:06). The owner disabled the addon.
  - **Known:** the blocked call is `MainActionBarFrame.lua:373` `UpdateInteractIcons`, reached through `InputBindingManager` `CheckCoreBindingActive`. Auto-Omniadjustor loads first alphabetically, so its embedded toolkit copy ran for every module. The log shows Tackletron's options built by `AutoOmniadjustor/Libs/JigBoltgripToolkit`, so the blame can belong to shared toolkit code.
  - **Ruled out:**
    - callback registrations: `CallbackRegistry` has a taint barrier for event keys
    - the binding-name reads in the log: only the Settings panels read them
    - the combat binding owner: a probe by the toolkit session
    - the autocast overlay mixin
  - **Next:** with Auto-Omniadjustor disabled, open and close Options and the game menu, then open a radial. An error naming another addon means the toolkit. No error means this module.
