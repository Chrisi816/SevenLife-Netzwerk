local DISCORD_URL =
    "https://discord.com/api/webhooks/880120337784774698/Ni9-Ek7l4oersd6fBA_YAFO48SK3loLQeW5E6FLx_Lyl1kH4zCVI6xs3XhJllLvgrJnA"
function sendtoDiscord(color, name, message, footer)
    if message == nil or message == "" then
        return false
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

ESX = nil
local connectedPlayers, maxPlayers = {}, GetConvarInt("sv_maxclients", 32)
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5 * 60000)
            for k, playerid in pairs(GetPlayers()) do
                local xplayer = ESX.GetPlayerFromId(playerid)
                if xplayer ~= nil then
                    MySQL.Async.fetchAll(
                        "SELECT visastufe, visaxp FROM users WHERE identifier = @identifier",
                        {
                            ["@identifier"] = xplayer.identifier
                        },
                        function(result)
                            for k, v in pairs(Config.levels) do
                                if result[1].visastufe == v.level then
                                    local endproduct = result[1].visaxp + 0.5
                                    if endproduct >= v.xp then
                                        local endlevel = result[1].visastufe + 1
                                        MySQL.Async.execute(
                                            "UPDATE users SET visaxp = @visaxp , visastufe = @visastufe WHERE identifier = @identifer",
                                            {
                                                ["@identifer"] = xplayer.identifier,
                                                ["@visaxp"] = 0,
                                                ["@visastufe"] = endlevel
                                            },
                                            function()
                                                TriggerClientEvent(
                                                    "SevenLife:TimetCustom:Notify",
                                                    playerid,
                                                    "Visa",
                                                    "Du bist jetzt in der Visa Stufe " ..
                                                        endlevel .. " angekommen, Herzlichen Glückwunsch!",
                                                    3000
                                                )
                                            end
                                        )
                                    else
                                        MySQL.Async.execute(
                                            "UPDATE users SET visaxp = @visaxp WHERE identifier = @identifer",
                                            {
                                                ["@identifer"] = xplayer.identifier,
                                                ["@visaxp"] = endproduct
                                            },
                                            function()
                                            end
                                        )
                                    end
                                end
                            end
                        end
                    )
                end
            end
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:MainMenu:GetInfosFirstSite",
    function(source, cb)
        local name = GetPlayerName(source)
        local onlinePlayers = GetNumPlayerIndices()
        local _source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT warns, statuse, vip, orga, visastufe, job, visaxp, name, wohnort FROM users WHERE identifier = @identifer",
            {
                ["@identifer"] = identifiers
            },
            function(result)
                MySQL.Async.fetchAll(
                    "SELECT * FROM skillsystem_level WHERE id = @id",
                    {
                        ["@id"] = identifiers
                    },
                    function(result1)
                        cb(result, result1, name, onlinePlayers)
                    end
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:MainMenu:GetData",
    function(source, cb)
        local date = os.date("*t")
        local actualltime = ("%02d:%02d:%02d"):format(date.hour, date.min, date.sec)

        cb(actualltime)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:MainMenu:ShowPlayers",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT name, statuse, visastufe, id FROM users ",
            {},
            function(result)
                cb(result)
            end
        )
    end
)
local NumberCharset = {}
local Charset = {}
for i = 48, 57 do
    table.insert(NumberCharset, string.char(i))
end

for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

RegisterServerEvent("SevenLife:MainMenu:Identifier")
AddEventHandler(
    "SevenLife:MainMenu:Identifier",
    function()
        local _source = source
        local identifiers = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT id FROM users WHERE identifier = @identifer",
            {
                ["@identifer"] = identifiers
            },
            function(result)
                if result == nil then
                    local id = GetID()
                    MySQL.Async.execute(
                        "UPDATE users SET id = @id WHERE identifier = @identifer",
                        {
                            ["@identifer"] = identifiers,
                            ["@id"] = id
                        },
                        function()
                        end
                    )
                end
            end
        )
    end
)
function GetID()
    local MakePlate
    local doBreak = false

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())

        MakePlate = string.upper(GetRandomNumber(6))

        MySQL.Async.fetchAll(
            "SELECT name FROM users WHERE id = @id",
            {
                ["@id"] = MakePlate
            },
            function(result)
                if result == nil then
                    doBreak = true
                end
            end
        )

        if doBreak then
            break
        end
    end

    return MakePlate
end

function GetRandomNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ""
    end
end

RegisterServerEvent("SevenLife:MainMenu:MakeTickeDC")
AddEventHandler(
    "SevenLife:MainMenu:MakeTickeDC",
    function(coords, titel, nachricht)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(_source).identifier
        local players = ESX.GetPlayers()
        for i = 1, #players do
            if IsPlayerAceAllowed(players[i], "admin") then
                TriggerClientEvent(
                    "SevenLife:Admin:MakeChatNachricht",
                    "Admin",
                    GetPlayerName(_source) .. " hat gerade ein Ticket eröffnet"
                )
            end
        end
        sendtoDiscord(
            1704191,
            "System - Ticket",
            "**" ..
                GetPlayerName(_source) ..
                    "** hat gerade ein Ticket Eröffnet \n\n **Titel:** " ..
                        titel ..
                            "\n\n **Beschreibung**: " ..
                                nachricht ..
                                    "\n\n **Coords**: " .. coords .. "\n\n **Identifier**: " .. identifiers .. "\n",
            "Made by Chrisi"
        )
    end
)
local se = {}
local mi = {}
local hr = {}
local di = {}

RegisterServerEvent("SevenLife:TimeTracker:GetTime")
AddEventHandler(
    "SevenLife:TimeTracker:GetTime",
    function()
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT Seconds, Minutes, Hours, Days FROM times WHERE identifier = @id",
            {["@id"] = identifier},
            function(gotInfo)
                if gotInfo[1] ~= nil then
                    TriggerClientEvent(
                        "SevenLife:TrackTime:SendDATA",
                        _source,
                        gotInfo[1].Seconds,
                        gotInfo[1].Minutes,
                        gotInfo[1].Hours,
                        gotInfo[1].Days
                    )
                else
                    local news = 0
                    local newm = 0
                    local newh = 0
                    local newd = 0
                    MySQL.Async.execute(
                        "INSERT INTO times (identifier, Seconds, Minutes, Hours, Days) VALUES (@Identifier,@Seconds,@Minutes,@Hours,@Days)",
                        {
                            ["@Identifier"] = identifier,
                            ["@Seconds"] = news,
                            ["@Minutes"] = newm,
                            ["@Hours"] = newh,
                            ["@Days"] = newd
                        }
                    )
                    TriggerClientEvent("SevenLife:TrackTime:SendDATA", _source, news, newm, newh, newd)
                end
            end
        )
    end
)
RegisterServerEvent("SevenLife:MainMenu:savetime")
AddEventHandler(
    "SevenLife:MainMenu:savetime",
    function(s, m, h, d)
        local _source = source
        se[_source] = {
            ["total"] = s
        }
        mi[_source] = {
            ["total"] = m
        }
        hr[_source] = {
            ["total"] = h
        }
        di[_source] = {
            ["total"] = d
        }
    end
)
RegisterServerEvent("SevenLife:MainMenu:savetimedb")
AddEventHandler(
    "SevenLife:MainMenu:savetimedb",
    function(s, m, h, d)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.execute(
            "UPDATE times SET Seconds=@SECONDS, Minutes = @MINUTES, Hours = @HOURS, Days = @DAYS WHERE identifier=@identifier",
            {
                ["@SECONDS"] = s,
                ["@MINUTES"] = m,
                ["@HOURS"] = h,
                ["@DAYS"] = d,
                ["@identifier"] = identifier
            }
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:MainMenu:GetStats",
    function(source, cb)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT name, kills, deaths, datumerstellen FROM users WHERE identifier = @identifer",
            {
                ["@identifer"] = identifiers
            },
            function(result)
                cb(result)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:MainMenu:GetHour",
    function(source, cb)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT Minutes, Hours, Days FROM times WHERE identifier = @identifer",
            {
                ["@identifer"] = identifiers
            },
            function(result)
                cb(result)
            end
        )
    end
)

RegisterServerEvent("SevenLife:MainMenu:MakeTicketMySQL")
AddEventHandler(
    "SevenLife:MainMenu:MakeTicketMySQL",
    function(coords, titel, beschreibung, status, typeofticket)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.execute(
            "INSERT INTO reports (identifier, name, about, description, dnt, type, coords) VALUES (@Identifier,@name,@about,@description,@dnt, @type, @coords)",
            {
                ["@Identifier"] = identifiers,
                ["@name"] = GetPlayerName(_source),
                ["@about"] = titel,
                ["@description"] = beschreibung,
                ["@dnt"] = status,
                ["@type"] = typeofticket,
                ["@coords"] = coords
            },
            function(result)
                Citizen.Wait(100)
                MySQL.Async.fetchAll(
                    "SELECT id FROM reports WHERE identifier = @identifer AND about = @about AND description = @description",
                    {
                        ["@identifer"] = identifiers,
                        ["@about"] = titel,
                        ["@description"] = beschreibung
                    },
                    function(resultse)
                        MySQL.Async.execute(
                            "INSERT INTO verlauftickets (id, absender, nachricht) VALUES (@id, @absender, @nachricht)",
                            {
                                ["@id"] = resultse[1].id,
                                ["@absender"] = GetPlayerName(_source),
                                ["@nachricht"] = beschreibung
                            },
                            function(result)
                            end
                        )
                    end
                )
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:MainMenu:GetTicket",
    function(source, cb)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT id, identifier, name, about, type FROM reports WHERE identifier = @identifer",
            {
                ["@identifer"] = identifiers
            },
            function(result)
                cb(result)
            end
        )
    end
)

RegisterServerEvent("SevenLife:MainMenu:DeleteTicket")
AddEventHandler(
    "SevenLife:MainMenu:DeleteTicket",
    function(id)
        MySQL.Async.execute(
            "DELETE FROM reports WHERE id = @id",
            {
                ["@id"] = id
            },
            function()
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:MainMenu:GetTicketDetails",
    function(source, cb, id)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT id, identifier, name, about, dnt ,description, type FROM reports WHERE id = @id ",
            {
                ["@id"] = id
            },
            function(result)
                MySQL.Async.fetchAll(
                    "SELECT * FROM verlauftickets WHERE id = @id ",
                    {
                        ["@id"] = id
                    },
                    function(results)
                        cb(result, results)
                    end
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Player:GetConnectedPlayers",
    function(source, cb)
        cb(connectedPlayers, maxPlayers)
    end
)

AddEventHandler(
    "esx:setJob",
    function(playerId, job, lastJob)
        connectedPlayers[playerId].job = job.name
    end
)

AddEventHandler(
    "esx:playerLoaded",
    function(playerId, xPlayer)
        Citizen.Wait(10000)
        AddPlayerToScoreboard(xPlayer, true)
    end
)

AddEventHandler(
    "esx:playerDropped",
    function(playerId)
        connectedPlayers[playerId] = nil
    end
)

RegisterServerEvent("SevenLife:OnlinePlayer:GetData")
AddEventHandler(
    "SevenLife:OnlinePlayer:GetData",
    function()
        local _source = source
        connectedPlayers = {}
        AddPlayersToScoreboard(_source)
    end
)
function AddPlayerToScoreboard(xPlayer, _source)
    local playerId = xPlayer.source

    connectedPlayers[playerId] = {}
    connectedPlayers[playerId].ping = GetPlayerPing(playerId)
    connectedPlayers[playerId].id = playerId

    connectedPlayers[playerId].name = Sanitize(xPlayer.getName())
    connectedPlayers[playerId].job = xPlayer.job.name
end

function AddPlayersToScoreboard(_source)
    local players = ESX.GetPlayers()

    for i = 1, #players, 1 do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        AddPlayerToScoreboard(xPlayer, _source)
    end

    TriggerClientEvent("SevenLife:OnlinePlayer:UpdateConnectedPlayers", _source, connectedPlayers)
end

function Sanitize(str)
    local replacements = {
        ["&"] = "&amp;",
        ["<"] = "&lt;",
        [">"] = "&gt;",
        ["\n"] = "<br/>"
    }

    return str:gsub("[&<>\n]", replacements):gsub(
        " +",
        function(s)
            return " " .. ("&nbsp;"):rep(#s - 1)
        end
    )
end
local Time = {}
RegisterServerEvent("SevenLife:MainMenu:SaveTime")
AddEventHandler(
    "SevenLife:MainMenu:SaveTime",
    function(time)
        local _source = source
        Time[_source] = time
    end
)
RegisterServerEvent("SevenLife:MainMenu:MakeCode")
AddEventHandler(
    "SevenLife:MainMenu:MakeCode",
    function(value)
        local xPlayer = ESX.GetPlayerFromId(source)
        if value == "freegift" then
            xPlayer.addAccountMoney("money", 500)
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "MainMenu",
                "Erfolgreich den Code " .. value .. "eingelöst",
                3000
            )
        else
            TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "MainMenu", "Code nicht vorhanden", 3000)
        end
    end
)
RegisterServerEvent("SevenLife:MainMenu:MakeCreatorCode")
AddEventHandler(
    "SevenLife:MainMenu:MakeCreatorCode",
    function(value)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT identifier FROM creatorcodes WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(result)
                if result[1] ~= nil then
                    MySQL.Async.execute(
                        "UPDATE creatorcodes SET code = @code WHERE identifier = @identifer",
                        {
                            ["@identifer"] = identifier,
                            ["@code"] = value
                        },
                        function()
                        end
                    )
                else
                    MySQL.Async.execute(
                        "INSERT INTO creatorcodes (identifier, code) VALUES (@Identifier,@code)",
                        {
                            ["@Identifier"] = identifier,
                            ["@code"] = value
                        }
                    )
                end
            end
        )
    end
)
RegisterServerEvent("SevenLife:MainMenu:MakeNachricht")
AddEventHandler(
    "SevenLife:MainMenu:MakeNachricht",
    function(nachricht, id)
        local _source = source
        local players = ESX.GetPlayers()
        for i = 1, #players do
            if IsPlayerAceAllowed(players[i], "admin") then
                TriggerClientEvent(
                    "SevenLife:Admin:MakeChatNachricht",
                    "Admin",
                    "#" .. id .. " wurde gerade bearbeitet!"
                )
            end
        end
        MySQL.Async.execute(
            "INSERT INTO verlauftickets (id, absender, nachricht) VALUES (@id, @absender, @nachricht)",
            {
                ["@id"] = id,
                ["@absender"] = GetPlayerName(_source),
                ["@nachricht"] = nachricht
            },
            function()
                Citizen.Wait(20)
                MySQL.Async.fetchAll(
                    "SELECT * FROM verlauftickets WHERE id = @id",
                    {
                        ["@id"] = id
                    },
                    function(result)
                        TriggerClientEvent("SevenLife:MainMenu:UpdateTicketChat", _source, result)
                    end
                )
            end
        )
    end
)
local function round(num)
    return math.floor(num + 0.5)
end

ESX.RegisterServerCallback(
    "SevenLife:MainMenu:GetSeasonPassData",
    function(source, cb)
        local EndTime = os.time {year = 2023, month = 9, day = 23, hour = 0}
        local Currenttime = os.time()
        local difference = EndTime - Currenttime
        local days = round(difference / 86400)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local users =
            MySQL.Sync.fetchAll(
            "SELECT levelbattlepass, coinsbattlepass FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        local data =
            MySQL.Sync.fetchAll(
            "SELECT * FROM abgeholtebattlepass WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        cb(users, data, days)
    end
)
RegisterServerEvent("SevenLife:Phone:GiveCoins")
AddEventHandler(
    "SevenLife:Phone:GiveCoins",
    function(amount)
        local _source = source
        local identifier = ESX.GetPlayerFromId(source).identifier
        local users =
            MySQL.Sync.fetchAll(
            "SELECT levelbattlepass, coinsbattlepass FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        if tonumber(users[1].coinsbattlepass + amount) >= 200 then
            MySQL.Async.execute(
                "UPDATE users SET coinsbattlepass = @coinsbattlepass AND levelbattlepass = @levelbattlepass WHERE identifier = @identifer",
                {
                    ["@identifer"] = identifier,
                    ["@coinsbattlepass"] = 0,
                    ["@levelbattlepass"] = tonumber(users[1].levelbattlepass + 1)
                },
                function()
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "MainMenu",
                        "Du hast 10 Coins bekommen.",
                        3000
                    )
                    Citizen.Wait(100)
                    local users =
                        MySQL.Sync.fetchAll(
                        "SELECT levelbattlepass, coinsbattlepass FROM users WHERE identifier = @identifier",
                        {
                            ["@identifier"] = identifier
                        }
                    )
                    TriggerClientEvent(
                        "SevenLife:Phone:UpdateCoins",
                        _source,
                        users[1].coinsbattlepass,
                        users[1].levelbattlepass
                    )
                end
            )
        end
    end
)
RegisterServerEvent("SevenLife:Phone:ValideData")
AddEventHandler(
    "SevenLife:Phone:ValideData",
    function(index, types, label, amount, normal)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local users =
            MySQL.Sync.fetchAll(
            "SELECT levelbattlepass, coinsbattlepass, ownpremium FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )

        if normal == true and users[1].ownpremium == "false" then
            if users[1].levelbattlepass >= index then
                local infos2 =
                    MySQL.Sync.fetchAll(
                    "SELECT * FROM abgeholtebattlepass WHERE identifier = @identifier AND level = @level",
                    {
                        ["@identifier"] = identifier,
                        ["@level"] = index
                    }
                )

                if infos2[1] ~= nil and infos2[1].pass == "1" then
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "MainMenu",
                        "Du hast diese Belohnung schon abgeholt!",
                        3000
                    )
                else
                    if types == "money" then
                        local amount = tonumber(amount)
                        xPlayer.addAccountMoney("money", amount)
                    elseif types == "item" then
                        local amount = tonumber(amount)
                        xPlayer.addInventoryItem(label, amount)
                    end
                    MySQL.Async.execute(
                        "INSERT INTO abgeholtebattlepass (identifier, level, pass) VALUES (@identifier, @level, @pass)",
                        {
                            ["@identifier"] = identifier,
                            ["@level"] = index,
                            ["@pass"] = true
                        },
                        function()
                            TriggerClientEvent(
                                "SevenLife:TimetCustom:Notify",
                                _source,
                                "MainMenu",
                                "Transaktion war erfolgreich!",
                                3000
                            )
                        end
                    )
                end
            else
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "MainMenu",
                    "Du musst Level " .. index .. " erst erreichen!",
                    3000
                )
            end
        else
            if users[1].ownpremium == "true" and normal == false then
                if users[1].levelbattlepass >= index then
                    local infos2 =
                        MySQL.Sync.fetchAll(
                        "SELECT * FROM abgeholtebattlepass WHERE identifier = @identifier AND level = @level",
                        {
                            ["@identifier"] = identifier,
                            ["@level"] = index
                        }
                    )
                    if infos2[1] ~= nil and infos2[1].pass == "1" then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "MainMenu",
                            "Du hast diese Belohnung schon abgeholt!",
                            3000
                        )
                    else
                        if types == "money" then
                            xPlayer.addAccountMoney("money", amount)
                        elseif types == "item" then
                            xPlayer.addInventoryItem(label, amount)
                        end
                        MySQL.Async.execute(
                            "INSERT INTO abgeholtebattlepass (identifier, level, pass) VALUES (@identifier, @level, @pass)",
                            {
                                ["@identifier"] = identifier,
                                ["@level"] = index,
                                ["@pass"] = true
                            },
                            function()
                                TriggerClientEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    _source,
                                    "MainMenu",
                                    "Transaktion war erfolgreich!",
                                    3000
                                )
                            end
                        )
                    end
                else
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "MainMenu",
                        "Du musst Level " .. index .. " erst erreichen!",
                        3000
                    )
                end
            else
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "MainMenu",
                    "Du besitzt den Premium Pass nicht!",
                    3000
                )
            end
        end
        TriggerClientEvent("SevenLife:Phone:UpdateState", _source)
    end
)
