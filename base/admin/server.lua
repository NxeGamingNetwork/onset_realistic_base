-- Add owner in the database
local function addOwner(player)
    local plyId = GetPlayerSteamId(player)
    if RealisticBase.SteamIDOwner ~= tostring(plyId) then return end

    SendRequest("UPDATE players SET admin=3 WHERE steamid='?'", RealisticBase.SteamIDOwner)
end
AddEvent("OnPlayerJoin", addOwner)