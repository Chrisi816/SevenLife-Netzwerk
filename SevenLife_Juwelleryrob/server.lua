local Copsonline = 0
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("sevenlife:checkcops")
AddEventHandler(
    "sevenlife:checkcops",
    function()
        local player = ESX.GetPlayers()
        Copsonline = 0
        for k = 1, #player, 1 do
            local xplayer = ESX.GetPlayerFromID(player[k])
        end
    end
)

RegisterServerEvent("sevenlife:startvetrine")
AddEventHandler(
    "sevenlife:startvetrine",
    function()
    end
)
RegisterServerEvent("sevenlife:getjewels")
AddEventHandler(
    "sevenlife:getjewels",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.addInventoryItem("juwelen", math.random(Config.jewelsstart, Config.jewelsend))
    end
)
RegisterServerEvent("sevenlife:checkjuwels")
AddEventHandler(
    "sevenlife:checkjuwels",
    function()
        local enoughitems
        local xPlayer = ESX.GetPlayerFromId(source)
        local juwelen = xPlayer.getInventoryItem("juwelen").count
        if juwelen < 20 then
            enoughitems = false
            TriggerClientEvent("sevenlife:callback", source, enoughitems)
        else
            if juwelen >= 20 then
                enoughitems = true
                TriggerClientEvent("sevenlife:callback", source, enoughitems)
            end
        end
    end
)
RegisterServerEvent("sevenlife:takejuwels")
AddEventHandler(
    "sevenlife:takejuwels",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("juwelen", 20)
    end
)
RegisterServerEvent("sevenlife:givecash")
AddEventHandler(
    "sevenlife:givecash",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney("bank", 200)
    end
)
