--[[ Admin menu system ]]--
-- Send net when command
local function openAdminMenu(player)
    if not CheckAdmin(player) then return AddPlayerChat(player, "<span color=\"#cc1111\">You don't have enough permissions to do this !</>") end

    -- Plys names
    local plysName = {}
    for k,v in pairs(GetAllPlayers()) do
        if IsValidPlayer(v) --[[and v ~= player]] then
            plysName[v] = GetPlayerName(v)
        end
    end

    CallRemoteEvent(player, "OpenAdminMenu", plysName, RealisticBase.PositionsNames)
end
AddCommand("admin", openAdminMenu)
AddCommand("admin_menu", openAdminMenu)
AddCommand("amenu", openAdminMenu)


--[[ Admin functions (networking) ]]--
-- Bring
local function bring(ply1, ply2)
    if not CheckAdmin(ply1) then return AddPlayerChat(ply, "<span color=\"#cc1111\">You don't have enough permissions to do this !</>") end
    local x, y, z = GetPlayerLocation(ply1)
    x = x + 25
    y = y + 25
    SetPlayerLocation(ply2, x, y, z)
    AddPlayerChat(ply1, "You brought "..GetPlayerName(ply2).." to you.")
    AddPlayerChar(ply2, GetPlayerName(ply1).." has brought you to him.")
end
AddRemoteEvent("bringPlayer", bring)

-- Goto
local function goTo(ply1, ply2)
    if not CheckAdmin(ply1) then return AddPlayerChat(ply, "<span color=\"#cc1111\">You don't have enough permissions to do this !</>") end
    local x, y, z = GetPlayerLocation(ply2)
    z = z + 30
    SetPlayerLocation(ply1, x, y, z)
    AddPlayerChat(ply1, "You teleported to "..GetPlayerName(ply2).." !")
end
AddRemoteEvent("gotoPlayer", goTo)

-- GoPos
local function goPos(ply, pos)
    if not CheckAdmin(ply) then return AddPlayerChat(ply, "<span color=\"#cc1111\">You don't have enough permissions to do this !</>") end
    pos = tonumber(pos)
    local pPos = RealisticBase.Positions[pos]
    if type(pPos) ~= "table" then return print("[ERROR | RealisticBase] The specified teleport position is not defined correctly in the config !") end
    SetPlayerLocation(ply, pPos.x, pPos.y, pPos.z)
    AddPlayerChat(ply, "You have been teleported to <span color=\"#0984e3\">"..RealisticBase.PositionsNames[pos].."</> !")
end
AddRemoteEvent("goPosPlayer", goPos)

-- Global advert
local function advert(ply, msg)
    if not CheckAdmin(ply) then return AddPlayerChat(ply, "<span color=\"#cc1111\">You don't have enough permissions to do this !</>") end
    if type(msg) ~= "string" then return end
    if #msg < 3 or #msg > 300 then return end

    AddPlayerChatAll("<span color=\"#cc1111\">GLOBAL ADVERT : "..msg.."</>")
end
AddRemoteEvent("sendGlobalAdvert", advert)



--[[ Noclipping System ]]--

-- Noclip vars
local timer
local noclip = {}
local moves = {
    ["Z"] = false,
    ["Space Bar"] = false,
    ["Left Ctrl"] = false,
    ["Left Shift"] = false
}

-- Noclip movement system
local function noclipSystem()
    timer = CreateTimer(function()
        if type(noclip) ~= "table" then return end
        if #noclip < 1 then return end

        for id,v in pairs(noclip) do
            if not IsValidPlayer(id) then return end 
            local heading = GetPlayerHeading(id)
            local speed = RealisticBase.NoclipSpeed
            if noclip[id]["Left Shift"] then speed = RealisticBase.NoclipSpeed*2 else speed = RealisticBase.NoclipSpeed end
            local vecX, vecY = math.cos(heading * math.pi / 180)*speed, math.sin(heading * math.pi / 180)*speed

            if noclip[id]["Z"] then
                noclip[id]["location"].x = noclip[id]["location"].x + vecX
                noclip[id]["location"].y = noclip[id]["location"].y + vecY
            end
            if noclip[id]["Space Bar"] then
                noclip[id]["location"].z = noclip[id]["location"].z + math.pi*(speed/4)
            end
            if noclip[id]["Left Ctrl"] then
                noclip[id]["location"].z = noclip[id]["location"].z - math.pi*(speed/4)
            end
            SetPlayerLocation(id, noclip[id]["location"].x, noclip[id]["location"].y, noclip[id]["location"].z)
        end
    end, 5)
end
AddEvent("OnPackageStart", noclipSystem)

-- Stop timer system
local function stopTimer()
    if timer == nil then return end
    DestroyTimer(timer)
    timer = nil
end
AddEvent("OnPackageStop", stopTimer)

-- Enable/Disable noclip system
local function enableNoclip(player, multi)
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
AddRemoteEvent("enableNoclipping", enableNoclip)

-- Noclip binds system
local function noclipPos(player, key, bool)
    if not IsValidPlayer(player) then return end
    
    if key == "V" then 
        enableNoclip(player)
        return
    end
    
    if type(noclip[player]) ~= "table" then return end
    if moves[key] == nil then return end
    if type(noclip[player]) ~= "table" then return end
    if type(bool) ~= "boolean" then return end

    noclip[player][key] = bool
end
AddRemoteEvent("KeyPressNoclip", noclipPos)

-- Remove from the table when quitting
local function removeFromNoclip(player)
    if type(noclip[player]) == "table" then
        noclip[player] = nil
    end
end
AddEvent("OnPlayerQuit", removeFromNoclip)