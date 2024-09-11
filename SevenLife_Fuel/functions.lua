function GetFuelinCar(vehicle)
    return DecorGetFloat(vehicle, Config.FuelDecor)
end

function SetFuelinCar(vehicle, fuel)
    if type(fuel) == "number" and fuel >= 0 and fuel <= 100 then
        SetVehicleFuelLevel(vehicle, fuel + 0.0)
        DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
    end
end

function CreateBlip(coordsx, coordsy, coordsz)
    local blips = vector3(coordsx, coordsy, coordsz)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 361)
    SetBlipScale(blip1, 0.9)
    SetBlipColour(blip1, 4)
    SetBlipDisplay(blip1, 4)
    SetBlipAsShortRange(blip1, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Tankstelle")
    EndTextCommandSetBlipName(blip1)

    return blip1
end


function MangeFuel(vehicle)
    if not DecorExistOn(vehicle, Config.FuelDecor) then
        --TODO: DatenBank Sync
        SetFuelinCar(vehicle, math.random(200, 800) / 10)
    elseif not isfuelsynced then
        SetFuelinCar(vehicle, GetFuel(vehicle))

        isfuelsynced = true
    end

    if IsVehicleEngineOn(vehicle) then
        SetFuelinCar(
            vehicle,
            GetVehicleFuelLevel(vehicle) -
                Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] *
                    (Config.Classes[GetVehicleClass(vehicle)] or 1.0) /
                    10
        )
    end
end
