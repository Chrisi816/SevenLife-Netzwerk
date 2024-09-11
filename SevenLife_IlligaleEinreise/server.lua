ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:CheckIFPlayerIsIllegal",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT illigalorlegal FROM login_accounts WHERE identifer = @identifer",
            {
                ["@identifer"] = identifiers
            },
            function(result)
                if result[1].illigalorlegal == 2 then
                    cb(true)
                else
                    cb(false)
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Illegal:GiveCard")
AddEventHandler(
    "SevenLife:Illegal:GiveCard",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.addInventoryItem("bread", 20)
        xPlayer.addInventoryItem("water", 20)
        xPlayer.addAccountMoney("money", 100)
        xPlayer.addInventoryItem("phone", 1)
        TriggerClientEvent("SevenLife:DivingSuit:Make", source)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:IllegaleEinreise:FirstTime",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT illigalorlegal FROM login_accounts WHERE identifer= @identifer ",
            {
                ["@identifer"] = identifier
            },
            function(results)
                if results[1] ~= nil then
                    if results[1].illigalorlegal == 2 then
                        MySQL.Async.fetchAll(
                            "SELECT firsttime FROM users WHERE identifier= @identifier ",
                            {
                                ["@identifier"] = identifier
                            },
                            function(results)
                                if results[1].firsttime == "true" then
                                    cb(true)
                                else
                                    cb(false)
                                end
                            end
                        )
                    end
                else
                    cb(false)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Questing:CheckIfPlayerHaveAccount",
    function(source, cb)
        local source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT missionid FROM anfangsmissionen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] ~= nil then
                    cb(true)
                else
                    MySQL.Async.execute(
                        "INSERT INTO anfangsmissionen (`identifier`, `missionid`) VALUES (@identifier, @missionid)",
                        {
                            ["@identifier"] = identifiers,
                            ["@missionid"] = 100
                        },
                        function()
                            cb(false)
                        end
                    )
                end
            end
        )
    end
)
