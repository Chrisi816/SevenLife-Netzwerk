selling = false
notify = true

if Config.seller then
    Citizen.CreateThread(
        function()
            while true do
                Citizen.Wait(1)
                local Npcplacer = vector3(Config.sellernpc.x, Config.sellernpc.y, Config.sellernpc.z)
                local distance =
                    GetDistanceBetweenCoords(
                    GetEntityCoords(GetPlayerPed(-1)),
                    vector3(Npcplacer.x, Npcplacer.y, Npcplacer.z)
                )
                spawnsellernpc()
                if distance < 1 then
                    if selling == false then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um deine Juwelen zu verkaufen",
                            "System-Nachricht",
                            true
                        )
                    else
                        if selling then
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                    if selling == false then
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent("sevenlife:checkjuwels")
                            selling = true
                        end
                    end
                else
                    if distance >= 1.1 and distance <= 1.5 then
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    )
end

function spawnsellernpc()
    local pednumber = tonumber(1)
    for i = 1, pednumber do
        local NpcSpawner = vector3(Config.sellernpc.x, Config.sellernpc.y, Config.sellernpc.z)
        local ped = GetHashKey("a_m_m_soucent_01")
        if not HasModelLoaded(ped) then
            RequestModel(ped)
            while not HasModelLoaded(ped) do
                Citizen.Wait(1)
            end
            ped1 = CreatePed(4, ped, NpcSpawner.x, NpcSpawner.y, NpcSpawner.z, Config.sellernpc.heading, false, true)
            SetEntityInvincible(ped1, true)
            FreezeEntityPosition(ped1, true)
            SetBlockingOfNonTemporaryEvents(ped1, true)
        end
    end
end
RegisterNetEvent("sevenlife:callback")
AddEventHandler(
    "sevenlife:callback",
    function(enoughitems)
        if enoughitems == true then
            TriggerEvent("")
            selling = true
        else
            if enoughitems == false then
                selling = false
                TriggerEvent("sevenlife:notifyit")
            end
        end
    end
)

RegisterNetEvent("sevenlife:notifyit")
AddEventHandler(
    "sevenlife:notifyit",
    function()
        Citizen.CreateThread(
            function()
                while notify do
                    TriggerEvent("sevenliferp:startnui", "Du hast zu wenige Juwelen", "System-Nachricht", true)
                    Citizen.Wait(2000)
                    TriggerEvent("sevenliferp:closenotify", false)
                    notify = false
                end
            end
        )
    end
)

RegisterNetEvent("sevenlife:givecashwaiter")
AddEventHandler(
    "sevenlife:givecashwaiter",
    function()
        Citizen.CreateThread(
            function()
                while selling do
                    TriggerServerEvent("sevenlife:takejuwels")
                    Citizen.Wait(10000)
                    TriggerServerEvent("sevenlife:givecash")
                    selling = false
                end
            end
        )
    end
)
AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        spawnsellernpc()
    end
)
