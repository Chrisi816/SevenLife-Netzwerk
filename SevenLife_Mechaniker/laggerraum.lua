-- Variables

local InPedArea = false
local Ped = GetHashKey("a_m_y_business_03")
local IsPedLoaded = false
local mechanikjob = mechanik
local IsPlayerInMenu = false
local InRangeOfLaggeraum = false
local IsNotify = true

-- Ped
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.Laggerraum.x,
                Config.Laggerraum.y,
                Config.Laggerraum.z,
                true
            )

            Citizen.Wait(1000)
            InPedArea = false
            if distance < 40 then
                InPedArea = true
                if not IsPedLoaded then
                    RequestModel(Ped)
                    while not HasModelLoaded(Ped) do
                        Citizen.Wait(1)
                    end
                    Ped2 =
                        CreatePed(
                        4,
                        Ped,
                        Config.Laggerraum.x,
                        Config.Laggerraum.y,
                        Config.Laggerraum.z,
                        Config.Laggerraum.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(Ped2, true)
                    FreezeEntityPosition(Ped2, true)
                    SetBlockingOfNonTemporaryEvents(Ped2, true)
                    RequestAnimDict("missfbi_s4mop")
                    while not HasAnimDictLoaded("missfbi_s4mop") do
                        Citizen.Wait(1)
                    end
                    TaskPlayAnim(Ped2, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    IsPedLoaded = true
                end
            end

            if IsPedLoaded and not InPedArea then
                DeleteEntity(Ped2)
                SetModelAsNoLongerNeeded(Ped)
                IsPedLoaded = false
            end
        end
    end
)

-- Mechaniker Laggerraum

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(coords, Config.Laggerraum.x, Config.Laggerraum.y, Config.Laggerraum.z, true)
            if mechanik then
                if IsPlayerInMenu == false then
                    if distance < 1.5 then
                        InRangeOfLaggeraum = true
                        if IsNotify then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um das Lager anzusehen",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 1.6 and distance <= 4 then
                            InRangeOfLaggeraum = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

-- Check Key
Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if InRangeOfLaggeraum then
                if IsControlJustPressed(0, 38) then
                    if IsPlayerInMenu == false then
                        IsPlayerInMenu = true
                        IsNotify = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        ESX.TriggerServerCallback(
                            "SevenLife:Mechaniker:GetItemImLager",
                            function(items)
                                ESX.TriggerServerCallback(
                                    "SevenLife:Mechaniker:GetReadyItems",
                                    function(items2)
                                        TriggerScreenblurFadeIn(2000)
                                        SetNuiFocus(true, true)
                                        SendNUIMessage(
                                            {
                                                type = "OpenLager",
                                                lageritems = items,
                                                gereate = items2
                                            }
                                        )
                                    end
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
    "CloseMenuLaggerraum",
    function()
        TriggerScreenblurFadeOut(2000)
        IsNotify = true
        IsPlayerInMenu = false
    end
)

RegisterNUICallback(
    "GetItemOutLager",
    function(data)
        TriggerScreenblurFadeOut(2000)
        SetNuiFocus(false, false)
        IsNotify = true
        IsPlayerInMenu = false
        local NameOfItem = data.name
        ESX.TriggerServerCallback(
            "SevenLife:Mechaniker:CheckIfEnoughInLagerOrGerät",
            function(enoughinlager)
                if enoughinlager then
                    TriggerServerEvent("SevenLife:Mechaniker:GiveItem", data.name)
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Fahrzeug", "Im Lager sind zu wenig Items", 2000)
                end
            end,
            data.name
        )
    end
)

RegisterNUICallback(
    "GetInventoryItems",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Mechaniker:GetInventoryItems",
            function(items)
                local inventory = {}
                for key, value in pairs(items) do
                    if items[key].count <= 0 then
                        items[key] = nil
                    else
                        items[key].type = "item_standard"
                        table.insert(inventory, items[key])
                    end
                end
                SendNUIMessage(
                    {
                        type = "OpenNUIInventory",
                        inventoryitems = inventory
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "InsertItemIntoLager",
    function(data)
        if
            data.name == "repairkit" or data.name == "lackierung" or data.name == "rad" or data.name == "xenon" or
                data.name == "turbo" or
                data.name == "rauchfarbe" or
                data.name == "vorderestoßstangen" or
                data.name == "hinterestoßstangen" or
                data.name == "seitenschweller" or
                data.name == "auspuff" or
                data.name == "motorhaube" or
                data.name == "motor" or
                data.name == "getriebe" or
                data.name == "bremsen" or
                data.name == "hupe" or
                data.name == "mixedlakeriung" or
                data.name == "federung"
         then
            TriggerServerEvent("SevenLife:Mechaniker:AddLagerItem", data.name)
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Fahrzeug", "Dieses Item kannst du nicht einlagern", 2000)
        end
    end
)
