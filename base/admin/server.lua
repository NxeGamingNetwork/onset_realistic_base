-- Add owner on starting package
local function addOwner()
    SendRequest("SELECT * FROM players WHERE steamid='?' AND name='?'", 5, 9)
end
AddEvent("OnPackageStart", addOwner)