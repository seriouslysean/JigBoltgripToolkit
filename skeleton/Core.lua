-- GPL-3.0 with additional terms under section 7: README.md, "License".

local addonName, ns = ...
-- The libraries, looked up once; every file uses these.
ns.toolkit = LibStub("JigBoltgripToolkit-1.0")
ns.L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-- The module's record, from file load on: every file names the module to the kit with ns.module. The class
-- is the one whose color the name takes in chat.
ns.module = ns.toolkit:NewModule(addonName, "WARRIOR", "__COMMAND__")

-- Saved data is read here only, once the game has loaded it: the kit runs the migrations (one function per
-- schema step, in order) and fills the defaults.
EventUtil.ContinueOnAddOnLoaded(addonName, function()
	ns.db = ns.toolkit:LoadSaved(ns.module, addonName .. "DB", { schema = 1, migrations = {}, defaults = {} })
	ns.InitSettings()
	-- Working builds only: the module's Troubleshooting.lua defines it inside its debug markers (docs/standards.md, "Working build").
	if ns.StartWorkingLog then ns.StartWorkingLog() end
end)
