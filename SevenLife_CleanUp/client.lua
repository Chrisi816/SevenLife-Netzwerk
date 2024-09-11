--------------------------------------------------------------------------------------------------------------
------------------------------------------------ESX-----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

ESX = nil
local verkuefer

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
Citizen.CreateThread(
    function()
        for i, v in pairs(Config.locations) do
            local blips = vector2(v.x, v.y)
            local blip = AddBlipForCoord(blips.x, blips.y)

            SetBlipSprite(blip, 524)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.9)
            SetBlipColour(blip, 67)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Waschstraßen")
            EndTextCommandSetBlipName(blip)
        end
    end
)

local notifys = true
local area = false
local inmarker = false
local inmenu = false
local timemain = 100

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(6)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenWaschanlage"
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

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)
            local inCar = IsPedInAnyVehicle(ped, false)
            if inCar then
                for k, v in pairs(Config.locations) do
                    local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                    if distance < 15 then
                        area = true
                        timemain = 15
                        if distance < 2 then
                            inmarker = true

                            if notifys then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um dein Auto zu waschen",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 2.1 and distance <= 3 then
                                inmarker = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        timemain = 100
                        area = false
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
            Citizen.Wait(1)
            local ped = GetPlayerPed(-1)

            local inCar = IsPedInAnyVehicle(ped, false)
            if inCar then
                if area then
                    for i, v in pairs(Config.locations) do
                        DrawMarker(20, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 234, 0, 122, 200, 1, 1, 0, 1)
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
RegisterNUICallback(
    "CloseMenu",
    function()
        inmenu = false
        notifys = true
        SetNuiFocus(false, false)
    end
)

RegisterNUICallback(
    "makeweasche1",
    function()
        inmenu = false
        notifys = true
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:CleanUp:CheckMoney",
            function(enoughmoney)
                if enoughmoney then
                    local ped = GetPlayerPed(-1)
                    local car = GetVehiclePedIsIn(GetPlayerPed(-1), false)

                    WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 0.6)
                    SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)), 6.0)

                    FreezeEntityPosition(ped, true)
                    Citizen.Wait(100)
                    if car then
                        Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(car))
                    end
                    Citizen.Wait(1300)
                    FreezeEntityPosition(ped, false)
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Waschanlage",
                        "Du besitzt zu wenig Geld um dieses Angebot annzunehmen",
                        2000
                    )
                end
            end,
            80
        )
    end
)
RegisterNUICallback(
    "makeweasche2",
    function()
        inmenu = false
        notifys = true
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:CleanUp:CheckMoney",
            function(enoughmoney)
                if enoughmoney then
                    local ped = GetPlayerPed(-1)
                    local car = GetVehiclePedIsIn(GetPlayerPed(-1), false)

                    WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 0.8)
                    SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)), 4.0)

                    FreezeEntityPosition(ped, true)
                    Citizen.Wait(100)
                    if car then
                        Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(car))
                    end
                    Citizen.Wait(1300)
                    FreezeEntityPosition(ped, false)
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Waschanlage",
                        "Du besitzt zu wenig Geld um dieses Angebot annzunehmen",
                        2000
                    )
                end
            end,
            100
        )
    end
)
RegisterNUICallback(
    "makeweasche3",
    function()
        inmenu = false
        notifys = true
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:CleanUp:CheckMoney",
            function(enoughmoney)
                if enoughmoney then
                    local ped = GetPlayerPed(-1)
                    local car = GetVehiclePedIsIn(GetPlayerPed(-1), false)

                    WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
                    SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)), 0.0)

                    FreezeEntityPosition(ped, true)
                    Citizen.Wait(100)
                    if car then
                        Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(car))
                    end
                    Citizen.Wait(1300)
                    FreezeEntityPosition(ped, false)
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Waschanlage",
                        "Du besitzt zu wenig Geld um dieses Angebot annzunehmen",
                        2000
                    )
                end
            end,
            120
        )
    end
)
