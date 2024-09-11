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

-- Variables
local area = false
local time = 2000
local timemain = 100
local inmarker = false
local activenotify = true
local inmenu = false

-- Distance

Citizen.CreateThread(
    function()
        Blipses()
        while true do
            Citizen.Wait(timemain)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)
            local distance =
                GetDistanceBetweenCoords(coord, Config.Location.x, Config.Location.y, Config.Location.z, true)
            if distance < 15 then
                area = true
                timemain = 10
                if distance < 2 then
                    inmarker = true
                    if activenotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um Werbung zu schalten",
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
                area = false
            end
        end
    end
)

-- Key

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(9)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    ESX.TriggerServerCallback(
                        "SevenLife:GetWerbungs",
                        function(result)
                            SetNuiFocus(true, true)
                            inmenu = true
                            activenotify = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            timemain = 2000
                            time = 2000
                            SendNUIMessage(
                                {
                                    type = "OpenNUILifeInvader",
                                    result = result
                                }
                            )
                        end
                    )
                end
            end
        end
    end
)

-- Marker

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time)
            if area and not inmenu then
                time = 1
                DrawMarker(
                    1,
                    Config.Location.x,
                    Config.Location.y,
                    Config.Location.z,
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

function Blipses()
    Blip = AddBlipForCoord(Config.Location.x, Config.Location.y, Config.Location.z)
    SetBlipSprite(Blip, 77)
    SetBlipDisplay(Blip, 4)
    SetBlipScale(Blip, 0.9)
    SetBlipColour(Blip, 49)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("LifeInvader")
    EndTextCommandSetBlipName(Blip)
end
RegisterNUICallback(
    "Close",
    function()
        inmenu = false
        activenotify = true
        timemain = 10
        time = 1

        SetNuiFocus(false, false)
    end
)
RegisterNUICallback(
    "sendnachricht",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Lifeinvader:GetNameOfPersons",
            function(name)
                if data.status == 1 then
                    benutzername = name
                else
                    benutzername = "Anonym"
                end

                TriggerServerEvent(
                    "SevenLife:Lifeinvader:SendNachrichCheck",
                    data.inachrichtcon,
                    data.titel,
                    benutzername,
                    data.statuses
                )
            end
        )
    end
)

RegisterNetEvent("SevenLife:LifeInvader:NotEnoughCash")
AddEventHandler(
    "SevenLife:LifeInvader:NotEnoughCash",
    function()
        SetNuiFocus(false, false)
        TriggerEvent("sevenliferp:startnui", "Du hast zu wenig Geld", "LifeInvader", true)
        Citizen.Wait(2000)
        TriggerEvent("sevenliferp:closenotify", false)
        activenotify = true
        inmenu = false
        timemain = 10
        time = 1
    end
)

RegisterNetEvent("SevenLife:LifeInvader:Delete")
AddEventHandler(
    "SevenLife:LifeInvader:Delete",
    function()
        inmenu = false
        activenotify = true
        timemain = 10
        time = 1

        SetNuiFocus(false, false)
    end
)
