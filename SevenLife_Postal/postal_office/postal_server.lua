ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:GetMails",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM postal WHERE toidentifer = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                cb(result)
            end
        )
    end
)

RegisterServerEvent("SevenLife:Bote:Giveitem")
AddEventHandler(
    "SevenLife:Bote:Giveitem",
    function(item, number, name, toid, id)
        print("hey")
        local number = tonumber(number)
        local xPlayer = ESX.GetPlayerFromId(source)
        print(item)
        print(number)
        xPlayer.addInventoryItem(item, number)
        MySQL.Async.fetchAll(
            "DELETE FROM postal WHERE name = @name AND toidentifer = @toidentifer AND things = @things AND number = @number AND id = @id",
            {
                ["@name"] = name,
                ["@toidentifer"] = toid,
                ["@things"] = item,
                ["@number"] = number,
                ["@id"] = id
            }
        )
    end
)

RegisterServerEvent("SevenLife:addPost")
AddEventHandler(
    "SevenLife:addPost",
    function(name, item, number, id)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.execute(
            "INSERT INTO postal (name,toidentifer,things,number, id) VALUES (@name, @toidentifer, @things, @number, @id)",
            {
                ["@name"] = name,
                ["@toidentifer"] = identifiers,
                ["@things"] = item,
                ["@number"] = number,
                ["@id"] = id
            }
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:idtaken",
    function(source, cb, id)
        MySQL.Async.fetchAll(
            "SELECT * FROM postal WHERE id = @id",
            {
                ["@id"] = id
            },
            function(result)
                cb(result[1] ~= nil)
            end
        )
    end
)
