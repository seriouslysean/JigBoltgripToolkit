-- The game's own translated names for the terms a module uses, read from Blizzard's tables by key, so a
-- translator writes "Angeln" for Fishing because the game does, not by guessing (docs/translations.md).
--   luajit tools/glossary.lua <build> <locale> <table> <key column> <name column> <key>...
--   luajit tools/glossary.lua 1.60.1.71139 deDE SpellName ID Name_lang 7620 3273
--   luajit tools/glossary.lua 1.60.1.71139 deDE GlobalStrings BaseTag TagText_lang FRIENDS COMBAT_LABEL
-- wago.tools serves each table as CSV per build and language; the build is the client the module targets.
local build, locale, tableName, keyColumn, nameColumn = arg[1], arg[2], arg[3], arg[4], arg[5]
assert(nameColumn and arg[6], "usage: luajit tools/glossary.lua <build> <locale> <table> <key column> <name column> <key>...")
local url = ("https://wago.tools/db2/%s/csv?build=%s&locale=%s"):format(tableName, build, locale)
local csv = assert(io.popen("curl -fsS " .. ("%q"):format(url))):read("*a")
assert(csv ~= "", "no table from " .. url)

-- The CSV's rows, each a list of fields; a quoted field may hold commas, line breaks and doubled quotes.
local function Rows(text)
	local position = 1
	return function()
		if position > #text then return nil end
		local fields = {}
		while true do
			local value
			if text:sub(position, position) == '"' then
				value, position = "", position + 1
				while true do
					local quote = assert(text:find('"', position, true), "unclosed quote in the table")
					value = value .. text:sub(position, quote - 1)
					position = quote + 1
					if text:sub(position, position) ~= '"' then break end
					value, position = value .. '"', position + 1
				end
			else
				local stop = text:find("[,\r\n]", position) or (#text + 1)
				value, position = text:sub(position, stop - 1), stop
			end
			fields[#fields + 1] = value
			local mark = text:sub(position, position)
			position = position + 1
			if mark == "\r" and text:sub(position, position) == "\n" then position = position + 1 end
			if mark ~= "," then return fields end
		end
	end
end

local wanted = {}
for index = 6, #arg do wanted[arg[index]] = true end
local keyIndex, nameIndex
for fields in Rows(csv) do
	if not keyIndex then
		for index, name in ipairs(fields) do
			if name == keyColumn then keyIndex = index end
			if name == nameColumn then nameIndex = index end
		end
		assert(keyIndex and nameIndex, ("%s has no column %s or %s"):format(tableName, keyColumn, nameColumn))
	elseif wanted[fields[keyIndex]] then
		print(("%s\t%s"):format(fields[keyIndex], fields[nameIndex]))
		wanted[fields[keyIndex]] = nil
	end
end
for key in pairs(wanted) do print(key .. "\t(not in the table)") end
