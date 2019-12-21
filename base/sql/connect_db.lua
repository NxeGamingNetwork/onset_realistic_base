-- Don't touch
SQLConnection = false
local try = 1
local createTable = "CREATE TABLE IF NOT EXISTS `players` (`id` int(11) NOT NULL AUTO_INCREMENT, `steamid` varchar(255) NOT NULL, `profile_id` int(11) NOT NULL, `name` varchar(255) NOT NULL DEFAULT '[[]]', `money` int(11) DEFAULT 0, `bank_money` int(11) NOT NULL DEFAULT 1000, `position` varchar(255) NOT NULL DEFAULT '[[]]', `model` TEXT NOT NULL DEFAULT '[[]]', `admin` int(11) NOT NULL DEFAULT 0, `health` int(11) NOT NULL DEFAULT 100, `armor` int(11) NOT NULL DEFAULT 0, `thirst` int(11) NOT NULL DEFAULT 100, `stamina` int(11) NOT NULL DEFAULT 100, `hunger` int(11) NOT NULL DEFAULT 100, `inventory` TEXT NOT NULL DEFAULT '[[]]', `weapons` TEXT NOT NULL DEFAULT '[[]]', PRIMARY KEY (`id`)) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4_general_ci;"

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

        local query = mariadb_prepare(SQLConnection, "SHOW TABLES LIKE '?';", "players")
        mariadb_query(SQLConnection, query, CheckPlayerTable) -- Check if players table exists
    end
end
AddEvent("OnPackageStart", connect_db)

function CheckPlayerTable()
    if mariadb_get_row_count() ~= 0 then return end
    
    mariadb_query(SQLConnection, createTable)
    print("[RealisticBase] 'Players' database table initialized !")
end

-- Stop when stoping package
local function disconnect_db()
    if not SQLConnection then return end
    mariadb_close(SQLConnection)
end
AddEvent("OnPackageStop", disconnect_db)