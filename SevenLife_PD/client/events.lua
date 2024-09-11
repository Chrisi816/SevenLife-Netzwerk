local actif = false
local actif2 = false
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

--------------------------------------------------------------------------------------------------------------
---------------------------------------------Npc Spawner------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local pedloaded = false
local pedarea = false
local ped = GetHashKey("csb_trafficwarden")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance =
                GetDistanceBetweenCoords(PlayerCoord, Config.Events.x, Config.Events.y, Config.Events.z, true)

            Citizen.Wait(500)

            if distance < 50 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped10 =
                        CreatePed(
                        4,
                        ped,
                        Config.Events.x,
                        Config.Events.y,
                        Config.Events.z,
                        Config.Events.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped10, true)
                    FreezeEntityPosition(ped10, true)
                    SetBlockingOfNonTemporaryEvents(ped10, true)
                    TaskPlayAnim(ped10, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped10)
                SetModelAsNoLongerNeeded(ped10)
                pedloaded = false
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------

local notifys9 = true
local inmarker9 = false
local inmenu9 = false

local timemain1 = 100
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain1)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance = GetDistanceBetweenCoords(coord, Config.Events.x, Config.Events.y, Config.Events.z, true)
            if distance < 15 then
                timemain1 = 15
                if distance < 1.2 then
                    inmarker9 = true
                    if notifys9 then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Event Manager zu öffnen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.2 and distance <= 3 then
                        inmarker9 = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmarker9 then
                if IsControlJustPressed(0, 38) then
                    if inmenu9 == false then
                        if PlayerData.job.grade == 11 or PlayerData.job.grade == 10 then
                            inmenu9 = true
                            local ped = GetPlayerPed(-1)
                            TriggerEvent("sevenliferp:closenotify", false)
                            notifys9 = false
                            SetNuiFocus(true, true)
                            EnableCam(ped)
                            SendNUIMessage(
                                {
                                    type = "OpenEvent"
                                }
                            )
                        else
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Polizei",
                                "Du bist nicht in der Führungsebene",
                                2000
                            )
                        end
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

RegisterNUICallback(
    "events",
    function()
        notactive = false
        OpenMenu = false
        SetNuiFocus(false, false)
        AllowSevenNotify = true
        DisableCam()
        SpawnCar()
        SpawnNPC()
        BlipPDs(Config.ConvoiFirstPunkt.x, Config.ConvoiFirstPunkt.y, Config.ConvoiFirstPunkt.z, "Lizenzen holen")
        TriggerEvent("SevenLife:Convoi:Check")
        Citizen.Wait(100)
        inmarker9 = false
        TriggerServerEvent("SevenLife:PD:MakeNotify")
    end
)
function EnableCam(player)
    local rx = GetEntityRotation(ped10)
    camrot = rx + vector3(0.0, 0.0, 181)
    local px, py, pz = table.unpack(GetEntityCoords(ped10, true))
    local x, y, z = px + GetEntityForwardX(ped10) * 1.2, py + GetEntityForwardY(ped10) * 1.2, pz + 0.52
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
function SpawnCar()
    ESX.Game.SpawnVehicle(
        "RIOT",
        vector3(Config.Polizei.AusParkPunkt.x, Config.Polizei.AusParkPunkt.y, Config.Polizei.AusParkPunkt.z),
        Config.Polizei.AusParkPunkt.heading,
        function(vehicle)
            vehicles = vehicle
            SetVehicleNumberPlateText(vehicle, "Chrisibest")

            local playerPed = PlayerPedId()
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

            Citizen.Wait(100)
            inmenu9 = false
            notifys9 = true
            TriggerEvent("sevenliferp:closenotify", false)
        end
    )
end
function SpawnNPC()
    RequestModel(ped)
    while not HasModelLoaded(ped) do
        Citizen.Wait(1)
    end
    ped11 =
        CreatePed(
        4,
        ped,
        Config.ConvoiFirstPunkt.x,
        Config.ConvoiFirstPunkt.y,
        Config.ConvoiFirstPunkt.z,
        Config.ConvoiFirstPunkt.heading,
        false,
        true
    )
    SetEntityInvincible(ped11, true)
    FreezeEntityPosition(ped11, true)
    SetBlockingOfNonTemporaryEvents(ped11, true)
    TaskPlayAnim(ped11, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
end
function BlipPDs(coordsx, coordsy, coordsz, name)
    ClearAllBlipRoutes()
    local blips = vector3(coordsx, coordsy, coordsz)
    blip5 = AddBlipForCoord(blips)
    SetBlipRoute(blip5, true)
    SetBlipSprite(blip5, 60)
    SetBlipColour(blip5, 63)
    SetBlipDisplay(blip5, 4)
    SetBlipAsShortRange(blip5, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip5)
end
RegisterNetEvent("SevenLife:Convoi:Check")
AddEventHandler(
    "SevenLife:Convoi:Check",
    function()
        actif = true
        local notifys10 = true
        local inmarker10 = false
        local inmenu10 = false
        local timemain1 = 100
        Citizen.CreateThread(
            function()
                while actif do
                    Citizen.Wait(timemain1)
                    local ped = GetPlayerPed(-1)
                    local coord = GetEntityCoords(ped)

                    local distance =
                        GetDistanceBetweenCoords(
                        coord,
                        Config.ConvoiFirstPunkt.x,
                        Config.ConvoiFirstPunkt.y,
                        Config.ConvoiFirstPunkt.z,
                        true
                    )
                    if distance < 15 then
                        timemain1 = 15
                        if distance < 1.2 then
                            inmarker10 = true
                            if notifys10 then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um die Lizenzen zu holen",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 1.2 and distance <= 3 then
                                inmarker10 = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    end
                end
            end
        )

        Citizen.CreateThread(
            function()
                Citizen.Wait(10)
                while actif do
                    Citizen.Wait(5)
                    if inmarker10 then
                        if IsControlJustPressed(0, 38) then
                            if inmenu10 == false then
                                if PlayerData.job.grade == 11 or PlayerData.job.grade == 10 then
                                    notifys10 = false
                                    inmarker10 = false
                                    inmenu10 = false
                                    RemoveBlip(blip5)
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    SendNUIMessage(
                                        {
                                            type = "OpenLoadingbar"
                                        }
                                    )
                                    Citizen.Wait(60000)
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Polizei",
                                        "Du hast die Lizenzen erhalten, fahre zum AbgabeOrt",
                                        2000
                                    )
                                    DeletePed(ped11)
                                    SpawnNPC2()
                                    BlipPDs(
                                        Config.ConvoiLiefer.x,
                                        Config.ConvoiLiefer.y,
                                        Config.ConvoiLiefer.z,
                                        "Abgabe"
                                    )
                                    actif = false

                                    Citizen.Wait(1000)
                                    inmarker10 = false
                                    TriggerEvent("SevenLife:Convoi:Check2")

                                    TriggerEvent("sevenliferp:closenotify", false)
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Polizei",
                                        "Du bist nicht in der Führungsebene",
                                        2000
                                    )
                                end
                            end
                        end
                    else
                        Citizen.Wait(1000)
                    end
                end
            end
        )
    end
)
function SpawnNPC2()
    RequestModel(ped)
    while not HasModelLoaded(ped) do
        Citizen.Wait(1)
    end
    ped12 =
        CreatePed(
        4,
        ped,
        Config.ConvoiLiefer.x,
        Config.ConvoiLiefer.y,
        Config.ConvoiLiefer.z,
        Config.ConvoiLiefer.heading,
        false,
        true
    )
    SetEntityInvincible(ped12, true)
    FreezeEntityPosition(ped12, true)
    SetBlockingOfNonTemporaryEvents(ped12, true)
    TaskPlayAnim(ped12, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
end
RegisterNetEvent("SevenLife:Convoi:Check2")
AddEventHandler(
    "SevenLife:Convoi:Check2",
    function()
        actif = true
        local notifys10 = true
        local inmarker10 = false
        local inmenu10 = false
        local timemain1 = 100
        Citizen.CreateThread(
            function()
                while actif do
                    Citizen.Wait(timemain1)
                    local ped = GetPlayerPed(-1)
                    local coord = GetEntityCoords(ped)

                    local distance =
                        GetDistanceBetweenCoords(
                        coord,
                        Config.ConvoiLiefer.x,
                        Config.ConvoiLiefer.y,
                        Config.ConvoiLiefer.z,
                        true
                    )
                    if distance < 15 then
                        timemain1 = 15
                        if distance < 1.2 then
                            inmarker10 = true
                            if notifys10 then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um die Ware abzugeben",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 1.2 and distance <= 3 then
                                inmarker10 = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    end
                end
            end
        )

        Citizen.CreateThread(
            function()
                Citizen.Wait(10)
                while actif do
                    Citizen.Wait(5)
                    if inmarker10 then
                        if IsControlJustPressed(0, 38) then
                            if inmenu10 == false then
                                if PlayerData.job.grade == 11 or PlayerData.job.grade == 10 then
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    notifys10 = false
                                    inmarker10 = false
                                    inmenu10 = false
                                    SendNUIMessage(
                                        {
                                            type = "OpenLoadingbar"
                                        }
                                    )
                                    Citizen.Wait(60000)
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Polizei",
                                        "Du hast alles erfolgreich abgegeben",
                                        2000
                                    )
                                    DeletePed(ped12)
                                    DeleteVehicle(vehicles)
                                    RemoveBlip(blip5)
                                    actif = false
                                    TriggerEvent("sevenliferp:closenotify", false)
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Polizei",
                                        "Du bist nicht in der Führungsebene",
                                        2000
                                    )
                                end
                            end
                        end
                    else
                        Citizen.Wait(1000)
                    end
                end
            end
        )
    end
)
RegisterNUICallback(
    "eventsescape",
    function()
        notifys9 = true
        inmarker9 = false
        inmenu9 = false

        timemain1 = 100
    end
)
