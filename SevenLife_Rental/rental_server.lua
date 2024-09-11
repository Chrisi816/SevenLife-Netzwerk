ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("sevenlife:spawncar")
AddEventHandler(
    "sevenlife:spawncar",
    function(name, minutes, preis)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local difference = preis - xPlayer.getMoney()
        if xPlayer.getMoney() < preis then
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                _source,
                "Vermietung",
                "Dir fehlt " .. difference .. "$",
                2000
            )
        else
            xPlayer.removeMoney(preis)
            TriggerClientEvent("SevenLife:Quest:UpdateIfPossible", _source, 1)
            TriggerClientEvent("sevenlife:spawncar", _source, name, minutes)
        end
    end
)
