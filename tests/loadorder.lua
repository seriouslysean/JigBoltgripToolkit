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
	ChatTypeInfo = { SYSTEM = { r = 1, g = 1, b = 0, id = 1 }, MONSTER_SAY = { r = 1, g = 1, b = 0.5, id = 12 } }
	DEFAULT_CHAT_FRAME = { AddMessage = function(_, text, r, g, b) table.insert(chat, text); chat.color = { r, g, b } end }
	RAID_CLASS_COLORS = { MAGE = { r = 0, g = 0, b = 1 } }
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
-- Fails if a command on the options page loses the note that explains it.
local notes = 0
for _, row in ipairs(buttons) do if row.note then notes = notes + 1 end end
check("each command on the options page has a note under it", notes > 0)
check("help rows sit under the header text", chat[2] ~= nil and chat[2]:sub(1, #"|TInterface\\Common\\spacer") == "|TInterface\\Common\\spacer")

-- Chat: one shape for the whole family. Fails if the mark or the shared word goes missing, the device
-- color reaches beyond the name, or rows under a header carry their own mark.
local MARK = "|TInterface\\WorldMap\\GEAR_64GREY:0|t"
local blue = toolkit:RegisterModule("Alpha", "MAGE")
chat = {}
toolkit:Say(blue, "deploys a bobber!")
-- The class color (0, 0, 1) with 25% of the line color (91, 217, 222): 23, 54, 247.
check("a voiced line is the mark, the shared word, the class-colored name and the action",
	chat[1] == MARK .. " Boltgrip's |cff1736f7Alpha title|r deploys a bobber!")
-- Fails if the line stops being the family's own teal.
check("a line is printed in the family's color",
	math.abs(chat.color[1] - 91 / 255) < 0.001 and math.abs(chat.color[2] - 217 / 255) < 0.001 and math.abs(chat.color[3] - 222 / 255) < 0.001)
chat = {}
toolkit:PrintBlock("Header", { "one", "two" })
local ALIGN = "|TInterface\\Common\\spacer:0|t "
check("a block marks its header and aligns its rows under the header text", chat[1] == MARK .. " Header"
	and chat[2] == ALIGN .. "one" and chat[3] == ALIGN .. "two")
chat = {}
toolkit:Say({ title = "Plain" }, "hums!")
check("a module without a class keeps the line color", chat[1] == MARK .. " Boltgrip's Plain hums!")

print(failures == 0 and "ALL LOAD ORDER CHECKS PASSED" or (failures .. " FAILED"))
os.exit(failures == 0 and 0 or 1)
