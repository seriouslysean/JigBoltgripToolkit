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
	ChatTypeInfo = { SYSTEM = { r = 1, g = 1, b = 0, id = 1 } }
	DEFAULT_CHAT_FRAME = { AddMessage = function(_, text) table.insert(chat, text) end }
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
check("unknown command prints the help", help:find("/alpha go", 1, true) and help:find("/alpha help", 1, true) and true or false)

print(failures == 0 and "ALL LOAD ORDER CHECKS PASSED" or (failures .. " FAILED"))
os.exit(failures == 0 and 0 or 1)
