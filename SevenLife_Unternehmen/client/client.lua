--------------------------------------------------------------------------------------------------------------
--------------------------------------------Variables--------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
local HaveUnternehmen = false
local SpawnedCars = {}
local area = false
local time = 2000
local timemain = 100
local inmarker = false
local activenotify = true
local inhome = false
local inmenu = false
local areasgarage = false
local timemainsgarage = 100
local inmenusgarage = false
local inmarkerhomegarage = false
local timesgarage = 10
local areasdach = false
local timemainsdach = 100
local inmarkerhomedach = false
local timesdach = 10
--------------------------------------------------------------------------------------------------------------
------------------------------------------------ESX-----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

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
            Citizen.Wait(10)
        end
    end
)

--------------------------------------------------------------------------------------------------------------
-------------------------------------------------Locale-------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(
    function()
        MakeUnternehmsBlips()
        while true do
            Citizen.Wait(timemain)
            local distance = GetDistanceBetweenCoords(Coord, Config.aufzug.x, Config.aufzug.y, Config.aufzug.z, true)
            if distance < 15 then
                area = true
                timemain = 10
                if distance < 1.1 then
                    inmarker = true
                    if activenotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um in dein Büro zu kommen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.1 and distance <= 2 then
                        inmarker = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                area = false
            end
        end
    end
)
--------------------------------------------------------------------------------------------------------------
------------------------------------------------Key-----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    ESX.TriggerServerCallback(
                        "SevenLife:Unternehmen:CheckIfPlayerHaveUnternehmen",
                        function(owned)
                            SetNuiFocus(true, true)
                            if owned then
                                SendNUIMessage(
                                    {
                                        type = "OpenNormalMenu"
                                    }
                                )
                            else
                                SendNUIMessage(
                                    {
                                        type = "OpenMenuBesuch"
                                    }
                                )
                            end
                        end
                    )
                end
            end
        end
    end
)
--------------------------------------------------------------------------------------------------------------
----------------------------------------------------Ped-------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(100)
            Ped = PlayerPedId()
            Coord = GetEntityCoords(Ped)
        end
    end
)
--------------------------------------------------------------------------------------------------------------
----------------------------------------------------Marker----------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time)
            if area and not inmenu then
                time = 1
                DrawMarker(
                    1,
                    Config.aufzug.x,
                    Config.aufzug.y,
                    Config.aufzug.z,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.8,
                    0.8,
                    0.8,
                    236,
                    80,
                    80,
                    155,
                    false,
                    false,
                    2,
                    false,
                    0,
                    0,
                    0,
                    0
                )
            else
                time = 2000
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
-----------------------------------------------------Blips----------------------------------------------------
--------------------------------------------------------------------------------------------------------------
function MakeUnternehmsBlips()
    local blips = vector3(Config.aufzug.x, Config.aufzug.y, Config.aufzug.z)
    local blip = AddBlipForCoord(blips.x, blips.y, blips.z)
    SetBlipSprite(blip, 525)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 21)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Unternehmens Appartement")
    EndTextCommandSetBlipName(blip)
end
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------Go out Funktion----------------------------------------------
--------------------------------------------------------------------------------------------------------------
local xcoordout, ycoordout, zcoordout
local areas = false
local timemains = 100
local inmenus = false
local inmarkerhome = false
local times = 10
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemains)
            for k, v in pairs(Config.Interion) do
                local distance = GetDistanceBetweenCoords(Coord, v.gooutx, v.goouty, v.gooutz, true)
                if distance < 10 then
                    xcoordout = v.gooutx
                    ycoordout = v.goouty
                    zcoordout = v.gooutz
                    areas = true
                    timemains = 10
                    if distance < 1.1 then
                        inmarkerhome = true
                        if activenotify then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke E um die Appartment Optionen zu sehen",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 1.1 and distance <= 2 then
                            inmarkerhome = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    if distance >= 10.1 and distance <= 20 then
                        timemains = 100
                        areas = false
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if inmarkerhome then
                if IsControlJustPressed(0, 38) then
                    SetNuiFocus(true, true)
                    SendNUIMessage(
                        {
                            type = "MakeInteraktionsMenu"
                        }
                    )
                end
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
-------------------------------------------------Go out Marker------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(times)
            if areas then
                times = 1
                DrawMarker(
                    1,
                    xcoordout,
                    ycoordout,
                    zcoordout,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.8,
                    0.8,
                    0.8,
                    236,
                    80,
                    80,
                    155,
                    false,
                    false,
                    2,
                    false,
                    0,
                    0,
                    0,
                    0
                )
            else
                time = 2000
            end
        end
    end
)

RegisterNUICallback(
    "LeaveApartment",
    function(data)
        for i = 1, #SpawnedCars do
            ESX.Game.DeleteVehicle(SpawnedCars[i])
        end
        SetNuiFocus(false, false)
        local Ped = GetPlayerPed(-1)
        RequestCollisionAtCoord()
        FreezeEntityPosition(Ped, true)

        SetEntityCoords(Ped, Config.aufzug.x, Config.aufzug.y, Config.aufzug.z, false, false, false, false)
        while not HasCollisionLoadedAroundEntity(Ped) do
            Citizen.Wait(0)
        end
        FreezeEntityPosition(Ped, false)
        Citizen.Wait(100)
        DeleteEntity(ped1)
        pedloaded = false
        inmarker = false
        areas = false
        inmarkerhome = false
        inmarkerhomedach = false
        inmarkerhomegarage = false
    end
)
RegisterNUICallback(
    "EnterApartment",
    function()
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Unternehmen:CheckBuero",
            function(buero, firmenname)
                firmennames = firmenname
                for k, v in pairs(Config.Interion) do
                    if v.buero == buero then
                        Buero = v.buero

                        inmarker = false
                        RequestCollisionAtCoord(v.x, v.y, v.z)
                        FreezeEntityPosition(Ped, true)

                        SetEntityCoords(Ped, v.x, v.y, v.z, false, false, false, false)
                        while not HasCollisionLoadedAroundEntity(Ped) do
                            Citizen.Wait(0)
                        end
                        FreezeEntityPosition(Ped, false)
                        Citizen.Wait(100)
                        TriggerEvent("sevenliferp:closenotify", false)
                        inmarker = false
                        inmarkerhome = false
                        inmarkerhomedach = false
                        inmarkerhomegarage = false
                    end
                end
            end
        )
    end
)
RegisterNUICallback(
    "escape",
    function()
        SetNuiFocus(false, false)
    end
)
RegisterNUICallback(
    "EnterGarage",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Garage:GetCars",
            function(result)
                SpawnCars(result)
                SetNuiFocus(false, false)
                inmarker = false
                RequestCollisionAtCoord(Config.garage.x, Config.garage.y, Config.garage.z)
                FreezeEntityPosition(Ped, true)

                SetEntityCoords(Ped, Config.garage.x, Config.garage.y, Config.garage.z, false, false, false, false)
                while not HasCollisionLoadedAroundEntity(Ped) do
                    Citizen.Wait(0)
                end
                DeleteEntity(ped1)
                pedloaded = false
                FreezeEntityPosition(Ped, false)
                SetEntityHeading(Ped, Config.garage.h)
                Citizen.Wait(100)
                TriggerEvent("sevenliferp:closenotify", false)
                inmarker = false
                inmarkerhome = false
                inmarkerhomedach = false
                inmarkerhomegarage = false
            end,
            firmennames
        )
    end
)
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------Go out Funktion----------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemainsgarage)

            local distance =
                GetDistanceBetweenCoords(Coord, Config.LeaveGarage.x, Config.LeaveGarage.y, Config.LeaveGarage.z, true)
            if distance < 6 then
                areasgarage = true
                timemainsgarage = 10
                if distance < 1.1 then
                    inmarkerhomegarage = true
                    if activenotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um die Garage zu verlassen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.1 and distance <= 2 then
                        inmarkerhomegarage = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                timemainsgarage = 100
                areasgarage = false
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if inmarkerhomegarage then
                if IsControlJustPressed(0, 38) then
                    SetNuiFocus(true, true)
                    SendNUIMessage(
                        {
                            type = "LeaveGarage"
                        }
                    )
                end
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
-------------------------------------------------Go out Marker------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timesgarage)
            if areasgarage then
                timesgarage = 1
                DrawMarker(
                    1,
                    Config.LeaveGarage.x,
                    Config.LeaveGarage.y,
                    Config.LeaveGarage.z,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.8,
                    0.8,
                    0.8,
                    236,
                    80,
                    80,
                    155,
                    false,
                    false,
                    2,
                    false,
                    0,
                    0,
                    0,
                    0
                )
            else
                time = 2000
            end
        end
    end
)
function SpawnCars(result)
    for k, v in ipairs(Config.AutoSpots) do
        for ks, _v in ipairs(result) do
            local vehiclearea = ESX.Game.GetVehiclesInArea(_v, 4.0)
            if cars <= 4 then
                if #vehiclearea == 0 then
                    ESX.Game.SpawnVehicle(
                        _v.model,
                        v,
                        v.h,
                        function(vehicle)
                            if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                                Citizen.Wait(200)
                                cars = cars + 1
                                table.insert(SpawnedCars, vehicle)
                            end
                        end
                    )
                else
                    if ks == 4 then
                        print("Alle Spawn Plätze sind belegt ")
                    end
                end
            end
        end
    end
end

RegisterNUICallback(
    "EnterDach",
    function()
        SetNuiFocus(false, false)
        inmarker = false
        RequestCollisionAtCoord(Config.Dach.x, Config.Dach.y, Config.Dach.z)
        FreezeEntityPosition(Ped, true)

        SetEntityCoords(Ped, Config.Dach.x, Config.Dach.y, Config.Dach.z, false, false, false, false)
        while not HasCollisionLoadedAroundEntity(Ped) do
            Citizen.Wait(0)
        end
        FreezeEntityPosition(Ped, false)
        SetEntityHeading(Ped, Config.Dach.h)
        Citizen.Wait(100)
        TriggerEvent("sevenliferp:closenotify", false)
        inmarker = false
        DeleteEntity(ped1)
        pedloaded = false
        inmarkerhome = false
        inmarkerhomedach = false
        inmarkerhomegarage = false
    end
)
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------Go out Funktion----------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timesdach)

            local distance = GetDistanceBetweenCoords(Coord, Config.Dach.x, Config.Dach.y, Config.Dach.z, true)
            if distance < 6 then
                areasdach = true
                timesdach = 10
                if distance < 1.1 then
                    inmarkerhomedach = true
                    if activenotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um den Dach zu verlassen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.1 and distance <= 2 then
                        inmarkerhomedach = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                timesdach = 100
                areasdach = false
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if inmarkerhomedach then
                if IsControlJustPressed(0, 38) then
                    SetNuiFocus(true, true)
                    SendNUIMessage(
                        {
                            type = "LeaveDach"
                        }
                    )
                end
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
-------------------------------------------------Go out Marker------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemainsdach)
            if areasdach then
                timemainsdach = 1
                DrawMarker(
                    1,
                    Config.Dach.x,
                    Config.Dach.y,
                    Config.Dach.z,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.8,
                    0.8,
                    0.8,
                    236,
                    80,
                    80,
                    155,
                    false,
                    false,
                    2,
                    false,
                    0,
                    0,
                    0,
                    0
                )
            else
                time = 2000
            end
        end
    end
)
