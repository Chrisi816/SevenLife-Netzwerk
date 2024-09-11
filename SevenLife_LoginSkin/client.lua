ESX = nil
inmenu = false
isMale = true
local camcoord
local plano = "kopf"
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
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)

            local player = GetPlayerPed(-1)

            SetEntityCoords(player, Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
            TriggerEvent("sevenlife:skin:senddata")
            inmenu = true
            TriggerEvent("SevenLife:OpenIt:remove")
            TriggerServerEvent("SevenLife:LoginSkin:MakeEntityAlone")
            Removenormalhud()
            break
        end
    end
)

function SkyCam(bool)
    SetRainFxIntensity(0.0)
    SetWeatherTypePersist("EXTRASUNNY")
    SetWeatherTypeNow("EXTRASUNNY")
    SetWeatherTypeNowPersist("EXTRASUNNY")
    NetworkOverrideClockTime(12, 0, 0)

    if bool then
        DoScreenFadeIn(1000)
        SetTimecycleModifier("hud_def_blur")
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1456.11, -547.92, 73.1, 0.0, 0.0, 216.53, 45.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetTimecycleModifier("default")
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(GetPlayerPed(-1), false)
    end
end
RegisterNetEvent("sevenlife:skin:senddata")
AddEventHandler(
    "sevenlife:skin:senddata",
    function()
        SetTimecycleModifier("hud_def_blur")
        SetTimecycleModifierStrength(0.0)
        if not IsPlayerSwitchInProgress() then
            SwitchOutPlayer(PlayerPedId(), 1, 1)
        end
        TriggerEvent("SevenLife:OpenIt:remove")
        while GetPlayerSwitchState() ~= 5 do
            Citizen.Wait(0)
            ClearScreen()
        end
        ClearScreen()
        Citizen.Wait(0)
        local timer = GetGameTimer()
        ShutdownLoadingScreenNui()
        local player = GetPlayerPed(-1)
        FreezeEntityPosition(player, true)
        Citizen.CreateThread(
            function()
                RequestCollisionAtCoord(-1453.29, -551.6, 72.84)
                while not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) do
                    Citizen.Wait(1)
                end
            end
        )
        TriggerEvent("SevenLife:OpenIt:remove")
        local player = GetPlayerPed(-1)
        TriggerEvent("esx_skin:playerRegistered")
        SetEntityCoords(player, Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
        TriggerEvent("sevenliferp:closenotify", false)
        Citizen.Wait(3500)

        while true do
            ClearScreen()
            Citizen.Wait(0)
            if GetGameTimer() - timer > 5000 then
                SwitchInPlayer(PlayerPedId())
                ClearScreen()

                while GetPlayerSwitchState() ~= 12 do
                    Citizen.Wait(0)
                    ClearScreen()
                end
                break
            end
        end

        local player = GetPlayerPed(-1)
        SetEntityCoords(player, Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
        TriggerEvent("SevenLife:OpenIt:remove")
        TriggerServerEvent("realtime:event")
        NetworkSetTalkerProximity(0.0)
        openCharMenu(true)
    end
)
function ClearScreen()
    HideHudAndRadarThisFrame()
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end
function openCharMenu(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage(
        {
            type = "opennui",
            toggle = bool
        }
    )
    SkyCam(bool)
end
function Removenormalhud()
    Citizen.CreateThread(
        function()
            while inmenu do
                Citizen.Wait(1)
                DisplayRadar(false)
            end
        end
    )
end

RegisterNUICallback(
    "CreateAccount",
    function(data)
        TriggerServerEvent("SevenLife:Login:CheckIfPlayerHaceAccount", data.benutzername, data.passwort)
    end
)

RegisterNetEvent("sevenlife:Login:NextStep")
AddEventHandler(
    "sevenlife:Login:NextStep",
    function()
        local player = GetPlayerPed(-1)
        SendNUIMessage(
            {
                type = "NextStepAfterNewAccount"
            }
        )
        SetTimecycleModifier("default")
        FreezeEntityPosition(player, false)
        SetEntityCoords(player, Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
        TaskGoStraightToCoord(player, -1455.24, -551.18, 72.84, 1.0, -1, 72.84, 786603, 1.0)

        Wait(5000)
        SetEntityVisible(PlayerPedId(), true)
        SetEntityInvincible(player, true)
        SetBlockingOfNonTemporaryEvents(player, true)
    end
)
local currentrot
RegisterNUICallback(
    "CreateData",
    function(data)
        local vorname = data.vorname
        local nachname = data.nachname
        local birth = data.birth
        TriggerServerEvent("SevenLife:UpdateData", vorname, nachname, birth)
        isOnCreator = true
        local playerPed = PlayerPedId()
        camcoord = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 3.0, 0.0)
        facecoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.8, 0.6)
        clothescoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.5, 0.1)
        invisible = true
        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
        h = GetEntityHeading(PlayerPedId())
        heading = GetEntityHeading(PlayerPedId())
        headingToCam = GetEntityHeading(PlayerPedId())
        EnableCam()
        currentrot = h - 180
        facecoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.8, 0.6)

        SetCamCoord(camara, facecoord)
    end
)

local default = false
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)

            if isOnCreator == true then
            end
        end
    end
)
function EnableCam()
    local ped = PlayerPedId()

    -- Camara
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(camara, false)
    if (not DoesCamExist(camara)) then
        camara = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(camara, true)
        RenderScriptCams(true, false, 0, true, true)
        SetCamCoord(camara, camcoord)

        SetCamRot(camara, 0.0, 0.0, h - 180.0)
    end

    if heading ~= GetEntityHeading(ped) then
        SetEntityHeading(ped, heading)
    end

    headingToCam = GetEntityHeading(PlayerPedId()) + 90
end
RegisterNUICallback(
    "rotationleft",
    function(data)
        local ped = PlayerPedId()
        local pedPos = GetEntityCoords(ped)
        local camPos = GetCamCoord(camara)
        local headings = headingToCam
        headings = headings + 2.5
        headingToCam = headings
        local cx, cy = GetPositionByRelativeHeading(ped, headings, 2)
        SetCamCoord(camara, cx, cy, camPos.z)
        PointCamAtCoord(camara, pedPos.x, pedPos.y, camPos.z)
    end
)
RegisterNUICallback(
    "rotationright",
    function(data)
        local ped = PlayerPedId()
        local pedPos = GetEntityCoords(ped)
        local camPos = GetCamCoord(camara)
        local headings = headingToCam
        headings = headings - 2.5
        headingToCam = headings
        local cx, cy = GetPositionByRelativeHeading(ped, headings, 2)
        SetCamCoord(camara, cx, cy, camPos.z)
        PointCamAtCoord(camara, pedPos.x, pedPos.y, camPos.z)
    end
)
function GetPositionByRelativeHeading(ped, head, dist)
    local pedPos = GetEntityCoords(ped)

    local finPosx = pedPos.x + math.cos(head * (math.pi / 180)) * dist
    local finPosy = pedPos.y + math.sin(head * (math.pi / 180)) * dist

    return finPosx, finPosy
end
RegisterNUICallback(
    "LagaleReise",
    function()
        TriggerServerEvent("SevenLife:LoginSkin:MakeEntityNormalWorld")
        isOnCreator = false
        local player = GetPlayerPed(-1)
        local fertig = true
        inmenu = false
        local legal = 1
        TriggerServerEvent("SevenLife:Hotel:PlayerEnterdHouse")
        SetNuiFocus(false, false)
        SetCamActive(camara, false)
        camara = nil
        RenderScriptCams(false, true, 500, true, true)

        DoScreenFadeOut(100)
        Citizen.Wait(500)
        SetEntityCoords(player, Config.legal.x, Config.legal.y, Config.legal.z)
        Citizen.Wait(500)
        local pos = GetEntityCoords(player)
        local id = pos.x .. pos.y .. pos.z
        TaskStartScenarioAtPosition(
            player,
            "PROP_HUMAN_SEAT_BENCH",
            Config.legal.x,
            Config.legal.y,
            pos.z - 0.4,
            89.1,
            0,
            true,
            true
        )
        Citizen.Wait(1500)
        DoScreenFadeIn(2000)
        FreezeEntityPosition(player, false)
        TriggerEvent("Noxans:Activate")
        Citizen.Wait(2000)

        TriggerServerEvent("Sevenlife:login:laststep", fertig, legal)
        TriggerServerEvent("realtime:event")
        TriggerEvent("SevenLife:SafePos:start")
        TriggerEvent("SevenLife:OpenIt:Right")
        TriggerEvent("SevenLife:Start:OpenHud")
        Citizen.Wait(1000)

        DisplayRadar(true)
        Citizen.Wait(5000)
        ClearPedTasks(player)
        TriggerEvent("Noxans:AntiCheat:StartAntiCheat")
        TriggerServerEvent("SevenLife:Westen:Save")
    end
)

RegisterNUICallback(
    "ILLagaleReise",
    function()
        isOnCreator = false
        local player = GetPlayerPed(-1)
        local fertig = true
        local illegal = 2
        inmenu = false
        TriggerServerEvent("SevenLife:LoginSkin:MakeEntityNormalWorld")
        SetNuiFocus(false, false)
        SetCamActive(camara, false)
        RenderScriptCams(false, true, 500, true, true)
        camara = nil
        DoScreenFadeOut(100)
        Citizen.Wait(500)
        Citizen.CreateThread(
            function()
                RequestCollisionAtCoord(Config.illegal.x, Config.illegal.y, Config.illegal.z)
                while not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) do
                    Citizen.Wait(1)
                end
            end
        )
        SetEntityCoords(player, Config.illegal.x, Config.illegal.y, Config.illegal.z)
        Citizen.Wait(1500)
        DoScreenFadeIn(2000)
        FreezeEntityPosition(player, false)
        Citizen.Wait(2000)
        TriggerServerEvent("Sevenlife:login:laststep", fertig, illegal)

        TriggerEvent("SevenLife:SafePos:start")

        TriggerEvent("SevenLife:OpenIt:Right")
        TriggerEvent("SevenLife:Start:OpenHud")

        Citizen.Wait(1000)
        DisplayRadar(true)
        Citizen.Wait(5000)
        ClearPedTasks(player)
        TriggerEvent("Noxans:Activate")
        TriggerEvent("Noxans:AntiCheat:StartAntiCheat")
        TriggerServerEvent("SevenLife:Westen:Save")
    end
)

RegisterNUICallback(
    "Login",
    function(data)
        isOnCreator = false
        ESX.TriggerServerCallback(
            "SevenLife:LoginSkin:Anmelde",
            function(valid)
                if valid then
                    SetCamActive(camara, false)
                    SendNUIMessage(
                        {
                            type = "RemoveLoginPanel"
                        }
                    )
                    RenderScriptCams(false, true, 500, true, true)
                    camara = nil
                    SetNuiFocus(false, false)
                    SetTimecycleModifier("default")
                    TriggerServerEvent("sevenlife:login:spawnplayer")
                    TriggerServerEvent("SevenLife:LoginSkin:MakeEntityNormalWorld")
                    inmenu = false
                    Citizen.Wait(100)
                    TriggerEvent("SevenLife:SafePos:start")
                    TriggerEvent("SevenLife:OpenIt:Right")
                    TriggerEvent("SevenLife:Start:OpenHud")
                    Citizen.Wait(100)
                    DisplayRadar(true)
                    TriggerEvent("Noxans:AntiCheat:StartAntiCheat")
                    TriggerEvent("Noxans:Activate")
                    TriggerServerEvent("SevenLife:Westen:Save")
                end
            end,
            data.benutzername,
            data.passwort
        )
    end
)

RegisterNetEvent("sevenlife:login:spawnpos")
AddEventHandler(
    "sevenlife:login:spawnpos",
    function(PosX, PosY, PosZ)
        SetEntityCoords(GetPlayerPed(-1), PosX, PosY, PosZ, 1, 0, 0, 1)
    end
)

RegisterNetEvent("SevenLife:Char:SetCam")
AddEventHandler(
    "SevenLife:Char:SetCam",
    function(cam)
        facecoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.8, 0.6)
        clothescoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.5, 0.1)
        if cam == "kopf" then
            SetCamCoord(camara, facecoord)
        elseif cam == "ropa" then
            SetCamCoord(camara, clothescoord)
        end
    end
)
