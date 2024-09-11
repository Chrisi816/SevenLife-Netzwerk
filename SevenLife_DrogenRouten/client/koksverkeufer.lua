local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_m_mexlabor_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.DrogenRouten.KoksEnde.x,
                Config.DrogenRouten.KoksEnde.y,
                Config.DrogenRouten.KoksEnde.z,
                true
            )

            Citizen.Wait(500)

            if distance < 30 then
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
                        Config.DrogenRouten.KoksEnde.x,
                        Config.DrogenRouten.KoksEnde.y,
                        Config.DrogenRouten.KoksEnde.z,
                        Config.DrogenRouten.KoksEnde.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped1, true)
                    FreezeEntityPosition(ped1, true)
                    SetBlockingOfNonTemporaryEvents(ped1, true)
                    RequestAnimDict("amb@code_human_in_car_mp_actions@gang_sign_a@std@ds@base")
                    while (not HasAnimDictLoaded("amb@code_human_in_car_mp_actions@gang_sign_a@std@ds@base")) do
                        Citizen.Wait(10)
                    end
                    TaskPlayAnim(
                        ped1,
                        "amb@code_human_in_car_mp_actions@gang_sign_a@std@ds@base",
                        "idle_a",
                        2.0,
                        -2.0,
                        -1,
                        49,
                        0,
                        true,
                        false,
                        true
                    )
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
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

local inmarker = false
local inmenu = false
local timemain = 100
local notifys = true
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(150)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance =
                GetDistanceBetweenCoords(
                coord,
                Config.DrogenRouten.MethEnde.x,
                Config.DrogenRouten.MethEnde.y,
                Config.DrogenRouten.MethEnde.z,
                true
            )
            if distance < 15 then
                timemain = 15
                if distance < 2 then
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um 1 Packung Koks zu verkaufen",
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
                        ESX.TriggerServerCallback(
                            "SevenLife:Item:GetPackungen",
                            function(count)
                                TriggerEvent("sevenliferp:closenotify", false)
                                if count >= 1 then
                                    inmenu = true
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    notifys = false

                                    SendNUIMessage(
                                        {
                                            type = "OpenBar"
                                        }
                                    )

                                    Citizen.CreateThread(
                                        function()
                                            Citizen.Wait(11000)
                                            TriggerServerEvent("SevenLife:Koks:GiveGeld")
                                            inmenu = false
                                            notifys = true
                                        end
                                    )
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Meth Verkäufer",
                                        "Du hast zu wenig Koks packungen",
                                        2000
                                    )
                                end
                            end,
                            "koks_verpackt"
                        )
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
