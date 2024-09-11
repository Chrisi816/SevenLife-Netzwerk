--------------------------------------------------------------------------------------------------------------
------------------------------------------------Local ESX-----------------------------------------------------
--------------------------------------------------------------------------------------------------------------
ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

--------------------------------------------------------------------------------------------------------------
----------------------------------------------Get All Cars----------------------------------------------------
--------------------------------------------------------------------------------------------------------------

RegisterServerEvent("sevenlife:getcarshopdata")
AddEventHandler(
    "sevenlife:getcarshopdata",
    function(shopcategory)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM vehiclesshop WHERE category = @shopcategory",
            {
                ["@shopcategory"] = shopcategory
            },
            function(results)
                if results[1] ~= nil then
                    TriggerClientEvent("sevenlife:beforeopening", _source, results)
                end
            end
        )
    end
)
--------------------------------------------------------------------------------------------------------------
----------------------------------------------Buy Vehicle-----------------------------------------------------
--------------------------------------------------------------------------------------------------------------
ESX.RegisterServerCallback(
    "sevenlife:buyvehicle",
    function(source, cb, vehicleModel)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local vehicleData = nil
        local bankMoney = xPlayer.getAccount("bank").money

        MySQL.Async.fetchAll(
            "SELECT * FROM vehiclesshop WHERE label = @vehicleModel",
            {
                ["@vehicleModel"] = vehicleModel
            },
            function(results)
                if results[1].price ~= nil then
                    if xPlayer.getMoney() >= results[1].price then
                        xPlayer.removeMoney(results[1].price)
                        cb(true)
                    else
                        if bankMoney >= results[1].price then
                            xPlayer.setAccountMoney("bank", bankMoney - results[1].price)
                            cb(true)
                        else
                            cb(false)
                        end
                    end
                end
            end
        )
    end
)
--------------------------------------------------------------------------------------------------------------
---------------------------------------------Vehcile Owned----------------------------------------------------
--------------------------------------------------------------------------------------------------------------
RegisterServerEvent("sevenlife:makevehicleowned")
AddEventHandler(
    "sevenlife:makevehicleowned",
    function(vehicleProps, id, types)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        TriggerClientEvent("SevenLife:Quest:UpdateIfPossible", source, 4)
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
                TriggerClientEvent("sevenlife:displaynachrichtse", _source, "Du hast das Auto erfolgreich gekauft")
            end
        )
    end
)
--------------------------------------------------------------------------------------------------------------
---------------------------------------------Plate Taken----------------------------------------------------
--------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------
---------------------------------------------Plate Taken----------------------------------------------------
--------------------------------------------------------------------------------------------------------------
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
