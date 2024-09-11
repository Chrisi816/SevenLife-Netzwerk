local isClose, Selected = false, nil
local RoulettTable = {}
local BetAmount = 0
idleTimer = 0
Citizen.CreateThread(
    function()
        while true do
            local playerCoords = GetEntityCoords(GetPlayerPed(-1))

            for k, v in pairs(Config.RulettTables) do
                if GetDistanceBetweenCoords(playerCoords, Config.RulettTables[k].position, true) < 100.0 then
                    isClose = true
                else
                    isClose = false
                end
            end
            Citizen.Wait(1000)
        end
    end
)

Citizen.CreateThread(
    function()
        while not isClose do
            Citizen.Wait(1)
        end

        RequestAnimDict("anim_casino_b@amb@casino@games@roulette@table")
        RequestAnimDict("anim_casino_b@amb@casino@games@roulette@dealer_female")
        RequestAnimDict("anim_casino_b@amb@casino@games@shared@player@")
        RequestAnimDict("anim_casino_b@amb@casino@games@roulette@player")

        for k, data in pairs(Config.RulettTables) do
            print(k)
            CreateRoulette(k, data)
        end
    end
)

CreateRoulette = function(index, data)
    local list = {}
    list.index = index
    list.data = data
    list.cam = 1
    list.roulettecam = nil
    list.betobj = {}
    list.ballobj = nil
    list.hoverobj = {}
    list.betlist = {}
    list.number = {}

    list.CreateTable = function()
        for k, v in pairs(Config.TablesRoul) do
            list.tableObject =
                GetClosestObjectOfType(
                data.position.x,
                data.position.y,
                data.position.z,
                3.0,
                GetHashKey(Config.TablesRoul[k]),
                false,
                false,
                false
            )
        end
    end
    list.CreatePed = function()
        RequestModel(GetHashKey("S_F_Y_Casino_01"))
        while not HasModelLoaded(GetHashKey("S_F_Y_Casino_01")) do
            Citizen.Wait(1)
        end

        local pedOffset =
            GetObjectOffsetFromCoords(data.position.x, data.position.y, data.position.z, data.rot, 0.0, 0.7, 1.0)
        list.ped = CreatePed(2, GetHashKey("S_F_Y_Casino_01"), pedOffset, data.rot + 180.0, false, true)

        SetEntityCanBeDamaged(list.ped, 0)
        SetPedAsEnemy(list.ped, 0)
        SetBlockingOfNonTemporaryEvents(list.ped, 1)
        SetPedResetFlag(list.ped, 249, 1)
        SetPedConfigFlag(list.ped, 185, true)
        SetPedConfigFlag(list.ped, 108, true)
        SetPedCanEvasiveDive(list.ped, 0)
        SetPedCanRagdollFromPlayerImpact(list.ped, 0)
        SetPedConfigFlag(list.ped, 208, true)

        -- 1.0.1
        setBlackjackDealerPedVoiceGroup(list.ped, 1)
        SetBlackjackDealerClothes(list.ped, 1)

        TaskPlayAnim(
            list.ped,
            "anim_casino_b@amb@casino@games@roulette@dealer_female",
            "idle",
            3.0,
            3.0,
            -1,
            2,
            0,
            true,
            true,
            true
        )
    end
    list.MakePedSpeak = function(speakName)
        PlayAmbientSpeech1(list.ped, speakName, "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", 1)
    end
    list.Cam = function(state)
        if state then
            list.MakePedSpeak("MINIGAME_DEALER_GREET")

            local rot = vector3(270.0, -90.0, list.data.rot + 270.0)
            list.rulettCam =
                CreateCamWithParams(
                "DEFAULT_SCRIPTED_CAMERA",
                list.data.position.x,
                list.data.position.y,
                list.data.position.z + 2.0,
                rot.x,
                rot.y,
                rot.z,
                80.0,
                true,
                2
            )
            SetCamActive(list.rulettCam, true)
            RenderScriptCams(true, 900, 900, true, false)

            Selected = list.index
            list.BetRender(true)

            PlayIdle()

            Citizen.CreateThread(
                function()
                    while Selected ~= nil do
                        Citizen.Wait(1000)

                        if idleTimer ~= nil then
                            idleTimer = idleTimer - 1
                            if idleTimer < 1 then
                                idleTimer = nil
                                PlayIdle()
                            end
                        end
                    end
                end
            )

            Citizen.CreateThread(
                function()
                    while Selected ~= nil do
                        Citizen.Wait(125)

                        if IsDisabledControlPressed(0, 172) then
                            BetAmount = BetAmount + 100
                            ChangeBet(BetAmount)
                        elseif IsDisabledControlPressed(0, 173) then
                            if BetAmount > 0 then
                                BetAmount = BetAmount - 100

                                if BetAmount < 0 then
                                    BetAmount = 0
                                end

                                ChangeBet(BetAmount)
                            end
                        end
                    end
                end
            )

            Citizen.CreateThread(
                function()
                    while Selected ~= nil do
                        Citizen.Wait(0)
                        DisableAllControlActions(0)

                        if IsDisabledControlJustPressed(0, 177) then
                            list.Cam(false)
                            PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", false)
                        end
                        if IsDisabledControlJustPressed(0, 38) then
                            list.ChangeCam()
                            PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", false)
                        end

                        if IsDisabledControlJustPressed(0, 22) then
                        -- Nui Custom
                        -- (ChangeBet)
                        end
                    end
                end
            )

            Citizen.Wait(1500)
        else
            TriggerServerEvent("SevenLife:Casino:NotUsing", Selected)

            if DoesCamExist(list.rulettCam) then
                DestroyCam(list.rulettCam, false)
            end

            RenderScriptCams(false, 900, 900, true, false)
            list.BetRender(false)

            Selected = nil
            list.MakePedSpeak("MINIGAME_DEALER_LEAVE_NEUTRAL_GAME")

            NetworkStopSynchronisedScene(globalscene)

            local endingDict = "anim_casino_b@amb@casino@games@shared@player@"
            RequestAnimDict(endingDict)
            while not HasAnimDictLoaded(endingDict) do
                Citizen.Wait(1)
            end

            local whichAnim = nil
            if chairid == 1 then
                whichAnim = "sit_exit_left"
            elseif chairid == 2 then
                whichAnim = "sit_exit_right"
            elseif chairid == 3 then
                whichAnim = "sit_exit_left"
            elseif chairid == 4 then
                whichAnim = "sit_exit_left"
            end

            TaskPlayAnim(PlayerPedId(), endingDict, whichAnim, 1.0, 1.0, 2500, 0)
            SetPlayerControl(PlayerId(), 0, 0)
            Citizen.Wait(3600)
            SetPlayerControl(PlayerId(), 1, 0)
        end
    end
    list.ChangeCam = function()
        if DoesCamExist(list.rulettCam) then
            if list.cameraMode == 1 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Citizen.Wait(1)
                end
                list.cameraMode = 2
                local camOffset = GetOffsetFromEntityInWorldCoords(list.tableObject, -1.45, -0.15, 1.45)
                SetCamCoord(list.rulettCam, camOffset)
                SetCamRot(list.rulettCam, -25.0, 0.0, list.data.rot + 270.0, 2)
                SetCamFov(list.rulettCam, 40.0)
                ShakeCam(list.rulettCam, "HAND_SHAKE", 0.3)
                DoScreenFadeIn(200)
            elseif list.cameraMode == 2 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Citizen.Wait(1)
                end
                list.cameraMode = 3
                local camOffset = GetOffsetFromEntityInWorldCoords(list.tableObject, 1.45, -0.15, 2.15)
                SetCamCoord(list.rulettCam, camOffset)
                SetCamRot(list.rulettCam, -58.0, 0.0, list.data.rot + 90.0, 2)
                ShakeCam(list.rulettCam, "HAND_SHAKE", 0.3)
                SetCamFov(list.rulettCam, 80.0)
                DoScreenFadeIn(200)
            elseif list.cameraMode == 3 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Citizen.Wait(1)
                end
                list.cameraMode = 4
                local camOffset =
                    GetWorldPositionOfEntityBone(
                    list.tableObject,
                    GetEntityBoneIndexByName(list.tableObject, "Roulette_Wheel")
                )
                local rot = vector3(270.0, -90.0, list.data.rot + 270.0)
                SetCamCoord(list.rulettCam, camOffset + vector3(0.0, 0.0, 0.5))
                SetCamRot(list.rulettCam, rot, 2)
                StopCamShaking(list.rulettCam, false)
                SetCamFov(list.rulettCam, 80.0)
                DoScreenFadeIn(200)
            elseif list.cameraMode == 4 then
                DoScreenFadeOut(200)
                while not IsScreenFadedOut() do
                    Citizen.Wait(1)
                end
                list.cameraMode = 1
                local rot = vector3(270.0, -90.0, list.data.rot + 270.0)
                SetCamCoord(list.rulettCam, list.data.position + vector3(0.0, 0.0, 2.0))
                SetCamRot(list.rulettCam, rot, 2)
                SetCamFov(list.rulettCam, 80.0)
                StopCamShaking(list.rulettCam, false)
                DoScreenFadeIn(200)
            end
        end
    end
    list.BetRender = function(state)
        enabledBetRender = state

        if state then
            Citizen.CreateThread(
                function()
                    while enabledBetRender do
                        Citizen.Wait(8)

                        if aimingAtBet ~= -1 and lastAimedBet ~= aimingAtBet then
                            lastAimedBet = aimingAtBet
                            local bettingData = list.betData[aimingAtBet]
                            if bettingData ~= nil then
                                list.HoverNumberSlots(bettingData.hoverNumbers)
                            else
                                list.HoverNumberSlots({})
                            end
                        end

                        if aimingAtBet == -1 and lastAimedBet ~= -1 then
                            list.HoverNumberSlots({})
                        end
                    end
                end
            )

            Citizen.CreateThread(
                function()
                    while enabledBetRender do
                        Citizen.Wait(1)

                        ShowCursorThisFrame()

                        local e = RoulettTable[Selected]
                        if e ~= nil then
                            local cx, cy = GetNuiCursorPosition()
                            local rx, ry = GetActiveScreenResolution()

                            local n = 30

                            local foundBet = false

                            for i = 1, #list.betData, 1 do
                                local bettingData = list.betData[i]
                                local onScreen, screenX, screenY =
                                    World3dToScreen2d(bettingData.pos.x, bettingData.pos.y, bettingData.pos.z)
                                local l = math.sqrt(math.pow(screenX * rx - cx, 2) + math.pow(screenY * ry - cy, 2))
                                if l < n then
                                    aimingAtBet = i
                                    foundBet = true

                                    if IsDisabledControlJustPressed(0, 24) then
                                        if Selected > 0 then
                                            if Config.RulettTables[Selected] ~= nil then
                                                PlaySoundFrontend(
                                                    -1,
                                                    "DLC_VW_BET_DOWN",
                                                    "dlc_vw_table_games_frontend_sounds",
                                                    true
                                                )
                                                TriggerServerEvent(
                                                    "SevenLife:Casino:BetRoulette",
                                                    Selected,
                                                    aimingAtBet,
                                                    Selected
                                                )
                                            end
                                        else
                                            TriggerEvent("SevenLife:TimetCustom:Notify", "Casino", "Ungültig", 2000)
                                        end
                                    end
                                end
                            end

                            if not foundBet then
                                aimingAtBet = -1
                            end
                        end
                    end
                end
            )
        end
    end
    list.HoverNumberSlots = function(hoveredNumbers)
        for i = 1, #list.hoverObjects, 1 do
            if DoesEntityExist(list.hoverObjects[i]) then
                DeleteObject(list.hoverObjects[i])
            end
        end

        list.hoverObjects = {}

        for i = 1, #hoveredNumbers, 1 do
            local t = list.numbersData[hoveredNumbers[i]]
            if t ~= nil then
                RequestModel(GetHashKey(t.hoverObject))
                while not HasModelLoaded(GetHashKey(t.hoverObject)) do
                    Citizen.Wait(1)
                end

                local obj = CreateObject(GetHashKey(t.hoverObject), t.hoverPos, false)
                SetEntityHeading(obj, list.data.rot)

                table.insert(list.hoverObjects, obj)
            end
        end
    end
    list.BetObject = function(bets)
        for i = 1, #list.betObjects, 1 do
            if DoesEntityExist(list.betObjects[i].obj) then
                DeleteObject(list.betObjects[i].obj)
            end
        end

        list.betObjects = {}

        local existBetId = {}

        for i = 1, #bets, 1 do
            local t = list.betData[bets[i].betId]

            if existBetId[bets[i].betId] == nil then
                existBetId[bets[i].betId] = 0
            else
                existBetId[bets[i].betId] = existBetId[bets[i].betId] + 1
            end

            if t ~= nil then
                local betModelObject = GetChipModelByAmount(bets[i].betAmount)

                if betModelObject ~= nil then
                    RequestModel(betModelObject)
                    while not HasModelLoaded(betModelObject) do
                        Citizen.Wait(1)
                    end

                    local obj =
                        CreateObject(
                        betModelObject,
                        t.objectPos.x,
                        t.objectPos.y,
                        t.objectPos.z + (existBetId[bets[i].betId] * 0.0081),
                        false
                    )
                    SetEntityHeading(obj, list.data.rot)
                    table.insert(
                        list.betObjects,
                        {
                            obj = obj,
                            betAmount = bets[i].betAmount,
                            playerSrc = bets[i].playerSrc
                        }
                    )
                end
            end
        end
    end
    list.SpinIt = function(tickRate)
        if DoesEntityExist(list.tableObject) and DoesEntityExist(list.ped) then
            list.MakePedSpeak("MINIGAME_DEALER_CLOSED_BETS")
            TaskPlayAnim(
                list.ped,
                "anim_casino_b@amb@casino@games@roulette@dealer_female",
                "no_more_bets",
                3.0,
                3.0,
                -1,
                0,
                0,
                true,
                true,
                true
            )

            Citizen.Wait(1500)

            if DoesEntityExist(list.ballObject) then
                DeleteObject(list.ballObject)
            end

            TaskPlayAnim(
                list.ped,
                "anim_casino_b@amb@casino@games@roulette@dealer_female",
                "spin_wheel",
                3.0,
                3.0,
                -1,
                0,
                0,
                true,
                true,
                true
            )

            RequestModel(GetHashKey("vw_prop_roulette_ball"))
            while not HasModelLoaded(GetHashKey("vw_prop_roulette_ball")) do
                Citizen.Wait(1)
            end

            local ballOffset =
                GetWorldPositionOfEntityBone(
                list.tableObject,
                GetEntityBoneIndexByName(list.tableObject, "Roulette_Wheel")
            )

            local LIB = "anim_casino_b@amb@casino@games@roulette@table"
            RequestAnimDict(LIB)
            while not HasAnimDictLoaded(LIB) do
                Citizen.Wait(1)
            end

            Citizen.Wait(3000)

            list.ballObject = CreateObject(GetHashKey("vw_prop_roulette_ball"), ballOffset, false)
            SetEntityHeading(list.ballObject, list.data.rot)
            SetEntityCoordsNoOffset(list.ballObject, ballOffset, false, false, false)
            local h = GetEntityRotation(list.ballObject)
            SetEntityRotation(list.ballObject, h.x, h.y, h.z + 90.0, 2, false)

            if DoesEntityExist(list.tableObject) and DoesEntityExist(list.ped) then
                PlayEntityAnim(list.ballObject, "intro_ball", LIB, 1000.0, false, true, true, 0, 136704)
                PlayEntityAnim(list.ballObject, "loop_ball", LIB, 1000.0, false, true, false, 0, 136704)

                PlayEntityAnim(list.tableObject, "intro_wheel", LIB, 1000.0, false, true, true, 0, 136704)
                PlayEntityAnim(list.tableObject, "loop_wheel", LIB, 1000.0, false, true, false, 0, 136704)

                PlayEntityAnim(
                    list.ballObject,
                    string.format("exit_%s_ball", tickRate),
                    LIB,
                    1000.0,
                    false,
                    true,
                    false,
                    0,
                    136704
                )
                PlayEntityAnim(
                    list.tableObject,
                    string.format("exit_%s_wheel", tickRate),
                    LIB,
                    1000.0,
                    false,
                    true,
                    false,
                    0,
                    136704
                )

                Citizen.Wait(11e3)

                if DoesEntityExist(list.tableObject) and DoesEntityExist(list.ped) then
                    TaskPlayAnim(
                        list.ped,
                        "anim_casino_b@amb@casino@games@roulette@dealer_female",
                        "clear_chips_zone1",
                        3.0,
                        3.0,
                        -1,
                        0,
                        0,
                        true,
                        true,
                        true
                    )
                    Citizen.Wait(1500)
                    TaskPlayAnim(
                        list.ped,
                        "anim_casino_b@amb@casino@games@roulette@dealer_female",
                        "clear_chips_zone2",
                        3.0,
                        3.0,
                        -1,
                        0,
                        0,
                        true,
                        true,
                        true
                    )
                    Citizen.Wait(1500)
                    TaskPlayAnim(
                        list.ped,
                        "anim_casino_b@amb@casino@games@roulette@dealer_female",
                        "clear_chips_zone3",
                        3.0,
                        3.0,
                        -1,
                        0,
                        0,
                        true,
                        true,
                        true
                    )

                    Citizen.Wait(2000)
                    if DoesEntityExist(list.tableObject) and DoesEntityExist(list.ped) then
                        TaskPlayAnim(
                            list.ped,
                            "anim_casino_b@amb@casino@games@roulette@dealer_female",
                            "idle",
                            3.0,
                            3.0,
                            -1,
                            0,
                            0,
                            true,
                            true,
                            true
                        )
                    end

                    if DoesEntityExist(list.ballObject) then
                        DeleteObject(list.ballObject)
                    end
                end
            end
        end
    end
    list.CreatePed()
    list.CreateTable()
    RoulettTable[index] = list
end

Citizen.CreateThread(
    function()
        while true do
            local letSleep = true
            local ped = PlayerPedId()
            local playerpos = GetEntityCoords(ped)

            if isClose and Selected == nil then
                for k, v in pairs(RoulettTable) do
                    for i = 1, #Config.TablesRoul, 1 do
                        if DoesEntityExist(v.tableObject) then
                            local tableObj =
                                GetClosestObjectOfType(playerpos, 3.0, GetHashKey(Config.TablesRoul[i]), false)

                            if DoesEntityExist(tableObj) then
                                for Bone, ID in pairs(Config.PokerChairs) do
                                    local chaisdata = GetEntityBoneIndexByName(tableObj, Bone)
                                    local chaircoords =
                                        GetWorldPositionOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, Bone))

                                    if chaircoords then
                                        local distance = GetDistanceBetweenCoords(playerpos, chaircoords, true)
                                        if distance < 1.5 then
                                            print("phase5")
                                            letSleep = false

                                            local closestChairData = GetChair(tableObj)

                                            DrawMarker(
                                                20,
                                                chaircoords + vector3(0.0, 0.0, 1.0),
                                                0.0,
                                                0.0,
                                                0.0,
                                                180.0,
                                                0.0,
                                                0.0,
                                                0.3,
                                                0.3,
                                                0.3,
                                                255,
                                                255,
                                                255,
                                                255,
                                                true,
                                                true,
                                                2,
                                                true,
                                                nil,
                                                nil,
                                                false
                                            )

                                            if IsControlJustPressed(0, 38) then
                                                TriggerServerEvent(
                                                    "SevenLife:Casino:SitDownRouletteCheck",
                                                    k,
                                                    closestChairData
                                                )
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if letSleep then
                Citizen.Wait(1000)
            end
            Citizen.Wait(3)
        end
    end
)

function GetChair(tableObject)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    if DoesEntityExist(tableObject) then
        local chairs = {"Chair_Base_01", "Chair_Base_02", "Chair_Base_03", "Chair_Base_04"}
        for i = 1, #chairs, 1 do
            local objcoords =
                GetWorldPositionOfEntityBone(tableObject, GetEntityBoneIndexByName(tableObject, chairs[i]))
            local dist = GetDistanceBetweenCoords(coords, objcoords, true)
            if dist < 1.7 then
                return {
                    position = objcoords,
                    rotation = GetWorldRotationOfEntityBone(
                        tableObject,
                        GetEntityBoneIndexByName(tableObject, chairs[i])
                    ),
                    chairId = Config.ChairIds[chairs[i]]
                }
            end
        end
    end
end

RegisterNetEvent("SevenLife:Casino:SitDownSeasion")
AddEventHandler(
    "SevenLife:Casino:SitDownSeasion",
    function(Index, Data)
        chairid = Data.chairId
        chairdata = Data
        local playerid = PlayerId()
        globalscene = NetworkCreateSynchronisedScene(Data.position, Data.rotation, 2, 1, 0, 1065353216, 0, 1065353216)
        RequestAnimDict("anim_casino_b@amb@casino@games@shared@player@")
        while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@shared@player@") do
            Citizen.Wait(1)
        end

        local Sit = "sit_enter_left"
        NetworkAddPedToSynchronisedScene(
            PlayerPedId(),
            globalscene,
            "anim_casino_b@amb@casino@games@shared@player@",
            Sit,
            2.0,
            -2.0,
            13,
            16,
            2.0,
            0
        )
        NetworkStartSynchronisedScene(globalscene)
        SetPlayerControl(playerid, 0, 0)
        startRulett(Index, Data.chairId)
        Citizen.Wait(4000)
        SetPlayerControl(playerid, 1, 0)
    end
)
function StartingRoulette(index, chairId)
    if RoulettTable[index] then
        TriggerServerEvent("SevenLife:Casino:StartGame", index, chairId)
    end
end

RegisterNetEvent("SevenLife:Casino:OpenRoulette")
AddEventHandler(
    "SevenLife:Casino:OpenRoulette",
    function(Index)
        if RoulettTable[Index] ~= nil then
            Citizen.Wait(4000)
            RoulettTable[Index].enableCamera(true)
        end
    end
)

function PlayIdle()
    local rot = chairdata.rotation

    if chairid == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif chairid == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif chairid == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif chairid == 1 then
        chairid = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local scene =
        string.format("anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@idles", chairid, chairid)

    if GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
        sex = 1
    end

    if sex == 1 then
        scene =
            string.format(
            "anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@idles",
            chairid,
            chairid
        )
    end

    RequestAnimDict(scene)
    while not HasAnimDictLoaded(scene) do
        Citizen.Wait(1)
    end

    if chairdata ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(chairdata.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), currentScene, scene, "idle_b", 1.0, -2.0, 13, 16, 1148846080, 0)
        NetworkStartSynchronisedScene(currentScene)
    end
end
function ChangeBet(amount)
    BetAmount = amount

    PlaySoundFrontend(-1, "DLC_VW_BET_HIGHLIGHT", "dlc_vw_table_games_frontend_sounds", true)
end
RegisterNetEvent("SevenLife:Casino:UpdateTable")
AddEventHandler(
    "SevenLife:Casino:UpdateTable",
    function(Index, bets)
        if RoulettTable[Index] ~= nil then
            RoulettTable[Index].BetObject(bets)
        end
    end
)
RegisterNetEvent("SevenLife:Casino:UpdateStatus")
AddEventHandler(
    "SevenLife:Casino:UpdateStatus",
    function(Index, ido, statusz)
        if RoulettTable[Index] ~= nil then
            RoulettTable[Index].ido = ido
            RoulettTable[Index].statusz = statusz
        end
    end
)
RegisterNetEvent("SevenLife:Casino:StartSpin")
AddEventHandler(
    "SevenLife:Casino:StartSpin",
    function(Index, tickRate)
        if RoulettTable[Index] ~= nil then
            RoulettTable[Index].SpinIt(tickRate)

            if Selected == Index then
                Play()
            end
        end
    end
)
function Play()
    local rot = chairdata.rotation

    if chairid == 4 then
        rot = rot + vector3(0.0, 0.0, 90.0)
    elseif chairid == 3 then
        rot = rot + vector3(0.0, 0.0, -180.0)
    elseif chairid == 2 then
        rot = rot + vector3(0.0, 0.0, -90.0)
    elseif chairid == 1 then
        chairid = 1
        rot = rot + vector3(0.0, 0.0, -90.0)
    end

    local sex = 0
    local scenes =
        string.format(
        "anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@reacts@v01",
        chairid,
        chairid
    )

    if GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
        sex = 1
    end

    if sex == 1 then
        scenes =
            string.format(
            "anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@reacts@v01",
            SELECTED_CHAIR_ID,
            SELECTED_CHAIR_ID
        )
    end

    RequestAnimDict(scenes)
    while not HasAnimDictLoaded(scenes) do
        Citizen.Wait(1)
    end

    if chairdata ~= nil then
        local currentScene = NetworkCreateSynchronisedScene(chairdata.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        NetworkAddPedToSynchronisedScene(
            PlayerPedId(),
            currentScene,
            scenes,
            "reaction_impartial_var01",
            4.0,
            -2.0,
            13,
            16,
            1148846080,
            0
        )
        NetworkStartSynchronisedScene(currentScene)

        idleTimer = 8
    end
end

RegisterNetEvent("SevenLife:Roulette:LossAnim")
AddEventHandler(
    "SevenLife:Roulette:LossAnim",
    function(chairIds)
        local rot = chairdata.rotation

        if chairIds == 4 then
            rot = rot + vector3(0.0, 0.0, 90.0)
        elseif chairIds == 3 then
            rot = rot + vector3(0.0, 0.0, -180.0)
        elseif chairIds == 2 then
            rot = rot + vector3(0.0, 0.0, -90.0)
        elseif chairIds == 1 then
            chairIds = 1
            rot = rot + vector3(0.0, 0.0, -90.0)
        end

        local sex = 0
        local scenes =
            string.format(
            "anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@reacts@v01",
            chairIds,
            chairIds
        )

        if GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
            sex = 1
        end

        if sex == 1 then
            scenes =
                string.format(
                "anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@reacts@v01",
                chairIds,
                chairIds
            )
        end

        RequestAnimDict(scenes)
        while not HasAnimDictLoaded(scenes) do
            Citizen.Wait(1)
        end

        if chairdata ~= nil then
            local currentScene =
                NetworkCreateSynchronisedScene(chairdata.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
            NetworkAddPedToSynchronisedScene(
                PlayerPedId(),
                currentScene,
                scenes,
                "reaction_bad_var01",
                4.0,
                -2.0,
                13,
                16,
                1148846080,
                0
            )
            NetworkStartSynchronisedScene(currentScene)

            idleTimer = 8
        end
    end
)
RegisterNetEvent("SevenLife:Casino:PlayWinAnimation")
AddEventHandler(
    "SevenLife:Casino:PlayWinAnimation",
    function(chairIds)
        local rot = chairdata.rotation

        if chairIds == 4 then
            rot = rot + vector3(0.0, 0.0, 90.0)
        elseif chairIds == 3 then
            rot = rot + vector3(0.0, 0.0, -180.0)
        elseif chairIds == 2 then
            rot = rot + vector3(0.0, 0.0, -90.0)
        elseif chairIds == 1 then
            chairIds = 1
            rot = rot + vector3(0.0, 0.0, -90.0)
        end

        local sex = 0
        local scenes =
            string.format(
            "anim_casino_b@amb@casino@games@roulette@ped_male@seat_%s@regular@0%sa@reacts@v01",
            chairIds,
            chairIds
        )

        if GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
            sex = 1
        end

        if sex == 1 then
            scenes =
                string.format(
                "anim_casino_b@amb@casino@games@roulette@ped_female@seat_%s@regular@0%sa@reacts@v01",
                chairIds,
                chairIds
            )
        end

        RequestAnimDict(scenes)
        while not HasAnimDictLoaded(scenes) do
            Citizen.Wait(1)
        end

        if chairdata ~= nil then
            local currentScene =
                NetworkCreateSynchronisedScene(chairdata.position, rot, 2, 1, 0, 1065353216, 0, 1065353216)
            NetworkAddPedToSynchronisedScene(
                PlayerPedId(),
                currentScene,
                scenes,
                "reaction_great",
                4.0,
                -2.0,
                13,
                16,
                1148846080,
                0
            )
            NetworkStartSynchronisedScene(currentScene)

            idleTimer = 8
        end
    end
)
RegisterCommand(
    "getRoulettetable",
    function()
        local found = false

        local playercoords = GetEntityCoords(PlayerPedId())
        for i = 1, #Config.TablesRoul, 1 do
            local obj = GetClosestObjectOfType(playercoords, 3.0, GetHashKey(Config.TablesRoul[i]), false, false, false)
            if DoesEntityExist(obj) then
                print(GetEntityCoords(obj))
                print(GetEntityHeading(obj))
                found = true
            end
        end

        if not found then
            print("none table found.")
        end
    end
)
RegisterCommand(
    "getpokertable",
    function()
        local found = false

        local playercoords = GetEntityCoords(PlayerPedId())
        for i = 1, #Config.Tables, 1 do
            local obj = GetClosestObjectOfType(playercoords, 3.0, GetHashKey(Config.Tables[i]), false, false, false)
            if DoesEntityExist(obj) then
                found = true
            end
        end

        if not found then
            print("none table found.")
        end
    end
)
