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

-- Variables

local notopenshop = false
local allowednotify = true
local price = 0
local car = ""

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
                Config.Polizei.Waffenschrank2.x,
                Config.Polizei.Waffenschrank2.y,
                Config.Polizei.Waffenschrank2.z,
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
                    ped3 =
                        CreatePed(
                        4,
                        ped,
                        Config.Polizei.Waffenschrank2.x,
                        Config.Polizei.Waffenschrank2.y,
                        Config.Polizei.Waffenschrank2.z,
                        Config.Polizei.Waffenschrank2.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped3, true)
                    FreezeEntityPosition(ped3, true)
                    SetBlockingOfNonTemporaryEvents(ped3, true)
                    TaskPlayAnim(ped3, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped3)
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
                Config.Polizei.Waffenschrank2.x,
                Config.Polizei.Waffenschrank2.y,
                Config.Polizei.Waffenschrank2.z,
                true
            )
            if distance < 15 then
                timemain = 15
                if distance < 2 then
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Waffenschrank zu öffnen",
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

                        TriggerEvent("SevenLife:Inventory:MakeWeaponSchrankPolice")
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

-- Callbacks

RegisterNetEvent("SevenLife:PD:DeleteAll")
AddEventHandler(
    "SevenLife:PD:DeleteAll",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
    end
)
