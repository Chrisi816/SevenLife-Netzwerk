local inmenu
local activatereward = false
local minutese = 0
ESX = nil
Citizen.CreateThread(
    function()
        while not ESX do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(100)
        end
        Citizen.Wait(2000)
        ESX.TriggerServerCallback(
            "SevenLife:Player:GetConnectedPlayers",
            function(connectedPlayers, maxPlayers)
                UpdatePlayerTable(connectedPlayers)

                SendNUIMessage(
                    {
                        action = "updateServerInfo",
                        maxPlayers = maxPlayers,
                        uptime = "unknown",
                        playTime = "00h 00m"
                    }
                )
            end
        )

        while true do
            Citizen.Wait(60000)
            minutese = minutese + 1
            if minutese >= 60 then
                activatereward = true
            else
                activatereward = false
            end
        end
    end
)
local zeit
RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        PlayerData = xPlayer
        TriggerEvent("SevenLife:GetDetails:MakeRound")

        TriggerServerEvent("SevenLife:MainMenu:Identifier")

        ESX.TriggerServerCallback(
            "SevenLife:MainMenu:GetData",
            function(actualltime)
                zeit = actualltime
            end
        )
    end
)
local number = 60
RegisterNetEvent("SevenLife:GetDetails:MakeRound")
AddEventHandler(
    "SevenLife:GetDetails:MakeRound",
    function()
        Citizen.CreateThread(
            function()
                while true do
                    Citizen.Wait(60000)
                    if number > 1 then
                        number = number - 1
                        TriggerServerEvent("SevenLife:MainMenu:SaveTime", number)
                    else
                        TriggerEvent("SevenLife:GetDetail:AddBelohnung")
                    end
                end
            end
        )
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(job)
        PlayerData.job = job
    end
)

local stufe
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(2)
            if IsControlJustPressed(0, 170) then
                ESX.TriggerServerCallback(
                    "SevenLife:MainMenu:GetInfosFirstSite",
                    function(result, result1, id, onlineplayer)
                        for k, v in pairs(Config.levels) do
                            if result[1].visastufe == v.level then
                                stufe = result[1].visaxp / v.xp * 100
                            end
                        end
                        TriggerEvent("SevenLife:OpenIt:remove")
                        inmenu = true
                        TriggerEvent("SevenLife:Start:removeHUD")
                        DisableMini()
                        SetNuiFocus(true, true)
                        jobgrade = PlayerData.job.grade_name
                        if result[1].job == "Unemployed" then
                            JobVisual = "Arbeitslos"
                        else
                            JobVisual = result[1].job
                        end
                        local level, xp, skillpoints = 0, 0, 0
                        if result[1].level ~= nil then
                            level = result[1].level
                        end
                        if result[1].xp ~= nil then
                            xp = result[1].xp
                        end
                        if result[1].skillpoints ~= nil then
                            skillpoints = result[1].skillpoints
                        end
                        SendNUIMessage(
                            {
                                type = "OpenMainNUI",
                                warns = result[1].warns,
                                status = result[1].statuse,
                                vip = result[1].vip,
                                visastufe = result[1].visastufe,
                                visaprozent = stufe,
                                name = result[1].name,
                                job = JobVisual,
                                orga = result[1].orga,
                                jobgrade = jobgrade,
                                wohnort = result[1].wohnort,
                                level = level,
                                xp = xp,
                                points = skillpoints,
                                number = number,
                                id = GetPlayerServerId(PlayerId()),
                                onlineplayer = onlineplayer,
                                zeit = zeit
                            }
                        )
                    end
                )
            end
        end
    end
)

RegisterNUICallback(
    "CloseMenu",
    function()
        inmenu = false
        TriggerEvent("SevenLife:OpenIt:Right")
        TriggerEvent("SevenLife:Start:OpenHud")
        SetNuiFocus(false, false)

        Citizen.Wait(20)
        DisplayRadar(true)
    end
)

function DisableMini()
    Citizen.CreateThread(
        function()
            while inmenu do
                Citizen.Wait(2)
                DisplayRadar(false)
            end
        end
    )
end

RegisterNUICallback(
    "GetDataSpieler",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:MainMenu:ShowPlayers",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenMenuPlayer",
                        players = result
                    }
                )
            end
        )
    end
)

function DrawText3D(position, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(position.x, position.y, position.z + 1)
    local dist = #(GetGameplayCamCoords() - position)

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.35 * scale)

        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

RegisterNUICallback(
    "MakeBugTicket",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local status = "Bearbeitung"
        local typeofticket = "Bug"
        LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        local LastPosH = GetEntityHeading(GetPlayerPed(-1))
        local lastpos = "{" .. LastPosX .. ", " .. LastPosY .. ",  " .. LastPosZ .. ", " .. LastPosH .. "}"
        TriggerServerEvent("SevenLife:MainMenu:MakeTickeDC", coords, data.titel, data.nachricht)
        TriggerServerEvent(
            "SevenLife:MainMenu:MakeTicketMySQL",
            lastpos,
            data.titel,
            data.nachricht,
            status,
            typeofticket
        )
    end
)

RegisterNUICallback(
    "MakeFrageTicket",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local status = "Bearbeitung"
        local typeofticket = "Frage"
        LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        local LastPosH = GetEntityHeading(GetPlayerPed(-1))
        local lastpos = "{" .. LastPosX .. ", " .. LastPosY .. ",  " .. LastPosZ .. ", " .. LastPosH .. "}"
        TriggerServerEvent("SevenLife:MainMenu:MakeTickeDC", coords, data.titel, data.nachricht)

        TriggerServerEvent(
            "SevenLife:MainMenu:MakeTicketMySQL",
            lastpos,
            data.titel,
            data.nachricht,
            status,
            typeofticket
        )
    end
)

RegisterNUICallback(
    "MakeMeldeTicket",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        local LastPosH = GetEntityHeading(GetPlayerPed(-1))
        local lastpos = "{" .. LastPosX .. ", " .. LastPosY .. ",  " .. LastPosZ .. ", " .. LastPosH .. "}"
        local status = "Bearbeitung"
        local typeofticket = "Ticket"
        TriggerServerEvent("SevenLife:MainMenu:MakeTickeDC", coords, data.titel, data.nachricht)
        TriggerServerEvent(
            "SevenLife:MainMenu:MakeTicketMySQL",
            lastpos,
            data.titel,
            data.nachricht,
            status,
            typeofticket
        )
    end
)

RegisterNUICallback(
    "GetStats",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:MainMenu:GetStats",
            function(result)
                ESX.TriggerServerCallback(
                    "SevenLife:MainMenu:GetHour",
                    function(resulstiem)
                        SendNUIMessage(
                            {
                                type = "OpenStats",
                                name = result[1].name,
                                kills = result[1].kills,
                                toder = result[1].deaths,
                                datumerstellen = result[1].datumerstellen,
                                min = resulstiem[1].Minutes,
                                h = resulstiem[1].Hours,
                                Days = resulstiem[1].Days,
                                kd = math.round(result[1].kills / result[1].deaths, 2)
                            }
                        )
                    end
                )
            end
        )
    end
)
function math.round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces > 0 then
        local mult = 10 ^ numDecimalPlaces
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

function round(a, b)
    math.round(a, b)
end

local seconds = 0
local minutes = 0
local hours = 0
local days = 0
local timechecked = false
local count = 0
Citizen.CreateThread(
    function()
        Citizen.Wait(5000)
        while true do
            Citizen.Wait(1)
            TriggerServerEvent("SevenLife:TimeTracker:GetTime")
            if timechecked then
                break
            end
        end
    end
)

RegisterNetEvent("SevenLife:TrackTime:SendDATA")
AddEventHandler(
    "SevenLife:TrackTime:SendDATA",
    function(s, m, h, d)
        seconds = s
        minutes = m
        hours = h
        days = d
        timechecked = true
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)
            if timechecked == true then
                count = count + 1
                seconds = seconds + 1
                if seconds == 60 then
                    seconds = 0
                    minutes = minutes + 1
                    if minutes == 60 then
                        minutes = 0
                        hours = hours + 1
                        if hours == 24 then
                            hours = 0
                            days = days + 1
                        end
                    end
                end
            end
            TriggerServerEvent("SevenLife:MainMenu:savetime", seconds, minutes, hours, days)
            if count == 60 then
                TriggerServerEvent("SevenLife:MainMenu:savetimedb", seconds, minutes, hours, days)
                count = 0
            end
        end
    end
)

RegisterNUICallback(
    "MakeTicketsAppear",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:MainMenu:GetTicket",
            function(resulstiem)
                SendNUIMessage(
                    {
                        type = "DisplayTickets",
                        ticket = resulstiem
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "DeleteTicket",
    function(data)
        TriggerServerEvent("SevenLife:MainMenu:DeleteTicket", data.id)
    end
)

RegisterNUICallback(
    "ShowDetails",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:MainMenu:GetTicketDetails",
            function(resulstiem, ticketdetails)
                SendNUIMessage(
                    {
                        type = "DisplayTicketDetail",
                        tickets = resulstiem,
                        ticketdetails = ticketdetails
                    }
                )
            end,
            data.id
        )
    end
)

local showPlayerId, isScoreboardActive = true, false

RegisterNUICallback(
    "GetDataOnlinePlayers",
    function()
        TriggerServerEvent("SevenLife:OnlinePlayer:GetData")
    end
)

RegisterNetEvent("SevenLife:OnlinePlayer:UpdateConnectedPlayers")
AddEventHandler(
    "SevenLife:OnlinePlayer:UpdateConnectedPlayers",
    function(connectedPlayers)
        UpdatePlayerTable(connectedPlayers)
    end
)

function UpdatePlayerTable(connectedPlayers)
    local formattedPlayerList = connectedPlayers
    local ems, police, taxi, mechanic, cardealer, estate, players = 0, 0, 0, 0, 0, 0, 0

    for k, v in pairs(formattedPlayerList) do
        players = players + 1

        if v.job == "ambulance" then
            ems = ems + 1
        elseif v.job == "police" then
            police = police + 1
        elseif v.job == "taxi" then
            taxi = taxi + 1
        elseif v.job == "mechanic" then
            mechanic = mechanic + 1
        elseif v.job == "cardealer" then
            cardealer = cardealer + 1
        elseif v.job == "realestateagent" then
            estate = estate + 1
        end
    end

    SendNUIMessage(
        {
            type = "UpdatePlayerList",
            players = formattedPlayerList
        }
    )

    SendNUIMessage(
        {
            type = "UpdateJobs",
            jobs = {
                ems = ems,
                police = police,
                taxi = taxi,
                mechanic = mechanic,
                cardealer = cardealer,
                estate = estate,
                player_count = players
            }
        }
    )
end
RegisterNUICallback(
    "MakeCode",
    function(data)
        TriggerServerEvent("SevenLife:MainMenu:MakeCode", data.value)
    end
)
RegisterNUICallback(
    "MakeCreatorCode",
    function(data)
        TriggerServerEvent("SevenLife:MainMenu:MakeCreatorCode", data.value)
    end
)
RegisterNUICallback(
    "MakeNachricht",
    function(data)
        TriggerServerEvent("SevenLife:MainMenu:MakeNachricht", data.inputting, data.id)
    end
)
RegisterNetEvent("SevenLife:MainMenu:UpdateTicketChat")
AddEventHandler(
    "SevenLife:MainMenu:UpdateTicketChat",
    function(result)
        SendNUIMessage(
            {
                type = "UpdateChat",
                result = result
            }
        )
    end
)
RegisterNetEvent("SevenLife:Admin:UpdateListOfTicket")
AddEventHandler(
    "SevenLife:Admin:UpdateListOfTicket",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:MainMenu:GetTicket",
            function(resulstiem)
                SendNUIMessage(
                    {
                        type = "UpdateTicket",
                        ticket = resulstiem
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "GetDataSeasonPass",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:MainMenu:GetSeasonPassData",
            function(result, apply)
                SendNUIMessage(
                    {
                        type = "OpenBattlePass",
                        coins = result[1].coinsbattlepass,
                        level = result[1].levelbattlepass,
                        result = result,
                        days = days,
                        normal = Config.SeasonPass.normal,
                        premium = Config.SeasonPass.premiums
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "GiveCoins",
    function()
        if activatereward then
            minutes = 0
            TriggerServerEvent("SevenLife:Phone:GiveCoins", 10)
        else
            TriggerEvent(
                "SevenLife:TimetCustom:Notify",
                "MainMenu",
                "Du musst noch " .. 60 - minutese .. " Minuten warten",
                3000
            )
        end
    end
)
RegisterNetEvent("SevenLife:Phone:UpdateCoins")
AddEventHandler(
    "SevenLife:Phone:UpdateCoins",
    function(coins, level)
        SendNUIMessage(
            {
                type = "UpdateCoins",
                coins = coins,
                level = level
            }
        )
    end
)
local bearbeite = false
RegisterNUICallback(
    "ValideOption",
    function(data)
        if not bearbeite then
            bearbeite = true
            TriggerServerEvent(
                "SevenLife:Phone:ValideData",
                data.index,
                data.types,
                data.label,
                data.amount,
                data.normal
            )
        end
    end
)
RegisterNetEvent("SevenLife:Phone:UpdateState")
AddEventHandler(
    "SevenLife:Phone:UpdateState",
    function()
        bearbeite = false
    end
)
