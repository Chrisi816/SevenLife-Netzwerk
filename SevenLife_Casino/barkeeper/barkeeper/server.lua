ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterNetEvent("SevenLife:Casino:Buy")
AddEventHandler(
    "SevenLife:Casino:Buy",
    function(Item, ItemCount, preis)
        local _source = source
        local preis = tonumber(preis)
        local xPlayer = ESX.GetPlayerFromId(_source)

        local ItemCount = tonumber(ItemCount)
        local Item = string.lower(Item)

        if xPlayer.getMoney() < preis then
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                _source,
                "Casino",
                "Du hast zu wenig Geld um so eine Menge zu kaufen",
                2000
            )
        else
            xPlayer.removeMoney(preis)
            xPlayer.addInventoryItem(Item, ItemCount)
        end
    end
)
ESX.RegisterUsableItem(
    "casino_vodka",
    function(source)
        TriggerClientEvent("SevenLife:Casino:Vodka", source)
    end
)
ESX.RegisterUsableItem(
    "casino_wein",
    function(source)
        TriggerClientEvent("SevenLife:Casino:Wein", source)
    end
)
