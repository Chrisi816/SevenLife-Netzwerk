local KILLS = 0
local DEATHS = 0
local KD = 0
Citizen.CreateThread(
    function()
        local wasDead = false

        while true do
            Citizen.Wait(100)

            if IsEntityDead(PlayerPedId()) and not wasDead then
                Citizen.Wait(500)
                wasDead = true

                local killerPed = GetPedSourceOfDeath(PlayerPedId())
                local killerPlayer = nil

                if IsEntityAPed(killerPed) and IsPedAPlayer(killerPed) then
                    killerPlayer = NetworkGetPlayerIndexFromPed(killerPed)
                elseif
                    IsEntityAVehicle(killerPed) and IsEntityAPed(GetPedInVehicleSeat(killerPed, -1)) and
                        IsPedAPlayer(GetPedInVehicleSeat(killerPed, -1))
                 then
                    killerPlayer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(killerPed, -1))
                end

                if killerPlayer ~= PlayerId() and killerPlayer ~= nil then
                    TriggerServerEvent("SevenLife:KD:AddKill", GetPlayerServerId(killerPlayer))
                end

                TriggerServerEvent("SevenLife:KD:AddDeath")
            elseif not IsEntityDead(PlayerPedId()) and wasDead == true then
                wasDead = false
            end
        end
    end
)
function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
