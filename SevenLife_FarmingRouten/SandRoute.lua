local AllowSevenNotify = true
local inmarker = false
local inaction = false

-- Local Start
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
                SevenConfig.locations.sand.x,
                SevenConfig.locations.sand.y,
                SevenConfig.locations.sand.z,
                true
            )
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
                timebetweenchecking = 8
                if inmarker and not inaction then
                    if IsControlJustPressed(0, 38) then
                        inaction = true
                        print("Hey")
                        AllowSevenNotify = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        ESX.TriggerServerCallback(
                            "SevenLife:Sand:CheckIfPlayerHaveItem",
                            function(haveitem)
                                if haveitem then
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, false)
                                    Citizen.Wait(8500)
                                    ClearPedTasks(ped)
                                    TriggerServerEvent(
                                        "SevenLife:GiveItem",
                                        "sand",
                                        math.random(SevenConfig.lowestsandanzahl, SevenConfig.highestsandanzahl)
                                    )
                                    Citizen.Wait(1500)
                                    AllowSevenNotify = true
                                end
                            end,
                            "spaten"
                        )
                    end
                end
            else
                timebetweenchecking = 200
            end
        end
    end
)

RegisterNetEvent("SevenLife:Sand:SendNotify")
AddEventHandler(
    "SevenLife:Sand:SendNotify",
    function(message)
        AllowSevenNotify = false
        Citizen.Wait(1)
        TriggerEvent("sevenliferp:closenotify", false)
        Citizen.Wait(100)
        TriggerEvent("sevenliferp:startnui", message, "System - Nachricht", true)
        Citizen.Wait(3000)
        TriggerEvent("sevenliferp:closenotify", false)
        Citizen.Wait(200)
        inaction = false
        AllowSevenNotify = true
    end
)

local inmarkers = false
local inareas = false
-- Local Verarbeiter Start
Citizen.CreateThread(
    function()
        SpawnNPCSandverarbeiter()

        Citizen.Wait(1000)
        while true do
            Citizen.Wait(time)
            local ped = GetPlayerPed(-1)
            local coordofped = GetEntityCoords(ped)
            local distance =
                GetDistanceBetweenCoords(
                coordofped,
                SevenConfig.locations.SandVerarbeiter.x,
                SevenConfig.locations.SandVerarbeiter.y,
                SevenConfig.locations.SandVerarbeiter.z,
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
            local ped = GetPlayerPed(-1)
            Citizen.Wait(timebetweenchecking)
            if inareas then
                timebetweenchecking = 20
                if inmarkers and not inaction then
                    if IsControlJustPressed(0, 38) then
                        inaction = true
                        print("hey")
                        AllowSevenNotify = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        ESX.TriggerServerCallback(
                            "SevenLife:Sand:CheckIfPlayerHaveItemsand",
                            function(haveitem)
                                if haveitem then
                                    SendNUIMessage(
                                        {
                                            type = "openvararbeiternavsand"
                                        }
                                    )
                                    Citizen.Wait(10000)
                                    SendNUIMessage(
                                        {
                                            type = "resetnavbar"
                                        }
                                    )
                                    TriggerServerEvent("SevenLife:GiveItem", "glas", 1)
                                    Citizen.Wait(200)
                                    AllowSevenNotify = true
                                    inaction = false
                                end
                            end,
                            "sand"
                        )
                    end
                end
            else
                timebetweenchecking = 200
            end
        end
    end
)

function SpawnNPCSandverarbeiter()
    local pednumber = tonumber(1)
    for i = 1, pednumber do
        local NpcSpawner =
            vector3(
            SevenConfig.locations.SandVerarbeiter.x,
            SevenConfig.locations.SandVerarbeiter.y,
            SevenConfig.locations.SandVerarbeiter.z
        )
        local ped = GetHashKey("cs_floyd")
        if not HasModelLoaded(ped) then
            RequestModel(ped)
            while not HasModelLoaded(ped) do
                Citizen.Wait(1)
            end
            ped1 =
                CreatePed(
                8,
                ped,
                NpcSpawner.x,
                NpcSpawner.y,
                NpcSpawner.z,
                SevenConfig.locations.SandVerarbeiter.heading,
                true,
                false
            )
            SetEntityInvincible(ped1, true)
            FreezeEntityPosition(ped1, true)
            SetBlockingOfNonTemporaryEvents(ped1, true)
        end
    end
end
