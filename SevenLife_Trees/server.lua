ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
local list
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5500)
            local random = math.random(1, 6)

            list = Config.TreeCoords[random]

            Citizen.Wait(60000 * 30)
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Trees:GetItem",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local checkitem = xPlayer.getInventoryItem("axt").count
        if checkitem >= 1 then
            cb(true)
        else
            cb(false)
        end
    end
)
RegisterServerEvent("SevenLife:Trees:RemoveAll")
AddEventHandler(
    "SevenLife:Trees:RemoveAll",
    function()
        TriggerClientEvent("SevenLife:Trees:Remove", -1)
    end
)
RegisterServerEvent("SevenLife:Trees:GetData")
AddEventHandler(
    "SevenLife:Trees:GetData",
    function()
        TriggerClientEvent("SevenLife:Trees:SyncFallenTree3", source, list)
    end
)
