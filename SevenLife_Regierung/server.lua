ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
RegisterServerEvent("sevenlife:checkcashings")
AddEventHandler(
    "sevenlife:checkcashings",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local bankcash = xPlayer.getAccount("bank").money
        local money = xPlayer.getAccount("money").money
        local _source = source
        if bankcash < 30000 and money < 30000 then
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                _source,
                "Regierung",
                "Du hast nicht genug Geld dabei",
                2000
            )
            TriggerClientEvent("SevenLife:Regierung:Close", _source)
        end
    end
)
RegisterServerEvent("sevenlife:haveplayeracompeny")
AddEventHandler(
    "sevenlife:haveplayeracompeny",
    function()
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM unternehmen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] ~= nil then
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Regierung",
                        "Du hast bereits ein Unternehmen",
                        2000
                    )
                    TriggerClientEvent("SevenLife:Regierung:Close", _source)
                end
            end
        )
    end
)

RegisterServerEvent("sevenlife:neuesunternehmen")
AddEventHandler(
    "sevenlife:neuesunternehmen",
    function(unternehmensname)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local firmageld = 0
        local geld = 10
        MySQL.Async.fetchAll(
            "SELECT * FROM unternehmen WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                MySQL.Async.fetchAll(
                    "INSERT INTO unternehmen (identifier, firmenname, firmenvalue, cash) VALUES (@identifier, @firmenname, @firmenvalue, @cash)",
                    {
                        ["@identifier"] = identifiers,
                        ["@firmenname"] = unternehmensname,
                        ["@firmenvalue"] = firmageld,
                        ["@cash"] = geld
                    },
                    function(result)
                    end
                )
            end
        )
    end
)

RegisterServerEvent("sevenlife:selctbuere")
AddEventHandler(
    "sevenlife:selctbuere",
    function(whichbuero)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local whichbuero = tonumber(whichbuero)
        MySQL.Async.execute(
            "UPDATE unternehmen SET bueronummer = @bueronummer WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers,
                ["@bueronummer"] = whichbuero
            }
        )
    end
)

RegisterServerEvent("sevenlife:checkout")
AddEventHandler(
    "sevenlife:checkout",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local bankcash = xPlayer.getAccount("bank").money
        local money = xPlayer.getAccount("money").money
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local isready
        local ready = 1
        if bankcash >= 30000 then
            xPlayer.removeAccountMoney("bank", 30000)
        else
            if money >= 30000 then
                xPlayer.removeAccountMoney("money", 30000)
            end
        end
        MySQL.Async.fetchAll(
            "SELECT completet FROM unternehmen WHERE completet = @completet",
            {
                ["@completet"] = isready
            },
            function(result)
                if isready == nil then
                    MySQL.Async.execute(
                        "UPDATE unternehmen SET completet = @completet WHERE identifier = @identifier",
                        {
                            ["@completet"] = ready,
                            ["@identifier"] = identifiers
                        },
                        function(result)
                        end
                    )
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:loadimpoundedvehicles",
    function(source, cb)
        local ownedCars = {}
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        local results =
            MySQL.Sync.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `keys` = @keys AND `stored` = @stored",
            {
                ["@keys"] = identifier,
                ["@stored"] = "0"
            },
            function(results)
            end
        )

        local vehicles =
            MySQL.Sync.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `owner` = @identifier AND `stored` = @stored",
            {
                ["@identifier"] = identifier,
                ["@stored"] = "0"
            },
            function(result)
            end
        )
        for k, v in pairs(results) do
            vehicles[k] = v
        end

        for _, v in pairs(vehicles) do
            if v.type == "car" then
                local vehicle = json.decode(v.vehicle)
                table.insert(
                    ownedCars,
                    {vehicle = vehicle, stored = v.stored, plate = v.plate, fuel = v.fuel, versichert = v.versichert}
                )
            end
        end

        cb(ownedCars)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Impounder:GetFlugzeuge",
    function(source, cb)
        local ownedCars = {}
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `owner` = @owner AND `stored` = @stored",
            {["@owner"] = identifier, ["@stored"] = "0"},
            function(vehicles)
                for _, v in pairs(vehicles) do
                    if v.type == "heli" then
                        local vehicle = json.decode(v.vehicle)
                        table.insert(
                            ownedCars,
                            {
                                vehicle = vehicle,
                                stored = v.stored,
                                plate = v.plate,
                                fuel = v.fuel,
                                versichert = v.versichert
                            }
                        )
                    end
                end
                cb(ownedCars)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Impounder:GetBoote",
    function(source, cb)
        local ownedCars = {}
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE `owner` = @owner AND `stored` = @stored",
            {["@owner"] = identifier, ["@stored"] = "0"},
            function(vehicles)
                for _, v in pairs(vehicles) do
                    if v.type == "boot" then
                        local vehicle = json.decode(v.vehicle)
                        table.insert(
                            ownedCars,
                            {
                                vehicle = vehicle,
                                stored = v.stored,
                                plate = v.plate,
                                fuel = v.fuel,
                                versichert = v.versichert
                            }
                        )
                    end
                end
                cb(ownedCars)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "sevenlife:spawnvehiclese",
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
RegisterServerEvent("sevenlife:renamecar")
AddEventHandler(
    "sevenlife:renamecar",
    function(old, new, vehicleid)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        local identifier = ESX.GetPlayerFromId(source).identifier
        local news = string.upper(new)
        if money >= 100 then
            xPlayer.removeAccountMoney("money", 100)
            MySQL.Async.execute(
                "UPDATE owned_vehicles SET plate = @plate WHERE vehicleid = @vehicleid",
                {
                    ["@vehicleid"] = vehicleid,
                    ["@plate"] = new
                },
                function(result)
                    TriggerClientEvent("sevenlife:timednotifycar", _source, "Erfolgreich Kennzeichen geändert")
                    TriggerClientEvent("SevenLife:Regierung:RenameCar", _source, new)
                end
            )
        else
            TriggerClientEvent("sevenlife:timednotifycar", _source, "Du hast zu wenig Geld um das Auto Anzumelden")
        end
    end
)
ESX.RegisterServerCallback(
    "sevenlife:checkifplayerhavelicense",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM seven_licenses WHERE `identifier` = @identifier",
            {["@identifier"] = identifier},
            function(result)
                if result[1] ~= nil then
                    if result[1].driverlicense ~= nil then
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            end
        )
    end
)
--------------------------------------------------------------------------------------------------------------
---------------------------------------------Plate Taken------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
ESX.RegisterServerCallback(
    "sevenlife:platetakens",
    function(source, cb, plate, vehicleid)
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
------------------------------------------------Car ID--------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
ESX.RegisterServerCallback(
    "sevenlife:vehicleid",
    function(source, cb, plate)
        local originalplate = string.sub(plate, "2")
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE plate = @plate",
            {
                ["@plate"] = originalplate
            },
            function(result)
                if result ~= nil then
                    local id = result[1].vehicleid
                    cb(id)
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Regierung:Perso:CheckIfPlayerhaveenoughmoney",
    function(source, cb, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        if money >= amount then
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:Regierung:Perso:Payforit")
AddEventHandler(
    "SevenLife:Regierung:Perso:Payforit",
    function(amount, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local amount = tonumber(amount)
        xPlayer.removeMoney(amount)
        TriggerClientEvent("SevenLife:Quest:UpdateIfPossible", source, 5)
        TriggerClientEvent("SevenLife:Postal:AddPost", source, "Regierung", item, 1)
    end
)

ESX.RegisterServerCallback(
    "sevenlife:checkifcarisownedanmelde",
    function(source, cb, plate)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        if plate ~= nil then
            local plate = string.gsub(plate, "%s+", "")

            MySQL.Async.fetchAll(
                "SELECT vehicle, type FROM owned_vehicles WHERE plate = @plate AND owner = @owner",
                {
                    ["@plate"] = plate,
                    ["@owner"] = identifier
                },
                function(results)
                    if results[1] ~= nil then
                        for _, v in pairs(results) do
                            if v.type == "car" then
                                cb(true)
                            else
                                cb(false)
                            end
                        end
                    else
                        cb(false)
                    end
                end
            )
        else
            cb(false)
        end
    end
)
function extend(t1, t2)
    return table.move(t2, 1, #t2, #t1 + 1, t1)
end
RegisterServerEvent("sevenlife:ziehegeldimpounderab")
AddEventHandler(
    "sevenlife:ziehegeldimpounderab",
    function(price)
        local price = tonumber(price)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeAccountMoney("money", price)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Impounder:GetEnoughMoney",
    function(source, cb, price)
        local price = tonumber(price)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local money = xPlayer.getMoney()
        if money >= price then
            cb(true)
        else
            cb(false)
        end
    end
)
