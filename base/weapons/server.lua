-- Give a weapon to a player
local function spawnWeapon(player, model)
    model = tonumber(model)
    if model == nil then return AddPlayerChat(player, "Please specify a weapon model (between 1 and 20)") end
    if model < 1 or model > 20 then return AddPlayerChat(player, "Please specify a valid weapon model between 1 and 20") end

    SetPlayerWeapon(player, model, 500, true, 1, false)
end
AddCommand("w", spawnWeapon)
AddCommand("weap", spawnWeapon)
AddCommand("weapon", spawnWeapon)