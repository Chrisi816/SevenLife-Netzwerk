local mistime = 1000
local ingarageparkrange = false
local outarea = false

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(200)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(
                coords,
                Config.Polizei.AusParkPunkt.x,
                Config.Polizei.AusParkPunkt.y,
                Config.Polizei.AusParkPunkt.z,
                true
            )
            if IsPlayerInPD and inoutservice then
                if IsPedInAnyVehicle(player, true) then
                    if distance < 40 then
                        outarea = true
                        if distance < 5.5 then
                            ingarageparkrange = true

                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um das Fahrzeug einzulagern",
                                "System - Nachricht",
                                true
                            )
                        else
                            if distance >= 5.6 and distance <= 9 then
                                ingarageparkrange = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        outarea = false
                    end
                else
                    if distance >= 5.6 and distance <= 9 then
                        ingarageparkrange = false
                        outarea = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
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
            Citizen.Wait(mistime)
            if IsPlayerInPD and inoutservice then
                if outarea then
                    mistime = 1
                    DrawMarker(
                        Config.MarkerType,
                        Config.Polizei.AusParkPunkt.x,
                        Config.Polizei.AusParkPunkt.y,
                        Config.Polizei.AusParkPunkt.z,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        vector3(3.5, 3.5, 1.1),
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
            else
                Citizen.Wait(2000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(7)
            if IsPlayerInPD and inoutservice then
                if ingarageparkrange then
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent("sevenliferp:closenotify", false)
                        local vehiclese = ESX.Game.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(-1)), 7.0)
                        for k, v in pairs(vehiclese) do
                            local fuel = exports["SevenLife_Fuel"]:GetFuelLevel(v)
                            TriggerServerEvent(
                                "sevenlife:savecartile",
                                GetVehicleNumberPlateText(v),
                                ESX.Game.GetVehicleProperties(v)
                            )
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Success", "Auto erfolgreich eingeparkt", 3000)
                            TriggerServerEvent("sevenlife:changemode", GetVehicleNumberPlateText(v), true)
                            ESX.Game.DeleteVehicle(v)
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(5000)
            end
        end
    end
)
-- Heli
local mistime1 = 1000
local ingarageparkrange1 = false
local outarea1 = false

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(200)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(
                coords,
                Config.Polizei.HeliAusParkPunkt.x,
                Config.Polizei.HeliAusParkPunkt.y,
                Config.Polizei.HeliAusParkPunkt.z,
                true
            )
            if IsPlayerInPD and inoutservice then
                if IsPedInAnyVehicle(player, true) then
                    if distance < 40 then
                        outarea1 = true
                        if distance < 5.5 then
                            ingarageparkrange1 = true

                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um das Fahrzeug einzulagern",
                                "System - Nachricht",
                                true
                            )
                        else
                            if distance >= 5.6 and distance <= 9 then
                                ingarageparkrange1 = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        outarea1 = false
                    end
                else
                    if distance >= 5.6 and distance <= 9 then
                        ingarageparkrange1 = false
                        outarea1 = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
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
            Citizen.Wait(mistime1)
            if IsPlayerInPD and inoutservice then
                if outarea1 then
                    mistime1 = 1
                    DrawMarker(
                        Config.MarkerType,
                        Config.Polizei.HeliAusParkPunkt.x,
                        Config.Polizei.HeliAusParkPunkt.y,
                        Config.Polizei.HeliAusParkPunkt.z,
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
                    mistime1 = 1000
                end
            else
                Citizen.Wait(2000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(7)
            if IsPlayerInPD and inoutservice then
                if ingarageparkrange1 then
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent("sevenliferp:closenotify", false)
                        local vehiclese = ESX.Game.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(-1)), 7.0)
                        for k, v in pairs(vehiclese) do
                            local fuel = exports["SevenLife_Fuel"]:GetFuelLevel(v)
                            TriggerServerEvent(
                                "sevenlife:savecartile",
                                GetVehicleNumberPlateText(v),
                                ESX.Game.GetVehicleProperties(v)
                            )
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Success", "Heli erfolgreich eingeparkt", 3000)
                            TriggerServerEvent("sevenlife:changemode", GetVehicleNumberPlateText(v), true)
                            ESX.Game.DeleteVehicle(v)
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(5000)
            end
        end
    end
)
