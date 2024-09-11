Citizen.CreateThread(
    function()
        while true do
            -- Es wird jeden Tick ausgeführt
            Citizen.Wait(1)
            -- TODO Traffic and Ped density managment
            SetTrafficDensity(0)
            SetPedDensity(0)
            Stopsspawning(false)
            local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
            ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
            RemoveVehiclesFromGeneratorsInArea(x - 300.0, y - 300.0, z - 300.0, x + 300.0, y + 300.0, z + 300.0)
        end
    end
)
-- Stopt Autos und generellen Verkehr
function SetTrafficDensity(density)
    SetParkedVehicleDensityMultiplierThisFrame(density)
    SetVehicleDensityMultiplierThisFrame(density)
    SetRandomVehicleDensityMultiplierThisFrame(density)
end

function SetPedDensity(density)
    SetPedDensityMultiplierThisFrame(density)
    SetScenarioPedDensityMultiplierThisFrame(density)
end

function Stopsspawning(boolen)
    SetGarbageTrucks(boolen)
    SetRandomBoats(boolen)
    SetCreateRandomCops(boolen)
    SetCreateRandomCopsNotOnScenarios(boolen)
    SetCreateRandomCopsOnScenarios(boolen)
end
