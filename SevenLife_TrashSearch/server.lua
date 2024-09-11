ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:MüllDrop:GiveItem")
AddEventHandler(
    "SevenLife:MüllDrop:GiveItem",
    function(item, amount)
        local _soucre = source
        local xPlayer = ESX.GetPlayerFromId(_soucre)
        xPlayer.addInventoryItem(item, amount)
    end
)
