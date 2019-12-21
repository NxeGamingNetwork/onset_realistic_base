AddEvent("OnPlayerSpawn", function(player)
    CallRemoteEvent(player, "ShowSpawnMenu", RealisticBase.SpawnPoses)

    print("New Player connected")
end)

local spawnedPlayers = {}

AddEvent("OnPlayerQuit", function(player)
    spawnedPlayers[player] = nil
end)
AddRemoteEvent("ServerPlayerSpawn", function(player, pos)
    if spawnedPlayers[player] then return end -- Protection
    if RealisticBase.SpawnPoses[pos] == nil then return end

    SetPlayerLocation(player, RealisticBase.SpawnPoses[pos].x, RealisticBase.SpawnPoses[pos].y, RealisticBase.SpawnPoses[pos].z)
    
    spawnedPlayers[player] = true

    AddPlayerChatAll("Hi to "..GetPlayerName(player))
end)
