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

local pedloaded = 0
local pedarea = false
local ped = GetHashKey("a_m_m_og_boss_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            for k, v in pairs(Config.LimboLocation) do
                local distance = GetDistanceBetweenCoords(PlayerCoord, v.x, v.y, v.z, true)

                Citizen.Wait(500)

                if distance < 100 then
                    pedarea = true
                    if pedloaded <= 2 then
                        RequestModel(ped)
                        while not HasModelLoaded(ped) do
                            Citizen.Wait(1)
                        end
                        ped1 = CreatePed(4, ped, v.x, v.y, v.z, v.h, false, true)
                        SetEntityInvincible(ped1, true)
                        FreezeEntityPosition(ped1, true)
                        SetBlockingOfNonTemporaryEvents(ped1, true)
                        TaskPlayAnim(ped1, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                        pedloaded = pedloaded + 1
                    end
                else
                    if distance >= 100.1 and distance <= 150.0 then
                        pedarea = false
                    end
                end

                if pedloaded == 3 and not pedarea then
                    DeleteEntity(ped1)
                    SetModelAsNoLongerNeeded(ped1)
                    pedloaded = 0
                end
            end
        end
    end
)

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

            for k, v in pairs(Config.LimboLocation) do
                local distance = GetDistanceBetweenCoords(coord, v.x, v.y, v.z, true)
                if distance < 15 then
                    timemain = 15
                    if distance < 2 then
                        inmarker = true
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um Limbo zu spielen",
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
                        ESX.TriggerServerCallback(
                            "SevenLife:Limbo:GetPrevious",
                            function(result, chips)
                                SendNUIMessage(
                                    {
                                        type = "OpenLimbo",
                                        result = result,
                                        money = chips
                                    }
                                )
                            end
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
    "escape",
    function()
        SetNuiFocus(false, false)
        notifys = true
        inmenu = false
    end
)
RegisterNUICallback(
    "ZuwenigGeld",
    function()
        TriggerEvent("SevenLife:TimetCustom:Notify", "Casino", "Du besitzt zu wenig Ships", 1500)
    end
)
RegisterNUICallback(
    "Verloren",
    function(data)
        TriggerServerEvent("SevenLife:Phone:Verloren", data.einsatz, data.multi)
    end
)
RegisterNUICallback(
    "Gewonnen",
    function(data)
        TriggerServerEvent("SevenLife:Phone:Gewonnen", data.einsatz, data.multi)
    end
)
RegisterNetEvent("SevenLife:Phone:UpdateAll")
AddEventHandler(
    "SevenLife:Phone:UpdateAll",
    function(coins, list)
        SendNUIMessage(
            {
                type = "UpdateNUI",
                coins = coins,
                list = list
            }
        )
    end
)
