ESX = nil
local inmenu = false
local near = false
local orange = 0

local notify = false
Citizen.CreateThread(
    function()
        Showsblips()
        ShowsVerarbeiter()
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

function Showsblips()
    local blips = AddBlipForCoord(Config.BlipOrangen.x, Config.BlipOrangen.y)
    SetBlipSprite(blips, 237)
    SetBlipDisplay(blips, 4)
    SetBlipScale(blips, 1.0)
    SetBlipColour(blips, 47)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Orangen farmen")
    EndTextCommandSetBlipName(blips)
    SetBlipAsShortRange(blips, true)
end

function ShowsVerarbeiter()
    local blips = AddBlipForCoord(Config.BlipVerarbeiter.x, Config.BlipVerarbeiter.y)
    SetBlipSprite(blips, 478)
    SetBlipDisplay(blips, 4)
    SetBlipScale(blips, 1.0)
    SetBlipColour(blips, 47)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Orangen Verarbeiten")
    EndTextCommandSetBlipName(blips)
    SetBlipAsShortRange(blips, true)
end

local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_o_soucent_02")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.BlipVerarbeiter.x,
                Config.BlipVerarbeiter.y,
                Config.BlipVerarbeiter.z,
                true
            )

            Citizen.Wait(500)

            if distance < 30 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped1 =
                        CreatePed(
                        4,
                        ped,
                        Config.BlipVerarbeiter.x,
                        Config.BlipVerarbeiter.y,
                        Config.BlipVerarbeiter.z,
                        Config.BlipVerarbeiter.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped1, true)
                    FreezeEntityPosition(ped1, true)
                    SetBlockingOfNonTemporaryEvents(ped1, true)
                    TaskPlayAnim(ped1, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped1)
                SetModelAsNoLongerNeeded(ped1)
                pedloaded = false
            end
        end
    end
)

-- Verarbeiter

local inmarker = false
local timemain = 100
local notifys = true
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(y)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance =
                GetDistanceBetweenCoords(
                coord,
                Config.BlipVerarbeiter.x,
                Config.BlipVerarbeiter.y,
                Config.BlipVerarbeiter.z,
                true
            )
            if distance < 15 then
                timemain = 15
                if distance < 2 then
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Orangen Verarbeiter zu öffnen",
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
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenOrangeVerarbeiter"
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
RegisterNUICallback(
    "GiveOrange",
    function(data)
        SetNuiFocus(false, false)
        orange = orange + 5

        TriggerServerEvent("SevenLife:Orange:GiveItem")

        if orange == 10 then
            TriggerEvent("SevenLife:Quest:UpdateIfPossible", 6)
        end
        Citizen.CreateThread(
            function()
                Citizen.Wait(5000)
                inmenu = false
                notifys = true
            end
        )
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(100)
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)
            for k, v in pairs(Config.Coords) do
                local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                if distance <= 1.5 then
                    near = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Orangen zu pflücken",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.6 and distance <= 3.0 then
                        near = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if near then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenOrange"
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
RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
    end
)
RegisterNUICallback(
    "MakeVerarbeiten",
    function()
        SetNuiFocus(false, false)
        TriggerServerEvent("SevenLife:Orange:RemoveItems")
        SendNUIMessage(
            {
                type = "OpenVerarbeiterNUI"
            }
        )
        Citizen.CreateThread(
            function()
                Citizen.Wait(21000)
                TriggerServerEvent("SevenLife:Orange:GiveVerpackteOrange")
                inmenu = false
                notifys = true
            end
        )
    end
)
