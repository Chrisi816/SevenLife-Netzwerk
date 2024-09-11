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
    local blip = AddBlipForCoord(Config.Mailspot.x, Config.Mailspot.y, Config.Mailspot.z)
    SetBlipSprite(blip, 357)
    SetBlipColour(blip, 5)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Post Amt")
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
            local distance =
                GetDistanceBetweenCoords(Coords, Config.Mailspot.x, Config.Mailspot.y, Config.Mailspot.z, true)
            if distance < 10 then
                time = 15
                inarea = true
                if distance < 1.6 then
                    time = 5
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um zum Post Boten zu gelangen",
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
                    time = 100
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

                    RequestCollisionAtCoord(Config.MailGarage.x, Config.MailGarage.y, Config.MailGarage.z)
                    FreezeEntityPosition(Ped, true)
                    inhome = true
                    SetEntityCoords(
                        Ped,
                        Config.MailGarage.x,
                        Config.MailGarage.y,
                        Config.MailGarage.z,
                        false,
                        false,
                        false,
                        false
                    )
                    Citizen.Wait(10)
                    while not HasCollisionLoadedAroundEntity(Ped) do
                        Citizen.Wait(0)
                    end
                    FreezeEntityPosition(Ped, false)
                    TriggerEvent("sevenliferp:closenotify", false)
                    notifys = true
                    inmarker = false
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
                    Config.Mailspot.x,
                    Config.Mailspot.y,
                    Config.Mailspot.z,
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
