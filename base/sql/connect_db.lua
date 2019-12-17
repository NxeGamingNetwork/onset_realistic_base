-- Don't touch
SQLConnexion = false
local try = 1
local createTable = "CREATE TABLE IF NOT EXISTS `players` (`id` int(11) NOT NULL AUTO_INCREMENT, `steamid` varchar(255) NOT NULL, `name` text NOT NULL DEFAULT '""', `money` int(11) DEFAULT 0, `bank_money` int(11) NOT NULL DEFAULT 1000, `position` text NOT NULL DEFAULT '""', `model` text NOT NULL DEFAULT '""', `admin` int(11) NOT NULL DEFAULT 0, `health` int(11) NOT NULL DEFAULT 100, `armor` int(11) NOT NULL DEFAULT 0, `thirst` int(11) NOT NULL DEFAULT 100, `stamina` int(11) NOT NULL DEFAULT 100, `hunger` int(11) NOT NULL DEFAULT 100, `inventory` text NOT NULL DEFAULT '""', `weapons` text NOT NULL DEFAULT '""', PRIMARY KEY (`id`), UNIQUE KEY `steamidindex` (`steamid`)) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;"

-- Connect to database when the package is starting
local function connect_db()
    SQLConnexion = mariadb_connect(RealisticBase.Host..":"..RealisticBase.Port, RealisticBase.User, RealisticBase.Pass, RealisticBase.Name)
    if not SQLConnexion then 
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

        -- Create tables if not exists
        mariadb_query(SQLConnexion, createTable)
    end
end
AddEvent("OnPackageStart", connect_db)

-- Stop when stoping package
local function disconnect_db()
    if not SQLConnexion then return end
    mariadb_close(SQLConnexion)
end
AddEvent("OnPackageStop", disconnect_db)