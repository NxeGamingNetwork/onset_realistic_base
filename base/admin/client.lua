--[[ Admin Menu ]]--

-- Vars & imports
local Dialog = ImportPackage("dialogui") -- UI Lib
Dialog.setGlobalTheme("saitama")
local admin = Dialog.create("Admin menu", nil, "Teleport a player", "Go to a player", "Go to a place", "Enable/Disable Noclip", "Send an global advert", "Leave")
local teleportMenu = Dialog.create("Teleport a player", "Choose a player to bring any player to you !", nil, "Bring the player", "Back")
Dialog.addSelect(teleportMenu, 1, "Players list", 8)
local gotoMenu = Dialog.create("Goto a player", "Choose the player you want to goto.", nil, "Goto the player", "Back")
Dialog.addSelect(gotoMenu, 1, "Players list", 8)
local goPosMenu = Dialog.create("Goto a place", "Choose the position you want to goto.", nil, "Bring me there !", "Back")
Dialog.addSelect(goPosMenu, 1, "Positions list", 8)
local alertMenu = Dialog.create("Global advert", "Write your global alert right there.", nil, "Send advert", "Back")
Dialog.addTextInput(alertMenu, 1, "Message")

-- Create the admin menu
local function adminMenu(plys, posList)
	Dialog.setSelectLabeledOptions(teleportMenu, 1, 1, plys)
	Dialog.setSelectLabeledOptions(gotoMenu, 1, 1, plys)
	Dialog.setSelectLabeledOptions(goPosMenu, 1, 1, posList)
	Dialog.show(admin)
end
AddRemoteEvent("OpenAdminMenu", adminMenu)

-- When a button is pressed
local function onSubmit(frame, button, ...)
	if admin ~= nil then
		local args = {...}
		if frame == admin then
			Dialog.hide(admin)
			if button == 1 then
				Dialog.show(teleportMenu)
			elseif button == 2 then
				Dialog.show(gotoMenu)
			elseif button == 3 then
				Dialog.show(goPosMenu)
			elseif button == 4 then
				CallRemoteEvent("enableNoclipping")
			elseif button == 5 then
				Dialog.show(alertMenu)
			end
		elseif frame == teleportMenu then
			if button == 1 then
				Dialog.hide(teleportMenu)
				CallRemoteEvent("bringPlayer", args[1])
			elseif button == 2 then
				Dialog.hide(teleportMenu)
				Dialog.show(admin)
			end
		elseif frame == gotoMenu then
			if button == 1 then
				Dialog.hide(gotoMenu)
				CallRemoteEvent("gotoPlayer", args[1])
			elseif button == 2 then
				Dialog.hide(gotoMenu)
				Dialog.show(admin)
			end
		elseif frame == goPosMenu then
			if button == 1 then
				Dialog.hide(goPosMenu)
				CallRemoteEvent("goPosPlayer", args[1])
			elseif button == 2 then
				Dialog.hide(goPosMenu)
				Dialog.show(admin)
			end
		elseif frame == alertMenu then
			if button == 1 then
				Dialog.hide(alertMenu)
				CallRemoteEvent("sendGlobalAdvert", args[1])
			elseif button == 2 then
				Dialog.hide(alertMenu)
				Dialog.show(admin)
			end
		end
	end
end
AddEvent("OnDialogSubmit", onSubmit)


--[[ Events section ]]--

-- Noclip keys system
local binds = {
	["Z"] = true,
	["Space Bar"] = true,
	["Left Ctrl"] = true,
	["Left Shift"] = true
}
local function onKeyPress(key)
	if binds[key] or key == "V" then
		CallRemoteEvent("KeyPressNoclip", key, true)
	end
end
AddEvent("OnKeyPress", onKeyPress)

local function onKeyRelease(key)
	if binds[key] then
		CallRemoteEvent("KeyPressNoclip", key, false)
	end
end
AddEvent("OnKeyRelease", onKeyRelease)