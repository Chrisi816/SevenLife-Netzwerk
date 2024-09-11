ESX = nil
Citizen.CreateThread(
    function()
        Showsblips()
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

-- Variables
local rental =
    vector3(Config.locations.starterrantal.x, Config.locations.starterrantal.y, Config.locations.starterrantal.z)
local notopenshop = false
local allowednotify = true
local price = 0
local car = ""

function Showsblips()
    local blips = AddBlipForCoord(rental.x, rental.y)
    SetBlipSprite(blips, 100)
    SetBlipDisplay(blips, 4)
    SetBlipScale(blips, 1.0)
    SetBlipColour(blips, 48)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Fahrzeug Verleih")
    EndTextCommandSetBlipName(blips)
    SetBlipAsShortRange(blips, true)
end
--------------------------------------------------------------------------------------------------------------
---------------------------------------------Npc Spawner------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.locations.npc.x,
                Config.locations.npc.y,
                Config.locations.npc.z,
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
                        Config.locations.npc.x,
                        Config.locations.npc.y,
                        Config.locations.npc.z,
                        Config.locations.npc.heading,
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
                SetModelAsNoLongerNeeded(ped)
                pedloaded = false
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------

local notifys = true
local inmarker = false
local inmenu = false

local timemain = 100
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance =
                GetDistanceBetweenCoords(
                coord,
                Config.locations.npc.x,
                Config.locations.npc.y,
                Config.locations.npc.z,
                true
            )
            if distance < 15 then
                timemain = 15
                if distance < 2 then
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um das Vermietungs Katalog zu öffnen",
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
                                type = "openrental",
                                result = Config.Fahrzeuge
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

-- Callbacks

RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
    end
)

-- Car Callbacks

RegisterNUICallback(
    "GiveCar",
    function(data)
        local name = data.name
        local minutes = tonumber(data.count)
        local preis = tonumber(data.preis)
        local endpreis = minutes * preis
        PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 1)
        TriggerServerEvent("sevenlife:spawncar", name, minutes, endpreis)
    end
)

RegisterNUICallback(
    "Fehler",
    function()
        TriggerEvent("SevenLife:TimetCustom:Notify", "Vermietung", "Es ist ein Fehler unterlaufen", 2000)
    end
)

RegisterNetEvent("sevenlife:spawncar")
AddEventHandler(
    "sevenlife:spawncar",
    function(name, minutes)
        local player = PlayerPedId()
        local minutess = minutes * 60000
        ESX.Game.SpawnVehicle(
            name,
            Config.spawnpoint.slot1,
            63.86,
            function(vehicle)
                TaskWarpPedIntoVehicle(player, vehicle, -1)
                SetVehicleColours(vehicle, 112, 112)
                SetVehicleNumberPlateText(vehicle, "Ausleih")

                TriggerEvent(
                    "SevenLife:TimetCustom:Notify",
                    "Vermietung",
                    "Fahrzeug läuft in " .. minutes .. " Minuten ab",
                    2000
                )

                Citizen.SetTimeout(
                    minutess,
                    function()
                        ESX.Game.DeleteVehicle(vehicle)
                        PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 1)
                    end
                )

                Citizen.SetTimeout(
                    minutess - 60000,
                    function()
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Vermietung",
                            "Fahrzeug läuft in 1ner Minuten aus",
                            2000
                        )
                    end
                )

                Citizen.Wait(1000)
                inmenu = false
                notifys = true
                inmarker = false
                TriggerEvent("sevenliferp:closenotify", false)
            end
        )
    end
)
