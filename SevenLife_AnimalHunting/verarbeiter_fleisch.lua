ESX = nil
local ingaragerange = false
local notifys = true
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
local inmenu = false
local pedloaded = false
-- Core
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

        AddNagelBlipOnMap(SevenConfig.NagelFabrick.x, SevenConfig.NagelFabrick.y, SevenConfig.NagelFabrick.z)
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(
                coords,
                SevenConfig.NagelFabrick.x,
                SevenConfig.NagelFabrick.y,
                SevenConfig.NagelFabrick.z,
                true
            )

            if inmenu == false then
                if distance < 1.5 then
                    ingaragerange = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um zum Nagel zu verarbeiten",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.6 and distance <= 4 then
                        ingaragerange = false
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
            if ingaragerange then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        inmenu = true
                        notifys = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        ESX.TriggerServerCallback(
                            "SevenLife:Verarbeiters:CheckItems",
                            function(enough)
                                if enough then
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Tier",
                                        "Du startest das Verarbeiten des Eisens",
                                        2000
                                    )
                                    TriggerServerEvent("SevenLife:Verarbeiter:Removeitems", "eisen", 10)
                                    Citizen.Wait(30000)
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Tier",
                                        "Erfolgreich verarbeitet",
                                        2000
                                    )
                                    inmenu = false
                                    notifys = true
                                    TriggerServerEvent("SevenLife:Verarbeiter:GiveItems", "nagel", 1)
                                else
                                    inmenu = false
                                    notifys = true
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Tier",
                                        "Du hast zu wenige Items",
                                        2000
                                    )
                                end
                            end,
                            "eisen",
                            10
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
                SevenConfig.NagelFabrick.x,
                SevenConfig.NagelFabrick.y,
                SevenConfig.NagelFabrick.z,
                true
            )

            Citizen.Wait(1000)
            pedarea = false
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
                        SevenConfig.NagelFabrick.x,
                        SevenConfig.NagelFabrick.y,
                        SevenConfig.NagelFabrick.z,
                        SevenConfig.NagelFabrick.heading,
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
                SetModelAsNoLongerNeeded(ped)
                pedloaded = false
            end
        end
    end
)

function AddNagelBlipOnMap(coordsx, coordsy, coordsz)
    local blips = vector3(coordsx, coordsy, coordsz)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 478)
    SetBlipColour(blip1, 39)
    SetBlipDisplay(blip1, 4)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Nagel Herstellen")
    EndTextCommandSetBlipName(blip1)
end
