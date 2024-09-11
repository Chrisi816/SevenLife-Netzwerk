local timess = 100
local inmarkerss = false
local notifysss = true
local mistime = 200
local inarea = false
local inprogress = false

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            Coords = GetEntityCoords(Ped)
            Citizen.Wait(timess)
            local distance =
                GetDistanceBetweenCoords(
                Coords,
                Config.Hospital.HeliPed.x,
                Config.Hospital.HeliPed.y,
                Config.Hospital.HeliPed.z,
                true
            )
            if distance < 10 then
                inarea = true
                timess = 25
                if distance < 1.2 then
                    timess = 5
                    inmarkerss = true
                    if notifysss then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um in den Aufzug zu gehen!",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.3 and distance <= 5 then
                        inmarkerss = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                if distance >= 8 and distance <= 20 then
                    inarea = false
                    timess = 100
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(5)
            if inmarkerss then
                if IsControlJustPressed(0, 38) then
                    if not inprogress then
                        inprogress = true
                        notifysss = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenMenuTeleport3"
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
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(mistime)
            if inarea then
                mistime = 1
                DrawMarker(
                    Config.MarkerType,
                    Config.Hospital.HeliPed.x,
                    Config.Hospital.HeliPed.y,
                    Config.Hospital.HeliPed.z,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    Config.MarkerSize,
                    Config.MarkerColor.r,
                    Config.MarkerColor.g,
                    Config.MarkerColor.b,
                    100,
                    true,
                    true,
                    2,
                    false,
                    nil,
                    nil,
                    false
                )
            else
                mistime = 1000
            end
        end
    end
)
RegisterNUICallback(
    "CloseMonologue3",
    function()
        inmarkerss = false
        SetNuiFocus(false, false)
        notifysss = true
        inprogress = false
    end
)
