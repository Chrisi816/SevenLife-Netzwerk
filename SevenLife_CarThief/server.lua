ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("sevenlife:givecashsesffd")
AddEventHandler(
    "sevenlife:givecashsesffd",
    function(howmany)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney("money", howmany)
    end
)
