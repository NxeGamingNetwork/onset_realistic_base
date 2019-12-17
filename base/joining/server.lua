-- Add a player in the database when he connect to the server
local function addNewPlayer(player)
    Delay(2000, function() -- thx steam
        local pId = GetID(player)
        local pName = GetPlayerName(player)
        local admin = 0

        -- If he is the owner
        if pId == RealisticBase.SteamIDOwner then admin = 3 end

        -- Create in the database | If already exists then just update the name (in case of edit)
        local prepare = mariadb_prepare(SQLConnection, "INSERT INTO players(steamid, name, admin) VALUES('?', '?', ?) ON DUPLICATE KEY UPDATE name='?', admin=?", pId, pName, admin, pName, admin)
        prepare = mariadb_query(SQLConnection, prepare, function()
            if prepare then print("[RealisticBase] Player "..pName.." has been successfully updated !") else print("[RealisticBase] Player "..pName.." can't be created !") end
        end)

        -- Draw welcome message
        CallRemoteEvent(player, "SendWelcomeMessage", RealisticBase.MsgToShow, RealisticBase.StayTime*1000)
    end)
end
AddEvent("OnPlayerJoin", addNewPlayer)