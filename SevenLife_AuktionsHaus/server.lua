ESX = nil
-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Auktion:GetActiveAuktionen",
    function(source, cb)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM auktionen ",
            {},
            function(result)
                cb(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:AuktionsHaus:GetCars",
    function(source, cb)
        local ownedCars = {}
        local _source = source
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE owner = @owner ",
            {
                ["@owner"] = identifier
            },
            function(result)
                for _, v in pairs(result) do
                    if v.type == "car" then
                        local vehicle = json.decode(v.vehicle)
                        table.insert(
                            ownedCars,
                            {
                                vehicle = vehicle,
                                stored = v.stored,
                                plate = v.plate,
                                fuel = v.fuel,
                                vehicleid = v.vehicleid
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
    "SevenLife:AuktionsHaus:GetBoote",
    function(source, cb)
        local ownedCars = {}
        local _source = source
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE owner = @owner ",
            {
                ["@owner"] = identifier
            },
            function(result)
                for _, v in pairs(result) do
                    if v.type == "boot" then
                        local vehicle = json.decode(v.vehicle)
                        table.insert(
                            ownedCars,
                            {
                                vehicle = vehicle,
                                stored = v.stored,
                                plate = v.plate,
                                fuel = v.fuel,
                                vehicleid = v.vehicleid
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
    "SevenLife:AuktionsHaus:GetFlugzeuge",
    function(source, cb)
        local ownedCars = {}
        local _source = source
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE owner = @owner ",
            {
                ["@owner"] = identifier
            },
            function(result)
                for _, v in pairs(result) do
                    if v.type == "heli" then
                        local vehicle = json.decode(v.vehicle)
                        table.insert(
                            ownedCars,
                            {
                                vehicle = vehicle,
                                stored = v.stored,
                                plate = v.plate,
                                fuel = v.fuel,
                                vehicleid = v.vehicleid
                            }
                        )
                    end
                end
                cb(ownedCars)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Auktion:MakeAuktion")
AddEventHandler(
    "SevenLife:Auktion:MakeAuktion",
    function(choice, zeit, preis, type, label, count, labelcar, vehicleid, labelse)
        local _source = source
        local ownedCars = {}
        local vehicleids, formerowner = nil, nil
        local xPlayer = ESX.GetPlayerFromId(source)
        local hour, labelname
        local identifier = ESX.GetPlayerFromId(source).identifier
        local currenttime = os.date("*t", os.time())
        local formatedtime = {currenttime["hour"] .. ":" .. currenttime["min"] .. ":" .. currenttime["sec"]}

        local addedtime = currenttime["hour"] + tonumber(zeit)

        if addedtime >= 24 then
            local endtime = addedtime - 24
            hour = endtime
        else
            hour = addedtime
        end
        local labels

        if labelse ~= nil then
            labels = labelse
        else
            labels = label
        end

        if type == "cars" then
            vehicleids = vehicleid
            formerowner = identifier
            labels = labelcar
            MySQL.Async.fetchAll(
                "SELECT * FROM owned_vehicles WHERE owner = @identifier ",
                {
                    ["@identifier"] = identifier
                },
                function(result)
                    if result[1] ~= nil then
                        MySQL.Async.execute(
                            "UPDATE owned_vehicles SET owner = @owner WHERE vehicleid = @vehicleid ",
                            {
                                ["@vehicleid"] = vehicleid,
                                ["@owner"] = "auktion"
                            }
                        )
                    end
                end
            )
        end
        if type == "items" then
            xPlayer.removeInventoryItem(label, count)
        end
        if type == "shops" then
            labels = "Shop #" .. labels
        end
        local EndTime = {hour .. ":" .. currenttime["min"] .. ":" .. currenttime["sec"]}

        MySQL.Async.execute(
            "INSERT INTO auktionen (identifier, inhalt,label,count,startpreis,endpreis,startzeit, endezeit, kategorie, bieter, sofort,vehicleid,formerowner ) VALUES (@identifier, @inhalt,@label,@count,@startpreis,@endpreis,@startzeit, @endezeit, @kategorie, @bieter, @sofort , @vehicleid,@formerowner)",
            {
                ["@identifier"] = identifier,
                ["@inhalt"] = labels,
                ["@label"] = label,
                ["@count"] = count,
                ["@startpreis"] = preis,
                ["@endpreis"] = preis,
                ["@startzeit"] = formatedtime,
                ["@endezeit"] = EndTime,
                ["@kategorie"] = type,
                ["@bieter"] = 0,
                ["@sofort"] = choice,
                ["@vehicleid"] = vehicleids,
                ["@formerowner"] = formerowner
            },
            function()
            end
        )
        Citizen.Wait(1000)
        TriggerClientEvent("SevenLife:Auktion:Update", _source)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Auktion:GetInventory",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local inv = xPlayer.inventory
        cb(inv)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Auktion:GetShops",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_shops WHERE identifier = @owner ",
            {
                ["@owner"] = identifier
            },
            function(result)
                cb(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Auktion:GetTanke",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM tankstellen WHERE identifer = @owner ",
            {
                ["@owner"] = identifier
            },
            function(result)
                cb(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Auktion:GetPlateVeh",
    function(source, cb, label)
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE plate = @label ",
            {
                ["@label"] = label
            },
            function(result)
                local vehicle = json.decode(result[1].vehicle)

                cb(vehicle)
            end
        )
    end
)

Citizen.CreateThread(
    function()
        while true do
            local currenttime = os.date("*t", os.time())

            MySQL.Async.fetchAll(
                "SELECT * FROM auktionen",
                {},
                function(result)
                    for k, v in pairs(result) do
                        local overall = v.endezeit:match("([^,]+):")
                        if overall ~= nil then
                            local minute = overall:match(":([^,]+)")
                            local hour = overall:match("([^,]+):")

                            if
                                tonumber(currenttime["hour"]) == tonumber(hour) and
                                    tonumber(currenttime["min"]) == tonumber(minute)
                             then
                                if v.hoesterbieter ~= nil then
                                    MySQL.Async.execute(
                                        "UPDATE auktionen SET endezeit = @endezeit WHERE id = @id",
                                        {
                                            ["@id"] = v.id,
                                            ["@endezeit"] = "abgeschlossen"
                                        },
                                        function(result)
                                        end
                                    )
                                else
                                    if v.type == "cars" then
                                        MySQL.Async.execute(
                                            "UPDATE owned_vehicles SET owner = @owner WHERE vehicleid = @vehicleid ",
                                            {
                                                ["@vehicleid"] = v.vehicleid,
                                                ["@owner"] = v.formerowner
                                            }
                                        )
                                    else
                                        MySQL.Async.execute(
                                            "UPDATE auktionen SET endezeit = @endezeit WHERE id = @id",
                                            {
                                                ["@id"] = v.id,
                                                ["@endezeit"] = "abgeschlossen"
                                            },
                                            function(result)
                                            end
                                        )
                                        MySQL.Async.execute(
                                            "UPDATE auktionen SET hoesterbieter = @hoesterbieter WHERE id = @id",
                                            {
                                                ["@id"] = v.id,
                                                ["@endezeit"] = v.formerowner
                                            },
                                            function(result)
                                            end
                                        )
                                    end
                                end
                            end
                        end
                    end
                end
            )
            Citizen.Wait(60000)
        end
    end
)

-- Give Functions
function MakeCars(idbieter, plate, identifier)
    MySQL.Async.fetchAll(
        "SELECT * FROM owned_vehicles WHERE owner = @identifier ",
        {
            ["@identifier"] = identifier
        },
        function(result)
            if result[1] ~= nil then
                MySQL.Async.execute(
                    "UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate",
                    {
                        ["@owner"] = idbieter,
                        ["@plate"] = plate
                    }
                )
            end
        end
    )
end

function MakeItem(label, count, identifier)
    MySQL.Async.fetchAll(
        "SELECT inventory FROM users WHERE identifier = @identifier ",
        {
            ["@identifier"] = identifier
        },
        function(result)
        end
    )
end

RegisterServerEvent("SevenLife:Auktion:MakeBuyingValide")
AddEventHandler(
    "SevenLife:Auktion:MakeBuyingValide",
    function(id, count, label, preis)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifer
        local money = tonumber(xPlayer.getMoney())
        if money >= tonumber(preis) then
            MySQL.Async.fetchAll(
                "SELECT kategorie, identifier FROM auktionen WHERE id = @id ",
                {
                    ["@id"] = id
                },
                function(result)
                    if result[1].kategorie == "cars" or result[1].kategorie == "boats" or result[1].kategorie == "fly" then
                        MakeCars(identifier, label, result[1].identifer)
                    elseif result[1].kategorie == "items" then
                        xPlayer.addInventoryItem(label, count)
                    elseif result[1].kategorie == "shops" then
                        MakeShopsTransfer(label, identifier)
                    elseif result[1].kategorie == "fuel" then
                        MakeFuelTransfer()
                    elseif result[1].kategorie == "hauses" then
                        MakeHausTransfer()
                    end

                    MySQL.Async.execute(
                        "DELETE FROM auktionen WHERE id = @id ",
                        {
                            ["@id"] = id
                        },
                        function()
                            TriggerClientEvent("SevenLife:Auktion:Update", _source)
                        end
                    )
                end
            )
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                _source,
                "AuktionsHaus",
                "Du hast gerade zu wenig Geld mit dabei um bei dieser Auktion teil zu nehmen",
                2000
            )
        end
    end
)
function MakeShopsTransfer(id, identifier)
    MySQL.Async.fetchAll(
        "SELECT * FROM owned_shops WHERE ShopNumber = @ShopNumber ",
        {
            ["@ShopNumber"] = id
        },
        function(result)
            if result[1] ~= nil then
                MySQL.Async.execute(
                    "UPDATE owned_shops SET identifier = @identifier WHERE ShopNumber = @ShopNumber",
                    {
                        ["@identifier"] = identifier,
                        ["@ShopNumber"] = id
                    }
                )
            end
        end
    )
end
function MakeFuelTransfer(id, identifier)
    MySQL.Async.fetchAll(
        "SELECT * FROM tankstellen WHERE tankstellennummer = @tankstellennummer ",
        {
            ["@tankstellennummer"] = id
        },
        function(result)
            if result[1] ~= nil then
                MySQL.Async.execute(
                    "UPDATE tankstellen SET identifier = @identifier WHERE tankstellennummer = @tankstellennummer",
                    {
                        ["@identifier"] = identifier,
                        ["@tankstellennummer"] = id
                    }
                )
            end
        end
    )
end
RegisterServerEvent("SevenLife:Auktion:MitBieten")
AddEventHandler(
    "SevenLife:Auktion:MitBieten",
    function(id, count, label, preis)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        local money = tonumber(xPlayer.getMoney())
        local preising = preis / 10

        local preisend = round(preising + preis, 1)

        if money >= tonumber(preis) then
            MySQL.Async.fetchAll(
                "SELECT bieter FROM auktionen WHERE id = @id ",
                {
                    ["@id"] = id
                },
                function(result)
                    if result[1] ~= nil then
                        MySQL.Async.execute(
                            "UPDATE auktionen SET endpreis = @endpreis, hoesterbieter = @hoesterbieter, bieter = @bieter WHERE id = @id",
                            {
                                ["@id"] = id,
                                ["@endpreis"] = preisend,
                                ["@hoesterbieter"] = identifier,
                                ["@bieter"] = tonumber(result[1].bieter) + 1
                            }
                        )
                        Citizen.Wait(1000)
                        -- Update
                        TriggerClientEvent("SevenLife:Auktion:Update", _source)
                    end
                end
            )
        end
    end
)
function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
ESX.RegisterServerCallback(
    "SevenLife:Auktionen:GetAngebote",
    function(source, cb)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        local deineangebote =
            MySQL.Sync.fetchAll(
            "SELECT * FROM auktionen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(result)
            end
        )
        local deinegebote =
            MySQL.Sync.fetchAll(
            "SELECT * FROM auktionen WHERE hoesterbieter = @hoesterbieter ",
            {
                ["@hoesterbieter"] = identifier
            },
            function(result)
            end
        )
        cb(deineangebote, deinegebote)
    end
)
RegisterServerEvent("SevenLife:Auktion:MakeBuyingValide2")
AddEventHandler(
    "SevenLife:Auktion:MakeBuyingValide2",
    function(id, count, label, preis)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifer
        local money = tonumber(xPlayer.getMoney())
        if money >= tonumber(preis) then
            MySQL.Async.fetchAll(
                "SELECT kategorie, identifier FROM auktionen WHERE id = @id ",
                {
                    ["@id"] = id
                },
                function(result)
                    if result[1].kategorie == "cars" or result[1].kategorie == "boats" or result[1].kategorie == "fly" then
                        MakeCars(identifier, label, result[1].identifer)
                    elseif result[1].kategorie == "items" then
                        xPlayer.addInventoryItem(label, count)
                    elseif result[1].kategorie == "shops" then
                        MakeShopsTransfer(label, identifier)
                    elseif result[1].kategorie == "fuel" then
                        MakeFuelTransfer()
                    elseif result[1].kategorie == "hauses" then
                        MakeHausTransfer()
                    end

                    MySQL.Async.execute(
                        "DELETE FROM auktionen WHERE id = @id ",
                        {
                            ["@id"] = id
                        },
                        function()
                            TriggerClientEvent("SevenLife:Auktion:UpdateSeeAll", _source)
                        end
                    )
                end
            )
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                _source,
                "AuktionsHaus",
                "Du hast gerade zu wenig Geld mit dabei um bei dieser Auktion teil zu nehmen",
                2000
            )
        end
    end
)
