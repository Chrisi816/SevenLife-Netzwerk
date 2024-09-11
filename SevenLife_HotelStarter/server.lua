ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Hotel:GetIfPlayerHaveHotel",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT wohnort FROM users WHERE identifier= @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(results)
                if results[1].wohnort == "hotel" then
                    cb(true)
                else
                    cb(false)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Hotel:GetInfos",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT lastname FROM users WHERE identifier= @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(results)
                cb(results)
            end
        )
    end
)

Citizen.CreateThread(
    function()
        while true do
            for k, playerid in pairs(GetPlayers()) do
                local _source = playerid
                local xPlayer = ESX.GetPlayerFromId(playerid)
                local identifier = xPlayer.identifier
                if xPlayer ~= nil then
                    MySQL.Async.fetchAll(
                        "SELECT wohnort FROM users WHERE identifier= @identifier ",
                        {
                            ["@identifier"] = identifier
                        },
                        function(results)
                            if results[1].wohnort == "hotel" then
                                local money = xPlayer.getAccount("bank").money
                                if money >= 100 then
                                    xPlayer.removeAccountMoney("bank", 100)
                                    TriggerClientEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        _source,
                                        "Miete",
                                        "Du hast 100$ für die Miete bezahlt",
                                        2000
                                    )
                                else
                                    TriggerEvent("SevenLife:Hotel:MakeBill", _source, 100)
                                end
                            end
                        end
                    )
                end
            end
            Citizen.Wait(1500000)
        end
    end
)

RegisterServerEvent("SevenLife:Hotel:MakeBill")
AddEventHandler(
    "SevenLife:Hotel:MakeBill",
    function(source, fine)
        local xPlayer = ESX.GetPlayerFromId(source)
        local amount = tonumber(fine)

        if xPlayer ~= nil then
            MySQL.Async.execute(
                "INSERT INTO bill_options (identifier, title, reason, price, stand, firma) VALUES (@identifier, @title, @reason, @price, @stand, @firma)",
                {
                    ["@identifier"] = xPlayer.identifier,
                    ["@title"] = "Überschreitung",
                    ["@reason"] = "Miete nicht bezahlt",
                    ["@price"] = amount,
                    ["@stand"] = "notpaid",
                    ["@firma"] = "miete"
                },
                function()
                end
            )
        end
    end
)

RegisterServerEvent("SevenLife:Hotel:PlayerEnterdHouse")
AddEventHandler(
    "SevenLife:Hotel:PlayerEnterdHouse",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        local id = math.random(1, 20000)
        SetPlayerRoutingBucket(_source, id)
        SetRoutingBucketPopulationEnabled(id, false)
    end
)

RegisterServerEvent("SevenLife:Hotel:LeaveHouse")
AddEventHandler(
    "SevenLife:Hotel:LeaveHouse",
    function()
        local _source = source
        SetPlayerRoutingBucket(_source, 0)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:HotelStarter:HausFirstTime",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier

        MySQL.Async.fetchAll(
            "SELECT firsttime FROM users WHERE identifier= @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(results)
                print(results[1].firsttime)
                if results[1].firsttime == "true" then
                    cb(true)
                else
                    cb(false)
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:HotelStarter:MakeOkFirst")
AddEventHandler(
    "SevenLife:HotelStarter:MakeOkFirst",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        MySQL.Async.execute(
            "UPDATE users SET firsttime = @firsttime WHERE identifier = @identifer",
            {
                ["@identifer"] = identifier,
                ["@firsttime"] = "true"
            },
            function()
            end
        )
    end
)
