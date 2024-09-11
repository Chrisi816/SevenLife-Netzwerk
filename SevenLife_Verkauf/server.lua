ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterUsableItem(
    "vertrag",
    function(source)
        local _source = source
        TriggerClientEvent("SevenLife:KaufVertrag:OpenCard", _source)
    end
)
