-- Don't touch
SQLConnection = false
local try = 1
local createTable = "CREATE TABLE IF NOT EXISTS `players` (`id` int(11) NOT NULL AUTO_INCREMENT, `steamid` varchar(255) NOT NULL, `profile_id` int(11) NOT NULL, `name` varchar(255) NOT NULL DEFAULT '[[]]', `money` int(11) DEFAULT 0, `bank_money` int(11) NOT NULL DEFAULT 1000, `position` varchar(255) NOT NULL DEFAULT '[[]]', `model` TEXT NOT NULL DEFAULT '[[]]', `admin` int(11) NOT NULL DEFAULT 0, `health` int(11) NOT NULL DEFAULT 100, `armor` int(11) NOT NULL DEFAULT 0, `thirst` int(11) NOT NULL DEFAULT 100, `stamina` int(11) NOT NULL DEFAULT 100, `hunger` int(11) NOT NULL DEFAULT 100, `inventory` TEXT NOT NULL DEFAULT '[[]]', `weapons` TEXT NOT NULL DEFAULT '[[]]', PRIMARY KEY (`id`));"
local createTableAnnouncements = "CREATE TABLE IF NOT EXISTS `announcements` (`id` int(11) NOT NULL AUTO_INCREMENT, `content` TEXT NOT NULL, `time` int(20) NOT NULL, `color` TEXT NOT NULL, PRIMARY KEY (`id`));"

local Checks = {
    ["players"] = createTable,
    ["announcements"] = createTableAnnouncements,
}

-- Connect to database when the package is starting
local function connect_db()
    SQLConnection = mariadb_connect(RealisticBase.Host..":"..RealisticBase.Port, RealisticBase.User, RealisticBase.Pass, RealisticBase.Name)
    if not SQLConnection then 
        print("[ERROR | RealisticBase] Can't connect to "..RealisticBase.Host.." ! Please check all the fields in the config file (attempt "..try..")")
        
        if try <= 5 then
            Delay(3000, function()
                print("[ERROR | RealisticBase] Retrying connection...")
                try = try + 1
                connect_db()
            end)
        else
            print("[ERROR | RealisticBase] After 5 attempts, can't connect to the database. Stopping the server.")
            try = 0
            Delay(1000, function()
                ServerExit() -- close server
            end)
        end
    else
        print("[RealisticBase] Database "..RealisticBase.Host.." successfully connected !")

        for k,v in pairs(Checks) do -- Check if tables exists
            local query = mariadb_prepare(SQLConnection, v)
            mariadb_await_query(SQLConnection, query, false)
        end

        CallEvent("OnSqlConnectionOpened", SQLConnection)
    end
end
AddEvent("OnPackageStart", connect_db)

-- Stop when stoping package
local function disconnect_db()
    if not SQLConnection then return end
    CallEvent("OnSqlConnectionClosed", SQLConnection)
    Delay(1000, function()
        mariadb_close(SQLConnection)
    end)
end
AddEvent("OnPackageStop", disconnect_db)