AllowKey = false
local PedPd = false
local inrader = false
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(200)
            if PlayerData.job.name == "police" then
                PedPd = true
                local Ped = GetPlayerPed(-1)

                if IsVehiclePolice(Ped) then
                    AllowKey = true
                end
            else
                Citizen.Wait(10000)
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if PedPd and AllowKey then
                if IsControlJustPressed(0, 249) then
                    if not inrader then
                        inrader = true

                        SendNUIMessage(
                            {
                                type = "OpenRadar"
                            }
                        )
                    else
                        inrader = false
                        SendNUIMessage(
                            {
                                type = "RemoveRadar"
                            }
                        )
                    end
                end
            else
                Citizen.Wait(200)
            end
            if inrader then
                local ped = GetPlayerPed(-1)
                if not IsPedInAnyVehicle(ped, false) then
                    SendNUIMessage(
                        {
                            type = "RemoveRadar"
                        }
                    )
                    inrader = false
                end
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(200)
            if inrader then
                local Ped = GetPlayerPed(-1)
                local CurrentCar = GetVehiclePedIsIn(Ped, false)
                local currentvehspeed = math.floor(GetEntitySpeed(CurrentCar) * 3.6)
                local vehicle = GetVehiclePedIsIn(Ped, false)
                local vehiclePos = GetEntityCoords(vehicle)

                local forwardPosition = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 50.0, 0.0)
                local fwdPos = {x = forwardPosition.x, y = forwardPosition.y, z = forwardPosition.z}
                local _, fwdZ = GetGroundZFor_3dCoord(fwdPos.x, fwdPos.y, fwdPos.z + 500.0)

                if (fwdPos.z < fwdZ and not (fwdZ > vehiclePos.z + 1.0)) then
                    fwdPos.z = fwdZ + 0.5
                end

                local packedFwdPos = vector3(fwdPos.x, fwdPos.y, fwdPos.z)
                local fwdVeh = GetVehicleInDirectionSphere(vehicle, vehiclePos, packedFwdPos)

                if (DoesEntityExist(fwdVeh) and IsEntityAVehicle(fwdVeh)) then
                    local fwdVehSpeed = round(GetVehSpeed(fwdVeh), 0)

                    SpeedVorne = FormatSpeed(fwdVehSpeed)
                    platetextfront = ESX.Math.Trim(GetVehicleNumberPlateText(fwdVeh))
                end

                local backwardPosition = GetOffsetFromEntityInWorldCoords(vehicle, -10.0, 50.0, 0.0)
                local bwdPos = {x = backwardPosition.x, y = backwardPosition.y, z = backwardPosition.z}
                local _, bwdZ = GetGroundZFor_3dCoord(bwdPos.x, bwdPos.y, bwdPos.z + 500.0)

                if (bwdPos.z < bwdZ and not (bwdZ > vehiclePos.z + 1.0)) then
                    bwdPos.z = bwdZ + 0.5
                end

                local packedBwdPos = vector3(bwdPos.x, bwdPos.y, bwdPos.z)
                local bwdVeh = GetVehicleInDirectionSphere(vehicle, vehiclePos, packedBwdPos)

                if (DoesEntityExist(bwdVeh) and IsEntityAVehicle(bwdVeh)) then
                    local bwdVehSpeed = round(GetVehSpeed(bwdVeh), 0)

                    backspeed = FormatSpeed(bwdVehSpeed)
                    platetextback = ESX.Math.Trim(GetVehicleNumberPlateText(bwdVeh))
                end
                if SpeedVorne == nil then
                    SpeedVorne = 000
                end
                if backspeed == nil then
                    backspeed = 000
                end
                if platetextback == nil then
                    platetextback = "000 000"
                end
                if platetextfront == nil then
                    platetextfront = "000 000"
                end
                SendNUIMessage(
                    {
                        type = "UpdateRadar",
                        speed = currentvehspeed,
                        vornespeed = SpeedVorne,
                        backspeed = backspeed,
                        platetext = platetextback,
                        plateback = platetextfront
                    }
                )
            else
                Citizen.Wait(1000)
            end
        end
    end
)
function GetVehSpeed(veh)
    return GetEntitySpeed(veh) * 3.6
end
function GetVehicleInDirectionSphere(entFrom, coordFrom, coordTo)
    local rayHandle =
        StartShapeTestCapsule(
        coordFrom.x,
        coordFrom.y,
        coordFrom.z,
        coordTo.x,
        coordTo.y,
        coordTo.z,
        2.0,
        10,
        entFrom,
        7
    )
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    return vehicle
end
function FormatSpeed(speed)
    return string.format("%03d", speed)
end
function IsEntityInMyHeading(myAng, tarAng, range)
    local rangeStartFront = myAng - (range / 2)
    local rangeEndFront = myAng + (range / 2)

    local opp = oppang(myAng)

    local rangeStartBack = opp - (range / 2)
    local rangeEndBack = opp + (range / 2)

    if ((tarAng > rangeStartFront) and (tarAng < rangeEndFront)) then
        return true
    elseif ((tarAng > rangeStartBack) and (tarAng < rangeEndBack)) then
        return false
    else
        return nil
    end
end
function round(num)
    return tonumber(string.format("%.0f", num))
end

function oppang(ang)
    return (ang + 180) % 360
end
function IsVehiclePolice(ped)
    local vehicle = GetVehiclePedIsIn(ped)
    for i = 1, #Config.Cars do
        GetVehicles = IsVehicleModel(vehicle, Config.Cars[i])
        if GetVehicles then
            return GetVehicles
        end
    end
end
