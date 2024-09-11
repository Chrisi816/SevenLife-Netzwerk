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
            Citizen.Wait(0)
        end
    end
)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        PlayerData = xPlayer
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(job)
        PlayerData.job = job
    end
)

-- Variables
local inareaofRepair = false
local InRangeOfRepair = false
local TimeSpeed = 100
local proccesing = false

Citizen.CreateThread(
    function()
        Citizen.Wait(2000)
        if mechanik then
            local blips = AddBlipForCoord(Config.RepairKit.x, Config.RepairKit.y, Config.RepairKit.z)
            SetBlipSprite(blips, 238)
            SetBlipDisplay(blips, 4)
            SetBlipScale(blips, 1.3)
            SetBlipColour(blips, 5)
            SetBlipAsShortRange(blips, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Werkstatt: RepairKit")
            EndTextCommandSetBlipName(blips)
        end
    end
)

-- InPound
Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(coords, Config.RepairKit.x, Config.RepairKit.y, Config.RepairKit.z, true)
            if mechanik then
                if distance < 40 then
                    inareaofRepair = true
                    if distance < 5.5 then
                        InRangeOfRepair = true
                        if not proccesing then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um die RepairKits aufzusammeln",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 5.6 and distance <= 7 then
                            InRangeOfRepair = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    inareaofRepair = false
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(TimeSpeed)
            if inareaofRepair then
                if not proccesing then
                    TimeSpeed = 1
                    DrawMarker(
                        Config.MarkerType,
                        Config.RepairKit.x,
                        Config.RepairKit.y,
                        Config.RepairKit.z,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        Config.MarkerSize2,
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
                end
            else
                TimeSpeed = 1000
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if InRangeOfRepair then
                if not proccesing then
                    if IsControlJustPressed(0, 38) then
                        if indienst then
                            local ped = GetPlayerPed(-1)
                            proccesing = true
                            TriggerEvent("sevenliferp:closenotify", false)

                            Citizen.Wait(30000)
                            TriggerServerEvent("SevenLife:Mechaniker:GiveRepairKit", InRangeOfRepair)
                            proccesing = false
                        else
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Mechaniker", "Du bist nicht im Dienst", 2000)
                        end
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
