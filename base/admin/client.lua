-- Vars & imports
local Dialog = ImportPackage("dialogui") -- UI Lib
Dialog.setGlobalTheme("saitama")
local frame = 0
local admin

-- Create the admin menu
local function adminMenu() -- frame=0
    admin = Dialog.create("Admin menu", "", "Teleport a player", "Go to a player", "Go to a place", "Enable/Disable Noclip", "Send an global advert", "Leave")
    frame = 0
    Dialog.show(admin)
end
AddRemoteEvent("OpenAdminMenu", adminMenu)

-- Teleport a player
local function teleportPlayer() -- frame=1
	AddPlayerChat("salut à tous les amis c'est the Kairi")
	local menu = Dialog.create("Teleport a player", "Choose a player to bring any player to you !")
	frame = 1
	Dialog.show(menu)
end

-- When a button is pressed
local function onSubmit(frame, button, ...)
	if admin ~= nil then
    	if frame == 0 then
			local args = {...}

			AddPlayerChat(button)
			if button == 1 then
				teleportPlayer()
			end
    	else
    		-- continue here
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