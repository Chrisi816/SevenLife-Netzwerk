ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("sevenlife:checkyuremoneybag")
AddEventHandler(
    "sevenlife:checkyuremoneybag",
    function(howmanycostit)
        local xPlayer = ESX.GetPlayerFromId(source)
        local cash = xPlayer.getMoney()
        if cash < howmanycostit then
            leftcash = howmanycostit - cash
            TriggerClientEvent("sevenlife:fjsfjjdfsjfjjsj", source, leftcash)
        else
            if cash > howmanycostit then
                xPlayer.removeMoney(howmanycostit)
                TriggerClientEvent("sevenlife:sdfkfskfkskfk", source)
            end
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:CleanUp:CheckMoney",
    function(source, cb, money)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if (xPlayer.getMoney() < money) then
            cb(false)
        else
            if (xPlayer.getMoney() >= money) then
                xPlayer.removeAccountMoney("money", money)
                cb(true)
            end
        end
    end
)
