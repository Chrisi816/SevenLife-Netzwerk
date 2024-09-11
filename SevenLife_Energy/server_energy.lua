TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Energy:CheckIfHaveItem",
    function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local item = xPlayer.getInventoryItem(item)["count"]

        if item >= 1 then
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:Energy:RemoveItem")
AddEventHandler(
    "SevenLife:Energy:RemoveItem",
    function(item)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        xPlayer.removeInventoryItem(item, 1)
    end
)
local blackoutstatus = false
local blackoutdur = 600
local cooldown = 3600
RegisterServerEvent("SevenLife:Energy:BlackOut")
AddEventHandler(
    "SevenLife:Energy:BlackOut",
    function(status, state)
        blackoutstatus = true
        local xPlayers = ESX.GetPlayers()

        for i = 1, #xPlayers, 1 do
            TriggerClientEvent("SevenLife:Energy:SyncBlackOut", xPlayers[i], status, state)
        end
        BlackoutTimer()
    end
)

function BlackoutTimer()
    local timer = blackoutdur
    repeat
        Citizen.Wait(1000)
        timer = timer - 1
    until timer == 0
    blackoutstatus = false
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        TriggerClientEvent("SevenLife:Energy:Activate", xPlayers[i], false)
    end
end
