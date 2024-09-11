ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:CarLock:isVehicleOwner",
    function(source, cb, plate)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        local results =
            MySQL.Sync.fetchAll(
            "SELECT owner FROM owned_vehicles WHERE owner = @owner AND plate = @plate",
            {
                ["@owner"] = identifier,
                ["@plate"] = plate
            },
            function(result)
            end
        )

        local resultse =
            MySQL.Sync.fetchAll(
            "SELECT `keys` FROM owned_vehicles WHERE `keys` = @keys AND `plate` = @plate",
            {
                ["@keys"] = identifier,
                ["@plate"] = plate
            },
            function(results)
            end
        )

        if results[1] or resultse[1] then
            if results[1] ~= nil then
                cb(true)
            end
            if resultse[1] ~= nil then
                cb(true)
            end
        else
            cb(false)
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:RadialMenu:CheckIfPlayerHaveItem",
    function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)

        local items = xPlayer.getInventoryItem(item).count
        print(items)
        if items >= 1 then
            cb(true)
        else
            cb(false)
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:RadialMenu:GetPersoData",
    function(source, cb)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT name, lastname, dateofbirth, datumerstellen FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("SevenLife:RadialMenu:OpenPerso")
AddEventHandler(
    "SevenLife:RadialMenu:OpenPerso",
    function(data, id, tagetid)
        local identifier = ESX.GetPlayerFromId(id).identifier
        local _source = ESX.GetPlayerFromId(tagetid).source
        TriggerClientEvent("SevenLife:RadialMenu:OpenPersoTarget", _source, data)
    end
)

RegisterServerEvent("SevenLife:RadialMenu:ShowLizenz")
AddEventHandler(
    "SevenLife:RadialMenu:ShowLizenz",
    function(tagetid)
        local _source = ESX.GetPlayerFromId(tagetid).source
        TriggerClientEvent("SevenLife:RadialMenu:OpenOtherSide", _source)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:RadialMenu:GetPersoDataLizenzen",
    function(source, cb)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT driverlicense, bootlicense, lkwlicense, motorlicense, gunlicense FROM seven_licenses WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(result)
                cb(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:RadialMenu:GetPlayerPed",
    function(source, cb)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM pets WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(result)
                cb(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Auto:CheckIfPlayerHaveSeatItem",
    function(source, cb)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local item = xPlayer.getInventoryItem("keys").count
        if item >= 1 then
            cb(true)
        else
            cb(false)
        end
    end
)
RegisterServerEvent("SevenLife:Auto:AddSchlüssel")
AddEventHandler(
    "SevenLife:Auto:AddSchlüssel",
    function(id, plate)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        local targetId = ESX.GetPlayerFromId(id).identifier
        MySQL.Async.fetchAll(
            "SELECT keys FROM owned_vehicles WHERE keys = @keys AND plate = @plate",
            {
                ["@owner"] = identifier,
                ["@plate"] = plate
            },
            function(results)
                if results[1] ~= nil then
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source "Auto",
                        "Von diesem Auto hat jemand schon einen Schlüssel. Geh zum Schlösser und lasse das Schloss austauschen",
                        1500
                    )
                else
                    MySQL.Async.execute(
                        "INSERT INTO owned_vehicles (keys) VALUES (@keys)",
                        {
                            ["@owner"] = identifier,
                            ["@plate"] = plate,
                            ["@keys"] = targetId
                        },
                        function()
                            TriggerClientEvent(
                                "SevenLife:TimetCustom:Notify",
                                _source "Auto",
                                "Von diesem Auto hat jemand schon einen Schlüssel. Geh zum Schlösser und lasse das Schloss austauschen",
                                1500
                            )
                        end
                    )
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Anims:GetAnims",
    function(source, cb)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        MySQL.Async.fetchAll(
            "SELECT * FROM marked_emotes WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(results)
                cb(results)
            end
        )
    end
)
