ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:GetWerbungs",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM lifeinvader_werbungen",
            {},
            function(result)
                if result[1] ~= nil then
                    cb(result)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Lifeinvader:GetNameOfPersons",
    function(source, cb)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM lifeinvader_accounts WHERE identifier = @identifier",
            {["@identifier"] = player},
            function(result)
                if result[1] ~= nil then
                    cb(result[1].benutzername)
                else
                    cb("Anonym")
                end
            end
        )
    end
)
RegisterNetEvent("SevenLife:Lifeinvader:SendNachrichCheck")
AddEventHandler(
    "SevenLife:Lifeinvader:SendNachrichCheck",
    function(nachricht, titel, benutzer, status)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local preis
        if status == "1" then
            preis = 50
        else
            preis = 150
        end
        if xPlayer.getMoney() >= preis then
            xPlayer.removeMoney(preis)
            MySQL.Async.execute(
                "INSERT INTO lifeinvader_werbungen (benutzername, titel, nachricht, premiumornot) VALUES (@benutzername, @titel, @nachricht, @premiumornot)",
                {
                    ["@benutzername"] = benutzer,
                    ["@titel"] = titel,
                    ["@nachricht"] = nachricht,
                    ["@premiumornot"] = status
                },
                function(result)
                end
            )
            TriggerClientEvent("SevenLife:LifeInvader:Delete", _source)
        else
            TriggerClientEvent("SevenLife:LifeInvader:NotEnoughCash", _source)
        end
    end
)
