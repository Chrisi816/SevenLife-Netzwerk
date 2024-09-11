local DISCORD_URL =
    "https://discord.com/api/webhooks/884860468106260520/K2vJCc8HBEdkQ3HFdTIq4b8G98hbUKu1BJUxefOQZCTXVfUF3yeSs924fuCWxrE3fL1p"
local DISCORD_URL1 =
    "https://discord.com/api/webhooks/884860899557519380/OkvSoUyPEQ0gSbEiOdnkMoC9gc0PQ6hrIAAzxLbiPqGcItps4AnwcmIzB6sqyZ8P4aRR"
local DISCORD_URL2 =
    "https://discord.com/api/webhooks/891026273369989130/6Mq4DVHBkBzM3DNhvoBTqa1U5BznntvkFcvFaMpyEgh-PoJgnw6bHqQSBFb1fkZAspwv"
function sendtoDiscord(color, name, message, footer)
    if message == nil or message == "" then
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
        DISCORD_URL,
        function(err, text, headers)
        end,
        "POST",
        json.encode({username = name, embeds = embed}),
        {["Content-Type"] = "application/json"}
    )
end

AddEventHandler(
    "playerConnecting",
    function()
        sendtoDiscord(
            1704191,
            "System - Connection",
            "**" .. GetPlayerName(source) .. "** Versucht gerade den Server zu joinen.",
            "Made by Chrisi"
        )
    end
)

function sendtoDiscorddis(color, name, message, footer)
    if message == nil or message == "" then
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
        DISCORD_URL1,
        function(err, text, headers)
        end,
        "POST",
        json.encode({username = name, embeds = embed}),
        {["Content-Type"] = "application/json"}
    )
end

AddEventHandler(
    "playerDropped",
    function(reason)
        sendtoDiscorddis(
            16711680,
            "System - Disconnect",
            GetPlayerName(source) .. " ist vom Server geleavt. \n" .. "(Grund: **" .. reason .. "**)",
            "Made by Chrisi"
        )
    end
)
RegisterServerEvent("sevenlife:playerdied")
AddEventHandler(
    "sevenlife:playerdied",
    function(name, grund, killer)
        sendtoDiscorddisdead(
            16711680,
            "System - Tod",
            GetPlayerName(source) .. " ist gestorben " .. "\n Grund: " .. grund .. "\n Beteiligte: " .. killer,
            "Made by Chrisi"
        )
    end
)

function sendtoDiscorddisdead(color, name, message, footer)
    if message == nil or message == "" then
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
        DISCORD_URL2,
        function(err, text, headers)
        end,
        "POST",
        json.encode({username = name, embeds = embed}),
        {["Content-Type"] = "application/json"}
    )
end
