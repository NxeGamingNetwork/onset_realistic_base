-- Send net when command
local function openAdminMenu(player)
    CallRemoteEvent(player, "OpenAdminMenu")
end
AddCommand("admin", openAdminMenu)
AddCommand("admin_menu", openAdminMenu)
AddCommand("amenu", openAdminMenu)