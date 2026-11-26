-- Throwaway test page: every candidate Blizzard Settings control on one page, using Blizzard's own API only (no
-- toolkit), so a failure under the Gamepad UI is the control's, not ours. Each change prints one chat line.
local ADDON = ...

local function Say(text)
	print("ControlTest: " .. text)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("ADDON_ACTION_BLOCKED")
frame:RegisterEvent("ADDON_ACTION_FORBIDDEN")

-- The "Interface action failed" message fires no event; log it where Blizzard prints it, as the kit's working build does.
local function HookInterfaceAction()
	if ChatFrameUtil and ChatFrameUtil.AddSystemMessage then
		hooksecurefunc(ChatFrameUtil, "AddSystemMessage", function(text)
			if text == INTERFACE_ACTION_BLOCKED then
				Say("INTERFACE ACTION FAILED")
				Say(debugstack(3, 8, 0))
			end
		end)
	end
end

local function Build()
	JigBoltgripControlTestDB = JigBoltgripControlTestDB or {}
	local db = JigBoltgripControlTestDB
	-- Each case gets its own page, so a control that stops the d-pad leaves the others testable.
	local main = Settings.RegisterVerticalLayoutCategory("Control Test")
	local category, layout = main, nil
	local function Page(name)
		category, layout = Settings.RegisterVerticalLayoutSubcategory(main, name)
	end

	local function Header(name)
		layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(name))
	end

	-- One saved setting per control; key is both the saved key and the logged name.
	local function Setting(key, label, varType, default)
		local setting = Settings.RegisterAddOnSetting(category, "JBCT_" .. key, key, db, varType, label, default)
		setting:SetValueChangedCallback(function(_, value)
			Say(("%s = %s"):format(label, tostring(value)))
		end)
		return setting
	end

	-- 1. Basic
	Page("1 Checkboxes")
	Header("Basic")
	Settings.CreateCheckbox(category, Setting("check", "Checkbox", Settings.VarType.Boolean, false), "A plain checkbox.")
	Settings.CreateCheckbox(category, Setting("check2", "Second checkbox", Settings.VarType.Boolean, false), "Another plain checkbox.")
	Settings.CreateCheckbox(category, Setting("check3", "Third checkbox", Settings.VarType.Boolean, false), "Another plain checkbox.")

	Page("2 Checkbox with child")

	local parent = Settings.CreateCheckbox(category, Setting("parent", "Checkbox with child", Settings.VarType.Boolean, false), "Turns the child on.")
	local child = Settings.CreateCheckbox(category, Setting("child", "Child checkbox", Settings.VarType.Boolean, false), "Indented under the parent.")
	child:SetParentInitializer(parent, function() return db.parent end)

	Page("3 Slider")
	local stops = { "Off", "Low", "Medium", "High", "Max" }
	local sliderOptions = Settings.CreateSliderOptions(1, 5, 1)
	sliderOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value) return stops[value] or tostring(value) end)
	Settings.CreateSlider(category, Setting("stops", "Slider with named stops", Settings.VarType.Number, 3), sliderOptions, "Five stops with words.")

	-- 2. Dropdown
	Page("4 Dropdown")
	local words = { "Thank", "Bow", "Cheer", "Wave" } -- the game's emote labels are command strings, so plain words
	local function Options()
		local container = Settings.CreateControlTextContainer()
		for i, word in ipairs(words) do container:Add(i, word) end
		return container:GetData()
	end
	Settings.CreateDropdown(category, Setting("dropdown", "Dropdown", Settings.VarType.Number, 1), Options, "A static list of four.")

	-- 3. Grouped choices
	Page("5 Grouped choices")
	for group = 1, 3 do
		Header("Group " .. group)
		for n = 1, 6 do
			local key = ("group%dchoice%d"):format(group, n)
			Settings.CreateCheckbox(category, Setting(key, ("Group %d choice %d"):format(group, n), Settings.VarType.Boolean, false))
		end
	end

	-- 4. Other
	Page("6 Button and combined row")
	layout:AddInitializer(CreateSettingsButtonInitializer("Button row", "Press", function() Say("Button pressed") end, "Prints a chat line.", true))
	-- A key binding row needs a Bindings.xml entry (binding names are declared there), so it is skipped here.

	-- 5. Checkbox and slider in one row
	local cbSetting = Setting("combo", "Checkbox and slider", Settings.VarType.Boolean, false)
	local slSetting = Setting("combolevel", "Slider of the combined row", Settings.VarType.Number, 3)
	local comboOptions = Settings.CreateSliderOptions(1, 5, 1)
	comboOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value) return stops[value] or tostring(value) end)
	if CreateSettingsCheckboxSliderInitializer then
		layout:AddInitializer(CreateSettingsCheckboxSliderInitializer(cbSetting, "Checkbox and slider", "One row, two controls.", slSetting, comboOptions, "Level", "The slider half."))
	else
		Say("CreateSettingsCheckboxSliderInitializer is not on this client")
	end

	-- 6. Reported cases from other Forever authors, unreproduced; each is measured on its own.
	Page("7 Shown predicate")
	Settings.CreateCheckbox(category, Setting("shownsource", "Shown predicate: source checkbox", Settings.VarType.Boolean, true), "The next checkbox is shown only while this is on.")
	local shown = Settings.CreateCheckbox(category, Setting("shown", "Shown predicate: checkbox with AddShownPredicate", Settings.VarType.Boolean, false), "Hidden when the source is off.")
	shown:AddShownPredicate(function() return db.shownsource end)

	Page("8 Inserted two ways")
	Header("Case: Inserted with CreateCheckbox")
	Settings.CreateCheckbox(category, Setting("insertA", "Inserted with CreateCheckbox", Settings.VarType.Boolean, false), "Settings.CreateCheckbox.")

	Header("Case: Inserted with RegisterInitializer")
	local insertB = Setting("insertB", "Inserted with RegisterInitializer", Settings.VarType.Boolean, false)
	Settings.RegisterInitializer(category, Settings.CreateCheckboxInitializer(insertB, nil, "CreateCheckboxInitializer then Settings.RegisterInitializer."))

	Page("9 Search tags")
	local tagged = Settings.CreateCheckbox(category, Setting("tagged", "Search tags: checkbox with AddSearchTags", Settings.VarType.Boolean, false), "Search the Settings box for the tag.")
	tagged:AddSearchTags("ControlTest tag")

	Page("10 Open from code")
	local function OpenHere()
		Say("Settings.OpenToCategory")
		Settings.OpenToCategory(main:GetID())
	end
	layout:AddInitializer(CreateSettingsButtonInitializer("Open from code", "Open this page", OpenHere, "Calls Settings.OpenToCategory while the panel is open.", true))
	SLASH_JBCONTROLTEST1 = "/controltest"
	SlashCmdList.JBCONTROLTEST = function(arg)
		if arg == "open" then OpenHere() else Say("/controltest open") end
	end

	Settings.RegisterAddOnCategory(main)
end

frame:SetScript("OnEvent", function(_, event, a, b)
	if event == "ADDON_LOADED" then
		if a == ADDON then
			frame:UnregisterEvent("ADDON_LOADED")
			HookInterfaceAction()
			Build()
			Say("loaded, find it in Options, AddOns, Control Test")
		end
	else
		Say(("%s: %s, %s"):format(event, tostring(a), tostring(b)))
	end
end)
