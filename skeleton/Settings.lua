local addonName, ns = ...
local L = ns.L

-- One table drives the chat help and the Commands rows.
ns.commands = {
	{ action = "", description = L["Open the options"], run = function()
		Settings.OpenToCategory(ns.module.category:GetID())
	end },
}

function ns.InitSettings()
	local toolkit = ns.toolkit
	local module = toolkit:RegisterModule(addonName, ns.device.class)
	ns.module = module
	toolkit:BuildOptions(module, ns.db, {
		{ heading = GENERAL, place = "features", rows = {
			{ kind = "checkbox", key = "enabled", label = L["Enable __TITLE__"], default = true,
				tooltip = L["Turns __TITLE__ on or off."] },
		} },
	})
	toolkit:RegisterCommands(module, "__COMMAND__", ns.commands)
	toolkit:FinishModule(module)
end
