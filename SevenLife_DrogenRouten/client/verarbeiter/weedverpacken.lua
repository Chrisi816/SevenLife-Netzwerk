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
            local distance =
                GetDistanceBetweenCoords(
                coords,
                Config.VerarbeiterCoords.Tisch2Weed.x,
                Config.VerarbeiterCoords.Tisch2Weed.y,
                Config.VerarbeiterCoords.Tisch2Weed.z,
                true
            )
            if distance < 15 then
                area = true
                timemain = 15
                if distance < 1.1 then
                    inmarker = true
                    if activenotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um das Weed zu Verpacken",
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
                Citizen.Wait(200)
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
                    if not inmenu then
                        inmenu = true
                        local Ped = GetPlayerPed(-1)

                        ESX.TriggerServerCallback(
                            "SevenLife:Item:GetPackungen",
                            function(count)
                                if count >= 6 then
                                    ESX.TriggerServerCallback(
                                        "SevenLife:Drogen:HavePlayerEnoughSpace",
                                        function(canPickUp)
                                            if canPickUp then
                                                inmarker = false
                                                activenotify = false
                                                TriggerServerEvent("SevenLife:Weed:RemoveItem", "gestrektesweed", 12)
                                                SendNUIMessage(
                                                    {
                                                        type = "OpenBarVerarbeiten"
                                                    }
                                                )

                                                MakeAnim(Ped)
                                                Citizen.Wait(100)
                                                TriggerEvent("sevenliferp:closenotify", false)
                                                Citizen.Wait(11000)
                                                ClearPedTasksImmediately(Ped)
                                                inmenu = false
                                                activenotify = true
                                                TriggerServerEvent("SevenLife:Weed:ChangeItem2")
                                            else
                                                activenotify = true
                                                inmenu = false
                                                TriggerEvent(
                                                    "SevenLife:TimetCustom:Notify",
                                                    "Weed",
                                                    "Du besitzt zu wenig Platz in deiner Tasche",
                                                    2000
                                                )
                                            end
                                        end,
                                        12
                                    )
                                else
                                    activenotify = true
                                    inmenu = false
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Weed",
                                        "Du besitzt zu wenig Gestrektes Weed",
                                        2000
                                    )
                                end
                            end,
                            "gestrektesweed"
                        )
                    end
                end
            else
                Citizen.Wait(150)
            end
        end
    end
)

function MakeAnim(ped)
    RequestAnimDict("amb@prop_human_bum_bin@idle_b")
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        Citizen.Wait(10)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 2.0, -2.0, -1, 49, 0, true, false, true)
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time)
            if area and not inmenu then
                time = 1
                DrawMarker(
                    1,
                    Config.VerarbeiterCoords.Tisch2Weed.x,
                    Config.VerarbeiterCoords.Tisch2Weed.y,
                    Config.VerarbeiterCoords.Tisch2Weed.z,
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
