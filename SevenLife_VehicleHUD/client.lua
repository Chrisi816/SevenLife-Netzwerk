local allowrefresh = false
local activeengine = false
local beld = false
local tempomat = false
local velBuffer = {}
local selectedgear = 0
local gears
local gearactive = false
local vehicles = nil
Citizen.CreateThread(
    function()
        while true do
            local player = PlayerPedId()

            local streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(player))))
            if IsPedInAnyVehicle(player, true) then
                vehicle = GetVehiclePedIsIn(player, false)
                local speed = GetEntitySpeed(vehicle)
                local liter = exports["SevenLife_Fuel"]:GetFuelLevel(vehicle)
                local liter = math.floor(liter)
                local curspeed = math.floor(speed * 3.6)
                if IsPedInAnyHeli(player) then
                    gears = "Heli"
                else
                    gears = GetVehicleCurrentGear(vehicle)

                    if not gearactive then
                        if tonumber(gears) == 0 then
                            gears = "R"
                        else
                            gears = GetVehicleCurrentGear(vehicle)
                        end
                    else
                        if tonumber(selectedgear) == -1 then
                            gears = "R"
                        else
                            gears = selectedgear
                        end
                    end
                end

                TriggerEvent("sevenlife:openhud", curspeed, gears, liter, streetname)
                allowrefresh = true

                local EntityHealth = GetEntityHealth(vehicle)
                local maxEntityHealth = GetEntityMaxHealth(vehicle)
                local vehicleHealth = (EntityHealth / maxEntityHealth) * 100

                SetPlayerVehicleDamageModifier(PlayerId(), 100)
                local maxSpeed = 100 - ((100 - ((GetVehicleEngineHealth(vehicle) / maxEntityHealth) * 100)) / 1.5)
                if (vehicleHealth <= 30) then
                    SetVehicleMaxSpeed(vehicle, maxSpeed)
                else
                    SetVehicleMaxSpeed(vehicle, 200.0)
                end
                if (vehicleHealth == 0) then
                    SetVehicleEngineOn(vehicle, false, false)
                end
            else
                if not IsPedInAnyVehicle(player, true) then
                    allowrefresh = false
                    beld = false
                    TriggerEvent("sevenlife:removehud")
                end
            end

            Citizen.Wait(1000)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            local player = PlayerPedId()
            Citizen.Wait(300)
            if IsPedInAnyVehicle(player, true) then
                local vehicle = GetVehiclePedIsIn(player, false)
                local speed = GetEntitySpeed(vehicle)
                local curspeed = math.floor(speed * 3.6)
                if IsPedInAnyHeli(player) then
                    gears = "Heli"
                else
                    gears = GetVehicleCurrentGear(vehicle)

                    if not gearactive then
                        if tonumber(gears) == 0 then
                            gears = "R"
                        else
                            gears = GetVehicleCurrentGear(vehicle)
                        end
                    else
                        if tonumber(selectedgear) == -1 then
                            gears = "R"
                        else
                            gears = selectedgear
                        end
                    end
                end
                Citizen.Wait(50)
                local liter = exports["SevenLife_Fuel"]:GetFuelLevel(vehicle)
                local liter = math.floor(liter)
                local streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(player))))
                TriggerEvent("sevenlife:refreshhud", curspeed, gears, liter, streetname)
                local runningengine = GetIsVehicleEngineRunning(vehicle)
                if runningengine == 1 then
                    TriggerEvent("sevenlife:activeaccounts", "updatemotor")
                else
                    TriggerEvent("sevenlife:activeaccounts", "removemotor")
                    tempomat = false
                end
                if beld == true then
                    TriggerEvent("sevenlife:activeaccounts", "updateanschnall")
                else
                    TriggerEvent("sevenlife:activeaccounts", "removeanschnall")
                end
                if tempomat then
                    if speeds then
                        speedtempo = GetEntitySpeed(vehicle)
                        speeds = false
                    end
                    if not IsEntityInAir(vehicle) then
                        SetEntityMaxSpeed(vehicle, speedtempo)
                    end
                else
                    SetEntityMaxSpeed(vehicle, 1000.0)
                end
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            if (IsControlJustReleased(0, 29)) then
                if beld == false then
                    beld = true
                else
                    beld = false
                end
            end
            if (IsControlJustReleased(0, 137)) then
                if tempomat == false then
                    tempomat = true
                    speeds = true
                    TriggerEvent("sevenlife:activeaccounts", "updatetempomat")
                else
                    tempomat = false
                    TriggerEvent("sevenlife:activeaccounts", "removetempomat")
                end
            end
        end
    end
)
function Fwv(entity)
    local heading = GetEntityHeading(entity) + 90.0
    if heading < 0.0 then
        heading = 360.0 + heading
    end
    heading = heading * 0.0174533
    return {x = math.cos(heading) * 2.0, y = math.sin(heading) * 2.0}
end

local inblackout = false
local damagebody = 0

Citizen.CreateThread(
    function()
        local time = 200
        while true do
            Citizen.Wait(time)
            local ped = GetPlayerPed(-1)
            local vehicle = GetVehiclePedIsIn(ped, false)
            if DoesEntityExist(vehicle) then
                local damageinvehicle = GetVehicleBodyHealth(vehicle)
                if damageinvehicle ~= damagebody then
                    if not inblackout and (damageinvehicle < damagebody) and ((damagebody - damageinvehicle) >= 20) then
                        if not beld then
                            local co = GetEntityCoords(ped)
                            local fw = Fwv(ped)
                            SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                            Citizen.Wait(1)
                            SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                            inblackout = false
                        end
                    end
                    damagebody = damageinvehicle
                end
            else
                damagebody = 0
            end
        end
    end
)

local active = false
local activeright = false

local activeall = false

local numgears = nil
local topspeedGTA = nil
local topspeedms = nil
local acc = nil
local hash = nil

local hbrake = nil

local incar = false

local currspeedlimit = nil
local ready = false
local realistic = false

-- Lights
Citizen.CreateThread(
    function()
        Citizen.Wait(2000)
        while true do
            Citizen.Wait(7)
            local ped = GetPlayerPed(-1)
            local peds = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            if IsPedInAnyVehicle(ped, false) then
                -- Left

                if IsControlJustPressed(0, 174) then
                    if not active then
                        SetVehicleIndicatorLights(peds, 0, false)
                        SetVehicleIndicatorLights(peds, 1, true)
                        active = true
                        SendNUIMessage(
                            {
                                type = "updatelinks"
                            }
                        )
                    else
                        if active then
                            SetVehicleIndicatorLights(peds, 0, false)
                            SetVehicleIndicatorLights(peds, 1, false)
                            active = false
                            SendNUIMessage(
                                {
                                    type = "removelinks"
                                }
                            )
                        end
                    end
                end
                -- Right
                if IsControlJustPressed(0, 175) then
                    if not activeright then
                        activeright = true
                        SetVehicleIndicatorLights(peds, 0, true)
                        SetVehicleIndicatorLights(peds, 1, false)
                        SendNUIMessage(
                            {
                                type = "updaterechts"
                            }
                        )
                    else
                        if activeright then
                            activeright = false
                            SetVehicleIndicatorLights(peds, 0, false)
                            SetVehicleIndicatorLights(peds, 1, false)
                            SendNUIMessage(
                                {
                                    type = "removerechts"
                                }
                            )
                        end
                    end
                end
                -- All
                if IsControlJustPressed(0, 173) then
                    if not activeall then
                        activeall = true
                        SetVehicleIndicatorLights(peds, 0, true)
                        SetVehicleIndicatorLights(peds, 1, true)
                        SendNUIMessage(
                            {
                                type = "updaterechts"
                            }
                        )
                        SendNUIMessage(
                            {
                                type = "updatelinks"
                            }
                        )
                    else
                        if activeall then
                            activeall = false
                            SetVehicleIndicatorLights(peds, 0, false)
                            SetVehicleIndicatorLights(peds, 1, false)
                            SendNUIMessage(
                                {
                                    type = "removerechts"
                                }
                            )
                            SendNUIMessage(
                                {
                                    type = "removelinks"
                                }
                            )
                        end
                    end
                end

                if IsControlJustPressed(0, 311) then
                    if not gearactive then
                        gearactive = true

                        SendNUIMessage(
                            {
                                type = "updategearmanuell"
                            }
                        )
                    else
                        if gearactive then
                            gearactive = false

                            resetvehicle()
                            SendNUIMessage(
                                {
                                    type = "removegearmanuell"
                                }
                            )
                        end
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        selectedgear = 0
        while true do
            Citizen.Wait(100)

            if gearactive then
                local ped = PlayerPedId()
                local newveh = GetVehiclePedIsIn(ped, false)
                local class = GetVehicleClass(newveh)
                if newveh == vehicles then
                elseif newveh == 0 and vehicles ~= nil then
                    resetvehicle()
                else
                    if GetPedInVehicleSeat(newveh, -1) == ped then
                        if class ~= 13 and class ~= 14 and class ~= 15 and class ~= 16 and class ~= 21 then
                            vehicles = newveh
                            hash = GetEntityModel(newveh)

                            if GetVehicleMod(vehicles, 13) < 0 then
                                numgears = GetVehicleHandlingInt(newveh, "CHandlingData", "nInitialDriveGears")
                            else
                                numgears = GetVehicleHandlingInt(newveh, "CHandlingData", "nInitialDriveGears") + 1
                            end

                            hbrake = GetVehicleHandlingFloat(newveh, "CHandlingData", "fHandBrakeForce")

                            topspeedGTA = GetVehicleHandlingFloat(newveh, "CHandlingData", "fInitialDriveMaxFlatVel")
                            topspeedms = (topspeedGTA * 1.32) / 3.6

                            acc = GetVehicleHandlingFloat(newveh, "CHandlingData", "fInitialDriveForce")

                            SetVehicleMaxSpeed(newveh, topspeedms)
                            Citizen.Wait(50)
                            ready = true
                        end
                    end
                end
            else
                Citizen.Wait(300)
            end
        end
    end
)
function resetvehicle()
    SetVehicleHandlingFloat(vehicles, "CHandlingData", "fInitialDriveForce", acc)
    SetVehicleHandlingFloat(vehicles, "CHandlingData", "fInitialDriveMaxFlatVel", topspeedGTA)
    SetVehicleHandlingFloat(vehicles, "CHandlingData", "fHandBrakeForce", hbrake)
    SetVehicleHighGear(vehicles, numgears)
    ModifyVehicleTopSpeed(vehicles, 1)
    SetVehicleHandbrake(vehicles, false)
    SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1000.0)
    vehicles = nil
    numgears = nil
    topspeedGTA = nil
    topspeedms = nil
    acc = nil
    hash = nil
    hbrake = nil
    selectedgear = 0
    currspeedlimit = nil
    ready = false
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            if gearactive and vehicles ~= nil then
                DisableControlAction(0, 80, true)
                DisableControlAction(0, 21, true)
            else
                Citizen.Wait(200)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)

            if gearactive == true and vehicles ~= nil then
                if vehicles ~= nil then
                    if ready == true then
                        if IsDisabledControlJustPressed(0, 21) then
                            if selectedgear <= numgears - 1 then
                                DisableControlAction(0, 71, true)

                                selectedgear = selectedgear + 1

                                Wait(300)
                                DisableControlAction(0, 71, false)
                                SimulateGears()
                            end
                        elseif IsDisabledControlJustPressed(0, 80) then
                            if selectedgear > -1 then
                                DisableControlAction(0, 71, true)

                                Wait(300)
                                selectedgear = selectedgear - 1

                                DisableControlAction(0, 71, false)
                                SimulateGears()
                            end
                        end
                    end
                end
            end
        end
    end
)

function SimulateGears()
    local engineup = GetVehicleMod(vehicles, 11)

    if selectedgear > 0 then
        local ratio
        if Config.vehicles[hash] ~= nil then
            if selectedgear ~= 0 and selectedgear ~= nil then
                if numgears ~= nil and selectedgear ~= nil then
                    ratio = Config.vehicles[hash][numgears][selectedgear] * (1 / 0.9)
                else
                    ratio = Config.gears[numgears][selectedgear] * (1 / 0.9)
                end
            end
        else
            if selectedgear ~= 0 and selectedgear ~= nil then
                if numgears ~= nil and selectedgear ~= nil then
                    ratio = Config.gears[numgears][selectedgear] * (1 / 0.9)
                end
            end
        end

        if ratio ~= nil then
            SetVehicleHighGear(vehicles, 1)
            newacc = ratio * acc
            newtopspeedGTA = topspeedGTA / ratio
            newtopspeedms = topspeedms / ratio

            SetVehicleHandbrake(vehicles, false)
            SetVehicleHandlingFloat(vehicles, "CHandlingData", "fInitialDriveForce", newacc)
            SetVehicleHandlingFloat(vehicles, "CHandlingData", "fInitialDriveMaxFlatVel", newtopspeedGTA)
            SetVehicleHandlingFloat(vehicles, "CHandlingData", "fHandBrakeForce", hbrake)
            ModifyVehicleTopSpeed(vehicles, 1)
            SetVehicleMaxSpeed(vehicles, newtopspeedms)
            currspeedlimit = newtopspeedms
        end
    elseif selectedgear == -1 then
        SetVehicleHandbrake(vehicles, false)
        SetVehicleHighGear(vehicles, numgears)
        SetVehicleHandlingFloat(vehicles, "CHandlingData", "fInitialDriveForce", acc)
        SetVehicleHandlingFloat(vehicles, "CHandlingData", "fInitialDriveMaxFlatVel", topspeedGTA)
        SetVehicleHandlingFloat(vehicles, "CHandlingData", "fHandBrakeForce", hbrake)
        ModifyVehicleTopSpeed(vehicles, 1)
    end
    SetVehicleMod(vehicles, 11, engineup, false)
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            if gearactive == true and vehicles ~= nil then
                if selectedgear == -1 then
                    if GetVehicleCurrentGear(vehicles) == 1 then
                        DisableControlAction(0, 71, true)
                    end
                elseif selectedgear > 0 then
                    if GetEntitySpeedVector(vehicles, true).y < 0.0 then
                        DisableControlAction(0, 72, true)
                    end
                    local speed = round(topspeedGTA / Config.GearTemp[selectedgear], 1)
                    SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), speed)
                elseif selectedgear == 0 then
                    SetVehicleHandbrake(vehicles, true)
                    if IsControlJustPressed(0, 76) == false then
                        SetVehicleHandlingFloat(vehicles, "CHandlingData", "fHandBrakeForce", 0.0)
                    else
                        SetVehicleHandlingFloat(vehicles, "CHandlingData", "fHandBrakeForce", hbrake)
                    end
                end
            else
                Citizen.Wait(100)
            end
        end
    end
)
function round(number, decimals)
    local power = 10 ^ decimals
    return math.floor(number * power) / power
end
local disable = false

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(7)

            if gearactive == true and vehicles ~= nil then
                if selectedgear > 1 then
                    if IsControlJustPressed(0, 71) then
                        local speed = GetEntitySpeed(vehicles)
                        local minspeed = currspeedlimit / 7

                        if speed < minspeed then
                            if GetVehicleCurrentRpm(vehicles) < 0.4 then
                                disable = true
                            end
                        end
                    end
                end
            else
                Citizen.Wait(100)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            if disable == true then
                SetVehicleEngineOn(vehicles, false, true, false)
                Citizen.Wait(1000)

                disable = false
            else
                Citizen.Wait(100)
            end
        end
    end
)
