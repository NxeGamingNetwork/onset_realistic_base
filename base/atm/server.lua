local atms = {
    modelid = 336,
    pos = {
        {43821.29296875, 133144.375, 1509.1500244141},
        {43821.375, 133058.90625, 1509.1500244141},
        
    }
}
-- TODO: Add all atms locations

local spawnedAtms = {}

AddEvent("OnPackageStop", function()
    for k,v in pairs(spawnedAtms) do
        DestroyPickup(v)
    end
end)

AddEvent("OnPackageStart", function()
    for k,v in pairs(atms.pos) do
        if not spawnedAtms[k] then
            spawnedAtms[k] = CreatePickup(atms.modelid, v[1], v[2], v[3])
        end
    end
end)

AddEvent("OnPlayerPickupHit", function(player, pickup)
    if not Players[player] then return end

    local found = false
    for k,v in pairs(spawnedAtms) do
        if v == pickup then found = true end
    end
    if not found then return end

    Players[player].closeToAtm = GetTimeSeconds()
    AddPlayerChat(player, "Press E to open the ATM !")
end)

AddCommand("getpos", function(player)
    local x,y,z = GetPlayerLocation(player)
    z = z - 40
    AddPlayerChat(player, x..", "..y..", "..z)
    print(x..", "..y..", "..z)
end)

AddRemoteEvent("CanOpenAtmMenu", function(player)
    if not Players[player] then return end
    if Players[player].closeToAtm ~= nil and Players[player].closeToAtm + 10 < GetTimeSeconds() then return end

    local toPlayers = {}
    for k,v in pairs(GetAllPlayers()) do
        toPlayers[k] = GetPlayerName(k)
    end
    CallRemoteEvent(player, "OpenATMMenu", toPlayers, Players[player].bank_money, Players[player].money)
end)

function withdrawMoney(player, amount)
    if not Players[player] then return end
    if Players[player].closeToAtm and Players[player].closeToAtm + 10 < GetTimeSeconds() then return end
    amount = tonumber(amount)
    if not amount then return end
    amount = math.abs(amount)

    if Players[player].bank_money < amount then AddPlayerChat(player, "You don't have that amount of money !") return end
    Players[player].money = Players[player].money + amount
    Players[player].bank_money = Players[player].bank_money - amount

    AddPlayerChat(player, "You withdrawed "..amount.."$ from your bank account !")
end
AddRemoteEvent("ServerWithdrawMoney", withdrawMoney)

function depositMoney(player, amount)
    if not Players[player] then return end
    if Players[player].closeToAtm and Players[player].closeToAtm + 10 < GetTimeSeconds() then return end
    amount = tonumber(amount)
    if not amount then return end
    amount = math.abs(amount)

    if Players[player].money < amount then AddPlayerChat(player, "You don't have that amount of money !") return end
    Players[player].money = Players[player].money - amount
    Players[player].bank_money = Players[player].bank_money + amount

    AddPlayerChat(player, "You deposited "..amount.."$ to your bank account !")
end
AddRemoteEvent("ServerDepositMoney", depositMoney)

function transferMoney(player, toPlayer, amount)
    if not Players[player] then return end
    if not Players[toPlayer] then return end
    if Players[player].closeToAtm and Players[player].closeToAtm + 10 < GetTimeSeconds() then return end
    amount = tonumber(amount)
    if not amount then return end
    amount = math.abs(amount)

    if Players[player].bank_money < amount then AddPlayerChat(player, "You don't have that amount of money !") return end
    Players[player].bank_money = Players[player].bank_money - amount
    Players[toPlayer].bank_money = Players[toPlayer].bank_money + amount

    AddPlayerChat(player, "You transfered ".. amount .."$ to "..GetPlayerName(toPlayer))
    AddPlayerChat(player, "You received "..amount.."$ from "..GetPlayerName(player))
end
AddRemoteEvent("ServerTransferMoney", transferMoney)