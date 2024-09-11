ESX = nil
local PlayerData = {}
local defaultPrice60 = 50
local defaultPrice80 = 150
local defaultPrice120 = 200

local extraZonePrice10 = 10
local extraZonePrice20 = 50
local extraZonePrice30 = 100
local hasBeenCaught = false
local finalBillingPrice = 0

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

local blips = {
    {title = "Blitzer ", colour = 1, id = 1, x = -524.2645, y = -1776.3569, z = 21.3384}, -- 60KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = 392.09, y = -991.31, z = 28.3384}, -- 60KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = 2506.0671, y = 4145.2431, z = 38.1054}, -- 80KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = 1258.2006, y = 789.4199, z = 104.2190}, -- 80KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = 172.98, y = -1344.89, z = 29.1054}, -- 80KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = 980.9982, y = 407.4164, z = 92.2374}, -- 80KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = 292.3, y = -445.52, z = 43.04}, -- 80KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = 226.04, y = -712.11, z = 34.04}, -- 80KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = -224.05, y = -1792.21, z = 29.13}, -- 80KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = -277.33, y = -1286.21, z = 31.13}, -- 80KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = -124.4, y = -931.33, z = 29.24}, -- 80KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = 1584.9281, y = -993.4557, z = 59.3923}, -- 120KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = 2442.2006, y = -134.6004, z = 88.7765}, -- 120KM/H ZONE
    {title = "Blitzer ", colour = 1, id = 1, x = 2871.7951, y = 3540.5795, z = 53.0930} -- 120KM/H ZONE
}

Citizen.CreateThread(
    function()
        for _, blip in pairs(blips) do
            blips = AddBlipForCoord(blip.x, blip.y, blip.z)
            SetBlipSprite(blips, 58)
            SetBlipDisplay(blips, 5)
            SetBlipScale(blips, 0.5)
            SetBlipColour(blips, 61)
            SetBlipAsShortRange(blips, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blip.title)
            EndTextCommandSetBlipName(blips)
        end
    end
)

local S60Zone = {
    {x = -524.2645, y = -1776.3569, z = 21.3384},
    {x = 392.09, y = -991.31, z = 28.3384}
}

local S80Zone = {
    {x = 2506.0671, y = 4145.2431, z = 38.1054},
    {x = 1258.2006, y = 789.4199, z = 103.2190},
    {x = 980.9982, y = 407.4164, z = 92.2374},
    {x = 656.92, y = -20.21, z = 82.13},
    {x = -224.05, y = -1792.21, z = 29.13},
    {x = 292.3, y = -445.52, z = 43.04},
    {x = 226.04, y = -712.11, z = 34.04},
    {x = 172.98, y = -1344.89, z = 29.12},
    {x = -277.33, y = -1286.21, z = 31.13},
    {x = -124.4, y = -931.33, z = 29.24}
}

local S120Zone = {
    {x = 1584.9281, y = -993.4557, z = 59.3923},
    {x = 2442.2006, y = -134.6004, z = 88.7765},
    {x = 2871.7951, y = 3540.5795, z = 53.0930}
}

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(20)
            local playerPed = GetPlayerPed(-1)
            if IsPedInAnyVehicle(playerPed) then
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local veh = GetVehiclePedIsIn(playerPed)
                if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then
                elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then
                elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then
                elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then
                elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then
                elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then
                elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then
                elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then
                else
                    for k in pairs(S60Zone) do
                        local dist =
                            Vdist(plyCoords.x, plyCoords.y, plyCoords.z, S60Zone[k].x, S60Zone[k].y, S60Zone[k].z)
                        if dist <= 20.0 then
                            local playerCar = GetVehiclePedIsIn(playerPed, false)
                            local SpeedKM = GetEntitySpeed(playerPed) * 3.6
                            local maxSpeed = 60.0

                            if SpeedKM > maxSpeed then
                                if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
                                    if hasBeenCaught == false then
                                        SendNUIMessage(
                                            {
                                                type = "MakeBiltzer"
                                            }
                                        )

                                        if SpeedKM >= maxSpeed + 30 then
                                            finalBillingPrice = defaultPrice60 + extraZonePrice30
                                        elseif SpeedKM >= maxSpeed + 20 then
                                            finalBillingPrice = defaultPrice60 + extraZonePrice20
                                        elseif SpeedKM >= maxSpeed + 10 then
                                            finalBillingPrice = defaultPrice60 + extraZonePrice10
                                        else
                                            finalBillingPrice = defaultPrice60
                                        end
                                        TriggerEvent(
                                            "SevenLife:Handy:Message",
                                            "../src/appsymbols/bill.png",
                                            "Rechnungen",
                                            "Überschreitung",
                                            "Du bist zu schnell gefahren"
                                        )
                                        TriggerServerEvent("SevenLife:Blitzer:MakeBill", finalBillingPrice)
                                        hasBeenCaught = true
                                        Citizen.Wait(5000)
                                    end
                                end

                                hasBeenCaught = false
                            end
                        end
                    end
                    for k in pairs(S80Zone) do
                        local dist =
                            Vdist(plyCoords.x, plyCoords.y, plyCoords.z, S80Zone[k].x, S80Zone[k].y, S80Zone[k].z)
                        if dist <= 20.0 then
                            local playerCar = GetVehiclePedIsIn(playerPed, false)
                            local SpeedKM = GetEntitySpeed(playerPed) * 3.6
                            local maxSpeed = 80

                            if SpeedKM > maxSpeed then
                                if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
                                    if hasBeenCaught == false then
                                        SendNUIMessage(
                                            {
                                                type = "MakeBiltzer"
                                            }
                                        )

                                        if SpeedKM >= maxSpeed + 30 then
                                            finalBillingPrice = defaultPrice80 + extraZonePrice30
                                        elseif SpeedKM >= maxSpeed + 20 then
                                            finalBillingPrice = defaultPrice80 + extraZonePrice20
                                        elseif SpeedKM >= maxSpeed + 10 then
                                            finalBillingPrice = defaultPrice80 + extraZonePrice10
                                        else
                                            finalBillingPrice = defaultPrice80
                                        end
                                        TriggerEvent(
                                            "SevenLife:Handy:Message",
                                            "../src/appsymbols/bill.png",
                                            "Rechnungen",
                                            "Überschreitung",
                                            "Du bist zu schnell gefahren"
                                        )
                                        TriggerServerEvent("SevenLife:Blitzer:MakeBill", finalBillingPrice)
                                        hasBeenCaught = true
                                        Citizen.Wait(5000)
                                    end
                                end

                                hasBeenCaught = false
                            end
                        end
                    end
                    for k in pairs(S120Zone) do
                        local dist =
                            Vdist(plyCoords.x, plyCoords.y, plyCoords.z, S120Zone[k].x, S120Zone[k].y, S120Zone[k].z)
                        if dist <= 20.0 then
                            local playerCar = GetVehiclePedIsIn(playerPed, false)

                            local SpeedKM = GetEntitySpeed(playerPed) * 3.6
                            local maxSpeed = 120.0

                            if SpeedKM > maxSpeed then
                                if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
                                    if hasBeenCaught == false then
                                        SendNUIMessage(
                                            {
                                                type = "MakeBiltzer"
                                            }
                                        )
                                        if SpeedKM >= maxSpeed + 30 then
                                            finalBillingPrice = defaultPrice120 + extraZonePrice30
                                        elseif SpeedKM >= maxSpeed + 20 then
                                            finalBillingPrice = defaultPrice120 + extraZonePrice20
                                        elseif SpeedKM >= maxSpeed + 10 then
                                            finalBillingPrice = defaultPrice120 + extraZonePrice10
                                        else
                                            finalBillingPrice = defaultPrice120
                                        end
                                        TriggerEvent(
                                            "SevenLife:Handy:Message",
                                            "../src/appsymbols/bill.png",
                                            "Rechnungen",
                                            "Überschreitung",
                                            "Du bist zu schnell gefahren"
                                        )
                                        TriggerServerEvent("SevenLife:Blitzer:MakeBill", finalBillingPrice)
                                        hasBeenCaught = true
                                        Citizen.Wait(5000)
                                    end
                                end
                            end

                            hasBeenCaught = false
                        end
                    end
                end
            end
        end
    end
)
