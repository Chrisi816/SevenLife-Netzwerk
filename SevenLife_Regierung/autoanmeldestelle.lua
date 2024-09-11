local vehicles = {}
--------------------------------------------------------------------------------------------------------------
------------------------------------------------ESX-----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

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
            Citizen.Wait(10)
        end
    end
)
--------------------------------------------------------------------------------------------------------------
------------------------------------------------Blips---------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        Citizen.Wait(500)
        local blip = AddBlipForCoord(Config.CarAnmeldestelle.Ped.x, Config.CarAnmeldestelle.Ped.y)

        SetBlipSprite(blip, 476)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 48)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Zulassungsstelle")
        EndTextCommandSetBlipName(blip)
    end
)

--------------------------------------------------------------------------------------------------------------
---------------------------------------------Npc Spawner------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
local msg
local msgeins
local msgzwei
local garage
local notifys = true
local inmarker = false
local inmenu = false
local openmenu = false
local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.CarAnmeldestelle.Ped.x,
                Config.CarAnmeldestelle.Ped.y,
                Config.CarAnmeldestelle.Ped.z,
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
                    ped1 =
                        CreatePed(
                        4,
                        ped,
                        Config.CarAnmeldestelle.Ped.x,
                        Config.CarAnmeldestelle.Ped.y,
                        Config.CarAnmeldestelle.Ped.z,
                        Config.CarAnmeldestelle.Ped.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped1, true)
                    FreezeEntityPosition(ped1, true)
                    SetBlockingOfNonTemporaryEvents(ped1, true)
                    RequestAnimDict("missfbi_s4mop")
                    while not HasAnimDictLoaded("missfbi_s4mop") do
                        Citizen.Wait(1)
                    end
                    TaskPlayAnim(ped10, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
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

RegisterNUICallback(
    "umschauen",
    function()
        SetNuiFocus(false, false)
        disableCam()
        openmenu = false
        notifys = true
        inmenu = false
    end
)
RegisterNUICallback(
    "Kennzeicheneandern",
    function()
        TriggerEvent("sevenlife:getmorecarstepse")
    end
)
--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            local player = GetPlayerPed(-1)
            if openmenu == false then
                Citizen.Wait(150)
                local coords = GetEntityCoords(player)
                local distance =
                    GetDistanceBetweenCoords(
                    coords,
                    Config.CarAnmeldestelle.Ped.x,
                    Config.CarAnmeldestelle.Ped.y,
                    Config.CarAnmeldestelle.Ped.z,
                    true
                )
                if distance < 1.5 then
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um dein Auto Anzumelden",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.6 and distance <= 4 then
                        inmarker = false
                        TriggerEvent("sevenliferp:closenotify", false)
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
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        openmenu = true
                        enableCam(ped)
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenAnmeldeInteraction"
                            }
                        )
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
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
AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        DeletePed(ped1)
    end
)

function disableCam()
    local player = GetPlayerPed(-1)
    RenderScriptCams(false, true, 1500, 1, 0)
    DestroyCam(cam, false)
    FreezeEntityPosition(player, false)

    FreezeEntityPosition(GetPlayerPed(-1), false)
end
--------------------------------------------------------------------------------------------------------------
------------------------------------------------Markers-------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
local inarea
Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            player = GetPlayerPed(-1)

            Citizen.Wait(250)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(
                coords,
                Config.CarAnmeldestelle.carplace.x,
                Config.CarAnmeldestelle.carplace.y,
                Config.CarAnmeldestelle.carplace.z,
                true
            )
            if distance < 15 then
                inarea = true
            else
                if distance > 15 then
                    inarea = false
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(1)

            if openmenu == false then
                if inarea then
                    DrawMarker(
                        36,
                        Config.CarAnmeldestelle.carplace.x,
                        Config.CarAnmeldestelle.carplace.y,
                        Config.CarAnmeldestelle.carplace.z,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        1.2,
                        1.2,
                        1.2,
                        234,
                        0,
                        122,
                        200,
                        1,
                        1,
                        0,
                        0
                    )
                end
            end
        end
    end
)
RegisterNUICallback(
    "Kennzeicheneandern",
    function()
        vehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)))

        local plate = GetVehicleNumberPlateText(vehicle)
        ESX.TriggerServerCallback(
            "sevenlife:checkifplayerhavelicense",
            function(owned)
                if owned == true then
                    if vehicle ~= 0 then
                        ESX.TriggerServerCallback(
                            "sevenlife:checkifcarisownedanmelde",
                            function(owneds)
                                local vehname = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                                if owneds then
                                    oldplates = plate
                                    SetNuiFocus(true, true)
                                    print("hey")
                                    SendNUIMessage(
                                        {
                                            type = "openanmelde",
                                            vehname = vehname,
                                            plate = GetVehicleNumberPlateText(vehicle)
                                        }
                                    )
                                else
                                    removing()
                                    TriggerEvent("sevenlife:timednotifycar", "Der " .. vehname .. " gehört nicht dir")
                                end
                            end,
                            GetVehicleNumberPlateText(vehicle)
                        )
                    else
                        removing()
                        TriggerEvent("sevenlife:timednotifycar", "Stelle erstmal ein Auto auf die Markierung ab")
                    end
                else
                    removing()
                    TriggerEvent("sevenlife:timednotifycar", "Du brauch einen Führerschein um dein Auto Anzumelden")
                end
            end
        )
    end
)

function removing()
    SetNuiFocus(false, false)
    disableCam()
    openmenu = false
    notifys = true
    inmenu = false
end

RegisterNetEvent("sevenlife:timednotifycar")
AddEventHandler(
    "sevenlife:timednotifycar",
    function(msg)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Fahrzeug", msg, 2000)
        inmenu = false
        notifys = true
        openmenu = false
    end
)

RegisterNUICallback(
    "anmeldedaten",
    function(data)
        local newplate = data.plate
        local oldplate = oldplates
        ESX.TriggerServerCallback(
            "sevenlife:vehicleid",
            function(vehicleid)
                ESX.TriggerServerCallback(
                    "sevenlife:platetakens",
                    function(isPlateTaken)
                        if not isPlateTaken then
                            notifys = true
                            inmarker = false
                            inmenu = false
                            openmenu = false
                            TriggerServerEvent("sevenlife:renamecar", oldplate, newplate, vehicleid)
                            removing()
                        else
                            removing()
                            TriggerEvent(
                                "sevenlife:timednotifycar",
                                "Leider ist das Kennzeichen welches du beanspruchen willst, schon an jemanden anderen Vergeben"
                            )
                        end
                    end,
                    newplate
                )
            end,
            oldplate
        )
        print(oldplate)
    end
)

RegisterNetEvent("SevenLife:Regierung:RenameCar")
AddEventHandler(
    "SevenLife:Regierung:RenameCar",
    function(newplate)
        SetVehicleNumberPlateText(vehicle, " " .. newplate)
    end
)
