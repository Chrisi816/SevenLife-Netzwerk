ESX = nil

Citizen.CreateThread(
    function()
        while ESX == nil do
            Citizen.Wait(10)
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
        end
    end
)
local List = {}
local Number = 0
RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        PlayerData = xPlayer
    end
)

RegisterCommand(
    "announce",
    function(source, args)
        local first = args[1]
        local two = args[2]
        TriggerServerEvent("sevenlife:makeannounce", first, two)
    end,
    false
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(3000)

            local ped = PlayerPedId()
            SetPedCanLosePropsOnDamage(ped, false, 0)
            if IsPedSittingInAnyVehicle(ped) then
                IsPedOverKMH()
                VehicleWindows()
                MakeLight()
            end
        end
    end
)

function MakeLight()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)
    local window = AreAllVehicleWindowsIntact(vehicle)
    local speed = GetEntitySpeed(vehicle) * 3.6
    if speed >= Config.lightspeed then
        SetVehicleLights(vehicle, 2)
    else
        SetVehicleLights(vehicle, 0)
    end
end

function VehicleWindows()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)
    local window = AreAllVehicleWindowsIntact(vehicle)
    local speed = GetEntitySpeed(vehicle) * 3.6
    if speed >= Config.masspeed then
        if window == false then
            FixVehicleWindow(vehicle, VEH_EXT_WINDSCREEN)
            FixVehicleWindow(vehicle, VEH_EXT_WINDSCREEN_R)
            FixVehicleWindow(vehicle, VEH_EXT_WINDOW_LF)
            FixVehicleWindow(vehicle, VEH_EXT_WINDOW_RF)
            FixVehicleWindow(vehicle, VEH_EXT_WINDOW_LR)
            FixVehicleWindow(vehicle, VEH_EXT_WINDOW_RR)
            FixVehicleWindow(vehicle, VEH_EXT_WINDOW_LM)
            FixVehicleWindow(vehicle, VEH_EXT_WINDOW_RM)
        end
    end
end

function IsPedOverKMH()
    local ped = PlayerPedId()
    local pedid = PlayerId()
    local invehicle = IsPedSittingInAnyVehicle(ped)
    local vehicle = GetVehiclePedIsUsing(ped)
    local speeds = GetEntitySpeed(vehicle) * 3.6
    if invehicle then
        if speeds >= Config.masspeed then
            SetPlayerCanDoDriveBy(pedid, false)
        else
            SetPlayerCanDoDriveBy(pedid, true)
        end
    end
end

RegisterNetEvent("sevenlife:openannounce")
AddEventHandler(
    "sevenlife:openannounce",
    function(ueberschrift, nachricht)
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
        SendNUIMessage(
            {
                type = "openannounce",
                ueberschrift = ueberschrift,
                nachricht = nachricht
            }
        )
    end
)
local tireBurstMaxNumber = Config.randomTireBurstInterval * 1200
RegisterNetEvent("sevenlife:removeanounce")
AddEventHandler(
    "sevenlife:removeanounce",
    function()
        SendNUIMessage(
            {
                type = "removeannounce"
            }
        )
    end
)

RegisterNetEvent("sevenlife:announcehandler")
AddEventHandler(
    "sevenlife:announcehandler",
    function(ueberschrift, nachricht)
        local announce = true
        Citizen.CreateThread(
            function()
                while announce do
                    PlaySoundFrontend(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 1)
                    TriggerEvent("sevenlife:openannounce", ueberschrift, nachricht)
                    Citizen.Wait(7000)
                    TriggerEvent("sevenlife:removeanounce")
                    announce = false
                end
            end
        )
    end
)

local wait = 40
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(wait)
            -- Variables
            local vehicle = GetVehiclePedIsIn(ped, false)
            local rolling = GetEntityRoll(vehicle)
            local speed = GetEntitySpeed(vehicle)
            if rolling > 70 or rolling < -70 and speed < 10 then
                -- Disable Keys
                wait = 1
                SetVehicleEngineOn(vehicle, false, false, false)
                DisableControlAction(2, 59, true)
                DisableControlAction(2, 60, true)
            else
                wait = 40
            end
        end
    end
)

local pedInSameVehicleLast = false
local vehicle
local lastVehicle
local vehicleClass
local fCollisionDamageMult = 0.0
local fDeformationDamageMult = 0.0
local fEngineDamageMult = 0.0
local fBrakeForce = 1.0

local healthEngineLast = 1000.0
local healthEngineCurrent = 1000.0
local healthEngineNew = 1000.0
local healthEngineDelta = 0.0
local healthEngineDeltaScaled = 0.0

local healthBodyLast = 1000.0
local healthBodyCurrent = 1000.0
local healthBodyNew = 1000.0
local healthBodyDelta = 0.0
local healthBodyDeltaScaled = 0.0

local healthPetrolTankLast = 1000.0
local healthPetrolTankCurrent = 1000.0
local healthPetrolTankNew = 1000.0
local healthPetrolTankDelta = 0.0
local healthPetrolTankDeltaScaled = 0.0
local tireBurstLuckyNumber
if Config.randomTireBurstInterval ~= 0 then
    tireBurstLuckyNumber = math.random(tireBurstMaxNumber)
end
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(50)
            local ped = PlayerPedId()
            if PedDriving() then
                vehicle = GetVehiclePedIsIn(ped, false)
                vehicleClass = GetVehicleClass(vehicle)
                healthEngineCurrent = GetVehicleEngineHealth(vehicle)
                if healthEngineCurrent == 1000 then
                    healthEngineLast = 1000.0
                end
                healthEngineNew = healthEngineCurrent
                healthEngineDelta = healthEngineLast - healthEngineCurrent
                healthEngineDeltaScaled =
                    healthEngineDelta * Config.damageFactorEngine * Config.classDamageMultiplier[vehicleClass]

                healthBodyCurrent = GetVehicleBodyHealth(vehicle)
                if healthBodyCurrent == 1000 then
                    healthBodyLast = 1000.0
                end
                healthBodyNew = healthBodyCurrent
                healthBodyDelta = healthBodyLast - healthBodyCurrent
                healthBodyDeltaScaled =
                    healthBodyDelta * Config.damageFactorBody * Config.classDamageMultiplier[vehicleClass]

                healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)

                if healthPetrolTankCurrent == 1000 then
                    healthPetrolTankLast = 1000.0
                end
                healthPetrolTankNew = healthPetrolTankCurrent
                healthPetrolTankDelta = healthPetrolTankLast - healthPetrolTankCurrent
                healthPetrolTankDeltaScaled =
                    healthPetrolTankDelta * Config.damageFactorPetrolTank * Config.classDamageMultiplier[vehicleClass]

                if healthEngineCurrent > Config.engineSafeGuard + 1 then
                    SetVehicleUndriveable(vehicle, false)
                end

                if healthEngineCurrent <= Config.engineSafeGuard + 1 and Config.limpMode == false then
                    SetVehicleUndriveable(vehicle, true)
                end

                -- If ped spawned a new vehicle while in a vehicle or teleported from one vehicle to another, handle as if we just entered the car
                if vehicle ~= lastVehicle then
                    pedInSameVehicleLast = false
                end

                if pedInSameVehicleLast == true then
                    -- Damage happened while in the car = can be multiplied

                    -- Only do calculations if any damage is present on the car. Prevents weird behavior when fixing using trainer or other script
                    if healthEngineCurrent ~= 1000.0 or healthBodyCurrent ~= 1000.0 or healthPetrolTankCurrent ~= 1000.0 then
                        -- Combine the delta values (Get the largest of the three)
                        local healthEngineCombinedDelta =
                            math.max(healthEngineDeltaScaled, healthBodyDeltaScaled, healthPetrolTankDeltaScaled)

                        -- If huge damage, scale back a bit
                        if healthEngineCombinedDelta > (healthEngineCurrent - Config.engineSafeGuard) then
                            healthEngineCombinedDelta = healthEngineCombinedDelta * 0.7
                        end

                        -- If complete damage, but not catastrophic (ie. explosion territory) pull back a bit, to give a couple of seconds og engine runtime before dying
                        if healthEngineCombinedDelta > healthEngineCurrent then
                            healthEngineCombinedDelta = healthEngineCurrent - (Config.cascadingFailureThreshold / 5)
                        end

                        healthEngineNew = healthEngineLast - healthEngineCombinedDelta

                        if
                            healthEngineNew > (Config.cascadingFailureThreshold + 5) and
                                healthEngineNew < Config.degradingFailureThreshold
                         then
                            healthEngineNew = healthEngineNew - (0.038 * Config.degradingHealthSpeedFactor)
                        end

                        -- If Damage is near catastrophic, cascade the failure
                        if healthEngineNew < Config.cascadingFailureThreshold then
                            healthEngineNew = healthEngineNew - (0.1 * Config.cascadingFailureSpeedFactor)
                        end

                        -- Prevent Engine going to or below zero. Ensures you can reenter a damaged car.
                        if healthEngineNew < Config.engineSafeGuard then
                            healthEngineNew = Config.engineSafeGuard
                        end

                        -- Prevent Explosions
                        if Config.compatibilityMode == false and healthPetrolTankCurrent < 750 then
                            healthPetrolTankNew = 750.0
                        end

                        -- Prevent negative body damage.
                        if healthBodyNew < 0 then
                            healthBodyNew = 0.0
                        end
                    end
                else
                    -- Just got in the vehicle. Damage can not be multiplied this round
                    -- Set vehicle handling data
                    fDeformationDamageMult = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fDeformationDamageMult")
                    fBrakeForce = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce")
                    local newFDeformationDamageMult = fDeformationDamageMult ^ Config.deformationExponent -- Pull the handling file value closer to 1
                    if Config.deformationMultiplier ~= -1 then
                        SetVehicleHandlingFloat(
                            vehicle,
                            "CHandlingData",
                            "fDeformationDamageMult",
                            newFDeformationDamageMult * Config.deformationMultiplier
                        )
                    end -- Multiply by our factor
                    if Config.weaponsDamageMultiplier ~= -1 then
                        SetVehicleHandlingFloat(
                            vehicle,
                            "CHandlingData",
                            "fWeaponDamageMult",
                            Config.weaponsDamageMultiplier / Config.damageFactorBody
                        )
                    end -- Set weaponsDamageMultiplier and compensate for damageFactorBody

                    --Get the CollisionDamageMultiplier
                    fCollisionDamageMult = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fCollisionDamageMult")
                    --Modify it by pulling all number a towards 1.0
                    local newFCollisionDamageMultiplier = fCollisionDamageMult ^ Config.collisionDamageExponent -- Pull the handling file value closer to 1
                    SetVehicleHandlingFloat(
                        vehicle,
                        "CHandlingData",
                        "fCollisionDamageMult",
                        newFCollisionDamageMultiplier
                    )

                    --Get the EngineDamageMultiplier
                    fEngineDamageMult = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fEngineDamageMult")
                    --Modify it by pulling all number a towards 1.0
                    local newFEngineDamageMult = fEngineDamageMult ^ Config.engineDamageExponent -- Pull the handling file value closer to 1
                    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fEngineDamageMult", newFEngineDamageMult)

                    -- If body damage catastrophic, reset somewhat so we can get new damage to multiply
                    if healthBodyCurrent < Config.cascadingFailureThreshold then
                        healthBodyNew = Config.cascadingFailureThreshold
                    end
                    pedInSameVehicleLast = true
                end

                -- set the actual new values
                if healthEngineNew ~= healthEngineCurrent then
                    SetVehicleEngineHealth(vehicle, healthEngineNew)
                end
                if healthBodyNew ~= healthBodyCurrent then
                    SetVehicleBodyHealth(vehicle, healthBodyNew)
                end
                if healthPetrolTankNew ~= healthPetrolTankCurrent then
                    SetVehiclePetrolTankHealth(vehicle, healthPetrolTankNew)
                end

                -- Store current values, so we can calculate delta next time around
                healthEngineLast = healthEngineNew
                healthBodyLast = healthBodyNew
                healthPetrolTankLast = healthPetrolTankNew
                lastVehicle = vehicle
                if Config.randomTireBurstInterval ~= 0 and GetEntitySpeed(vehicle) > 10 then
                    tireBurstLottery()
                end
            else
                if pedInSameVehicleLast == true then
                    -- We just got out of the vehicle
                    lastVehicle = GetVehiclePedIsIn(ped, true)
                    if Config.deformationMultiplier ~= -1 then
                        SetVehicleHandlingFloat(
                            lastVehicle,
                            "CHandlingData",
                            "fDeformationDamageMult",
                            fDeformationDamageMult
                        )
                    end -- Restore deformation multiplier
                    SetVehicleHandlingFloat(lastVehicle, "CHandlingData", "fBrakeForce", fBrakeForce) -- Restore Brake Force multiplier
                    if Config.weaponsDamageMultiplier ~= -1 then
                        SetVehicleHandlingFloat(
                            lastVehicle,
                            "CHandlingData",
                            "fWeaponDamageMult",
                            Config.weaponsDamageMultiplier
                        )
                    end -- Since we are out of the vehicle, we should no longer compensate for bodyDamageFactor
                    SetVehicleHandlingFloat(lastVehicle, "CHandlingData", "fCollisionDamageMult", fCollisionDamageMult) -- Restore the original CollisionDamageMultiplier
                    SetVehicleHandlingFloat(lastVehicle, "CHandlingData", "fEngineDamageMult", fEngineDamageMult) -- Restore the original EngineDamageMultiplier
                end
                pedInSameVehicleLast = false
            end
        end
    end
)
function Engine()
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped, false)

    if pedInSameVehicleLast then
        local factor = 1.0
        if healthEngineNew < 900 then
            factor = (healthEngineNew + 200.0) / 1100
        end
        SetVehicleEngineTorqueMultiplier(vehicle, factor)
    end
end

function PedDriving(ped)
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if GetPedInVehicleSeat(vehicle, -1) == ped then
            local vehicleclass = GetVehicleClass(vehicle)
            if vehicleclass ~= 15 and vehicleclass ~= 16 and vehicleclass ~= 21 and vehicleclass ~= 13 then
                return true
            end
        end
    end
    return false
end

function fscale(inputValue, originalMin, originalMax, newBegin, newEnd, curve)
    local OriginalRange = 0.0
    local NewRange = 0.0
    local zeroRefCurVal = 0.0
    local normalizedCurVal = 0.0
    local rangedValue = 0.0
    local invFlag = 0

    if (curve > 10.0) then
        curve = 10.0
    end
    if (curve < -10.0) then
        curve = -10.0
    end

    curve = (curve * -0.1)
    curve = 10.0 ^ curve

    if (inputValue < originalMin) then
        inputValue = originalMin
    end
    if inputValue > originalMax then
        inputValue = originalMax
    end

    OriginalRange = originalMax - originalMin

    if (newEnd > newBegin) then
        NewRange = newEnd - newBegin
    else
        NewRange = newBegin - newEnd
        invFlag = 1
    end

    zeroRefCurVal = inputValue - originalMin
    normalizedCurVal = zeroRefCurVal / OriginalRange

    if (originalMin > originalMax) then
        return 0
    end

    if (invFlag == 0) then
        rangedValue = ((normalizedCurVal ^ curve) * NewRange) + newBegin
    else
        rangedValue = newBegin - ((normalizedCurVal ^ curve) * NewRange)
    end

    return rangedValue
end

function tireBurstLottery()
    local tireBurstNumber = math.random(tireBurstMaxNumber)
    if tireBurstNumber == tireBurstLuckyNumber then
        -- We won the lottery, lets burst a tire.
        if GetVehicleTyresCanBurst(vehicle) == false then
            return
        end
        local numWheels = GetVehicleNumberOfWheels(vehicle)
        local affectedTire
        if numWheels == 2 then
            affectedTire = (math.random(2) - 1) * 4 -- wheel 0 or 4
        elseif numWheels == 4 then
            affectedTire = (math.random(4) - 1)
            if affectedTire > 1 then
                affectedTire = affectedTire + 2
            end -- 0, 1, 4, 5
        elseif numWheels == 6 then
            affectedTire = (math.random(6) - 1)
        else
            affectedTire = 0
        end
        SetVehicleTyreBurst(vehicle, affectedTire, false, 1000.0)
        tireBurstLuckyNumber = math.random(tireBurstMaxNumber) -- Select a new number to hit, just in case some numbers occur more often than others
    end
end

function RequestToSave()
    LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    local LastPosH = GetEntityHeading(GetPlayerPed(-1))
    TriggerServerEvent("sevenlife:safelaspos", LastPosX, LastPosY, LastPosZ, LastPosH)
end
RegisterNetEvent("SevenLife:SafePos:start")
AddEventHandler(
    "SevenLife:SafePos:start",
    function()
        Citizen.CreateThread(
            function()
                while true do
                    Citizen.Wait(25000)
                    RequestToSave()
                    ESX.TriggerServerCallback(
                        "SevenLife:SkillSystem:GetSkillOfStamina",
                        function(data)
                            if data[1] ~= nil then
                                if data[1].obenlinksbutton1 == "true" then
                                    RestorePlayerStamina(PlayerId(), 0.3)
                                end
                                if data[1].obenlinksbutton2 == "true" then
                                    RestorePlayerStamina(PlayerId(), 0.8)
                                end
                            end
                        end
                    )
                end
            end
        )
    end
)

RegisterNetEvent("SevenLife:RepairKit:Use")
AddEventHandler(
    "SevenLife:RepairKit:Use",
    function()
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)

        if IsAnyVehicleNearPoint(coords, 3.0) then
            local vehicle = nil
            if IsPedInAnyVehicle(ped) then
                TriggerEvent("SevenLife:TimetCustom:Notify", "Error", "Du musst ausserhalb des Autos sein", 3000)
            else
                vehicle = GetClosestVehicle(coords, 3.0, 0, 71)
            end
            local hood = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "bonnet"))
            local playerpos = GetEntityCoords(GetPlayerPed(-1), 1)
            local distancetohood = GetDistanceBetweenCoords(hood, playerpos, 1)
            if distancetohood < 2 then
                if DoesEntityExist(vehicle) then
                    SetVehicleDoorOpen(vehicle, 4, false, false)
                    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
                    TriggerServerEvent("SevenLife:RepairKit:RemoveItem")
                    Citizen.CreateThread(
                        function()
                            Citizen.Wait(10000)

                            SetVehicleFixed(vehicle)
                            SetVehicleDeformationFixed(vehicle)
                            SetVehicleUndriveable(vehicle, false)
                            SetVehicleEngineOn(vehicle, true, true)
                            ClearPedTasksImmediately(ped)
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Success", "Auto erfolgreich repariert", 3000)
                            TriggerServerEvent("SevenLife:GameSense:SyncRepairKit", vehicle)

                            TerminateThisThread()
                        end
                    )
                end
            else
                TriggerEvent(
                    "SevenLife:TimetCustom:Notify",
                    "Info",
                    "Gehe zur Motorhaube um das Auto zu reparieren",
                    3000
                )
            end
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Error", "In deiner Nähe steht kein Auto", 3000)
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), "FE_THDR_GTAO", "SevenLifeRP")
    end
)

local BlockedActions = false
local times
local holstered = true
-- Holster
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(15)
            loadAnimDict("rcmjosh4")
            loadAnimDict("reaction@intimidation@cop@unarmed")
            loadAnimDict("reaction@intimidation@1h")
            ped = GetPlayerPed(-1)
            if not IsPedInAnyVehicle(ped, false) then
                if
                    GetVehiclePedIsTryingToEnter(ped) == 0 and
                        (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and
                        not IsPedInParachuteFreeFall(ped)
                 then
                    if CheckWeapon(ped) then
                        if holstered then
                            times = 1
                            BlockedActions = true
                            SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)

                            TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 50, 0, 0, 0, 0)
                            Citizen.Wait(1250)
                            SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
                            Citizen.Wait(1600)
                            ClearPedTasks(ped)
                            Citizen.Wait(100)
                            holstered = false
                        else
                            BlockedActions = false
                            times = 10
                        end
                    else
                        if not holstered then
                            TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 3.0, -1, 50, 0, 0, 0.125, 0)
                            Citizen.Wait(1700)
                            ClearPedTasks(ped)
                            holstered = true
                            BlockedActions = false
                            times = 10
                        end
                    end
                else
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                end
            else
                holstered = true
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            ped = GetPlayerPed(-1)
            if IsPedInAnyVehicle(ped, false) then
                Engine()
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(times)

            if BlockedActions then
                DisableControlAction(1, 25, true)
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
                DisableControlAction(1, 23, true)
                DisableControlAction(1, 37, true)
                DisablePlayerFiring(ped, true)
            end
        end
    end
)

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(500)
    end
end

function CheckWeapon(ped)
    if IsEntityDead(ped) then
        blocked = false
        return false
    else
        for i = 1, #Config.Weapons do
            Citizen.Wait(1)
            if GetHashKey(Config.Weapons[i]) == GetSelectedPedWeapon(ped) then
                return true
            end
        end
        return false
    end
end
local wepononbag = {}
Citizen.CreateThread(
    function()
        while true do
            local ped = PlayerPedId()
            Citizen.Wait(10)
            for name, hash in pairs(Config.configweapon.compatable_weapon_hashes) do
                if HasPedGotWeapon(ped, hash, false) then
                    if not wepononbag[name] and GetSelectedPedWeapon(ped) ~= hash then
                        AttachWeapon(
                            name,
                            hash,
                            Config.configweapon.back_bone,
                            Config.configweapon.x,
                            Config.configweapon.y,
                            Config.configweapon.z,
                            Config.configweapon.x_rotation,
                            Config.configweapon.y_rotation,
                            Config.configweapon.z_rotation,
                            isMeleeWeapon(name)
                        )
                    end
                end
            end
            for name, attached_object in pairs(wepononbag) do
                if
                    GetSelectedPedWeapon(ped) == attached_object.hash or
                        not HasPedGotWeapon(ped, attached_object.hash, false)
                 then
                    DeleteObject(attached_object.handle)
                    wepononbag[name] = nil
                end
            end
        end
    end
)
function AttachWeapon(attachModel, modelHash, boneNumber, x, y, z, xR, yR, zR, isMelee)
    local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
    RequestModel(attachModel)
    while not HasModelLoaded(attachModel) do
        Wait(100)
    end

    wepononbag[attachModel] = {
        hash = modelHash,
        handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
    }

    if isMelee then
        x = 0.11
        y = -0.14
        z = 0.0
        xR = -75.0
        yR = 185.0
        zR = 92.0
    end
    if attachModel == "prop_ld_jerrycan_01" then
        x = x + 0.3
    end

    WeponEntity =
        AttachEntityToEntity(
        wepononbag[attachModel].handle,
        GetPlayerPed(-1),
        bone,
        x,
        y,
        z,
        xR,
        yR,
        zR,
        1,
        1,
        0,
        0,
        2,
        1
    )
end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
        return true
    else
        return false
    end
end
AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        DetachEntity(WeponEntity, 1, true)
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(10)
            if
                (not IsPedArmed(PlayerPedId(), 1)) and
                    (GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("weapon_unarmed"))
             then
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 141, true)
                DisableControlAction(0, 142, true)
            end
        end
    end
)

RegisterNetEvent("SevenLife:GameSense:Client:SyncRepairKit")
AddEventHandler(
    "SevenLife:GameSense:Client:SyncRepairKit",
    function(vehicle)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true)
    end
)
AddEventHandler(
    "gameEventTriggered",
    function(event, args)
        if event == "CEventNetworkEntityDamage" then
            local playerPed = PlayerPedId()
            if playerPed == args[1] then
                local attacker = args[2]
                local weaponHash = args[7]

                if attacker ~= -1 and (weaponHash == 911657153 or weaponHash == -1833087301) then
                    SetTimeout(
                        50,
                        function()
                            local gameTimer = GetGameTimer()
                            if List[attacker] and List[attacker] + 2800 > gameTimer then
                                return
                            end

                            if IsPedBeingStunned(playerPed, 0) then
                                List[attacker] = gameTimer
                                DoTaserEffect()
                            end
                        end
                    )
                end
            end
        end
    end
)
function FadeOutStunnedTimecycle(from)
    local strength = from
    local increments = from / 100

    for _i = 1, 100 do
        Citizen.Wait(50)
        strength = strength - increments

        if stunnedStack >= 1 then
            return
        end

        if strength <= 0 then
            break
        end

        SetTimecycleModifierStrength(strength)
    end

    SetTimecycleModifierStrength(0.0)
    ClearTimecycleModifier()
end

function DoTaserEffect()
    Number = Number + 1
    SetTimecycleModifierStrength(0.5)
    SetTimecycleModifier("dont_tazeme_bro")
    ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.25)

    Citizen.Wait(5000)
    Number = Number - 1
    if Number == 0 then
        FadeOutStunnedTimecycle(0.5)
    end
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)

            if pedInSameVehicleLast then
                local factor = 1.0
                if healthEngineNew < 900 then
                    factor = (healthEngineNew + 200.0) / 1100
                end

                SetVehicleEngineTorqueMultiplier(vehicle, factor)
            end
        end
    end
)
