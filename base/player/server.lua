-- Add parachute function
local function addParachute(player, bool)
    if not RealisticBase.AutoParachute then return end
    AttachPlayerParachute(player, bool)
end
AddRemoteEvent("addParachute", addParachute)