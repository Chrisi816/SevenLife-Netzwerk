ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "sevenlife:getgaragecars",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier

        local result =
            MySQL.Sync.fetchAll(
            "SELECT * FROM owned_vehicles WHERE owner = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(result)
            end
        )
        local results =
            MySQL.Sync.fetchAll(
            "SELECT * FROM owned_vehicles WHERE keys = @keys",
            {
                ["@keys"] = identifier
            },
            function(results)
            end
        )

        result = result + results
        if result[1] ~= nil then
            if result[1].stored == "1" then
                cb(result)
            end
        end
    end
)
ESX.RegisterServerCallback(
    "sevenlife:checkifcarisowned",
    function(source, cb, plate, garage)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        local plate = string.gsub(plate, "%s+", "")
        if garage == "20" or garage == "27" or garage == "28" then
            local results =
                MySQL.Sync.fetchAll(
                "SELECT * FROM owned_vehicles WHERE plate = @plate AND owner = @owner",
                {
                    ["@plate"] = plate,
                    ["@owner"] = identifier
                },
                function(results)
                end
            )
            local results2 =
                MySQL.Sync.fetchAll(
                "SELECT * FROM owned_vehicles WHERE `keys` = @keys",
                {
                    ["@keys"] = identifier
                },
                function(results)
                end
            )
            if results ~= nil or results2 ~= nil then
                for k, v in pairs(results2) do
                    results[k] = v
                end
                for _, v in pairs(results) do
                    if v.type == "heli" then
                        cb(true)
                    else
                        cb(false)
                    end
                end
            else
                if results == nil then
                    cb(false)
                end
            end
        else
            if garage == "21" or garage == "29" then
                local results =
                    MySQL.Sync.fetchAll(
                    "SELECT vehicle, type FROM owned_vehicles WHERE plate = @plate AND owner = @owner",
                    {
                        ["@plate"] = plate,
                        ["@owner"] = identifier
                    },
                    function(results)
                    end
                )
                local results2 =
                    MySQL.Sync.fetchAll(
                    "SELECT * FROM owned_vehicles WHERE `keys` = @keys",
                    {
                        ["@keys"] = identifier
                    },
                    function(results)
                    end
                )
                if results ~= nil or results2 ~= nil then
                    for k, v in pairs(results2) do
                        results[k] = v
                    end
                    for _, v in pairs(results) do
                        if v.type == "boot" then
                            cb(true)
                        else
                            cb(false)
                        end
                    end
                else
                    if results == nil then
                        cb(false)
                    end
                end
            else
                local results2 =
                    MySQL.Sync.fetchAll(
                    "SELECT * FROM owned_vehicles WHERE `keys` = @keys",
                    {
                        ["@keys"] = identifier
                    },
                    function(results)
                    end
                )
                local results =
                    MySQL.Sync.fetchAll(
                    "SELECT vehicle, type FROM owned_vehicles WHERE plate = @plate AND owner = @owner",
                    {
                        ["@plate"] = plate,
                        ["@owner"] = identifier
                    },
                    function(results)
                    end
                )
                if results ~= nil or results2 ~= nil then
                    for k, v in pairs(results2) do
                        results[k] = v
                    end
                    for _, v in pairs(results) do
                        if v.type == "car" then
                            cb(true)
                        else
                            cb(false)
                        end
                    end
                else
                    if results == nil then
                        cb(false)
                    end
                end
            end
        end
    end
)
RegisterNetEvent("sevenlife:changemode")
AddEventHandler(
    "sevenlife:changemode",
    function(plate, state)
        local originalplate = string.gsub(plate, "%s+", "")
        MySQL.Sync.execute(
            "UPDATE owned_vehicles SET stored = @state WHERE plate = @plate",
            {["@plate"] = originalplate, ["@state"] = state}
        )
    end
)

RegisterNetEvent("sevenlife:savecartile")
AddEventHandler(
    "sevenlife:savecartile",
    function(plate, tile)
        local tiles = json.encode(tile)
        local plate = string.gsub(plate, "%s+", "")
        MySQL.Sync.execute(
            "UPDATE owned_vehicles SET `vehicle` = @props WHERE `plate` = @plate",
            {["@plate"] = plate, ["@props"] = tiles}
        )
    end
)

ESX.RegisterServerCallback(
    "sevenlife:loadvehicle",
    function(source, cb, garage)
        local ownedCars = {}
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        local vehicles =
            MySQL.Sync.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `owner` = @owner AND `stored` = 1",
            {["@owner"] = identifier},
            function(vehicles)
            end
        )
        local result2 =
            MySQL.Sync.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `keys` = @keys",
            {
                ["@keys"] = identifier
            },
            function(results)
            end
        )
        for k, v in pairs(result2) do
            vehicles[k] = v
        end
        for _, v in pairs(vehicles) do
            if v.type == "car" then
                if tonumber(v.garage) == tonumber(garage) then
                    local vehicle = json.decode(v.vehicle)
                    table.insert(
                        ownedCars,
                        {vehicle = vehicle, stored = v.stored, plate = v.plate, fuel = v.fuel, nickname = v.nickname}
                    )
                end
            end
        end
        cb(ownedCars)
    end
)
ESX.RegisterServerCallback(
    "sevenlife:loadplanes",
    function(source, cb, garage)
        local ownedCars = {}
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        local vehicles =
            MySQL.Sync.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `owner` = @owner AND `stored` = 1",
            {["@owner"] = identifier},
            function(vehicles)
            end
        )
        local result2 =
            MySQL.Sync.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `keys` = @keys",
            {
                ["@keys"] = identifier
            },
            function(results)
            end
        )
        for k, v in pairs(result2) do
            vehicles[k] = v
        end

        for _, v in pairs(vehicles) do
            if v.type == "heli" then
                local vehicle = json.decode(v.vehicle)
                table.insert(
                    ownedCars,
                    {vehicle = vehicle, stored = v.stored, plate = v.plate, fuel = v.fuel, nickname = v.nickname}
                )
            end
        end
        cb(ownedCars)
    end
)
ESX.RegisterServerCallback(
    "sevenlife:loadboots",
    function(source, cb, garage)
        local ownedCars = {}
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        local vehicles =
            MySQL.Sync.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `owner` = @owner AND `stored` = 1",
            {["@owner"] = identifier},
            function(vehicles)
            end
        )
        local result2 =
            MySQL.Sync.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `keys` = @keys",
            {
                ["@keys"] = identifier
            },
            function(results)
            end
        )
        for k, v in pairs(result2) do
            vehicles[k] = v
        end
        for _, v in pairs(vehicles) do
            if v.type == "boot" then
                local vehicle = json.decode(v.vehicle)
                table.insert(
                    ownedCars,
                    {vehicle = vehicle, stored = v.stored, plate = v.plate, fuel = v.fuel, nickname = v.nickname}
                )
            end
        end
        cb(ownedCars)
    end
)
ESX.RegisterServerCallback(
    "sevenlife:spawnvehicle",
    function(source, cb, plate)
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `plate` = @plate",
            {["@plate"] = plate},
            function(vehicle)
                cb(vehicle)
            end
        )
    end
)
RegisterServerEvent("SevenLife:SafeFuelGarage")
AddEventHandler(
    "SevenLife:SafeFuelGarage",
    function(plate, fuel)
        MySQL.Sync.execute(
            "UPDATE owned_vehicles SET `fuel` = @fuel WHERE `plate` = @plate",
            {
                ["@plate"] = plate,
                ["@fuel"] = fuel
            },
            function()
            end
        )
    end
)

RegisterServerEvent("SevenLife:Garage:InsertGarage")
AddEventHandler(
    "SevenLife:Garage:InsertGarage",
    function(plate, garage)
        local garage = tonumber(garage)
        MySQL.Sync.execute(
            "UPDATE owned_vehicles SET garage = @garage WHERE plate = @plate",
            {
                ["@plate"] = plate,
                ["@garage"] = garage
            },
            function()
            end
        )
    end
)
RegisterServerEvent("SevenLife:Garagen:ChangeName")
AddEventHandler(
    "SevenLife:Garagen:ChangeName",
    function(name, plate)
        local _source = source

        MySQL.Sync.execute(
            "UPDATE owned_vehicles SET nickname = @nickname WHERE plate = @plate",
            {
                ["@plate"] = plate,
                ["@nickname"] = name
            },
            function()
            end
        )

        TriggerClientEvent("SevenLife:Garagen:Update", _source)
    end
)
