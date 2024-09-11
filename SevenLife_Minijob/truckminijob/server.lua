ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("sevenlife:giveaccountcash")
AddEventHandler(
    "sevenlife:giveaccountcash",
    function(howmany)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney("money", howmany)
    end
)
