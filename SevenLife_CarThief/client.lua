local pos =
    vector3(Config.locations.auftraggeaber.x, Config.locations.auftraggeaber.y, Config.locations.auftraggeaber.z)
local inmarker = false
local allowednotify = true
local inmenu = false
local poscam = vector3(Config.locations.cam.x, Config.locations.cam.y, Config.locations.cam.z)
local cam = -1
local leicht = false
local mittel = false
local schwer = false
ESX = nil
local nolimit = true
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
        spawnsellernpcnormals()
        Citizen.Wait(2000)

        while true do
            local player = GetPlayerPed(-1)
            Citizen.Wait(250)
            local coords = GetEntityCoords(player)
            local distance = GetDistanceBetweenCoords(coords, pos.x, pos.y, pos.z, true)
            if distance < 3 then
                inmarker = true
                if nolimit then
                    if allowednotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um mit Larry zu reden",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    TriggerEvent(
                        "sevenliferp:startnui",
                        "Larry hat momentan keine weiteren Aufträge",
                        "System - Nachricht",
                        true
                    )
                end
            else
                if distance >= 3.1 and distance <= 7 then
                    inmarker = false
                    TriggerEvent("sevenliferp:closenotify", false)
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        local player = GetPlayerPed(-1)
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    inmenu = true
                    TriggerEvent("sevenliferp:closenotify", false)
                    allowednotify = false
                    enableCam(player)
                    TriggerEvent("sevenlife:nuicalls", "openfahrzeug", true, true)
                end
            else
                Citizen.Wait(1000)
            end
            if inmenu then
                Citizen.Wait(1000)
            end
        end
    end
)

function spawnsellernpcnormals()
    local pednumber = tonumber(1)
    for i = 1, pednumber do
        local NpcSpawner = vector3(pos.x, pos.y, pos.z)
        local ped = GetHashKey("a_m_o_soucent_03")
        if not HasModelLoaded(ped) then
            RequestModel(ped)
            while not HasModelLoaded(ped) do
                Citizen.Wait(1)
            end
            ped1 =
                CreatePed(
                4,
                ped,
                NpcSpawner.x,
                NpcSpawner.y,
                NpcSpawner.z,
                Config.locations.auftraggeaber.heading,
                false,
                true
            )
            SetEntityInvincible(ped1, true)
            FreezeEntityPosition(ped1, true)
            SetBlockingOfNonTemporaryEvents(ped1, true)
        end
    end
end
function enableCam(player)
    local rx = GetEntityRotation(ped1)
    camrot = rx + vector3(0.0, 0.0, 181)
    local px, py, pz = table.unpack(GetEntityCoords(ped1, true))
    local x, y, z = px + GetEntityForwardX(ped1) * 1.2, py + GetEntityForwardY(ped1) * 1.2, pz + 0.52
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
RegisterNetEvent("sevenlife:nuicalls")
AddEventHandler(
    "sevenlife:nuicalls",
    function(event, bool, boolen)
        SetNuiFocus(bool, boolen)
        SendNUIMessage(
            {
                type = event
            }
        )
    end
)
RegisterNUICallback(
    "fahrzeugraus",
    function()
        disableCam()
        allowednotify = true
        inmenu = false
        TriggerEvent("sevenlife:nuicalls", "removefahrzeug", false, false)
    end
)
function disableCam()
    RenderScriptCams(false, true, 500, 1, 0)
    DestroyCam(cam, false)
    FreezeEntityPosition(player, false)

    FreezeEntityPosition(GetPlayerPed(-1), false)
end

RegisterNUICallback(
    "leicht",
    function()
        disableCam()
        leicht = true
        nolimit = false
        TriggerEvent("sevenlife:limit")
        inmenu = false
        TriggerEvent("sevenlife:nuicalls", "removefahrzeug", false, false)
        CreateBlip(Config.locations.leichtecarposeins.x, Config.locations.leichtecarposeins.y, "Ziel", 229, 49)
        Spawncar(
            "oracle",
            Config.locations.leichtecarposeins.x,
            Config.locations.leichtecarposeins.y,
            Config.locations.leichtecarposeins.z,
            Config.locations.leichtecarposeins.heading
        )
        TriggerEvent(
            "sevenlife:opennachricht",
            "openmelde",
            false,
            false,
            "Diebstahl",
            "Fahr zu dem Markierten Punkt, und knacke das auto auf"
        )
        TriggerEvent("sevenlife:checkifinmarker")
        TriggerEvent("sevenlife:markers")
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
        Citizen.Wait(6000)
        TriggerEvent("sevenlife:opennachricht", "removemelde", false, false)
    end
)

function CreateBlip(x, y, name, sprite, color)
    bliplager = AddBlipForCoord(x, y)
    SetBlipSprite(bliplager, sprite)
    SetBlipDisplay(bliplager, 4)
    SetBlipScale(bliplager, 0.8)
    SetBlipColour(bliplager, color)
    SetBlipRoute(bliplager, true)
    SetBlipRouteColour(bliplager, color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(bliplager)
end
RegisterNetEvent("sevenlife:opennachricht")
AddEventHandler(
    "sevenlife:opennachricht",
    function(event, bool, boolen, ueberschrift, nachricht)
        SetNuiFocus(bool, boolen)
        SendNUIMessage(
            {
                type = event,
                ueberschrift = ueberschrift,
                nachricht = nachricht
            }
        )
    end
)
function Spawncar(car, x, y, z, heading)
    local spaen = vector3(x, y, z)
    local player = PlayerPedId()
    ESX.Game.SpawnVehicle(
        car,
        spaen,
        heading,
        function(vehicle)
            vehicles = vehicle
            SetVehicleColours(vehicle, 112, 112)
            SetVehicleNumberPlateText(vehicle, "FORTNITE")
            SetVehicleDoorsLocked(vehicle, 2)
            TriggerEvent("sevenlife:timetnotify", "Du hast 15 Min Zeit")
            Citizen.SetTimeout(
                Config.RentTime,
                function()
                    ESX.Game.DeleteVehicle(vehicle)
                    PlaySoundFrontend(-1, "Crash", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                end
            )

            Citizen.SetTimeout(
                Config.WarningRentTime1,
                function()
                    TriggerEvent("sevenlife:timetnotify", "Fahrzeug läuft in 7 min aus")
                    PlaySoundFrontend(-1, "Crash", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                end
            )

            Citizen.SetTimeout(
                Config.WarningRentTime2,
                function()
                    TriggerEvent("sevenlife:timetnotify", "Fahrzeug läuft in 1 min aus")
                    PlaySoundFrontend(-1, "Crash", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                end
            )
        end
    )
end
local inmarkers = false
local inmenus = false
local allowednotifys = true
local isCarLockpicked = false
local iscar = false
RegisterNetEvent("sevenlife:checkifinmarker")
AddEventHandler(
    "sevenlife:checkifinmarker",
    function()
        Citizen.CreateThread(
            function()
                Citizen.Wait(2000)
                local player = GetPlayerPed(-1)
                while true do
                    Citizen.Wait(250)
                    local coords = GetEntityCoords(player)
                    local hood =
                        GetWorldPositionOfEntityBone(vehicles, GetEntityBoneIndexByName(vehicles, "door_dside_f"))
                    local distance = GetDistanceBetweenCoords(hood, coords, true)
                    if distance < 2 then
                        inmarkers = true
                        if isCarLockpicked == false then
                            if allowednotifys then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um das Schloss auf zu knacken",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        end
                    else
                        if distance >= 2.1 and distance <= 5 then
                            inmarkers = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                    if iscar == false then
                        if isCarLockpicked then
                            if IsPedInVehicle(player, vehicles, false) then
                                RemoveBlip(bliplager)
                                ClearAllBlipRoutes()
                                TriggerEvent(
                                    "sevenlife:opennachricht",
                                    "openmelde",
                                    false,
                                    false,
                                    "Diebstahl",
                                    "Fahr zum Abgabe Ort, und demontiere das Auto"
                                )
                                PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
                                Citizen.Wait(6000)
                                TriggerEvent("sevenlife:opennachricht", "removemelde", false, false)
                                iscar = true
                                CreateBlip(
                                    Config.locations.entnahmehalle.x,
                                    Config.locations.entnahmehalle.y,
                                    "LieferOrt",
                                    402,
                                    49
                                )
                                TriggerEvent("sevenlife:carthiefend")
                                TriggerEvent("sevenlife:carthiefendmarker")
                            end
                        end
                    end
                end
            end
        )
    end
)
RegisterNetEvent("sevenlife:markers")
AddEventHandler(
    "sevenlife:markers",
    function()
        Citizen.CreateThread(
            function()
                Citizen.Wait(3000)
                local player = GetPlayerPed(-1)
                while true do
                    Citizen.Wait(1)
                    if isCarLockpicked == false then
                        if inmarkers then
                            if IsControlJustReleased(0, 38) then
                                Citizen.Wait(100)
                                inmenus = true
                                TriggerEvent("sevenliferp:closenotify", false)
                                allowednotify = false
                                Startlockpicking()
                                TriggerEvent("sevenlive:checkifplayerisincar")
                            end
                        else
                            Citizen.Wait(1000)
                        end
                    end
                end
            end
        )
    end
)
function Startlockpicking()
    local playerPed = GetPlayerPed(-1)
    isCarLockpicked = true
    local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
    local animName = "machinic_loop_mechandplayer"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(50)
    end
    SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
    Citizen.Wait(500)
    FreezeEntityPosition(playerPed, true)
    TaskPlayAnim(playerPed, animDict, animName, 3.0, 1.0, -1, 31, 0, 0, 0)

    SetVehicleAlarm(vehicles, true)
    SetVehicleAlarmTimeLeft(vehicles, (45000))
    StartVehicleAlarm(vehicles)
    Citizen.Wait(7500)
    SetVehicleNeedsToBeHotwired(vehicles, true)
    IsVehicleNeedsToBeHotwired(vehicles)

    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)
    isCarLockpicked = true
    SetVehicleDoorsLocked(vehicles, 1)
end
RegisterNetEvent("sevenlife:limits")
AddEventHandler(
    "sevenlife:limits",
    function()
        Citizen.SetTimeout(
            1800000,
            function()
                nolimit = true
            end
        )
    end
)

RegisterNUICallback(
    "mittel",
    function()
        nolimit = false
        mittel = true
        TriggerEvent("sevenlife:limit")
        disableCam()
        inmenu = false
        TriggerEvent("sevenlife:nuicalls", "removefahrzeug", false, false)
        CreateBlip(Config.locations.mittelpos.x, Config.locations.mittelpos.y, "Ziel", 229, 49)
        Spawncar(
            "oracle",
            Config.locations.mittelpos.x,
            Config.locations.mittelpos.y,
            Config.locations.mittelpos.z,
            Config.locations.mittelpos.heading
        )
        TriggerEvent(
            "sevenlife:opennachricht",
            "openmelde",
            false,
            false,
            "Diebstahl",
            "Fahr zu dem Markierten Punkt, und knacke das auto auf"
        )
        TriggerEvent("sevenlife:checkifinmarkermittel")
        TriggerEvent("sevenlife:markersmittel")
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
        Citizen.Wait(6000)
        TriggerEvent("sevenlife:opennachricht", "removemelde", false, false)
    end
)
RegisterNetEvent("sevenlife:checkifinmarkermittel")
AddEventHandler(
    "sevenlife:checkifinmarkermittel",
    function()
        Citizen.CreateThread(
            function()
                Citizen.Wait(2000)
                local player = GetPlayerPed(-1)
                while true do
                    Citizen.Wait(250)
                    local coords = GetEntityCoords(player)
                    local hood =
                        GetWorldPositionOfEntityBone(vehicles, GetEntityBoneIndexByName(vehicles, "door_dside_f"))
                    local distance = GetDistanceBetweenCoords(hood, coords, true)
                    if distance < 2 then
                        inmarkers = true
                        if isCarLockpicked == false then
                            if allowednotifys then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um das Schloss auf zu knacken",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        end
                    else
                        if distance >= 2.1 and distance <= 5 then
                            inmarkers = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                    if iscar == false then
                        if isCarLockpicked then
                            if IsPedInVehicle(player, vehicles, false) then
                                RemoveBlip(bliplager)
                                ClearAllBlipRoutes()
                                TriggerEvent(
                                    "sevenlife:opennachricht",
                                    "openmelde",
                                    false,
                                    false,
                                    "Diebstahl",
                                    "Fahr zum Abgabe Ort, und demontiere das Auto, Cops kommen in 2 Min"
                                )
                                PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
                                Citizen.Wait(6000)
                                TriggerEvent("sevenlife:opennachricht", "removemelde", false, false)
                                iscar = true
                                CreateBlip(
                                    Config.locations.entnahmehalle.x,
                                    Config.locations.entnahmehalle.y,
                                    "LieferOrt",
                                    402,
                                    49
                                )
                                TriggerEvent("sevenlife:carthiefend")
                                TriggerEvent("sevenlife:carthiefendmarker")
                            end
                        end
                    end
                end
            end
        )
    end
)
RegisterNetEvent("sevenlife:markersmittel")
AddEventHandler(
    "sevenlife:markersmittel",
    function()
        Citizen.CreateThread(
            function()
                Citizen.Wait(3000)
                local player = GetPlayerPed(-1)
                while true do
                    Citizen.Wait(1)
                    if isCarLockpicked == false then
                        if inmarkers then
                            if IsControlJustReleased(0, 38) then
                                Citizen.Wait(100)
                                inmenus = true
                                TriggerEvent("sevenliferp:closenotify", false)
                                allowednotify = false
                                Startlockpicking()
                            end
                        else
                            Citizen.Wait(1000)
                        end
                    end
                end
            end
        )
    end
)
RegisterNetEvent("sevenlife:checkifinmarkerschwer")
AddEventHandler(
    "sevenlife:checkifinmarkerschwer",
    function()
        Citizen.CreateThread(
            function()
                Citizen.Wait(2000)
                local player = GetPlayerPed(-1)
                while true do
                    Citizen.Wait(250)
                    local coords = GetEntityCoords(player)
                    local hood =
                        GetWorldPositionOfEntityBone(vehicles, GetEntityBoneIndexByName(vehicles, "door_dside_f"))
                    local distance = GetDistanceBetweenCoords(hood, coords, true)
                    if distance < 2 then
                        inmarkers = true
                        if isCarLockpicked == false then
                            if allowednotifys then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um das Schloss auf zu knacken",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        end
                    else
                        if distance >= 2.1 and distance <= 5 then
                            inmarkers = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                    if iscar == false then
                        if isCarLockpicked then
                            if IsPedInVehicle(player, vehicles, false) then
                                RemoveBlip(bliplager)
                                ClearAllBlipRoutes()
                                TriggerEvent(
                                    "sevenlife:opennachricht",
                                    "openmelde",
                                    false,
                                    false,
                                    "Diebstahl",
                                    "Fahr zum Abgabe Ort, und demontiere das Auto, Cops kommen in 2 Min"
                                )
                                PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
                                Citizen.Wait(4000)
                                TriggerEvent("sevenlife:opennachricht", "removemelde", false, false)
                                iscar = true
                                CreateBlip(
                                    Config.locations.entnahmehalle.x,
                                    Config.locations.entnahmehalle.y,
                                    "LieferOrt",
                                    402,
                                    49
                                )
                                TriggerEvent("sevenlife:carthiefend")
                                TriggerEvent("sevenlife:carthiefendmarker")
                            end
                        end
                    end
                end
            end
        )
    end
)
RegisterNetEvent("sevenlife:markersschwer")
AddEventHandler(
    "sevenlife:markersschwer",
    function()
        Citizen.CreateThread(
            function()
                Citizen.Wait(3000)
                local player = GetPlayerPed(-1)
                while true do
                    Citizen.Wait(1)
                    if isCarLockpicked == false then
                        if inmarkers then
                            if IsControlJustReleased(0, 38) then
                                Citizen.Wait(100)
                                inmenus = true
                                TriggerEvent("sevenliferp:closenotify", false)
                                allowednotify = false
                                Startlockpicking()
                            end
                        else
                            Citizen.Wait(1000)
                        end
                    end
                end
            end
        )
    end
)
RegisterNUICallback(
    "schwer",
    function()
        disableCam()
        schwer = true
        nolimit = false
        TriggerEvent("sevenlife:limit")
        inmenu = false
        TriggerEvent("sevenlife:nuicalls", "removefahrzeug", false, false)
        CreateBlip(Config.locations.schwerpos.x, Config.locations.schwerpos.y, "Ziel", 229, 49)
        Spawncar(
            "oracle",
            Config.locations.schwerpos.x,
            Config.locations.schwerpos.y,
            Config.locations.schwerpos.z,
            Config.locations.schwerpos.heading
        )
        TriggerEvent(
            "sevenlife:opennachricht",
            "openmelde",
            false,
            false,
            "Diebstahl",
            "Fahr zu dem Markierten Punkt, und knacke das auto auf"
        )
        TriggerEvent("sevenlife:checkifinmarkerschwer")
        TriggerEvent("sevenlife:markersschwer")
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
        Citizen.Wait(4000)
        TriggerEvent("sevenlife:opennachricht", "removemelde", false, false)
    end
)

RegisterNetEvent("sevenlife:carthiefend")
AddEventHandler(
    "sevenlife:carthiefend",
    function()
        inmarkerse = false
        Citizen.CreateThread(
            function()
                Citizen.Wait(2000)
                local player = GetPlayerPed(-1)
                while true do
                    Citizen.Wait(250)
                    local coords = GetEntityCoords(player)
                    local distance =
                        GetDistanceBetweenCoords(
                        coords,
                        Config.locations.entnahmehalle.x,
                        Config.locations.entnahmehalle.y,
                        Config.locations.entnahmehalle.z,
                        true
                    )
                    if distance < 6 then
                        inmarkerse = true

                        if allowednotifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um das Auto zu plazieren",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 6.1 and distance <= 9 then
                            inmarkerse = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                end
            end
        )
    end
)

RegisterNetEvent("sevenlife:carthiefendmarker")
AddEventHandler(
    "sevenlife:carthiefendmarker",
    function()
        local fertig = false
        Citizen.CreateThread(
            function()
                Citizen.Wait(3000)
                local player = GetPlayerPed(-1)
                while fertig == false do
                    Citizen.Wait(1)

                    if inmarkerse then
                        if fertig == false then
                            if IsControlJustReleased(0, 38) then
                                Citizen.Wait(100)
                                TriggerEvent("sevenliferp:closenotify", false)
                                allowednotifys = false
                                SetEntityCoords(
                                    vehicles,
                                    Config.locations.entnahmehalle.x,
                                    Config.locations.entnahmehalle.y,
                                    Config.locations.entnahmehalle.z,
                                    false,
                                    false,
                                    false,
                                    true
                                )
                                TriggerEvent("sevenlife:demoniter")
                                TriggerEvent(
                                    "sevenlife:opennachricht",
                                    "openmelde",
                                    false,
                                    false,
                                    "Diebstahl",
                                    "Steig aus und Demontier das Auto"
                                )
                                PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
                                Citizen.Wait(6000)
                                TriggerEvent("sevenlife:opennachricht", "removemelde", false, false)
                                SetEntityHeading(vehicles, Config.locations.entnahmehalle.heading)
                                fertig = true
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
RegisterNetEvent("sevenlife:demoniter")
AddEventHandler(
    "sevenlife:demoniter",
    function()
        local demontieren = true
        local inactions = false
        local firstdoor = true
        local inactionses = false
        local inactionse = false
        local ped = GetPlayerPed(-1)
        Citizen.CreateThread(
            function()
                local frontdoor =
                    vector3(
                    Config.entnahmnequelle.tueren.x,
                    Config.entnahmnequelle.tueren.y,
                    Config.entnahmnequelle.tueren.z
                )
                local doortwo =
                    vector3(
                    Config.entnahmnequelle.vornezwei.x,
                    Config.entnahmnequelle.vornezwei.y,
                    Config.entnahmnequelle.vornezwei.z
                )
                local hump =
                    vector3(Config.entnahmnequelle.hump.x, Config.entnahmnequelle.hump.y, Config.entnahmnequelle.hump.z)
                while demontieren do
                    Citizen.Wait(1)
                    if firstdoor then
                        DrawText3Ds(frontdoor.x, frontdoor.y, frontdoor.z, "Drücke E um die vordere Tür zu demontieren")
                        if inactions == false then
                            if IsControlJustReleased(0, 38) then
                                inactions = true
                                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, false)
                                Citizen.Wait(8500)
                                ClearPedTasks(ped)
                                Citizen.Wait(500)
                                SetVehicleDoorBroken(vehicles, 0, true)
                                inactions = false
                                firstdoor = false
                                seconddoor = true
                            end
                        end
                    end
                    if seconddoor then
                        DrawText3Ds(doortwo.x, doortwo.y, doortwo.z, "Drücke E um die vordere Tür zu demontieren")
                        if inactionse == false then
                            if IsControlJustReleased(0, 38) then
                                inactionse = true
                                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, false)
                                Citizen.Wait(8500)
                                ClearPedTasks(ped)
                                Citizen.Wait(500)
                                SetVehicleDoorBroken(vehicles, 1, true)
                                inactionse = false
                                seconddoor = false
                                thirddoor = true
                            end
                        end
                    end
                    if thirddoor then
                        DrawText3Ds(hump.x, hump.y, hump.z, "Drücke E um die Motorhaube zu demontieren")
                        if inactionses == false then
                            if IsControlJustReleased(0, 38) then
                                inactionses = true
                                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, false)
                                Citizen.Wait(8500)
                                ClearPedTasks(ped)
                                Citizen.Wait(500)
                                inactionses = false
                                SetVehicleDoorBroken(vehicles, 4, true)
                                seconddoor = false
                                vorne = true
                                TriggerEvent(
                                    "sevenlife:opennachricht",
                                    "openmelde",
                                    false,
                                    false,
                                    "Diebstahl",
                                    "Erfolgreich"
                                )
                                local cash
                                if leicht then
                                    cash = 100
                                else
                                    if mittel then
                                        cash = 250
                                    else
                                        if schwer then
                                            cash = 400
                                        end
                                    end
                                end
                                PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
                                Citizen.Wait(6000)
                                RemoveBlip(bliplager)
                                ClearAllBlipRoutes()
                                TriggerEvent("sevenlife:opennachricht", "removemelde", false, false)
                                TriggerServerEvent("sevenlife:givecashsesffd", cash)
                                ESX.Game.DeleteVehicle(vehicles)
                                leicht = false

                                mittel = false
                                schwer = false
                                thirddoor = false
                            end
                        end
                    end
                end
            end
        )
    end
)

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
-- Delete NPC
AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        DeletePed(ped1)
        DeleteVehicle(vehicles)
    end
)
