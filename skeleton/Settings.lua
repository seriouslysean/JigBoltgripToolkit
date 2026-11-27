local addonName, ns = ...
local L = ns.L

-- One table drives the chat help and the Commands rows; the kit adds the "open the options" entry and help.
ns.commands = {}

function ns.InitSettings()
	local toolkit = ns.toolkit
	local module = toolkit:RegisterModule(addonName)
	toolkit:BuildOptions(module, ns.db, {
		{ heading = GENERAL, place = "features", rows = {
			{ kind = "checkbox", key = "enabled", label = L["Enable __TITLE__"], default = true,
				tooltip = L["Turns __TITLE__ on or off."] },
		} },
	})
	toolkit:RegisterCommands(module, ns.commands)
	toolkit:FinishModule(module)
end
