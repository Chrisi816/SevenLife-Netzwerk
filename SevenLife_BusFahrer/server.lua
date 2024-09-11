ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
ESX.RegisterServerCallback(
    "SevenLife:BusFahrer:CheckifEnoughMoney",
    function(source, cb, preis)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        if xPlayer.getMoney() < preis then
            cb(false)
        else
            xPlayer.removeMoney(preis)

            cb(true)
        end
    end
)
