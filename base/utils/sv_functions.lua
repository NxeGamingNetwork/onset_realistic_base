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


-- Send requests to database
function SendRequest(request, ...)
	local args = {...} -- all the args
	local count = #args

	local prepare = false
	if type(args) ~= "table" or #args <= 1 then
		prepare = mariadb_prepare(request)
	elseif count == 1 then
		prepare = mariadb_prepare(request, args[1])
	elseif count == 2 then
		prepare = mariadb_prepare(request, args[1], args[2])
	elseif count == 3 then
		prepare = mariadb_prepare(request, args[1], args[2], args[3])
	elseif count == 4 then
		prepare = mariadb_prepare(request, args[1], args[2], args[3], args[4])
	end
	if not prepare then return false end

	local query = mariadb_query(SQLConnexion, prepare)
	return query -- return query or false if fail
end


-- Check if a player is an administrator
function CheckAdmin(player)
	local steamId = GetPlayerSteamId(player)
	local query = SendRequest("SELECT admin FROM players WHERE steamid='?'", tostring(steamid))
	print(query)
end