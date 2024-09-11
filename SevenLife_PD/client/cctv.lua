local rotOffsets = {
    ["prop_cctv_cam_01a"] = vec3(-30, 0, 215),
    ["prop_cctv_cam_01b"] = vec3(-30, 0, 145),
    ["prop_cctv_cam_02a"] = vec3(-20, 0, 210),
    ["prop_cctv_cam_03a"] = vec3(0, 0, 135),
    ["prop_cctv_cam_04a"] = vec3(0, 0, 180),
    ["prop_cctv_cam_04b"] = vec3(0, 0, 180),
    ["prop_cctv_cam_04c"] = vec3(-20, 0, 180),
    ["prop_cctv_cam_05a"] = vec3(-20, 0, 180),
    ["prop_cctv_cam_06a"] = vec3(-20, 0, 180),
    ["prop_cctv_cam_07a"] = vec3(0, 0, 180),
    ["ba_prop_battle_cctv_cam_01a"] = vec3(-45, 0, -90),
    ["ba_prop_battle_cctv_cam_01b"] = vec3(-45, 0, 90)
}
local posOffsets = {
    ["prop_cctv_cam_01a"] = vec3(0, -0.7, 0.2),
    ["prop_cctv_cam_01b"] = vec3(0, -0.7, 0.2),
    ["prop_cctv_cam_02a"] = vec3(0.15, -0.3, 0),
    ["prop_cctv_cam_03a"] = vec3(-0.4, -0.4, 0.35),
    ["prop_cctv_cam_04a"] = vec3(0, -0.75, 0.65),
    ["prop_cctv_cam_04b"] = vec3(0, -0.6, 0.5),
    ["prop_cctv_cam_04c"] = vec3(0, -0.25, -0.35),
    ["prop_cctv_cam_05a"] = vec3(0, -0.2, -0.4),
    ["prop_cctv_cam_06a"] = vec3(0, -0.1, -0.2),
    ["prop_cctv_cam_07a"] = vec3(0, 0, -0.2),
    ["ba_prop_battle_cctv_cam_01a"] = vec3(0.35, -0.35, 0),
    ["ba_prop_battle_cctv_cam_01b"] = vec3(-0.35, -0.35, 0)
}
local canMove = {
    ["prop_cctv_cam_04a"] = true,
    ["prop_cctv_cam_04b"] = true,
    ["prop_cctv_cam_04c"] = true,
    ["prop_cctv_cam_07a"] = true
}

function ResetUI()
    ESX.UI.HUD.SetDisplay(1.0)
    DisplayRadar(true)

    RenderScriptCams(false, false, 0, 1, 0)
    ClearTimecycleModifier(timecycleModifier)

    ClearFocus()
end

function DisplayCamera(id)
    local cctv = Config.cameras[id]

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetFocusPosAndVel(cctv.Pos, 0.0, 0.0, 0.0)

    local object = 0
    while object == 0 do
        object = GetClosestObjectOfType(cctv.Pos, 5.0, GetHashKey(cctv.Prop), false, false, false)
        if object == 0 then
            Citizen.Wait(50)
        end
    end

    local coordsWithOffset = GetOffsetFromEntityInWorldCoords(object, posOffsets[cctv.Prop])
    local rotation = GetEntityRotation(object, 2) + rotOffsets[cctv.Prop]
    SetCamRot(cam, rotation, 2)
    SetCamCoord(cam, coordsWithOffset)
    RenderScriptCams(true, false, 0, 1, 0)

    SetTimecycleModifier(timecycleModifier)
    SetTimecycleModifierStrength(2.0)

    DisplayRadar(false)
    ESX.UI.HUD.SetDisplay(0.0)
    TriggerEvent("esx_status:setDisplay", 0.0)
    local delay = 5
    if canMove[cctv.Prop] then
        local step = 0.5

        Citizen.CreateThread(
            function()
                while DoesCamExist(cam) do
                    if IsDisabledControlPressed(0, 34) then
                        rotation = rotation + vec(0, 0, step)
                        SetCamRot(cam, rotation, 2)
                    end
                    Citizen.Wait(delay)
                end
            end
        )

        Citizen.CreateThread(
            function()
                while DoesCamExist(cam) do
                    if IsDisabledControlPressed(0, 35) then
                        rotation = rotation + vec(0, 0, -step)
                        SetCamRot(cam, rotation, 2)
                    end
                    Citizen.Wait(delay)
                end
            end
        )

        Citizen.CreateThread(
            function()
                while DoesCamExist(cam) do
                    if IsDisabledControlPressed(0, 32) then
                        if rotation.x < rotOffsets[cctv.Prop].x then
                            rotation = rotation + vec(step, 0, 0)
                            SetCamRot(cam, rotation, 2)
                        end
                    end
                    Citizen.Wait(delay)
                end
            end
        )

        Citizen.CreateThread(
            function()
                while DoesCamExist(cam) do
                    if IsDisabledControlPressed(0, 33) then
                        if rotation.x > -90 then
                            rotation = rotation + vec(-step, 0, 0)
                            SetCamRot(cam, rotation, 2)
                        end
                    end
                    Citizen.Wait(delay)
                end
            end
        )
    end
    Citizen.CreateThread(
        function()
            while DoesCamExist(cam) do
                if IsControlJustPressed(0, 177) then
                    DestroyCam(cam, false)
                    ResetUI()
                end
                Citizen.Wait(delay)
            end
        end
    )
end

--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------

notifys11 = true
inmarker11 = false
inmenu11 = false

local timemain1 = 100
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain1)
            if IsPlayerInPD and inoutservice then
                local ped = GetPlayerPed(-1)
                local coord = GetEntityCoords(ped)

                local distance =
                    GetDistanceBetweenCoords(coord, Config.CCTVPlacer.x, Config.CCTVPlacer.y, Config.CCTVPlacer.z, true)
                if distance < 15 then
                    timemain1 = 15
                    if distance < 2 then
                        inmarker11 = true
                        if notifys11 then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um CCTV zu aktivieren",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 2.1 and distance <= 3 then
                            inmarker11 = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
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
            if IsPlayerInPD and inoutservice then
                if inmarker11 then
                    if IsControlJustPressed(0, 38) then
                        if inmenu11 == false then
                            inmenu11 = true
                            TriggerEvent("sevenliferp:closenotify", false)
                            notifys11 = false
                            SetNuiFocus(true, false)
                            SendNUIMessage(
                                {
                                    type = "OpenCCTVMenu",
                                    result = Config.cameras
                                }
                            )
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            end
        end
    end
)

RegisterNUICallback(
    "MakeCCTV",
    function(data)
        SetNuiFocus(false, false)
        notifys11 = true
        inmarker11 = false
        inmenu11 = false
        local actions = tonumber(data.action)
        DisplayCamera(actions)
    end
)
