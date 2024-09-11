ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Blips:GetShowedBlips",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT blipid FROM showedblips WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Blips:NeuerOrtEntdeckt")
AddEventHandler(
    "SevenLife:Blips:NeuerOrtEntdeckt",
    function(blipid)
        local _source = source
        local identifier = ESX.GetPlayerFromId(source).identifier
        local blipid = tonumber(blipid)
        MySQL.Async.execute(
            "INSERT INTO showedblips (identifier, blipid) VALUES (@Identifier,@blipid)",
            {
                ["@Identifier"] = identifier,
                ["@blipid"] = blipid
            },
            function(result)
                Citizen.Wait(10000)
                MySQL.Async.fetchAll(
                    "SELECT blipid FROM showedblips WHERE identifier = @identifier",
                    {
                        ["@identifier"] = identifier
                    },
                    function(results)
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Region",
                            "Du hast eine neue Region entdeckt",
                            3000
                        )
                        TriggerClientEvent("SevenLife:Blips:UpdateBlips", _source, results)
                    end
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Blips:IsBlipRegistret",
    function(source, cb, blip)
        local _source = source
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT blipid FROM showedblips WHERE identifier = @identifier AND blipid = @blipid",
            {
                ["@identifier"] = identifier,
                ["@blipid"] = blip
            },
            function(results)
                if results[1] ~= nil then
                    cb(true)
                else
                    cb(false)
                end
            end
        )
    end
)
