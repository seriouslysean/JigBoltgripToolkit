# Clean paths: make Blizzard's UI act without taint

WoW Forever 1.60.1 (Interface 16001), Camelot overrides, Gamepad UI. Read this before any code that opens, clicks or changes something of Blizzard's. Every `file:line` is under `Interface/AddOns/` of [Gethe/wow-ui-source, `forever`](https://github.com/Gethe/wow-ui-source/tree/forever). Evidence labels:

- DECK: measured on the Steam Deck (decision 0068 and client-notes.md).
- SRC: read in Blizzard's source for this client.
- WEB: warcraft.wiki.gg, fetched 2026-11-27.
- UNVERIFIED: inferred, neither in source nor on the Deck. Section E gives each one's smallest Deck test; run it before relying on the pattern, and move the row to DECK with the result.

The source tree has no `GlobalStrings`, so a typed slash string (`SLASH_X1`) is read in game; section C gives the command key and where its typed string comes from.

## A. Rule of thumb

1. Whoever starts the Lua execution decides taint. Addon code that calls a Blizzard function runs it tainted, and everything it writes or selects is tainted.
2. Hand Blizzard data, not code: a button attribute, a macro line naming a Blizzard slash command, a hyperlink, a binding name, a C API that fires an event. Blizzard's own handler then runs secure.
3. Let the engine or Blizzard start the call: a press on a `SecureActionButtonTemplate`, a binding, a hyperlink clicked in a Blizzard chat frame, an event. Our code runs before (`PreClick`) or after (`PostClick`, `hooksecurefunc`), never inside.
4. Script text is code: `/run`, `/script`, `/dump` and any `macrotext` that runs them taint (DECK: `ForceTaint_Strong`). A slash command whose handler is Blizzard's (`/mappin`) does not (DECK).
5. Reading is free (post-hooks, events, `C_*` getters). Writing into Blizzard tables, frames, menus, panels, `UIPanelWindows`, SmartNavigation state, or calling `ShowUIPanel`/`HideUIPanel`, is where taint starts. B lists Blizzard's few sanctioned write doors.
6. In combat no protected frame can be shown, hidden, moved, enabled or given attributes. Hide and unanchor ours on `PLAYER_REGEN_DISABLED`, place them again on `PLAYER_REGEN_ENABLED`, and grey out the control they serve (standards.md, "Gamepad UI").

## B. Clean patterns

| # | Pattern | Mechanism | What it can do | Citation | Status |
|---|---|---|---|---|---|
| B1 | Secure button, `type="click"` + `clickbutton=<Blizzard button>` | `SECURE_ACTIONS.click` calls `delegate:Click(button)` when the delegate has no access constraints and no `ScriptedInput` forbidden aspect | Runs the Blizzard button's own OnClick untainted. Any named Blizzard button: micro menu (`CharacterMicroButton`, `ProfessionMicroButton`, `PlayerSpellsMicroButton`, `TalentMicroButton`, `SpellbookMicroButton`, `AchievementMicroButton`, `QuestLogMicroButton`, `GuildMicroButton`, `LFDMicroButton`, `CollectionsMicroButton`, `EJMicroButton`, `MainMenuMicroButton`), `MinimapCluster.ZoneTextButton` | SRC `Blizzard_FrameXML/SecureTemplates.lua:557-564`; micro buttons `Blizzard_MicroMenu/Mainline/MainMenuBarMicroButtons.xml:51-344`; Camelot: `ProfessionMicroButton` toggles `ProfessionsFrame` (`Blizzard_MicroMenu/Camelot/MainMenuBarMicroButtonsOverrides.lua:33`) | ZoneTextButton: DECK clean. Other buttons: SRC only, same mechanism (UNVERIFIED on Deck, test E1) |
| B2 | Same, via SmartNavigation's gamepad press | `SmartNavigationMixin:Click` -> `PerformClick` -> `SecureHelper.SecureCallOptionalFunction(button,"MouseDown"/"MouseUp")`; a field `OnSmartNavClick` on the button replaces the click | The gamepad A press clicks any focusable `Button`, including our own secure button; addon `PreClick` runs tainted but does not taint the secure OnClick | SRC `Blizzard_GamepadSmartNavigation/SmartNavigation.lua:1639-1652`; `SecureHelper.lua:206-210` | DECK clean (map opened, bags and game menu clean after; RecipeVacuum 595d930) |
| B3 | Secure button, `type="macro"`, `macrotext="/<blizzard slash> args"` | `SECURE_ACTIONS.macro` -> `C_Macro.RunMacroText` -> `SetMacroExecuteLineCallback` (Blizzard) -> private `MacroEditBox:SendText` -> `ParseText(1)` -> `hash_SecureCmdList` then `hash_SlashCmdList` | Any slash handler that Blizzard registered (section C). Macro line max 255 characters (WEB SecureActionButtonTemplate) | SRC `SecureTemplates.lua:450-463`; `Blizzard_ChatFrameBase/Shared/MacroExecutionManager.lua:1-29`; `ChatFrameEditBox.lua:250-283` | `/mappin` DECK clean; `/run` DECK taints. Other commands UNVERIFIED (test E2) |
| B4 | `/mappin <uiMapID> <x> <y>` (x, y are percent, 0-100, one decimal) | Handler validates, `C_Map.SetUserWaypoint`, then `OpenMapToUserWaypoint` -> `OpenWorldMap(waypoint.uiMapID)` | Sets the pin AND opens the world map on the PIN'S zone (not the player's) with a ping. Fails silently if `C_Map.CanSetUserWaypointOnMap(mapID)` is false | SRC `Blizzard_SharedMapDataProviders/WaypointLocationDataProvider.lua:185-229`, `Blizzard_WorldMap/Blizzard_WorldMap.lua:1454-1488` | DECK clean (38 pad moves, bags, game menu after; RecipeVacuum b7c1fc8, fd82f53) |
| B5 | Secure button types that act on game state with plain attributes | `SECURE_ACTIONS` table: see section "SECURE_ACTIONS" below | Cast, use item, toy, equipment set, target, focus, world marker, action bar page, outfit, housing teleport, `click`, `attribute` | SRC `SecureTemplates.lua:262-665` | SRC (not tested on Deck) |
| B6 | `SetOverrideBinding(owner, true, key, "<BINDING NAME>")`, `SetOverrideBindingClick(owner, true, key, "<global button name>", button)`, `SetOverrideBindingMacro` | The client runs the binding body (Blizzard Lua in `Bindings_*.xml`) from the key or pad press, not from addon code. Override bindings outrank the gamepad bar context (client-notes) | Pad or key -> Blizzard toggles: `TOGGLEPROFESSIONBOOK` -> `ToggleProfessionsBook()`, `TOGGLEWORLDMAP`, `TOGGLEQUESTLOG`, `TOGGLESPELLBOOK`, `TOGGLETALENTS`, `TOGGLEACHIEVEMENT`, `TOGGLECOLLECTIONS*`, `TOGGLEFRIENDSTAB`, `TOGGLEGAMEMENU`, `TOGGLEENCOUNTERJOURNAL`, and `CLICK <button>:<mouse button>` to any named button. Out of combat only for addon owners | SRC `Blizzard_FrameXML/Bindings_Camelot.xml:1169-1271`; restricted-snippet equivalent `Blizzard_RestrictedAddOnEnvironment/RestrictedFrames.lua:545-596` | UNVERIFIED on Deck (test E3). Override-over-pad rule: client-notes, Tackletron 2026-11-26 |
| B7 | Hyperlinks the player clicks in a BLIZZARD chat frame | `ChatFrameMixin:OnHyperlinkClick` -> `SetItemRef` -> `LinkUtil.ProcessLink` -> registered handler, all Blizzard code | See link table below. `|Hworldmap:...|h` sets the waypoint and opens the map on its zone (`WorldMapWaypoint` handler); `|Haddon:...|h` fires `EventRegistry "SetItemRef"` for addons | SRC `Blizzard_ChatFrameBase/Shared/ChatFrame.lua:19-25`; `Blizzard_UIPanels_Game/Mainline/ItemRef.lua:6-26`; `Mainline/ItemRefHandlers.lua`; `Shared/ItemRefHandlersShared.lua`; `Blizzard_SharedXML/LinkUtil.lua:1-65,170-205` | SRC only (UNVERIFIED on Deck, test E5). Whether a gamepad can click a chat link is also unverified |
| B8 | C API that asks the client, UI answers on an event | `C_TradeSkillUI.OpenRecipe(recipeID)` / `OpenTradeSkill(skillLineID)` fire `OPEN_RECIPE_RESPONSE` / `TRADE_SKILL_SHOW` / `TRADE_SKILL_LIST_UPDATE`; Blizzard's frame handler runs `ShowUIPanel` itself | Open Professions to a recipe without addon code touching the frame. Blizzard's own objective tracker does exactly this call | SRC `Blizzard_ObjectiveTracker/Blizzard_ProfessionsRecipeTracker.lua:40-52`; `Blizzard_Professions/Blizzard_ProfessionsFrame.lua:134-202`; `Blizzard_Game/Mainline/EventImplementation.lua:475-477`; docs `Blizzard_APIDocumentationGenerated/TradeSkillUIDocumentation.lua:1103,1113` (no `HasRestrictions`) | UNVERIFIED (test E4). Needs `Blizzard_Professions` loaded; see trap D8 |
| B9 | Settings open through the same pattern | `Settings.OpenToCategory` -> `C_SettingsUtil.OpenSettingsPanel` (flagged `HasRestrictions`) -> event `SETTINGS_PANEL_OPEN` -> `SettingsPanelMixin:OnEvent` selects the category | Open the panel to a category id. Client-notes already record the Deck blocked a version of this | SRC `Blizzard_Settings_Shared/Blizzard_Settings.lua:144-146`, `Blizzard_SettingsPanel.lua:145-153` | UNVERIFIED (kit notes: untested alone; test E6) |
| B10 | Post-hooks and events to read state | `hooksecurefunc`, `HookScript`, `EventRegistry:RegisterCallback`, `EventUtil.*`, `RegisterEvent` | Read Blizzard state and react. Callbacks run through `securecallfunction`/`secureexecuterange`, so a tainted callback does not taint the trigger | SRC `Blizzard_SharedXMLBase/CallbackRegistry.lua:1-3,184-` ; WEB Secure_Execution_and_Tainting (post-hooks cannot taint the original) | Kit rule + SRC |
| B11 | Blizzard's addon-facing SmartNavigation helpers | `SecureHelper:SetSecureValue` and `:WrapFunction`: tainted callers pass values through an attribute RPC that validates and sets them from secure code (allowed out of combat, `IsSecureOrOutOfCombatRestriction`) | `SmartNavigation_MarkFrameIgnored/Focusable/SetButtonFrame/MarkFrameSubSection/MarkFrameBlockingSmartNavClick/SetCustomCursorAnchorPointForFrame/UseVerticalCursorForFrame`, `AddJumpNavigationOverride`, `AddBidirectionalJumpNavigationOverride`, `ClearJumpNavigationOverrides*`, `RegisterOutgoingDirNavCallback`; wrapped methods `SetTargetButtonForFrame`, `SelectFirstButton`, `SelectTopLeftButton`, `ShowCursor`, `HideCursor`, `RefreshButtonGroups`, `HandlePanelOpen`, `SetScrollFrameForFrame`, `SetWrapping`, `SetUseGridNavigation`, `SetRightStickScrollingEnabled` | SRC `Blizzard_GamepadSmartNavigation/SecureHelper.lua:1-224`; `Utility.lua:18-180,414-600`; `SmartNavigation.lua:274-1797` (list in grep of `WrapFunction`). `SelectButton` itself is NOT wrapped (`EnsureIsSecure`, line 652) and its own comment says callers should use `SetTargetButtonForFrame` | Kit already uses jump overrides (client-notes). The rest UNVERIFIED on Deck (test E7). Wrapped calls validate the CALL, not the values: reading a tainted argument inside can still taint |
| B12 | Tooltips from addon code | Blizzard promotes tooltip data accessors to secure delegates "to allow tainted code to show standard tooltips" | `GameTooltip:SetItemByID/SetSpellByID/...` via `C_TooltipInfo` | SRC `Blizzard_SharedXMLGame/Tooltip/TooltipDataHandler.lua:489-503` | SRC |
| B13 | `UISpecialFrames` | Name list read by `CloseSpecialWindows`, run via `securecall` | Esc closes our frame | SRC `Blizzard_UIParentPanelManager/Shared/UIParentPanelManager.lua:1093-1168`; kit standards | Kit rule |
| B14 | `|Haddon:...|h` private links | `LinkTypes.AddOn` handler triggers `EventRegistry:TriggerEvent("SetItemRef", link, text, button, frame)` | Our own click targets inside Blizzard chat text; our callback runs isolated | SRC `Shared/ItemRefHandlersShared.lua:279` | SRC (UNVERIFIED on Deck) |
| B15 | Restricted environment (SecureHandlers) | Protected-frame snippets run in a sandbox with `Run`, `SetAttribute`, `Show/Hide` (protected frames, combat-safe), `SetBinding*`, `CallMethod` (forces insecure) | In-combat state changes on OUR protected frames; override bindings; cannot touch Blizzard panels (`GetFrameHandle` only for protected frames / handles we pass) | SRC `Blizzard_RestrictedAddOnEnvironment/*` (on disk) | SRC |
| B16 | CVars through `C_CVar` / console | `SetCVar` needs `RequiresValidAndPublicCVar`, non read-only, non secure CVar; args `NotAllowed` secret | Data-only toggles Blizzard UI reads (`ActionButtonUseKeyDown`, etc.) | SRC `Blizzard_APIDocumentationGenerated/CVarDocumentation.lua:131-136` | SRC |

### SECURE_ACTIONS (SecureTemplates.lua)

| type | Attributes | Does | Line | Note for addons |
|---|---|---|---|---|
| `menu` | `menu-function` | `ExecuteAttribute` of a function attribute | 262 | Function is addon code: runs insecure. Do not use for Blizzard menus (kit rule) |
| `togglemenu` | `unit` | `UnitPopup_OpenMenu(which, {ownerFrame=self, unit})` | 269 | Opens Blizzard's unit popup from a secure path. UNVERIFIED under Gamepad UI (menus took gamepad focus and tainted when addon-built) |
| `actionbar` | `action` (n, `increment`, `decrement`, `a,b`) | `C_ActionBar.SetActionBarPage` | 322 | |
| `action`, `actionrelease` | `action`, `actionpage`, ID | `UseAction`, flyout toggle | 341, 362 | |
| `pet`, `flyout`, `multispell` | `action`/`spell` | `CastPetAction`, `SpellFlyout:Toggle`, `SetMultiCastSpell` | 370-395 | |
| `spell` | `spell` (id or name), `unit` | `CastSpellByID/Name` | 396 | |
| `toy` | `toy` (id or name) | `UseToy/UseToyByName` | 407 | |
| `item` | `item`, `unit` (or deprecated bag/slot) | Equip or use via `SecureCmdUseItem` | 418 | |
| `equipmentset` | `equipmentset` (name) | `C_EquipmentSet.UseEquipmentSet` | 441 | |
| `macro` | `macro` (id/name) or `macrotext` | `RunMacro` / `C_Macro.RunMacroText` | 450 | See B3; `/run` taints |
| `cancelaura`, `leavevehicle`, `destroytotem`, `stop` | spell/index/slot | Cancel aura, `VehicleExit`, `DestroyTotem`, `SpellStopTargeting` | 471-505 | |
| `target`, `focus`, `assist` | `unit` (`none` clears) | `TargetUnit/ClearTarget`, `FocusUnit`, `AssistUnit` | 506-530 | |
| `maintank`, `mainassist` | `action` set/clear/toggle, `unit` | `SetPartyAssignment` | 545-556 | |
| `click` | `clickbutton` | `delegate:Click(button)`; blocked for access-constrained or `ScriptedInput`-forbidden delegates | 557 | B1 |
| `attribute` | `attribute-frame`, `attribute-name`, `attribute-value` | `frame:SetAttribute(name, value)` | 566 | Writes an attribute on any frame from secure code; the value is still ours. Writing to a Blizzard frame is UNVERIFIED and against kit rules |
| `raidtarget` | `marker`, `action` | `SetRaidTarget` | 582 | |
| `worldmarker` | `marker`, `action` set/clear/toggle | `PlaceRaidMarker/ClearRaidMarker` | 605 | |
| `teleporthome`, `returnhome`, `visithouse` | house GUID attributes | `C_Housing.*` | 623-648 | |
| `outfit` | `action`, `outfit-index` | `C_TransmogOutfitInfo.ChangeToOutfit/ClearOutfit` | 650 | |
| custom `_<type>` / `rawget(self,type)` | function or snippet string | Function: `forceinsecure()` first (runs tainted). String: `SecureHandler_OnClick` restricted snippet | 730-757 | |

Click rules (SRC `SecureTemplates.lua:759-826`):

- Attributes can be set only out of combat on a protected (secure) button; `SecureActionButtonTemplate` makes the button and its parents protected (WEB). Protected frames cannot be shown, hidden, moved or enabled from addon code in combat (WEB). Hide protected buttons before combat; pressing one in combat is unmeasured (E9).
- Press timing: `useOnKeyDown = not isSecureMousePress and (attribute useOnKeyDown, else CVar ActionButtonUseKeyDown, or pressAndHoldAction)`. The action fires on the DOWN event when `useOnKeyDown`, otherwise on the UP event. So `RegisterForClicks` must include the event that will fire: register `"AnyUp","AnyDown"` and set the `useOnKeyDown` attribute explicitly, or an AnyUp-only button does nothing when the CVar says key-down (line 792-811). The Deck log showed `down=true`, i.e. the pad press arrived as a down event.
- `typerelease` and `pressAndHoldAction` are the release-side variants (line 691-757).

### Hyperlink handlers (all `LinkUtil.RegisterLinkHandler`, Blizzard code, run when a link is clicked in a Blizzard chat frame)

| Link type | Opens or does | File:line |
|---|---|---|
| `worldmap` | `C_Map.SetUserWaypoint` + `OpenMapToUserWaypoint` (map on the pin's zone) | `Mainline/ItemRefHandlers.lua:219` |
| `worldquest` | `OpenWorldMap()` | `Shared/ItemRefHandlersShared.lua:78` |
| `eventpoi` | `OpenMapToEventPoi(id)` | `Mainline/ItemRefHandlers.lua:291` |
| `talentpane`, `honortalent` | `PlayerSpellsUtil.OpenToClassTalentsTab()` | `Mainline/ItemRefHandlers.lua:72,89` |
| `specpane` | `PlayerSpellsUtil.OpenToClassSpecializationsTab()` | same |
| `talentbuild` | `PlayerSpellsUtil.InspectLoadout` | same, TalentBuild |
| `transmogappearance`, `transmogset`, `customset`, `transmogillusion` | Collections wardrobe or dress-up | same |
| `mountequipment` | `ToggleCollectionsJournal(MOUNTS)` | same |
| `battleground`, `pvpbgs` | PvP UI | same / shared |
| `lfd` | `ToggleLFDParentFrame()` | shared |
| `calendarEvent` | Calendar to the event | Mainline handlers |
| `community`, `clubTicket`, `clubFinder` | Communities | same |
| `journal` | Adventure Guide | same |
| `perksactivity`, `initiativetask`, `housingdecor`, `housingblueprint` | Journal / housing dashboards | same |
| `lootHistory` | Loot history to an encounter | same |
| `death` | Death recap | Shared |
| `player`, `BNplayer` | Whisper / who / friend menu (right click = menu) | same / shared |
| `storecategory`, `aadcopenconfig` (Settings social page) | Store / Settings | same |
| `item`, `spell`, `quest`, `achievement`, `enchant`, `trade`, `unit`, `currency`, ... | No registered handler: falls through to `ItemRefTooltip` (`ShowUIPanel(ItemRefTooltip)`; modified click: chat insert / dress-up) | `ItemRef.lua:6-26` |
| `addon` | `EventRegistry "SetItemRef"` for addons | `Shared/ItemRefHandlersShared.lua:279` |

`LinkUtil.RegisterLinkHandler` refuses a duplicate type (assertsafe), so an addon cannot replace a Blizzard handler (SRC `LinkUtil.lua:198-210`). Quest and achievement links open no panel by themselves here (they show the ref tooltip); there is no `quest`/`achievement` handler in `Mainline/ItemRefHandlers.lua` or the shared file.

### API documentation flags (SRC `Blizzard_APIDocumentationGenerated`)

| Flag | Meaning | Evidence |
|---|---|---|
| `SecretArguments = "AllowedWhenUntainted"` | Arguments may be secret values only when the call is untainted. 3686 functions | Counts by grep; semantics UNVERIFIED beyond the name |
| `SecretArguments = "AllowedWhenTainted"` / `"NotAllowed"` | Secret args allowed only from tainted code / never | same |
| `HasRestrictions = true` (288 functions) | Function carries a restriction predicate (`Predicates` entry `HasRestrictions`, type Precondition, FailureMode ReturnNothing, in `ActionDocumentation.lua:10-13`). It marks `OpenWorldMap`, `C_SettingsUtil.OpenSettingsPanel`, `C_Macro.RunMacroText`, `C_FriendList.SendWho/AddFriend`, `C_Calendar.AddEvent`, `C_CraftingOrders.PlaceNewOrder/ClaimOrder`, guild info setters, `CreateSecureDelegate`. The wiki tags `AssistUnit` (a protected function) the same way. | The exact rule (protected, hardware event, or addon-restriction state) is UNVERIFIED: no definition ships on disk and the wiki template page has none. DECK shows it does NOT forbid the call: tainted `OpenWorldMap` ran (and tainted afterwards), and `RunMacroText` ran from a secure button. Treat the flag as "do not call from addon code" not as "will error" |
| `RequiresValidAndPublicCVar`, `RequiresNonSecureCVar`, `RequiresNonReadOnlyCVar` | `SetCVar` preconditions | `CVarDocumentation.lua:131-136` |
| `ForbiddenAspect` enum (15 values) | Per-object restrictions; `ScriptedInput` = synthetic input (`Click`) forbidden. `/click` and `type="click"` check it | `ForbiddenAspectConstantsDocumentation.lua:13-27`; `SlashCommands.lua:735` |
| `C_RestrictedActions` | `AddOnRestrictionType`: Combat, Encounter, ChallengeMode, PvPMatch, Map, Chat; `CheckAllowProtectedFunctions` | `RestrictedActionsDocumentation.lua`, `...ConstantsDocumentation.lua:26-31` |
| `CreateSecureDelegate` | Wraps a function so tainted callers run it untainted; Blizzard uses it for tooltips and unit frames; `EnvironmentCleanup.lua:277` sets it to `nil` after load, so addons cannot use it | `FrameScriptDocumentation.lua:113-129`; `Blizzard_EnvironmentCleanup/Mainline/EnvironmentCleanup.lua:277` |

## C. Slash commands useful from a secure macro

How the handlers run (SRC): `ChatFrameEditBoxBaseMixin:ParseText(1)` checks `hash_SecureCmdList` first (Blizzard-only list, `SlashCommandsRegistry.lua:1-13`), then `hash_SlashCmdList` (public). `C_Macro.RunMacroText` from a secure button reaches both through the private `MacroEditBox` (`MacroExecutionManager.lua`). So EVERY command below is reachable from a macro. Secure (S) vs plain (P) only decides who may register the command, not whether a macro can run it. Registration is filtered by `C_GameRules.GetActiveGameMode()` (`SlashCommands.lua:253-300`); Forever behaves as Standard (all categories), shown by `/mappin` working.

Typed-string column: `W` = on warcraft.wiki.gg Macro_commands (WEB), `S` = Deck/SRC-confirmed from `SLASH_MAPPIN1` use, `?` = key confirmed in source but the typed string is not on disk or the wiki page (UNVERIFIED; read it from `_G["SLASH_"..KEY.."1"]` in game).

Reading the hints: `serves` = would serve an addon, `n` = not useful.

| Key | Typed | Args | Opens or does | File:line | S/P | Serves |
|---|---|---|---|---|---|---|
| MAPPIN | `/mappin` S | `<mapID> <x%> <y%>` | Sets waypoint, opens map on that zone | `WaypointLocationDataProvider.lua:213` | P | serves (DECK clean) |
| CLICK | `/click` W | `<globalFrameName> [button] [down]` | `button:Click`; refused if access-constrained or ScriptedInput forbidden | `SlashCommands.lua:726-743` | S | serves: any Blizzard button (B1 by macro) |
| CALENDAR | `/calendar` W | none | `Calendar_LoadUI`, `Calendar_Toggle` | `Mainline/SlashCommandsOverrides.lua:191-207` | P | serves |
| ACHIEVEMENTUI | `/achievements`? W | none | `ToggleAchievementFrame` (needs completed achievement or guild) | `SlashCommands.lua:1357-1371` | P | serves |
| MACRO | `/macro` W | none | `ShowMacroFrame` | `SlashCommands.lua:1259-1269` | P | n |
| FRIENDS | `/friends`? | none, or name+note (legacy) | `ToggleFriendsPanel`, or add/remove friend | `SlashCommands.lua:1124-1141` | P | serves (open) |
| WHO | `/who` W | filter text or none | Shows Who panel, `C_FriendList.SendWho` | `SlashCommands.lua:1106-1117` | P | maybe |
| DUNGEONS | `/dungeons`? (wiki: `/dungeonfinder`) | none | `ToggleLFDParentFrame` | `Mainline/SlashCommandsOverrides.lua:181` | P | serves |
| RAIDFINDER | `/raidfinder` W | none | `ToggleGroupFinderFrame("GroupFinderFrame", RaidFinderFrame)` | `SlashCommands.lua:1484-1488` | P | serves |
| GUILDFINDER | `/guildfinder` W | none | `ToggleGuildFinder` | `Mainline/SlashCommandsOverrides.lua:303-309` | P | n |
| COMMUNITY | `/community`? | `join` / `create character|battlenet` | Communities frame, flows | `Mainline/SlashCommandsOverrides.lua:319-344` | P | n |
| RAF | `/raf`? | none | `ToggleRAFPanel` | `Mainline/...:346` | P | n |
| RAID_INFO | `/raidinfo`? | none | Social UI raid list or `ToggleRaidFrame` | `SlashCommands.lua:1728-1766` | P | n |
| OPEN_LOOT_HISTORY | `/loot` W | none | `ToggleLootHistoryFrame` | `SlashCommands.lua:1480` | P | n |
| TRANSMOG_CUSTOM_SET | `/customset`? | set string | `DressUpItemTransmogInfoList` (dress-up window) | `Mainline/...:311-317` | P | maybe |
| TRANSMOG_OUTFIT | `/outfit`? | index (`!` prefix) | `C_TransmogOutfitInfo.ChangeToOutfit` | `SlashCommands.lua:1768-1789` | P | n |
| EDITMODE | `/editmode`? | none | `ShowUIPanel(EditModeManagerFrame)` | `Mainline/...:352-358` | P | n |
| CLICK_CASTING | `/clickcast`? | none | `ToggleClickBindingFrame` | `Mainline/...:360` | P | n |
| COOLDOWN_MANAGER | `/cdm`? | none | `CooldownViewerSettings:TogglePanel` | `Blizzard_CooldownViewer/SlashCommandRegistration.lua:1` | P | n |
| INSPECT | `/inspect` W | none (target) | `InspectUnit("target")` | `SlashCommands.lua:916` | P | n |
| TRADE | `/trade` W | none (target) | `InitiateTrade("target")` | `SlashCommands.lua:912` | P | n |
| PLAYED, TIME | `/played`, `/time` W | none | Chat output | `SlashCommands.lua:900-906` | P | n |
| STOPWATCH | `/stopwatch` W | `start|pause|clear|<n>` | Loads `Blizzard_TimeManager`, shows stopwatch | `SlashCommands.lua:1305-` | P | n |
| EQUIP_SET | `/equipset` W | set name | `C_EquipmentSet.UseEquipmentSet` | `SlashCommands.lua:812-820` | S | serves (equipment sets) |
| EQUIP, EQUIP_TO_SLOT | `/equip`, `/equipslot` W | item, slot+item | `C_Item.EquipItemByName` | `SlashCommands.lua:420-445` | S | serves |
| USE, CAST | `/use`, `/cast` W | item or spell, `[conditions]` | `SecureCmdUseItem` / `CastSpellByName` | `SlashCommands.lua:365-388` | S | serves (cast a profession spell, use a lure) |
| USE_TOY | `/usetoy` W | toy name | `UseToyByName` | `Mainline/...:28-33` | S | serves |
| TARGET, TARGET_EXACT, FOCUS, CLEARFOCUS, CLEARTARGET, ASSIST, TARGET_LAST_* | `/target` etc. W | unit or name | Targeting | `SlashCommands.lua:479-600` | S | serves (targeting) |
| TARGET_MARKER | `/tm` W (`/targetmarker`) | `n`, `!n`, `~n`, unit | `SetRaidTarget` | `SlashCommands.lua:1451-1478` | P | maybe |
| WORLD_MARKER, CLEAR_WORLD_MARKER | `/worldmarker`, `/clearworldmarker` W | n | `PlaceRaidMarker/ClearRaidMarker` | `SlashCommands.lua:822-838` | S | n |
| CHANGEACTIONBAR, SWAPACTIONBAR | `/changeactionbar`, `/swapactionbar` W | page | `C_ActionBar.SetActionBarPage` | `SlashCommands.lua:447-477` | S | maybe |
| TALENT_LOADOUT_BY_NAME / BY_INDEX, TALENT_SPEC_BY_NAME / BY_INDEX | `/talentloadout`?, `/talentspec`? (no wiki entry; keys are plain `SlashCmdList` entries) | name or index, `[conditions]` | `ClassTalentHelper.SwitchTo*` via `C_ClassTalents` and the talent frame | `Blizzard_ChatFrame/Shared/ClassTalentHelper.lua:55-90` | P (set with `SlashCmdList[...]`, not `CheckAdd`) | n |
| SET_TITLE | `/settitle` W | title text | `SetTitleByName` | `Mainline/...:209-218` | P | n |
| SUMMON_BATTLE_PET, RANDOMPET, RANDOMFAVORITEPET, DISMISSBATTLEPET | `/summonpet`, `/randompet` W, ... | pet name or GUID | `C_PetJournal.SummonPetByGUID` etc. | `SlashCommands.lua:1674-1725` | P | n |
| PVP | `/pvp` W | none | `C_PvP.TogglePVP` | `SlashCommands.lua:1271` | P | n |
| DISMOUNT | `/dismount` W | none | `Dismount` | `SlashCommands.lua:1285` | P | n |
| CASTSEQUENCE, CASTRANDOM, USERANDOM | `/castsequence`, `/castrandom`, `/userandom` W | spell/item list | Cast managers | `CastSequenceManager.lua:248`, `CastRandomManager.lua:77` | S | n |
| CONSOLE | `/console` W | `cvar value` | Runs console command (CVar set) | `SlashCommands.lua:840` | P | maybe (CVars as data) |
| RELOAD | `/reload` W | none | `ReloadUI` | `SlashCommands.lua:1441` | P | n (clean reload) |
| SCRIPT | `/run`, `/script` W | Lua | `RunScript`: FORCES TAINT | `SlashCommands.lua:1224` | P | NEVER |
| DUMP, TABLEINSPECT, EVENTTRACE, FRAMESTACK, API | `/dump`, `/tinspect`, `/etrace`, `/fstack`, `/api` | | Debug tools; `/dump` is script | `SlashCommands.lua:1384-1493`; `Mainline/...:220` | P | n |
| ENABLE_ADDONS, DISABLE_ADDONS | `/enableaddons`, `/disableaddons` W | name | Enable/disable then `ReloadUI` | `SlashCommands.lua:1295-1303` | P | n |
| Chat/channel/guild/group/pet/PvP wargame/commentator commands (JOIN, LEAVE, CHAT_*, GUILD_*, INVITE, UNINVITE, PROMOTE, READYCHECK, COUNTDOWN, PET_*, WARGAME, COMMENTATOR_*, VOICECHAT, TEXTTOSPEECH, COMBATAUDIOALERTS, LOGOUT, QUIT, STARTATTACK, STOPCASTING, ...) | various | | Act on chat, group, pets, session | `SlashCommands.lua:326-1800`; `Mainline/SlashCommandsOverrides.lua` | S/P | n |

There is NO slash command for: professions or tradeskill window, spellbook or talents panel (only loadout switching), collections journal, quest log, settings or Options categories, encounter journal, character panel, bags, achievements by id. For those use B1 (click a micro button), B6 (binding name), or B8/B9 (C API + event). Not found in source or wiki: UNVERIFIED that no other add-on-visible secure command exists (the grep covered `CheckAddSlashCommand`, `CheckAddSecureSlashCommand`, `SecureCmdList[`, `SlashCmdList[`, `RegisterNewSlashCommand` across all of `AddOns/`; non-Blizzard clients may add more).

Macro-run caveats:

- A macro line is at most 255 characters; secure button macro text cannot `/click` buttons that run other macros (WEB SecureActionButtonTemplate).
- `SecureCmdOptionParse` conditionals (`[combat]`, `[mod:shift]`) work in macro text (SRC handlers call it).
- An addon can overwrite `SlashCmdList[KEY]`; then the handler is addon code and taints. The Blizzard-registered entries are untainted only while nothing replaced them.
- Game-rule gates inside handlers (`Kiosk.IsEnabled()`, `DISALLOW_FRAME_TOGGLING`, `C_GameRules.IsGameRuleActive(...)`) can silently no-op.

## D. Traps (look fine, taint or break)

| # | Trap | Why | Evidence |
|---|---|---|---|
| D1 | `OpenWorldMap(id)`, `ToggleWorldMap()`, `ShowUIPanel(WorldMapFrame)` from addon code | Runs tainted; then `FocusDetails`/`SetGamepadFocus` select SmartNavigation buttons from tainted state; binding fields tainted; later `SetPreferredGamepadInteractTarget`, `SpellStopCasting`, `ClearTarget` forbidden until reload | DECK. SRC `Blizzard_WorldMap/Blizzard_WorldMap.lua:616` (FocusDetails: `SelectFirstButton`), `:634` (FocusMap: `ScrollContainer:SetGamepadFocus(true)`), `SmartNavigation.lua:652` |
| D2 | `WorldMapFrame:SetMapID` after a clean open | Addon-run Blizzard method; next pad press fails in `SetGamepadFocus` -> `MapCanvas_ScrollContainerMixin.lua:901` -> `SuspendCursor` | DECK |
| D3 | `macrotext="/run ..."` or `/script`, `/dump` from a secure button | `RunScript` path is `ForceTaint_Strong` | DECK |
| D4 | `ShowUIPanel` / `HideUIPanel` / `ToggleFrame` / `ToggleUIPanel` from addon code | Starts with `SetGamePadCursorControl(true)`; passes tainted `frame`/`force` attributes to the forbidden `FramePositionDelegate`; blocked in combat for insecure callers (`CheckProtectedFunctionsAllowed`) | SRC `Blizzard_UIParentPanelManager/Shared/UIParentPanelManager.lua:124-147,851-935`; kit rule |
| D5 | Writing into Blizzard frames, menus (`MenuUtil.CreateContextMenu`, `Menu.ModifyMenu`), Settings lists (`Settings.CreateDropdown`, `CreateElementInitializer`, `AddShownPredicate`), `ScrollBox` data providers, `UIPanelWindows`/`RegisterUIPanel`, `HelpTip:Show` | Gamepad navigation reads those values: `EnsureIsSecure`/`issecurevalue` fails; menus take gamepad focus and taint | DECK (kit standards); SRC `SmartNavigation.lua:74-90` |
| D6 | Calling `SmartNavigation:SelectButton`, `SuspendCursor`, `ActivateBinding`, `EnterFocusGroup`, `SetUseGridNavigation` etc. directly | Internal; `EnsureIsSecure` shows "Interface action failed because of an AddOn" and drops the call (many callers at lines 107-1334). Only the `WrapFunction` list (B11) is a supported door | SRC `SmartNavigation.lua:74-90,652`; DECK block messages |
| D7 | Panels that grab gamepad focus on show: `WorldMapMixin:FocusDetails/FocusMap` (`Blizzard_WorldMap.lua:611-640`), `SettingsPanelMixin` open (`Blizzard_SettingsPanel.lua:197,1041,1052,1171`, `Blizzard_CategoryList.lua:251`), Professions book page (`Blizzard_ProfessionsFrame.lua:644 UpdateSmartNavFocus_BookPage`), recipe page (`:716`), search box (`:989`), `CharacterFrame.lua:401-496` (Camelot), merchant, loot, quest, gossip frames | Each runs `SmartNavigation:SelectButton/SelectFirstButton` on show. Harmless when Blizzard code opened them; taints if the open call chain began in addon code (D1) or if addon-owned rows exist in their button groups (kit client-notes) | SRC lines cited |
| D8 | Loading Blizzard load-on-demand addons from addon code (`ProfessionsFrame_LoadUI()`, `C_AddOns.LoadAddOn("Blizzard_*")`, `Calendar_LoadUI()`) | Client-notes: risks taint. The same loads happen untainted when Blizzard's own event handlers do them (`HandleTradeSkillShow` -> `ShowProfessionsFrame`) | Kit client-notes; SRC `Blizzard_Game/Mainline/EventImplementation.lua:475`. UNVERIFIED whether the load alone taints |
| D9 | Calling a Blizzard handler yourself instead of clicking: `SetItemRef(link, ...)` or `ChatFrame:OnHyperlinkClick` from an addon frame's OnHyperlinkClick | The handler (e.g. `WorldMapWaypoint` -> `OpenMapToUserWaypoint`) then runs under addon taint, like D1. Only a click inside a Blizzard chat frame is clean | SRC `ChatFrame.lua:19-25`, `ItemRef.lua:6` |
| D10 | `type="click"` on a delegate with ScriptedInput forbidden or access constraints | Click silently refused | SRC `SecureTemplates.lua:561` |
| D11 | Secure button registered `AnyUp` only while `ActionButtonUseKeyDown` is 1 (or reverse) | Secure click fires on the event selected by `useOnKeyDown`, so the other event does nothing | SRC `SecureTemplates.lua:792-826` |
| D12 | `SECURE_ACTIONS` custom `_type` function, `menu-function`, `OnSmartNavClick`, `PreClick` bodies | They are addon code: they run insecure (`forceinsecure()` at `SecureTemplates.lua:744`). Fine for our own frame, never for Blizzard state | SRC |
| D13 | Changing secure button attributes, showing, hiding, moving or enabling a protected button in combat | Refused. Set them out of combat and after `PLAYER_REGEN_ENABLED`; SmartNavigation overrides likewise (`IsSecureOrOutOfCombatRestriction`) | WEB; SRC `SecureHelper.lua:25-27`; client-notes |
| D14 | `C_SettingsUtil.OpenSettingsPanel` / `Settings.OpenToCategory` from addon code | Kit saw `FocusContainer`/`SelectButton` blocked after it. Whether the event path alone is clean is unmeasured | Client-notes; SRC `Blizzard_Settings.lua:144`, `SettingsPanel.lua:145` |
| D15 | Expecting `CreateSecureDelegate`, `secretunwrap`, `loadstring_untainted`, `CreateSecureMixinCopy` to exist | Set to `nil` after Blizzard loads; only Blizzard-made delegates are available | SRC `EnvironmentCleanup.lua:272-277` |
| D16 | Interface style check cached at load (`InputUtil.IsGamepadUIEnabled`) | Switches on `INPUT_DEVICE_INTERFACE_TRANSITION` without reload | Client-notes |
| D17 | A Blizzard `ScrollBox` list or Settings list that contains addon-inserted rows | `HandleScroll` reads each row's element data; tainted rows break navigation of the whole list | Client-notes DECK |
| D18 | `Camelot` has no `ProfessionsBookFrame`; code that expects `ProfessionsBookFrame` | The Professions micro button toggles `ProfessionsFrame` | SRC `Camelot/MainMenuBarMicroButtonsOverrides.lua:33` |

## E. Smallest Deck tests for the unverified patterns

All tests: working build only, one action per press, read the log for `blocked`, `tainted field` and `ADDON_ACTION_FORBIDDEN` lines after bags, game menu, and 5 pad moves through the opened panel. Run one per session, reload between.

| Test | What | Pass if |
|---|---|---|
| E1 | `type="click"`, `clickbutton=ProfessionMicroButton` (then a second run with `TalentMicroButton` or `QuestLogMicroButton`), pressed by the pad | Professions opens (Camelot `ProfessionsFrame`), pad moves inside it work, no blocked line |
| E2 | `type="macro"`, `macrotext="/calendar"` (panel opener, plain handler), then `/achievements`, then `/click ProfessionMicroButton` (macro-side `/click`, secure handler) | Panel opens, no blocked line. Confirms any Blizzard slash handler is clean, not just `/mappin` |
| E3 | `SetOverrideBinding(ownerFrame, true, "PAD5"?, "TOGGLEPROFESSIONBOOK")` out of combat, press the pad button; also `SetOverrideBindingClick(owner, true, key, "ProfessionMicroButton")` | Opens with no block; confirms the override outranks the gamepad bar context and the body runs secure |
| E4 | `C_TradeSkillUI.OpenRecipe(<known recipeID>)` called from a secure button's PreClick, with the Professions window closed, then open | Window opens on the recipe via Blizzard's handlers; pad cursor works in it. Run twice: with and without calling `ProfessionsFrame_LoadUI()` first (D8) |
| E5 | Print `|Hworldmap:<...>|h` link (from `C_Map.GetUserWaypointHyperlink()` after `C_Map.SetUserWaypoint`) to `DEFAULT_CHAT_FRAME`, click it with the Deck cursor | Map opens on the pin's zone, no block. Also check a pad can click a chat link at all (if not, B7 is mouse-only) |
| E6 | `C_SettingsUtil.OpenSettingsPanel(<our categoryID>)` called from PreClick of a secure button whose action is harmless (`type="click"` on a hidden dummy) | Settings opens on our category with pad focus working. Compare with `Settings.OpenToCategory` and with the secure-click path to `MainMenuMicroButton` then Options |
| E7 | Call `SmartNavigation_AddJumpNavigationOverride` (already used) plus `SmartNavigation:SetTargetButtonForFrame(ourPanel, ourButton)` out of combat after our panel shows | Cursor lands on our button, no "Interface action failed". Then in combat to confirm it refuses without taint |
| E8 | `type="click"` with `RegisterForClicks("AnyUp","AnyDown")` and `useOnKeyDown` = false vs true, with `ActionButtonUseKeyDown` 0 and 1 | Exactly one action per pad press in all four combinations (resolves D11 and the `isSecureMousePress` rule) |
| E9 | Protected secure button in combat: press with `type="macro"`, `/mappin ...` | Map opens in combat (the button is protected; only attribute changes are blocked). Kit 0068 lists this as unmeasured |
| E10 | `type="togglemenu"` with `unit="target"` | Unit popup opens, pad navigation inside it works. Only worth running if the addon wants a unit menu |

## Sources

- SRC: files named in the tables, under `Interface/AddOns/`.
- WEB: [Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting) (taint rules, post-hooks, secure templates set via `SetAttribute` out of combat; page does not cover `securecall`, macro taint, `forceinsecure`, secrets), [SecureActionButtonTemplate](https://warcraft.wiki.gg/wiki/SecureActionButtonTemplate) (action types, 255-char macro limit, no `/click` of macro-running buttons, `useOnKeyDown`), [Macro commands](https://warcraft.wiki.gg/wiki/Macro_commands) (typed strings marked W; no taint or secure-command information on that page), [Category RestrictedActions](https://warcraft.wiki.gg/wiki/Category:API_systems/RestrictedActions) (function and event list only).
- Not fetched or empty: the wiki `Template:Restrictedapi` and `Module:API info/restricted` give no `HasRestrictions` definition. WoWUIBugs and Blizzard forum threads were not consulted for this file; the only forum-sourced item is kit client-notes's reference to Stanzilla/WoWUIBugs#896.
