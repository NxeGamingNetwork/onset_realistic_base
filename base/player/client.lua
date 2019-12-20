-- Call open parachute func when falling
local function onFalling()
    CallRemoteEvent("addParachute", true)
end
AddEvent("OnPlayerSkydive", onFalling)

local function removeParachute()
    CallRemoteEvent("addParachute", false)
end
AddEvent("OnPlayerCancelSkydive", removeParachute)