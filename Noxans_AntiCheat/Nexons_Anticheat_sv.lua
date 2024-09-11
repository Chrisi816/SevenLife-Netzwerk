ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

local DISCORD_URL_Banlogs = Config.DiscordUrl_banlogs
local DISCORDSPAM_URL_Banlogs = Config.DiscordUrl_messgaes
local DISCORDHALLOFSHAME_URL_ = Config.DiscordUrl_HallOfShame

text =
    [[
    _  __                                    ___         __    _   _____   __              __ 
   / |/ / ___  __ __ ___ _  ___   ___       / _ |  ___  / /_  (_) / ___/  / /  ___  ___ _ / /_
  /    / / _ \ \ \ // _ `/ / _ \ (_-<      / __ | / _ \/ __/ / / / /__   / _ \/ -_)/ _ `// __/
 /_/|_/  \___//_\_\ \_,_/ /_//_//___/ ____/_/ |_|/_//_/\__/ /_/  \___/  /_//_/\__/ \_,_/ \__/ 
                                  /___/                                                    
      
                                 VERSION: 1.0.1
                                Powered by Noxans 
    
]]
print(text)
function ExtractIdentifiers()
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end
    if not live then
        identifiers.live = "Microsoft: Missing"
    end
    if not xbl then
        identifiers.xbl = "Xbox Live: Missing"
    end

    return identifiers
end

RegisterServerEvent("noxans:hallofshame")
AddEventHandler(
    "noxans:hallofshame",
    function(reason, fast)
        if IsPlayerAceAllowed(source, "antibypass") then
            print("ADMIN = NO BAN")
        else
            local identifiers = ExtractIdentifiers()
            sendittodiscords(
                16711680,
                "Noxans - Anticheat",
                GetPlayerName(source) ..
                    " wurde vom server gebannt. (Grund: " .. reason .. "\n **Schnelligkeit:** " .. fast .. "KM/h",
                "Noxans - Kick_System"
            )
            DropPlayer(source, reason)
        end
    end
)

RegisterServerEvent("noxans:hallofshamecar")
AddEventHandler(
    "noxans:hallofshamecar",
    function(reason, car)
        if IsPlayerAceAllowed(source, "antibypass") then
            print("ADMIN = NO BAN")
        else
            local identifiers = ExtractIdentifiers()
            sendittodiscords(
                16711680,
                "Noxans - Anticheat",
                GetPlayerName(source) .. " wurde vom server gebannt. (Grund: " .. reason .. "**Auto: " .. car .. "**",
                "Noxans - Kick_System"
            )
        end
    end
)

RegisterServerEvent("nexons:kickplayer")
AddEventHandler(
    "nexons:kickplayer",
    function(reason, weapon)
        if IsPlayerAceAllowed(source, "antibypass") then
            print("ADMIN = NO BAN")
        else
            local identifiers = ExtractIdentifiers()
            if Config.sendDiscordlog_Banlogs then
                sendittodiscord(
                    16711680,
                    "Noxans - Anticheat",
                    GetPlayerName(source) ..
                        " wurde vom server gekickt. (Grund: " ..
                            reason ..
                                ") **Folgende Waffen waren im Inventar: **" ..
                                    weapon ..
                                        "\n\n ``Informationen``: \n\n``" ..
                                            identifiers.license ..
                                                "``\n\n``" ..
                                                    identifiers.steam ..
                                                        "``\n\n``" ..
                                                            identifiers.discord ..
                                                                "``\n\n``" ..
                                                                    identifiers.live ..
                                                                        "``\n\n``" ..
                                                                            identifiers.ip ..
                                                                                "``\n\n``" .. identifiers.xbl .. "``",
                    "Noxans - Kick_System"
                )
            end
            DropPlayer(source, reason)
        end
    end
)

RegisterServerEvent("nexons:kickplayercar")
AddEventHandler(
    "nexons:kickplayercar",
    function(reason, car)
        if IsPlayerAceAllowed(source, "antibypass") then
            print("ADMIN = NO BAN")
        else
            local identifiers = ExtractIdentifiers()
            if Config.sendDiscordlog_Banlogs then
                sendittodiscord(
                    16711680,
                    "Noxans - Anticheat",
                    GetPlayerName(source) ..
                        " wurde vom server gekickt. (Grund: " ..
                            reason ..
                                ") \n **Benutztes Auto:** " ..
                                    car ..
                                        "\n\n ``Informationen``: \n\n``" ..
                                            identifiers.license ..
                                                "``\n\n``" ..
                                                    identifiers.steam ..
                                                        "``\n\n``" ..
                                                            identifiers.discord ..
                                                                "``\n\n``" ..
                                                                    identifiers.live ..
                                                                        "``\n\n``" ..
                                                                            identifiers.ip ..
                                                                                "``\n\n``" .. identifiers.xbl .. "``",
                    "Noxans - Kick_System"
                )
                DropPlayer(source, reason)
            end
        end
    end
)

RegisterServerEvent("nexons:antijump")
AddEventHandler(
    "nexons:antijump",
    function(reason, jumplenght)
        if IsPlayerAceAllowed(source, "antibypass") then
            print("ADMIN = NO BAN")
        else
            local identifiers = ExtractIdentifiers()
            if Config.sendDiscordlog_Banlogs then
                sendittodiscord(
                    16711680,
                    "Noxans - Anticheat",
                    GetPlayerName(source) ..
                        " wurde vom server gekickt. (Grund: " ..
                            reason ..
                                ") \n **Sprunglänge:** " ..
                                    jumplenght ..
                                        "\n\n ``Informationen``: \n\n``" ..
                                            identifiers.license ..
                                                "``\n\n``" ..
                                                    identifiers.steam ..
                                                        "``\n\n``" ..
                                                            identifiers.discord ..
                                                                "``\n\n``" ..
                                                                    identifiers.live ..
                                                                        "``\n\n``" ..
                                                                            identifiers.ip ..
                                                                                "``\n\n``" .. identifiers.xbl .. "``",
                    "Noxans - Kick_System"
                )
                DropPlayer(source, reason)
            end
        end
    end
)

RegisterServerEvent("nexons:antifastrun")
AddEventHandler(
    "nexons:antifastrun",
    function(reason, fastrunnumber)
        if IsPlayerAceAllowed(source, "antibypass") then
            print("ADMIN = NO BAN")
        else
            local identifiers = ExtractIdentifiers()
            if Config.sendDiscordlog_Banlogs then
                sendittodiscord(
                    16711680,
                    "Noxans - Anticheat",
                    GetPlayerName(source) ..
                        " wurde vom server gekickt. (Grund: " ..
                            reason ..
                                ") \n **Schnelligkeit:** " ..
                                    fastrunnumber ..
                                        "\n\n ``Informationen``: \n\n``" ..
                                            identifiers.license ..
                                                "``\n\n``" ..
                                                    identifiers.steam ..
                                                        "``\n\n``" ..
                                                            identifiers.discord ..
                                                                "``\n\n``" ..
                                                                    identifiers.live ..
                                                                        "``\n\n``" ..
                                                                            identifiers.ip ..
                                                                                "``\n\n``" .. identifiers.xbl .. "``",
                    "Noxans - Kick_System"
                )
                DropPlayer(source, reason)
            end
        end
    end
)

RegisterServerEvent("nexons:antigame")
AddEventHandler(
    "nexons:antigame",
    function(reason)
        if IsPlayerAceAllowed(source, "antibypass") then
            print("ADMIN = NO BAN")
        else
            local identifiers = ExtractIdentifiers()
            if Config.sendDiscordlog_Banlogs then
                sendittodiscord(
                    16711680,
                    "Noxans - Anticheat",
                    GetPlayerName(source) ..
                        " wurde vom server gekickt. (Grund: " ..
                            reason ..
                                ") \n **Schnelligkeit:** " ..
                                    "\n\n ``Informationen``: \n\n``" ..
                                        identifiers.license ..
                                            "``\n\n``" ..
                                                identifiers.steam ..
                                                    "``\n\n``" ..
                                                        identifiers.discord ..
                                                            "``\n\n``" ..
                                                                identifiers.live ..
                                                                    "``\n\n``" ..
                                                                        identifiers.ip ..
                                                                            "``\n\n``" .. identifiers.xbl .. "``",
                    "Noxans - Kick_System"
                )
                DropPlayer(source, reason)
            end
        end
    end
)

-- blacklistetcommands
if Config.Checkmessage then
    RegisterServerEvent("chat:addMessage")
    RegisterServerEvent("chat:messageisEntered")
    AddEventHandler(
        "chat:messageisEntered",
        function()
            local playername = GetPlayerName(source)
            TriggerClientEvent("chatMessage", -1, "Noxans - AntiCheat", {180, 0, 0}, playername .. "wurde gekickt")
        end
    )
end
RegisterServerEvent("nexons:anticommand")
AddEventHandler(
    "nexons:nexons:anticommand",
    function(reason)
        if IsPlayerAceAllowed(source, "antibypass") then
            print("ADMIN = NO BAN")
        else
            local identifiers = ExtractIdentifiers()
            if Config.sendDiscordlog_Banlogs then
                sendittodiscord(
                    16711680,
                    "Noxans - Anticheat",
                    GetPlayerName(source) ..
                        " wurde vom server gekickt. (Grund: " ..
                            reason ..
                                ") \n **Schnelligkeit:** " ..
                                    "\n\n ``Informationen``: \n\n``" ..
                                        identifiers.license ..
                                            "``\n\n``" ..
                                                identifiers.steam ..
                                                    "``\n\n``" ..
                                                        identifiers.discord ..
                                                            "``\n\n``" ..
                                                                identifiers.live ..
                                                                    "``\n\n``" ..
                                                                        identifiers.ip ..
                                                                            "``\n\n``" .. identifiers.xbl .. "``",
                    "Noxans - Kick_System"
                )
                DropPlayer(source, reason)
            end
        end
    end
)

RegisterServerEvent("noxans:resourcestart")
AddEventHandler(
    "noxans:resourcestart",
    function()
        if Config.sendDiscordlog_Banlogs then
            sendittodiscordmessages(
                16711680,
                "Noxans - Anticheat",
                "Noxans - AntiCheat wurde gestartet",
                "Noxans - System - Announce"
            )
        end
    end
)
RegisterServerEvent("noxans:stopresource")
AddEventHandler(
    "noxans:stopresource",
    function()
        if Config.sendDiscordlog_Banlogs then
            sendittodiscordmessages(
                16711680,
                "Noxans - Anticheat",
                "Noxans - AntiCheat wurde gestoppt",
                "Noxans - System - Announce"
            )
        end
    end
)
function sendittodiscord(color, name, message, footer)
    if DISCORD_URL_Banlogs == nil or DISCORD_URL_Banlogs == "" then
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
        DISCORD_URL_Banlogs,
        function()
        end,
        "POST",
        json.encode({username = name, embeds = embed}),
        {["Content-Type"] = "application/json"}
    )
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

RegisterServerEvent("Noxans:Message:KickUniversal")
AddEventHandler(
    "Noxans:Message:KickUniversal",
    function(txt)
        if IsPlayerAceAllowed(source, "antibypass") then
            print("ADMIN = NO BAN")
        else
            local identifiers = ExtractIdentifiers()
            if Config.sendDiscordlog_Banlogs then
                sendittodiscord(
                    16711680,
                    "Noxans - Anticheat",
                    GetPlayerName(source) ..
                        " wurde vom server gekickt. (Grund: " ..
                            txt ..
                                ")" ..
                                    "\n\n ``Informationen``: \n\n``" ..
                                        identifiers.license ..
                                            "``\n\n``" ..
                                                identifiers.steam ..
                                                    "``\n\n``" ..
                                                        identifiers.discord ..
                                                            "``\n\n``" ..
                                                                identifiers.live ..
                                                                    "``\n\n``" ..
                                                                        identifiers.ip ..
                                                                            "``\n\n``" .. identifiers.xbl .. "``",
                    "Noxans - Kick_System"
                )
                DropPlayer(source, txt)
            end
        end
    end
)

RegisterServerEvent("Noxans:MessageSV:KickUniversal")
AddEventHandler(
    "Noxans:MessageSV:KickUniversal",
    function(txt, server)
        if IsPlayerAceAllowed(server, "antibypass") then
            print("ADMIN = NO BAN")
        else
            local identifiers = ExtractIdentifiers()
            if Config.sendDiscordlog_Banlogs then
                sendittodiscord(
                    16711680,
                    "Noxans - Anticheat",
                    GetPlayerName(server) ..
                        " wurde vom server gekickt. (Grund: " ..
                            txt ..
                                ")" ..
                                    "\n\n ``Informationen``: \n\n``" ..
                                        identifiers.license ..
                                            "``\n\n``" ..
                                                identifiers.steam ..
                                                    "``\n\n``" ..
                                                        identifiers.discord ..
                                                            "``\n\n``" ..
                                                                identifiers.live ..
                                                                    "``\n\n``" ..
                                                                        identifiers.ip ..
                                                                            "``\n\n``" .. identifiers.xbl .. "``",
                    "Noxans - Kick_System"
                )
                DropPlayer(server, txt)
            end
        end
    end
)
RegisterServerEvent("Noxans:AntiCheat:MakeScreenShot")
AddEventHandler(
    "Noxans:AntiCheat:MakeScreenShot",
    function()
        local src = source
        if not IsPlayerAceAllowed(src, "antibypass") then
            local screenshotOptions = {
                encoding = "png",
                quality = 1
            }
            local ids = ExtractIdentifiers(src)
            local playerIP = ids.ip
            local playerSteam = ids.steam
            local playerLicense = ids.license
            local playerXbl = ids.xbl
            local playerLive = ids.live
            local playerDisc = ids.discord
            exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(
                src,
                "https://discord.com/api/webhooks/1034172508519280680/TwwjLBMvukZTPQouLy_m0O4CkrxQU6TjPMRkwwU3C69pAMjdkJ6QAgQtKM9AASVCb6UA",
                screenshotOptions,
                {
                    username = "SevenLife",
                    avatar_url = "https://cdn.discordapp.com/attachments/954476483651461120/1034176560468598844/sevenlife.png",
                    content = "",
                    embeds = {
                        {
                            color = 16711680,
                            author = {
                                name = "SevenLife",
                                icon_url = "https://cdn.discordapp.com/attachments/954476483651461120/1034176560468598844/sevenlife.png"
                            },
                            title = "[Modder] Spieler hat Blacklistet Keys benutzt",
                            description = "**__Player Identifiers:__** \n\n" ..
                                "**Server ID:** `" ..
                                    src ..
                                        "`\n\n" ..
                                            "**Name:** `" ..
                                                GetPlayerName(src) ..
                                                    "`\n\n" ..
                                                        "**IP:** `" ..
                                                            playerIP ..
                                                                "`\n\n" ..
                                                                    "**Steam:** `" ..
                                                                        playerSteam ..
                                                                            "`\n\n" ..
                                                                                "**License:** `" ..
                                                                                    playerLicense ..
                                                                                        "`\n\n" ..
                                                                                            "**Xbl:** `" ..
                                                                                                playerXbl ..
                                                                                                    "`\n\n" ..
                                                                                                        "**Live:** `" ..
                                                                                                            playerLive ..
                                                                                                                "`\n\n" ..
                                                                                                                    "**Discord:** `" ..
                                                                                                                        playerDisc ..
                                                                                                                            "`\n\n",
                            footer = {
                                text = "[" .. src .. "]" .. GetPlayerName(src)
                            }
                        }
                    }
                }
            )
            print("text")
        end
    end
)

AddEventHandler(
    "entityCreating",
    function(entity)
        if DoesEntityExist(entity) then
            for k, v in pairs(Config.BlacklistedModels) do
                if GetEntityModel(entity) == GetHashKey(v) then
                    CancelEvent()
                    print("ENTITY ERROR: Blacklistet Objekt ID:[" .. NetworkGetEntityOwner(entity) .. "]")
                end
            end
        end
    end
)

AddEventHandler(
    "giveWeaponEvent",
    function(sender, data)
        CancelEvent()
        TriggerEvent("Noxans:MessageSV:KickUniversal", "Versucht Waffen zu geben", sender)
    end
)

AddEventHandler(
    "clearPedTasksEvent",
    function(sender, data)
        CancelEvent()
        TriggerEvent("Noxans:MessageSV:KickUniversal", "Versucht Spieler zu clearen", sender)
    end
)
AddEventHandler(
    "removeWeaponEvent",
    function(sender, data)
        CancelEvent()
        TriggerEvent("Noxans:MessageSV:KickUniversal", "Versucht Waffen zu nehmen", sender)
    end
)
AddEventHandler(
    "explosionEvent",
    function(sender, ev)
        for _, v in ipairs(Config.DeletedExplosions) do
            if ev.explosionType == v then
                CancelEvent()
                TriggerEvent("Noxans:MessageSV:KickUniversal", "Versucht Personen explodieren zu lassen", sender)
                return
            end
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Noxans:Bank",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getAccount("money").money
        local bank = xPlayer.getAccount("bank").money
        cb(money, bank)
    end
)

RegisterServerEvent("Noxans:CheckIfPlayerHaveToHighPing")
AddEventHandler(
    "Noxans:CheckIfPlayerHaveToHighPing",
    function()
        local ping = GetPlayerPing(source)
        if tonumber(ping) >= 500 then
            DropPlayer(source, "[Anti Lag Switch] Sicherheits Kick: Ping == " .. ping)
        end
    end
)

local function HaveWeaponInLoadout(xPlayer, weapon)
    for i, v in pairs(xPlayer.loadout) do
        if (GetHashKey(v.name) == weapon) then
            return true
        end
    end
    return false
end

RegisterServerEvent("Noxans:Veryfi:Weapon")
AddEventHandler(
    "Noxans:Veryfi:Weapon",
    function(weapon)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            if not HaveWeaponInLoadout(xPlayer, weapon) then
                DropPlayer(source, "[Anti Weapon] Waffe nicht im Inventar")
            end
        end
    end
)

local ProfRunning = false
RegisterConsoleListener(
    function(channel, message)
        if string.find(message, "server thread hitch warning") then
            if not ProfRunning then
                ExecuteCommand("profiler record 100")
                ProfRunning = true
            end
        end
        if string.find(message, "Stopped the recording") then
            resname = GetCurrentResourceName()
            respath = GetResourcePath(resname)
            ExecuteCommand("profiler saveJSON " .. respath .. "/profiler.json")
        end
        if string.find(message, "Save complete") then
            oldnamets = 0
            oldname = None
            warnmessage = ""
            discordmessage = warnmessage .. "\n"
            json2 = LoadResourceFile(GetCurrentResourceName(), "profiler.json")
            traceEvents = json.decode(json2).traceEvents
            print(warnmessage)
            for k, v in pairs(traceEvents) do
                if string.find(v.name, "tick") then
                    if oldname == v.name then
                        ticktime = v.ts - oldnamets
                        if ticktime > 5000 then
                            name = string.gsub(v.name, "tick", "")
                            name = string.gsub(name, "%(", "")
                            name = string.gsub(name, "%)", "")
                            name = string.gsub(name, " ", "")
                            print(name .. ": " .. ticktime / 1000 .. "ms")
                            discordmessage = discordmessage .. name .. ": " .. ticktime / 1000 .. "ms\n"
                        end
                    end
                    oldname = v.name
                    oldnamets = v.ts
                end
            end

            ProfRunning = false
        end
    end
)
