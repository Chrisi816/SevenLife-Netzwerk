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
                Config.Hospital.HeandeWaschenSpot.x,
                Config.Hospital.HeandeWaschenSpot.y,
                Config.Hospital.HeandeWaschenSpot.z,
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
                            "Drücke <span1 color = white>E</span1> um deine Hände zu waschen!",
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

                        FreezeEntityPosition(Ped, true)
                        RequestAnimDict("amb@incar@male@smoking@idle_a")
                        while not HasAnimDictLoaded("amb@incar@male@smoking@idle_a") do
                            Citizen.Wait(1)
                        end

                        SetEntityHeading(GetPlayerPed(-1), Config.Hospital.HeandeWaschenSpot.heading)

                        TaskPlayAnim(
                            GetPlayerPed(-1),
                            "amb@incar@male@smoking@idle_a",
                            "idle_a",
                            8.0,
                            1,
                            -1,
                            49,
                            0,
                            false,
                            false,
                            false
                        )
                        Citizen.Wait(5000)
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Information",
                            "Du hast deine Hände gewaschen!",
                            2000
                        )
                        FreezeEntityPosition(Ped, false)
                        heandegewaschen = true
                        notifysss = true
                        inprogress = false
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
                    Config.Hospital.HeandeWaschenSpot.x,
                    Config.Hospital.HeandeWaschenSpot.y,
                    Config.Hospital.HeandeWaschenSpot.z,
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
