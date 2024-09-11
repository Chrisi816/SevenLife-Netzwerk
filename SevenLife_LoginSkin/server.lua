ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
RegisterServerEvent("SevenLife:Login:CheckIfPlayerHaceAccount")
AddEventHandler(
    "SevenLife:Login:CheckIfPlayerHaceAccount",
    function(benutzer, passwort)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM login_accounts WHERE identifer = @identifier ",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] == nil then
                    MySQL.Async.execute(
                        "INSERT INTO login_accounts (identifer, benutzername, passwort) VALUES (@identifier, @username, @password)",
                        {
                            ["@identifier"] = identifiers,
                            ["@username"] = benutzer,
                            ["@password"] = passwort
                        },
                        function(result)
                            TriggerClientEvent("sevenlife:Login:NextStep", _source)
                        end
                    )
                else
                    TriggerEvent("SevenLife:Login:KickOfAccount", _source)
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Login:KickOfAccount")
AddEventHandler(
    "SevenLife:Login:KickOfAccount",
    function(source)
        local message =
            "Du hast bereits ein Account, falls du dein Passwort oder Benutzername vergessen hast, melde dich bei der Projektleitung (Chrisi)"
        local _source = source
        TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Login", message, 3000)
    end
)
RegisterServerEvent("SevenLife:UpdateData")
AddEventHandler(
    "SevenLife:UpdateData",
    function(vorname, nachname, birth)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.execute(
            "UPDATE users SET name = @name , firstname = @firstname , lastname = @lastname, dateofbirth = @birth WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifiers,
                ["@name"] = vorname .. " " .. nachname,
                ["@firstname"] = vorname,
                ["@lastname"] = nachname,
                ["@birth"] = birth
            },
            function(result)
            end
        )
    end
)
RegisterServerEvent("Sevenlife:login:laststep")
AddEventHandler(
    "Sevenlife:login:laststep",
    function(fertig, illegal)
        local date = os.date("%Y/%m/%d %X")
        local _source = source
        local identifiers = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.execute(
            "UPDATE login_accounts SET fertiggestellt = @fertig , illigalorlegal = @illegalorlegal WHERE identifer = @identifier ",
            {
                ["@identifier"] = identifiers,
                ["@fertig"] = fertig,
                ["@illegalorlegal"] = illegal
            },
            function(result)
            end
        )
        MySQL.Async.execute(
            "UPDATE users SET datumerstellen = @datumerstellen WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifiers,
                ["@datumerstellen"] = date
            },
            function(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:LoginSkin:Anmelde",
    function(source, cb, benutzer, pass)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local _source = source

        MySQL.Async.fetchAll(
            "SELECT identifer FROM login_accounts WHERE benutzername = @username AND BINARY passwort = @password",
            {
                ["@username"] = benutzer,
                ["@password"] = pass
            },
            function(result)
                if result[1] == nil then
                    TriggerEvent("sevenlife:kickit", _source)
                    cb(false)
                else
                    cb(true)
                end
            end
        )
    end
)

RegisterServerEvent("sevenlife:kickit")
AddEventHandler(
    "sevenlife:kickit",
    function(source)
        local message = "Dein Benutzername oder Passwort ist falsch"
        local _source = source
        TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Registrierung", message, 3000)
    end
)
RegisterServerEvent("sevenlife:login:spawnplayer")
AddEventHandler(
    "sevenlife:login:spawnplayer",
    function()
        local _source = source
        local player = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchScalar(
            "SELECT lastpos FROM users WHERE identifier = @identifier",
            {["@identifier"] = player},
            function(result)
                local SpawnPos = json.decode(result)
                TriggerClientEvent("sevenlife:login:spawnpos", _source, SpawnPos[1], SpawnPos[2], SpawnPos[3])
            end
        )
    end
)
