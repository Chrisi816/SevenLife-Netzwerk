-- Variablesr
local times = 100
local mistimes = 1000
local inareas = false
local inmarkers = false
local notifyss = true
local timess = 100
local inmarkerss = false
local notifysss = true
-- ESX

ESX = nil
Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(1000)
        end
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
-- Function for Init the Outside

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            Coords = GetEntityCoords(Ped)
            Citizen.Wait(times)
            local distance =
                GetDistanceBetweenCoords(Coords, Config.MailGarage.x, Config.MailGarage.y, Config.MailGarage.z, true)
            if distance < 10 then
                times = 15
                inareas = true
                if distance < 1.6 then
                    times = 5
                    inmarkers = true
                    if notifyss then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um das Post office zu verlassen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.7 and distance <= 8 then
                        inmarkers = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                if distance >= 8 and distance <= 12 then
                    times = 100
                    inareas = false
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(5)

            if inmarkers then
                if IsControlJustPressed(0, 38) then
                    inmarkers = false
                    notifyss = false

                    RequestCollisionAtCoord(Config.Mailspot.x, Config.Mailspot.y, Config.Mailspot.z)
                    FreezeEntityPosition(Ped, true)
                    SetEntityCoords(
                        Ped,
                        Config.Mailspot.x,
                        Config.Mailspot.y,
                        Config.Mailspot.z,
                        false,
                        false,
                        false,
                        false
                    )
                    Citizen.Wait(10)
                    while not HasCollisionLoadedAroundEntity(Ped) do
                        Citizen.Wait(0)
                    end
                    FreezeEntityPosition(Ped, false)
                    TriggerEvent("sevenliferp:closenotify", false)
                    notifyss = true
                    inmarkers = false
                end
            else
                Citizen.Wait(100)
            end
        end
    end
)

-- Coord and Ped
local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_m_skater_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance = GetDistanceBetweenCoords(PlayerCoord, Config.Ped.x, Config.Ped.y, Config.Ped.z, true)

            Citizen.Wait(1000)
            pedarea = false
            if distance < 20 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped1 = CreatePed(4, ped, Config.Ped.x, Config.Ped.y, Config.Ped.z, Config.Ped.heading, false, true)
                    SetEntityInvincible(ped1, true)
                    FreezeEntityPosition(ped1, true)
                    SetBlockingOfNonTemporaryEvents(ped1, true)
                    pedloaded = true
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped1)
                SetModelAsNoLongerNeeded(ped)
                pedloaded = false
            end
        end
    end
)

-- Marker

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(mistimes)
            if inareas then
                mistimes = 1
                DrawMarker(
                    Config.MarkerType,
                    Config.MailGarage.x,
                    Config.MailGarage.y,
                    Config.MailGarage.z,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    Config.MarkerSize,
                    Config.MarkerColor.r,
                    Config.MarkerColor.g,
                    Config.MarkerColor.b,
                    100,
                    false,
                    true,
                    2,
                    false,
                    nil,
                    nil,
                    false
                )
            else
                mistimes = 1000
            end
        end
    end
)

--- Hermano
Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            Coords = GetEntityCoords(Ped)
            Citizen.Wait(timess)
            local distance = GetDistanceBetweenCoords(Coords, Config.Ped.x, Config.Ped.y, Config.Ped.z, true)
            if distance < 10 then
                timess = 25
                if distance < 2 then
                    timess = 5
                    inmarkerss = true
                    if notifysss then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um mit Hermes zu Reden",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.1 and distance <= 5 then
                        inmarkerss = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                if distance >= 8 and distance <= 12 then
                    timess = 100
                end
            end
        end
    end
)

local endmails = {}
local numberofmail
local number = 0
Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(5)
            if inmarkerss then
                if IsControlJustPressed(0, 38) then
                    ESX.TriggerServerCallback(
                        "SevenLife:GetMails",
                        function(mails)
                            SetNuiFocus(true, true)
                            notifysss = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            inmarkerss = false
                            for v, k in pairs(mails) do
                                table.insert(endmails, mails[v])
                                number = number + 1
                            end
                            SendNUIMessage(
                                {
                                    type = "openmailoffice",
                                    mails = endmails,
                                    numberofmail = number
                                }
                            )
                        end
                    )
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

RegisterNUICallback(
    "CloseMenu",
    function()
        number = 0
        SetNuiFocus(false, false)
        endmails = {}
        inmarkerss = false
        notifysss = true
    end
)

RegisterNUICallback(
    "giveitem",
    function(data)
        number = 0
        endmails = {}
        TriggerServerEvent("SevenLife:Bote:Giveitem", data.item, data.number, data.name, data.toid, data.id)
    end
)

RegisterNetEvent("SevenLife:Postal:AddPost")
AddEventHandler(
    "SevenLife:Postal:AddPost",
    function(name, item, number)
        local id = GetID()
        TriggerEvent("SevenLife:TimetCustom:Notify", "Post", "Du hast neue Post bekommen", 3000)
        TriggerServerEvent("SevenLife:addPost", name, item, number, id)
    end
)
function GetID()
    local MakePlate
    local doBreak = false

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())

        MakePlate = string.upper(GetRandomLetter(10) .. GetRandomNumber(10))

        ESX.TriggerServerCallback(
            "sevenlife:idtaken",
            function(isPlateTaken)
                if not isPlateTaken then
                    doBreak = true
                end
            end,
            MakePlate
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

function GetRandomLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ""
    end
end
