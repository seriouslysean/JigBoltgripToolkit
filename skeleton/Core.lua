local addonName, ns = ...
-- The libraries, looked up once; every file uses these.
ns.toolkit = LibStub("JigBoltgripToolkit-1.0")
ns.L = LibStub("AceLocale-3.0"):GetLocale(addonName)

ns.title = C_AddOns.GetAddOnMetadata(addonName, "Title")
ns.device = { addon = addonName, title = ns.title, class = "WARRIOR" } -- the class whose color the name takes in chat

-- Saved data is read here only, once the game has loaded it; option defaults live with the options.
EventUtil.ContinueOnAddOnLoaded(addonName, function()
	__ADDON__DB = __ADDON__DB or {}
	ns.db = __ADDON__DB
	ns.InitSettings()
	-- Working builds only: the module's Troubleshooting.lua defines it inside its debug markers (docs/standards.md, "Working build").
	if ns.StartWorkingLog then ns.StartWorkingLog() end
end)
