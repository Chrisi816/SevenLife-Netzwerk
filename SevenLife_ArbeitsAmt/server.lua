ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:GetJobs",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT jobname,label, value FROM arbeitsamt ",
            {},
            function(result)
                cb(result)
            end
        )
    end
)

RegisterServerEvent("SevenLife:JobCenter:AddJob")
AddEventHandler(
    "SevenLife:JobCenter:AddJob",
    function(job, label)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = string.lower(job)

        xPlayer.setJob(job, 0)
        TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Arbeitsamt", "Du bist jetzt " .. label, 2000)
    end
)
