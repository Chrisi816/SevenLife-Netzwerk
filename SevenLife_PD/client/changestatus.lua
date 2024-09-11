-- Variables

inmenu = false
time = 200
timebetweenchecking = 200
AllowSevenNotify = true
inarea = false
inmarker = false
inoutservice = false
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
            Citizen.Wait(10)
        end
    end
)

-- Local Start
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time)
            if IsPlayerInPD then
                local ped = GetPlayerPed(-1)
                local coordofped = GetEntityCoords(ped)
                local distance =
                    GetDistanceBetweenCoords(
                    coordofped,
                    Config.Polizei.InOutOfDienst.x,
                    Config.Polizei.InOutOfDienst.y,
                    Config.Polizei.InOutOfDienst.z,
                    true
                )
                if distance < 20 then
                    time = 110
                    inarea = true
                    if distance < 2 then
                        if AllowSevenNotify then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke E um In / Aus dem Dienst zu gehen",
                                "System-Nachricht",
                                true
                            )
                        end
                        inmarker = true
                    else
                        if distance >= 2.1 and distance <= 3 then
                            TriggerEvent("sevenliferp:closenotify", false)
                            inmarker = false
                        end
                    end
                else
                    inarea = false
                    time = 200
                end
            else
                Citizen.Wait(2000)
            end
        end
    end
)
-- KeyCheck
Citizen.CreateThread(
    function()
        while true do
            local ped = GetPlayerPed(-1)
            Citizen.Wait(timebetweenchecking)
            if inarea then
                timebetweenchecking = 5
                if IsPlayerInPD then
                    if inmarker and not inmenu then
                        if IsControlJustPressed(0, 38) then
                            inmenu = true
                            enableCam(ped)
                            SetNuiFocus(true, true)
                            AllowSevenNotify = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            SendNUIMessage(
                                {
                                    type = "OpenMenuDienst"
                                }
                            )
                        end
                    end
                end
            else
                timebetweenchecking = 200
            end
        end
    end
)

-- Delete NPC
AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        DeletePed(ped1)
    end
)

-- NPC Function
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
                Config.Polizei.InOutOfDienst.x,
                Config.Polizei.InOutOfDienst.y,
                Config.Polizei.InOutOfDienst.z,
                Config.Polizei.InOutOfDienst.heading,
                true
            )

            Citizen.Wait(500)

            if distance < 30 then
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
                        Config.Polizei.InOutOfDienst.x,
                        Config.Polizei.InOutOfDienst.y,
                        Config.Polizei.InOutOfDienst.z,
                        Config.Polizei.InOutOfDienst.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped1, true)
                    FreezeEntityPosition(ped1, true)
                    SetBlockingOfNonTemporaryEvents(ped1, true)
                    TaskPlayAnim(ped1, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
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

function disableCam()
    local player = GetPlayerPed(-1)
    RenderScriptCams(false, true, 1500, 1, 0)
    DestroyCam(cam, false)
    FreezeEntityPosition(player, false)

    FreezeEntityPosition(GetPlayerPed(-1), false)
end

RegisterNUICallback(
    "annehmen",
    function()
        disableCam()
        AllowSevenNotify = true
        inmenu = false
        SetNuiFocus(false, false)
        inoutservice = true
        TriggerServerEvent("SevenLife:Police:Server:TakePoliceService")
    end
)

RegisterNUICallback(
    "ablehnen",
    function()
        disableCam()
        SetNuiFocus(false, false)
        AllowSevenNotify = true
        inmenu = false
        inoutservice = false
        TriggerServerEvent("SevenLife:Police:Server:LeavePoliceService")
    end
)

RegisterNetEvent("SevenLife:Police:CopsInService")
AddEventHandler(
    "SevenLife:Police:CopsInService",
    function(array)
        MakeCopBlips()
        AllCopsService = array
    end
)
