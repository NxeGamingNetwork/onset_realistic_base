local Dialog = ImportPackage("dialogui") -- UI Lib
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