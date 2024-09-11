ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("sevenlife:friseur:pay")
AddEventHandler(
    "sevenlife:friseur:pay",
    function()
        local source = source
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeMoney(50)
    end
)

ESX.RegisterServerCallback(
    "sevenlife:friseur:checkMoney",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)

        cb(xPlayer.getMoney() >= 50)
    end
)
