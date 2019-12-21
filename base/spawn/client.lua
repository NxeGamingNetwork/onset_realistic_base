local Dialog = ImportPackage("dialogui")
Dialog.setGlobalTheme("saitama")

local spawnMenu = Dialog.create("Spawn menu", nil, "Spawn")

function ShowSpawnMenu(spawnPoses)

end
AddRemoteEvent("ShowSpawnMenu", ShowSpawnMenu)

AddEventHandler("OnDialogSubmit", function(dialog, button, ...)
    if dialog == spawnMenu then
        if button == 1 then
            
        end
    end
end)
