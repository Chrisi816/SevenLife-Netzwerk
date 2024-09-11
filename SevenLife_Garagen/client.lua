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
            Citizen.Wait(1000)
        end
    end
)

--------------------------------------------------------------------------------------------------------------
------------------------------------------------Blips---------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        Citizen.Wait(500)
        for k, v in pairs(Config.garages) do
            MakeBlips("Garage", 50, v.x, v.y)
        end
    end
)

function MakeBlips(name, sprite, x, y)
    local blips = vector2(x, y)
    local blip = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 61)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

--------------------------------------------------------------------------------------------------------------
-----------------------------------------Locations Locale-----------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local msg
local msgeins
local msgzwei
local garage
local notifys = true
local inmarker = false
local inmenu = false
local opengarage = false
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
                        openshop = true
                        TriggerEvent("sevenlife:openmenugarage")
                        TriggerEvent("SevenLife:Garage:MakeAutos")
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

            for k, v in pairs(Config.garages) do
                local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                if distance < 15 then
                    area = true
                    timemain = 15
                    if distance < 2 then
                        garage = v.garage
                        inmarker = true

                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um die Garage zu begutachten",
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
)

--------------------------------------------------------------------------------------------------------------
------------------------------------------------Markers-------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local inarea
Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            player = GetPlayerPed(-1)
            for k, v in pairs(Config.garages) do
                Citizen.Wait(150)
                local coords = GetEntityCoords(player)
                local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                if distance < 15 then
                    inarea = true
                    coordx = v.x
                    coordy = v.y
                    coordz = v.z
                else
                    if distance > 15 and distance <= 29 then
                        inarea = false
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
            local area = inarea
            Citizen.Wait(1)
            if opengarage == false then
                if area then
                    DrawMarker(
                        20,
                        coordx,
                        coordy,
                        coordz,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0.8,
                        0.8,
                        0.8,
                        234,
                        0,
                        122,
                        200,
                        1,
                        1,
                        0,
                        1
                    )
                end
            end
        end
    end
)
RegisterNUICallback(
    "make-parkin",
    function(data, cb)
        local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(-1)), 35.0)

        for k, v in pairs(vehicles) do
            ESX.TriggerServerCallback(
                "sevenlife:checkifcarisowned",
                function(owned)
                    if owned then
                        local fuel = exports["SevenLife_Fuel"]:GetFuelLevel(v)
                        fuel = math.floor(fuel + 0.5)
                        AddCar(GetVehicleNumberPlateText(v), GetDisplayNameFromVehicleModel(GetEntityModel(v)), fuel)
                    end
                end,
                GetVehicleNumberPlateText(v),
                garage
            )
        end
    end
)

RegisterNetEvent("SevenLife:Garage:MakeAutos")
AddEventHandler(
    "SevenLife:Garage:MakeAutos",
    function()
        local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(-1)), 35.0)

        for k, v in pairs(vehicles) do
            ESX.TriggerServerCallback(
                "sevenlife:checkifcarisowned",
                function(owned)
                    if owned then
                        local fuel = exports["SevenLife_Fuel"]:GetFuelLevel(v)
                        fuel = math.floor(fuel + 0.5)
                        AddCar(GetVehicleNumberPlateText(v), GetDisplayNameFromVehicleModel(GetEntityModel(v)), fuel)
                    end
                end,
                GetVehicleNumberPlateText(v),
                garage
            )
        end
    end
)

function AddCar(plate, model, fuel)
    SendNUIMessage(
        {
            action = "addgarage",
            plate = plate,
            model = model,
            fuel = fuel
        }
    )
end

RegisterNUICallback(
    "escape",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
        openshop = false
    end
)

RegisterNUICallback(
    "park-in",
    function(data, cb)
        local vehiclese = ESX.Game.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(-1)), 35.0)
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
        for k, v in pairs(vehiclese) do
            if GetVehicleNumberPlateText(v) == data.plate then
                local fuel = exports["SevenLife_Fuel"]:GetFuelLevel(v)
                TriggerServerEvent(
                    "sevenlife:savecartile",
                    GetVehicleNumberPlateText(v),
                    ESX.Game.GetVehicleProperties(v)
                )
                fuel = math.floor(fuel + 0.5)
                TriggerEvent("SevenLife:TimetCustom:Notify", "Success", "Auto erfolgreich eingeparkt", 3000)
                TriggerServerEvent("sevenlife:changemode", GetVehicleNumberPlateText(v), true)
                TriggerServerEvent("SevenLife:SafeFuelGarage", GetVehicleNumberPlateText(v), fuel)

                TriggerServerEvent("SevenLife:Garage:InsertGarage", ESX.Math.Trim(GetVehicleNumberPlateText(v)), garage)
                ESX.Game.DeleteVehicle(v)
            end
        end
    end
)

RegisterNUICallback(
    "enable-parkout",
    function(data, cb)
        if garage == "20" or garage == "27" or garage == "28" then
            ESX.TriggerServerCallback(
                "sevenlife:loadplanes",
                function(ownedCars)
                    for _, v in pairs(ownedCars) do
                        local nickname = v.nickname
                        local hash = v.vehicle.model
                        local vehname = GetDisplayNameFromVehicleModel(hash)
                        local labelname = GetLabelText(vehname)

                        local plate = v.plate
                        local fuel = v.fuel
                        if nickname ~= nil then
                            labelname = v.nickname
                        end
                        Garage(plate, fuel, labelname)
                    end
                end,
                garage
            )
        else
            if garage == "21" or garage == "29" then
                ESX.TriggerServerCallback(
                    "sevenlife:loadboots",
                    function(ownedCars)
                        for _, v in pairs(ownedCars) do
                            local nickname = v.nickname
                            local hash = v.vehicle.model
                            local vehname = GetDisplayNameFromVehicleModel(hash)
                            local labelname = GetLabelText(vehname)
                            local plate = v.plate
                            local fuel = v.fuel
                            if nickname ~= nil then
                                labelname = v.nickname
                            end
                            Garage(plate, fuel, labelname)
                        end
                    end,
                    garage
                )
            else
                ESX.TriggerServerCallback(
                    "sevenlife:loadvehicle",
                    function(ownedCars)
                        for _, v in pairs(ownedCars) do
                            local nickname = v.nickname
                            local hash = v.vehicle.model
                            local vehname = GetDisplayNameFromVehicleModel(hash)
                            local labelname = GetLabelText(vehname)
                            local plate = v.plate
                            local fuel = v.fuel
                            if nickname ~= nil then
                                labelname = v.nickname
                            end
                            Garage(plate, fuel, labelname)
                        end
                    end,
                    garage
                )
            end
        end
    end
)

function Garage(plate, fuel, model)
    SendNUIMessage(
        {
            action = "addausparken",
            plate = plate,
            model = model,
            fuel = fuel
        }
    )
end
RegisterNUICallback(
    "park-out",
    function(data, cb)
        ESX.TriggerServerCallback(
            "sevenlife:spawnvehicle",
            function(vehicle)
                SetNuiFocus(false, false)
                local player = GetPlayerPed(-1)
                local carmechanic = json.decode(vehicle[1].vehicle)
                local plate = vehicle[1].plate
                for k, v in pairs(Config.spawnpoint) do
                    if garage == v.garage then
                        coordsspawngarage = vector3(v.x, v.y, v.z)
                        headingspawn = v.heading
                    end
                end
                TriggerServerEvent("SevenLife:Garage:InsertGarage", plate, 0)
                inmenu = false
                inmarker = false
                notifys = true
                ESX.Game.SpawnVehicle(
                    carmechanic.model,
                    coordsspawngarage,
                    headingspawn,
                    function(vehicles)
                        ESX.Game.SetVehicleProperties(vehicles, carmechanic)
                        SetVehRadioStation(vehicles, "OFF")
                        TaskWarpPedIntoVehicle(player, vehicles, -1)
                        Citizen.Wait(50)
                        TriggerEvent("sevenliferp:closenotify", false)

                        TriggerEvent("SevenLife:TimetCustom:Notify", "Success", "Auto erfolgreich ausgeparkt", 3000)
                        SetVehicleNumberPlateText(vehicles, plate)
                        TriggerServerEvent("sevenlife:changemode", " " .. data.plate, false)
                        inmarker = false
                        Citizen.Wait(1000)
                        exports["SevenLife_Fuel"]:SetFuel(vehicle, data.fuel)
                    end
                )
            end,
            data.plate
        )
    end
)
RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(true, true)
        inmenu = false
        DisplayRadar(true)
        notifys = true
        openshop = false
        isOnCreator = false
    end
)
RegisterNUICallback(
    "updatename",
    function(data)
        TriggerServerEvent("SevenLife:Garagen:ChangeName", data.inputting, data.plate)
    end
)
RegisterNetEvent("SevenLife:Garagen:Update")
AddEventHandler(
    "SevenLife:Garagen:Update",
    function()
        print(1)
        if garage == "20" or garage == "27" or garage == "28" then
            ESX.TriggerServerCallback(
                "sevenlife:loadplanes",
                function(ownedCars)
                    for _, v in pairs(ownedCars) do
                        local nickname = v.nickname
                        local hash = v.vehicle.model
                        local vehname = GetDisplayNameFromVehicleModel(hash)
                        local labelname = GetLabelText(vehname)

                        local plate = v.plate
                        local fuel = v.fuel
                        if nickname ~= nil then
                            labelname = v.nickname
                        end
                        Garage(plate, fuel, labelname)
                    end
                end,
                garage
            )
        else
            if garage == "21" or garage == "29" then
                ESX.TriggerServerCallback(
                    "sevenlife:loadboots",
                    function(ownedCars)
                        for _, v in pairs(ownedCars) do
                            local nickname = v.nickname
                            local hash = v.vehicle.model
                            local vehname = GetDisplayNameFromVehicleModel(hash)
                            local labelname = GetLabelText(vehname)
                            local plate = v.plate
                            local fuel = v.fuel
                            if nickname ~= nil then
                                labelname = v.nickname
                            end
                            Garage(plate, fuel, labelname)
                        end
                    end,
                    garage
                )
            else
                ESX.TriggerServerCallback(
                    "sevenlife:loadvehicle",
                    function(ownedCars)
                        for _, v in pairs(ownedCars) do
                            local nickname = v.nickname
                            local hash = v.vehicle.model
                            local vehname = GetDisplayNameFromVehicleModel(hash)
                            local labelname = GetLabelText(vehname)
                            local plate = v.plate
                            local fuel = v.fuel
                            if nickname ~= nil then
                                labelname = v.nickname
                            end
                            Garage(plate, fuel, labelname)
                        end
                    end,
                    garage
                )
            end
        end
    end
)
