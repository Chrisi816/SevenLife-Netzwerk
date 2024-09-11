ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:AnfangsQuest:CheckIfPlayerHaveAccount",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT missionid FROM anfangsmissionen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] ~= nil then
                    cb(true)
                else
                    MySQL.Async.execute(
                        "INSERT INTO anfangsmissionen (`identifier`, `missionid`) VALUES (@identifier, @missionid)",
                        {
                            ["@identifier"] = identifiers,
                            ["@missionid"] = 1
                        },
                        function()
                            cb(false)
                        end
                    )
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Quest:GetAll",
    function(source, cb)
        local source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        Citizen.CreateThread(
            function()
                while identifiers == nil do
                    Citizen.Wait(1)
                end
                MySQL.Async.fetchAll(
                    "SELECT missionid FROM anfangsmissionen WHERE identifier = @identifier",
                    {
                        ["@identifier"] = identifiers
                    },
                    function(result)
                        if result[1] ~= nil then
                            cb(true, result[1].missionid)
                        else
                            cb(false)
                        end
                    end
                )
            end
        )
    end
)
RegisterServerEvent("SevenLife:Quest:Override")
AddEventHandler(
    "SevenLife:Quest:Override",
    function(id)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.execute(
            "UPDATE anfangsmissionen SET missionid = @missionid WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers,
                ["@missionid"] = id
            },
            function(result)
            end
        )
    end
)
