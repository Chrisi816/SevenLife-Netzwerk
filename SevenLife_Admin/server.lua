ESX = nil
-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Admin:CheckPerms",
    function(source, cb)
        if IsPlayerAceAllowed(source, "admin") then
            local identifier = ESX.GetPlayerFromId(source).identifier
            MySQL.Async.fetchAll(
                "SELECT `group`, `statuse` FROM users WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifier
                },
                function(result)
                    cb(result)
                end
            )
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Admin:GetTicketDetails",
    function(source, cb)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM reports",
            {},
            function(result)
                cb(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Admin:GetTicketDetailsDetails",
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
RegisterServerEvent("SevenLife:Admin:MakeNachricht")
AddEventHandler(
    "SevenLife:Admin:MakeNachricht",
    function(nachricht, id)
        local _source = source
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
                        TriggerClientEvent("SevenLife:Admin:UpdateTicketChat", _source, result)
                    end
                )
            end
        )
    end
)

RegisterServerEvent("SevenLife:Admin:DelTicket")
AddEventHandler(
    "SevenLife:Admin:DelTicket",
    function(id, identifier)
        if IsPlayerAceAllowed(source, "admin") then
            local _source = source
            MySQL.Async.execute(
                "DELETE FROM reports WHERE id = @id",
                {
                    ["@id"] = id
                },
                function()
                end
            )
            local retval = GetServerIdFromIdentifier(identifier)

            TriggerClientEvent("SevenLife:Admin:UpdateListOfTicket", retval)
            TriggerClientEvent("SevenLife:Admin:UpdateAdminList", _source)
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Admin",
                "Dein Team Rank ist zu weit unten um diese Aktion auszuführen",
                3000
            )
        end
    end
)

function GetIdentifier(playerId)
    for k, v in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.match(v, "license:") then
            local identifier = string.gsub(v, "license:", "")
            return identifier
        end
    end
end

function GetServerIdFromIdentifier(identifier)
    local wanted_id = nil

    for k, v in pairs(GetPlayers()) do
        local id = tonumber(v)
        if GetIdentifier(id) == identifier then
            wanted_id = id
        end
    end

    return wanted_id
end

RegisterServerEvent("SevenLife:Admin:TPSpielerzumir")
AddEventHandler(
    "SevenLife:Admin:TPSpielerzumir",
    function(coords, identifier)
        local retval = GetServerIdFromIdentifier(identifier)
        if retval ~= nil then
            TriggerClientEvent("SevenLife:Admin:TPPlayer", retval, coords)
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                retval,
                "Admin",
                "Du wurdest von einem Administrator teleportiert",
                3000
            )
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Admin",
                "Spieler wurde erfolgreich teleportiert!",
                3000
            )
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                retval,
                "Admin",
                "Spieler ist momentan nicht Online",
                3000
            )
        end
    end
)
RegisterServerEvent("SevenLife:Admin:tpzumspieler")
AddEventHandler(
    "SevenLife:Admin:tpzumspieler",
    function(identifier)
        local _source = source
        local retval = GetServerIdFromIdentifier(identifier)
        if retval ~= nil then
            TriggerClientEvent("SevenLife:Admin:GetCoords", retval, identifier, _source)
        end
    end
)
RegisterServerEvent("SevenLife:Admin:Tpzumspieleradmin")
AddEventHandler(
    "SevenLife:Admin:Tpzumspieleradmin",
    function(coords, identifier, source)
        local retval = GetServerIdFromIdentifier(identifier)
        if retval ~= nil then
            TriggerClientEvent("SevenLife:Admin:TPPlayers", source, coords)
        end
    end
)
local playerindex = {}
local playerindes
ESX.RegisterServerCallback(
    "SevenLife:Admin:GetPlayers",
    function(source, cb)
        playerindex = {}
        for k, v in pairs(GetPlayers()) do
            local id = tonumber(v)
            local name = GetPlayerName(id)
            local identifier = GetIdentifier(id)
            playerindes = {
                id = id,
                name = name,
                identifier = identifier
            }
            table.insert(playerindex, playerindes)
        end
        cb(playerindex)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Admin:GetInfosAboutPlayer",
    function(source, cb, identifier)
        print(identifier)
        local retval = GetServerIdFromIdentifier(identifier)
        local steamid = false
        local license = false
        local discord = false
        local xbl = false
        local liveid = false
        local notiz = ""
        local ip = false
        local playtime =
            MySQL.Sync.fetchAll(
            "SELECT Minutes, Hours, Days FROM times WHERE identifier = @identifer",
            {
                ["@identifer"] = identifier
            }
        )
        local notizen =
            MySQL.Sync.fetchAll(
            "SELECT * FROM notizenspieler WHERE identifier = @identifer",
            {
                ["@identifer"] = identifier
            }
        )
        local users =
            MySQL.Sync.fetchAll(
            "SELECT warns, kills, deaths FROM users WHERE identifier = @identifer",
            {
                ["@identifer"] = identifier
            }
        )
        for k, v in pairs(GetPlayerIdentifiers(source)) do
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
                steamid = v
            elseif string.sub(v, 1, string.len("license:")) == "license:" then
                license = v
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                xbl = v
            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                ip = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                discord = v
            elseif string.sub(v, 1, string.len("live:")) == "live:" then
                liveid = v
            end
        end
        if notizen[1] ~= nil then
            notiz = notizen[1].notiz
        end
        cb(playtime, steamid, license, discord, xbl, liveid, notiz, users[1].warns, users[1].kills, users[1].deaths)
    end
)
RegisterServerEvent("SevenLife:Admin:GiveVerwahrnungspieler")
AddEventHandler(
    "SevenLife:Admin:GiveVerwahrnungspieler",
    function(identifier)
        local retval = GetServerIdFromIdentifier(identifier)
        local warns =
            MySQL.Sync.fetchAll(
            "SELECT warns FROM users WHERE identifier = @identifer",
            {
                ["@identifer"] = identifier
            },
            function()
            end
        )
        warns = warns[1].warns + 1
        MySQL.Async.execute(
            "UPDATE users SET warns = @warns WHERE identifier=@identifier",
            {
                ["@identifier"] = identifier,
                ["@warns"] = warns
            }
        )
        TriggerClientEvent("SevenLife:Admin:Verwahrnung", retval)
    end
)
RegisterServerEvent("SevenLife:Admin:KickPlayer")
AddEventHandler(
    "SevenLife:Admin:KickPlayer",
    function(identifier)
        local retval = GetServerIdFromIdentifier(identifier)
        DropPlayer(retval, "Du wurdest gekickt von einem Administrator gekickt. [Admin Name]: ", GetPlayerName(source))
    end
)
RegisterServerEvent("SevenLife:Admin:HeilPlayer")
AddEventHandler(
    "SevenLife:Admin:HeilPlayer",
    function(identifier)
        local retval = GetServerIdFromIdentifier(identifier)
        TriggerClientEvent("SevenLife:Admin:HeilPlayer", retval)
        TriggerClientEvent("SevenLife:Admin:HealdAndMove", retval)
    end
)
RegisterServerEvent("SevenLife:Admin:Zuschauen")
AddEventHandler(
    "SevenLife:Admin:Zuschauen",
    function(identifier)
        local identifierplayer = ESX.GetPlayerFromId(source).identifier
        local retval = GetServerIdFromIdentifier(identifier)
        local id = GetServerIdFromIdentifier(identifierplayer)
        TriggerClientEvent("SevenLife:Admin:ZuschauenClient", retval, identifier, id)
    end
)
RegisterServerEvent("SevenLife:Admin:ZuschauenKommite")
AddEventHandler(
    "SevenLife:Admin:ZuschauenKommite",
    function(identifier, id, targetped)
        local retval = GetServerIdFromIdentifier(identifier)

        TriggerClientEvent("SevenLife:Admin:Zuschauen", id, targetped)
    end
)
RegisterServerEvent("SevenLife:Admin:crash")
AddEventHandler(
    "SevenLife:Admin:crash",
    function(identifier)
        if IsPlayerAceAllowed(source, "admin") then
            local retval = GetServerIdFromIdentifier(identifier)
            TriggerClientEvent("SevenLife:Admin:crash", retval)
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Admin",
                "Dein Team Rank ist zu weit unten um diese Aktion auszuführen",
                3000
            )
        end
    end
)
RegisterServerEvent("SevenLife:Admin:anzünden")
AddEventHandler(
    "SevenLife:Admin:anzünden",
    function(identifier)
        if IsPlayerAceAllowed(source, "admin") then
            local retval = GetServerIdFromIdentifier(identifier)
            TriggerClientEvent("SevenLife:Admin:anzünden", retval)
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Admin",
                "Dein Team Rank ist zu weit unten um diese Aktion auszuführen",
                3000
            )
        end
    end
)
RegisterServerEvent("SevenLife:Admin:betrunkenmachen")
AddEventHandler(
    "SevenLife:Admin:betrunkenmachen",
    function(identifier)
        if IsPlayerAceAllowed(source, "admin") then
            local retval = GetServerIdFromIdentifier(identifier)
            TriggerClientEvent("SevenLife:Admin:betrunkenmachen", retval)
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Admin",
                "Dein Team Rank ist zu weit unten um diese Aktion auszuführen",
                3000
            )
        end
    end
)
RegisterServerEvent("SevenLife:Admin:InsertNotiz")
AddEventHandler(
    "SevenLife:Admin:InsertNotiz",
    function(insert, identifier)
        local _source = source

        MySQL.Async.fetchAll(
            "SELECT notiz, id FROM notizenspieler WHERE identifier = @identifer",
            {
                ["@identifer"] = identifier
            },
            function(result)
                if result[1] ~= nil then
                    MySQL.Async.execute(
                        "UPDATE notizenspieler SET notiz = @notiz WHERE id=@id",
                        {
                            ["@id"] = insert
                        }
                    )
                else
                    MySQL.Async.execute(
                        "INSERT INTO notizenspieler (identifier, notiz) VALUES (@identifier, @notiz)",
                        {
                            ["@identifier"] = identifier,
                            ["@notiz"] = insert
                        },
                        function()
                        end
                    )
                end
            end
        )
    end
)
RegisterServerEvent("SevenLife:Admin:BannServer")
AddEventHandler(
    "SevenLife:Admin:BannServer",
    function(identifier, grund, leange)
        local retval = GetServerIdFromIdentifier(identifier)
        local id = tostring(retval)
        TriggerClientEvent("SevenLife:Admin:BannTransfer", source, id, grund, leange)
    end
)
RegisterServerEvent("SevenLife:Admin:MakeAnnounce")
AddEventHandler(
    "SevenLife:Admin:MakeAnnounce",
    function(announce, detail, id)
        if id ~= nil then
            TriggerClientEvent("sevenlife:announcehandler", id, announce, detail)
        end
    end
)
RegisterServerEvent("SevenLife:Admin:ChangePedServer")
AddEventHandler(
    "SevenLife:Admin:ChangePedServer",
    function(name, id)
        if id ~= nil then
            TriggerClientEvent("SevenLife:Admin:ChangePedClient", id, name)
        else
            TriggerClientEvent("SevenLife:Admin:ChangePedClient", source, name)
        end
    end
)

RegisterServerEvent("SevenLife:Admin:SendenGeld")
AddEventHandler(
    "SevenLife:Admin:SendenGeld",
    function(name, id)
        local name = tonumber(name)
        local id = tonumber(id)
        local xPlayer = ESX.GetPlayerFromId(id)
        xPlayer.addAccountMoney("money", name)
    end
)
RegisterServerEvent("SevenLife:Admin:GeldSetzen")
AddEventHandler(
    "SevenLife:Admin:GeldSetzen",
    function(name, id)
        local name = tonumber(name)
        local id = tonumber(id)
        local xPlayer = ESX.GetPlayerFromId(id)
        xPlayer.setAccountMoney("money", name)
    end
)
RegisterServerEvent("SevenLife:Admin:GeldNehmen")
AddEventHandler(
    "SevenLife:Admin:GeldNehmen",
    function(name, id)
        local name = tonumber(name)
        local id = tonumber(id)
        local xPlayer = ESX.GetPlayerFromId(id)
        xPlayer.removeAccountMoney("money", name)
    end
)
RegisterServerEvent("SevenLife:Admin:WeaponGeben")
AddEventHandler(
    "SevenLife:Admin:WeaponGeben",
    function(name, id)
        local number = tonumber(id)

        local xPlayer = ESX.GetPlayerFromId(number)
        xPlayer.addWeapon(name, 999)
    end
)
RegisterServerEvent("SevenLife:Admin:ResetWaffen")
AddEventHandler(
    "SevenLife:Admin:ResetWaffen",
    function(id)
        local number = tonumber(id)
        local xPlayer = ESX.GetPlayerFromId(number)

        local weapons = xPlayer.getLoadout()
        for k, v in ipairs(weapons) do
            xPlayer.removeWeapon(v.name)
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Admin:GetInformationen",
    function(source, cb)
        local _source = source
        local activeusers = 0
        local adminse = {}
        local warns = 0
        local hour = 0
        local day = 0
        local ticketsactiv = 0
        local Bans = 0
        local players = ESX.GetPlayers()
        local admins = 0
        local users =
            MySQL.Sync.fetchAll(
            "SELECT name, warns FROM users ",
            {},
            function(result)
            end
        )
        local times =
            MySQL.Sync.fetchAll(
            "SELECT Days, Hours FROM times ",
            {},
            function(result)
            end
        )
        local banlist =
            MySQL.Sync.fetchAll(
            "SELECT license FROM banlist ",
            {},
            function(result)
            end
        )
        local tickets =
            MySQL.Sync.fetchAll(
            "SELECT about FROM reports ",
            {},
            function(result)
            end
        )
        for k, v in pairs(users) do
            activeusers = activeusers + 1
        end
        for k, v in pairs(users) do
            warns = warns + tonumber(v.warns)
        end
        for k, v in pairs(times) do
            hour = hour + tonumber(v.Hours)
            day = day + tonumber(v.Days)
            if hour >= 24 then
                hour = hour - 24
                day = day + 1
            end
        end
        for k, v in pairs(banlist) do
            Bans = Bans + 1
        end
        for k, v in pairs(tickets) do
            ticketsactiv = ticketsactiv + 1
        end
        for i = 1, #players do
            admins = admins + 1
            table.insert(adminse, GetPlayerName(players[i]))
        end
        cb(activeusers, adminse, warns, hour, day, Bans, admins, ticketsactiv)
    end
)
RegisterServerEvent("SevenLife:Admin:UpdateEinstellung")
AddEventHandler(
    "SevenLife:Admin:UpdateEinstellung",
    function(einstellung, marked)
        local _source = source
        local identifier = ESX.GetPlayerFromId(source).identifier
        if einstellung == 1 then
            MySQL.Async.fetchAll(
                "SELECT identifier FROM einstellungenadmins WHERE identifier = @identifer",
                {
                    ["@identifer"] = identifier
                },
                function(result)
                    if result[1] ~= nil then
                        MySQL.Async.execute(
                            "UPDATE einstellungenadmins SET chataktiv = @chataktiv  WHERE identifier=@identifier",
                            {
                                ["@identifier"] = identifier,
                                ["@chataktiv"] = marked
                            }
                        )
                    else
                        MySQL.Async.execute(
                            "INSERT INTO einstellungenadmins (identifier, chataktiv) VALUES (@identifier, @chataktiv)",
                            {
                                ["@identifier"] = identifier,
                                ["@chataktiv"] = marked
                            },
                            function()
                            end
                        )
                    end
                end
            )
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Admin:GetOptionen",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT chataktiv FROM einstellungenadmins WHERE identifier = @identifer",
            {
                ["@identifer"] = identifier
            },
            function(result)
                if result[1] ~= nil then
                    cb(result[1].chataktiv)
                else
                    cb(false)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Admin:GetItems",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local perms =
            MySQL.Sync.fetchAll(
            "SELECT statuse FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        local items = MySQL.Sync.fetchAll("SELECT * FROM items ")
        if perms[1].statuse == "Owner" then
            cb(true, items)
        else
            cb(false, items)
        end
    end
)
RegisterServerEvent("SevenLife:Admin:GiveItem")
AddEventHandler(
    "SevenLife:Admin:GiveItem",
    function(name, label)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem(name, 1)
        TriggerClientEvent(
            "SevenLife:TimetCustom:Notify",
            source,
            "Admin",
            "Du hast dir ein " .. label .. " gegeben!",
            3000
        )
    end
)
