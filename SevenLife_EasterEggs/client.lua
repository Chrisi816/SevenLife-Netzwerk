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
            Citizen.Wait(0)
        end
    end
)
local notifys = true
local inmarker = false
local inmenu = false
local timemain = 100
local active = false
RegisterNetEvent("SevenLife:EasterEgg:StartCall")
AddEventHandler(
    "SevenLife:EasterEgg:StartCall",
    function(number)
        active = true
        local x, y, z
        for k, v in pairs(Config.PhoneCells) do
            if number == k then
                x, y, z = v.x, v.y, v.z
            end
        end
        print(x .. y .. z)
        Citizen.CreateThread(
            function()
                while active do
                    Citizen.Wait(100)

                    local Coords = GetEntityCoords(GetPlayerPed(-1))
                    local eCoords = vector3(x, y, z)
                    local distIs = GetDistanceBetweenCoords(Coords, eCoords, true)
                    if (distIs <= 20) then
                        SendNUIMessage(
                            {
                                type = "PlaySound"
                            }
                        )
                        Citizen.Wait(28000)
                    else
                        SendNUIMessage(
                            {
                                type = "StopSound"
                            }
                        )
                    end
                end
            end
        )

        Citizen.CreateThread(
            function()
                while active do
                    Citizen.Wait(timemain)
                    local ped = GetPlayerPed(-1)
                    local coord = GetEntityCoords(ped)

                    local distance = GetDistanceBetweenCoords(coord, x, y, z, true)
                    if distance < 15 then
                        timemain = 15
                        if distance < 2 then
                            inmarker = true
                            if notifys then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um das Telefon anzunehmen",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 2.1 and distance <= 3 then
                                inmarker = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        timemain = 100
                    end
                end
            end
        )

        Citizen.CreateThread(
            function()
                Citizen.Wait(10)
                while active do
                    Citizen.Wait(5)
                    if inmarker then
                        if IsControlJustPressed(0, 38) then
                            if inmenu == false then
                                inmenu = true

                                notifys = false
                                TriggerServerEvent("SevenLife:EasterEgg:PhoneFound")
                                Citizen.Wait(1000)
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        Citizen.Wait(1000)
                    end
                end
            end
        )
    end
)
RegisterNetEvent("SevenLife:EasterEgg:Sync")
AddEventHandler(
    "SevenLife:EasterEgg:Sync",
    function()
        active = false
        inmenu = false
        notifys = true
        inmarker = false
        SendNUIMessage(
            {
                type = "StopSound"
            }
        )
    end
)
