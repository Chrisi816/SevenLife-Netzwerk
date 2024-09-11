ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Schlosser:GetSchloss",
    function(source, cb)
        local ownedCars = {}
        ownedCars = {}
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `owner` = @owner ",
            {
                ["@owner"] = identifier
            },
            function(vehicles)
                for _, v in pairs(vehicles) do
                    if v.keys ~= nil then
                        local vehicle = json.decode(v.vehicle)

                        table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
                    end
                end
                cb(ownedCars)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Schlosser:CheckMoney",
    function(source, cb)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if (xPlayer.getMoney() < 100) then
            cb(false)
        else
            if (xPlayer.getMoney() >= 100) then
                xPlayer.removeAccountMoney("money", 100)
                cb(true)
            end
        end
    end
)
RegisterServerEvent("SevenLife:Schlosser:RemoveSchlüssel")
AddEventHandler(
    "SevenLife:Schlosser:RemoveSchlüssel",
    function(plate)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local identifier = xPlayer.identifier
        MySQL.Async.execute(
            "UPDATE owned_vehicles SET `keys` = @keys WHERE `plate` = @plate AND owner = @identifier",
            {
                ["@plate"] = plate,
                ["@identifier"] = identifier,
                ["@keys"] = nil
            },
            function()
            end
        )
    end
)
