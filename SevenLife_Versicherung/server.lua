ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Versicherung:GetNotVersicherungen",
    function(source, cb)
        local ownedCars = {}

        ownedCars = {}
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `owner` = @owner and `versichert` = @versichert",
            {
                ["@owner"] = identifier,
                ["@versichert"] = "false"
            },
            function(vehicles)
                for _, v in pairs(vehicles) do
                    local vehicle = json.decode(v.vehicle)

                    table.insert(
                        ownedCars,
                        {
                            vehicle = vehicle,
                            stored = v.stored,
                            plate = v.plate,
                            versichert = v.versichert
                        }
                    )
                end
                cb(ownedCars)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Versicherung:CheckMoney",
    function(source, cb)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if (xPlayer.getMoney() < 15) then
            cb(false)
        else
            if (xPlayer.getMoney() >= 15) then
                xPlayer.removeAccountMoney("money", 15)
                cb(true)
            end
        end
    end
)
RegisterServerEvent("SevenLife:Versicherung:UpdateVersicherung")
AddEventHandler(
    "SevenLife:Versicherung:UpdateVersicherung",
    function(plate)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local identifier = xPlayer.identifier
        MySQL.Async.execute(
            "UPDATE owned_vehicles SET `versichert` = @versichert WHERE `plate` = @plate AND owner = @identifier",
            {
                ["@plate"] = plate,
                ["@identifier"] = identifier,
                ["@versichert"] = "true"
            },
            function()
            end
        )
    end
)
