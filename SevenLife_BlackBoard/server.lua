ESX = nil
-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
ESX.RegisterServerCallback(
    "SevenLife:BlackBoard:GetActiveLetters",
    function(source, cb)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        local aktivebleatter =
            MySQL.Sync.fetchAll(
            "SELECT * FROM blackboard",
            {},
            function(result)
            end
        )
        cb(aktivebleatter)
    end
)
RegisterServerEvent("SevenLife:BlackBoard:Finisch")
AddEventHandler(
    "SevenLife:BlackBoard:Finisch",
    function(id, desc, titel)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.execute(
            "INSERT INTO blackboard (identifier, titel, description, imgfrage) VALUES (@identifier, @titel, @description, @imgfrage)",
            {
                ["@identifier"] = identifier,
                ["@titel"] = titel,
                ["@description"] = desc,
                ["@imgfrage"] = id
            },
            function()
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "BlackBoard",
                    "Erfolgreich Poster angeheftet",
                    1500
                )
            end
        )
    end
)
RegisterServerEvent("SevenLife:BlackBoard:Finisch2")
AddEventHandler(
    "SevenLife:BlackBoard:Finisch2",
    function(id, src)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.execute(
            "INSERT INTO blackboard (identifier, imgfrage, src) VALUES (@identifier, @imgfrage, @src)",
            {
                ["@identifier"] = identifier,
                ["@imgfrage"] = id,
                ["@src"] = src
            },
            function()
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "BlackBoard",
                    "Erfolgreich Poster angeheftet",
                    1500
                )
            end
        )
    end
)
Citizen.CreateThread(
    function()
        while true do
            local currenttime = os.date("*t", os.time())

            MySQL.Async.fetchAll(
                "SELECT * FROM blackboard",
                {},
                function(result)
                    for k, v in pairs(result) do
                        if tonumber(currenttime["hour"]) == 4 and tonumber(currenttime["min"]) == 0 then
                            MySQL.Async.execute(
                                "DELETE FROM blackboard WHERE id = @id ",
                                {
                                    ["@id"] = v.id
                                },
                                function()
                                end
                            )
                        end
                    end
                end
            )
            Citizen.Wait(60000)
        end
    end
)
