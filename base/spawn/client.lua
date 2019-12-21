local Dialog = ImportPackage("dialogui")
Dialog.setGlobalTheme("saitama")

local spawnMenu = Dialog.create("Spawn menu", nil, "Spawn")
Dialog.addSelect(spawnMenu, 1, "Positions:" , 8)

function ShowSpawnMenu(spawnPoses)
    local toPos = {}
    for k,v in pairs(spawnPoses) do
        toPos[k] = k
    end
    Dialog.setSelectLabeledOptions(spawnMenu, 1, 1, toPos)
    Dialog.show(spawnMenu)
end
AddRemoteEvent("ShowSpawnMenu", ShowSpawnMenu)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }

    if dialog == spawnMenu then
        if button == 1 then
            CallRemoteEvent("ServerPlayerSpawn", args[1])
        end
    end
end)