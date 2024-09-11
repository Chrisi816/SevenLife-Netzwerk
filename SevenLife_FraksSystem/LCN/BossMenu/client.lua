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
inlcnjob = false
Citizen.CreateThread(
    function()
        Citizen.Wait(1000)

        while true do
            Citizen.Wait(3000)
            ESX.TriggerServerCallback(
                "SevenLife:Fraktionen:CheckIfInFrak",
                function(result)
                    if result then
                        inlcnjob = true
                    else
                        inlcnjob = false
                    end
                end,
                "LCN"
            )
        end
    end
)
local area = false
local notifys = true
local inmarker = false
local inmenu = false
local timemain = 100
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            if inlcnjob then
                local ped = GetPlayerPed(-1)
                local coord = GetEntityCoords(ped)

                local distance =
                    GetDistanceBetweenCoords(
                    coord,
                    Config.LCN.BossMenu.x,
                    Config.LCN.BossMenu.y,
                    Config.LCN.BossMenu.z,
                    true
                )
                if distance < 15 then
                    area = true
                    timemain = 15
                    if distance < 1.2 then
                        inmarker = true
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um das Boss menu aufzurufen!",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 1.2 and distance <= 4.2 then
                            inmarker = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    area = false
                end
            else
                Citizen.Wait(10000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inlcnjob then
                if inmarker then
                    if IsControlJustPressed(0, 38) then
                        if inmenu == false then
                            inmenu = true
                            TriggerEvent("sevenliferp:closenotify", false)
                            notifys = false
                            SetNuiFocus(true, true)
                            ESX.TriggerServerCallback(
                                "SevenLife:FraksSystem:GetInfosForBossMenu",
                                function(result, cash)
                                    local money = tonumber(cash[1].reichtum)
                                    SetNuiFocus(true, true)

                                    SendNUIMessage(
                                        {
                                            type = "OpenBossMenu",
                                            result = result,
                                            cash = money,
                                            informationen = Config.Informationen
                                        }
                                    )
                                end,
                                "LCN"
                            )
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(10000)
            end
        end
    end
)
RegisterNUICallback(
    "CloseFamilienMenu",
    function()
        notifys = true
        inmenu = false
        inmenu = false
    end
)
RegisterNUICallback(
    "GetInfosAboutMitglieder",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Frak:GetInfosAboutMitglider",
            function(result, onlinepersonen, insgesamtplayer)
                SendNUIMessage(
                    {
                        type = "InsertMembers",
                        result = result,
                        onlinepersonen = onlinepersonen,
                        insgesamtplayer = insgesamtplayer
                    }
                )
            end,
            "LCN"
        )
    end
)
local time = 2000
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time)
            if inlcnjob then
                if area and not inmenu then
                    time = 1
                    DrawMarker(
                        1,
                        Config.LCN.BossMenu.x,
                        Config.LCN.BossMenu.y,
                        Config.LCN.BossMenu.z,
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
                else
                    time = 2000
                end
            else
                Citizen.Wait(3000)
            end
        end
    end
)
RegisterNUICallback(
    "Einzahlen",
    function(data)
        TriggerServerEvent("SevenLife:FraksSystem:Einzahlen", data.cash, "LCN")
    end
)
RegisterNUICallback(
    "Auszahlen",
    function(data)
        TriggerServerEvent("SevenLife:FraksSystem:Auszahlen", data.cash, "LCN")
    end
)
RegisterNUICallback(
    "GetOldLohn",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:FraksSystem:GetLohn",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateLohn",
                        result = result
                    }
                )
            end,
            "LCN"
        )
    end
)
RegisterNUICallback(
    "SetLohn",
    function(data)
        local lohn = data.lohn
        if lohn <= 500 then
            TriggerServerEvent("SevenLife:FraksSystem:SetLohn", data.type, lohn)
        else
            TriggerEvent(
                "SevenLife:TimetCustom:Notify",
                "Fraktion",
                "Du kannst nicht mehr als 500$ als Lohn einstellen",
                2000
            )
        end
    end
)
RegisterNUICallback(
    "GetMembers",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:FraksSystem:GetAngestellte",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenAngestellte",
                        result = result
                    }
                )
            end,
            "LCN"
        )
    end
)
RegisterNUICallback(
    "DeRank",
    function(data)
        TriggerServerEvent("SevenLife:FraksSystem:DeRank", data.id, "LCN")

        Citizen.Wait(1000)
        ESX.TriggerServerCallback(
            "SevenLife:FraksSystem:GetAngestellte",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateAngestellte",
                        result = result
                    }
                )
            end,
            "LCN"
        )
    end
)
RegisterNUICallback(
    "RankUp",
    function(data)
        TriggerServerEvent("SevenLife:FraksSystem:RankUp", data.id, "LCN")
        Citizen.Wait(1000)
        ESX.TriggerServerCallback(
            "SevenLife:FraksSystem:GetAngestellte",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateAngestellte",
                        result = result
                    }
                )
            end,
            "LCN"
        )
    end
)
RegisterNUICallback(
    "feuern",
    function(data)
        TriggerServerEvent("SevenLife:FraksSystem:Feuern", data.id, "LCN")
        Citizen.Wait(1000)
        ESX.TriggerServerCallback(
            "SevenLife:FraksSystem:GetAngestellte",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateAngestellte",
                        result = result
                    }
                )
            end,
            "LCN"
        )
    end
)
