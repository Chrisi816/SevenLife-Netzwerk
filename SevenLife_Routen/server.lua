ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Sand:CheckIfPlayerHaveItem",
    function(source, cb, item)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local item = xPlayer.getInventoryItem(item).count
        local sand = xPlayer.getInventoryItem("sand").count
        if sand < 50 then
            if item >= 1 then
                cb(true)
            else
                TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Sand", "Du brauchst einen Spaten")
            end
        else
            if sand >= 51 then
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Sand",
                    "Du hast in deinem Rucksack kein Platz"
                )
            end
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Sand:CheckIfPlayerHaveItemsand",
    function(source, cb, item)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local item = xPlayer.getInventoryItem("sand").count
        local glas = xPlayer.getInventoryItem("glas").count
        if glas < 50 then
            if item >= 3 then
                xPlayer.removeInventoryItem("sand", 6)
                cb(true)
            else
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Sand - Verarbeiter",
                    "Du hast zu wenig Sand"
                )
            end
        else
            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Sand", "Du hast in deinem Rucksack kein Platz")
        end
    end
)

RegisterServerEvent("SevenLife:GiveItem")
AddEventHandler(
    "SevenLife:GiveItem",
    function(item, count)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem(item, count)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:FarmingRouten:HavePlayerEnoughSpace",
    function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local count = xPlayer.getInventoryItem(item).count
        if count < 50 then
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:Farming:GivePlayerItem")
AddEventHandler(
    "SevenLife:Farming:GivePlayerItem",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("karotten", math.random(1, 3))
        local _source = source
        local identifier = xPlayer.identifier
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM battlepassmissionen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )

        if check[1] ~= nil then
            if tonumber(check[1].index1) == 3 then
                TriggerEvent("SevenLife:SeasonPass:MakeProgress", 1, false, _source, 3, 50)
            end
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Verarbeiter:CheckItems",
    function(source, cb, item, anzahl1, items2, anzahl2, enditems)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local item1 = xPlayer.getInventoryItem(item).count
        local item2 = xPlayer.getInventoryItem(items2).count
        local enditem = xPlayer.getInventoryItem(enditems).count
        if enditem < 50 then
            if item1 >= anzahl1 and item2 >= anzahl2 then
                xPlayer.removeInventoryItem(item, anzahl1)
                xPlayer.removeInventoryItem(items2, anzahl2)
                cb(true)
            else
                cb(false)
            end
        else
            TriggerClientEvent(
                "SevenLife:Verarbeiter:Time:Notify",
                _source,
                "Du hast in deinem Rucksack kein Platz mehr"
            )
        end
    end
)

RegisterServerEvent("SevenLife:Verarbeiter:GiveItem")
AddEventHandler(
    "SevenLife:Verarbeiter:GiveItem",
    function(item)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem(item, 1)
    end
)
RegisterServerEvent("SevenLife:Farming:GivePlayerItems")
AddEventHandler(
    "SevenLife:Farming:GivePlayerItems",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("kartoffel", math.random(1, 4))
        local _source = source
        local identifier = xPlayer.identifier
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM battlepassmissionen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )

        if check[1] ~= nil then
            if tonumber(check[1].index1) == 2 then
                TriggerEvent("SevenLife:SeasonPass:MakeProgress", 1, false, _source, 4, 50)
            end
        end
    end
)

RegisterServerEvent("SevenLife:Baumarkt:Spaten")
AddEventHandler(
    "SevenLife:Baumarkt:Spaten",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("spaten", 1)
    end
)
RegisterServerEvent("SevenLife:Baumarkt:GiveSpitzhacke")
AddEventHandler(
    "SevenLife:Baumarkt:GiveSpitzhacke",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("pickaxe", 1)
    end
)
RegisterServerEvent("SevenLife:Baumarkt:Givebehealter")
AddEventHandler(
    "SevenLife:Baumarkt:Givebehealter",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("behälter", 1)
    end
)
RegisterServerEvent("SevenLife:FarmingRouten:GiveItem")
AddEventHandler(
    "SevenLife:FarmingRouten:GiveItem",
    function(item, price)
        local _source = source
        local price = tonumber(price)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getAccount("money").money

        if money < price then
            local diffirenz = price - money
            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Baumarkt", "Dir fehlen " .. diffirenz .. "$")
        else
            xPlayer.removeAccountMoney("money", price)
            xPlayer.addInventoryItem(item, 1)
        end
    end
)
RegisterServerEvent("SevenLife:Routen:GiveItem")
AddEventHandler(
    "SevenLife:Routen:GiveItem",
    function(name, count)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem(name, count)
    end
)
