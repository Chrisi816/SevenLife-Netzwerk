local inblackout = false
local damagebody = 0

Citizen.CreateThread(
    function()
        local time = 200
        while true do
            Citizen.Wait(time)
            local ped = GetPlayerPed(-1)
            vehicle = GetVehiclePedIsIn(ped, false)
            if DoesEntityExist(vehicle) then
                time = 5

                local damageinvehicle = GetVehicleBodyHealth(vehicle)
                if damageinvehicle ~= damagebody then
                    if not inblackout and (damageinvehicle < damagebody) and ((damagebody - damageinvehicle) >= 30) then
                        Blackout()
                    end
                    damagebody = damageinvehicle
                end
            else
                damagebody = 0
            end
            if inblackout then
                time = 1
                DisableControlAction(0, 71, true)
                DisableControlAction(0, 72, true)
                DisableControlAction(0, 63, true)
                DisableControlAction(0, 64, true)
                DisableControlAction(0, 75, true)
                TriggerEvent("sevenlife:removeallhud")
            end
        end
    end
)

function Blackout()
    if not inblackout then
        inblackout = true
        Citizen.CreateThread(
            function()
                DoScreenFadeOut(100)
                while not IsScreenFadedOut() do
                    Citizen.Wait(1)
                end
                Citizen.Wait(2000)
                DoScreenFadeIn(550)
                inblackout = false
            end
        )
    end
end

AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if resourceName == GetCurrentResourceName() then
            DoScreenFadeIn(100)
        end
    end
)
