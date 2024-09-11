local allowednotify = true
-- ESX
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

-- Notify

Citizen.CreateThread(
    function()
        local time = 200
        Citizen.Wait(200)
        shown = true
        while true do
            local ped = GetPlayerPed(-1)
            Citizen.Wait(time)

            for w_, v in pairs(Config.Tankstellen) do
                local coord = GetEntityCoords(ped)

                local distance = GetDistanceBetweenCoords(coord, v.x, v.y, v.z, true)
                if distance < 20 then
                    tanke = v.tanknumber
                    time = 100
                    if shown then
                        data = GetTankeData(tanke)
                    end
                    incircle = true
                else
                    if distance >= 20.1 and distance <= 40 then
                        shown = 1
                        time = 200
                        incircle = false
                        allowednotify = true
                    end
                end
            end
        end
    end
)

-- Display

Citizen.CreateThread(
    function()
        local times = 2000
        while true do
            Citizen.Wait(times)
            if incircle then
                times = 1000
                if allowednotify then
                    local message =
                        "Name: " ..
                        datas[1].firmenname ..
                            "</br> Besitzer: " ..
                                datas[1].owner ..
                                    "</br>Liter: " ..
                                        datas[1].activefuel ..
                                            "</br>Wert: " ..
                                                datas[1].wert .. "</br> Preis pro L. : " .. datas[1].preisproliter
                    TriggerEvent("SevenLife:Tankstelle:AddInfo", message)
                    Citizen.Wait(3000)
                    allowednotify = false
                end
            else
                times = 2000
            end
        end
    end
)

-- Get Tank

function GetTankeData(tankenummer)
    shown = false
    ESX.TriggerServerCallback(
        "sevenlife:fuel:gettankedata",
        function(data)
            datas = data
        end,
        tankenummer
    )
end
-- Blips Display
Citizen.CreateThread(
    function()
        for _, coords in pairs(Config.Tankstellen) do
            if coords.tanknumber ~= 29 and coords.tanknumber ~= 30 then
                CreateBlip(coords.x, coords.y, coords.z)
            end
        end
        CreateBlips(Config.Flieger.x, Config.Flieger.y, Config.Flieger.z)
        CreateBlipe(Config.Boot.x, Config.Boot.y, Config.Boot.z)
    end
)

function CreateBlips(coordsx, coordsy, coordsz)
    local blips = vector3(coordsx, coordsy, coordsz)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 361)
    SetBlipScale(blip1, 0.9)
    SetBlipColour(blip1, 4)
    SetBlipDisplay(blip1, 4)
    SetBlipAsShortRange(blip1, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Flugzeug Tankstelle")
    EndTextCommandSetBlipName(blip1)

    return blip1
end

function CreateBlipe(coordsx, coordsy, coordsz)
    local blips = vector3(coordsx, coordsy, coordsz)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 361)
    SetBlipScale(blip1, 0.9)
    SetBlipColour(blip1, 4)
    SetBlipDisplay(blip1, 4)
    SetBlipAsShortRange(blip1, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Boots Tankstelle")
    EndTextCommandSetBlipName(blip1)

    return blip1
end

----- Tankstelle
local NearPump = false
local iscurrentlyfueling = false
local curentfuellevel = 0.0
local currentcost = 0.0
local currentCash = 1000
local isFuelSynced = false

function ManageUsageOfFuel(car)
    if not DecorExistOn(car, "_FUEL_LEVEL") then
        SetFuel(car, math.random(200, 800) / 10)
    else
        if not isFuelSynced then
            SetFuel(car, GetFuelLevel(car))
            isFuelSynced = true
        end
    end

    if GetIsVehicleEngineRunning(car) then
        SetFuel(
            car,
            GetFuelLevel(car) -
                Config.FuelUsage[Round(GetVehicleCurrentRpm(car), 1)] * (Config.Classes[GetVehicleClass(car)] or 1.0) /
                    10
        )
    end
end

function FindNearestFuelPump(ped)
    local coords = GetEntityCoords(ped)
    local Pumps = {}
    local handle, object = FindFirstObject()
    local success

    repeat
        if Config.PumpModels[GetEntityModel(object)] then
            table.insert(Pumps, object)
        end

        success, object = FindNextObject(handle, object)
    until not success

    EndFindObject(handle)

    local pumpObject = 0
    local pumpDistance = 1000

    for _, fuelPumpObject in pairs(Pumps) do
        local distancechecking = GetDistanceBetweenCoords(coords, GetEntityCoords(fuelPumpObject))

        if distancechecking < pumpDistance then
            pumpDistance = distancechecking
            pumpObject = fuelPumpObject
        end
    end

    return pumpObject, pumpDistance
end

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        DecorRegister("_FUEL_LEVEL", 1)
        while true do
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local car = GetVehiclePedIsIn(ped, false)
                if GetPedInVehicleSeat(car, -1) == ped then
                    ManageUsageOfFuel(car)
                end
            else
                if isFuelSynced then
                    isFuelSynced = false
                end
            end
            Citizen.Wait(1000)
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            local ped = PlayerPedId()
            Citizen.Wait(250)
            local pumpob, distancepump = FindNearestFuelPump(ped)
            if distancepump < 2.5 then
                NearPump = pumpob
                ESX.TriggerServerCallback(
                    "sevenlife:fuel:getplayermoney",
                    function(money)
                        currentCash = money
                    end
                )
            else
                NearPump = false
                Citizen.Wait(200)
            end
        end
    end
)

local invehicle
local callonlyone = true
local onlyoncefuel = true
local nocash = true
local isFueling = false
local onlyone = true
Citizen.CreateThread(
    function()
        local time = 50
        Citizen.Wait(100)

        while true do
            Citizen.Wait(time)
            local ped = PlayerPedId()
            if
                not iscurrentlyfueling and
                    ((NearPump and GetEntityHealth(NearPump) > 0) or
                        (GetSelectedPedWeapon(ped) == 883325847 and not NearPump))
             then
                time = 15
                if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped then
                    onlyone = false
                    if callonlyone then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Steige aus um dein Auto aufzutanken",
                            "System - Nachricht",
                            true
                        )
                        callonlyone = false
                        invehicle = true
                    end
                else
                    onlyone = false
                    if invehicle then
                        TriggerEvent("sevenliferp:closenotify", false)
                        invehicle = false
                        callonlyone = true
                    end
                    local car = GetPlayersLastVehicle()
                    local carcoords = GetEntityCoords(car)
                    if DoesEntityExist(car) and GetDistanceBetweenCoords(GetEntityCoords(ped), carcoords) < 2.5 then
                        if not DoesEntityExist(GetPedInVehicleSeat(car, -1)) then
                            local canFuel = true
                            if GetSelectedPedWeapon(ped) == 883325847 then
                                if GetAmmoInPedWeapon(ped, 883325847) < 100 then
                                    canFuel = false
                                end
                            end
                            if GetVehicleFuelLevel(car) < 95 and canFuel then
                                time = 2

                                if onlyoncefuel then
                                    TriggerEvent(
                                        "sevenliferp:startnui",
                                        "Drücke <span1 color = white>E</span1> um dein Auto aufzutanken",
                                        "System - Nachricht",
                                        true
                                    )
                                end
                                if not isFueling then
                                    if IsControlJustPressed(0, 38) then
                                        if currentCash > 0 then
                                            isFueling = true
                                            nocash = false

                                            onlyoncefuel = false
                                            TriggerEvent("sevenlife:fuel:pumping", NearPump, ped, car)
                                            TriggerEvent("sevenliferp:closenotify", false)
                                            LoadAnimDict("timetable@gardener@filling_can")
                                        else
                                            if nocash then
                                                TriggerEvent(
                                                    "SevenLife:TimetCustom:Notify",
                                                    "Tankstelle",
                                                    "Du hast kein Geld in deiner Tasche",
                                                    2000
                                                )
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                if onlyone == false then
                    TriggerEvent("sevenliferp:closenotify", false)
                    onlyone = true
                    callonlyone = true
                    onlyoncefuel = true
                end
            end
        end
    end
)

RegisterNetEvent("sevenlife:fuel:pumping")
AddEventHandler(
    "sevenlife:fuel:pumping",
    function(objekt, ped, car)
        TaskTurnPedToFaceEntity(ped, car, 1000)
        Citizen.Wait(1000)
        SetCurrentPedWeapon(ped, -1569615261, true)
        LoadAnimDict("timetable@gardener@filling_can")
        TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
        TriggerEvent("sevenlife:fuel:starttick", objekt, ped, car)

        while isFueling do
            for _, controlIndex in pairs(Config.DisableKeys) do
                DisableControlAction(0, controlIndex)
            end

            if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
                TaskPlayAnim(
                    ped,
                    "timetable@gardener@filling_can",
                    "gar_ig_5_filling_can",
                    2.0,
                    8.0,
                    -1,
                    50,
                    0,
                    0,
                    0,
                    0
                )
            end

            if
                IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(car, -1)) or
                    (NearPump and GetEntityHealth(objekt) <= 0)
             then
                isFueling = false
            end

            Citizen.Wait(0)
        end

        ClearPedTasks(ped)
        RemoveAnimDict("timetable@gardener@filling_can")
    end
)
RegisterNetEvent("sevenlife:fuel:starttick")
AddEventHandler(
    "sevenlife:fuel:starttick",
    function(objekt, ped, car)
        curentfuellevel = GetVehicleFuelLevel(car)
        SetNuiFocus(true, true)
        fuels = math.floor(curentfuellevel)
        cashs = math.floor(currentcost)
        SendNUIMessage(
            {
                type = "opentankenui",
                owner = datas[1].owner,
                activefuel = datas[1].activefuel,
                preislifter = datas[1].preisproliter,
                liter = fuels,
                preis = cashs
            }
        )
        while isFueling do
            Citizen.Wait(500)
            fuel = math.floor(curentfuellevel)
            cash = math.floor(currentcost)
            SendNUIMessage(
                {
                    type = "updatedata",
                    owner = datas[1].owner,
                    activefuel = datas[1].activefuel,
                    preislifter = datas[1].preisproliter,
                    liter = fuel,
                    preis = cash
                }
            )
            local oldFuel = DecorGetFloat(car, "_FUEL_LEVEL")
            local fuelToAdd = math.random(10, 20) / 10.0
            local extraCost = datas[1].preisproliter

            if not objekt then
                if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100 >= 0 then
                    curentfuellevel = oldFuel + fuelToAdd

                    SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100))
                else
                    isFueling = false
                end
            else
                curentfuellevel = oldFuel + fuelToAdd
            end

            if curentfuellevel > 100.0 then
                curentfuellevel = 100.0
                isFueling = false
            end

            currentcost = currentcost + extraCost

            if currentCash >= currentcost then
                SetFuel(car, curentfuellevel)
            else
                isFueling = false
            end
        end

        currentcost = 0.0
    end
)
function SetFuel(car, fuel)
    if type(fuel) == "number" and fuel >= 0 and fuel <= 100 then
        SetVehicleFuelLevel(car, fuel + 0.0)
        DecorSetFloat(car, Config.FuelDecor, GetVehicleFuelLevel(car))
    end
end
function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(1)
        end
    end
end
function Round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)

    return math.floor(num * mult + 0.5) / mult
end
function GetFuelLevel(vehicle)
    return DecorGetFloat(vehicle, Config.FuelDecor)
end

Citizen.CreateThread(
    function()
        local ped = PlayerPedId()
        while true do
            Citizen.Wait(2000)

            local vehicle = GetVehiclePedIsIn(ped, false)
            local liter = GetFuelLevel(vehicle)
            if liter < 1 then
                SetVehicleEngineOn(vehicle, false, true, true)
            end
        end
    end
)

RegisterNUICallback(
    "Zahlen",
    function()
        onlyoncefuel = true
        isFueling = false
        Fuelling = false
        TriggerServerEvent("sevenlife:fuel:pay", cash, tanke, curentfuellevel)
        SetNuiFocus(false, false)
        SendNUIMessage(
            {
                type = "closetanknui"
            }
        )
    end
)

Citizen.CreateThread(
    function()
        local time = 200
        local wasinvehicle = false
        local activenotify = true
        Citizen.Wait(200)
        while true do
            Citizen.Wait(time)

            for w_, v in pairs(Config.andereTanken) do
                local coord = GetEntityCoords(Ped)
                local distance = GetDistanceBetweenCoords(coord, v.x, v.y, v.z, true)
                if not Fuelling then
                    if distance < 20 then
                        time = 100
                        InInnerCircle = true
                        if distance < 10 then
                            if IsPedInAnyVehicle(Ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(Ped), -1) == Ped then
                                wasinvehicle = true
                                if wasinvehicle then
                                    TriggerEvent(
                                        "sevenliferp:startnui",
                                        "Steige aus um dein Fahrzeug aufzutanken",
                                        "System - Nachricht",
                                        true
                                    )
                                end
                            else
                                if wasinvehicle then
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    wasinvehicle = false
                                end
                                Ininnermarker = true
                                if activenotify then
                                    TriggerEvent(
                                        "sevenliferp:startnui",
                                        "Drücke <span1 color = white>E</span1> um dein Fahrzeug aufzutanken",
                                        "System - Nachricht",
                                        true
                                    )
                                end
                            end
                        else
                            if distance >= 10.1 and distance <= 12 then
                                TriggerEvent("sevenliferp:closenotify", false)
                                Ininnermarker = false
                            end
                        end
                    else
                        if distance >= 20.1 and distance <= 40 then
                            time = 200
                            InInnerCircle = false
                        end
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        local time = 200
        while true do
            Citizen.Wait(time)
            if Ininnermarker then
                time = 5
                if IsControlJustPressed(0, 38) then
                    ESX.TriggerServerCallback(
                        "SevenLife:Fuel:CheckIfEnoughGas",
                        function(enough)
                            if enough then
                                activenotify = false
                                Fuelling = true
                                TriggerEvent("sevenliferp:closenotify", false)
                                local car = GetPlayersLastVehicle()
                                TriggerEvent("sevenlife:fuel:pumpingfahrzeug", Ped, car)
                                LoadAnimDict("timetable@gardener@filling_can")
                            else
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Tankstelle",
                                    "In dieser Tankstelle gibt es kein Benzin",
                                    2000
                                )
                            end
                        end,
                        tanke
                    )
                end
            end
        end
    end
)

RegisterNetEvent("sevenlife:fuel:pumpingfahrzeug")
AddEventHandler(
    "sevenlife:fuel:pumpingfahrzeug",
    function(ped, car)
        TaskTurnPedToFaceEntity(ped, car, 1000)
        Citizen.Wait(1000)
        SetCurrentPedWeapon(ped, -1569615261, true)
        LoadAnimDict("timetable@gardener@filling_can")
        TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
        TriggerEvent("sevenlife:fuel:starttick", ped, car)

        while Fuelling do
            for _, controlIndex in pairs(Config.DisableKeys) do
                DisableControlAction(0, controlIndex)
            end

            if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
                TaskPlayAnim(
                    ped,
                    "timetable@gardener@filling_can",
                    "gar_ig_5_filling_can",
                    2.0,
                    8.0,
                    -1,
                    50,
                    0,
                    0,
                    0,
                    0
                )
            end

            if
                IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(car, -1)) or
                    (NearPump and GetEntityHealth(objekt) <= 0)
             then
                Fuelling = false
            end

            Citizen.Wait(0)
        end

        ClearPedTasks(ped)
        RemoveAnimDict("timetable@gardener@filling_can")
    end
)

RegisterNetEvent("sevenlife:fuel:starttick")
AddEventHandler(
    "sevenlife:fuel:starttick",
    function(objekt, ped, car)
        curentfuellevel = GetVehicleFuelLevel(car)
        SetNuiFocus(true, true)
        fuels = math.floor(curentfuellevel)
        cashs = math.floor(currentcost)
        SendNUIMessage(
            {
                type = "opentankenui",
                owner = datas[1].owner,
                liter = fuels,
                preis = cashs
            }
        )
        while Fuelling do
            Citizen.Wait(500)
            fuel = math.floor(curentfuellevel)
            cash = math.floor(currentcost)
            SendNUIMessage(
                {
                    type = "updatedata",
                    owner = datas[1].owner,
                    liter = fuel,
                    preis = cash
                }
            )
            local oldFuel = DecorGetFloat(car, "_FUEL_LEVEL")
            local fuelToAdd = math.random(10, 20) / 10.0
            local extraCost = fuelToAdd / 1.5 * 1.5

            curentfuellevel = oldFuel + fuelToAdd

            if curentfuellevel > 100.0 then
                curentfuellevel = 100.0
                Fuelling = false
            end

            currentcost = currentcost + extraCost

            if currentCash >= currentcost then
                SetFuel(car, curentfuellevel)
            else
                Fuelling = false
            end
        end

        currentcost = 0.0
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(200)
            Ped = GetPlayerPed(-1)
            Coords = GetEntityCoords(Ped)
        end
    end
)
