-- Get the nearest vehicle
function GetNearestVehicle(player)
	local vehicles = GetStreamedVehiclesForPlayer(player)
	local found = 0
	local nearest_dist = 999999
	local x, y, z = GetPlayerLocation(player)

	for _,v in pairs(vehicles) do
		local x2, y2, z2 = GetVehicleLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
		if dist < nearest_dist then
			nearest_dist = dist
			found = v
		end
	end
	return found, nearest_dist
end


-- Get player SteamID
function GetID(player)
	local steamid = GetPlayerSteamId(player)
	if steamid == nil then return false end
	return tostring(steamid)
end


-- Check if a player is an administrator
function CheckAdmin(player)
	if not IsValidPlayer(player) then return end
	local steamId = GetID(player)
	local query = mariadb_prepare(SQLConnection, "SELECT admin FROM players WHERE steamid='?'", steamId)
	query = mariadb_query(SQLConnection, query, function()
		if query ~= false then
			local value = mariadb_get_assoc(1)
			return value			
		end
	end)
	return false
end