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

local _wheel, _base, _lights1, _lights2, _arrow1, _arrow2, cars = nil, nil, nil, nil, nil, nil, Config.Car
local _podiumModel = vector3(963.42, 47.85, 74.33)
local m1a = GetHashKey("vw_prop_vw_luckylight_off")
local m1b = GetHashKey("vw_prop_vw_luckylight_on")
local m2a = GetHashKey("vw_prop_vw_jackpot_off")
local m2b = GetHashKey("vw_prop_vw_jackpot_on")
local PosWheel = {x = 978.01, y = 50.35, z = 73.93, h = 327.99}
local Running = false
Citizen.CreateThread(
    function()
        RequestScriptAudioBank("DLC_VINEWOOD\\CASINO_GENERAL", false)
        local model = GetHashKey("vw_prop_vw_luckywheel_02a")
        local model1 = GetHashKey("vw_prop_vw_luckywheel_01a")
        local podiumModel = GetHashKey("vw_prop_vw_casino_podium_01a")
        local o =
            GetClosestObjectOfType(
            PosWheel.x,
            PosWheel.y,
            PosWheel.z,
            2.5,
            GetHashKey("vw_prop_vw_luckywheel_01a"),
            0,
            0,
            0
        )
        local o1 =
            GetClosestObjectOfType(
            PosWheel.x,
            PosWheel.y,
            PosWheel.z,
            2.5,
            GetHashKey("vw_prop_vw_jackpot_on"),
            0,
            0,
            0
        )
        local o2 =
            GetClosestObjectOfType(
            PosWheel.x,
            PosWheel.y,
            PosWheel.z,
            2.5,
            GetHashKey("vw_prop_vw_luckylight_on"),
            0,
            0,
            0
        )
        if DoesEntityExist(o) then
            PosWheel.x = GetEntityCoords(o).x
            PosWheel.y = GetEntityCoords(o).y - 1.0
            PosWheel.z = GetEntityCoords(o).z + 0.2593
            PosWheel.h = GetEntityHeading(o)
            SetModelAsNoLongerNeeded(o, true, true)
            SetEntityCollision(o, false, false)
            SetEntityVisible(o, false)

            SetModelAsNoLongerNeeded(o1, true, true)
            SetEntityCollision(o1, false, false)
            SetEntityVisible(o1, false)

            SetModelAsNoLongerNeeded(o2, true, true)
            SetEntityCollision(o2, false, false)
            SetEntityVisible(o2, false)
        end

        Citizen.CreateThread(
            function()
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                RequestModel(model1)
                while not HasModelLoaded(model1) do
                    Citizen.Wait(0)
                end

                RequestModel(m1a)
                while not HasModelLoaded(m1a) do
                    Citizen.Wait(0)
                end
                RequestModel(m1b)
                while not HasModelLoaded(m1b) do
                    Citizen.Wait(0)
                end
                RequestModel(m2a)
                while not HasModelLoaded(m2a) do
                    Citizen.Wait(0)
                end
                RequestModel(m2b)
                while not HasModelLoaded(m2b) do
                    Citizen.Wait(0)
                end

                ClearArea(PosWheel.x, PosWheel.y, PosWheel.z, 5.0, true, false, false, false)

                _wheel = CreateObject(model, PosWheel.x, PosWheel.y, PosWheel.z, false, false, true)
                SetEntityHeading(_wheel, PosWheel.h)
                SetModelAsNoLongerNeeded(model)

                _base = CreateObject(model1, PosWheel.x, PosWheel.y, PosWheel.z - 0.26, false, false, true)
                SetEntityHeading(_base, PosWheel.h)
                SetModelAsNoLongerNeeded(_base)

                _lights1 = CreateObject(m1a, PosWheel.x, PosWheel.y, PosWheel.z + 0.35, false, false, true)
                SetEntityHeading(_lights1, PosWheel.h)
                SetModelAsNoLongerNeeded(_lights1)

                _lights2 = CreateObject(m1b, PosWheel.x, PosWheel.y, PosWheel.z + 0.35, false, false, true)
                SetEntityVisible(_lights2, false, 0)
                SetEntityHeading(_lights2, PosWheel.h)
                SetModelAsNoLongerNeeded(_lights2)

                _arrow1 = CreateObject(m2a, PosWheel.x, PosWheel.y, PosWheel.z + 2.5, false, false, true)
                SetEntityHeading(_arrow1, PosWheel.h)
                SetModelAsNoLongerNeeded(_arrow1)

                _arrow2 = CreateObject(m2b, PosWheel.x, PosWheel.y, PosWheel.z + 2.5, false, false, true)
                SetEntityVisible(_arrow2, false, 0)
                SetEntityHeading(_arrow2, PosWheel.h)
                SetModelAsNoLongerNeeded(_arrow2)

                RequestModel(podiumModel)
                while not HasModelLoaded(podiumModel) do
                    Citizen.Wait(0)
                end
                _podiumModel =
                    CreateObject(podiumModel, _podiumModel.x, _podiumModel.y, _podiumModel.z, false, false, true)
                SetEntityHeading(_podiumModel, 0.0)
                SetModelAsNoLongerNeeded(podiumModel)

                headingwheel = GetEntityRotation(_wheel)
            end
        )
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(100)

            local o =
                GetClosestObjectOfType(
                PosWheel.x,
                PosWheel.y,
                PosWheel.z,
                2.5,
                GetHashKey("ch_prop_casino_lucky_wheel_01a"),
                0,
                0,
                0
            )
            SetEntityCollision(o, false, false)
            SetEntityVisible(o, false)
            if DoesEntityExist(o) and GetEntityCoords(o) ~= GetEntityCoords(_wheel) then
                PosWheel.x = GetEntityCoords(o).x
                PosWheel.y = GetEntityCoords(o).y - 2.0
                PosWheel.z = GetEntityCoords(o).z
                PosWheel.h = GetEntityHeading(o)
                SetEntityCoords(_wheel, PosWheel.x, PosWheel.y, PosWheel.z + 1.50)
                SetEntityCoords(_base, PosWheel.x, PosWheel.y, PosWheel.z)

                SetEntityCoords(_lights1, PosWheel.x, PosWheel.y, PosWheel.z)
                SetEntityCoords(_lights2, PosWheel.x, PosWheel.y, PosWheel.z)
                SetEntityCoords(_arrow1, PosWheel.x, PosWheel.y, PosWheel.z)
                SetEntityCoords(_arrow2, PosWheel.x, PosWheel.y, PosWheel.z)

                SetEntityHeading(_lights1, PosWheel.h)
                SetEntityHeading(_lights2, PosWheel.h)
                SetEntityHeading(_arrow1, PosWheel.h)
                SetEntityHeading(_arrow2, PosWheel.h)
                SetEntityHeading(_wheel, PosWheel.h)
                SetEntityHeading(_base, PosWheel.h)
            end

            if
                GetDistanceBetweenCoords(
                    GetEntityCoords(GetPlayerPed(-1)),
                    Config.VehiclePoss.x,
                    Config.VehiclePoss.y,
                    Config.VehiclePoss.z,
                    true
                ) < 40
             then
                if DoesEntityExist(vehicles) == false then
                    if cars then
                        RequestModel(GetHashKey(cars))
                        while not HasModelLoaded(GetHashKey(cars)) do
                            Wait(1)
                        end
                        local coordsofcar = vector3(Config.VehiclePoss.x, Config.VehiclePoss.y, Config.VehiclePoss.z)
                        ESX.Game.SpawnVehicle(
                            cars,
                            coordsofcar,
                            Config.VehiclePoss.h,
                            function(vehicle)
                                vehicles = vehicle
                                FreezeEntityPosition(vehicle, true)
                                SetEntityInvincible(vehicle, true)
                                SetVehicleColours(vehicle, 62, 159)
                                SetVehicleNumberPlateText(vehicle, "ChrisiDev")
                                SetVehicleDirtLevel(vehicle, 0.0)
                            end
                        )
                    end
                else
                    SetVehicleDoorsLocked(vehicles, 2)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

RegisterNetEvent("SevenLife:Casino:SyncRoll")
AddEventHandler(
    "SevenLife:Casino:SyncRoll",
    function()
        if not Running then
            print("test")
            Running = true
            local playerPed = PlayerPedId()
            local _lib = "anim_casino_a@amb@casino@games@lucky7wheel@female"
            if IsPedMale(playerPed) then
                _lib = "anim_casino_a@amb@casino@games@lucky7wheel@male"
            end
            local lib, anim = _lib, "enter_right_to_baseidle"

            ESX.Streaming.RequestAnimDict(
                lib,
                function()
                    local PosMoving =
                        GetObjectOffsetFromCoords(GetEntityCoords(_base), GetEntityHeading(_base), -0.9, -0.8, -1.0)
                    TaskGoStraightToCoord(
                        playerPed,
                        PosMoving.x,
                        PosMoving.y,
                        PosMoving.z,
                        1.0,
                        3000,
                        GetEntityHeading(_base),
                        0.0
                    )
                    local _isMoved = false
                    while not _isMoved do
                        local coords = GetEntityCoords(PlayerPedId())
                        if
                            coords.x >= (PosMoving.x - 0.01) and coords.x <= (PosMoving.x + 0.01) and
                                coords.y >= (PosMoving.y - 0.01) and
                                coords.y <= (PosMoving.y + 0.01)
                         then
                            _isMoved = true
                        end
                        Citizen.Wait(0)
                    end
                    SetEntityHeading(playerPed, GetEntityHeading(_base))
                    TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                    while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                        Citizen.Wait(0)
                        DisableAllControlActions(0)
                    end
                    TaskPlayAnim(playerPed, lib, "enter_to_armraisedidle", 8.0, -8.0, -1, 0, 0, false, false, false)
                    while IsEntityPlayingAnim(playerPed, lib, "enter_to_armraisedidle", 3) do
                        Citizen.Wait(0)
                        DisableAllControlActions(0)
                    end
                    TaskPlayAnim(
                        playerPed,
                        lib,
                        "armraisedidle_to_spinningidle_high",
                        8.0,
                        -8.0,
                        -1,
                        0,
                        0,
                        false,
                        false,
                        false
                    )
                end
            )
        end
    end
)

RegisterNetEvent("SevenLife:Casino:Finish")
AddEventHandler(
    "SevenLife:Casino:Finish",
    function()
        Running = false
    end
)
RegisterNetEvent("SevenLife:Casino:StartWheel")
AddEventHandler(
    "SevenLife:Casino:StartWheel",
    function(s, index, p)
        Citizen.Wait(1000)
        SetEntityVisible(_lights1, false, 0)
        SetEntityVisible(_lights2, true, 0)
        win = (index - 1) * 18 + 0.0
        local j = 360

        if s == GetPlayerServerId(PlayerId()) then
            PlaySoundFromEntity(-1, "Spin_Start", _wheel, "dlc_vw_casino_lucky_wheel_sounds", 1, 1)
        end

        for i = 1, 1100, 1 do
            SetEntityRotation(_wheel, headingwheel.x, j + 0.0, headingwheel.z, 0, false)
            if i < 50 then
                j = j - 1.5
            elseif i < 100 then
                j = j - 2.0
            elseif i < 150 then
                j = j - 2.5
            elseif i > 1060 then
                j = j - 0.3
            elseif i > 1030 then
                j = j - 0.6
            elseif i > 1000 then
                j = j - 0.9
            elseif i > 970 then
                j = j - 1.2
            elseif i > 940 then
                j = j - 1.5
            elseif i > 910 then
                j = j - 1.8
            elseif i > 880 then
                j = j - 2.1
            elseif i > 850 then
                j = j - 2.4
            elseif i > 820 then
                j = j - 2.7
            else
                j = j - 3.0
            end
            if i == 850 then
                j = math.random(win - 4, win + 10) + 0.0
            end
            if j > 360 then
                j = j + 0
            end
            if j < 0 then
                j = j + 360
            end
            Citizen.Wait(0)
        end
        Citizen.Wait(300)
        SetEntityVisible(_arrow1, false, 0)
        SetEntityVisible(_arrow2, true, 0)
        local t = true

        if s == GetPlayerServerId(PlayerId()) then
            if p.sound == "car" then
                PlaySoundFromEntity(-1, "Win_Car", _wheel, "dlc_vw_casino_lucky_wheel_sounds", 1, 1)
            elseif p.sound == "cash" then
                PlaySoundFromEntity(-1, "Win_Cash", _wheel, "dlc_vw_casino_lucky_wheel_sounds", 1, 1)
            elseif p.sound == "chips" then
                PlaySoundFromEntity(-1, "Win_Chips", _wheel, "dlc_vw_casino_lucky_wheel_sounds", 1, 1)
            elseif p.sound == "clothes" then
                PlaySoundFromEntity(-1, "Win_Clothes", _wheel, "dlc_vw_casino_lucky_wheel_sounds", 1, 1)
            elseif p.sound == "mystery" then
                PlaySoundFromEntity(-1, "Win_Mystery", _wheel, "dlc_vw_casino_lucky_wheel_sounds", 1, 1)
            else
                PlaySoundFromEntity(-1, "Win", _wheel, "dlc_vw_casino_lucky_wheel_sounds", 1, 1)
            end
        end

        for i = 1, 15, 1 do
            Citizen.Wait(200)
            SetEntityVisible(_lights1, t, 0)
            SetEntityVisible(_arrow2, t, 0)
            t = not t
            SetEntityVisible(_lights2, t, 0)
            SetEntityVisible(_arrow1, t, 0)
            if i == 5 then
                if s == GetPlayerServerId(PlayerId()) then
                    TriggerServerEvent("SevenLife:Casino:GivePrice", s, p)
                end
            end
        end

        Citizen.Wait(1000)
        SetEntityVisible(_lights1, true, 0)
        SetEntityVisible(_lights2, false, 0)
        SetEntityVisible(_arrow1, true, 0)
        SetEntityVisible(_arrow2, false, 0)
        TriggerServerEvent("SevenLife:Casino:StopRolling")
    end
)

local allowednotify = true
local inmarker = false
local inmenu = false
local inrange = false
Citizen.CreateThread(
    function()
        Citizen.Wait(2000)

        while true do
            local player = GetPlayerPed(-1)

            Citizen.Wait(250)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(coords, Config.PlaceWheel.x, Config.PlaceWheel.y, Config.PlaceWheel.z, true)
            if distance < 50 then
                inrange = true
                if distance < 2 then
                    inmarker = true
                    if allowednotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um das Glücksrad zu drehen",
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
                if distance >= 50.1 and distance <= 60.0 then
                    inrange = false
                    TriggerEvent("sevenliferp:closenotify", false)
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(1)
            if inrange then
                if inmarker then
                    if IsControlJustPressed(0, 38) then
                        if inmenu == false then
                            Citizen.Wait(100)
                            inmenu = true
                            allowednotify = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            TriggerServerEvent("SevenLife:Casino:GetWheel")
                        end
                    end
                else
                    Citizen.Wait(400)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
RegisterNetEvent("SevenLife:Casino:ResetSettings")
AddEventHandler(
    "SevenLife:Casino:ResetSettings",
    function()
        inmenu = false
        allowednotify = true
    end
)

Citizen.CreateThread(
    function()
        while true do
            if _podiumModel ~= nil then
                local _heading = GetEntityHeading(_podiumModel)
                local _z = _heading - 0.05
                SetEntityHeading(_podiumModel, _z)
                SetEntityHeading(vehicles, _z)
            end
            Citizen.Wait(5)
        end
    end
)
