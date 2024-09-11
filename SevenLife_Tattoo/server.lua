ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("sevenlife:friseur:pays")
AddEventHandler(
    "sevenlife:friseur:pays",
    function(preis)
        local source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local preis = tonumber(preis)
        xPlayer.removeMoney(preis)
    end
)

ESX.RegisterServerCallback(
    "sevenlife:friseur:checkMoneys",
    function(source, cb, preis)
        local xPlayer = ESX.GetPlayerFromId(source)
        local preis = tonumber(preis)
        cb(xPlayer.getMoney() >= preis)
    end
)
