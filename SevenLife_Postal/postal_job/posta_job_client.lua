ESX = nil
local times = 100
local active = false
local inmarkers = false
local notifyss = true

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

Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        MakeBlipForPostalJob()
    end
)

-- Blips function

function MakeBlipForPostalJob()
    local blip = AddBlipForCoord(Config.PostVermittler.x, Config.PostVermittler.y, Config.PostVermittler.z)
    SetBlipSprite(blip, 371)
    SetBlipColour(blip, 5)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Post Depot")
    EndTextCommandSetBlipName(blip)
end

local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_m_prolhost_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.PostVermittler.x,
                Config.PostVermittler.y,
                Config.PostVermittler.z,
                true
            )

            Citizen.Wait(1000)
            pedarea = false
            if distance < 20 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped2 =
                        CreatePed(
                        4,
                        ped,
                        Config.PostVermittler.x,
                        Config.PostVermittler.y,
                        Config.PostVermittler.z,
                        Config.PostVermittler.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped2, true)
                    FreezeEntityPosition(ped2, true)
                    SetBlockingOfNonTemporaryEvents(ped2, true)
                    pedloaded = true
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped2)
                SetModelAsNoLongerNeeded(ped)
                pedloaded = false
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            Coords = GetEntityCoords(Ped)
            Citizen.Wait(times)
            local distance =
                GetDistanceBetweenCoords(
                Coords,
                Config.PostVermittler.x,
                Config.PostVermittler.y,
                Config.PostVermittler.z,
                true
            )
            if distance < 10 then
                times = 15
                inareas = true
                if distance < 1.6 then
                    times = 5
                    inmarkers = true
                    if notifyss then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um mit dem Post Chef zu sprechen!",
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
                    notifyss = false
                    TriggerEvent("sevenliferp:closenotify", false)
                    SetNuiFocus(true, true)

                    ESX.TriggerServerCallback(
                        "SevenLife:Postal:CheckJob",
                        function(next)
                            if next then
                                active = true
                                RemoveRadar()

                                EnableCam(GetPlayerPed(-1))
                                SendNUIMessage(
                                    {
                                        type = "OpenMainMenuPostal"
                                    }
                                )
                            else
                                SendNUIMessage(
                                    {
                                        type = "OpenWarnung"
                                    }
                                )
                            end
                        end,
                        args
                    )
                end
            else
                Citizen.Wait(100)
            end
        end
    end
)
RegisterNUICallback(
    "ClosePostal",
    function()
        DisableCam()
        notifyss = true
        active = false
        inmarkers = false
        SetNuiFocus(false, false)
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)
RegisterNUICallback(
    "GivePedJob",
    function()
        TriggerServerEvent("SevenLife:Postal:GiveJobToPlayer")
        Citizen.Wait(50)
        EnableCam(GetPlayerPed(-1))
        RemoveRadar()
        TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Du bist jetzt Postbote!", 2000)
        SendNUIMessage(
            {
                type = "OpenMainMenuPostal"
            }
        )
    end
)
function EnableCam(player)
    local rx = GetEntityRotation(ped2)
    camrot = rx + vector3(0.0, 0.0, 181)
    local px, py, pz = table.unpack(GetEntityCoords(ped2, true))
    local x, y, z = px + GetEntityForwardX(ped2) * 1.2, py + GetEntityForwardY(ped2) * 1.2, pz + 0.52
    local coords = vector3(x, y, z)
    RenderScriptCams(false, true, 500, 1, 0)
    DestroyCam(cam, false)
    if (not DoesCamExist(cam)) then
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, camrot, GetGameplayCamFov())
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 1500, true, true)
    end
    FreezeEntityPosition(player, true)
end

function DisableCam()
    local player = GetPlayerPed(-1)
    RenderScriptCams(false, true, 1500, 1, 0)
    DestroyCam(cam, false)
    FreezeEntityPosition(player, false)

    FreezeEntityPosition(GetPlayerPed(-1), false)
end
function RemoveRadar()
    Citizen.CreateThread(
        function()
            while active do
                Citizen.Wait(1)
                DisplayRadar(false)
                TriggerEvent("sevenlife:removeallhud")
            end
        end
    )
end
local paketes = tonumber(1)
RegisterNUICallback(
    "LetsStartJob",
    function(data)
        SpawnCar()
        DisableCam()

        StartJob()
        if tonumber(data.value) >= 2 and tonumber(data.value) <= 10 then
            paketes = tonumber(data.value)
        end
        Citizen.Wait(300)
        notifyss = true
        active = false
        inmarkers = false
        SetNuiFocus(false, false)
        Citizen.Wait(1000)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Informaton", "Fahre zum markierten Punkt!", 2000)
        DisplayRadar(true)
    end
)
local missionvehicle
function SpawnCar()
    ESX.Game.SpawnVehicle(
        "boxville2",
        vector3(Config.LasterSpawn.x, Config.LasterSpawn.y, Config.LasterSpawn.z),
        Config.LasterSpawn.heading,
        function(vehicle)
            missionvehicle = vehicle
            SetVehicleNumberPlateText(vehicle, "CHRISIBESTDEV")
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
        end
    )
end
local blipjob = nil
function StartJob()
    local random = math.random(1, 35)
    local coordse = Config.Livraisons[random]
    if blipjob ~= nil then
        RemoveBlip(blipjob)
    end
    MakeBlip(coordse.x, coordse.y, coordse.z)
    local started = true
    local notifys = true
    local inmarker = false
    local inmenu = false
    local openshop = false
    local time = 100
    Citizen.CreateThread(
        function()
            Citizen.Wait(100)

            while started do
                local player = GetPlayerPed(-1)
                if openshop == false then
                    Citizen.Wait(time)
                    local coords = GetEntityCoords(player)
                    distance = GetDistanceBetweenCoords(coords, coordse.x, coordse.y, coordse.z, true)
                    if distance < 40 then
                        time = 15
                        allowmarker = true
                        if distance < 2 then
                            time = 5
                            inmarker = true
                            if notifys then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um dein Paket abzugeben",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 2.1 and distance <= 5 then
                                inmarker = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        if distance >= 40.1 and distance <= 60 then
                            allowmarker = false
                        end
                    end
                else
                    Citizen.Wait(2000)
                end
            end
        end
    )

    Citizen.CreateThread(
        function()
            Citizen.Wait(3000)
            while started do
                Citizen.Wait(5)
                if inmarker then
                    if IsControlJustPressed(0, 38) then
                        if inmenu == false then
                            notifys = false
                            started = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            local money = math.random(10, 25)
                            TriggerServerEvent("SevenLife:Post:GiveMoney", money)
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Räuber",
                                "Du hast " .. money .. "$ erhalten!",
                                2000
                            )
                            if paketes > 1 then
                                paketes = paketes - 1
                                StartJob()
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Räuber",
                                    "Fahre zum nächsten Punkt um deine Wahre auszuliefern!",
                                    2000
                                )
                            else
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Räuber",
                                    "Fahre zurück um deinen Laster abzugeben!",
                                    2000
                                )
                                FinishJob()
                            end
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            end
        end
    )

    Citizen.CreateThread(
        function()
            local time = 2000
            while started do
                Citizen.Wait(time)
                if allowmarker then
                    time = 1

                    DrawMarker(
                        Config.MarkerType,
                        coordse.x,
                        coordse.y,
                        coordse.z,
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
                    time = 2000
                end
            end
        end
    )
end

function MakeBlip(x, y, z)
    blipjob = AddBlipForCoord(x, y, z)
    SetBlipSprite(blipjob, 371)
    SetBlipColour(blipjob, 5)
    SetBlipDisplay(blipjob, 4)
    SetBlipScale(blipjob, 0.8)
    SetBlipAsShortRange(blipjob, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Liefer Punkt")
    EndTextCommandSetBlipName(blipjob)
    SetBlipRoute(blipjob, true)
    SetBlipRouteColour(blipjob, 5)
end

function FinishJob()
    local started1 = true
    local notifys = true
    local inmarker = false
    local inmenu = false
    local openshop = false
    local time = 100
    RemoveBlip(blipjob)
    MakeBlip(Config.LasterSpawn.x, Config.LasterSpawn.y, Config.LasterSpawn.z)
    Citizen.CreateThread(
        function()
            Citizen.Wait(100)

            while started1 do
                local player = GetPlayerPed(-1)
                if openshop == false then
                    Citizen.Wait(time)
                    local coords = GetEntityCoords(player)
                    distance =
                        GetDistanceBetweenCoords(
                        coords,
                        Config.LasterSpawn.x,
                        Config.LasterSpawn.y,
                        Config.LasterSpawn.z,
                        true
                    )
                    if distance < 10 then
                        time = 15
                        allowmarker = true
                        if distance < 5 then
                            time = 5
                            inmarker = true
                            if notifys then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um dein Paket abzugeben",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 2.1 and distance <= 5 then
                                inmarker = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        if distance >= 5 and distance <= 10 then
                            allowmarker = false
                        end
                    end
                else
                    Citizen.Wait(2000)
                end
            end
        end
    )

    Citizen.CreateThread(
        function()
            Citizen.Wait(3000)
            while started1 do
                Citizen.Wait(5)
                if inmarker then
                    if inmenu == false then
                        notifys = false
                        started1 = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        DeleteVehicle(missionvehicle)
                        RemoveBlip(blipjob)
                    end
                else
                    Citizen.Wait(1000)
                end
            end
        end
    )

    Citizen.CreateThread(
        function()
            local time = 2000
            while started1 do
                Citizen.Wait(time)
                if allowmarker then
                    time = 1

                    DrawMarker(
                        Config.MarkerType,
                        Config.LasterSpawn.x,
                        Config.LasterSpawn.y,
                        Config.LasterSpawn.z,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        vector3(3.8, 3.8, 2.8),
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
                    time = 2000
                end
            end
        end
    )
end
