local vehiclesData = {}

-- Create a specified vehicle
function createVehicle(player, model, nitro)
	if model == nil then
		return AddPlayerChat(player, "Please specify a model (1-12) : /veh 1")
	end

	model = tonumber(model)
	if model < 1 or model > 12 then
		return AddPlayerChat(player, "Vehicle model "..model.." does not exist.")
	end

	local x, y, z = GetPlayerLocation(player)
	local h = GetPlayerHeading(player)

	local vehicle = CreateVehicle(model, x, y, z, h)
	if vehicle == false then
		return AddPlayerChat(player, "Failed to spawn your vehicle")
	end

	SetVehicleLicensePlate(vehicle, "RealisticBase")
	if type(nitro) ~= "bool" then nitro = false end -- Set default value to false
	if nitro then
		AttachVehicleNitro(vehicle, true)
	end

	if model == 8 then
		-- Set Ambulance blue color and license plate text
		SetVehicleColor(vehicle, RGB(0.0, 60.0, 240.0))
		SetVehicleLicensePlate(vehicle, "EMS-01")
	end

    -- Make player enter
	SetPlayerInVehicle(player, vehicle)

	AddPlayerChat(player, "Vehicle spawned !")
end
AddCommand("v", createVehicle)
AddCommand("veh", createVehicle)
AddCommand("vehicle", createVehicle)
AddCommand("vehicule", createVehicle)


-- Lock/Unlock system
local function lockSystem(player)
	local vehicle = GetNearestVehicle(player)
	if not IsValidVehicle(vehicle) then return end

	-- if doesn't exists, then insert the first player
	if vehiclesData[vehicle] ~= nil then
		vehiclesData[vehicle] = {
			["owner"] = player,
			["locked"] = true
		}
	end

	if vehiclesData[vehicle]["locked"] then
		vehiclesData[vehicle]["locked"] = false
		AddPlayerChat(player, "Vous avez dévérouillé votre véhicule !")
	else
		vehiclesData[vehicle]["locked"] = true
		AddPlayerChat(player, "Vous avez vérouillé votre véhicule !")
	end
end
AddRemoteEvent("lockSystemEvent", lockSystem)