-- Variables

local innotifymarker = false
local Markertime = 200
local timemain = 150
local inminerange = false
local Amfarmen = false
local activenotify = true

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
            Citizen.Wait(10)
        end
    end
)

-- Blip

function MakeMineBlip()
    local blips = vector2(Config.MineBlip.x, Config.MineBlip.y)
    local blip = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blip, 176)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.1)
    SetBlipColour(blip, 48)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mine")
    EndTextCommandSetBlipName(blip)
end

-- Check if Player is in a Marker (5/5)

Citizen.CreateThread(
    function()
        MakeMineBlip()
        while true do
            for i, v in pairs(Config.Minen) do
                Citizen.Wait(timemain)
                local player = GetPlayerPed(-1)
                local coord = GetEntityCoords(player)
                local distance = GetDistanceBetweenCoords(coord, v.x, v.y, v.z, true)
                if distance < 80 then
                    inminerange = true
                    timemain = 100
                    if distance < 2 then
                        innotifymarker = true
                        if activenotify then
                            TriggerEvent("sevenliferp:startnui", "Drücke E um zu Minen", "System - Nachricht", true)
                        end
                    else
                        if distance >= 2.1 and distance <= 3 then
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    inminerange = false
                end
            end
        end
    end
)

-- Key

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(9)
            if innotifymarker and not Amfarmen then
                if IsControlJustPressed(0, 38) then
                    ESX.TriggerServerCallback(
                        "SevenLife:Mine:CheckIfPlayerHavePickaxe",
                        function(haveitem)
                            if haveitem then
                                Amfarmen = true
                                TriggerEvent("sevenliferp:closenotify", false)
                                activenotify = false
                                StartMining()
                            else
                                activenotify = false
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Du hast keine Spitzhacke",
                                    "System - Nachricht",
                                    true
                                )
                                Citizen.Wait(3000)
                                TriggerEvent("sevenliferp:closenotify", false)
                                Citizen.Wait(200)
                                activenotify = true
                            end
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
            Citizen.Wait(Markertime)
            if inminerange and not Amfarmen then
                Markertime = 1
                for i, v in pairs(Config.Minen) do
                    DrawMarker(
                        1,
                        v.x,
                        v.y,
                        v.z,
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
                end
            else
                if not inminerange and Amfarmen then
                    Markertime = 1000
                end
            end
        end
    end
)

-- Mining function

function StartMining()
    local einschlag = 0
    Citizen.CreateThread(
        function()
            while einschlag < 3 do
                Citizen.Wait(1)
                local ped = GetPlayerPed(-1)
                RequestAnimDict("amb@world_human_hammering@male@base")
                Citizen.Wait(100)
                TaskPlayAnim((ped), "amb@world_human_hammering@male@base", "base", 12.0, 12.0, -1, 80, 0, 0, 0, 0)
                SetEntityHeading(ped, 270.0)
                if einschlag == 0 then
                    pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true)
                    AttachEntityToEntity(
                        pickaxe,
                        ped,
                        GetPedBoneIndex(ped, 57005),
                        0.18,
                        -0.02,
                        -0.02,
                        350.0,
                        100.00,
                        140.0,
                        true,
                        true,
                        false,
                        true,
                        1,
                        true
                    )
                end
                Citizen.Wait(2500)
                einschlag = einschlag + 1
                if einschlag == 3 then
                    DetachEntity(pickaxe, 1, true)
                    DeleteEntity(pickaxe)
                    DeleteObject(pickaxe)
                    einschlag = 0
                    Citizen.Wait(500)

                    TriggerServerEvent("SevenLife:Mining:GetPlayerItems")
                    activenotify = true
                    Amfarmen = false
                    break
                end
            end
        end
    )
end
