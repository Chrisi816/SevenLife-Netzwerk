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

--------------------------------------------------------------------------------------------------------------
---------------------------------------------Npc Spawner------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local pedloaded = false
local pedarea = false
local ped = GetHashKey("csb_trafficwarden")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance = GetDistanceBetweenCoords(PlayerCoord, Config.Essen.x, Config.Essen.y, Config.Essen.z, true)

            Citizen.Wait(500)

            if distance < 50 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped5 =
                        CreatePed(
                        4,
                        ped,
                        Config.Essen.x,
                        Config.Essen.y,
                        Config.Essen.z,
                        Config.Essen.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped5, true)
                    FreezeEntityPosition(ped5, true)
                    SetBlockingOfNonTemporaryEvents(ped5, true)
                    TaskPlayAnim(ped5, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped5)
                SetModelAsNoLongerNeeded(ped5)
                pedloaded = false
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------

notifys8 = true
inmarker8 = false
inmenu8 = false

local timemain1 = 100
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain1)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance = GetDistanceBetweenCoords(coord, Config.Essen.x, Config.Essen.y, Config.Essen.z, true)
            if distance < 15 then
                timemain1 = 15
                if distance < 2 then
                    inmarker8 = true
                    if notifys8 then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Laden zu öffnen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.1 and distance <= 3 then
                        inmarker8 = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        BlipGefeangnisEssenGeben()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmarker8 then
                if IsControlJustPressed(0, 38) then
                    if inmenu8 == false then
                        inmenu8 = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys8 = false
                        SetNuiFocus(true, false)
                        SendNUIMessage(
                            {
                                type = "OpenEssenMenu"
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
function BlipGefeangnisEssenGeben()
    local blips = vector3(Config.Essen.x, Config.Essen.y, Config.Essen.z)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 478)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 9)
    SetBlipScale(blip1, 0.9)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Essen kaufen")
    EndTextCommandSetBlipName(blip1)
end
RegisterNUICallback(
    "MakeActionEssen",
    function(data)
        SetNuiFocus(false, false)
        notifys8 = true
        inmarker8 = false
        inmenu8 = false
        local actions = tonumber(data.action)
        if actions == 1 then
            TriggerServerEvent("SevenLife:Gefeangnis:GiveItem", "bread", 3)
        elseif actions == 2 then
            TriggerServerEvent("SevenLife:Gefeangnis:GiveItem", "water", 2)
        end
    end
)
