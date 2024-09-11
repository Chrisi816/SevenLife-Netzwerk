local AllowSevenNotify = true
local inmarker = false
local active = false
local inaction = false

-- Local Start
Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        while true do
            Citizen.Wait(time)
            local ped = GetPlayerPed(-1)
            local coordofped = GetEntityCoords(ped)
            local distance = GetDistanceBetweenCoords(coordofped, Config.Sand.x, Config.Sand.y, Config.Sand.z, true)
            if distance < 20 then
                time = 110
                inarea = true
                if distance < 2 then
                    if AllowSevenNotify then
                        TriggerEvent("sevenliferp:startnui", "Drücke E um Sand zu Farmen", "System-Nachricht", true)
                    end
                    inmarker = true
                else
                    if distance >= 2.1 and distance <= 3 then
                        TriggerEvent("sevenliferp:closenotify", false)
                        inmarker = false
                    end
                end
            else
                inarea = false
                time = 200
            end
        end
    end
)
-- KeyCheck
Citizen.CreateThread(
    function()
        while true do
            local ped = GetPlayerPed(-1)
            Citizen.Wait(timebetweenchecking)
            if inarea then
                timebetweenchecking = 5
                if inmarker and not inaction then
                    if IsControlJustPressed(0, 38) then
                        inaction = true
                        AllowSevenNotify = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        ESX.TriggerServerCallback(
                            "SevenLife:Sand:CheckIfPlayerHaveItem",
                            function(haveitem)
                                if haveitem then
                                    active = true
                                    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, false)
                                    SendNUIMessage(
                                        {
                                            type = "OpenBar"
                                        }
                                    )
                                end
                            end,
                            "spaten"
                        )
                    end
                end
            else
                timebetweenchecking = 200
            end
            if active then
                if IsControlJustPressed(0, 38) then
                    SendNUIMessage(
                        {
                            type = "UpdateBar"
                        }
                    )
                end
            end
        end
    end
)
RegisterNUICallback(
    "GiveSand",
    function()
        local ped = GetPlayerPed(-1)
        TriggerEvent("sevenliferp:closenotify", false)
        ClearPedTasksImmediately(ped)
        active = false
        TriggerServerEvent("SevenLife:GiveItem", "sand", math.random(1, 3))
        inaction = false
        AllowSevenNotify = true
    end
)

local inmarkers = false
local inareas = false
Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        while true do
            Citizen.Wait(time)
            local ped = GetPlayerPed(-1)
            local coordofped = GetEntityCoords(ped)
            local distance =
                GetDistanceBetweenCoords(
                coordofped,
                Config.SandVerarbeiter.x,
                Config.SandVerarbeiter.y,
                Config.SandVerarbeiter.z,
                true
            )
            if distance < 20 then
                time = 110
                inareas = true
                if distance < 1.5 then
                    if AllowSevenNotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um Sand zu verarbeiten",
                            "System-Nachricht",
                            true
                        )
                    end
                    inmarkers = true
                else
                    if distance >= 1.6 and distance <= 3 then
                        TriggerEvent("sevenliferp:closenotify", false)
                        inmarkers = false
                    end
                end
            else
                inareas = false
                time = 200
            end
        end
    end
)
-- KeyCheck
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timebetweenchecking)
            if inareas then
                timebetweenchecking = 20
                if inmarkers and not inaction then
                    if IsControlJustPressed(0, 38) then
                        inaction = true
                        SetNuiFocus(true, true)
                        AllowSevenNotify = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        SendNUIMessage(
                            {
                                type = "OpenSandVerarbeiterNUI"
                            }
                        )
                    end
                end
            else
                timebetweenchecking = 200
            end
        end
    end
)

RegisterNUICallback(
    "MakeVerarbeiten",
    function()
        SetNuiFocus(false, false)

        ESX.TriggerServerCallback(
            "SevenLife:Sand:CheckIfPlayerHaveItemsand",
            function(haveitem)
                if haveitem then
                    SendNUIMessage(
                        {
                            type = "OpenLoadingVerarbeiten"
                        }
                    )
                    Citizen.Wait(30000)
                    TriggerServerEvent("SevenLife:GiveItem", "glas", 1)
                    Citizen.Wait(200)
                    AllowSevenNotify = true
                    inaction = false
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Sand - Verarbeiter", "Du hast zu wenig Sand")
                    AllowSevenNotify = true
                    inaction = false
                end
            end,
            "sand"
        )
    end
)

local pedarea = false
local ped = GetHashKey("s_m_y_airworker")
local pedloaded = false
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.SandVerarbeiter.x,
                Config.SandVerarbeiter.y,
                Config.SandVerarbeiter.z,
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
                        Config.SandVerarbeiter.x,
                        Config.SandVerarbeiter.y,
                        Config.SandVerarbeiter.z,
                        Config.SandVerarbeiter.heading,
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
