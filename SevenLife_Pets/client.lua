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

local inapothekerange = false
local notifys = true
local inmenu = false
local pedloaded = false
local ped = GetHashKey("a_m_y_business_03")
-- Pharma Apotheke

Citizen.CreateThread(
    function()
        BlipPet()
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)

            local distance =
                GetDistanceBetweenCoords(
                coords,
                SevenConfig.PetLocation.x,
                SevenConfig.PetLocation.y,
                SevenConfig.PetLocation.z,
                true
            )

            if not IsPedInAnyVehicle(player, true) then
                if distance < 1.5 then
                    inapothekerange = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um dir das Tierheim Sortiment anzugucken",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.6 and distance <= 6 then
                        inapothekerange = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                inapothekerange = false
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inapothekerange then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        TriggerEvent("sevenliferp:closenotify", false)
                        inmenu = true
                        notifys = false
                        TriggerScreenblurFadeIn(2000)
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenPetMenu"
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
                SevenConfig.PetLocation.x,
                SevenConfig.PetLocation.y,
                SevenConfig.PetLocation.z,
                true
            )

            Citizen.Wait(1000)

            if distance < 40 then
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped1 =
                        CreatePed(
                        4,
                        ped,
                        SevenConfig.PetLocation.x,
                        SevenConfig.PetLocation.y,
                        SevenConfig.PetLocation.z,
                        SevenConfig.PetLocation.heading,
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
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped1)
                SetModelAsNoLongerNeeded(ped1)
                pedloaded = false
            end
        end
    end
)

function BlipPet()
    local blips = vector3(SevenConfig.PetLocation.x, SevenConfig.PetLocation.y, SevenConfig.PetLocation.z)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 141)
    SetBlipScale(blip1, 0.9)
    SetBlipColour(blip1, 48)
    SetBlipDisplay(blip1, 4)
    SetBlipAsShortRange(blip1, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Tierheim")
    EndTextCommandSetBlipName(blip1)
end

RegisterNUICallback(
    "CloseMenu",
    function(...)
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
        TriggerScreenblurFadeOut(2000)
    end
)

RegisterNUICallback(
    "BuyPets",
    function(data)
        local types = tonumber(data.types)
        local price = tonumber(data.price)
        local item = data.item
        print(types)
        print(price)
        print(item)
        SetNuiFocus(false, false)
        TriggerScreenblurFadeOut(2000)
        inmenu = false
        notifys = true
        ESX.TriggerServerCallback(
            "SevenLife:GetIfPlayerHavePet",
            function(havdog)
                if not havdog then
                    TriggerServerEvent("SevenLife:Pets:MakePet", item, price, types)

                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Pets",
                        "Du hast den " .. item .. " erfolgreich gekauft!",
                        2000
                    )
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Pets", "Du hast den " .. item .. " schon!", 2000)
                end
            end,
            item,
            types
        )
    end
)
