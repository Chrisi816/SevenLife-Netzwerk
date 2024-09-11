ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:AnimalHunting:GiveReward")
AddEventHandler(
    "SevenLife:AnimalHunting:GiveReward",
    function(item, number)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        xPlayer.addInventoryItem(item, number)
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
            if tonumber(check[1].index3) == 4 then
                TriggerEvent("SevenLife:SeasonPass:MakeProgress", 1, false, _source, 1, 20)
            end
        end
    end
)

ESX.RegisterUsableItem(
    "fleisch",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("fleisch", 1)

        TriggerClientEvent("esx_status:add", source, "hunger", 200000)
        TriggerClientEvent("SevenLife:AnimalHunting:onfleisch", source)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:AnimalHunt:CheckEnoughMoney",
    function(source, cb, money)
        local xPlayer = ESX.GetPlayerFromId(source)
        local moneyplayer = xPlayer.getMoney()
        if moneyplayer >= money then
            cb(true)
            xPlayer.removeAccountMoney("money", money)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:AnimalHunting:GiveMesser")
AddEventHandler(
    "SevenLife:AnimalHunting:GiveMesser",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addWeapon("WEAPON_KNIFE", 1)
    end
)

RegisterServerEvent("SevenLife:AnimalHunting:GiveLizenz")
AddEventHandler(
    "SevenLife:AnimalHunting:GiveLizenz",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        MySQL.Async.execute(
            "UPDATE seven_licenses SET jagdlicense = @jagdlicense WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier,
                ["@jagdlicense"] = "true"
            },
            function(result)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Verarbeiters:CheckItems",
    function(source, cb, item, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        local count = xPlayer.getInventoryItem(item).count
        if count >= amount then
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:Verarbeiter:Removeitems")
AddEventHandler(
    "SevenLife:Verarbeiter:Removeitems",
    function(item, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(item, amount)
    end
)
RegisterServerEvent("SevenLife:Verarbeiter:GiveItems")
AddEventHandler(
    "SevenLife:Verarbeiter:GiveItems",
    function(item, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem(item, amount)
    end
)
