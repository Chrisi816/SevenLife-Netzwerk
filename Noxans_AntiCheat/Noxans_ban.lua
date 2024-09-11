ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

History = {}
BanListing = {}
isbanlistloaded = false
banlisthistoryloaded = false
local optionale = false
function sendittodiscordses(color, name, message, footer)
    if Config.DiscordUrl_banlogs == nil or Config.DiscordUrl_banlogs == "" then
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
CreateThread(
    function()
        while true do
            Wait(2000)
            if isbanlistloaded == false then
                loadingbanlist()
                if BanListing ~= {} then
                    print("-----------------------------------------------------------------------")
                    print("----------------------------Banlist Loaded-----------------------------")
                    print("-----------------------------------------------------------------------")
                    isbanlistloaded = true
                else
                    print("-----------------------------------------------------------------------")
                    print("----------------------Fatal Error: Banlist-----------------------------")
                    print("-----------------------------------------------------------------------")
                end
            end

            if banlisthistoryloaded == false then
                loadhistory()
                if History ~= {} then
                    print("-----------------------------------------------------------------------")
                    print("----------------------------History Loaded-----------------------------")
                    print("-----------------------------------------------------------------------")
                    banlisthistoryloaded = true
                else
                    print("-----------------------------------------------------------------------")
                    print("-----------------------Fatal Error: History----------------------------")
                    print("-----------------------------------------------------------------------")
                end
            end
            local ms = GetGameTimer()
            local build = GetGameBuildNumber()
            local name = GetCurrentResourceName()
            local retval = GetResourceState(name)
            local path = GetResourcePath(name)

            if not optionale then
                print("-----------------------------------------------------------------------")
                print("-----------------------Systems are Optional----------------------------")
                print("-----------------------Current Ms: " .. ms .. "------------------------")
                print("-----------------------Build: " .. build .. "--------------------------")
                print("-----------------------Name: " .. name .. "----------------------------")
                print("-----------------------Status: " .. retval .. "------------------------")
                print("-----------------------Path: " .. path .. "----------------------------")
                print("-----------------------------------------------------------------------")
                optionale = true
            end
        end
    end
)

if Config.serversync then
    CreateThread(
        function(...)
            Wait(400000)
            MySQL.Async.fetchAll(
                "SELECT * FROM banlist",
                {},
                function(data)
                    if #data ~= #BanListing then
                        BanListing = {}

                        for i = 1, #data, 1 do
                            table.insert(
                                BanListing,
                                {
                                    license = data[i].license,
                                    identifier = data[i].identifier,
                                    liveid = data[i].liveid,
                                    xboxlid = data[i].xboxlid,
                                    discord = data[i].discord,
                                    ip = data[i].ip,
                                    reason = data[i].reason,
                                    added = data[i].added,
                                    expiration = data[i].expiration,
                                    permanent = data[i].permanent
                                }
                            )
                        end
                        loadhistory()
                    end
                end
            )
        end
    )
end

function loadingbanlist()
    MySQL.Async.fetchAll(
        "SELECT * FROM banlist",
        {},
        function(data)
            BanListing = {}

            for y = 1, #data, 1 do
                table.insert(
                    BanListing,
                    {
                        license = data[y].license,
                        identifier = data[y].identifier,
                        liveid = data[y].liveid,
                        xboxlid = data[y].xboxlid,
                        discord = data[y].discord,
                        ip = data[y].ip,
                        reason = data[y].reason,
                        ending = data[y].ending,
                        expiration = data[y].expiration,
                        permanent = data[y].permanent
                    }
                )
            end
        end
    )
end
function loadhistory()
    MySQL.Async.fetchAll(
        "SELECT * FROM banhistory",
        {},
        function(data)
            History = {}

            for y = 1, #data, 1 do
                table.insert(
                    History,
                    {
                        license = data[y].license,
                        identifier = data[y].identifier,
                        liveid = data[y].liveid,
                        xboxlid = data[y].xboxlid,
                        discord = data[y].discord,
                        ip = data[y].ip,
                        targetplayername = data[y].targetplayername,
                        sourceplayername = data[y].sourceplayername,
                        reason = data[y].reason,
                        added = data[y].added,
                        expiration = data[y].expiration,
                        permanent = data[y].permanent,
                        timeat = data[y].timeat
                    }
                )
            end
        end
    )
end
AddEventHandler(
    "playerConnecting",
    function(name, setKickReason, deferrals)
        local license, steamID, liveid, xblid, discord, playerip = "n/a", "n/a", "n/a", "n/a", "n/a", "n/a"

        for k, v in ipairs(GetPlayerIdentifiers(source)) do
            if string.sub(v, 1, string.len("license:")) == "license:" then
                license = v
            elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
                steamID = v
            elseif string.sub(v, 1, string.len("live:")) == "live:" then
                liveid = v
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                xblid = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                discord = v
            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                playerip = v
            end
        end

        if (BanListing == {}) then
            Citizen.Wait(1000)
        end

        for v = 1, #BanListing, 1 do
            if (BanListing[v].expiration == nil) then
                Citizen.Wait(1000)
            end
            if
                ((tostring(BanListing[v].license)) == tostring(license) or
                    (tostring(BanListing[v].identifier)) == tostring(steamID) or
                    (tostring(BanListing[v].liveid)) == tostring(liveid) or
                    (tostring(BanListing[v].xblid)) == tostring(xblid) or
                    (tostring(BanListing[v].discord)) == tostring(discord) or
                    (tostring(BanListing[v].playerip)) == tostring(playerip))
             then
                if tonumber(BanListing[v].permanent) == 1 then
                    setKickReason("Du wurdest Permament von diesem Server gebannt. Wegen: " .. BanListing[v].reason)
                    CancelEvent()
                    break
                else
                    if (tonumber(BanListing[v].expiration)) > os.time() then
                        local temp = (((tonumber(BanListing[v].expiration)) - os.time()) / 60)
                        if temp >= 1440 then
                            local day = (temp / 60) / 24
                            local hours = (day - math.floor(day)) * 24
                            local minutes = (hours - math.floor(hours)) * 60
                            local banday = math.floor(day)
                            local banhours = math.floor(hours)
                            local banminutes = math.ceil(minutes)
                            setKickReason(
                                "Du wurdest wegen: " ..
                                    BanListing[v].reason ..
                                        " Gebannt, für weitere: " ..
                                            banday .. "Tage " .. banhours .. "Stunden " .. banminutes .. "Minuten "
                            )
                            CancelEvent()
                            break
                        elseif temp >= 60 and temp < 1440 then
                            local day = (temp / 60) / 24
                            local hours = temp / 60
                            local minutes = (hours - math.floor(hours)) * 60
                            local banday = math.floor(day)
                            local banhours = math.floor(hours)
                            local banminutes = math.ceil(minutes)

                            setKickReason(
                                "Du wurdest wegen: " ..
                                    BanListing[v].reason ..
                                        " Gebannt, für weitere: " ..
                                            banday .. "Tage " .. banhours .. "Stunden " .. banminutes .. "Minuten "
                            )
                            CancelEvent()
                            break
                        elseif temp then
                            local day = 0
                            local hours = 0
                            local minutes = math.ceil(temp)
                            setKickReason(
                                "Du wurdest wegen: " ..
                                    BanListing[v].reason ..
                                        " Gebannt, für weitere: " ..
                                            day .. "Tage " .. hours .. "Stunden " .. minutes .. "Minuten "
                            )
                            CancelEvent()
                            break
                        end
                    elseif tonumber(BanListing[v].expiration) < os.time() and tonumber(BanListing[v].permanent) == 0 then
                        deletebanned(BanListing[v].identifier)
                        break
                    end
                end
            end
        end
    end
)

RegisterServerEvent("NOXANS:BAN:PLAYER")
AddEventHandler(
    "NOXANS:BAN:PLAYER",
    function(id, grund, dauer)
        local _source = source
        local id = tonumber(id:match("^%s*(.-)%s*$"))
        local grund = grund:match("^%s*(.-)%s*$")
        local dauer = tonumber(dauer:match("^%s*(.-)%s*$"))
        local players = ESX.GetPlayers()
        for i = 1, #players do
            if IsPlayerAceAllowed(players[i], "admin") then
                TriggerClientEvent(
                    "SevenLife:Admin:MakeChatNachricht",
                    "Admin",
                    GetPlayerName(_source) .. " wurde gebannt aufgrund von " .. grund .. ". Für " .. dauer .. "Tage"
                )
            end
        end
        local xPlayer = ESX.GetPlayerFromId(id)

        if xPlayer ~= nil then
            local identifier
            local license
            local liveid = ""
            local xblid = ""
            local discord = ""
            local playerip
            local duree = tonumber(dauer)
            local reason = grund
            local targetplayername = xPlayer.name
            local sourceplayername = GetPlayerName(source)

            if reason == "" then
                reason = ("Kein Grund Angegeben")
            end

            for k, v in ipairs(GetPlayerIdentifiers(_source)) do
                if string.sub(v, 1, string.len("steam:")) == "steam:" then
                    identifier = v
                elseif string.sub(v, 1, string.len("license:")) == "license:" then
                    license = v
                elseif string.sub(v, 1, string.len("live:")) == "live:" then
                    liveid = v
                elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                    xblid = v
                elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                    discord = v
                elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                    playerip = v
                end
            end

            if duree ~= nil or duree > 0 then
                local permanent = 0
                ban(
                    _source,
                    identifier,
                    license,
                    liveid,
                    xblid,
                    discord,
                    playerip,
                    targetplayername,
                    sourceplayername,
                    duree,
                    reason,
                    permanent
                )
                local temp = (((tonumber(duree)) - os.time()) / 60)
                local day = (temp / 60) / 24
                local hours = (day - math.floor(day)) * 24
                local minutes = (hours - math.floor(hours)) * 60
                DropPlayer(id, "AC Ban von " .. sourceplayername)
            else
                local permanent = 1
                ban(
                    _source,
                    identifier,
                    license,
                    liveid,
                    xblid,
                    discord,
                    playerip,
                    targetplayername,
                    sourceplayername,
                    duree,
                    reason,
                    permanent
                )
                local temp = (((tonumber(duree)) - os.time()) / 60)
                local day = (temp / 60) / 24
                local hours = (day - math.floor(day)) * 24
                local minutes = (hours - math.floor(hours)) * 60
                DropPlayer(id, "AC Ban von " .. sourceplayername)
            end
        else
            TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Noxans", "Fehler Code 1", 2000)
        end
    end
)

function ban(
    sources,
    identifier,
    license,
    liveid,
    xblid,
    discord,
    playerip,
    targetplayername,
    sourceplayername,
    duree,
    reason,
    permanent)
    print(reason)
    local expiration = duree * 86400
    local timeat = os.time()
    local message

    if expiration < os.time() then
        expiration = os.time() + expiration
    end

    table.insert(
        BanListing,
        {
            identifier = identifier,
            license = license,
            liveid = liveid,
            xblid = xblid,
            discord = discord,
            playerip = playerip,
            reason = reason,
            expiration = expiration,
            permanent = permanent
        }
    )

    MySQL.Async.execute(
        "INSERT INTO banlist (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,timeat,expiration,permanent) VALUES (@license,@identifier,@liveid,@xboxlid,@discord,@ip,@targetplayername,@sourceplayername,@reason,@timeat,@expiration,@permanent)",
        {
            ["@license"] = license,
            ["@identifier"] = identifier,
            ["@liveid"] = liveid,
            ["@xboxlid"] = xblid,
            ["@discord"] = discord,
            ["@ip"] = playerip,
            ["@targetplayername"] = targetplayername,
            ["@sourceplayername"] = sourceplayername,
            ["@reason"] = reason,
            ["@timeat"] = os.time(),
            ["@expiration"] = expiration,
            ["@permanent"] = permanent
        },
        function()
        end
    )

    MySQL.Async.execute(
        "INSERT INTO banhistory (license, identifier,liveid,xboxlid,discord,ip,targetplayername,sourceplayername,reason,timeat,added,expiration,permanent) VALUES (@license,@identifier,@liveid,@xboxlid,@discord,@ip,@targetplayername,@sourceplayername,@reason,@timeat,@added,@expiration, @permanent)",
        {
            ["@license"] = license,
            ["@identifier"] = identifier,
            ["@liveid"] = liveid,
            ["@xboxlid"] = xblid,
            ["@discord"] = discord,
            ["@ip"] = playerip,
            ["@targetplayername"] = targetplayername,
            ["@sourceplayername"] = sourceplayername,
            ["@reason"] = reason,
            ["@timeat"] = os.time(),
            ["@added"] = "hey",
            ["@expiration"] = expiration,
            ["@permanent"] = permanent
        },
        function()
        end
    )

    local temp = (((tonumber(expiration)) - os.time()) / 60)
    local day = (temp / 60) / 24
    local hours = (day - math.floor(day)) * 24
    local minutes = (hours - math.floor(hours)) * 60
    if IsPlayerAceAllowed(source, "antibypass") then
        print("ADMIN = NO BAN")
    else
        local identifiers = ExtractIdentifiers()

        sendittodiscordses(
            16711680,
            "Noxans - Anticheat",
            GetPlayerName(source) ..
                " wurde vom Server gebannt. (Grund: " ..
                    reason ..
                        ")" ..
                            "\n\n ``Dauer``: \n\n``" ..
                                day ..
                                    "``Tage ``" ..
                                        hours ..
                                            "``Stunden ``" ..
                                                minutes ..
                                                    "``Minuten ``" ..
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
                                                                                                "``\n\n``" ..
                                                                                                    identifiers.xbl ..
                                                                                                        "``",
            "Noxans - Kick_System"
        )
    end
    TriggerEvent("SevenLife:TimetCustom:Notify", sources, "Noxans", "Spieler Erfolgreich gebannt", 2000)
    BanListHistoryLoad = false
end
function deletebanned(identifier)
    MySQL.Async.execute(
        "DELETE FROM banlist WHERE identifier=@identifier",
        {
            ["@identifier"] = identifier
        },
        function()
            loadingbanlist()
        end
    )
end
