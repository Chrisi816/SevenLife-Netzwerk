ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:Orange:GiveItem")
AddEventHandler(
    "SevenLife:Orange:GiveItem",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("orange", 5)
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
            if tonumber(check[1].index1) == 1 then
                TriggerEvent("SevenLife:SeasonPass:MakeProgress", 1, false, _source, 5, 50)
            end
        end
    end
)
RegisterServerEvent("SevenLife:Orange:RemoveItems")
AddEventHandler(
    "SevenLife:Orange:RemoveItems",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("orange", 5)
    end
)
RegisterServerEvent("SevenLife:Orange:GiveVerpackteOrange")
AddEventHandler(
    "SevenLife:Orange:GiveVerpackteOrange",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("verpackte_orange", 1)
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
            if tonumber(check[1].index1) == 4 then
                TriggerEvent("SevenLife:SeasonPass:MakeProgress", 1, false, _source, 1, 10)
            end
        end
    end
)
