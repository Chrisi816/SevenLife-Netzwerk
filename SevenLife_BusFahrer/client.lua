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

Citizen.CreateThread(
    function()
        for _, route in ipairs(Config.Routes.BusStops) do
            local blip = AddBlipForCoord(route.pos)
            SetBlipSprite(blip, 513)
            SetBlipColour(blip, 61)
            SetBlipScale(blip, 0.5)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Bus stop")
            EndTextCommandSetBlipName(blip)
        end
    end
)
local busDriverPed = nil
local bus = nil
local timer = 500
local price = 10
local Busschongerufen = false
local notifys = true
local inmarkers = false
local inmenu = false
local timemains = 100

local position = 0
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemains)
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)

            for k, v in pairs(Config.TickerMaker) do
                local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                if distance < 40 then
                    timemains = 5
                    if distance < 15 then
                        DrawMarker(20, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 234, 0, 122, 200, 1, 1, 0, 0)
                        timemains = 1
                        position = v.station
                        if distance < 1.0 then
                            inmarkers = true
                            if notifys then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um ein Ticket zu kaufen!",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 1.1 and distance <= 2.5 then
                                inmarkers = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        if distance >= 15.1 and distance <= 30 then
                            timemains = 5
                        end
                    end
                else
                    if distance >= 40.1 and distance <= 70 then
                        timemains = 100
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
            Citizen.Wait(6)
            if inmarkers then
                bank = 2
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        inmenu = true
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenNui",
                                position = position,
                                description = Config.Descriptions[position]
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

function CreateBusDriver(coords, heading)
    -- Bus spawnen
    local busHash = GetHashKey("bus")
    RequestModel(busHash)
    while not HasModelLoaded(busHash) do
        Wait(1)
    end

    bus = CreateVehicle(busHash, coords, heading, true, false)

    -- Busfahrer spawnen
    local busDriverHash = GetHashKey("a_m_m_mexlabor_01")
    RequestModel(busDriverHash)
    while not HasModelLoaded(busDriverHash) do
        Wait(1)
    end

    busDriverPed = CreatePed(4, busDriverHash, coords, true, true)
    SetPedIntoVehicle(busDriverPed, bus, -1)
end

RegisterNUICallback(
    "StartCourse",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:BusFahrer:CheckifEnoughMoney",
            function(valid)
                if valid then
                    if Config.Descriptions[position][data.station].preis > 0 then
                        Citizen.CreateThread(
                            function()
                                local coords = Config.Spawner.BusStops[position]
                                local coordsheading = Config.Spawner.BusStops[position].heading
                                local driveto = Config.Routes.BusStops[position].pos
                                local endziel = Config.Routes.BusStops[data.station].pos

                                CreateBusDriver(coords.pos, coordsheading)
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Information",
                                    "Warte 1 Min. Der Bus kommt schon!",
                                    2000
                                )
                                Citizen.Wait(2000)
                                LoadCollision(busDriverPed, bus)
                                SetupPedAndVehicle(busDriverPed, bus)
                                repeat
                                    SetVehicleOnGroundProperly(bus, 5.0)
                                    ClearPedTasks(busDriverPed)
                                    TaskVehicleDriveToCoordLongrange(busDriverPed, bus, driveto, 50.0, 2103615, 15.0)
                                    DoStuckCheck(bus)
                                    Wait(500)
                                until not CanGoOn(bus) or GetScriptTaskStatus(busDriverPed, 567490903) > 1 or
                                    GetEntitySpeed(bus) > 1.0

                                while CanGoOn(bus) and GetScriptTaskStatus(busDriverPed, 567490903) ~= 7 do
                                    lastKnownPosition = GetEntityCoords(bus)
                                    DoStuckCheck(bus)
                                    Wait(500)
                                end

                                local timer = GetGameTimer()
                                while CanGoOn(bus) and not IsVehicleStopped(bus) and (GetGameTimer() - timer < 4000) do
                                    Wait(100)
                                end
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Information",
                                    "Steige ein, du hast 10 Sekunden!",
                                    2000
                                )
                                Citizen.Wait(10 * 1000)

                                repeat
                                    SetVehicleOnGroundProperly(bus, 5.0)
                                    ClearPedTasks(busDriverPed)
                                    TaskVehicleDriveToCoordLongrange(busDriverPed, bus, endziel, 50.0, 2103615, 20.0)
                                    DoStuckCheck(bus)
                                    Wait(500)
                                until not CanGoOn(bus) or GetScriptTaskStatus(busDriverPed, 567490903) > 1 or
                                    GetEntitySpeed(bus) > 1.0

                                while CanGoOn(bus) and GetScriptTaskStatus(busDriverPed, 567490903) ~= 7 do
                                    lastKnownPosition = GetEntityCoords(bus)
                                    DoStuckCheck(bus)
                                    Wait(500)
                                end

                                TaskVehicleDriveToCoord(
                                    busDriverPed,
                                    bus,
                                    endziel,
                                    7.0,
                                    0,
                                    GetEntityModel(bus),
                                    2103615,
                                    10.0
                                )
                                local timer = GetGameTimer()
                                while CanGoOn(bus) and not IsVehicleStopped(bus) and (GetGameTimer() - timer < 4000) do
                                    Wait(100)
                                end
                                FreezeEntityPosition(bus, true)
                                TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Steige aus!", 2000)
                                Citizen.Wait(4000)
                                ESX.Game.DeleteVehicle(bus)
                                DeletePed(busDriverPed)
                                notifys = true
                                inmarkers = false
                                inmenu = false
                                timemains = 100
                            end
                        )
                    else
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Information",
                            "Du musst eine andere Halestelle auswählen!",
                            2000
                        )
                    end
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Du besitzt zu wenig Geld!", 2000)
                end
            end,
            Config.Descriptions[position][data.station].preis
        )
    end
)
RegisterNUICallback(
    "Close",
    function()
        SetNuiFocus(false, false)
        notifys = true
        inmarkers = false
        inmenu = false
        timemains = 100
    end
)
function DoStuckCheck(vehicle)
    if
        IsVehicleStuckTimerUp(vehicle, 0, 4000) or IsVehicleStuckTimerUp(vehicle, 1, 4000) or
            IsVehicleStuckTimerUp(vehicle, 2, 4000) or
            IsVehicleStuckTimerUp(vehicle, 3, 4000)
     then
        SetEntityCollision(vehicle, false, true)
        local vehPos = GetEntityCoords(vehicle)
        local ret, outPos = GetPointOnRoadSide(vehPos.x, vehPos.y, vehPos.z, -1)
        local ret, pos, heading = GetClosestVehicleNodeWithHeading(outPos.x, outPos.y, outPos.z, 1, 3.0, 0)
        if ret then
            SetEntityCoords(vehicle, pos)
            SetEntityHeading(vehicle, heading)
            SetEntityCollision(vehicle, true, true)
            SetVehicleOnGroundProperly(vehicle, 5.0)
        end
    end
end
function CanGoOn(vehicle)
    return DoesEntityExist(vehicle) and NetworkHasControlOfNetworkId(VehToNet(vehicle))
end

function LoadCollision(ped, vehicle)
    SetEntityLoadCollisionFlag(ped, true, 1)
    SetEntityLoadCollisionFlag(vehicle, true, 1)
    while not HasCollisionLoadedAroundEntity(vehicle) or not HasCollisionLoadedAroundEntity(ped) do
        Wait(0)
    end
end

function SetupPedAndVehicle(ped, vehicle, position)
    SetEntityCanBeDamaged(vehicle, false)
    SetVehicleDamageModifier(vehicle, 0.0)
    SetVehicleEngineCanDegrade(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleLights(vehicle, 0)
    -- Not sure but this should make the driver able to set vehicle on wheels again (like players can do when vehicle goes upside down)
    if not DoesVehicleHaveStuckVehicleCheck(vehicle) then -- From doc: Maximum amount of vehicles with vehicle stuck check appears to be 16.
        AddVehicleStuckCheckWithWarp(vehicle, 10.0, 1000, false, false, false, -1)
    end
    SetEntityCanBeDamaged(ped, false)
    SetPedCanBeTargetted(ped, false)
    SetDriverAbility(ped, 1.0)
    SetDriverAggressiveness(ped, 0.0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedConfigFlag(ped, 251, true)
    SetPedConfigFlag(ped, 64, true)
    SetPedStayInVehicleWhenJacked(ped, true)
    SetPedCanBeDraggedOut(ped, false)
    SetEntityCleanupByEngine(ped, false)
    SetEntityCleanupByEngine(vehicle, false)
    SetPedComponentVariation(ped, 3, 1, 2, 0)
    SetPedComponentVariation(ped, 4, 0, 2, 0)
end
