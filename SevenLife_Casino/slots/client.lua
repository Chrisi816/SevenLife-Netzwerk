Citizen.CreateThread(
    function()
        local ped = PlayerId()
        SetPlayerControl(ped, 1, 0)
        RequestScriptAudioBank("DLC_VINEWOOD\\CASINO_SLOT_MACHINES_01", false)
        RequestScriptAudioBank("DLC_VINEWOOD\\CASINO_SLOT_MACHINES_02", false)
        RequestScriptAudioBank("DLC_VINEWOOD\\CASINO_SLOT_MACHINES_03", false)
        RequestScriptAudioBank("DLC_VINEWOOD\\CASINO_GENERAL", false)
    end
)
local closetoped, selectedSlot = false, nil
local Slots, Spins = {}, {}
local SITTING_SCENE = nil
local bet = 0
local CURRENT_CHAIR_DATA = nil
local ACTIVE_SLOT = nil

Citizen.CreateThread(
    function()
        while true do
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)
            Citizen.Wait(1000)
            if
                GetDistanceBetweenCoords(coords, Config.PlaceWheel.x, Config.PlaceWheel.y, Config.PlaceWheel.z, true) <
                    200
             then
                closetoped = true
            else
                closetoped = false
            end
        end
    end
)

Citizen.CreateThread(
    function()
        local SecondSlots = {}
        while closetoped == false do
            Citizen.Wait(1500)
        end
        for k, v in pairs(Config.CasinoSlots) do
            local obj = GetGamePool("CObject")
            local filter = k

            if type(filter) == "string" then
                if filter ~= "" then
                    filter = {filter}
                end
                for i = 1, #obj, 1 do
                    if filter == nil or (type(filter) == "table" and #filter == 0) then
                        print("hey")
                    else
                        local objectModel = GetEntityModel(obj[i])
                        for j = 1, #filter, 1 do
                            if objectModel == GetHashKey(filter[j]) then
                                local data = {
                                    pos = GetEntityCoords(obj[i]),
                                    bet = v.bet,
                                    prop = k,
                                    prop1 = v.prop1,
                                    prop2 = v.prop2
                                }
                                table.insert(SecondSlots, data)
                            end
                        end
                    end
                end
            end
        end
        table.sort(
            SecondSlots,
            function(a, b)
                return a.pos.x < b.pos.x
            end
        )
        table.sort(
            SecondSlots,
            function(a, b)
                return a.pos.y < b.pos.y
            end
        )
        table.sort(
            SecondSlots,
            function(a, b)
                return a.pos.z < b.pos.z
            end
        )
        for k, v in pairs(SecondSlots) do
            CreateSlotMaschine(k, v)
        end
    end
)

function GetChair(table)
    local player = PlayerPedId()
    local pos = GetEntityCoords(player)
    if DoesEntityExist(table) then
        local obj = GetWorldPositionOfEntityBone(table, GetEntityBoneIndexByName(table, "Chair_Base_01"))
        local rot = GetWorldRotationOfEntityBone(table, GetEntityBoneIndexByName(table, "Chair_Base_01"))
        local distance = GetDistanceBetweenCoords(pos, obj, true)

        if distance < 1.7 then
            return {
                position = obj,
                rotation = rot,
                chairId = 1,
                obj = table
            }
        end
    end
end

function CreateSlotMaschine(index, data)
    local self = {}
    self.index = index
    self.data = data
    self.betData = {}
    self.rulettCam = nil

    self.spin1 = nil
    self.spin2 = nil
    self.spin3 = nil

    self.spin1b = nil
    self.spin2b = nil
    self.spin3b = nil

    self.running = false
    self.cameraMode = 1
    self.tableObject = GetClosestObjectOfType(data.pos, 0.8, GetHashKey(self.data.prop), 0, 0, 0)

    self.data.rot = GetEntityHeading(self.tableObject)
    self.data.position = GetEntityCoords(self.tableObject)

    self.offset =
        GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.0, 0.05, 0.0)
    self.StartPlayingSlots = function(state)
        local ped = PlayerPedId()
        if state then
            local sound = CheckSound(self.data)
            Citizen.Wait(3000)
            if ped == PlayerPedId() then
                PlaySoundFrontend(-1, "welcome_stinger", sound, 1, 20)
                FreezeEntityPosition(true)
                self.cameraModi = 1

                local sex = 0
                local rot = CURRENT_CHAIR_DATA.rotation + vector3(0.0, 0.0, -90.0)
                if GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
                    sex = 1
                end
                local Anim = "anim_casino_a@amb@casino@games@slots@male"
                if sex == 1 then
                    Anim = "anim_casino_a@amb@casino@games@slots@female"
                end

                RequestAnimDict(Anim)
                while not HasAnimDictLoaded(Anim) do
                    Citizen.Wait(1)
                end

                SITTING_SCENE = NetworkCreateSynchronisedScene(self.offset, rot, 2, 1, 0, 1065353216, 0, 1065353216)
                local rndspin =
                    ({"base_idle_a", "base_idle_b", "base_idle_c", "base_idle_d", "base_idle_e", "base_idle_f"})[
                    math.random(1, 6)
                ]

                NetworkAddPedToSynchronisedScene(PlayerPedId(), SITTING_SCENE, Anim, rndspin, 2.0, 2.0, 13, 16, 2.0, 0)
                NetworkStartSynchronisedScene(SITTING_SCENE)

                model = GetHashKey(self.data.prop1)

                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(1)
                end

                model = GetHashKey(self.data.prop2)
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)

                    Citizen.Wait(1)
                end

                local rot = vector3(0.0, 0.0, self.data.rot + 0.0)
                local Offset =
                    GetObjectOffsetFromCoords(
                    GetEntityCoords(self.tableObject),
                    GetEntityHeading(self.tableObject),
                    0.0,
                    -0.5,
                    0.6
                )
                local CamOffset =
                    GetObjectOffsetFromCoords(
                    GetEntityCoords(self.tableObject),
                    GetEntityHeading(self.tableObject),
                    0.0,
                    -0.5,
                    0.6
                )

                local Offset1 =
                    GetObjectOffsetFromCoords(
                    GetEntityCoords(self.tableObject),
                    GetEntityHeading(self.tableObject),
                    -0.118,
                    0.05,
                    0.9
                )
                local Offset2 =
                    GetObjectOffsetFromCoords(
                    GetEntityCoords(self.tableObject),
                    GetEntityHeading(self.tableObject),
                    0.000,
                    0.05,
                    0.9
                )
                local Offset3 =
                    GetObjectOffsetFromCoords(
                    GetEntityCoords(self.tableObject),
                    GetEntityHeading(self.tableObject),
                    0.118,
                    0.05,
                    0.9
                )

                selectedSlot = self.index

                self.spin1 = CreateObject(GetHashKey(self.data.prop1), Offset1.x, Offset1.y, Offset1.z, true, true)
                self.spin2 = CreateObject(GetHashKey(self.data.prop1), Offset2.x, Offset2.y, Offset2.z, true, true)
                self.spin3 = CreateObject(GetHashKey(self.data.prop1), Offset3.x, Offset3.y, Offset3.z, true, true)

                table.insert(Spins, self.spin1)
                table.insert(Spins, self.spin2)
                table.insert(Spins, self.spin3)

                SetEntityAsMissionEntity(self.spin1, true, true)
                SetEntityAsMissionEntity(self.spin2, true, true)
                SetEntityAsMissionEntity(self.spin3, true, true)

                SetEntityHeading(self.spin1, self.data.rot)
                SetEntityHeading(self.spin2, self.data.rot)
                SetEntityHeading(self.spin3, self.data.rot)

                self.rulettCam =
                    CreateCamWithParams(
                    "DEFAULT_SCRIPTED_CAMERA",
                    CamOffset.x,
                    CamOffset.y,
                    CamOffset.z + 0.8,
                    rot.x - 25.0,
                    rot.y,
                    rot.z,
                    85.0,
                    true,
                    2
                )
                SetCamActive(self.rulettCam, true)
                ShakeCam(self.rulettCam, "HAND_SHAKE", 0.3)
                RenderScriptCams(true, 900, 900, true, false)
                SendNUIMessage(
                    {
                        type = "OpenContainerSlots"
                    }
                )

                Citizen.CreateThread(
                    function()
                        while selectedSlot ~= nil do
                            DisableHUD()
                            Citizen.Wait(1)

                            DisableAllControlActions(0)

                            if IsDisabledControlJustPressed(0, 38) then
                                self.ChangeKamera()
                            end

                            if IsDisabledControlJustPressed(0, 177) then -- BACKSPACE
                                ACTIVE_SLOT = nil
                                DeleteSlots(self.spin1, self.spin2, self.spin3)
                                DeleteSlots2(Spins)
                                self.StartPlayingSlots(false)
                                self.spin1 =
                                    GetClosestObjectOfType(
                                    Offset.x - 0.118,
                                    Offset.y,
                                    Offset.z,
                                    1.0,
                                    GetHashKey(self.data.prop1),
                                    false,
                                    false,
                                    false
                                )
                                self.spin2 =
                                    GetClosestObjectOfType(
                                    Offset.x + 0.000,
                                    Offset.y,
                                    Offset.z,
                                    1.0,
                                    GetHashKey(self.data.prop1),
                                    false,
                                    false,
                                    false
                                )
                                self.spin3 =
                                    GetClosestObjectOfType(
                                    Offset.x + 0.118,
                                    Offset.y,
                                    Offset.z,
                                    1.0,
                                    GetHashKey(self.data.prop1),
                                    false,
                                    false,
                                    false
                                )
                            end
                            if IsDisabledControlJustPressed(0, 191) or IsDisabledControlJustPressed(0, 22) then -- SPIN
                                if not self.running then
                                    self.running = true
                                    Start(self.index, self.data)
                                    self.spin1 =
                                        GetClosestObjectOfType(
                                        Offset.x - 0.118,
                                        Offset.y,
                                        Offset.z,
                                        1.0,
                                        GetHashKey(self.data.prop1),
                                        false,
                                        false,
                                        false
                                    )
                                    self.spin2 =
                                        GetClosestObjectOfType(
                                        Offset.x + 0.000,
                                        Offset.y,
                                        Offset.z,
                                        1.0,
                                        GetHashKey(self.data.prop1),
                                        false,
                                        false,
                                        false
                                    )
                                    self.spin3 =
                                        GetClosestObjectOfType(
                                        Offset.x + 0.118,
                                        Offset.y,
                                        Offset.z,
                                        1.0,
                                        GetHashKey(self.data.prop1),
                                        false,
                                        false,
                                        false
                                    )
                                    Citizen.Wait(4000)
                                    self.running = false
                                end
                            end
                            if IsDisabledControlJustPressed(0, 172) then
                                bet = bet + 10
                                SendNUIMessage(
                                    {
                                        type = "UpdateContainerSlots",
                                        coins = bet
                                    }
                                )
                            end
                            if IsDisabledControlJustPressed(0, 173) then
                                bet = bet - 10
                                SendNUIMessage(
                                    {
                                        type = "UpdateContainerSlots",
                                        coins = bet
                                    }
                                )
                            end
                        end
                    end
                )
                Citizen.Wait(2000)
            end
        else
            SendNUIMessage(
                {
                    type = "CloseNUISlots"
                }
            )
            if DoesCamExist(self.rulettCam) then
                DestroyCam(self.rulettCam, false)
            end

            FreezeEntityPosition(ped, false)

            RenderScriptCams(false, 900, 900, true, false)
            selectedSlot = nil

            local sex = 0
            local rot = CURRENT_CHAIR_DATA.rotation + vector3(0.0, 0.0, -90.0)
            if GetEntityModel(state) == GetHashKey("mp_f_freemode_01") then
                sex = 1
            end
            local Anim = "anim_casino_a@amb@casino@games@slots@male"
            if sex == 1 then
                Anim = "anim_casino_a@amb@casino@games@slots@female"
            end
            RequestAnimDict(Anim)
            while not HasAnimDictLoaded(Anim) do
                Citizen.Wait(1)
            end
            SITTING_SCENE = NetworkCreateSynchronisedScene(self.offset, rot, 2, 1, 0, 1065353216, 0, 1065353216)
            local rndspin = ({"exit_left", "exit_right"})[math.random(1, 2)]
            NetworkAddPedToSynchronisedScene(ped, SITTING_SCENE, Anim, rndspin, 2.0, 2.0, 13, 16, 0, 0)
            NetworkStartSynchronisedScene(SITTING_SCENE)
            Citizen.Wait(3000)
            ClearPedTasks(ped)
            TriggerServerEvent("SevenLife:Slots:NotUsable", self.index)

            DisplayRadar(true)
            TriggerEvent("ActivateAllHUD")
        end
    end
    self.ChangeKamera = function()
        local rot = CURRENT_CHAIR_DATA.rotation + vector3(0.0, 0.0, -90.0)
        if self.cameraMode == 1 then
            self.cameraMode = 2
            local CamOffset =
                GetObjectOffsetFromCoords(
                GetEntityCoords(self.tableObject),
                GetEntityHeading(self.tableObject),
                0.50,
                -0.60,
                0.54
            )
            self.rulettCam =
                CreateCamWithParams(
                "DEFAULT_SCRIPTED_CAMERA",
                CamOffset.x,
                CamOffset.y,
                CamOffset.z + 0.8,
                rot.x - 25.0,
                rot.y,
                rot.z + 35.0,
                80.0,
                true,
                2
            )
            SetCamActive(self.rulettCam, true)
            RenderScriptCams(true, 900, 900, true, false)
            ShakeCam(self.rulettCam, "HAND_SHAKE", 0.3)
        elseif self.cameraMode == 2 then
            self.cameraMode = 3
            if DoesCamExist(self.rulettCam) then
                DestroyCam(self.rulettCam, false)
            end
            RenderScriptCams(false, 900, 900, true, false)
        elseif self.cameraMode == 3 then
            self.cameraMode = 1
            local CamOffset =
                GetObjectOffsetFromCoords(
                GetEntityCoords(self.tableObject),
                GetEntityHeading(self.tableObject),
                0.0,
                -0.5,
                0.6
            )
            self.rulettCam =
                CreateCamWithParams(
                "DEFAULT_SCRIPTED_CAMERA",
                CamOffset.x,
                CamOffset.y,
                CamOffset.z + 0.8,
                rot.x - 25.0,
                rot.y,
                rot.z,
                85.0,
                true,
                2
            )
            SetCamActive(self.rulettCam, true)
            RenderScriptCams(true, 900, 900, true, false)
            ShakeCam(self.rulettCam, "HAND_SHAKE", 0.3)
        end
    end
    self.SpinIt = function(Tick)
        local ped = PlayerPedId()
        local sound = CheckSound(self.data)
        local sex = 0
        local rot = CURRENT_CHAIR_DATA.rotation + vector3(0.0, 0.0, -90.0)
        if GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
            sex = 1
        end
        local Anim = "anim_casino_a@amb@casino@games@slots@male"
        if sex == 1 then
            Anim = "anim_casino_a@amb@casino@games@slots@female"
        end
        RequestAnimDict(Anim)
        while not HasAnimDictLoaded(Anim) do
            Citizen.Wait(1)
        end
        SITTING_SCENE = NetworkCreateSynchronisedScene(self.offset, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        local rndspin = ({"press_spin_a", "press_spin_b"})[math.random(1, 2)]

        NetworkAddPedToSynchronisedScene(ped, SITTING_SCENE, Anim, rndspin, 2.0, 2.0, 50, 16, 2.0, 0)
        NetworkStartSynchronisedScene(SITTING_SCENE)

        Citizen.Wait(500)
        PlaySoundFrontend(-1, "place_bet", sound, 1, 20)
        DeleteSlots(self.spin1, self.spin2, self.spin3)
        DeleteSlots2(Spins)

        local Offset1 =
            GetObjectOffsetFromCoords(
            GetEntityCoords(self.tableObject),
            GetEntityHeading(self.tableObject),
            -0.118,
            0.05,
            0.9
        )
        local Offset2 =
            GetObjectOffsetFromCoords(
            GetEntityCoords(self.tableObject),
            GetEntityHeading(self.tableObject),
            0.000,
            0.05,
            0.9
        )
        local Offset3 =
            GetObjectOffsetFromCoords(
            GetEntityCoords(self.tableObject),
            GetEntityHeading(self.tableObject),
            0.118,
            0.05,
            0.9
        )

        self.spin1b = CreateObject(GetHashKey(self.data.prop2), Offset1.x, Offset1.y, Offset1.z, true, true)
        self.spin2b = CreateObject(GetHashKey(self.data.prop2), Offset2.x, Offset2.y, Offset2.z, true, true)
        self.spin3b = CreateObject(GetHashKey(self.data.prop2), Offset3.x, Offset3.y, Offset3.z, true, true)
        table.insert(Spins, self.spin1b)
        table.insert(Spins, self.spin2b)
        table.insert(Spins, self.spin3b)
        SetEntityAsMissionEntity(self.spin1b, true, true)
        SetEntityAsMissionEntity(self.spin2b, true, true)
        SetEntityAsMissionEntity(self.spin3b, true, true)

        SetEntityHeading(self.spin1b, self.data.rot)
        SetEntityHeading(self.spin2b, self.data.rot)
        SetEntityHeading(self.spin3b, self.data.rot)
        local temp1 = GetEntityRotation(self.spin1b)
        local temp2 = GetEntityRotation(self.spin2b)
        local temp3 = GetEntityRotation(self.spin3b)

        SetEntityRotation(self.spin1b, temp1.x + math.random(0, 360) - 180.0, temp1.y, temp1.z, 0, true)
        SetEntityRotation(self.spin2b, temp2.x + math.random(0, 360) - 180.0, temp2.y, temp2.z, 0, true)
        SetEntityRotation(self.spin3b, temp3.x + math.random(0, 360) - 180.0, temp3.y, temp3.z, 0, true)
        PlaySoundFromEntity(-1, "start_spin", self.tableObject, sound, 1, 20)
        PlaySoundFromEntity(-1, "spinning", self.tableObject, sound, 1, 20)

        for i = 1, 300, 1 do
            local h1 = GetEntityRotation(self.spin1b)
            local h2 = GetEntityRotation(self.spin2b)
            local h3 = GetEntityRotation(self.spin3b)

            if i < 180 then
                SetEntityRotation(self.spin1b, h1.x + math.random(40, 100) / 10, h1.y, h1.z, 0, true)
            elseif i == 180 then
                h1 = GetEntityRotation(self.spin1b)
                DeleteSlot(self.spin1b)
                self.spin1 = CreateObject(GetHashKey(self.data.prop1), Offset1.x, Offset1.y, Offset1.z, true, true)
                table.insert(Spins, self.spin1)
                SetEntityAsMissionEntity(self.spin1, true, true)
                SetEntityHeading(self.spin1, self.data.rot)
                SetEntityRotation(self.spin1, Tick.a * 22.5 - 180 + 0.0, h1.y, h1.z, 0, true)
                PlaySoundFrontend(-1, "wheel_stop_clunk", sound, 1, 20)
            end

            if i < 240 then
                SetEntityRotation(self.spin2b, h2.x + math.random(40, 100) / 10, h2.y, h2.z, 0, true)
            elseif i == 240 then
                h2 = GetEntityRotation(self.spin2b)
                DeleteSlot(self.spin2b)
                self.spin2 = CreateObject(GetHashKey(self.data.prop1), Offset2.x, Offset2.y, Offset2.z, true, true)
                table.insert(Spins, self.spin2)
                SetEntityAsMissionEntity(self.spin2, true, true)
                SetEntityHeading(self.spin2, self.data.rot)
                SetEntityRotation(self.spin2, Tick.b * 22.5 - 180 + 0.0, h2.y, h2.z, 0, true)
                PlaySoundFrontend(-1, "wheel_stop_clunk", sound, 1, 20)
            end

            if i < 300 then
                SetEntityRotation(self.spin3b, h3.x + math.random(40, 100) / 10, h3.y, h3.z, 0, true)
            elseif i == 300 then
                h3 = GetEntityRotation(self.spin3b)
                DeleteSlot(self.spin3b)
                self.spin3 = CreateObject(GetHashKey(self.data.prop1), Offset3.x, Offset3.y, Offset3.z, true, true)
                table.insert(Spins, self.spin3)
                SetEntityAsMissionEntity(self.spin3, true, true)
                SetEntityHeading(self.spin3, self.data.rot)
                SetEntityRotation(self.spin3, Tick.c * 22.5 - 180 + 0.0, h3.y, h3.z, 0, true)
                PlaySoundFrontend(-1, "wheel_stop_clunk", sound, 1, 20)
                local rndidle = ({"idle_a", "idle_a=b"})[math.random(1, 2)]
                NetworkAddPedToSynchronisedScene(
                    ped,
                    SITTING_SCENE,
                    "anim_casino_b@amb@casino@games@shared@player@",
                    rndidle,
                    2.0,
                    2.0,
                    50,
                    16,
                    2.0,
                    0
                )
                NetworkStartSynchronisedScene(SITTING_SCENE)
            end
            Citizen.Wait(13)
        end
        Citizen.Wait(500)
        CheckForWin(Tick, self.data, sound)

        self.running = false
        if Config.PrintClient then
            print(Config.Wins[Tick.a] or "MISS", Config.Wins[Tick.b] or "MISS", Config.Wins[Tick.c] or "MISS")
        end
        TriggerServerEvent("SevenLife:Casino:CheckIfWin", self.index, bet, Tick, self.data)
    end
    Slots[self.index] = self
end

function DisableHUD(tate)
    DisplayRadar(false)
    TriggerEvent("SevenLife:Start:removeHUD")
end
function CheckForWin(w, data, s)
    local a = Config.Wins[w.a]
    local b = Config.Wins[w.b]
    local c = Config.Wins[w.c]
    local total = 0
    if a == b and b == c and a == c then
        if Config.Mult[a] then
            total = bet * Config.Mult[a]
        end
    elseif a == "6" and b == "6" then
        total = bet * 5
    elseif a == "6" and c == "6" then
        total = bet * 5
    elseif b == "6" and c == "6" then
        total = bet * 5
    elseif a == "6" then
        total = bet * 2
    elseif b == "6" then
        total = bet * 2
    elseif c == "6" then
        total = bet * 2
    end
    if total == 0 then
        PlaySoundFrontend(-1, "no_win", s, 1, 20)
    elseif total == data.bet * 2 then
        PlaySoundFrontend(-1, "small_win", s, 1, 20)
    elseif total == data.bet * 5 then
        PlaySoundFrontend(-1, "big_win", s, 1, 20)
    else
        PlaySoundFrontend(-1, "jackpot", s, 1, 20)
    end
end
function DeleteSlots(a, b, c)
    DeleteEntity(a)
    DeleteObject(a)
    while DoesEntityExist(a) do
        Citizen.Wait(1)
        SetEntityAsMissionEntity(a, true, true)
        DeleteEntity(a)
        DeleteObject(a)
    end

    DeleteEntity(b)
    DeleteObject(b)
    while DoesEntityExist(b) do
        Citizen.Wait(1)
        SetEntityAsMissionEntity(b, true, true)
        DeleteEntity(b)
        DeleteObject(b)
    end

    DeleteEntity(c)
    DeleteObject(c)
    while DoesEntityExist(c) do
        Citizen.Wait(1)
        SetEntityAsMissionEntity(c, true, true)
        DeleteEntity(c)
        DeleteObject(c)
    end
end

function DeleteSlots2()
    for k, v in pairs(Spins) do
        DeleteEntity(v)
        DeleteObject(v)
        while DoesEntityExist(v) do
            Citizen.Wait(1)
            SetEntityAsMissionEntity(v, true, true)
            DeleteEntity(v)
            DeleteObject(v)
        end
    end
end

function DeleteSlot(a)
    DeleteEntity(a)
    DeleteObject(a)
    while DoesEntityExist(a) do
        Citizen.Wait(1)
        DeleteEntity(a)
        DeleteObject(a)
    end
end
function StartSlots(index)
    if Slots[index] then
        local active = true
        Slots[index].StartPlayingSlots(active)
    end
end
function CheckSound(sounds)
    local sound
    if sounds.prop == "vw_prop_casino_slot_01a" then
        sound = "dlc_vw_casino_slot_machine_ak_npc_sounds"
    elseif sounds.prop == "vw_prop_casino_slot_02a" then
        sound = "dlc_vw_casino_slot_machine_ir_npc_sounds"
    elseif sounds.prop == "vw_prop_casino_slot_03a" then
        sound = "dlc_vw_casino_slot_machine_rsr_npc_sounds"
    elseif sounds.prop == "vw_prop_casino_slot_04a" then
        sound = "dlc_vw_casino_slot_machine_fs_npc_sounds"
    elseif sounds.prop == "vw_prop_casino_slot_05a" then
        sound = "dlc_vw_casino_slot_machine_ds_npc_sounds"
    elseif sounds.prop == "vw_prop_casino_slot_06a" then
        sound = "dlc_vw_casino_slot_machine_kd_npc_sounds"
    elseif sounds.prop == "vw_prop_casino_slot_07a" then
        sound = "dlc_vw_casino_slot_machine_td_npc_sounds"
    elseif sounds.prop == "vw_prop_casino_slot_08a" then
        sound = "dlc_vw_casino_slot_machine_hz_npc_sounds"
    end
    return sound
end
Citizen.CreateThread(
    function()
        while true do
            local letSleep = true

            if closetoped and selectedSlot == nil then
                local ped = PlayerPedId()
                for k, v in pairs(Slots) do
                    if DoesEntityExist(v.tableObject) then
                        local playerpos = GetEntityCoords(ped)
                        local Offset =
                            GetObjectOffsetFromCoords(
                            GetEntityCoords(v.tableObject),
                            GetEntityHeading(v.tableObject),
                            0.0,
                            -0.8,
                            0.0
                        )
                        if GetDistanceBetweenCoords(playerpos, Offset.x, Offset.y, Offset.z, true) <= 1.5 then
                            letSleep = false
                            local closestChairData = GetChair(v.tableObject)
                            if closestChairData == nil then
                                break
                            end

                            DrawMarker(
                                20,
                                closestChairData.position + vector3(0.0, 0.0, 1.0),
                                0.0,
                                0.0,
                                0.0,
                                180.0,
                                0.0,
                                0.0,
                                0.2,
                                0.2,
                                0.2,
                                255,
                                255,
                                255,
                                255,
                                false,
                                true,
                                2,
                                true,
                                nil,
                                nil,
                                false
                            )

                            if IsControlJustPressed(0, 38) then
                                ESX.TriggerServerCallback(
                                    "SevenLife:Casino:IsPlaceUsed",
                                    function(used)
                                        if used then
                                        else
                                            ACTIVE_SLOT = v.index
                                            SELECTED_CHAIR_ID = closestChairData.chairId
                                            CURRENT_CHAIR_DATA = closestChairData
                                            SITTING_SCENE =
                                                NetworkCreateSynchronisedScene(
                                                closestChairData.position,
                                                closestChairData.rotation,
                                                2,
                                                1,
                                                0,
                                                1065353216,
                                                0,
                                                1065353216
                                            )
                                            RequestAnimDict("anim_casino_b@amb@casino@games@shared@player@")
                                            while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@shared@player@") do
                                                Citizen.Wait(1)
                                            end
                                            local randomSit = ({"sit_enter_left", "sit_enter_right"})[math.random(1, 2)]
                                            NetworkAddPedToSynchronisedScene(
                                                ped,
                                                SITTING_SCENE,
                                                "anim_casino_b@amb@casino@games@shared@player@",
                                                randomSit,
                                                2.0,
                                                -2.0,
                                                13,
                                                16,
                                                2.0,
                                                0
                                            )
                                            NetworkStartSynchronisedScene(SITTING_SCENE)
                                            StartSlots(k)
                                        end
                                    end,
                                    v.index
                                )
                            end
                            break
                        end
                    else
                        local tSlots = {}
                        for k, v in pairs(Config.CasinoSlots) do
                            local objects = GetGamePool("CObject")

                            local filter = k
                            if type(filter) == "string" then
                                if filter ~= "" then
                                    filter = {filter}
                                end
                            end
                            for i = 1, #objects, 1 do
                                if filter == nil or (type(filter) == "table" and #filter == 0) then
                                    print("hey")
                                else
                                    local objectModel = GetEntityModel(objects[i])
                                    for j = 1, #filter, 1 do
                                        if objectModel == GetHashKey(filter[j]) then
                                            local data = {
                                                pos = GetEntityCoords(objects[i]),
                                                bet = v.bet,
                                                prop = k,
                                                prop1 = v.prop1,
                                                prop2 = v.prop2
                                            }
                                            table.insert(tSlots, data)
                                        end
                                    end
                                end
                            end
                        end
                        table.sort(
                            tSlots,
                            function(a, b)
                                return a.pos.x < b.pos.x
                            end
                        )
                        table.sort(
                            tSlots,
                            function(a, b)
                                return a.pos.y < b.pos.y
                            end
                        )
                        table.sort(
                            tSlots,
                            function(a, b)
                                return a.pos.z < b.pos.z
                            end
                        )
                        for k, v in pairs(tSlots) do
                            CreateSlotMaschine(k, v)
                        end
                    end
                end
                if #Slots == 0 then
                    local tSlots = {}
                    for k, v in pairs(Config.CasinoSlots) do
                        local objects = GetGamePool("CObject")

                        local filter = k
                        if type(filter) == "string" then
                            if filter ~= "" then
                                filter = {filter}
                            end
                        end
                        for i = 1, #objects, 1 do
                            if filter == nil or (type(filter) == "table" and #filter == 0) then
                                print("hey")
                            else
                                local objectModel = GetEntityModel(objects[i])
                                for j = 1, #filter, 1 do
                                    if objectModel == GetHashKey(filter[j]) then
                                        local data = {
                                            pos = GetEntityCoords(objects[i]),
                                            bet = v.bet,
                                            prop = k,
                                            prop1 = v.prop1,
                                            prop2 = v.prop2
                                        }
                                        table.insert(tSlots, data)
                                    end
                                end
                            end
                        end
                    end
                    table.sort(
                        tSlots,
                        function(a, b)
                            return a.pos.x < b.pos.x
                        end
                    )
                    table.sort(
                        tSlots,
                        function(a, b)
                            return a.pos.y < b.pos.y
                        end
                    )
                    table.sort(
                        tSlots,
                        function(a, b)
                            return a.pos.z < b.pos.z
                        end
                    )
                    for k, v in pairs(tSlots) do
                        CreateSlotMaschine(k, v)
                    end
                end
            else
                letSleep = true
            end

            if letSleep then
                Citizen.Wait(1000)
            end
            Citizen.Wait(5)
        end
    end
)
function Start(index, data)
    if Slots[index] then
        TriggerServerEvent("SevenLife:Casino:Start", index, bet)
    end
end

RegisterNetEvent("SevenLife:Casino:StartIT")
AddEventHandler(
    "SevenLife:Casino:StartIT",
    function(index, tickRate)
        if Slots[index] ~= nil then
            Slots[index].SpinIt(tickRate)
        end
    end
)
