-- Lint for the client's Lua 5.1; embedded libraries are linted by their own authors.
-- `globals` lists the only globals the addon sets; add each game global it reads to `read_globals`.
std = "lua51"
exclude_files = { "Libs/JigBoltgripToolkit", "Libs/AceLocale-3.0", "Libs/LibStub" }
globals = { "__ADDON__DB", "SlashCmdList", "SLASH_BOLTGRIP1", "BINDING_HEADER_JIGBOLTGRIPTOOLKIT" }
max_line_length = false
ignore = { "21./self", "212" }
read_globals = {
	"C_AddOns", "EventUtil", "GENERAL", "LibStub", "Settings",
}
files["tests"] = { std = "+busted" }
