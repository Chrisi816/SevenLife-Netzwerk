local isrobbingactive = false
local isttimerrobactive = false

ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:ShopRobbery:GetInfos",
    function(source, cb)
        if not isrobbingactive then
            if not isttimerrobactive then
                -- end
                local police = 0
                for _, playerId in pairs(ESX.GetPlayers()) do
                    local xPlayer = ESX.GetPlayerFromId(playerId)
                    if xPlayer.job.name == "police" then
                        police = police + 1
                    end
                end
                -- if police >= 2 then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end
)
RegisterServerEvent("evenLife:ShopRobbery:AlarmPD")
AddEventHandler(
    "evenLife:ShopRobbery:AlarmPD",
    function()
        for _, playerId in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer.job.name == "police" then
                TriggerClientEvent(
                    "SevenLife:TimetCustom:PoliceNotify",
                    playerId,
                    "Momentan wird ein Laden ausgeraubt!"
                )
            end
        end
    end
)
RegisterServerEvent("SevenLife:ShopRobbery:MakeBlips")
AddEventHandler(
    "SevenLife:ShopRobbery:MakeBlips",
    function(x, y, z)
        TriggerClientEvent("SevenLife:ShopRobbery:MakeBlip", -1, x, y, z)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:ShopRobbery:GiveMoney",
    function(source, cb, money)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney("money", money)
        cb(money)
    end
)
