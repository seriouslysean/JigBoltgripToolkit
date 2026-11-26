-- Lint on the client's Lua (5.1). Reading WoW's API globals is not reported (113: there are
-- thousands); writing a global is, so the only globals this file sets are listed here.
std = "lua51"
globals = { "SlashCmdList", "SLASH_BOLTGRIP1", "BINDING_HEADER_JIGBOLTGRIPTOOLKIT" }
max_line_length = false
ignore = { "113", "21./self", "212" }

-- The offline test stands in for the client, so it defines its globals on purpose.
files["tests"] = { std = "+busted", ignore = { "111", "112", "121", "122", "142", "143", "211" } }

-- The new-module skeleton names its saved variables with a placeholder that tools/new-module.sh replaces.
files["skeleton"] = { globals = { "__ADDON__DB" } }

-- The throwaway control-test addon owns its saved variables.
files["tools/ControlTest"] = { globals = { "JigBoltgripControlTestDB" } }
