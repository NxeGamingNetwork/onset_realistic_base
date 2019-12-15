-- Lock/unlock system
local function lockSystem(key)
    if key == "U" then
        CallRemoteEvent("lockSystemEvent")
    end
end
AddEvent("OnKeyPress", lockSystem)