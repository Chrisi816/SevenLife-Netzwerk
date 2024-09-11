ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:GetIfPlayerHavePet",
    function(source, cb, item, types)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        MySQL.Async.fetchAll(
            "SELECT * FROM pets WHERE identifier = @identifier",
            {["@identifier"] = identifier},
            function(result)
                if result[1] ~= nil then
                    if result[1].pettypes == types then
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Pets:MakePet")
AddEventHandler(
    "SevenLife:Pets:MakePet",
    function(item, price, types)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeAccountMoney("money", price)
        if types == 1 then
            MySQL.Async.execute(
                "INSERT INTO pets (identifier, pettypes) VALUES (@identifier, @pettypes)",
                {
                    ["@identifier"] = identifier,
                    ["@pettypes"] = 1
                }
            )
        elseif types == 2 then
            MySQL.Async.execute(
                "INSERT INTO pets (identifier, pettypes) VALUES (@identifier, @pettypes)",
                {
                    ["@identifier"] = identifier,
                    ["@pettypes"] = 2
                }
            )
        elseif types == 3 then
            MySQL.Async.execute(
                "INSERT INTO pets (identifier, pettypes) VALUES (@identifier, @pettypes)",
                {
                    ["@identifier"] = identifier,
                    ["@pettypes"] = 3
                }
            )
        elseif types == 4 then
            MySQL.Async.execute(
                "INSERT INTO pets (identifier, pettypes) VALUES (@identifier, @pettypes)",
                {
                    ["@identifier"] = identifier,
                    ["@pettypes"] = 4
                }
            )
        elseif types == 5 then
            MySQL.Async.execute(
                "INSERT INTO pets (identifier, pettypes) VALUES (@identifier, @pettypes)",
                {
                    ["@identifier"] = identifier,
                    ["@pettypes"] = 5
                }
            )
        elseif types == 6 then
            MySQL.Async.execute(
                "INSERT INTO pets (identifier, pettypes) VALUES (@identifier, @pettypes)",
                {
                    ["@identifier"] = identifier,
                    ["@pettypes"] = 6
                }
            )
        elseif types == 7 then
            MySQL.Async.execute(
                "INSERT INTO pets (identifier, pettypes) VALUES (@identifier, @pettypes)",
                {
                    ["@identifier"] = identifier,
                    ["@pettypes"] = 7
                }
            )
        end
    end
)
