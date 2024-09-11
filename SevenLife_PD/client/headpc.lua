-- Variables
headquatercoords = vector3(Config.Polizei.HeadQuarters.x, Config.Polizei.HeadQuarters.y, Config.Polizei.HeadQuarters.z)
inmenu5 = false
local time2 = 200
local time2betweenchecking = 200
AllowSevenNotify5 = true
inarea5 = false
local infogardrobe
inmarker5 = false
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

-- Local Start
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time2)
            if PlayerData ~= nil then
                if PlayerData.job.grade == 11 or PlayerData.job.grade == 10 then
                    if IsPlayerInPD and inoutservice then
                        local ped = GetPlayerPed(-1)
                        local coordofped = GetEntityCoords(ped)
                        local distance =
                            GetDistanceBetweenCoords(
                            coordofped,
                            Config.Polizei.HeadQuarters.x,
                            Config.Polizei.HeadQuarters.y,
                            Config.Polizei.HeadQuarters.z,
                            true
                        )
                        if distance < 20 then
                            time2 = 110
                            inarea5 = true
                            if distance < 2 then
                                if AllowSevenNotify5 then
                                    TriggerEvent(
                                        "sevenliferp:startnui",
                                        "Drücke E um den Pc an zu schalten",
                                        "System-Nachricht",
                                        true
                                    )
                                end
                                inmarker5 = true
                            else
                                if distance >= 2.1 and distance <= 3 then
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    inmarker5 = false
                                end
                            end
                        else
                            inarea5 = false
                            time2 = 200
                        end
                    else
                        Citizen.Wait(5000)
                    end
                else
                    Citizen.Wait(1000)
                end
            end
        end
    end
)
-- KeyCheck
Citizen.CreateThread(
    function()
        while true do
            local ped = GetPlayerPed(-1)
            Citizen.Wait(time2betweenchecking)
            if PlayerData ~= nil then
                if inarea5 then
                    time2betweenchecking = 5
                    if PlayerData.job.grade == 11 or PlayerData.job.grade == 10 then
                        if IsPlayerInPD and inoutservice then
                            if inmarker5 and not inmenu5 then
                                if IsControlJustPressed(0, 38) then
                                    inmenu5 = true
                                    SetNuiFocus(true, true)
                                    AllowSevenNotify5 = false
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    SendNUIMessage(
                                        {
                                            type = "OpenPC"
                                        }
                                    )
                                end
                            end
                        end
                    end
                else
                    time2betweenchecking = 200
                end
            end
        end
    end
)
local misoftime2 = 1000
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(misoftime2)
            if PlayerData ~= nil then
                if PlayerData.job.grade == 11 or PlayerData.job.grade == 10 then
                    if IsPlayerInPD and inoutservice then
                        if inarea5 then
                            misoftime2 = 1
                            DrawMarker(
                                Config.MarkerType,
                                headquatercoords,
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
                            misoftime2 = 1000
                        end
                    else
                        Citizen.Wait(2000)
                    end
                else
                    Citizen.Wait(1000)
                end
            end
        end
    end
)

RegisterNUICallback(
    "GetDetailsAboutMember",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:PD:Details",
            function(result)
                SendNUIMessage(
                    {
                        type = "InsertPDData",
                        result = result
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "SetLohn",
    function(data)
        local lohn = data.lohn
        if lohn <= 500 then
            TriggerServerEvent("SevenLife:PD:SetLohn", data.type, lohn)
            TriggerEvent("SevenLife:TimetCustom:Notify", "PD", "Erfolgreich Lohn geändert", 2000)
        else
            TriggerEvent(
                "SevenLife:TimetCustom:Notify",
                "PD",
                "Du kannst nicht mehr als 500$ als Lohn einstellen",
                2000
            )
        end
    end
)
