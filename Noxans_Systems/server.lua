local player = {}
local connectInfo = {}
local ipIdentifier
local discordId
local steamIdentifier, licenseIdentifier, xblid, liveid, sourceplayername, autoincriement
local DISCORDSPAM_URL_Banlogs =
    "https://discord.com/api/webhooks/884860468106260520/K2vJCc8HBEdkQ3HFdTIq4b8G98hbUKu1BJUxefOQZCTXVfUF3yeSs924fuCWxrE3fL1p"

AddEventHandler(
    "playerConnecting",
    function(playerName, setKickReason, deferrals)
        local _source = source
        local identifiers = GetPlayerIdentifiers(_source)
        local whitelisted
        local roles = {
            "866752119254941716"
        }

        deferrals.defer()
        Citizen.Wait(100)
        deferrals.update("Mit dem connecten akzeptierst du unsere Datenschutzvereinbarung")
        Citizen.Wait(2000)
        deferrals.update("Server protected by NOXANS Security / Protection Date: 04.10.2022 ")
        Citizen.Wait(2000)
        deferrals.update("Überprüfung der Verbindung")
        Citizen.Wait(2000)
        deferrals.update("Anti VPN connection check")

        for _, v in pairs(identifiers) do
            if string.find(v, "ip") then
                ipIdentifier = v:sub(4)
            elseif string.find(v, "steam") then
                steamIdentifier = v
            elseif string.find(v, "license") then
                licenseIdentifier = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                discordId = v
            elseif string.sub(v, 1, string.len("live:")) == "live:" then
                liveid = v
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                xblid = v
            end
        end

        if not ipIdentifier then
            deferrals.done("Wir konnten deine IP nicht finden")
            CancelEvent()
        else
            PerformHttpRequest(
                "http://ip-api.com/json/" .. ipIdentifier .. "?fields=proxy",
                function(err, text, headers)
                    if tonumber(err) == 200 then
                        local tbl = json.decode(text)
                        if tbl["proxy"] == false then
                        else
                            deferrals.done("Wir konnten deine IP nicht finden")
                            CancelEvent()
                        end
                    else
                        deferrals.done("Fehler in der API")
                        CancelEvent()
                    end
                end
            )
        end
        Citizen.Wait(500)
        deferrals.update("Check Steam Account")

        if not steamIdentifier then
            deferrals.done("Du musst Steam geöffnet haben")
            CancelEvent()
        end
        Citizen.Wait(500)
        deferrals.update("Check License of GTA")

        if not licenseIdentifier then
            deferrals.done("Du besitzt kein Gta oder deine License ist falsch")
            CancelEvent()
        end

        Citizen.Wait(5000)

        Citizen.Wait(1250)
        if not discordId then
            deferrals.done("Überprüfe ob deine Discord Applikation läuft und mit dem Internet verbindet ist")
            CancelEvent()
        end

        deferrals.update(" Überprüfung deines Discord Accounts")
        Citizen.Wait(1250)

        Citizen.Wait(100)

        for i = 1, #roles do
            local discRole = nil
            local DiscordID = string.gsub(discordId, "discord:", "")
            local endpoint = ("guilds/%s/members/%s"):format("866729353252831242", DiscordID)
            local member = MakeDiscordHTTPSRequest("GET", endpoint, {})
            if member.code == 404 then
                deferrals.done(" Du bist nicht auf unserem Discord")
                return
            elseif member.code == 200 then
                deferrals.done("Es gab einen fehler!")
                return
            end
            local data = json.decode(member.data)
            for k, v in ipairs(data.roles) do
                if roles[i] == v then
                    whitelisted = true
                    break
                end
            end
        end

        if not whitelisted then
            sendittodiscordmessages(
                "#ff0000",
                "Keine Whitelist",
                "Der spieler hat keine Whitelist",
                "NOXANS_WHITELIST CHECKER"
            )
            deferrals.done("Du bist nicht gewhitelistet. Whiteliste dich im Support!")

            CancelEvent()
        end

        Citizen.Wait(1000)
        deferrals.update("Check Global Ban list")

        Citizen.Wait(2000)
        deferrals.update("Whitelist erfolgreich initialinisiert. Viel Spaß auf SevenLife!")
        Citizen.Wait(2000)
        deferrals.done()
    end
)

RegisterServerEvent("SevenLife:Whitelist:RemovePlayerFromQueue")
AddEventHandler(
    "SevenLife:Whitelist:RemovePlayerFromQueue",
    function()
        for k, v in pairs(connectInfo) do
            if v.discordId == GetPlayerIdentifier(source, 3) then
                table.remove(connectInfo, k)
            end
        end
    end
)

function MakeDiscordHTTPSRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest(
        "https://discordapp.com/api/" .. endpoint,
        function(errorCode, resultData, resultHeaders)
            data = {data = resultData, code = errorCode, headers = resultHeaders}
        end,
        method,
        #jsondata > 0 and json.encode(jsondata) or "",
        {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bot ODg4NzI0Nzk4NzE1MzM0NjY2.YUW3dw.9d4xZ69x4-hW_EIPThJ2oKtoNgw"
        }
    )
    while data == nil do
        Wait(0)
    end

    return data
end

function sendittodiscordmessages(color, name, message, footer)
    if DISCORDSPAM_URL_Banlogs == nil or DISCORDSPAM_URL_Banlogs == "" then
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
        DISCORDSPAM_URL_Banlogs,
        function()
        end,
        "POST",
        json.encode({username = name, embeds = embed}),
        {["Content-Type"] = "application/json"}
    )
end
