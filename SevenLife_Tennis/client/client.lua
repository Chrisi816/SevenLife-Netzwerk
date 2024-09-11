CurrentMovementAnim = nil
CurrentMovementShouldSqeak = false
local CourtCenter = vector3(-773.1, 153.71000000001, 67.47)
local BlockControlUntil = 0

Citizen.CreateThread(
    function()
        for k, v in ipairs(Blips) do
            BlipBasketBall(v)
        end
    end
)
function BlipBasketBall(v)
    local blips = v
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 122)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 2)
    SetBlipScale(blip1, 0.9)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Tennis")
    EndTextCommandSetBlipName(blip1)
end

Citizen.CreateThread(
    function()
        while true do
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            for _, courtData in pairs(TennisCourts) do
                if #(coords - courtData.courtCenter) < 50.0 then
                    courtData.isActive = true
                else
                    courtData.isActive = false
                end
                Wait(0)
            end

            Wait(1000)
        end
    end
)
function SetupServingScaleformFully()
    local serveScaleform = setupServeScaleform("TENNIS")

    BeginScaleformMovieMethod(serveScaleform, "SWING_METER_TRANSITION_IN")
    EndScaleformMovieMethod()

    SWING_METER_SET_FILL(serveScaleform, 0.5, 1.0)
    SWING_METER_SET_TARGET(serveScaleform, 0.7, 0.1)
    SWING_METER_POSITION(serveScaleform, 0.7, 0.5)

    return {
        scaleform = serveScaleform,
        isServing = false,
        progress = 1.0,
        progressSpeed = 0.3,
        progressAcceleration = 1.0
    }
end

function HandleServingScaleformTick(scaleformData)
    if scaleformData.isServing then
        scaleformData.progress = scaleformData.progress - scaleformData.progressSpeed * GetFrameTime()
        scaleformData.progressSpeed = scaleformData.progressSpeed + scaleformData.progressAcceleration * GetFrameTime()

        if scaleformData.progress <= 0.0 then
            scaleformData.progressSpeed = scaleformData.progressSpeed * -1
            scaleformData.progressAcceleration = scaleformData.progressAcceleration * -1
            scaleformData.reachedPeak = true
        end

        if scaleformData.progress >= 0.75 and scaleformData.reachedPeak then
            scaleformData.isServing = false
            scaleformData.finalStrength = 0.25
        end

        if isLeftClicked then
            scaleformData.isServing = false
        end
    end

    SET_MARKER(scaleformData.scaleform, scaleformData.progress)
    DrawScaleformMovieFullscreen(scaleformData.scaleform, 255, 255, 255, 255, 0)
end

function setupServeScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    return scaleform
end

function SET_MARKER(serveScaleform, y)
    BeginScaleformMovieMethod(serveScaleform, "SWING_METER_SET_MARKER")
    ScaleformMovieMethodAddParamBool(true)
    ScaleformMovieMethodAddParamFloat(y)
    ScaleformMovieMethodAddParamBool(false)
    ScaleformMovieMethodAddParamFloat(-0.25)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(serveScaleform, "SWING_METER_SET_APEX_MARKER")
    ScaleformMovieMethodAddParamBool(true)
    ScaleformMovieMethodAddParamFloat(y + 0.002)
    ScaleformMovieMethodAddParamBool(false)
    ScaleformMovieMethodAddParamFloat(-0.25)
    EndScaleformMovieMethod()
end

function SWING_METER_SET_FILL(iParam0, fParam1, fParam2)
    BeginScaleformMovieMethod(iParam0, "SWING_METER_SET_FILL")
    ScaleformMovieMethodAddParamFloat(fParam1)
    ScaleformMovieMethodAddParamFloat(fParam2)
    EndScaleformMovieMethod()
end

function SWING_METER_POSITION(iParam0, fParam1, fParam2)
    BeginScaleformMovieMethod(iParam0, "SWING_METER_POSITION")
    ScaleformMovieMethodAddParamFloat(fParam1)
    ScaleformMovieMethodAddParamFloat(fParam2)
    ScaleformMovieMethodAddParamBool(true)
    EndScaleformMovieMethod()
end

function SWING_METER_SET_TARGET(iParam0, fParam1, fParam2)
    BeginScaleformMovieMethod(iParam0, "SWING_METER_SET_TARGET")
    ScaleformMovieMethodAddParamFloat(fParam1)
    ScaleformMovieMethodAddParamFloat(fParam2)
    EndScaleformMovieMethod()
end

function SWING_METER_SET_TARGET_COLOR(iParam0, r, g, b, a)
    BeginScaleformMovieMethod(iParam0, "SWING_METER_SET_TARGET_COLOR")
    ScaleformMovieMethodAddParamFloat(iParam0, r / 255)
    ScaleformMovieMethodAddParamFloat(iParam0, g / 255)
    ScaleformMovieMethodAddParamFloat(iParam0, b / 255)
    ScaleformMovieMethodAddParamFloat(iParam0, a / 255)
    EndScaleformMovieMethod()
end
DIST_SPEED = {
    CONST_DIST_CLOSE = 19.0,
    CONST_DIST_NORMAL = 20.0,
    CONST_DIST_DIVE = 15.0
}

function ComputeAfterHitVelocity(heading, distName, isServe)
    heading = heading * -1
    local isW = IsDisabledControlPressed(0, 32)
    local isS = IsDisabledControlPressed(0, 33)
    local isA = IsDisabledControlPressed(0, 34)
    local isD = IsDisabledControlPressed(0, 35)

    local vertDist = 0.25
    local fwdDist = 0.9
    local horizontalDist = 0.0

    if isServe then
        vertDist = 0.15
    end

    if isW and isA then
        vertDist = 0.15
        fwdDist = 1.15
        horizontalDist = -0.25
    elseif isW and isD then
        vertDist = 0.15
        fwdDist = 1.15
        horizontalDist = 0.25
    elseif isS and isA then
        if isServe then
            horizontalDist = -0.35
        else
            vertDist = 0.2
            fwdDist = 0.2
            horizontalDist = -0.2
        end
    elseif isS and isD then
        if isServe then
            horizontalDist = 0.35
        else
            vertDist = 0.2
            fwdDist = 0.2
            horizontalDist = 0.2
        end
    elseif isA then
        if isServe then
            horizontalDist = -0.25
        else
            horizontalDist = -0.19
        end
    elseif isD then
        if isServe then
            horizontalDist = 0.25
        else
            horizontalDist = 0.19
        end
    elseif isW then
        vertDist = 0.15
        fwdDist = 1.15
    elseif isS then
        vertDist = 0.3
        fwdDist = 0.5
    end

    rndHorizontalDist = math.random(-1000, 1000) / 30000
    rndFwdDist = math.random(0, 1000) / 30000
    rndVertDist = math.random(-500, 1000) / 30000

    local finalStraightVelocity =
        vector3(horizontalDist + rndHorizontalDist, fwdDist + rndFwdDist, vertDist + rndVertDist) * DIST_SPEED[distName]

    local adjustedVec = rotateVec3(finalStraightVelocity, vector3(0.0, 0.0, 1.0), math.rad(heading))

    return adjustedVec
end

function applyMatrixRowsToVec3(v, r1, r2, r3)
    local dot1 = v.x * r1.x + v.y * r1.y + v.z * r1.z
    local dot2 = v.x * r2.x + v.y * r2.y + v.z * r2.z
    local dot3 = v.x * r3.x + v.y * r3.y + v.z * r3.z

    return vector3(dot1, dot2, dot3)
end

function rotationVectors(u, angle)
    local c = math.cos(angle)
    local s = math.sin(angle)
    local d = 1 - c
    local su = s * u
    local du = d * u
    local r1 = du.x * u + vector3(c, su.z, -su.y)
    local r2 = du.y * u + vector3(-su.z, c, su.x)
    local r3 = du.z * u + vector3(su.y, -su.x, c)
    return r1, r2, r3
end

function rotateVec3(v, u, angle)
    return applyMatrixRowsToVec3(v, rotationVectors(u, angle))
end

BallEntity = nil
BallPosition = nil
BallVelocity = nil
PredictedCollisionCoords = nil
COLLISION_SHAPETEST_FLAG = 1 + 2 + 4 + 16

RegisterNetEvent("SevenLife:Tennis:SetData")
AddEventHandler(
    "SevenLife:Tennis:SetData",
    function(senderServerId, courtName, hitType, pos, velocity)
        local player = GetPlayerFromServerId(senderServerId)

        if NetworkIsPlayerActive(player) then
            local ped = GetPlayerPed(player)

            PlaySoundFromEntity(-1, "TENNIS_PLYR_SMASH_MASTER", ped, 0, false, 0)

            if TennisCourts[courtName].entity and DoesEntityExist(TennisCourts[courtName].entity) then
                DeleteEntity(TennisCourts[courtName].entity)
            end

            if TennisCourts[courtName].ptfx then
                StopParticleFxLooped(TennisCourts[courtName].ptfx, 1)
            end
            TennisCourts[courtName].ballPos = pos
            TennisCourts[courtName].spin = hitType
            TennisCourts[courtName].ballVelocity = velocity
            TennisCourts[courtName].predictedCollisionCoords =
                ComputeFirstGroundCollisionPosition(
                TennisCourts[courtName].spin,
                TennisCourts[courtName].ballPos,
                TennisCourts[courtName].ballVelocity,
                TennisCourts[courtName].z
            )
            TennisCourts[courtName].entity =
                CreateObject("prop_tennis_ball", TennisCourts[courtName].ballPos, false, false, false)
        end
    end
)

RegisterNetEvent("SevenLife:Tennis:SetDataInHand")
AddEventHandler(
    "SevenLife:Tennis:SetDataInHand",
    function(senderServerId, courtName)
        local player = GetPlayerFromServerId(senderServerId)

        if NetworkIsPlayerActive(player) then
            local ped = GetPlayerPed(player)

            if TennisCourts[courtName].entity and DoesEntityExist(TennisCourts[courtName].entity) then
                DeleteEntity(TennisCourts[courtName].entity)
            end

            if TennisCourts[courtName].ptfx then
                StopParticleFxLooped(TennisCourts[courtName].ptfx, 1)
            end

            TennisCourts[courtName].ballPos = nil
            TennisCourts[courtName].spin = nil
            TennisCourts[courtName].ballVelocity = nil
            TennisCourts[courtName].predictedCollisionCoords = nil

            local coords = GetEntityCoords(ped)

            TennisCourts[courtName].entity =
                CreateObject("prop_tennis_ball", coords.x, coords.y, coords.z + 2.0, false, false, false)
            AttachEntityToEntity(
                TennisCourts[courtName].entity,
                ped,
                GetPedBoneIndex(ped, 60309),
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                1,
                0,
                0,
                0,
                2,
                1
            )
        end
    end
)

function OnBallCollision(courtName, collisionCoords, collisionMaterial, collisionEntity)
    if PlayerSettings and PlayerSettings.courtName == courtName then
        local ballHitData =
            GetPointData(
            TennisCourts[courtName].courtCenter,
            TennisCourts[courtName].courtHeading,
            TennisCourts[courtName].courtWidth,
            TennisCourts[courtName].courtLength,
            collisionCoords
        )

        if not ballHitData.isInArea then
        elseif collisionMaterial == 122789469 then
        else
            local abSide = ballHitData.isASide and "a" or "b"
            local lrSide = ballHitData.isLeftSide and "left" or "right"
        end
    end
end

Citizen.CreateThread(
    function()
        Citizen.Wait(2000)

        StartAudioScene("TENNIS_SCENE")

        RequestScriptAudioBank("SCRIPT\\Tennis", false, -1)
        RequestScriptAudioBank("SCRIPT\\TENNIS_VER2_A", false, -1)

        local isCollisionDisabled = false

        while true do
            Citizen.Wait(1)

            local frameTime = GetFrameTime()
            local gameTimer = GetGameTimer()

            for courtName, courtData in pairs(TennisCourts) do
                if courtData.isActive and courtData.ballPos then
                    if gameTimer > courtData.collisionSuspendedUntil then
                        courtData.collisionSuspendedUntil = gameTimer + 100
                        courtData.isCollisionActive =
                            ShouldCollisionBeActive(
                            courtData.entity,
                            courtData.z,
                            courtData.spin,
                            courtData.ballPos,
                            courtData.ballVelocity
                        )
                    end

                    courtData.ballPos, courtData.ballVelocity, collisionCoords, collisionMaterial, collisionEntity =
                        SimulatePhysicsStep(
                        frameTime,
                        courtData.spin,
                        courtData.ballPos,
                        courtData.ballVelocity,
                        courtData.z,
                        courtData.isCollisionActive,
                        not isCollisionDisabled
                    )

                    HandleBallTrailer(courtData)

                    isCollisionDisabled = false

                    if collisionCoords then
                        courtData.spin = CONST_HIT_NORMAL
                        isCollisionDisabled = true
                        Citizen.CreateThread(
                            function()
                                courtData.predictedCollisionCoords =
                                    ComputeFirstGroundCollisionPosition(
                                    courtData.spin,
                                    courtData.ballPos,
                                    courtData.ballVelocity,
                                    courtData.z
                                )
                            end
                        )

                        OnBallCollision(courtName, collisionCoords, collisionMaterial, collisionEntity)
                    end

                    if courtData.predictedCollisionCoords then
                        DrawMarker(
                            25,
                            courtData.predictedCollisionCoords.x,
                            courtData.predictedCollisionCoords.y,
                            courtData.predictedCollisionCoords.z + 0.03,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.5,
                            0.5,
                            0.5,
                            255,
                            255,
                            255,
                            150,
                            false,
                            false,
                            false,
                            false,
                            nil,
                            nil,
                            false
                        )
                    end

                    SetEntityCoordsNoOffset(
                        courtData.entity,
                        courtData.ballPos + vector3(0.0, 0.0, Config.BallRadius),
                        false,
                        false,
                        false
                    )
                end
            end
        end
    end
)

function ShouldCollisionBeActive(ent, groundZ, spin, pos, velocity)
    local endPos, _, _ = SimulatePhysicsStep(130 / 1000, spin, pos, velocity, groundZ, false)

    local capsuleRay = StartShapeTestCapsule(pos, endPos, 0.2, COLLISION_SHAPETEST_FLAG, ent, 4)
    local retval, hit = GetShapeTestResult(capsuleRay)

    return hit == 1
end

function ComputeFirstGroundCollisionPosition(spin, ballPos, ballVel, groundZ)
    local frameTime = GetFrameTime()
    local fps = 1 / frameTime
    local predictFrames = fps * 4

    local intersperse = 10

    for i = 1, predictFrames do
        if intersperse <= 0 then
            Wait(0)
            intersperse = 10
        end
        intersperse = intersperse - 1
        ballPos, ballVel, collisionCoords = SimulatePhysicsStep(frameTime, spin, ballPos, ballVel, groundZ, true)

        if collisionCoords then
            spin = CONST_HIT_NORMAL
        end

        if collisionCoords and (collisionCoords.z - groundZ) < 0.05 then
            return collisionCoords
        end
    end

    return nil
end

function PredictBallPosition(spin, ballPos, ballVel, groundZ)
    local elapsedMs = 0
    local secondsToPredict =
        math.max(ANIM_HIT_DELAY[CONST_DIST_CLOSE], ANIM_HIT_DELAY[CONST_DIST_NORMAL], ANIM_HIT_DELAY[CONST_DIST_DIVE]) +
        0.2
    local frameTime = GetFrameTime()

    local predictionPoints = {
        CONST_DIST_CLOSE = false,
        CONST_DIST_NORMAL = false,
        CONST_DIST_DIVE = false
    }

    while secondsToPredict > 0 do
        ballPos, ballVel, collision = SimulatePhysicsStep(frameTime, spin, ballPos, ballVel, groundZ, true, false)

        if collision then
            spin = CONST_HIT_NORMAL
        end

        secondsToPredict = secondsToPredict - frameTime
        elapsedMs = elapsedMs + frameTime * 1000

        for dist, pos in pairs(predictionPoints) do
            if not pos and ANIM_HIT_DELAY[dist] <= elapsedMs then
                predictionPoints[dist] = {pos = ballPos, vel = ballVel}
            end
        end
    end

    Citizen.Wait(1)

    local closestDistAbs = nil
    local closestPos = nil
    local closestVel = nil
    local closestSide = nil
    local closestDistName = nil

    local ped = PlayerPedId()

    for _, side in pairs({CONST_SIDE_BACKHAND, CONST_SIDE_FOREHAND}) do
        for _, dist in pairs({CONST_DIST_CLOSE, CONST_DIST_NORMAL, CONST_DIST_DIVE}) do
            local relOffset = ANIM_DIST_OFFSET[side][dist]
            local offsetCoords = GetOffsetFromEntityInWorldCoords(ped, relOffset.x, relOffset.y, 0.0)

            local nowDist = #(offsetCoords - predictionPoints[dist].pos)

            if not closestDistAbs or closestDistAbs > nowDist then
                if dist ~= CONST_DIST_DIVE or nowDist < 3.0 then
                    closestDistAbs = nowDist
                    closestPos = predictionPoints[dist].pos
                    closestVel = predictionPoints[dist].vel
                    closestSide = side
                    closestDistName = dist
                end
            end
        end
    end

    return closestSide, closestDistName, closestPos, closestVel
end

function SimulatePhysicsStep(frameTime, spin, ballPos, ballVel, groundZ, detectCollision, shakeNet)
    local isOnGround = (ballPos.z - groundZ) < 0.01 and ballVel.z <= 0.01
    local collisionCoords = nil
    local collisionEntHit = nil
    local collisionMaterial = nil

    if #ballVel < 0.04 then
        ballVel = vector3(0.0, 0.0, 0.0)
    else
        if isOnGround then
            ballVel = ballVel - ballVel * Config.RollingResistance * frameTime
        else
            ballVel = ballVel + Config.Gravity[spin] * frameTime
            ballVel = ballVel - ballVel * Config.Drag * frameTime
        end

        local candidateNewBallPos = ballPos + ballVel * frameTime

        if detectCollision then
            local ray =
                StartExpensiveSynchronousShapeTestLosProbe(ballPos, candidateNewBallPos, COLLISION_SHAPETEST_FLAG, 0, 0)
            local retval, hit, endCoords, surfaceNormal, material, hitEnt = GetShapeTestResultEx(ray)

            if hit == 1 then
                local isNetCollision = material == 122789469

                if isNetCollision then
                    ballVel = ballVel * 0.3
                end

                if shakeNet and (isNetCollision or material == 125958708) then
                    if isNetCollision then
                        PlaySoundFromCoord(
                            -1,
                            "TENNIS_NET_BALL_MEDIUM_MASTER",
                            ballPos.x,
                            ballPos.y,
                            ballPos.z,
                            0,
                            false,
                            0,
                            1
                        )
                    end

                    for i = -6, 6 do
                        local impulseVector = (ballVel / #ballVel) * 0.5
                        local impulseStart = ballPos - impulseVector * (i / 20)

                        ApplyImpulseToCloth(
                            impulseStart.x,
                            impulseStart.y,
                            impulseStart.z,
                            impulseVector.x,
                            impulseVector.y,
                            impulseVector.z,
                            2.0
                        )
                    end
                elseif shakeNet then
                    PlayBallHitSound(ballPos, ballVel, material)
                end

                local reflectedBallVec = ballVel - 2 * ballVel * (surfaceNormal * surfaceNormal * Config.BallElasticity)
                reflectedBallVec = reflectedBallVec / #reflectedBallVec * #ballVel

                local distToCollision = #(ballPos - endCoords)
                local distFull = #(ballVel * frameTime)

                local portionToCollision = distToCollision / distFull

                local newBallVec = reflectedBallVec * Config.GroundBounceEnergyLoss
                collisionCoords = endCoords
                collisionEntHit = hitEnt
                collisionMaterial = material

                if newBallVec.z <= Config.StopHorizontalBounceTreshold and isOnGround then
                    local zPortion = newBallVec.z / #newBallVec
                    newBallVec = vector3(newBallVec.x * (1.0 + zPortion / 2), newBallVec.y * (1.0 + zPortion / 2), 0.0)

                    ballPos = vector3(ballPos.x, ballPos.y, groundZ)
                end

                ballPos =
                    ballPos + (ballVel * frameTime) * portionToCollision +
                    (newBallVec * frameTime) * (1.0 - portionToCollision)
                ballVel = newBallVec

                ReleaseScriptGuidFromEntity(ray)
                ReleaseScriptGuidFromEntity(hitEnt)
            else
                ballPos = candidateNewBallPos
            end
        else
            ballPos = candidateNewBallPos
        end
    end

    return ballPos, ballVel, collisionCoords, collisionMaterial, collisionEntHit
end

function PlayBallHitSound(pos, velocity, material)
    if #velocity > 1.5 then
        PlaySoundFromCoord(-1, "TENNIS_CLS_BALL_MASTER", pos.x, pos.y, pos.z, 0, false, 0, 1)
    end
end

AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end

        for _, courtData in pairs(TennisCourts) do
            DeleteEntity(courtData.entity)
        end
    end
)

function HandleBallTrailer(courtData)
    local pos = courtData.ballPos

    if not HasNamedPtfxAssetLoaded("scr_minigametennis") then
        RequestNamedPtfxAsset("scr_minigametennis")
    else
        if #courtData.ballVelocity > 0.1 then
            if not courtData.ptfx or not DoesParticleFxLoopedExist(courtData.ptfx) then
                UseParticleFxAssetNextCall("scr_minigametennis")
                courtData.ptfx =
                    StartParticleFxLoopedAtCoord(
                    "scr_tennis_ball_trail",
                    pos.x,
                    pos.y,
                    pos.z,
                    0.0,
                    0.0,
                    0.0,
                    1065353216,
                    0,
                    0,
                    0,
                    true
                )
                SetParticleFxLoopedColour(courtData.ptfx, 255 / 255, 234 / 255, 8 / 255, false)
            else
                SetParticleFxLoopedOffsets(courtData.ptfx, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0)
            end
        elseif courtData.ptfx and DoesParticleFxLoopedExist(courtData.ptfx) then
            StopParticleFxLooped(courtData.ptfx, 1)
            courtData.ptfx = nil
        end
    end
end
CONST_SIDE_A = "a"
CONST_SIDE_B = "b"

PlayerSettings = nil

notifys = true
inmarkers = false
inmenu = false
timemain = 100
local courtid = nil
local positionNames = nil
local side = nil

Citizen.CreateThread(
    function()
        while true do
            if not PlayerSettings then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)

                for courtIdx, courtData in pairs(TennisCourts) do
                    local courtCenter = courtData.courtCenter
                    local courtHeading = courtData.courtHeading
                    local serverPointLength = courtData.courtLength + 0.7
                    local serverPointWide = courtData.courtWidth / 3

                    local aSideServePoint =
                        vector3(
                        courtCenter.x + math.cos(math.rad(courtHeading + 90.0)) * serverPointLength +
                            math.cos(math.rad(courtHeading + 180.0)) * serverPointWide,
                        courtCenter.y + math.sin(math.rad(courtHeading + 90.0)) * serverPointLength +
                            math.sin(math.rad(courtHeading + 180.0)) * serverPointWide,
                        courtCenter.z - 0.1
                    )

                    local bSideServePoint =
                        vector3(
                        courtCenter.x + math.cos(math.rad(courtHeading - 90.0)) * serverPointLength +
                            math.cos(math.rad(courtHeading + 0.0)) * serverPointWide,
                        courtCenter.y + math.sin(math.rad(courtHeading - 90.0)) * serverPointLength +
                            math.sin(math.rad(courtHeading + 0.0)) * serverPointWide,
                        courtCenter.z - 0.1
                    )

                    local distance1 =
                        GetDistanceBetweenCoords(coords, aSideServePoint.x, aSideServePoint.y, aSideServePoint.z, true)
                    local distance2 =
                        GetDistanceBetweenCoords(coords, bSideServePoint.x, bSideServePoint.y, bSideServePoint.z, true)
                    if distance1 or distance2 < 30 then
                        courtid = courtIdx

                        HandleServePoint(ped, coords, courtIdx, CONST_SIDE_A, aSideServePoint)
                        HandleServePoint(ped, coords, courtIdx, CONST_SIDE_B, bSideServePoint)
                    end
                end

                Citizen.Wait(0)
            else
                Wait(1000)
            end
        end
    end
)
function HandleServePoint(ped, coords, courtIdx, positionName, serverPointCoords)
    local distance =
        GetDistanceBetweenCoords(coords, serverPointCoords.x, serverPointCoords.y, serverPointCoords.z, true)

    if distance < 15 then
        courtid = courtIdx
        timemain = 15
        DrawMarker(
            20,
            serverPointCoords.x,
            serverPointCoords.y,
            serverPointCoords.z + 1,
            0,
            0,
            0,
            0,
            0,
            0,
            0.6,
            0.6,
            0.6,
            234,
            0,
            122,
            200,
            1,
            1,
            0,
            0
        )

        if distance < 2 then
            positionNames = positionName
            inmarker = true
            if notifys then
                TriggerEvent(
                    "sevenliferp:startnui",
                    "Drücke <span1 color = white>E</span1> um Tennis zu spielen!",
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
        timemain = 100
    end
end

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(6)
            if inmarker then
                if IsControlJustPressed(0, 38) and courtid ~= nil and positionNames ~= nil then
                    if inmenu == false then
                        savedname = courtid

                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        SendNUIMessage(
                            {
                                type = "OpenHelpMenu"
                            }
                        )
                        inmenu = true
                        TriggerServerEvent("SevenLife:Tennis:GetPos", courtid, positionNames)
                        Citizen.Wait(500)
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

function DrawText3DTest(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent("SevenLife:Tennis:Position")
AddEventHandler(
    "SevenLife:Tennis:Position",
    function(courtName, positionName, isServing)
        PlayerSettings = {}
        PlayerSettings.courtName = courtName
        PlayerSettings.side = positionName
        PlayerSettings.isServing = isServing

        StartTennisWorker(PlayerPedId(), TennisCourts[courtName], positionName)
    end
)

function GetServeExtremePoints(courtCenter, courtHeading, courtLength, courtWidth, side)
    local sideOffsetHeading = 0

    if side == CONST_SIDE_A then
        sideOffsetHeading = 180.0
    end

    local centerPoint1 =
        vector3(
        courtCenter.x + math.cos(math.rad(courtHeading - 90.0 + sideOffsetHeading)) * (courtLength - 2.0),
        courtCenter.y + math.sin(math.rad(courtHeading - 90.0 + sideOffsetHeading)) * (courtLength - 2.0),
        courtCenter.z
    )
    local centerPoint2 =
        vector3(
        courtCenter.x + math.cos(math.rad(courtHeading - 90.0 + sideOffsetHeading)) * (courtLength + 3.0),
        courtCenter.y + math.sin(math.rad(courtHeading - 90.0 + sideOffsetHeading)) * (courtLength + 3.0),
        courtCenter.z
    )

    local rightPoint1 =
        vector3(
        centerPoint1.x + math.cos(math.rad(courtHeading + sideOffsetHeading)) * (courtWidth / 2 + 0.75),
        centerPoint1.y + math.sin(math.rad(courtHeading + sideOffsetHeading)) * (courtWidth / 2 + 0.75),
        centerPoint1.z
    )

    local rightPoint2 =
        vector3(
        centerPoint2.x + math.cos(math.rad(courtHeading + sideOffsetHeading)) * (courtWidth / 2 + 0.75),
        centerPoint2.y + math.sin(math.rad(courtHeading + sideOffsetHeading)) * (courtWidth / 2 + 0.75),
        centerPoint2.z
    )

    return {centerPoint1, centerPoint2}, {rightPoint1, rightPoint2}
end

function HandleServingFuly(ped, courtPtr, side)
    TaskPlayAnim(ped, "mini@tennis", "serve_idle_01", 4.0, 4.0, -1, 1, 1.0, false, false, false)
    local scaleformData = SetupServingScaleformFully()

    while PlayerSettings do
        Wait(0)

        DisablePlayerFiring(PlayerId(), true)
        DisableAllControlActions(0)
        EnableControlAction(0, 249, true)
        EnableControlAction(0, 245, true)

        EnableControlAction(0, 0, true)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)

        local finalHeading = courtPtr.courtHeading + (side == CONST_SIDE_A and 180.0 or 0.0)
        SetEntityHeading(ped, finalHeading)

        local isLeftClick = IsDisabledControlJustPressed(0, 24)
        local isA = IsDisabledControlPressed(0, 34)
        local isD = IsDisabledControlPressed(0, 35)

        local leftmost, rightmost =
            GetServeExtremePoints(
            courtPtr.courtCenter,
            courtPtr.courtHeading,
            courtPtr.courtLength,
            courtPtr.courtWidth,
            side
        )

        if GetGameTimer() > BlockControlUntil then
            if isLeftClick then
                PlayMovementAnim(ped, "serve", true, true)
                local clickedStartAt = GetGameTimer()
                local isHitSubmitted = false

                while true do
                    Wait(0)

                    local timePassed = (GetGameTimer() - clickedStartAt)

                    if timePassed <= 3550 then
                        if timePassed > 1000 then
                            HandleServingScaleformTick(scaleformData)
                        end

                        if not scaleformData.isServing and not scaleformData.finalStrength and timePassed > 2000 then
                            scaleformData.isServing = true
                        end

                        if scaleformData.isServing and IsDisabledControlJustPressed(0, 24) then
                            scaleformData.isServing = false
                            scaleformData.finalStrength = math.max(0.0, math.min(1.0, 1.0 - scaleformData.progress))
                        end
                    elseif not isHitSubmitted then
                        isHitSubmitted = true

                        local hitVector = ComputeAfterHitVelocity(finalHeading, CONST_DIST_NORMAL, true)
                        local finalStrength = (scaleformData.finalStrength or 0.25) * 1.1

                        TriggerServerEvent(
                            "SevenLife:Tennis:MakeBallData",
                            PlayerSettings.courtName,
                            CONST_HIT_NORMAL,
                            GetEntityCoords(courtPtr.entity),
                            hitVector * finalStrength
                        )
                    elseif timePassed > 5000 then
                        break
                    end
                end

                return
            elseif isA and not IsEntityInAngledArea(ped, leftmost[1], leftmost[2], 1.0, false, false, false) then
                PlayMovementAnim(ped, "serve_walk_l", true, true) -- strafe_lft
            elseif isD and not IsEntityInAngledArea(ped, rightmost[1], rightmost[2], 1.0, false, false, false) then
                PlayMovementAnim(ped, "serve_walk_r", true, true) -- strafe_rt
            else
                StopMovementAnimIfPlaying(ped, true, "serve_idle_01")
            end
        end
    end
end

RacketEntity = nil

function EnsureRacketEntity(ped, coords)
    RacketEntity = CreateObject("prop_tennis_rack_01b", coords + vector3(0.0, 1.0, 0.0), true, false, false)
    AttachEntityToEntity(RacketEntity, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 0, 0, 0, 2, 1)
end

AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end

        DeleteEntity(RacketEntity)
    end
)

function StartTennisWorker(ped, courtPtr, side)
    local coords = GetEntityCoords(ped)

    LoadAnimDict("mini@tennis")
    LoadAnimDict("weapons@tennis@male")

    EnsureRacketEntity(ped, coords)

    if PlayerSettings.isServing then
        HandleServingFuly(ped, courtPtr, side)
    else
        TaskPlayAnim(ped, "mini@tennis", "idle_fh", 4.0, 4.0, -1, 1, 1.0, false, false, false)
    end

    while PlayerSettings do
        Wait(0)
        DisablePlayerFiring(PlayerId(), true)
        DisableAllControlActions(0)
        EnableControlAction(0, 249, true)
        EnableControlAction(0, 245, true)

        EnableControlAction(0, 0, true)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)

        local isW = IsDisabledControlPressed(0, 32)
        local isS = IsDisabledControlPressed(0, 33)
        local isA = IsDisabledControlPressed(0, 34)
        local isD = IsDisabledControlPressed(0, 35)
        local isX = IsDisabledControlPressed(0, 73)
        local ped = PlayerPedId()

        local isSpaceClick = IsDisabledControlJustPressed(0, 22)
        local isLeftClick = IsDisabledControlJustPressed(0, 24)
        local isRightClick = IsDisabledControlJustPressed(0, 25)

        SetEntityHeading(ped, courtPtr.courtHeading + (side == CONST_SIDE_A and 180.0 or 0.0))

        if GetGameTimer() > BlockControlUntil then
            if isLeftClick then
                HandleAttemptHitBall(ped, PlayerSettings.courtName, CONST_HIT_NORMAL)
            elseif isSpaceClick then
                HandleAttemptHitBall(ped, PlayerSettings.courtName, CONST_HIT_BACKSPIN)
            elseif isRightClick then
                HandleAttemptHitBall(ped, PlayerSettings.courtName, CONST_HIT_TOPSPIN)
            elseif isW and isA then
                PlayMovementAnim(ped, "run_fwd_-45", false, true)
            elseif isW and isD then
                PlayMovementAnim(ped, "run_fwd_45", false, true)
            elseif isS and isA then
                PlayMovementAnim(ped, "run_bwd_-135", false, true)
            elseif isS and isD then
                PlayMovementAnim(ped, "run_bwd_135", false, true)
            elseif isW then
                PlayMovementAnim(ped, "run_fwd_0", false, true)
            elseif isS then
                PlayMovementAnim(ped, "strafe_bwd", false, true)
            elseif isA then
                PlayMovementAnim(ped, "run_bwd_-90_loop", true, true)
            elseif isD then
                PlayMovementAnim(ped, "run_fwd_90_loop", true, true)
            elseif isX then
                PlayerSettings = nil
                notifys = true
                inmenu = false
                SendNUIMessage(
                    {
                        type = "CloseHelpMenu"
                    }
                )
                --  StopAnimTask(PlayerPedId(), "mini@tennis", CurrentMovementAnim, 1.0)
                --StopAnimTask(PlayerPedId(), "mini@tennis", CurrentMovementAnim .. "_loop", 1.0)
                StopMovementAnimIfPlaying(ped, true, "serve_idle_01")
                CurrentMovementAnim = nil
                CurrentMovementShouldSqeak = false
                ClearPedTasks(PlayerPedId())
                ClearPedSecondaryTask(PlayerPedId())
                BlockControlUntil = 0
                BallEntity = nil
                BallPosition = nil
                BallVelocity = nil
                PredictedCollisionCoords = nil
                COLLISION_SHAPETEST_FLAG = 1 + 2 + 4 + 16
                RacketEntity = nil
                DeleteEntity(RacketEntity)
                TriggerServerEvent("SevenLife:Tennis:Clean", savedname)
                DeleteEntity(BallEntity)
            else
                if CurrentMovementShouldSqeak then
                    PlaySoundFromEntity(-1, "TENNIS_FOOT_SQUEAKS_MASTER", ped, 0, false, 0)
                    CurrentMovementShouldSqeak = false
                end

                StopMovementAnimIfPlaying(ped, true)
            end
        end
    end
end

function HandleAttemptHitBall(ped, courtName, hitType)
    local side, distName, ballPos, ballVel =
        PredictBallPosition(
        TennisCourts[courtName].spin,
        TennisCourts[courtName].ballPos,
        TennisCourts[courtName].ballVelocity,
        TennisCourts[courtName].z
    )

    local groundDist = ComputeGroundHitDist(ped, ballPos)

    PlayHitBallAnim(
        PlayerPedId(),
        ANIM_TREE[side][distName][hitType][groundDist],
        side,
        distName,
        hitType,
        TennisCourts[courtName],
        ballPos
    )
end

function ComputeGroundHitDist(ped, ballPos)
    local pedCoords = GetEntityCoords(ped)

    local zDiff = (ballPos.z + Config.BallRadius) - pedCoords.z

    local loDist = math.abs(zDiff - ANIM_GND_DIST_OFFSET[CONST_GND_DIST_LO])
    local mdDist = math.abs(zDiff - ANIM_GND_DIST_OFFSET[CONST_GND_DIST_MD])
    local hiDist = math.abs(zDiff - ANIM_GND_DIST_OFFSET[CONST_GND_DIST_HI])

    if loDist < mdDist and loDist < hiDist then
        return CONST_GND_DIST_LO
    end

    if mdDist < loDist and mdDist < hiDist then
        return CONST_GND_DIST_MD
    end

    if hiDist < mdDist and hiDist < loDist then
        return CONST_GND_DIST_HI
    end

    return CONST_GND_DIST_MD
end

local AnimToIdle = {
    ["forehand_ts_md"] = "idle_bh",
    ["run_fwd_-45"] = "idle_bh",
    ["run_fwd_45"] = "idle_fh",
    ["run_bwd_-135"] = "idle_bh",
    ["run_bwd_135"] = "idle_fh",
    ["run_fwd_0"] = "idle_bh",
    ["strafe_bwd"] = "idle_fh",
    ["run_bwd_-90_loop"] = "idle_bh",
    ["run_fwd_90_loop"] = "idle_fh"
}

local lastSidewaysAnim = nil

function StopMovementAnimIfPlaying(ped, setIdle, forcedIdleAnim)
    if CurrentMovementAnim then
        StopAnimTask(ped, "mini@tennis", CurrentMovementAnim, 1.0)
        StopAnimTask(ped, "mini@tennis", CurrentMovementAnim .. "_loop", 1.0)

        if setIdle then
            CurrentMovementAnim =
                forcedIdleAnim or AnimToIdle[lastSidewaysAnim] or AnimToIdle[CurrentMovementAnim] or "idle_fh"
            TaskPlayAnim(ped, "mini@tennis", CurrentMovementAnim, 4.0, 4.0, -1, 1, 1.0, false, false, false)
            lastSidewaysAnim = nil
        end

        CurrentMovementShouldSqeak = false
        CurrentMovementAnim = nil
    end
end

function PlayMovementAnim(ped, anim, skipIntro, shouldSqeak)
    if anim ~= CurrentMovementAnim then
        StopMovementAnimIfPlaying(ped)
        CurrentMovementAnim = anim

        local isFwdOrBwdMove = CurrentMovementAnim == "strafe_bwd" or CurrentMovementAnim == "run_fwd_0"

        if not isFwdOrBwdMove then
            lastSidewaysAnim = CurrentMovementAnim
        end

        CurrentMovementShouldSqeak = shouldSqeak

        if skipIntro then
            TaskPlayAnim(ped, "mini@tennis", anim, 4.0, 4.0, -1, 1, 1.0, false, false, false)
        else
            TaskPlayAnim(ped, "mini@tennis", anim .. "_intro", 4.0, 4.0, -1, 0, 1.0, false, false, false)
            TaskPlayAnim(ped, "mini@tennis", anim .. "_loop", 4.0, 4.0, -1, 1, 1.0, false, false, false)
        end
    end
end

function PlayHitBallAnim(ped, name, side, distName, hitType, courtPtr, predictedBallPos)
    local animDuration = tonumber(math.floor(GetAnimDuration("mini@tennis", name) * 1000))

    CurrentMovementAnim = nil
    TaskPlayAnim(ped, "mini@tennis", name, 4.0, 4.0, animDuration - 200, 1, 1.0, false, false, false)
    BlockControlUntil = GetGameTimer() + animDuration - 200

    Citizen.SetTimeout(
        animDuration - 200,
        function()
            CurrentMovementAnim = name
            if side == CONST_SIDE_BACKHAND then
                lastSidewaysAnim = "run_fwd_0"
            else
                lastSidewaysAnim = "strafe_bwd"
            end
        end
    )

    Citizen.SetTimeout(
        math.max(1, ANIM_HIT_DELAY[distName] - 150),
        function()
            local racketCoords = GetOffsetFromEntityInWorldCoords(RacketEntity, 0.0, 0.0, 0.4)

            if #(racketCoords.xy - courtPtr.ballPos.xy) < 2.8 then
                local finalHeading = courtPtr.courtHeading + (PlayerSettings.side == CONST_SIDE_A and 180.0 or 0.0)
                local newVelocity = ComputeAfterHitVelocity(finalHeading, distName)

                TriggerServerEvent(
                    "SevenLife:Tennis:MakeBallData",
                    PlayerSettings.courtName,
                    hitType,
                    predictedBallPos,
                    newVelocity
                )
            end
        end
    )
end

function LoadAnimDict(animDict)
    while (not HasAnimDictLoaded(animDict)) do
        RequestAnimDict(animDict)
        Citizen.Wait(0)
    end

    Wait(0)
end
