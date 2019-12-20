local Dialog = ImportPackage("dialogui") -- UI Lib
Dialog.setGlobalTheme("saitama")
local frame = 0
local admin

local function adminMenu()
    admin = Dialog.create("Admin menu", "", "Teleport a player", "Go to a player", "Go to a place", "Enable/Disable Noclip", "Send an global advert", "Leave")
    frame = 0
    Dialog.show(admin)
end
AddRemoteEvent("OpenAdminMenu", adminMenu)

local function teleportPlayer()

end

local function onSubmit(frame, button, ...)
	if admin ~= nil then
    	if frame == 0 then
			local args = {...}

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
	AddPlayerChat(key)
	if binds[key] then
		CallRemoteEvent("KeyPressNoclip", key, false)
	end
end
AddEvent("OnKeyRelease", onKeyRelease)