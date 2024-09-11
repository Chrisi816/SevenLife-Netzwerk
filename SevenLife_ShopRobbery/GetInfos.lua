local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_o_tramp_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            Citizen.Wait(500)

            local distance =
                GetDistanceBetweenCoords(PlayerCoord, Config.GetPlans.x, Config.GetPlans.y, Config.GetPlans.z, true)

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
                        Config.GetPlans.x,
                        Config.GetPlans.y,
                        Config.GetPlans.z,
                        Config.GetPlans.heading,
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

local notifys = true
local inmarker = false
local inmenu = false
local timemain = 100

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance =
                GetDistanceBetweenCoords(coord, Config.GetPlans.x, Config.GetPlans.y, Config.GetPlans.z, true)
            if distance < 15 then
                area = true
                timemain = 15
                if distance < 2 then
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um mit dem Räuber zu sprechen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.1 and distance <= 3 then
                        inmarker = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                area = false
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
                        ESX.TriggerServerCallback(
                            "SevenLife:ShopRobbery:GetInfos",
                            function(Start)
                                if Start then
                                    inmenu = true
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    notifys = false
                                    SetNuiFocus(true, true)
                                    openmenu = true
                                    EnableCam(GetPlayerPed(-1))
                                    SendNUIMessage(
                                        {
                                            type = "OpenDialogueMenu"
                                        }
                                    )
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Räuber",
                                        "Du kannst momentan keinen Laden ausrauben!",
                                        2000
                                    )
                                end
                            end
                        )
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
function EnableCam(player)
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

function DisableCam()
    local player = GetPlayerPed(-1)
    RenderScriptCams(false, true, 1500, 1, 0)
    DestroyCam(cam, false)
    FreezeEntityPosition(player, false)

    FreezeEntityPosition(GetPlayerPed(-1), false)
end
RegisterNUICallback(
    "closes",
    function()
        notactive = false
        OpenMenu = false
        DisableCam()
        SetNuiFocus(false, false)
        AllowSevenNotify = true
    end
)
RegisterNUICallback(
    "ablehnen",
    function()
        notactive = false
        OpenMenu = false
        DisableCam()
        SetNuiFocus(false, false)
        AllowSevenNotify = true
    end
)
RegisterNUICallback(
    "annehmen",
    function()
        notactive = false
        OpenMenu = false
        DisableCam()
        SetNuiFocus(false, false)
        AllowSevenNotify = true
        TriggerEvent("SevenLife:ShopRobbery:MakeNextStep")
    end
)
