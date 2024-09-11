--------------------------------------------------------------------------------------------------------------
--------------------------------------------Variables--------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local area = false
local time = 2000
local timemain = 200
local inmarker = false
local activenotify = true

local inmenu = false

ESX = nil

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(1000)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            local coords = GetEntityCoords(GetPlayerPed(-1))
            local distance = GetDistanceBetweenCoords(coords, 1088.6519775391, -3187.5625, -39.993480682373, true)
            if distance < 15 then
                area = true
                timemain = 15
                if distance < 1.1 then
                    inmarker = true
                    if activenotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um das Koks Labor zu verlassen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.1 and distance <= 2 then
                        inmarker = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                timemain = 200
                area = false
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    local Ped = GetPlayerPed(-1)
                    inmarker = false
                    RequestCollisionAtCoord(
                        Config.Verarbeiter.Koks.x,
                        Config.Verarbeiter.Koks.y,
                        Config.Verarbeiter.Koks.z
                    )
                    FreezeEntityPosition(Ped, true)

                    if Abbrechen then
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Weed", "Abbgebrochen", 2000)
                    end
                    SetEntityCoords(
                        Ped,
                        Config.Verarbeiter.Koks.x,
                        Config.Verarbeiter.Koks.y,
                        Config.Verarbeiter.Koks.z,
                        false,
                        false,
                        false,
                        false
                    )
                    while not HasCollisionLoadedAroundEntity(Ped) do
                        Citizen.Wait(0)
                    end
                    FreezeEntityPosition(Ped, false)
                    TriggerServerEvent("SevenLife:DrogenRouten:BucketListReset")
                    Citizen.Wait(100)
                    TriggerEvent("sevenliferp:closenotify", false)
                    inmarker = false
                end
            else
                Citizen.Wait(200)
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time)
            if area and not inmenu then
                time = 1
                DrawMarker(
                    1,
                    1088.6519775391,
                    -3187.5625,
                    -39.993480682373,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.8,
                    0.8,
                    0.8,
                    236,
                    80,
                    80,
                    155,
                    false,
                    false,
                    2,
                    false,
                    0,
                    0,
                    0,
                    0
                )
            else
                time = 2000
            end
        end
    end
)
