--------------------------------------------------------------------------------------------------------------
------------------------------------------------ESX-----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Unternehmen:CheckIfPlayerHaveUnternehmen",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM unternehmen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] ~= nil then
                    cb(true)
                else
                    cb(false)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Unternehmen:CheckBuero",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT bueronummer FROM unternehmen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                cb(result[1].bueronummer)
            end
        )
    end
)
AddEventHandler(
    "esx:playerDropped",
    function(playerId)
        TriggerClientEvent("SevenLife:Unternehmen:TPPlayerOut", playerId)
    end
)
