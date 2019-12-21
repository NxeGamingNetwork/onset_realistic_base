-- Lock/unlock system
local function lockSystem(key)
    if key == "U" then
        CallRemoteEvent("lockSystemEvent")
    end
end
AddEvent("OnKeyPress", lockSystem)

-- Prevent the player to enter a vehicle
local function preventEntering(vehicle)
	if GetVehiclePropertyValue(vehicle, "locked") then
		AddPlayerChat("The doors are locked.")
		return false -- no enter
	end
end
AddEvent("OnPlayerStartEnterVehicle", preventEntering)