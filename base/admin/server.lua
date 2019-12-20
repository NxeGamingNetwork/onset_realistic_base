-- Send net when command
local function openAdminMenu(player)
    CallRemoteEvent(player, "OpenAdminMenu")
end
AddCommand("admin", openAdminMenu)
AddCommand("admin_menu", openAdminMenu)
AddCommand("amenu", openAdminMenu)

-- Noclip vars
local noclip = {}
local moves = {
    ["Z"] = false,
    ["Space Bar"] = false,
    ["Left Ctrl"] = false,
    ["Left Shift"] = false
}

-- Noclip movement system
local function noclipSystem()
    if type(noclip) ~= "table" then return end
    if #noclip < 1 then return end

    for id,v in pairs(noclip) do
        local heading = GetPlayerHeading(id)
        local angX, angY = math.cos(heading * math.pi / 180), math.sin(heading * math.pi / 180)

        noclip[id]["multiplier"] = noclip[id]["multiplier"] or 1
        if noclip[id]["Left Shift"] then noclip[id]["multiplier"] = 3 else noclip[id]["multiplier"] = 1 end
        --print(multiplier)
        if noclip[id]["Z"] then
            noclip[id]["location"].x = noclip[id]["location"].x + angX*RealisticBase.Noclip*noclip[id]["multiplier"]
            noclip[id]["location"].y = noclip[id]["location"].y + angY*RealisticBase.Noclip*noclip[id]["multiplier"]
        end
        if noclip[id]["Space Bar"] then
            noclip[id]["location"].z = noclip[id]["location"].z + math.pi*(RealisticBase.Noclip/4)
        end
        if noclip[id]["Left Ctrl"] then
            noclip[id]["location"].z = noclip[id]["location"].z - math.pi*(RealisticBase.Noclip/4)
        end
        SetPlayerLocation(id, noclip[id]["location"].x, noclip[id]["location"].y, noclip[id]["location"].z)
    end
end
AddEvent("OnGameTick", noclipSystem)

-- Enable/Disable noclip system
local function enableNoclip(player)
    if type(noclip[player]) == "table" then -- then disable noclip
        noclip[player] = nil
        AddPlayerChat(player, "Noclip disabled.")
    else -- then enable noclip
        noclip[player] = moves
        AddPlayerChat(player, "Noclip enabled.")
        local xx,yy,zz = GetPlayerLocation(player)
        noclip[player]["location"] = {x=xx, y=yy, z=zz}
    end
end
AddCommand("noclip", enableNoclip)

-- Noclip binds system
local function noclipPos(player, key, bool)
    if not IsValidPlayer(player) then return end

    print(key)

    if key == "V" then 
        enableNoclip(player)
        return
    end

    if moves[key] == nil then return end
    if type(noclip[player]) ~= "table" then return end
    if type(bool) ~= "boolean" then return end

    noclip[player][key] = bool
end
AddRemoteEvent("KeyPressNoclip", noclipPos)