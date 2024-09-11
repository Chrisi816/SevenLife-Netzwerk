ESX = nil
Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(1000)
        end
    end
)

function DT(DATETIME)
    local M = {
        "Januar",
        "Februar",
        "März",
        "April",
        "Mai",
        "Juni",
        "Juli",
        "August",
        "September",
        "Oktober",
        "November",
        "Dezember"
    }
    local tableDT = (os.date("*t", tonumber(DATETIME)))
    tableDT.month = M[tonumber(tableDT.month)]
    return tableDT.month
end

RegisterServerEvent("sevenlife:getallinfos")
AddEventHandler(
    "sevenlife:getallinfos",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = xPlayer.getJob().name
        local handcash = xPlayer.getAccount("money").money
        local date = os.date("%d")
        local onlinePlayers = GetNumPlayerIndices()
        local deutschezeit = DT(os.date())
        TriggerClientEvent("sevenlife:getdatas", source, handcash, job, date, onlinePlayers, deutschezeit)
    end
)
