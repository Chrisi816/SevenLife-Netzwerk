ESX = nil
Citizen.CreateThread(
    function()
        for k, v in pairs(Config.BauernPlaces) do
            Showsblips(v.x, v.y)
        end

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
function Showsblips(x, y)
    local blips = AddBlipForCoord(x, y)
    SetBlipSprite(blips, 480)
    SetBlipDisplay(blips, 4)
    SetBlipScale(blips, 1.0)
    SetBlipColour(blips, 48)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Bauer")
    EndTextCommandSetBlipName(blips)
    SetBlipAsShortRange(blips, true)
end
local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_m_farmer_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            Citizen.Wait(500)
            for k, v in pairs(Config.BauernPlaces) do
                local distance = GetDistanceBetweenCoords(PlayerCoord, v.x, v.y, v.z, true)

                if distance < 30 then
                    pedarea = true
                    if not pedloaded then
                        RequestModel(ped)
                        while not HasModelLoaded(ped) do
                            Citizen.Wait(1)
                        end
                        ped1 = CreatePed(4, ped, v.x, v.y, v.z, v.heading, false, true)
                        SetEntityInvincible(ped1, true)
                        FreezeEntityPosition(ped1, true)
                        SetBlockingOfNonTemporaryEvents(ped1, true)
                        TaskPlayAnim(ped1, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                        pedloaded = true
                    end
                else
                    if distance >= 30.1 and distance <= 50 then
                        pedarea = false
                    end
                end

                if pedloaded and not pedarea then
                    DeleteEntity(ped1)
                    SetModelAsNoLongerNeeded(ped)
                    pedloaded = false
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

            for k, v in pairs(Config.BauernPlaces) do
                local distance = GetDistanceBetweenCoords(coord, v.x, v.y, v.z, true)
                if distance < 15 then
                    area = true
                    timemain = 15
                    if distance < 2 then
                        inmarker = true
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um mit dem Lokalen Bauern zu sprechen",
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
                    area = false
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
                        openmenu = true
                        ESX.TriggerServerCallback(
                            "SevenLife:Bauern:GetMoney",
                            function(money)
                                SendNUIMessage(
                                    {
                                        type = "OpenBauer",
                                        items = Config.Items,
                                        money = money
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
    "BuyBauer",
    function(data)
        TriggerServerEvent("SevenLife:Bauern:BuyItem", data.name, data.preis)
    end
)

RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
    end
)
RegisterNetEvent("SevenLife:Bauern:Geld")
AddEventHandler(
    "SevenLife:Bauern:Geld",
    function(money)
        SendNUIMessage(
            {
                type = "UpdateMoney",
                money = money
            }
        )
    end
)
