local Dialog = ImportPackage("dialogui")

AddEvent("OnGameTick", function()
    --AddPlayerChat(dump(GetStreamedObjects()))
    --AddPlayerChat(GetObjectCount())
end)

AddEvent("OnKeyPress", function(key)
    if key == 'E' then
        CallRemoteEvent("CanOpenAtmMenu")
    end
end)

local atmMenu = Dialog.create("ATM Menu", "Bank balance: {bank_balance}$ | Cash balance: {cash_balance}$", "Withdraw", "Deposit", "Transfer", "Exit")
Dialog.addTextInput(atmMenu, 1, "Amount: ")
Dialog.addSelect(atmMenu, 1, "Player: ", 4)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
    if dialog == atmMenu then
        if button == 1 and args[1] ~= nil and args[1] ~= nil then
            CallRemoteEvent("ServerWithdrawMoney", args[1])
        elseif button == 2 and args[1] ~= nil and args[1] ~= nil then
            CallRemoteEvent("ServerDepositMoney", args[1])
        elseif button == 3 and args[1] ~= nil and args[1] ~= nil and args[2] ~= nil and args[2] ~= "" then
            CallRemoteEvent("ServerTransferMoney", args[1], args[2])
        end
    end
end)

function ShowAtmMenu(players, bank_balance, cash_balance)
    Dialog.setVariable(atmMenu, "bank_balance", bank_balance)
    Dialog.setVariable(atmMenu, "cash_balance", cash_balance)
    Dialog.setSelectLabeledOptions(atmMenu, 1, 1, players)
    Dialog.show(atmMenu)
end
AddRemoteEvent("OpenATMMenu", ShowAtmMenu)
