local messagesallowed = true
local inmarker = false
local drinne = false
Citizen.CreateThread(
    function()
        Citizen.Wait(2000)
        local player = GetPlayerPed(-1)

        while true do
            for k, v in pairs(Config.pos) do
                Citizen.Wait(250)
                local Safezones = vector3(v.x, v.y, v.z)
                local distance =
                    GetDistanceBetweenCoords(
                    GetEntityCoords(GetPlayerPed(-1)),
                    vector3(Safezones.x, Safezones.y, Safezones.z)
                )
                if distance < 20 then
                    inmarker = true
                    if messagesallowed then
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "SafeZone",
                            "Du bist jetzt in einer Safe Zone",
                            2000
                        )

                        messagesallowed = false
                    end
                else
                    if distance >= 20 and distance <= 50 then
                        messagesallowed = true
                        inmarker = false
                        SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1000.0)
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(1)
            if inmarker then
                if Config.disableall then
                    DisableanyactionsinGreenZone()
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

function DisableanyactionsinGreenZone()
    DisableControlAction(2, 37, true)
    DisablePlayerFiring(GetPlayerPed(-1), true)
    DisableControlAction(0, 45, true)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 142, true)
    SetPlayerInvincible(PlayerId(), true)
    SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13.0)
    for k, v in pairs(GetActivePlayers()) do
        local ped = GetPlayerPed(v)
        SetEntityNoCollisionEntity(GetPlayerPed(-1), GetVehiclePedIsIn(ped, false), true)
        SetEntityNoCollisionEntity(GetVehiclePedIsIn(ped, false), GetVehiclePedIsIn(GetPlayerPed(-1), false), true)
    end
end
