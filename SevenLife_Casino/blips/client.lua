Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        local blip = AddBlipForCoord(Config.VehiclePoss.x, Config.VehiclePoss.y, Config.VehiclePoss.z)
        SetBlipSprite(blip, 439)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Casino")
        EndTextCommandSetBlipName(blip)
    end
)
