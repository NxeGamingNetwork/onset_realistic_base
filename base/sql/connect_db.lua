SQLConnexion = false

-- Connect to database when the package is starting
local function connect_db()
    SQLConnexion = mariadb_connect(RealisticBase.Host..":"..RealisticBase.Port, RealisticBase.User, RealisticBase.Pass, RealisticBase.Name)
    if not SQLConnexion then 
        print("[ERROR | RealisticBase] Can't connect to "..RealisticBase.Host.." !")
        Delay(2000, function()
            ServerExit() -- Close server
        end)
    else
        print("[RealisticBase] Database "..RealisticBase.Host.." successfully connected !")
    end
end
AddEvent("OnPackageStart", connect_db)

-- Stop when stoping package
local function disconnect_db()
    if not SQLConnexion then return end
    mariadb_close(SQLConnexion)
end
AddEvent("OnPackageStop", disconnect_db)