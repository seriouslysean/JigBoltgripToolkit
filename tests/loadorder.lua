-- Offline check: the real library file loaded more than once through the real LibStub, as happens
-- when two addons embed copies. Client functions are stubs.
-- luajit tests/loadorder.lua JigBoltgripToolkit.lua <path to LibStub.lua>
local LIBRARY, LIBSTUB = arg[1], arg[2]

local source = assert(io.open(LIBRARY)):read("*a")
local CURRENT = tonumber(source:match('"JigBoltgripToolkit%-1%.0", (%d+)'))

local failures = 0
local function check(name, ok)
	print((ok and "PASS " or "FAIL ") .. name)
	if not ok then failures = failures + 1 end
end

-- A fresh client: globals the library reads, and a record of what it shows the player.
local chat, buttons
local function NewClient()
	chat, buttons = {}, {}
	LibStub = nil
	dofile(LIBSTUB)
	SlashCmdList = {}
	NORMAL_FONT_COLOR = { WrapTextInColorCode = function(_, text) return "|cffffd100" .. text .. "|r" end }
	ChatTypeInfo = { SYSTEM = { r = 1, g = 1, b = 0, id = 1 }, MONSTER_SAY = { r = 1, g = 1, b = 0.5, id = 12 } }
	DEFAULT_CHAT_FRAME = { AddMessage = function(_, text, r, g, b) table.insert(chat, text); chat.color = { r, g, b } end }
	RAID_CLASS_COLORS = { MAGE = { r = 0, g = 0, b = 1 } }
	KEY_BINDING, COMBAT, SOUND = "Key Binding", "Combat", "Sound" -- Blizzard's global strings, enUS
	function strtrim(text) return (text:gsub("^%s+", ""):gsub("%s+$", "")) end
	C_AddOns = { GetAddOnMetadata = function(addon, field)
		if field == "Title" then return addon .. " title" end
	end }
	local function Category()
		return { GetID = function() return 1 end }, { AddInitializer = function(_, row) table.insert(buttons, row) end }
	end
	Settings = {
		RegisterVerticalLayoutCategory = Category,
		RegisterVerticalLayoutSubcategory = Category,
		RegisterAddOnCategory = function() end,
		OpenToCategory = function() end,
		CreateElementInitializer = function(template, data) return { note = data.text, template = template } end,
	}
	function CreateSettingsListSectionHeaderInitializer(title) return { header = title } end
	function CreateSettingsButtonInitializer(title) return { button = title } end
end

-- Loads the library as a copy with the given MINOR.
local function Load(minor)
	local copy = source:gsub('("JigBoltgripToolkit%-1%.0", )%d+', "%1" .. minor, 1)
	assert(loadstring(copy, "JigBoltgripToolkit@" .. minor))()
end

local function Count(list, field, value)
	local count = 0
	for _, row in ipairs(list) do
		if row[field] == value then count = count + 1 end
	end
	return count
end

-- An addon's startup: register the module and one command that records its argument.
local ran
local function StartAddon(addon, slash)
	local toolkit = LibStub("JigBoltgripToolkit-1.0")
	local module = toolkit:RegisterModule(addon)
	toolkit:RegisterCommands(module, slash, {
		{ action = "go", description = "Go", run = function(arguments) ran = addon .. ":" .. arguments end },
	})
	toolkit:FinishModule(module)
end

-- Each row: the MINOR of the copy the first addon embeds, then of the second addon's copy.
local orders = {
	{ name = "same copy twice", first = CURRENT, second = CURRENT },
	{ name = "newer copy loads second", first = CURRENT, second = CURRENT + 1 },
	{ name = "older copy loads second", first = CURRENT + 1, second = CURRENT },
}
for _, order in ipairs(orders) do
	NewClient()
	Load(order.first)
	StartAddon("Alpha", "alpha")
	Load(order.second)
	StartAddon("Beta", "beta")
	local _, minor = LibStub("JigBoltgripToolkit-1.0")
	check(order.name .. ": newest copy is the one in use", minor == math.max(order.first, order.second))

	ran = nil
	SlashCmdList.BOLTGRIP_ALPHA("go one")
	check(order.name .. ": first addon's own command still runs", ran == "Alpha:one")
	ran = nil
	SlashCmdList.BOLTGRIP("beta go two")
	check(order.name .. ": /boltgrip reaches the second addon", ran == "Beta:two")
	ran = nil
	SlashCmdList.BOLTGRIP("alpha go three")
	check(order.name .. ": /boltgrip reaches the first addon", ran == "Alpha:three")

	check(order.name .. ": one Open row per addon",
		Count(buttons, "button", "Alpha title") == 1 and Count(buttons, "button", "Beta title") == 1)
	check(order.name .. ": one toolkit header", Count(buttons, "header", "AddOns") == 1)
end

-- Starting the same addon twice (a module file loaded again) adds nothing.
NewClient()
Load(CURRENT)
StartAddon("Alpha", "alpha")
local rows = #buttons
local toolkit = LibStub("JigBoltgripToolkit-1.0")
check("registering a module again returns the same module",
	toolkit:RegisterModule("Alpha") == toolkit.modules[1] and #toolkit.modules == 1 and #buttons == rows)

-- An unknown command prints the help, which names every command.
chat = {}
SlashCmdList.BOLTGRIP_ALPHA("nonsense")
local help = table.concat(chat, "\n")
check("unknown command prints the help", help:find("/alpha go", 1, true) and not help:find("/alpha help", 1, true) and true or false)
-- A troubleshooting section: a gold heading, its commands one step further in. Fails if the heading
-- reads like a command row or its commands lose the extra step.
do
	local tk = LibStub("JigBoltgripToolkit-1.0")
	local m = tk:RegisterModule("Gamma")
	tk:RegisterCommands(m, "gamma", { { action = "go", description = "Go", run = function() end },
		{ action = "probe", description = "Probe", run = function() end, troubleshooting = true } })
	chat = {}
	SlashCmdList.BOLTGRIP_GAMMA("nonsense")
	local SPACER = "|TInterface\\Common\\spacer:0|t "
	local heading, probe
	for _, line in ipairs(chat) do
		if line:find("Troubleshooting", 1, true) then heading = line end
		if line:find("/gamma probe", 1, true) then probe = line end
	end
	check("a troubleshooting heading is gold and not a command row", heading == SPACER .. "|cffffd100Troubleshooting|r")
	check("troubleshooting commands sit one step in", probe ~= nil and probe:sub(1, 2 * #SPACER) == SPACER .. SPACER)
end

-- Options built from data. Fails if a setting loses its derived name or saved key, a note does not
-- follow its row, an indented checkbox loses its parent, or a change stops reaching onChange.
do
	local registered, made, changed = {}, {}, nil
	Settings.VarType = { Boolean = "boolean", Number = "number", String = "string" }
	Settings.RegisterAddOnSetting = function(_, variable, key, db, varType, label, default)
		local setting = { variable = variable, key = key, varType = varType, value = default }
		function setting:SetValueChangedCallback(fn) self.callback = fn end
		function setting:GetValue() return self.value end
		function setting:SetValue(value) self.value = value; if self.callback then self.callback(self, value) end end
		registered[key] = setting
		return setting
	end
	Settings.CreateCheckbox = function(_, setting)
		local row = { checkbox = setting.key }
		function row:SetParentInitializer(parent) self.parent = parent end
		table.insert(buttons, row); made[setting.key] = row
		return row
	end
	Settings.CreateDropdown = function(_, setting, options)
		local row = { dropdown = setting.key, options = options() }
		table.insert(buttons, row); made[setting.key] = row
		return row
	end
	Settings.CreateControlTextContainer = function()
		local data = {}
		return { Add = function(_, value, label) table.insert(data, { value = value, label = label }) end, GetData = function() return data end }
	end
	local tk = LibStub("JigBoltgripToolkit-1.0")
	local m = tk:RegisterModule("Delta")
	buttons = {}
	local saved = {}
	local built = tk:BuildOptions(m, saved, {
		{ heading = "Sound", place = "blizzard", rows = {} },
		{ heading = "Key Binding", place = "blizzard", rows = {} },
		{ heading = "Things", place = "features", rows = {
			{ kind = "checkbox", key = "record", label = "Record Things", tooltip = "t", default = true, note = "Why." },
			{ kind = "checkbox", key = "announce", label = "Announce Things", tooltip = "t", default = true, under = "record" },
			{ kind = "dropdown", key = "mode", label = "Mode", tooltip = "t", default = 2,
				values = { { 1, "One" }, { 2, "Two" } }, onChange = function(value) changed = value end },
		} },
		{ heading = "Thing Sources", place = "sources", rows = {
			{ kind = "cards", key = "level", label = "Thing Sources", default = 1,
				values = tk:SourceCards({ what = "things", public = "things people link in chat", openings = false }) },
		} },
	})
	-- Fails if a module's sections are not put in the toolkit's one order: sources, features, Blizzard's.
	local headings = {}
	for _, row in ipairs(buttons) do if row.header then headings[#headings + 1] = row.header end end
	check("sections follow the toolkit's order whatever order a module lists them in",
		table.concat(headings, ",") == "Thing Sources,Things,Key Binding,Sound")
	-- Fails if a sources section may put another row above its cards.
	local cardsSecond = pcall(tk.BuildOptions, tk, m, {}, { { heading = "Late Sources", place = "sources", rows = {
		{ kind = "checkbox", key = "early", label = "Early", default = true },
		{ kind = "cards", key = "late", label = "Late Sources", default = 1, values = tk:SourceCards({ what = "things" }) } } } })
	check("a sources section starts with its cards", not cardsSecond)
	-- Fails if hand-built cards pass, or a module's choice to drop the range openings is ignored.
	local handBuilt = pcall(tk.BuildOptions, tk, m, {}, { { heading = "Hand Sources", place = "sources", rows = {
		{ kind = "cards", key = "hand", label = "Hand Sources", default = 1, values = { { 1, "Self Found", "", "Mine." } } } } } })
	local cards = tk:SourceCards({ what = "fish", openings = false })
	local withOpenings = tk:SourceCards({ what = "recipes", friends = true, public = "recipes people link in chat" })
	check("cards come only from the kit, in one sentence shape, with or without the range openings", not handBuilt
		and #cards == 1 and cards[1][4] == "Tracks only fish you see for yourself."
		and #withOpenings == 3 and withOpenings[2][4] == "Medium range. Also tracks what your party, guild and friends find."
		and withOpenings[3][4] == "Long range. Also tracks recipes people link in chat.")
	check("a setting is named after the addon and saved under its key",
		registered.record.variable == "Delta_record" and registered.record.varType == "boolean" and registered.mode.varType == "number")
	local afterRecord
	for index, row in ipairs(buttons) do if row.checkbox == "record" then afterRecord = buttons[index + 1] end end
	check("a note follows its row", afterRecord ~= nil and afterRecord.note == "Why.")
	check("an indented checkbox sits under its parent", made.announce.parent == made.record)
	check("a dropdown lists its choices", #made.mode.options == 2 and made.mode.options[2].label == "Two")
	built.mode:SetValue(1)
	check("a change reaches the row's onChange", changed == 1)
end

-- Fails if a command on the options page loses the note that explains it, or gets another row's note
-- (the earlier version counted any note on the page; Astra review).
do
	buttons = {}
	local epsilon = LibStub("JigBoltgripToolkit-1.0"):RegisterModule("Epsilon")
	LibStub("JigBoltgripToolkit-1.0"):RegisterCommands(epsilon, "epsilon", {
		{ action = "go", description = "Go", note = "Goes somewhere.", run = function() end },
		{ action = "stop", description = "Stop", run = function() end },
	})
	LibStub("JigBoltgripToolkit-1.0"):FinishModule(epsilon)
	local noteAfter = {}
	for index, row in ipairs(buttons) do
		if row.button then noteAfter[row.button] = buttons[index + 1] and buttons[index + 1].note end
	end
	check("each command on the options page has its own note under it", noteAfter["/epsilon go"] == "Goes somewhere."
		and noteAfter["/epsilon stop"] == "Stop")
end
check("help rows sit under the header text", chat[2] ~= nil and chat[2]:sub(1, #"|TInterface\\Common\\spacer") == "|TInterface\\Common\\spacer")

-- Chat: one shape for the whole family. Fails if the mark or the shared word goes missing, the device
-- color reaches beyond the name, or rows under a header carry their own mark.
local MARK = "|TInterface\\WorldMap\\GEAR_64GREY:0|t"
local blue = toolkit:RegisterModule("Alpha", "MAGE")
chat = {}
toolkit:Say(blue, "whirs and rattles", "Intake complete!")
-- The class color (0, 0, 1) with 25% of the line color (91, 217, 222): 23, 54, 247.
check("a voiced line is the mark, the shared word, the class-colored name, the noise and the report",
	chat[1] == MARK .. " Boltgrip's |cff1736f7Alpha title|r whirs and rattles. Intake complete!")
-- Fails if the line stops being the family's own teal.
check("a line is printed in the family's color",
	math.abs(chat.color[1] - 91 / 255) < 0.001 and math.abs(chat.color[2] - 217 / 255) < 0.001 and math.abs(chat.color[3] - 222 / 255) < 0.001)
chat = {}
toolkit:PrintBlock("Header", { "one", "two" })
local ALIGN = "|TInterface\\Common\\spacer:0|t "
check("a block marks its header and aligns its rows under the header text", chat[1] == MARK .. " Header"
	and chat[2] == ALIGN .. "one" and chat[3] == ALIGN .. "two")
chat = {}
toolkit:Say({ title = "Plain" }, "hums", "Ready!")
check("a module without a class keeps the line color", chat[1] == MARK .. " Boltgrip's Plain hums. Ready!")

-- Working builds. Fails if a second call makes a second listener, or timings mix between modules.
do
	local cvars, frames = {}, 0
	C_CVar = { SetCVar = function(name, value) cvars[name] = value end }
	local realCreateFrame = CreateFrame
	CreateFrame = function(...)
		frames = frames + 1
		local frame = { RegisterEvent = function() end, SetScript = function() end }
		return frame
	end
	EventUtil = EventUtil or { ContinueOnAddOnLoaded = function() end }
	toolkit:EnableWorkingBuild()
	toolkit:EnableWorkingBuild()
	CreateFrame = realCreateFrame
	check("a working build shows Lua errors and listens once", cvars.scriptErrors == "1" and frames == 1)
	local one, two = { addon = "One" }, { addon = "Two" }
	toolkit:TimeMs(one, "build", 4); toolkit:TimeMs(one, "build", 2); toolkit:TimeMs(two, "scan", 1)
	local lines = toolkit:TimingLines(one)
	check("timings are kept per module", #lines == 1 and lines[1]:find("runs     2", 1, true) ~= nil
		and lines[1]:find("slowest    4.00", 1, true) ~= nil and #toolkit:TimingLines(two) == 1)
end

-- Working-build log. Fails if lines go to another module's log, lose their order, or the cap drops the newest.
do
	date = date or os.date
	GetBuildInfo = GetBuildInfo or function() return "1.60.1", "71091" end
	C_AddOns = C_AddOns or {}
	C_AddOns.GetAddOnMetadata = C_AddOns.GetAddOnMetadata or function() return "test" end
	UnitName = UnitName or function() return "Tester" end
	UnitLevel = UnitLevel or function() return 1 end
	C_Map = C_Map or { GetBestMapForUnit = function() return 1429 end, GetMapInfo = function() return { name = "Elwynn Forest" } end }
	GetSubZoneText = GetSubZoneText or function() return "" end
	C_Map.GetPlayerMapPosition = C_Map.GetPlayerMapPosition or function() return nil end
	C_MapExplorationInfo = C_MapExplorationInfo or { GetExploredAreaIDsAtPosition = function() return nil end }
	local saved = {}
	local module = { addon = "Logger", title = "Logger" }
	local realCreateFrame = CreateFrame
	CreateFrame = function()
		local frame = { RegisterEvent = function() end, UnregisterAllEvents = function() end }
		frame.SetScript = function(self, _, fn) self.script = fn end
		return frame
	end
	toolkit:StartLog(module, saved)
	CreateFrame = realCreateFrame
	local cap, trim = toolkit.LOG_LINES, toolkit.LOG_TRIM
	saved.devLog = {} -- without the session header, so the count is exact
	local most = 0
	for index = 1, cap + trim + 1 do
		toolkit:Log(module, "line " .. index, true)
		most = math.max(most, #saved.devLog)
	end
	check("the log keeps the newest lines, in order, per module, never more than its cap", #saved.devLog == cap
		and most == cap
		and saved.devLog[1] == "line " .. (trim + 2) and saved.devLog[cap] == "line " .. (cap + trim + 1))
	-- Fails if /boltgrip watch misses a module that started a log, or writes one module's lines to another.
	local otherSaved, seen = {}, {}
	local other = { addon = "Other", title = "Other" }
	toolkit:StartLog(other, otherSaved, { LOOT_READY = function(slot) seen[#seen + 1] = slot end })
	SlashCmdList.BOLTGRIP("watch on")
	local listener = toolkit.watchFrame
	check("/boltgrip watch switches every module's own watch", saved.watch == true and otherSaved.watch == true
		and otherSaved.devLog[#otherSaved.devLog]:find("watch on", 1, true) ~= nil and #saved.devLog <= toolkit.LOG_LINES + toolkit.LOG_TRIM)
	-- Fails if the shared listener drops a module's event, or passes it while the watch is off.
	listener.script(listener, "LOOT_READY", 7)
	SlashCmdList.BOLTGRIP("watch off")
	listener.script(listener, "LOOT_READY", 8)
	check("the shared listener passes events only while watching", #seen == 1 and seen[1] == 7)
	-- Fails if a working build's log is not on from the start, or a paused log still traces.
	local freshSaved = {}
	local fresh = { addon = "Fresh", title = "Fresh" }
	toolkit:StartLog(fresh, freshSaved)
	toolkit:Trace(fresh, "offer sent")
	local traced = freshSaved.devLog[#freshSaved.devLog]:find("offer sent", 1, true) ~= nil
	SlashCmdList.BOLTGRIP("watch off")
	local count = #freshSaved.devLog
	toolkit:Trace(fresh, "not this")
	toolkit:LogAll("nor this")
	check("a working build logs from the start, and a paused log takes no trace or shared context",
		traced and #freshSaved.devLog == count and freshSaved.watch == false and not toolkit:IsLogging(fresh))
end

-- Fails if the library holds a packager token, even in a comment: the packager turns "--@debug@" into the
-- start of a block comment, so everything after it would vanish from release builds (it did, MINOR 19 to 24).
do
	local file = assert(io.open(LIBRARY))
	local text = file:read("*a")
	file:close()
	check("the library holds no packager tokens", not text:find("%-%-@[%a%-]+@"))
end

print(failures == 0 and "ALL LOAD ORDER CHECKS PASSED" or (failures .. " FAILED"))
os.exit(failures == 0 and 0 or 1)
