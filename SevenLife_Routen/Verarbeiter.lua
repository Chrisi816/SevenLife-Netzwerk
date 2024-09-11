local inmarker = false
local inmenu = false
local AllowSevenNotify = true
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
local pedloaded = false

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(700)
            ped = PlayerPedId()
            coordofped = GetEntityCoords(ped)
        end
    end
)

-- Local Verarbeiter Start

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(coords, Config.Verarbeiten.x, Config.Verarbeiten.y, Config.Verarbeiten.z, true)

            if inmenu == false then
                if distance < 1.5 then
                    inmarker = true
                    if AllowSevenNotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um mit Billie zu Sprechen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.6 and distance <= 4 then
                        inmarker = false
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
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        Removenormalhud()
                        TriggerEvent("sevenliferp:closenotify", false)
                        inmenu = true
                        AllowSevenNotify = false
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "verarbeiten"
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

Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.Verarbeiten.x,
                Config.Verarbeiten.y,
                Config.Verarbeiten.z,
                true
            )

            Citizen.Wait(1000)

            if distance < 40 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped1 =
                        CreatePed(
                        4,
                        ped,
                        Config.Verarbeiten.x,
                        Config.Verarbeiten.y,
                        Config.Verarbeiten.z,
                        Config.Verarbeiten.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped1, true)
                    FreezeEntityPosition(ped1, true)
                    SetBlockingOfNonTemporaryEvents(ped1, true)
                    RequestAnimDict("missfbi_s4mop")
                    while not HasAnimDictLoaded("missfbi_s4mop") do
                        Citizen.Wait(1)
                    end
                    TaskPlayAnim(ped1, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                pedarea = false
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped1)
                SetModelAsNoLongerNeeded(ped)
                pedloaded = false
            end
        end
    end
)

function Removenormalhud()
    Citizen.CreateThread(
        function()
            while inmenu do
                Citizen.Wait(1)
                DisplayRadar(false)
                TriggerEvent("sevenlife:removeallhud")
            end
        end
    )
end

RegisterNUICallback(
    "closes",
    function()
        inmenu = false
        AllowSevenNotify = true
        SetNuiFocus(false, false)
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

RegisterNUICallback(
    "karottense",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Verarbeiter:CheckItems",
            function(haveitem)
                inmenu = false
                if haveitem then
                    SetNuiFocus(false, false)
                    inverarbeiter = true
                    SendNUIMessage(
                        {
                            type = "OpenNUIVerarbeiter",
                            time = 1500
                        }
                    )
                    inmenu = false
                    Citizen.Wait(200)
                    DisplayRadar(true)

                    Citizen.Wait(30000)

                    TriggerServerEvent("SevenLife:Verarbeiter:GiveItem", "kartoffelsalat")
                    inverarbeiter = false
                    AllowSevenNotify = true
                else
                    AllowSevenNotify = true
                    SetNuiFocus(false, false)
                    inverarbeiter = false
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Verarbeiter", "Du hast nicht die nötigen Items")
                end
            end,
            "glas",
            1,
            "karotten",
            30,
            "karottensaft"
        )
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

RegisterNUICallback(
    "kartoffelss",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Verarbeiter:CheckItems",
            function(haveitem)
                inmenu = false
                if haveitem then
                    SetNuiFocus(false, false)
                    inverarbeiter = true
                    SendNUIMessage(
                        {
                            type = "OpenNUIVerarbeiter",
                            time = 2000
                        }
                    )

                    Citizen.Wait(200)
                    inmenu = false
                    DisplayRadar(true)

                    Citizen.Wait(40000)

                    TriggerServerEvent("SevenLife:Verarbeiter:GiveItem", "kartoffelsalat")
                    inverarbeiter = false
                    AllowSevenNotify = true
                else
                    inmenu = false
                    SetNuiFocus(false, false)
                    inverarbeiter = false
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Verarbeiter", "Du hast nicht die nötigen Items")
                end
            end,
            "glas",
            1,
            "kartoffel",
            20,
            "kartoffelsalat"
        )
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

RegisterNUICallback(
    "lederverarbeiten",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Verarbeiter:CheckItems",
            function(haveitem)
                inmenu = false
                if haveitem then
                    SetNuiFocus(false, false)
                    inverarbeiter = true
                    SendNUIMessage(
                        {
                            type = "OpenNUIVerarbeiter",
                            time = 2000
                        }
                    )
                    inmenu = false
                    Citizen.Wait(200)
                    DisplayRadar(true)

                    Citizen.Wait(40000)

                    TriggerServerEvent("SevenLife:Verarbeiter:GiveItem", "leatherperfekt")
                    inverarbeiter = false
                    AllowSevenNotify = true
                else
                    SetNuiFocus(false, false)
                    inverarbeiter = false
                    AllowSevenNotify = true
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Verarbeiter", "Du hast nicht die nötigen Items", 2000)
                end
            end,
            "leatherschlecht",
            20,
            "leathergood",
            20,
            "leatherperfekt"
        )
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)
