ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Fraktionslcn:getjob",
    function(source, cb, price)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = ESX.GetPlayerFromId(_source).identifier

        MySQL.Async.fetchAll(
            "SELECT * FROM job_player WHERE identifier= @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(results)
                if results[1].job == "LCN" then
                    cb(true)
                else
                    cb(false)
                end
            end
        )
    end
)
