Announcements = {}

AddEvent("OnSqlConnectionOpened", function() -- Handle refresh, need to recreate all data after a refresh
    Delay(1000, function()
        local query = mariadb_prepare(SQLConnection, "SELECT * FROM announcements;")
        mariadb_query(SQLConnection, query, SaveAnnouncements)
    end)
end)

function SaveAnnouncements()
    if mariadb_get_row_count() == 0 then return end
    
    local rows = mariadb_get_row_count()
    for i=1, rows do
        local result = mariadb_get_assoc(i)

        Announcements[i] = {
            content = result["content"],
            color = result["color"],
            time = tonumber(result["time"])
        }
    end

    print("[RealisticBase] All Announcements created !")
end

function OpenAnnounMenu(player)
    if not CheckAdmin(player) then return end
    CallRemoteEvent(player, "ShowAnnouncementMenu", Announcements, RealisticBase.AnnouncementColors)
end
AddCommand("announcement", OpenAnnounMenu)

AddRemoteEvent("ServerEditAnnouncement", function(player, id, content, time, color)
    if not CheckAdmin(player) then return end
    id = tonumber(id)
    if not Announcements[id] then return end
    time = math.abs(tonumber(time) or 0)
    if content == nil or content == "" or color == nil or color == "" or time == nil or time <= 0 then AddPlayerChat(player, "Invalid args !") OpenAnnounMenu(player) return end

    local query = mariadb_prepare(SQLConnection, "UPDATE announcements SET content = '?', time = ?, color = '?' WHERE id = ? LIMIT 1;",
        content, time, color, id)
    mariadb_query(SQLConnection, query)

    Announcements[id] = {
        content = content,
        color = color,
        time = time
    }

    AddPlayerChat(player, "Announcement #"..id.." edited !")
end)

AddRemoteEvent("ServerNewAnnouncement", function(player, content, time, color)
    if not CheckAdmin(player) then return end
    if content == nil or color == nil or RealisticBase.AnnouncementColors[color] == nil or tonumber(time) == nil then AddPlayerChat(player, "Invalid args !") OpenAnnounMenu(player) return end
    time = math.abs(tonumber(time))

    local query = mariadb_prepare(SQLConnection, "INSERT INTO announcements (content, color, time) VALUES ('?', '?', ?);",
        content, color, time)
    mariadb_query(SQLConnection, query)

    Announcements[tablelength(Announcements)+1] = {
        content = content,
        color = color,
        time = time
    }

    AddPlayerChat(player, "New announcement added !")
end)

local lastThink = GetTimeSeconds() + 1
AddEvent("OnGameTick", function()
    if lastThink > GetTimeSeconds() then return end

    for k,v in pairs(Announcements) do
        if v.last == nil then v.last = GetTimeSeconds() + v.time end

        if v.last <= GetTimeSeconds() then
            AddPlayerChatAll("<span color=\""..RealisticBase.AnnouncementColors[v.color].."\">"..v.content.."</>")

            v.last = GetTimeSeconds() + v.time
        end
    end
end)