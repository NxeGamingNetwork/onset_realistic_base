-- A simple lua refresh system (with a command)
local function luaRefresh(player, package)
    if type(package) ~= "string" then return AddPlayerChat(player, "Please specify a package to reload ! Usage : /reload package_name") end
    if package == GetPackageName() then return AddPlayerChat(player, "Can't reload myself !") end
    
    StopPackage(package)
    Delay(500, function()
        StartPackage(package)
    end)
end
AddCommand("reload", luaRefresh)
AddCommand("refresh", luaRefresh)