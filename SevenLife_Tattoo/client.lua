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
            MakeBlips("Tattoo", 75, v)
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
    SetBlipColour(blip, 1)
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
                                    "Drücke <span1 color = white>E</span1> um den Tatoo Katalog zu begutachten",
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
local list = {}
Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        for i, k in pairs(tattoosList) do
                            table.insert(list, tattoosList[i])
                        end
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        openshop = true
                        currentValue = "mpbeach_overlays"
                        SetNuiFocus(true, true)
                        isOnCreator = true
                        SendNUIMessage(
                            {
                                type = "opennuibarber",
                                tatto = list
                            }
                        )
                        local playerPed = PlayerPedId()
                        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
                        camcoord = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 3.0, 0.0)
                        facecoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.8, 0.6)
                        h = GetEntityHeading(PlayerPedId())
                        heading = GetEntityHeading(PlayerPedId())
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

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            local ped = PlayerPedId()

            if isOnCreator == true then
                local x, y, z = table.unpack(camcoord)

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

                if plano == "kopf" then
                    SetCamCoord(camara, facecoord)
                end

                if heading ~= GetEntityHeading(ped) then
                    SetEntityHeading(ped, heading)
                end
            end
        end
    end
)

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
        ESX.TriggerServerCallback(
            "esx_skin:getPlayerSkin",
            function(skin)
                TriggerEvent("skinchanger:loadSkin", skin)
            end
        )
        Citizen.Wait(50)
        DisplayRadar(true)
    end
)

RegisterNUICallback(
    "Kaufen",
    function(data)
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "sevenlife:friseur:checkMoneys",
            function(hasEnoughMoney)
                if hasEnoughMoney then
                    TriggerEvent(
                        "skinchanger:getSkin",
                        function(skin)
                            TriggerServerEvent("esx_skin:save", skin)
                            TriggerEvent("skinchanger:loadSkin", skin)
                        end
                    )
                    openshop = false
                    TriggerServerEvent("sevenlife:friseur:pays", Preis)
                    SetNuiFocus(false, false)
                    inmenu = false
                    notifys = true

                    isOnCreator = false
                    Citizen.Wait(100)
                    DisplayRadar(true)

                    SetCamActive(camara, false)
                    RenderScriptCams(false, true, 500, true, true)
                else
                    SetNuiFocus(false, false)
                    openshop = false
                    inmenu = false

                    notifys = true

                    isOnCreator = false
                    SetCamActive(camara, false)
                    Citizen.Wait(100)
                    DisplayRadar(true)
                    RenderScriptCams(false, true, 500, true, true)
                    ESX.TriggerServerCallback(
                        "esx_skin:getPlayerSkin",
                        function(skin)
                            TriggerEvent("skinchanger:loadSkin", skin)
                        end
                    )
                end
            end,
            Preis
        )
    end
)

RegisterNUICallback(
    "gucken",
    function(data)
        isOnCreator = false
        Preis = data.preis
        SetEntityHeading(GetPlayerPed(-1), 297.7296)
        ClearPedDecorations(GetPlayerPed(-1))
        if (GetEntityModel(GetPlayerPed(-1)) == -1667301416) then -- GIRL SKIN
            SetPedComponentVariation(GetPlayerPed(-1), 8, 34, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 11, 101, 1, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 4, 16, 0, 2)
        else -- BOY SKIN
            SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 11, 91, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 0, 2)
        end
        ApplyPedOverlay(GetPlayerPed(-1), GetHashKey("mpbeach_overlays"), GetHashKey(data.name))
        if (not DoesCamExist(cam)) then
            cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

            SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
            SetCamRot(cam, 0.0, 0.0, 0.0)
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 0, true, true)

            SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
        end

        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
        local x2, y2, z2, rot = tonumber(data.x), tonumber(data.y), tonumber(data.z), tonumber(data.rot)
        SetCamCoord(cam, x + x2, y + y2, z + z2)
        SetCamRot(cam, 0.0, 0.0, rot)
    end
)
