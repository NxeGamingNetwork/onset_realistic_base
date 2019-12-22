-- Serverside configuration
RealisticBase = RealisticBase or {}

-- SQL Configuration
RealisticBase.Host = "127.0.0.1" -- Host (IP)
RealisticBase.Port = "3306" -- Port
RealisticBase.User = "root" -- User
RealisticBase.Pass = "" -- Password
RealisticBase.Name = "realistic_base" -- Database name (/!\)

-- SteamID64 of the server owner (https://steamidfinder.com/lookup/)
RealisticBase.SteamIDOwner = "76561198161920297"

-- Message to show when the player join the server
RealisticBase.MsgToShow = "Welcome on WasiedRP ! Have a good time in our servers and don't forget to read the rules !"
-- The time the message will be shown (seconds)
RealisticBase.StayTime = 10

-- Noclip speed
RealisticBase.NoclipSpeed = 35

-- Auto-deployment of the parachute when starting to fall (true/false)
RealisticBase.AutoParachute = true

-- Positions availables in the admin menu
RealisticBase.Positions = {
    [1] = {x=126885, y=78414, z=2064},
    [2] = {x=42695, y=134974, z=1567},
    [3] = {x=-176235, y=-43373, z=1128}
}
-- The name of the ID position
RealisticBase.PositionsNames = {
    [1] = "Pump station",
    [2] = "Little town 1",
    [3] = "New city"
}

RealisticBase.SpawnPoses = {
    ["New City"] = {x=-176235, y=-43373, z=1128},
    ["Little town"] = {x=42695, y=134974, z=1567}
}

RealisticBase.hairsColor = {
    blond = { 250, 240, 190, 1 },
    black = { 0, 0, 0, 1 },
    red = { 255, 0, 0, 1 },
    brown = { 139, 69, 19, 1 }
}

RealisticBase.MaxCharacters = 3

RealisticBase.AnnouncementColors = {
    color_blue = "#1854b5",
    color_red = "#c21117",
    color_green = "#11c21d"
}