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
                    Config.LCN.SpecieleItems.x,
                    Config.LCN.SpecieleItems.y,
                    Config.LCN.SpecieleItems.z,
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
                                "Drücke <span1 color = white>E</span1> um Familien Items anzugucken!",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 1.2 and distance <= 2.2 then
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
                                "SevenLife:Bauern:GetMoney",
                                function(money)
                                    SendNUIMessage(
                                        {
                                            type = "OpenSpecialItems",
                                            items = Config.Items.LCN,
                                            money = money,
                                            frak = "LCN - ITEMS"
                                        }
                                    )
                                end
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
    "CloseMenuBauer",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
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
                        Config.LCN.SpecieleItems.x,
                        Config.LCN.SpecieleItems.y,
                        Config.LCN.SpecieleItems.z - 1,
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
    "BuyItems",
    function(data)
        TriggerServerEvent("SevenLife:FraksSystem:BuyItem", data.name, data.preis, data.rang)
    end
)
RegisterNetEvent("SevenLife:FraksSystem:Geld")
AddEventHandler(
    "SevenLife:FraksSystem:Geld",
    function(money)
        SendNUIMessage(
            {
                type = "UpdateMoney",
                money = money
            }
        )
    end
)
