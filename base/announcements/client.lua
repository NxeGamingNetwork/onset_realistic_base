local Dialog = ImportPackage("dialogui")

local annoucementMenu = Dialog.create("Announcements Menu", nil, "Edit", "New", "Close")
Dialog.addSelect(annoucementMenu, 1, "Annoucements list: ", 8)

local editAnnouncement = Dialog.create("Edit annoucement", nil, "Save", "Cancel")
Dialog.addTextInput(editAnnouncement, 1, "Content: ")
Dialog.addTextInput(editAnnouncement, 1, "Time: ")
Dialog.addSelect(editAnnouncement, 1, "Announcement's color: ", 8)

local newAccouncement = Dialog.create("New announcement", nil, "Save", "Back")
Dialog.addTextInput(newAccouncement, 1, "Content: ")
Dialog.addTextInput(newAccouncement, 1, "Time: ")
Dialog.addSelect(newAccouncement, 1, "Announcement's color: ", 8)

local Annoucements = {}
function ShowAnnouncementMenu(annoucements, colors)
    Annoucements = annoucements
    local toList = {}
    for k,v in pairs(annoucements) do
        toList[k] = "#"..k.." - "..v.time.."s - "..v.color.." - "..v.content
    end
    Dialog.setSelectLabeledOptions(annoucementMenu, 1, 1, toList)

    local toColors = {}
    for k,v in pairs(colors) do
        toColors[k] = k
    end
    Dialog.setSelectLabeledOptions(newAccouncement, 1, 3, toColors)
    Dialog.setSelectLabeledOptions(editAnnouncement, 1, 3, toColors)

    Dialog.show(annoucementMenu)
end
AddRemoteEvent("ShowAnnouncementMenu", ShowAnnouncementMenu)

local a_id
AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }

    if dialog == annoucementMenu then
        if button == 1 and args[1] ~= nil then
            a_id = args[1]
            Dialog.show(editAnnouncement)
        elseif button == 1 then AddPlayerChat("You need to select an announcement") Dialog.show(annoucementMenu)
        elseif button == 2 then Dialog.show(newAccouncement) end
    elseif dialog == editAnnouncement then
        if args[1] == nil or args[1] == "" or a_id == nil then AddPlayerChat("Invalid arguments !") Dialog.show(annoucementMenu) return end

        if tonumber(args[2]) == nil or tonumber(args[2]) <= 0 then args[2] = 30 end
        if args[3] == nil or args[3] == "" then args[3] = "color_red" end

        CallRemoteEvent("ServerEditAnnouncement", a_id, args[1], args[2], args[3])
        a_id = nil
    elseif dialog == newAccouncement then
        if button == 1 then
            if args[1] == nil or args[1] == "" then AddPlayerChat("You need to set a valid content !") Dialog.show(newAccouncement) return end

            if tonumber(args[2]) == nil or tonumber(args[2]) <= 0 then args[2] = 30 end
            if args[3] == nil or args[3] == "" then args[3] = "color_red" end

            AddPlayerChat(dump(args))

            CallRemoteEvent("ServerNewAnnouncement", args[1], args[2], args[3])
        elseif button == 2 then Dialog.show(annoucementMenu) end
    end
end)