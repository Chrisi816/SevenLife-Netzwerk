ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Medic:CheckIfEnoughMoney",
    function(source, cb, price)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        if money >= tonumber(price) then
            cb(true)
            xPlayer.removeAccountMoney("money", tonumber(price))
        else
            cb(false)
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Medic:Buyvehicle",
    function(source, cb, price)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local bankMoney = xPlayer.getAccount("bank").money
        local price = tonumber(price)

        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            cb(true)
        else
            if bankMoney >= price then
                xPlayer.setAccountMoney("bank", bankMoney - price)
                cb(true)
            else
                cb(false)
            end
        end
    end
)
RegisterServerEvent("SevenLife:Medic:AddCard")
AddEventHandler(
    "SevenLife:Medic:AddCard",
    function(frak, vehicleProps, id, types)
        local _source = source

        MySQL.Async.execute(
            "INSERT INTO owned_vehicles (owner, plate, vehicle, type, vehicleid) VALUES (@owner, @plate, @vehicle, @type, @vehicleid)",
            {
                ["@owner"] = frak,
                ["@plate"] = vehicleProps.plate,
                ["@vehicle"] = json.encode(vehicleProps),
                ["@type"] = types,
                ["@vehicleid"] = id
            },
            function()
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Information",
                    "Du hast das Auto erfolgreich gekauft"
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Medic:GetGarageCars",
    function(source, cb, frak)
        local ownedCars = {}

        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE owner = @owner AND `stored` = 1",
            {
                ["@owner"] = frak
            },
            function(results)
                if results[1] ~= nil then
                    for _, v in pairs(results) do
                        if v.type == "car" then
                            local vehicle = json.decode(v.vehicle)
                            table.insert(
                                ownedCars,
                                {vehicle = vehicle, stored = v.stored, plate = v.plate, fuel = v.fuel}
                            )
                        end
                    end
                    cb(ownedCars)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Medic:GetGarageFlugzeug",
    function(source, cb, frak)
        local ownedCars = {}

        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE owner = @owner AND `stored` = 1",
            {
                ["@owner"] = frak
            },
            function(results)
                if results[1] ~= nil then
                    for _, v in pairs(results) do
                        if v.type == "heli" then
                            local vehicle = json.decode(v.vehicle)
                            table.insert(
                                ownedCars,
                                {vehicle = vehicle, stored = v.stored, plate = v.plate, fuel = v.fuel}
                            )
                        end
                    end
                    cb(ownedCars)
                end
            end
        )
    end
)
RegisterServerEvent("SevenLife:Medic:RemoveItem")
AddEventHandler(
    "SevenLife:Medic:RemoveItem",
    function(item)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(item, 1)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Medic:GetItem",
    function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local itemcount = xPlayer.getInventoryItem(item).count

        cb(itemcount)
    end
)
RegisterServerEvent("SevenLife:Medic:PutIntoVehicle")
AddEventHandler(
    "SevenLife:Medic:PutIntoVehicle",
    function(id)
        TriggerClientEvent("SevenLife:Medic:PutIntoVehicleClient", id)
    end
)

local carrying = {}
local carried = {}

RegisterServerEvent("SevenLife:Medic:Sync")
AddEventHandler(
    "SevenLife:Medic:Sync",
    function(targetSrc)
        local source = source
        local sourcePed = GetPlayerPed(source)
        local sourceCoords = GetEntityCoords(sourcePed)
        local targetPed = GetPlayerPed(targetSrc)
        local targetCoords = GetEntityCoords(targetPed)
        if #(sourceCoords - targetCoords) <= 3.0 then
            TriggerClientEvent("SevenLife:Medic:SyncTarget", targetSrc, source)
            carrying[source] = targetSrc
            carried[targetSrc] = source
        end
    end
)

RegisterServerEvent("SevenLife:Medic:Stop")
AddEventHandler(
    "CSevenLife:Medic:Stop",
    function(targetSrc)
        local source = source

        if carrying[source] then
            TriggerClientEvent("SevenLife:Medic:Cl_Stops", targetSrc)
            carrying[source] = nil
            carried[targetSrc] = nil
        elseif carried[source] then
            TriggerClientEvent("SevenLife:Medic:Cl_Stops", carried[source])
            carrying[carried[source]] = nil
            carried[source] = nil
        end
    end
)

AddEventHandler(
    "playerDropped",
    function(reason)
        local source = source

        if carrying[source] then
            TriggerClientEvent("SevenLife:Medic:Cl_Stops", carrying[source])
            carried[carrying[source]] = nil
            carrying[source] = nil
        end

        if carried[source] then
            TriggerClientEvent("SevenLife:Medic:Cl_Stops", carried[source])
            carrying[carried[source]] = nil
            carried[source] = nil
        end
    end
)
RegisterServerEvent("SevenLife:Medic:GiveMedikamente")
AddEventHandler(
    "SevenLife:Medic:GiveMedikamente",
    function(id)
        TriggerClientEvent("SevenLife:Medic:GiveMedikamenteClient", id)
    end
)
RegisterServerEvent("SevenLife:Medic:MakeBill")
AddEventHandler(
    "SevenLife:Medic:MakeBill",
    function(id, label, reason, amount)
        local _source = source
        local xTarget = ESX.GetPlayerFromId(id)
        local amount = tonumber(amount)
        if amount < 0 then
            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Du musst über 0 Euro als Rechnung eingeben")
        else
            if xTarget ~= nil then
                MySQL.Async.execute(
                    "INSERT INTO bill_options (identifier, title, reason, price, stand, firma) VALUES (@identifier, @title, @reason, @price, @stand, @firma)",
                    {
                        ["@identifier"] = xTarget.identifier,
                        ["@title"] = label,
                        ["@reason"] = reason,
                        ["@price"] = amount,
                        ["@stand"] = "notpaid",
                        ["@firma"] = "medic"
                    },
                    function()
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            xTarget.source,
                            "Du hast eine Rechnung in höche von " .. amount .. "bekommen"
                        )
                    end
                )
            else
                TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Es gibt keinem Spieler in deiner Nähe")
            end
        end
    end
)
RegisterServerEvent("SevenLife:Medic:BuyItem")
AddEventHandler(
    "SevenLife:Medic:BuyItem",
    function(label, preis, rang)
        local _source = source
        local identifier = ESX.GetPlayerFromId(source).identifier

        local preis = tonumber(preis)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        if tonumber(money) >= preis then
            xPlayer.removeAccountMoney("money", preis)
            xPlayer.addInventoryItem(label, 1)
            local moneys = xPlayer.getMoney()
            TriggerClientEvent("SevenLife:Medic:Geld", source, moneys)
        end
    end
)
