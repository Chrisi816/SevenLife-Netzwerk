ESX = nil
local DISCORDHALLOFSHAME_URL_ = Config.DiscordURL
-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
RegisterServerEvent("sevenlife:makeannounce")
AddEventHandler(
    "sevenlife:makeannounce",
    function(arg1, arg2)
        TriggerClientEvent("sevenlife:announcehandler", -1, arg1, arg2)
        sendittodiscords(
            16711680,
            "Announce",
            "Nachricht: **" .. arg2 .. "**",
            "Noxans - Nachricht by " .. GetPlayerName(source)
        )
    end
)
function sendittodiscords(color, name, message, footer)
    if DISCORDHALLOFSHAME_URL_ == nil or DISCORDHALLOFSHAME_URL_ == "" then
        return False
    end
    local embed = {
        {
            ["color"] = color,
            ["title"] = "**" .. name .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer
            }
        }
    }
    PerformHttpRequest(
        DISCORDHALLOFSHAME_URL_,
        function()
        end,
        "POST",
        json.encode({username = name, embeds = embed}),
        {["Content-Type"] = "application/json"}
    )
end
RegisterServerEvent("sevenlife:safelaspos")
AddEventHandler(
    "sevenlife:safelaspos",
    function(x, y, z, h)
        local _source = source
        local player = ESX.GetPlayerFromId(source).identifier
        local lastpos = "{" .. x .. ", " .. y .. ",  " .. z .. ", " .. h .. "}"
        MySQL.Async.execute(
            "UPDATE users SET lastpos = @laspos WHERE identifier = @identifier",
            {
                ["@identifier"] = player,
                ["@laspos"] = lastpos
            },
            function(result)
            end
        )
    end
)

RegisterServerEvent("sevenlife:spawnplayer")
AddEventHandler(
    "sevenlife:spawnplayer",
    function()
        local _source = source
        local player = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchScalar(
            "SELECT lastpos FROM users WHERE identifier = @identifier",
            {["@identifier"] = player},
            function(result)
                local SpawnPos = json.decode(result)
                TriggerClientEvent("sevenlife:spawnpos", _source, SpawnPos[1], SpawnPos[2], SpawnPos[3])
            end
        )
    end
)
AddEventHandler(
    "playerDropped",
    function()
        TriggerEvent(
            "es:getPlayerFromId",
            source,
            function(user)
                local player = user.identifier
                local LastPos =
                    "{" ..
                    user.coords.x .. ", " .. user.coords.y .. ", " .. user.coords.z .. ", " .. user.coords.h .. "}"
                MySQL.Async.execute(
                    "UPDATE users SET lastpos = @lastpos WHERE identifier = @identifier",
                    {
                        ["@identifier"] = player,
                        ["@lastpos"] = LastPos
                    },
                    function(result)
                    end
                )
            end
        )
    end
)

RegisterServerEvent("restart:checkreboot")
AddEventHandler(
    "restart:checkreboot",
    function()
        date_local1 = os.date("%H:%M:%S", os.time())
        local date_local = date_local1
        if date_local == "05:00:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in einer Stunde Neu"
            )
        elseif date_local == "05:30:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 30 Minuten neu"
            )
        elseif date_local == "05:45:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 15 Minuten neu"
            )
        elseif date_local == "05:50:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 10 Minuten neu"
            )
        elseif date_local == "05:55:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 5 Minuten neu")
        elseif date_local == "05:56:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 4 Minuten neu")
        elseif date_local == "05:57:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 3 Minuten neu")
        elseif date_local == "05:58:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 2 Minuten neu")
        elseif date_local == "05:59:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 1ner Minuten neu"
            )
        elseif date_local == "11:00:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in einer Stunde Neu"
            )
        elseif date_local == "11:30:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 30 Minuten neu"
            )
        elseif date_local == "11:45:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 15 Minuten neu"
            )
        elseif date_local == "11:50:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 10 Minuten neu"
            )
        elseif date_local == "11:55:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 5 Minuten neu")
        elseif date_local == "11:56:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 4 Minuten neu")
        elseif date_local == "11:57:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 3 Minuten neu")
        elseif date_local == "11:58:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 2 Minuten neu")
        elseif date_local == "11:59:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 1ner Minuten neu"
            )
        elseif date_local == "17:00:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in einer Stunde Neu"
            )
        elseif date_local == "17:30:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 30 Minuten neu"
            )
        elseif date_local == "17:45:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 15 Minuten neu"
            )
        elseif date_local == "17:50:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 10 Minuten neu"
            )
        elseif date_local == "17:55:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 5 Minuten neu")
        elseif date_local == "17:56:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 4 Minuten neu")
        elseif date_local == "17:57:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 3 Minuten neu")
        elseif date_local == "17:58:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 2 Minuten neu")
        elseif date_local == "17:59:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 1ner Minuten neu"
            )
        elseif date_local == "23:00:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in einer Stunde Neu"
            )
        elseif date_local == "23:30:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 30 Minuten neu"
            )
        elseif date_local == "23:45:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 15 Minuten neu"
            )
        elseif date_local == "23:50:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 10 Minuten neu"
            )
        elseif date_local == "23:55:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 5 Minuten neu")
        elseif date_local == "23:56:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 4 Minuten neu")
        elseif date_local == "23:57:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 3 Minuten neu")
        elseif date_local == "23:58:00" then
            TriggerClientEvent("sevenlife:announcehandler", -1, "Server Restart", "Der Server startet in 2 Minuten neu")
        elseif date_local == "23:59:00" then
            TriggerClientEvent(
                "sevenlife:announcehandler",
                -1,
                "Server Restart",
                "Der Server startet in 1ner Minuten neu"
            )
        end
    end
)
function restart_server()
    SetTimeout(
        1000,
        function()
            TriggerEvent("restart:checkreboot")
            restart_server()
        end
    )
end
restart_server()

ESX.RegisterUsableItem(
    "repairkit",
    function(source)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer.job.name ~= "mechaniker" then
            TriggerClientEvent("SevenLife:RepairKit:Use", _source)
        end
    end
)
RegisterServerEvent("SevenLife:RepairKit:RemoveItem")
AddEventHandler(
    "SevenLife:RepairKit:RemoveItem",
    function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeInventoryItem("repairkit", 1)
    end
)
ESX.RegisterUsableItem(
    "repairkit",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        TriggerClientEvent("SevenLife:RepairKit:Use", source)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:SkillSystem:GetSkillOfStamina",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local id = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT obenlinksbutton1, obenlinksbutton2 FROM skillsystem_tree WHERE id = @id",
            {["@id"] = id},
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("SevenLife:GameSense:SyncRepairKit")

AddEventHandler(
    "SevenLife:GameSense:SyncRepairKit",
    function(car)
        TriggerClientEvent("SevenLife:GameSense:Client:SyncRepairKit", -1, car)
    end
)
