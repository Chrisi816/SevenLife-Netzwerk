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
local active = false
local activgolf = false
notifys8 = true

local DrawLineActive = false
inmarker8 = false
inmenu8 = false

Citizen.CreateThread(
    function()
        for k, v in pairs(Config.Spots) do
            SetBlipGlobalGolf(v.x, v.y, v.z)
        end
        for k, v in pairs(Config.Holes.BigGolf) do
            SetBlipHoleGolf(v.x, v.y, v.z)
        end
    end
)

function SetBlipGlobalGolf(x, y, z)
    local blips = vector3(x, y, z)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 109)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 6)
    SetBlipScale(blip1, 0.9)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Golf")
    EndTextCommandSetBlipName(blip1)
end
function SetBlipHoleGolf(x, y, z)
    local blips = vector3(x, y, z)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 109)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 9)
    SetBlipScale(blip1, 0.9)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Loch")
    EndTextCommandSetBlipName(blip1)
end
-- Kaufen Ball

--------------------------------------------------------------------------------------------------------------
---------------------------------------------Npc Spawner------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_f_y_bevhills_03")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance = GetDistanceBetweenCoords(PlayerCoord, Config.Ped.x, Config.Ped.y, Config.Ped.z, true)

            Citizen.Wait(500)

            if distance < 50 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped5 = CreatePed(4, ped, Config.Ped.x, Config.Ped.y, Config.Ped.z, Config.Ped.h, false, true)
                    SetEntityInvincible(ped5, true)
                    FreezeEntityPosition(ped5, true)
                    SetBlockingOfNonTemporaryEvents(ped5, true)
                    TaskPlayAnim(ped5, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped5)
                SetModelAsNoLongerNeeded(ped5)
                pedloaded = false
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------

notifys8 = true
inmarker8 = false
inmenu8 = false

local timemain1 = 100
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain1)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance = GetDistanceBetweenCoords(coord, Config.Ped.x, Config.Ped.y, Config.Ped.z, true)
            if distance < 15 then
                timemain1 = 15
                if distance < 2 then
                    inmarker8 = true
                    if notifys8 then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Laden zu öffnen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.1 and distance <= 3 then
                        inmarker8 = false
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
            if inmarker8 then
                if IsControlJustPressed(0, 38) then
                    if inmenu8 == false then
                        inmenu8 = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys8 = false
                        SetNuiFocus(true, false)
                        SendNUIMessage(
                            {
                                type = "OpenMenuGolfBall"
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

RegisterNUICallback(
    "MakeActionBealle",
    function(data)
        SetNuiFocus(false, false)
        notifys8 = true
        inmarker8 = false
        inmenu8 = false
        local actions = tonumber(data.action)
        if actions == 1 then
            TriggerServerEvent("SevenLife:Golf:GiveBealle", "gball", 10, 15)
        elseif actions == 2 then
            TriggerServerEvent("SevenLife:Golf:GiveBealle", "gball", 20, 20)
        end
    end
)

RegisterNetEvent("SevenLife:Golf:AddFunktionToBall")
AddEventHandler(
    "SevenLife:Golf:AddFunktionToBall",
    function()
        activgolf = true
        SendNUIMessage(
            {
                type = "OpenHelp"
            }
        )

        local ped = GetPlayerPed(-1)
        local x, y, z = table.unpack(GetEntityCoords(ped))

        AnimPlay("amb@medic@standing@kneel@base", "base", GetEntityCoords(ped), -1, 1)

        Citizen.Wait(2000)
        objschlag = CreateNewObjekt("prop_golf_putter_01", GetEntityCoords(ped))

        obj = CreateNewObjekt("prop_golf_ball", GetEntityCoords(ped))
        AttachEntityToEntity(
            objschlag,
            ped,
            GetPedBoneIndex(ped, 28422),
            0,
            0,
            0,
            0.0,
            0.0,
            0.0,
            false,
            false,
            false,
            true,
            0,
            true
        )

        DetachEntity(obj)
        AddFloatParams(obj)
        SetCurrentPedWeapon(ped, -1569615261, true)
        ClearPedTasksImmediately(ped)
        FreezeEntityPosition(ped, true)
        local heading = GetEntityHeading(ped)
        SetEntityHeading(ped, heading - 90)
        AnimPlay("mini@golfai", "wedge_idle_a", GetEntityCoords(GetPlayerPed(-1)), -1, 1)
        local Ped = GetPlayerPed(-1)
        local baseHeading = GetEntityHeading(Ped)

        if not IsEntityAttached(Ped) then
            AttachEntityToEntity(Ped, obj, 20, 0.14, -0.62, 0.99, 0.0, 0.0, 0.0, false, false, false, false, 1, true)
        end

        SetEntityHeading(obj, baseHeading + 1.0)
        DetachEntity(Ped, true, true)
        MakeLine()
        TriggerEvent("SevenLife:Golf:StartEventBall")
    end
)

function CreateNewObjekt(model, pos)
    local model = model
    local hash = GetHashKey(model)

    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(1)
    end

    local objs = CreateObject(hash, pos, true, false, false)
    return objs
end

function AddFloatParams(entity)
    SetEntityLoadCollisionFlag(entity, true)
    SetEntityCollision(entity, true, true)
    SetEntityRecordsCollisions(entity, true)
    SetEntityHasGravity(entity, true)
    FreezeEntityPosition(entity, true)
    SetEntityHeading(entity, 0.0)
    SetEntityMaxSpeed(entity, 10.0)
    PlaceObjectOnGroundProperly(entity)
end

function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(100)
        end
    end
    return animDict
end
local power = 1.0
RegisterNetEvent("SevenLife:Golf:StartEventBall")
AddEventHandler(
    "SevenLife:Golf:StartEventBall",
    function()
        Citizen.CreateThread(
            function()
                while true do
                    Citizen.Wait(1)
                    if activgolf then
                        DisableanyactionsinGreenZone()
                        if IsControlJustPressed(0, 73) then
                            GolfQuit()
                        end
                        if IsControlPressed(0, 174) then
                            local Ped = GetPlayerPed(-1)
                            local baseHeading = GetEntityHeading(Ped)

                            if not IsEntityAttached(Ped) then
                                AttachEntityToEntity(
                                    Ped,
                                    obj,
                                    20,
                                    0.14,
                                    -0.62,
                                    0.99,
                                    0.0,
                                    0.0,
                                    0.0,
                                    false,
                                    false,
                                    false,
                                    false,
                                    1,
                                    true
                                )
                            end

                            SetEntityHeading(obj, baseHeading + 1.0)
                            DetachEntity(Ped, true, true)
                        end
                        if IsControlPressed(0, 175) then
                            local Ped = GetPlayerPed(-1)
                            local baseHeading = GetEntityHeading(Ped)

                            if not IsEntityAttached(Ped) then
                                AttachEntityToEntity(
                                    Ped,
                                    obj,
                                    20,
                                    0.14,
                                    -0.62,
                                    0.99,
                                    0.0,
                                    0.0,
                                    0.0,
                                    false,
                                    false,
                                    false,
                                    false,
                                    1,
                                    true
                                )
                            end

                            SetEntityHeading(obj, baseHeading - 1.0)
                            DetachEntity(Ped, true, true)
                        end
                        if IsDisabledControlPressed(0, 24) and power < 50.0 then
                            power = power + 1.0
                        end
                        if IsDisabledControlJustReleased(0, 24) then
                            gameCamPosition, DrawLineActive = CamLocation(90.0), false
                            Shoot()
                        end
                    else
                        return
                    end
                end
            end
        )
    end
)

function GolfQuit()
    local Ped = GetPlayerPed(-1)
    DetachEntity(Ped, true, true)
    FreezeEntityPosition(Ped, false)
    ClearPedTasksImmediately(Ped)
    DeleteObject(obj)
    DeleteEntity(obj)
    DeleteObject(objschlag)
    DeleteEntity(objschlag)
    objschlag = nil
    obj = nil
    activgolf = false
    DrawLineActive = false

    SendNUIMessage(
        {
            type = "RemoveHelp"
        }
    )
end

AddEventHandler(
    "onResourceStop",
    function(name)
        if GetCurrentResourceName() == name then
            GolfQuit()
        end
    end
)
function CamLocation(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotateToDiraction(cameraRotation)
    local destination = {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e =
        GetShapeTestResult(
        StartShapeTestRay(
            cameraCoord.x,
            cameraCoord.y,
            cameraCoord.z,
            destination.x,
            destination.y,
            destination.z,
            -1,
            -1,
            1
        )
    )
    return c
end

function RotateToDiraction(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function Shoot()
    SetEntityHeading(obj, 0.0)
    local Ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(Ped)
    local power = getPower()
    local cam = camPosition()
    local offset = GetOffsetFromEntityGivenWorldCoords(obj, cam.x, cam.y, cam.z)

    AnimPlay("mini@golfai", "iron_swing_action", {coords.x - 0.6, coords.y + 0.2, coords.z}, 5000, 0)

    SetTimeout(
        500,
        function()
            PlaySoundFromEntity(-1, "GOLF_SWING_FAIRWAY_IRON_LIGHT_MASTER", PlayerPedId(), 0, 0, 0)

            FreezeEntityPosition(obj, false)
            SetEntityVelocity(obj, offset.x * power * 10, offset.y * power * 10, offset.y * power * 30)
            ApplyForceToEntity(
                obj,
                0,
                offset.x * power * 20,
                offset.y * power * 20,
                offset.y * power * 30,
                0.0,
                0.0,
                0.0,
                0,
                false,
                true,
                true,
                false,
                true
            )

            MakeCam()
            local wait = 100
            active = true

            while active do
                Wait(wait)
                if power > 0.00 then
                    power = power - 1.0
                else
                    wait = 1

                    for k, v in pairs(Config.Holes.BigGolf) do
                        local speed = GetEntitySpeed(obj)
                        local curspeed = math.floor(speed * 3.6)

                        if 4.0 > curspeed then
                            SetEntityVelocity(obj, 0.0, 0.0, 0.0)
                            FreezeEntityPosition(obj, true)

                            local objectAtCoords =
                                DoesObjectOfTypeExistAtCoords(v.x, v.y, v.z, 10.4, "prop_golf_ball", false)

                            DelCam()

                            if objectAtCoords then
                                wait = 100
                                EndGame()
                                active = false
                            else
                                wait = 100

                                Weitergehts()
                                active = false
                            end
                        end
                    end
                end
            end
        end
    )
end
function AnimPlay(dict, anim, coords, duration, loop)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Wait(1)
    end

    if HasAnimDictLoaded(dict) then
        local x, y, z = false, false, false

        if coords then
            x = coords.x
            y = coords.y
            z = coords.z
        end

        TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, duration or -1, loop or 0, 0, x, y, z)
    end
end
function MakeCam()
    cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
    RenderScriptCams(true, false, 0, true, true)
    SetCamFov(cam, 90.0)
    AttachCamToEntity(cam, obj, -0.2, 0.0, 1.0099, false)
end
function DelCam()
    if cam then
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 0, true, true)
        cam = nil
    end
end
function EndGame()
    local Ped = GetPlayerPed(-1)
    DetachEntity(Ped, true, true)
    FreezeEntityPosition(Ped, false)
    ClearPedTasksImmediately(Ped)
    GolfQuit()
    DeleteObject(obj)

    activgolf = false
    DeleteObject(objschlag)
    TriggerServerEvent("SevenLife:Golf:GiveXP")
    SendNUIMessage(
        {
            type = "RemoveHelp"
        }
    )
    TriggerEvent("SevenLife:TimetCustom:Notify", "Golf", "+1 Skillbaum XP, +0.01% Visum", 3000)
end
function setCurrentPosition(p)
    currentPosition = p
end

function getPower()
    return power
end

function camPosition()
    return gameCamPosition
end

function MakeLine()
    Citizen.CreateThread(
        function()
            if not DrawLineActive then
                DrawLineActive = true
            end
            while DrawLineActive do
                Wait(1)

                if obj == nil then
                    return
                end

                local bcoords = GetEntityCoords(obj)
                local diraction = CamLocation(90.0)

                DrawLine(bcoords.x, bcoords.y, bcoords.z, diraction.x, diraction.y, diraction.z, 255, 0, 0, 0.8)
            end
        end
    )
end

function DisableanyactionsinGreenZone()
    DisableControlAction(0, 24, true)
end

function Weitergehts()
    local ped = GetPlayerPed(-1)
    FreezeEntityPosition(ped, false)
    ClearPedTasksImmediately(ped)
    activgolf = false
    GolfQuit()
    SendNUIMessage(
        {
            type = "RemoveHelp"
        }
    )
end
