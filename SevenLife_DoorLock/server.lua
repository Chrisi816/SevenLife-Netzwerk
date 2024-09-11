ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterUsableItem(
    "laptop",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local taschecount = xPlayer.getInventoryItem("tasche").count
        if taschecount >= 1 then
            xPlayer.removeInventoryItem("laptop", 1)
            TriggerClientEvent("SevenLife:Doorlock:StartHacking", source)
        else
            TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Tür", "Du brauchst eine Tasche", 2000)
        end
    end
)

local doorState = {}

RegisterServerEvent("SevenLife:DoorLock:UpdateState")
AddEventHandler(
    "SevenLife:DoorLock:UpdateState",
    function(doorIndex, state)
        local xPlayer = ESX.GetPlayerFromId(source)

        if
            xPlayer and type(doorIndex) == "number" and type(state) == "boolean" and SevenConfig.ListOfDoors[doorIndex] and
                isAuthorized(xPlayer.job.name, SevenConfig.ListOfDoors[doorIndex])
         then
            doorState[doorIndex] = state
            TriggerClientEvent("SevenLife:DoorLock:setState", -1, doorIndex, state)
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:DoorLock:GetState",
    function(source, cb)
        cb(doorState)
    end
)

function isAuthorized(jobName, doorObject)
    for k, job in pairs(doorObject.authorizedJobs) do
        if job == jobName then
            return true
        end
    end

    return false
end

ESX.RegisterUsableItem(
    "fakeidcard",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        TriggerClientEvent("SevenLife:Doorlock:OpenApp", source)
    end
)
