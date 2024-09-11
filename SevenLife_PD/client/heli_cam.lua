local WhitelistetHelis = {
    "buzzard",
    "polmav"
}
local activhelicam = false
local TargetVehicle = nil
local vehicle_display = 0
local vision_state = 0
local fov = (80.0 + 5.0) * 0.5

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            if IsPlayerInPD and inoutservice then
                if NetworkIsSessionStarted() then
                    DecorRegister("SpotvectorX", 3)
                    DecorRegister("SpotvectorY", 3)
                    DecorRegister("SpotvectorZ", 3)
                    DecorRegister("Target", 3)
                    return
                end
            else
                Citizen.Wait(5000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(7)

            if IsPlayerInPD and inoutservice then
                local Ped = GetPlayerPed(-1)
                local heli = GetVehiclePedIsIn(Ped)
                if IsVehicleHeli(Ped) then
                    if IsEntityHighOverGround(heli) and not activhelicam then
                        if IsControlJustPressed(0, 51) then
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            activhelicam = true
                        end

                        if IsControlJustPressed(0, 154) then
                            if GetPedInVehicleSeat(heli, 1) == Ped or GetPedInVehicleSeat(heli, 2) == Ped then
                                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                TaskRappelFromHeli(GetPlayerPed(-1), 1)
                            end
                        end
                    end

                    if IsControlJustPressed(0, 183) and GetPedInVehicleSeat(heli, -1) == Ped and not activhelicam then
                        if TargetVehicle then
                            if Spotlight_Tracking then
                                if not Pause_Light then
                                    Pause_Light = true
                                    TriggerServerEvent("SevenLife:PD:PauseTrackSpotLight", Pause_Light)
                                else
                                    Pause_Light = false
                                    TriggerServerEvent("SevenLife:PD:PauseTrackSpotLight", Pause_Light)
                                end
                                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            else
                                if Fspotlight_state then
                                    Fspotlight_state = false
                                end
                                local target_netID = VehToNet(TargetVehicle)
                                local target_plate = GetVehicleNumberPlateText(TargetVehicle)
                                local targetposx, targetposy, targetposz = table.unpack(GetEntityCoords(TargetVehicle))
                                Pause_Light = false
                                Spotlight_Tracking = true
                                TriggerServerEvent(
                                    "SevenLife:PD:SpotLight",
                                    target_netID,
                                    target_plate,
                                    targetposx,
                                    targetposy,
                                    targetposz
                                )

                                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            end
                        else
                            if Spotlight_Tracking then
                                Pause_Light = false
                                Spotlight_Tracking = false
                            end
                            Fspotlight_state = not Fspotlight_state
                            TriggerServerEvent("SevenLife:PD:MakeSpotlightForward", Fspotlight_state)
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                        end
                    end
                    if IsControlJustPressed(0, 44) and GetPedInVehicleSeat(heli, -1) == Ped then
                        ChangeDisplay()
                    end

                    if TargetVehicle and GetPedInVehicleSeat(heli, -1) == Ped then
                        local coords1 = GetEntityCoords(heli)
                        local coords2 = GetEntityCoords(TargetVehicle)
                        local target_distance =
                            GetDistanceBetweenCoords(
                            coords1.x,
                            coords1.y,
                            coords1.z,
                            coords2.x,
                            coords2.y,
                            coords2.z,
                            false
                        )
                        if IsControlJustPressed(0, 22) or target_distance > 700 then
                            DecorRemove(TargetVehicle, "Target")
                            if Spotlight_Tracking then
                                TriggerServerEvent("SevenLife:PD:ToogelSpotLight")
                            end
                            Spotlight_Tracking = false
                            Pause_Light = false
                            TargetVehicle = nil
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                        end
                    end
                    if activhelicam then
                        SetTimecycleModifier("heliGunCam")
                        SetTimecycleModifierStrength(0.3)
                        local scaleform = RequestScaleformMovie("HELI_CAM")
                        while not HasScaleformMovieLoaded(scaleform) do
                            Citizen.Wait(0)
                        end
                        local Ped = GetPlayerPed(-1)
                        local heli = GetVehiclePedIsIn(Ped)
                        local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
                        AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)
                        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(heli))
                        SetCamFov(cam, fov)
                        RenderScriptCams(true, false, 0, 1, 0)
                        PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
                        PushScaleformMovieFunctionParameterInt(1)
                        PopScaleformMovieFunctionVoid()
                        local locked_on_vehicle = nil

                        while activhelicam and not IsEntityDead(Ped) and (GetVehiclePedIsIn(Ped) == heli) and
                            IsEntityHighOverGround(heli) do
                            if IsControlJustPressed(0, 51) then
                                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                if manual_spotlight and TargetVehicle then
                                    TriggerServerEvent("SevenLife:SpotLight:ManuellToggel")
                                    local target_netID = VehToNet(TargetVehicle)
                                    local target_plate = GetVehicleNumberPlateText(TargetVehicle)
                                    local targetposx, targetposy, targetposz =
                                        table.unpack(GetEntityCoords(TargetVehicle))
                                    Pause_Light = false
                                    Spotlight_Tracking = true
                                    TriggerServerEvent(
                                        "SevenLife:PD:SpotLight",
                                        target_netID,
                                        target_plate,
                                        targetposx,
                                        targetposy,
                                        targetposz
                                    )
                                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                end
                                manual_spotlight = false
                                activhelicam = false
                            end

                            if IsControlJustPressed(0, 25) then
                                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                ChangeVision()
                            end

                            if IsControlJustPressed(0, 183) then
                                if Spotlight_Tracking then
                                    Pause_Light = true
                                    TriggerServerEvent("SevenLife:PD:PauseTrackSpotLight", Pause_Light)
                                    manual_spotlight = not manual_spotlight
                                    if manual_spotlight then
                                        local rotation = GetCamRot(cam, 2)
                                        local forward_vector = RotAnglesToVec(rotation)
                                        local SpotvectorX, SpotvectorY, SpotvectorZ = table.unpack(forward_vector)
                                        DecorSetInt(Ped, "SpotvectorX", SpotvectorX)
                                        DecorSetInt(Ped, "SpotvectorY", SpotvectorY)
                                        DecorSetInt(Ped, "SpotvectorZ", SpotvectorZ)
                                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                        TriggerServerEvent("SevenLife:SpotLight:Manuell")
                                    else
                                        TriggerServerEvent("SevenLife:SpotLight:ManuellToggel")
                                    end
                                elseif Fspotlight_state then
                                    Fspotlight_state = false
                                    TriggerServerEvent("heli:forward.spotlight", Fspotlight_state)
                                    manual_spotlight = not manual_spotlight
                                    if manual_spotlight then
                                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                        TriggerServerEvent("SevenLife:SpotLight:Manuell")
                                    else
                                        TriggerServerEvent("SevenLife:SpotLight:ManuellToggel")
                                    end
                                else
                                    manual_spotlight = not manual_spotlight
                                    if manual_spotlight then
                                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                        TriggerServerEvent("SevenLife:SpotLight:Manuell")
                                    else
                                        TriggerServerEvent("SevenLife:SpotLight:ManuellToggel")
                                    end
                                end
                            end

                            if IsControlJustPressed(0, 246) then
                                TriggerServerEvent("heli:light.up")
                            end

                            if IsControlJustPressed(0, 173) then
                                TriggerServerEvent("heli:light.down")
                            end

                            if IsControlJustPressed(0, 137) then
                                TriggerServerEvent("heli:radius.up")
                            end

                            if IsControlJustPressed(0, 21) then
                                TriggerServerEvent("heli:radius.down")
                            end

                            if IsControlJustPressed(0, 44) then
                                ChangeDisplay()
                            end

                            if locked_on_vehicle then
                                if DoesEntityExist(locked_on_vehicle) then
                                    PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
                                    RenderVehicleInfo(locked_on_vehicle)
                                    local coords1 = GetEntityCoords(heli)
                                    local coords2 = GetEntityCoords(locked_on_vehicle)
                                    local target_distance =
                                        GetDistanceBetweenCoords(
                                        coords1.x,
                                        coords1.y,
                                        coords1.z,
                                        coords2.x,
                                        coords2.y,
                                        coords2.z,
                                        false
                                    )
                                    if IsControlJustPressed(0, 22) or target_distance > 700.0 then
                                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                        DecorRemove(TargetVehicle, "Target")
                                        if Spotlight_Tracking then
                                            TriggerServerEvent("SevenLife:PD:SpotLight.toggle")
                                            Spotlight_Tracking = false
                                        end
                                        TargetVehicle = nil
                                        locked_on_vehicle = nil
                                        local rot = GetCamRot(cam, 2)
                                        local fov = GetCamFov(cam)
                                        local old
                                        cam = cam
                                        DestroyCam(old_cam, false)
                                        cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
                                        AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)
                                        SetCamRot(cam, rot, 2)
                                        SetCamFov(cam, fov)
                                        RenderScriptCams(true, false, 0, 1, 0)
                                    end
                                else
                                    locked_on_vehicle = nil
                                    TargetVehicle = nil
                                end
                            else
                                local zoomvalue = (1.0 / (80.0 - 5.0)) * (fov - 5.0)
                                CheckInputRotation(cam, zoomvalue)
                                local vehicle_detected = GetVehicleInView(cam)
                                if DoesEntityExist(vehicle_detected) then
                                    RenderVehicleInfo(vehicle_detected)
                                    if IsControlJustPressed(0, 22) then
                                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                        locked_on_vehicle = vehicle_detected

                                        if TargetVehicle then
                                            DecorRemove(TargetVehicle, "Target")
                                        end

                                        TargetVehicle = vehicle_detected
                                        NetworkRequestControlOfEntity(TargetVehicle)
                                        local target_netID = VehToNet(TargetVehicle)
                                        SetNetworkIdCanMigrate(target_netID, true)
                                        NetworkRegisterEntityAsNetworked(VehToNet(TargetVehicle))
                                        SetNetworkIdExistsOnAllMachines(TargetVehicle, true)
                                        SetEntityAsMissionEntity(TargetVehicle, true, true)
                                        target_plate = GetVehicleNumberPlateText(TargetVehicle)
                                        DecorSetInt(locked_on_vehicle, "Target", 2)

                                        if Spotlight_Tracking then
                                            TriggerServerEvent("SevenLife:PD:SpotLight.toggle")
                                            TargetVehicle = locked_on_vehicle

                                            if not Pause_Light then
                                                local target_netID = VehToNet(TargetVehicle)
                                                local target_plate = GetVehicleNumberPlateText(TargetVehicle)
                                                local targetposx, targetposy, targetposz =
                                                    table.unpack(GetEntityCoords(TargetVehicle))
                                                Pause_Light = false
                                                Spotlight_Tracking = true
                                                TriggerServerEvent(
                                                    "SevenLife:PD:SpotLight",
                                                    target_netID,
                                                    target_plate,
                                                    targetposx,
                                                    targetposy,
                                                    targetposz
                                                )
                                                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                            else
                                                Spotlight_Tracking = false
                                                Pause_Light = false
                                            end
                                        end
                                    end
                                end
                            end

                            HandleZoom(cam)
                            HideAll()
                            PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
                            PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heli).z)
                            PushScaleformMovieFunctionParameterFloat(zoomvalue)
                            PushScaleformMovieFunctionParameterFloat(GetCamRot(cam, 2).z)
                            PopScaleformMovieFunctionVoid()
                            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                            Citizen.Wait(1)

                            if manual_spotlight then
                                local rotation = GetCamRot(cam, 2)
                                local forward_vector = RotAnglesToVec(rotation)
                                local SpotvectorX, SpotvectorY, SpotvectorZ = table.unpack(forward_vector)
                                local camcoords = GetCamCoord(cam)

                                DecorSetInt(Ped, "SpotvectorX", SpotvectorX)
                                DecorSetInt(Ped, "SpotvectorY", SpotvectorY)
                                DecorSetInt(Ped, "SpotvectorZ", SpotvectorZ)
                                DrawSpotLight(
                                    camcoords,
                                    forward_vector,
                                    255,
                                    255,
                                    255,
                                    800.0,
                                    10.0,
                                    1.0,
                                    spotradius,
                                    1.0,
                                    1.0
                                )
                            else
                                TriggerServerEvent("SevenLife:SpotLight:ManuellToggel")
                            end
                        end
                        if manual_spotlight then
                            manual_spotlight = false
                            TriggerServerEvent("SevenLife:SpotLight:ManuellToggel")
                        end
                        activhelicam = false
                        ClearTimecycleModifier()
                        fov = (80.0 + 5.0) * 0.5
                        RenderScriptCams(false, false, 0, 1, 0)
                        SetScaleformMovieAsNoLongerNeeded(scaleform)
                        DestroyCam(cam, false)
                        SetNightvision(false)
                        SetSeethrough(false)
                    end
                    if TargetVehicle and not activhelicam and vehicle_display ~= 2 then
                        RenderVehicleInfo(TargetVehicle)
                    end
                end
            else
                Citizen.Wait(5000)
            end
        end
    end
)

function IsVehicleHeli(ped)
    local vehicle = GetVehiclePedIsIn(ped)
    for i = 1, #WhitelistetHelis do
        GetVehicles = IsVehicleModel(vehicle, WhitelistetHelis[i])
        if GetVehicles then
            return GetVehicles
        end
    end
end

function IsEntityHighOverGround(HeliPed)
    return GetEntityHeightAboveGround(HeliPed) > 3
end

function HideAll()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(19)
    HideHudComponentThisFrame(2)
    HideHudComponentThisFrame(11)
    HideHudComponentThisFrame(12)
    HideHudComponentThisFrame(15)
    HideHudComponentThisFrame(18)
end

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}
function ChangeDisplay()
    if vehicle_display == 0 then
        vehicle_display = 1
    elseif vehicle_display == 1 then
        vehicle_display = 2
    else
        vehicle_display = 0
    end
end

function ChangeVision()
    if vision_state == 0 then
        SetNightvision(true)
        vision_state = 1
    elseif vision_state == 1 then
        SetNightvision(false)
        SetSeethrough(true)
        vision_state = 2
    else
        SetSeethrough(false)
        vision_state = 0
    end
end
RegisterNetEvent("SevenLife:PD:SpotToggel")
AddEventHandler(
    "SevenLife:PD:SpotToggel",
    function(serverID)
        Mspotlight_toggle = false
    end
)

RegisterNetEvent("SevenLife:SpotLight:Change")
AddEventHandler(
    "SevenLife:SpotLight:Change",
    function(serverID)
        if GetPlayerServerId(PlayerId()) ~= serverID then
            local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
            local heliPed = GetPlayerPed(GetPlayerFromServerId(serverID))
            Mspotlight_toggle = true
            while not IsEntityDead(heliPed) and (GetVehiclePedIsIn(heliPed) == heli) and Mspotlight_toggle do
                Citizen.Wait(0)
                local helicoords = GetEntityCoords(heli)
                spotoffset = helicoords + vector3(0.0, 0.0, -1.5)
                SpotvectorX = DecorGetInt(heliPed, "SpotvectorX")
                SpotvectorY = DecorGetInt(heliPed, "SpotvectorY")
                SpotvectorZ = DecorGetInt(heliPed, "SpotvectorZ")
                if SpotvectorX then
                    DrawSpotLight(
                        spotoffset["x"],
                        spotoffset["y"],
                        spotoffset["z"],
                        SpotvectorX,
                        SpotvectorY,
                        SpotvectorZ,
                        255,
                        255,
                        255,
                        800.0,
                        10.0,
                        brightness,
                        spotradius,
                        1.0,
                        1.0
                    )
                end
            end
            Mspotlight_toggle = false
            DecorSetInt(heliPed, "SpotvectorX", nil)
            DecorSetInt(heliPed, "SpotvectorY", nil)
            DecorSetInt(heliPed, "SpotvectorZ", nil)
        end
    end
)
local function GetVhiclesNum(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(
        function()
            local iter, id = initFunc()
            if not id or id == 0 then
                disposeFunc(iter)
                return
            end

            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)

            local next = true
            repeat
                coroutine.yield(id)
                next, id = moveFunc(iter)
            until not next

            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end
    )
end

function GetVehicles()
    return GetVhiclesNum()
end

RegisterNetEvent("SevenLife:PD:PauseTSportLight")
AddEventHandler(
    "SevenLife:PD:PauseTSportLight",
    function(ID, Pause_Stoplight)
        if Pause_Stoplight then
            Tspotlight_pause = true
        else
            Tspotlight_pause = false
        end
    end
)

RegisterNetEvent("SevenLife:PD:HeliSpotlight")
AddEventHandler(
    "SevenLife:PD:HeliSpotlight",
    function(serverID, target_netID, target_plate, targetposx, targetposy, targetposz)
        if GetVehicleNumberPlateText(NetToVeh(target_netID)) == target_plate then
            Tspotlight_target = NetToVeh(target_netID)
        elseif GetVehicleNumberPlateText(DoesVehicleExistWithDecorator("Target")) == target_plate then
            Tspotlight_target = DoesVehicleExistWithDecorator("Target")
        elseif
            GetVehicleNumberPlateText(GetClosestVehicle(targetposx, targetposy, targetposz, 25.0, 0, 70)) ==
                target_plate
         then
            Tspotlight_target = GetClosestVehicle(targetposx, targetposy, targetposz, 25.0, 0, 70)
        else
            vehicle_match = FindVehicleByPlate(target_plate)
            if vehicle_match then
                Tspotlight_target = vehicle_match
            else
                Tspotlight_target = nil
            end
        end

        local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
        local heliPed = GetPlayerPed(GetPlayerFromServerId(serverID))
        Tspotlight_toggle = true
        Tspotlight_pause = false
        Spotlight_Tracking = true
        while not IsEntityDead(heliPed) and (GetVehiclePedIsIn(heliPed) == heli) and Tspotlight_target and
            Tspotlight_toggle do
            Citizen.Wait(1)
            local helicoords = GetEntityCoords(heli)
            local targetcoords = GetEntityCoords(Tspotlight_target)
            local spotVector = targetcoords - helicoords
            local target_distance = Vdist(targetcoords, helicoords)
            if Tspotlight_target and Tspotlight_toggle and not Tspotlight_pause then
                DrawSpotLight(
                    helicoords["x"],
                    helicoords["y"],
                    helicoords["z"],
                    spotVector["x"],
                    spotVector["y"],
                    spotVector["z"],
                    255,
                    255,
                    255,
                    (target_distance + 20),
                    10.0,
                    1.0,
                    4.0,
                    1.0,
                    0.0
                )
            end
            if Tspotlight_target and Tspotlight_toggle and target_distance > 700 then
                DecorRemove(Tspotlight_target, "Target")
                TargetVehicle = nil
                Spotlight_Tracking = false
                TriggerServerEvent("SevenLife:PD:ToogelSpotLight")
                Tspotlight_target = nil
                break
            end
        end
        Tspotlight_toggle = false
        Tspotlight_pause = false
        Tspotlight_target = nil
        Spotlight_Tracking = false
    end
)
function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        new_z = rotation.z + rightAxisX * -1.0 * (4.0) * (zoomvalue + 0.1)
        new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (4.0) * (zoomvalue + 0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
    end
end
RegisterNetEvent("SevenLife:PD:ToogelSpotLight")
AddEventHandler(
    "SevenLife:PD:ToogelSpotLight",
    function(serverID)
        Tspotlight_toggle = false
        Spotlight_Tracking = false
    end
)
RegisterNetEvent("SevenLife:PD:MakeSpotlightForward")
AddEventHandler(
    "SevenLife:PD:MakeSpotlightForward",
    function(serverID, state)
        local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
        SetVehicleSearchlight(heli, state, false)
    end
)

RegisterNetEvent("SevenLife:Light:up")
AddEventHandler(
    "SevenLife:Light:up",
    function(serverID)
        if brightness < 10 then
            brightness = brightness + 1.0
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        end
    end
)

RegisterNetEvent("SevenLife:Light:down")
AddEventHandler(
    "SevenLife:Light:down",
    function(serverID)
        if brightness > 1.0 then
            brightness = brightness - 1.0
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        end
    end
)

RegisterNetEvent("SevenLife:Radius:up")
AddEventHandler(
    "SevenLife:Radius:up",
    function(serverID)
        if spotradius < 10.0 then
            spotradius = spotradius + 1.0
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        end
    end
)

RegisterNetEvent("SevenLife:Radius:down")
AddEventHandler(
    "SevenLife:Radius:down",
    function(serverID)
        if spotradius > 4.0 then
            spotradius = spotradius - 1.0
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        end
    end
)
function HandleZoom(cam)
    if IsControlJustPressed(0, 241) then -- Scrollup
        fov = math.max(fov - 3.0, 5.0)
    end
    if IsControlJustPressed(0, 242) then
        fov = math.min(fov + 3.0, 80.0) -- ScrollDown
    end
    local current_fov = GetCamFov(cam)
    if math.abs(fov - current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
        fov = current_fov
    end
    SetCamFov(cam, current_fov + (fov - current_fov) * 0.05) -- Smoothing of camera zoom
end

function GetVehicleInView(cam)
    local coords = GetCamCoord(cam)
    local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
    --DrawLine(coords, coords+(forward_vector*100.0), 255,0,0,255) -- debug line to show LOS of cam
    local rayhandle =
        CastRayPointToPoint(coords, coords + (forward_vector * 200.0), 10, GetVehiclePedIsIn(GetPlayerPed(-1)), 0)
    local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
    if entityHit > 0 and IsEntityAVehicle(entityHit) then
        return entityHit
    else
        return nil
    end
end

function RenderVehicleInfo(vehicle)
    if DoesEntityExist(vehicle) then
        local model = GetEntityModel(vehicle)
        local vehname = GetLabelText(GetDisplayNameFromVehicleModel(model))
        local licenseplate = GetVehicleNumberPlateText(vehicle)

        vehspeed = GetEntitySpeed(vehicle) * 3.6

        SetTextFont(0)
        SetTextProportional(1)
        if vehicle_display == 0 then
            SetTextScale(0.0, 0.49)
        elseif vehicle_display == 1 then
            SetTextScale(0.0, 0.55)
        end
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        if vehicle_display == 0 then
            AddTextComponentString(
                "Speed: " ..
                    math.ceil(vehspeed) .. " " .. speed_measure .. "\nModel: " .. vehname .. "\nPlate: " .. licenseplate
            )
        elseif vehicle_display == 1 then
            AddTextComponentString("Model: " .. vehname .. "\nPlate: " .. licenseplate)
        end
        DrawText(0.45, 0.9)
    end
end

function RotAnglesToVec(rot) -- input vector3
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end
