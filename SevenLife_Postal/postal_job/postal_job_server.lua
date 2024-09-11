ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Postal:CheckJob",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = xPlayer.getJob()
        if job.name == "postal" then
            cb(true)
        else
            cb(false)
        end
    end
)
RegisterServerEvent("SevenLife:Postal:GiveJobToPlayer")
AddEventHandler(
    "SevenLife:Postal:GiveJobToPlayer",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.setJob("postal", 0)
    end
)

RegisterServerEvent("SevenLife:Post:GiveMoney")
AddEventHandler(
    "SevenLife:Post:GiveMoney",
    function(money)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney("money", money)
    end
)
