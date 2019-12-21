local Dialog = ImportPackage("dialogui")
Dialog.setGlobalTheme("saitama")

local spawnMenu = Dialog.create("Spawn menu", nil, "Spawn")
Dialog.addSelect(spawnMenu, 1, "Positions:" , 8)

local charactMenu = Dialog.create("Character Menu", nil, "Select", "New")
Dialog.addSelect(charactMenu, 1, "Available characters: ", 8)

local charactMenuCreation1 = Dialog.create("Character Creation", nil, "Create", "Back")
Dialog.addTextInput(charactMenuCreation1, 1, "Name: ")
Dialog.addSelect(charactMenuCreation1, 1, "Hairs selection: ", 4)
Dialog.addSelect(charactMenuCreation1, 2, "Hairs color: ", 4)
Dialog.addSelect(charactMenuCreation1, 1, "Shirt selection: ", 4)
Dialog.addSelect(charactMenuCreation1, 2, "Pants selection: ", 4)
Dialog.addSelect(charactMenuCreation1, 1, "Shoes selection: ", 4)

function ShowSpawnMenu(spawnPoses)
    local toPos = {}
    for k,v in pairs(spawnPoses) do
        toPos[k] = k
    end
    Dialog.setSelectLabeledOptions(spawnMenu, 1, 1, toPos)
    Dialog.show(spawnMenu)
end
AddRemoteEvent("ShowSpawnMenu", ShowSpawnMenu)

function ShowCharacterMenu(profiles)
    local toShow = {}
    
    for k,v in pairs(profiles) do
        toShow[k] = "Profile #"..k.." - "..v.name
    end
    Dialog.setSelectLabeledOptions(charactMenu, 1, 1, toShow)

    Dialog.show(charactMenu)
end
AddRemoteEvent("ShowCharacterMenu", ShowCharacterMenu)

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }

    if dialog == spawnMenu then
        if button == 1 then
            if args[1] == nil then AddPlayerChat("You need to select a valid spawn point !") Dialog.show(spawnMenu) end
            CallRemoteEvent("ServerPlayerSpawn", args[1])
        end
    elseif dialog == charactMenu then
        if button == 1 then
            if args[1] == nil then AddPlayerChat("You need to select your profile !") Dialog.show(charactMenu) end
            CallRemoteEvent("PlayerChooseProfile", args[1])
        end
        if button == 2 then CallRemoteEvent("ServerGetClothe") end-- Dialog.show(charactMenuCreation1) end
    elseif dialog == charactMenuCreation1 then
        if button == 1 then
            if args[1] == nil or args[2] == nil or args[3] == nil or args[4] == nil or args[5] == nil or args[6] == nil then
                AddPlayerChat("You need to select your outfits and your name !") Dialog.show(charactMenuCreation1)
            end
        
            CallRemoteEvent("ServerNewProfile", {
                name = args[1],
                hairsModel = args[2],
                shirtsModel = args[3],
                shoesModel = args[4],
                hairsColor = args[5],
                pantsModel = args[6],
            })
        end
        if button == 2 then Dialog.show(charactMenu) end
    end
end)

AddRemoteEvent("ClientSetClothe", function(shirtsModel, pantsModel, shoesModel, hairsModel, hairsColor)
    local toSm = {}
    for k,v in pairs(shirtsModel) do
        toSm[k] = k
    end
    local toPm = {}
    for k,v in pairs(pantsModel) do
        toPm[k] = k
    end
    local toSsm = {}
    for k,v in pairs(shoesModel) do
        toSsm[k] = k
    end
    local toHm = {}
    for k,v in pairs(hairsModel) do
        toHm[k] = k
    end
    local toHc = {}
    for k,v in pairs(hairsColor) do
        toHc[k] = k
    end
    Dialog.setSelectLabeledOptions(charactMenuCreation1, 1, 2, toHm)
    Dialog.setSelectLabeledOptions(charactMenuCreation1, 2, 1, toHc)
    Dialog.setSelectLabeledOptions(charactMenuCreation1, 1, 3, toSm)
    Dialog.setSelectLabeledOptions(charactMenuCreation1, 2, 2, toPm)
    Dialog.setSelectLabeledOptions(charactMenuCreation1, 1, 4, toSsm)
    Dialog.show(charactMenuCreation1)
end)

local PlayersCothes = {}

AddEvent("OnPlayerStreamIn", function(player)
    CallRemoteEvent("ServerGetOtherPlayerCothe", player)
end)

AddRemoteEvent("ClientChangeClothing", function(player, part, piece, r, g, b, a)
    local SkeletalMeshComponent
    local pieceName
    if part == 0 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing0")
        pieceName = piece
    end
    if part == 1 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing1")
        pieceName = piece
    end
    if part == 4 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing4")
        pieceName = piece
    end
    if part == 5 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing5")
        pieceName = piece
    end
    SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(pieceName))
    if part == 0 then
        local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)
        DynamicMaterialInstance:SetColorParameter("Hair Color", FLinearColor(r, g, b, a))
    end
end)