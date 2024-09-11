local Bucket = 0

ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Cars:GetCarsForValue",
    function(source, cb, shopcategory)
        local _source = source
        Bucket = Bucket + 1
        SetPlayerRoutingBucket(_source, Bucket)
        SetRoutingBucketPopulationEnabled(Bucket, false)
        MySQL.Async.fetchAll(
            "SELECT * FROM vehiclesshop WHERE category = @shopcategory",
            {
                ["@shopcategory"] = shopcategory
            },
            function(results)
                if results[1] ~= nil then
                    cb(results)
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:AutoHeandler:NormalBucket")
AddEventHandler(
    "SevenLife:AutoHeandler:NormalBucket",
    function()
        local _source = source
        SetPlayerRoutingBucket(_source, 0)
    end
)
RegisterServerEvent("SevenLife:AutoHeander:MakeAutoOwned")
AddEventHandler(
    "SevenLife:AutoHeander:MakeAutoOwned",
    function(vehicleProps, id, types)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        MySQL.Async.execute(
            "INSERT INTO owned_vehicles (owner, plate, vehicle, type, vehicleid) VALUES (@owner, @plate, @vehicle, @type, @vehicleid)",
            {
                ["@owner"] = xPlayer.identifier,
                ["@plate"] = vehicleProps.plate,
                ["@vehicle"] = json.encode(vehicleProps),
                ["@type"] = types,
                ["@vehicleid"] = id
            },
            function(rowsChanged)
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Auto Heandler",
                    "Auto Erfolgreich gekauft",
                    2000
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:isidTaken",
    function(source, cb, id)
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE vehicleid = @vehicleid",
            {
                ["@vehicleid"] = id
            },
            function(result)
                cb(result[1] ~= nil)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:platetaken",
    function(source, cb, plate)
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE plate = @plate",
            {
                ["@plate"] = plate
            },
            function(result)
                cb(result[1] ~= nil)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:AutoHeandler:CheckIfEnoughMoney",
    function(source, cb, money)
        local money = tonumber(money)
        print(money)
        local xPlayer = ESX.GetPlayerFromId(source)
        if money <= xPlayer.getMoney() then
            cb(true)
            xPlayer.removeAccountMoney("money", money)
        else
            cb(false)
        end
    end
)
