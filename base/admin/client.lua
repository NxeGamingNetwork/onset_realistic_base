-- Vars & imports
local Dialog = ImportPackage("dialogui") -- UI Lib
Dialog.setGlobalTheme("saitama")
local admin = Dialog.create("Admin menu", nil, "Teleport a player", "Go to a player", "Go to a place", "Enable/Disable Noclip", "Send an global advert", "Leave")
local teleportMenu = Dialog.create("Teleport a player", "Choose a player to bring any player to you !", nil, "Bring the player", "Leave")
Dialog.addSelect(teleportMenu, 1, "Players list", 8)

-- Create the admin menu
local function adminMenu(plys)
	Dialog.setSelectLabeledOptions(teleportMenu, 1, 1, plys)
	Dialog.show(admin)
end
AddRemoteEvent("OpenAdminMenu", adminMenu)

-- When a button is pressed
local function onSubmit(frame, button, ...)
	if admin ~= nil then
		local args = {...}
		if frame == admin then
			if button == 1 then
				Dialog.hide(admin)
				Dialog.show(teleportMenu)
			end
		elseif frame == teleportMenu then
			-- nothing to see here
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