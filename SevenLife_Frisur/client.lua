ESX = nil
Citizen.CreateThread(
    function()
        while not ESX do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )

            Citizen.Wait(500)
        end
    end
)
local skinproblemopacity = 0.1
local freckleopacity = 0.1
local camcoord
local plano = "kopf"
local allowmarker = false
Citizen.CreateThread(
    function()
        for k, v in ipairs(Config.Shops) do
            MakeBlips("Friseur", 71, v)
        end
    end
)
--------------------------------------------------------------------------------------------------------------
-------------------------------------------Blips function-----------------------------------------------------
--------------------------------------------------------------------------------------------------------------

function MakeBlips(name, sprite, coords)
    local blip = AddBlipForCoord(coords)

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 51)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

--------------------------------------------------------------------------------------------------------------
-------------------------------------------Locale Systems-----------------------------------------------------
--------------------------------------------------------------------------------------------------------------
local notifys = true
local inmarker = false
local inmenu = false
local openshop = false
local time = 100
Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            local player = GetPlayerPed(-1)
            if openshop == false then
                for k, v in pairs(Config.Shopse) do
                    Citizen.Wait(time)
                    local coords = GetEntityCoords(player)
                    distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                    if distance < 10 then
                        time = 15
                        allowmarker = true
                        if distance < 2 then
                            time = 5
                            inmarker = true
                            if notifys then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um den Friseur Katalog zu begutachten",
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
                        if distance >= 5 and distance <= 10 then
                            allowmarker = false
                        end
                    end
                end
            else
                Citizen.Wait(2000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        TriggerEvent(
                            "skinchanger:getSkin",
                            function(skin)
                                lastSkin = skin
                            end
                        )
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        openshop = true
                        SetNuiFocus(true, true)
                        isOnCreator = true
                        SendNUIMessage(
                            {
                                type = "opennuibarber"
                            }
                        )
                        local playerPed = PlayerPedId()
                        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
                        camcoord = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 3.0, 0.0)
                        facecoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.8, 0.6)
                        h = GetEntityHeading(PlayerPedId())
                        heading = GetEntityHeading(PlayerPedId())
                        EnableCam()
                        Removenormalhud()
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        local time = 2000
        while true do
            Citizen.Wait(time)
            if allowmarker then
                time = 1
                for k, v in pairs(Config.Shopse) do
                    DrawMarker(
                        Config.MarkerType,
                        v.x,
                        v.y,
                        v.z,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        Config.MarkerSize,
                        Config.MarkerColor.r,
                        Config.MarkerColor.g,
                        Config.MarkerColor.b,
                        100,
                        false,
                        true,
                        2,
                        false,
                        nil,
                        nil,
                        false
                    )
                end
            else
                time = 2000
            end
        end
    end
)
function Removenormalhud()
    Citizen.CreateThread(
        function()
            while inmenu do
                Citizen.Wait(1)
                DisplayRadar(false)
                TriggerEvent("sevenlife:removeallhud")
            end
        end
    )
end

local bartvar = -1
local beardcolor = 0
RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
        inmenu = false

        notifys = true
        openshop = false
        isOnCreator = false
        SetCamActive(camara, false)
        RenderScriptCams(false, true, 500, true, true)

        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)
function ChangedValue(value1, value2)
    if value1 ~= value2 then
        return true
    else
        return false
    end
end
local hair = 0
local hair2 = 1
RegisterNUICallback(
    "Haar1",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hair, data.Haar1) then
            hair = tonumber(data.Haar1)
            SetPedComponentVariation(player, 2, hair, hair2, 2)
        end
    end
)
RegisterNUICallback(
    "Haar2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hair, data.Haar2) then
            hair2 = tonumber(data.Haar2)
            SetPedComponentVariation(player, 2, hair, hair2, 2)
        end
    end
)
local haircolor = 0
local haircolor2 = 0
RegisterNUICallback(
    "Haar-farbe1",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hair, data.haarfarbe1) then
            haircolor = tonumber(data.haarfarbe1)
            SetPedHairColor(player, haircolor, haircolor2)
        end
    end
)
RegisterNUICallback(
    "Haar-farbe2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hair, data.haarfarbe2) then
            haircolor2 = tonumber(data.haarfarbe2)
            SetPedHairColor(player, haircolor, haircolor2)
        end
    end
)

RegisterNUICallback(
    "Kaufen",
    function()
        ESX.TriggerServerCallback(
            "sevenlife:friseur:checkMoney",
            function(hasEnoughMoney)
                if hasEnoughMoney then
                    TriggerEvent(
                        "skinchanger:getSkin",
                        function(skin)
                            if skin ~= nil then
                                skin["hair_1"] = tonumber(hair)
                                skin["hair_2"] = tonumber(hair2)
                                skin["hair_color_1"] = tonumber(haircolor)
                                skin["hair_color_2"] = tonumber(haircolor2)
                                skin["beard_1"] = tonumber(bartvar)
                                skin["beard_2"] = 10
                                skin["beard_3"] = tonumber(beardcolor)
                                TriggerEvent("skinchanger:loadSkin", skin)
                                TriggerServerEvent("esx_skin:save", skin)
                            end
                        end
                    )

                    openshop = false
                    TriggerServerEvent("sevenlife:friseur:pay")
                    SetNuiFocus(false, false)
                    inmenu = false
                    notifys = true
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Friseur", "Firseur erfolgreich gekauft", 2000)
                    isOnCreator = false
                    Citizen.Wait(1000)
                    DisplayRadar(true)

                    SetCamActive(camara, false)
                    RenderScriptCams(false, true, 500, true, true)
                else
                    SetNuiFocus(false, false)
                    openshop = false
                    inmenu = false
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Friseur", "Du besitzt zu wenig Geld", 2000)
                    notifys = true
                    TriggerEvent("skinchanger:loadSkin", lastSkin)
                    isOnCreator = false
                    SetCamActive(camara, false)
                    Citizen.Wait(1000)
                    DisplayRadar(true)
                    RenderScriptCams(false, true, 500, true, true)
                end
            end
        )
    end
)

RegisterNUICallback(
    "BartVar",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(bartvar, data.eyecolor) then
            bartvar = tonumber(data.eyecolor)
            SetPedHeadOverlay(player, 1, bartvar, 1.0)
        end
    end
)

RegisterNUICallback(
    "Bart-Farbe",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(beardcolor, data.eyebrow) then
            beardcolor = tonumber(data.eyebrow)
            SetPedHeadOverlayColor(player, 1, 1, beardcolor, 1)
        end
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
        TriggerEvent("SevenLife:Char:SetCam")
        cam = "kopf"
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
        TriggerEvent("SevenLife:Char:SetCam")
        cam = "kopf"
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
