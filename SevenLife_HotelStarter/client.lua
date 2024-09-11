-- Variables
time1 = 100
mistime1 = 1000
inarea1 = false
inmarker1 = false
notifys1 = true
time2 = 100
mistime2 = 1000
inarea2 = false
inmarker2 = false
notifys2 = true
local start = false
local firsttimecam
local firsttime
local openmenu = false
local inmarker3 = false
local notifys3 = true
local time3 = 100

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

-- Function for Init the Outside

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            Coords = GetEntityCoords(Ped)
            Citizen.Wait(time1)
            local distance =
                GetDistanceBetweenCoords(
                Coords,
                Config.MotelSpawnPlace.x,
                Config.MotelSpawnPlace.y,
                Config.MotelSpawnPlace.z,
                true
            )
            if firsttime then
                if distance < 10 then
                    time1 = 15
                    inarea1 = true
                    if distance < 1.3 then
                        time1 = 5
                        inmarker1 = true
                        if notifys1 then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke E um die Interaktionen anzugucken",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 1.4 and distance <= 2.5 then
                            inmarker1 = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    if distance >= 8 and distance <= 12 then
                        inarea1 = false
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(5)
            if firsttime then
                if inmarker1 then
                    if IsControlJustPressed(0, 38) then
                        inmarker1 = false
                        notifys1 = false
                        SetNuiFocus(true, true)
                        ESX.TriggerServerCallback(
                            "SevenLife:Hotel:GetInfos",
                            function(result)
                                SetNuiFocus(true, true)
                                TriggerEvent("sevenliferp:closenotify", false)

                                SendNUIMessage(
                                    {
                                        type = "OpenHotelOpenMenu",
                                        name = result[1].lastname
                                    }
                                )
                            end
                        )
                    end
                else
                    Citizen.Wait(100)
                end
            end
        end
    end
)

-- Marker

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(mistime1)
            if firsttime then
                if inarea1 then
                    mistime1 = 1
                    DrawMarker(
                        Config.MarkerType,
                        Config.MotelSpawnPlace.x,
                        Config.MotelSpawnPlace.y,
                        Config.MotelSpawnPlace.z,
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
                else
                    mistime1 = 1000
                end
            end
        end
    end
)

RegisterNUICallback(
    "rausMotel",
    function()
        TriggerServerEvent("SevenLife:Hotel:LeaveHouse")
        SetNuiFocus(false, false)
        RequestCollisionAtCoord(Config.Hotel.x, Config.Hotel.y, Config.Hotel.z)
        FreezeEntityPosition(Ped, true)

        SetEntityCoords(Ped, Config.Hotel.x, Config.Hotel.y, Config.Hotel.z, false, false, false, false)
        Citizen.Wait(10)
        SetEntityHeading(Ped, Config.Hotel.heading)
        while not HasCollisionLoadedAroundEntity(Ped) do
            Citizen.Wait(0)
        end
        FreezeEntityPosition(Ped, false)

        notifys1 = true
        inmenu1 = false
        inmarker1 = false
        Citizen.Wait(500)
        if not firsttimecam then
            TriggerEvent("SevenLife:FlughafenQuest:ActivateCam")
        end
    end
)

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function Animation(dict, anim, ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
end

-- Bed

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            local coords = GetEntityCoords(Ped)
            local distance = GetDistanceBetweenCoords(coords, Config.Bed.x, Config.Bed.y, Config.Bed.z, true)
            Citizen.Wait(time2)
            if firsttime then
                if distance < 10 then
                    time2 = 15
                    inarea2 = true
                    if distance < 2.5 then
                        time2 = 1
                        inmarker2 = true
                        notifys2 = true
                        if notifys2 then
                            DrawText3Ds(Config.Bed.x, Config.Bed.y, Config.Bed.z, "Drücke E um sich hinzulegen")
                        end
                    else
                        if distance >= 2.5 and distance <= 3.5 then
                            inmarker2 = false
                            notifys2 = false
                        end
                    end
                else
                    if distance >= 8 and distance <= 12 then
                        inarea2 = false
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(5)
            if firsttime then
                if inmarker2 then
                    if IsControlJustPressed(0, 38) then
                        inmarker2 = false
                        notifys2 = false
                        start = true
                        TaskStartScenarioAtPosition(
                            Ped,
                            "WORLD_HUMAN_SUNBATHE",
                            Config.Bed.x,
                            Config.Bed.y,
                            Config.Bed.z + 1.0,
                            272.48,
                            0,
                            true,
                            true
                        )
                    end
                else
                    Citizen.Wait(100)
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(7)
            if IsControlJustPressed(0, 73) then
                start = false
                notifys2 = true
                ClearPedTasks(Ped)
            end
        end
    end
)
RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        ESX.TriggerServerCallback(
            "SevenLife:HotelStarter:HausFirstTime",
            function(have)
                if have then
                    firsttime = true
                    firsttimecam = true
                else
                    firsttime = false
                    firsttimecam = false
                end
            end
        )
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            local coords = GetEntityCoords(Ped)
            local distance =
                GetDistanceBetweenCoords(coords, Config.firsttime.x, Config.firsttime.y, Config.firsttime.z, true)
            Citizen.Wait(time3)
            if not firsttime then
                time3 = 15
                if distance < 1.2 then
                    if not openmenu then
                        openmenu = true
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
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            local coords = GetEntityCoords(Ped)
            local distance =
                GetDistanceBetweenCoords(coords, Config.firsttime.x, Config.firsttime.y, Config.firsttime.z, true)
            Citizen.Wait(time3)
            if not firsttime then
                time3 = 15
                if distance < 2.5 then
                    time3 = 1
                    inmarker3 = true
                    notifys3 = true
                    if notifys3 then
                        DrawText3Ds(
                            Config.firsttime.x,
                            Config.firsttime.y,
                            Config.firsttime.z,
                            "Drücke E um den Zettel aufzuheben"
                        )
                    end
                else
                    if distance >= 2.5 and distance <= 3.5 then
                        inmarker3 = false
                        notifys3 = false
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(5)
            if not firsttime then
                if inmarker3 then
                    if IsControlJustPressed(0, 38) then
                        FreezeEntityPosition(Ped, true)
                        TaskStartScenarioInPlace(Ped, "PROP_HUMAN_BUM_SHOPPING_CART", 0, true)
                        inmarker3 = false
                        notifys3 = false
                        Citizen.Wait(1000)
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenInfo"
                            }
                        )
                    end
                else
                    Citizen.Wait(100)
                end
            end
        end
    end
)

RegisterNUICallback(
    "removepaper",
    function()
        TriggerServerEvent("SevenLife:HotelStarter:MakeOkFirst")
        firsttime = true
        openmenu = false
        SetNuiFocus(false, false)
        local Ped = GetPlayerPed(-1)
        ClearPedTasks(Ped)
        FreezeEntityPosition(Ped, false)
    end
)
