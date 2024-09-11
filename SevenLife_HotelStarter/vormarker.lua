-- Variables
local time = 100
local mistime = 1000
local inarea = false
local inmarker = false
local notifys = true
local openshop = false
local inmenu = false

-- ESX

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

-- Blips

Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        MakeBlipsForPostal()
    end
)

-- Blips function

function MakeBlipsForPostal()
    local blip = AddBlipForCoord(Config.Hotel.x, Config.Hotel.y, Config.Hotel.z)
    SetBlipSprite(blip, 475)
    SetBlipColour(blip, 0)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Hotel")
    EndTextCommandSetBlipName(blip)
end

-- Function for Init the Outside

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            Coords = GetEntityCoords(Ped)
            Citizen.Wait(time)
            local distance = GetDistanceBetweenCoords(Coords, Config.Hotel.x, Config.Hotel.y, Config.Hotel.z, true)
            if distance < 10 then
                time = 15
                inarea = true
                if distance < 1.6 then
                    time = 5
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um die Interaktionen anzugucken",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.7 and distance <= 8 then
                        inmarker = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                if distance >= 8 and distance <= 12 then
                    inarea = false
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
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    inmarker = false
                    notifys = false
                    SetNuiFocus(true, true)
                    TriggerEvent("sevenliferp:closenotify", false)
                    ESX.TriggerServerCallback(
                        "SevenLife:Hotel:GetIfPlayerHaveHotel",
                        function(havehotel)
                            if havehotel then
                                SendNUIMessage(
                                    {
                                        type = "OpenHotelGetIn"
                                    }
                                )
                            else
                                SendNUIMessage(
                                    {
                                        type = "OpenMenuBuyHotel"
                                    }
                                )
                            end
                        end
                    )
                end
            else
                Citizen.Wait(100)
            end
        end
    end
)

-- Marker

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(mistime)
            if inarea then
                mistime = 1
                DrawMarker(
                    Config.MarkerType,
                    Config.Hotel.x,
                    Config.Hotel.y,
                    Config.Hotel.z,
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
                    false,
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
    "getMotel",
    function()
        SetNuiFocus(false, false)
        TriggerServerEvent("SevenLife:Hotel:PlayerEnterdHouse")
        RequestCollisionAtCoord(Config.MotelSpawnPlace.x, Config.MotelSpawnPlace.y, Config.MotelSpawnPlace.z)
        FreezeEntityPosition(Ped, true)

        SetEntityCoords(
            Ped,
            Config.MotelSpawnPlace.x,
            Config.MotelSpawnPlace.y,
            Config.MotelSpawnPlace.z,
            false,
            false,
            false,
            false
        )
        Citizen.Wait(10)
        SetEntityHeading(Ped, Config.MotelSpawnPlace.heading)
        while not HasCollisionLoadedAroundEntity(Ped) do
            Citizen.Wait(0)
        end
        FreezeEntityPosition(Ped, false)

        notifys = true
        inmarker = false
        inmenu = false
    end
)

RegisterNUICallback(
    "escape",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
        inmenu1 = false
        notifys1 = true
    end
)
