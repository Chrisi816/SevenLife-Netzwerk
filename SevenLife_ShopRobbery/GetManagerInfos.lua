started = false
ispedallowedtowalk = false
RegisterNetEvent("SevenLife:ShopRobbery:MakeNextStep")
AddEventHandler(
    "SevenLife:ShopRobbery:MakeNextStep",
    function()
        TriggerEvent(
            "SevenLife:TimetCustom:Notify",
            "Wegweiser",
            "Fahre zum Markierten Punkt und klaue dem Manager seine Papiere um zu sehen wie viel die Märkte verdienen!",
            2000
        )
        started = true
        ispedallowedtowalk = true
        -- TODO
        SpawnNPC()
        StartMoving()
        TriggerEvent("SevenLife:ShopRobbery:MakeFunctions")
    end
)

function SpawnNPC()
    local ped_hash = GetHashKey("csb_reporter")
    RequestModel(ped_hash)
    while not HasModelLoaded(ped_hash) do
        Citizen.Wait(1)
    end
    NPC =
        CreatePed(1, ped_hash, Config.Manager.x, Config.Manager.y, Config.Manager.z - 1, Config.Manager.h, false, true)
    if IsPedNotDoingAnything(NPC) then
        ClearPedTasks(NPC)

        SetPedIsDrunk(NPC, true)
        RequestAnimSet("move_m@drunk@verydrunk")
        while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
            Wait(1)
        end
        SetPedMovementClipset(NPC, "move_m@drunk@verydrunk", 1.0)

        TaskWanderInArea(NPC, Config.Manager.x, Config.Manager.y, Config.Manager.z - 1, 50.0)
    end
    BlipNPC = AddBlipForEntity(NPC)
    SetBlipDisplay(BlipNPC, 4)
    SetBlipScale(BlipNPC, 0.8)
    SetBlipColour(BlipNPC, 0)
    SetBlipAsShortRange(BlipNPC, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Menager")
    EndTextCommandSetBlipName(BlipNPC)
    Citizen.CreateThread(
        function()
            while started do
                Citizen.Wait(1)
                NPCcoords = GetEntityCoords(NPC)
            end
        end
    )
end

function IsPedNotDoingAnything(ped)
    if IsPedOnFoot(ped) and not IsEntityInWater(ped) then
        if not IsPedSprinting(ped) and not IsPedRunning(ped) and not IsPedWalking(ped) then
            if not GetIsTaskActive(ped, 12) and not GetIsTaskActive(ped, 307) then
                if IsPedStill(ped) then
                    return true
                else
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function StartMoving()
    Citizen.CreateThread(
        function()
            while true do
                if ispedallowedtowalk then
                    if IsPedNotDoingAnything(NPC) then
                        TaskWanderInArea(NPC, Config.Manager.x, Config.Manager.y, Config.Manager.z, 50.0)
                    end
                end
                Citizen.Wait(500)
            end
        end
    )
end

RegisterNetEvent("SevenLife:ShopRobbery:MakeFunctions")
AddEventHandler(
    "SevenLife:ShopRobbery:MakeFunctions",
    function()
        local notifys = true
        local inmarker = false
        local inmenu = false
        local timemain = 100

        Citizen.CreateThread(
            function()
                while started do
                    Citizen.Wait(timemain)
                    local ped = GetPlayerPed(-1)
                    local coord = GetEntityCoords(ped)

                    local distance = GetDistanceBetweenCoords(coord, NPCcoords.x, NPCcoords.y, NPCcoords.z, true)
                    if distance < 15 then
                        area = true
                        timemain = 15
                        if distance < 2 then
                            inmarker = true
                            if notifys then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um dem Manager seine Daten zu klauen",
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
        )
        Citizen.CreateThread(
            function()
                Citizen.Wait(10)
                while started do
                    Citizen.Wait(5)
                    if inmarker then
                        if IsControlJustPressed(0, 38) then
                            if inmenu == false then
                                inmenu = true
                                TriggerEvent("sevenliferp:closenotify", false)
                                notifys = false
                                SetNuiFocus(true, true)
                                openmenu = true

                                moneysaving = math.random(400, 2000)
                                SendNUIMessage(
                                    {
                                        type = "OpenInfoKatalog",
                                        money = moneysaving
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
    end
)
RegisterNUICallback(
    "NextStep",
    function()
        Citizen.CreateThread(
            function()
                Citizen.Wait(10000)
                DeletePed(NPC)
            end
        )
        notactive = false
        OpenMenu = false
        SetNuiFocus(false, false)
        AllowSevenNotify = true
        SetNuiFocus(false, false)
        TriggerEvent("SevenLife:ShopRobbery:AcceptShop")
    end
)
