local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

Players = {} -- Cache players informations, and auto save from it
Profiles = {}

local Models = {
    shirtsModel = {
        formal_shirt_1 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt_LPR",
        formal_shirt_2 ="/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt2_LPR",
        simple_shirt = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR",
        knitted_shirt_2 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted2_LPR",
        knitted_shirt_1 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted_LPR",
        tshirt = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_LPR",
    },

    pantsModel = {
        cargo_pants = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_CargoPants_LPR",
        denim_pants = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_DenimPants_LPR",
        formal_pants = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR"
    },

    shoesModel = {
        normal_shoes = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR",
        business_shoes = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR"
    },
    hairsModel = {
        hairs_business = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Business_LP",
        hairs_scientist ="/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Scientist_LP",
        hairs_1 = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_01_LPR",
        hairs_3 = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_03_LPR",
        hairs_2 = "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_02_LPR"
    }
}

AddEvent("OnSqlConnectionClosed", function() -- Refresh and server stop
    for k,v in pairs(GetAllPlayers()) do
        SavePlayerData(k)
    end
    print("[RealisticBase] All players data saved !")
end)

AddEvent("OnSqlConnectionOpened", function() -- Handle refresh, need to recreate all data after a refresh
    Delay(1000, function()
        for k,v in pairs(GetAllPlayers()) do
            PlayerAuth(k)
        end
    end)
end)

function SavePlayerData(player)
    if player == nil then return end
    if Players[player] == nil then return end

    local x,y,z = GetPlayerLocation(player)
    Players[player].position = tostring(x) .. " " .. tostring(y) .. " " .. tostring(z)

    Players[player].weapons = {}
    for i=1, 3 do
        local weap, ammo = GetPlayerWeapon(player, i)
        if weap ~= 1 then
            table.insert(Players[player].weapons, {
                id = weap,
                ammo = ammo
            })
        end
    end

    local query = mariadb_prepare(SQLConnection, "UPDATE players SET name = '?', money = ?, bank_money = ?, position = '?', model = '?', admin = ?, health = ?, armor = ?, thirst = ?, stamina = ?, hunger = ?, inventory = '?', weapons = '?' WHERE steamid = '?' AND profile_id = ? LIMIT 1;",
        -- VALUES
        Players[player].name or "", 
        math.tointeger(Players[player].money) or 0, 
        math.tointeger(Players[player].bank_money) or 0, 
        Players[player].position or "", 
        json_encode(Players[player].model) or "", 
        math.tointeger(Players[player].admin) or 0,
		GetPlayerHealth(player) or 100,
        GetPlayerArmor(player) or 0,
        math.tointeger(Players[player].thirst) or 100,
        math.tointeger(Players[player].stamina) or 100,
        math.tointeger(Players[player].hunger) or 100,
        json_encode(Players[player].inventory) or "",
        json_encode(Players[player].weapons) or "",
        -- WHERE
        tostring(GetPlayerSteamId(player)), math.tointeger(Players[player].profile_id))
    mariadb_query(SQLConnection, query)
    
    print("[RealisticBase] Saved Data of "..GetPlayerName(player).." - "..GetPlayerSteamId(player))
end

function PlayerAuth(player)
    local query = mariadb_prepare(SQLConnection, "SELECT id, profile_id, name FROM players WHERE steamid = '?';", tostring(GetPlayerSteamId(player)))
    mariadb_async_query(SQLConnection, query, IntroducePlayer, player)
end
AddEvent("OnPlayerSteamAuth", PlayerAuth)

AddEvent("OnPlayerJoin", function(player)
	SetPlayerSpawnLocation(player, 125773.000000, 80246.000000, 1645.000000, 90.0)
end)

AddEvent("OnPlayerQuit", function(player)
    SavePlayerData(player)
    Delay(500, function()
        Players[player] = nil
        Profiles[player] = nil
    end)
end)

function IntroducePlayer(player)
    Profiles[player] = {}
    local toSend = {} -- 2 table dimension to network
    local rows = mariadb_get_row_count()
    if rows ~= 0 then
        for i=1, rows do
            local infos = mariadb_get_assoc(i)
            Profiles[player][infos.profile_id] = {
                id = infos.id,
                name = infos.name
            }

            toSend[infos.profile_id] = Profiles[player][infos.profile_id]
        end
    end

    CallRemoteEvent(player, "ShowCharacterMenu", toSend)
end

function PlayerChooseProfile(player, profile_id)
    if Profiles[player][profile_id] == nil then AddPlayerChat(player, "Invalid profile id !") PlayerAuth(player) return end

    local query = mariadb_prepare(SQLConnection, "SELECT * FROM players WHERE steamid = '?' AND profile_id = ?;", tostring(GetPlayerSteamId(player)), profile_id)
    mariadb_async_query(SQLConnection, query, CreatePlayerData, player, profile_id)
end
AddRemoteEvent("PlayerChooseProfile", PlayerChooseProfile)

function ComputePlayerPos(text_pos)
    if text_pos == nil then return {} end

    local comput_pPos = {}
    for i in string.gmatch(text_pos, "%S+") do
        if comput_pPos.x == nil then comput_pPos.x = i elseif comput_pPos.y == nil then comput_pPos.y = i elseif comput_pPos.z == nil then comput_pPos.z = i end
    end
    return comput_pPos
end

function CreatePlayerData(player, profile_id)
    if mariadb_get_row_count() == 0 then AddPlayerChat(player, "Error with the database, please contact the server owner !") PlayerAuth(player) return end

    local infos = mariadb_get_assoc(1)
    infos["spawned"] = false

    Players[player] = {}
    Players[player].profile_id = profile_id

    local toNumber = {
        ["money"] = true,
        ["bank_money"] = true,
        ["health"] = true,
        ["armor"] = true,
        ["thirst"] = true,
        ["stamina"] = true,
        ["hunger"] = true,
        ["admin"] = true
    }

    for k,v in pairs(infos) do
        if k == "inventory" or k == "weapons" or k == "model" then v = json_decode(v) end
        if toNumber[k] then v = tonumber(v) end

        Players[player][k] = v
    end

    SetPlayerName(player, Players[player].name)
    SetPlayerHealth(player, Players[player].health)
    SetPlayerArmor(player, Players[player].armor)
    -- TODO: Set the player thirst, hunger, stamina

    SetPlayerCothe(player, player)
    local ws = 1
    for k,v in pairs(Players[player].weapons) do
        if v.id ~= nil and v.ammo ~= nil and v.id ~= 1 then
            SetPlayerWeapon(player, v.id, v.ammo, false, ws, true)
            ws = ws + 1
        end
    end

    print("[RealisticBase] Data created for player "..GetPlayerName(player).." - "..GetPlayerSteamId(player))

    local toPos = RealisticBase.SpawnPoses
    toPos["Last Position"] = true
    CallRemoteEvent(player, "ShowSpawnMenu", toPos)
end

AddRemoteEvent("ServerPlayerSpawn", function(player, pos)
    if Players[player].spawned then return end -- Protection
    if RealisticBase.SpawnPoses[pos] == nil and pos ~= "Last Position" then
        local toPos = RealisticBase.SpawnPoses
        toPos["Last Position"] = true
        CallRemoteEvent(player, "ShowSpawnMenu", toPos)
        return
    end

    local poses = RealisticBase.SpawnPoses[pos]
    if pos == "Last Position" then
        local a = ComputePlayerPos(Players[player].position)
        if a.x == nil or a.y == nil or a.z == nil then
            AddPlayerChat(player, "Invalid last positions !")
            CallRemoteEvent(player, "ShowSpawnMenu", RealisticBase.SpawnPoses)
            return
        else poses = a end
    end

    SetPlayerLocation(player, poses.x, poses.y, poses.z)
    
    Players[player].spawned = true
end)

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

AddRemoteEvent("ServerNewProfile", function(player, infos)
    local model = {}
    for k,v in pairs(infos) do
        if k ~= "name" then
            model[k] = (RealisticBase[k] ~= nil and RealisticBase[k][v]) or (Models[k] ~= nil and Models[k][v]) or ''
        end
    end

    if tablelength(Profiles[player]) >= RealisticBase.MaxCharacters then AddPlayerChat(player, "You've got too many characters !") PlayerAuth(player) return end

    local query = mariadb_prepare(SQLConnection, "INSERT INTO players (steamid, profile_id, name, model, admin) VALUES ('?', ?, '?', '?', ?)",
        tostring(GetPlayerSteamId(player)),
        tablelength(Profiles[player])+1,
        infos.name,
        json_encode(model),
        GetID(player) == RealisticBase.SteamIDOwner and 3 or 0)
    mariadb_query(SQLConnection, query, PlayerAuth, player) -- Request player wich profile to choose
    AddPlayerChat(player, "New profile created !")
end)

AddRemoteEvent("ServerGetClothe", function(player)
    CallRemoteEvent(player, "ClientSetClothe", Models.shirtsModel, Models.pantsModel, Models.shoesModel, Models.hairsModel, RealisticBase.hairsColor)
end)

function SetPlayerCothe(player, playerTo)
    if not Players[playerTo] then return end

    CallRemoteEvent(player, "ClientChangeClothing", playerTo, 0,
        Players[playerTo].model["hairsModel"],
        Players[playerTo].model["hairsColor"][1],
        Players[playerTo].model["hairsColor"][2],
        Players[playerTo].model["hairsColor"][3],
        Players[playerTo].model["hairsColor"][4])
    CallRemoteEvent(player, "ClientChangeClothing", playerTo, 1, Players[playerTo].model["shirtsModel"], 0, 0, 0, 0)
    CallRemoteEvent(player, "ClientChangeClothing", playerTo, 4, Players[playerTo].model["pantsModel"], 0, 0, 0, 0)
    CallRemoteEvent(player, "ClientChangeClothing", playerTo, 5, Players[playerTo].model["shoesModel"], 0, 0, 0, 0)
end
AddRemoteEvent("ServerGetOtherPlayerCothe", SetPlayerCothe)


function cmd_w(player, weapon, slot, ammo)
	if (weapon == nil or slot == nil or ammo == nil) then
		return AddPlayerChat(player, "Usage: /w <weapon> <slot> <ammo>")
	end

	SetPlayerWeapon(player, weapon, ammo, true, slot, true)
end
AddCommand("w", cmd_w)
AddCommand("weapon", cmd_w)