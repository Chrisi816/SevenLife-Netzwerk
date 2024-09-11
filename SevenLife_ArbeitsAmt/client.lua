-- Variablesr

local timess = 100
local inmarkerss = false
local notifysss = true

Citizen.CreateThread(
    function()
        SpawnNPC()
        MakeBlipsForArbeitsamt()
    end
)

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
            Citizen.Wait(1000)
        end
    end
)

-- NPC Function
function SpawnNPC()
    Citizen.CreateThread(
        function()
            local NpcSpawner = vector3(Config.Ped.x, Config.Ped.y, Config.Ped.z)
            local ped = GetHashKey("a_m_m_skater_01")
            if not HasModelLoaded(ped) then
                RequestModel(ped)
                while not HasModelLoaded(ped) do
                    Citizen.Wait(1)
                end
                ped1 = CreatePed(4, ped, NpcSpawner.x, NpcSpawner.y, NpcSpawner.z, Config.Ped.heading, false, true)
                SetEntityInvincible(ped1, true)
                FreezeEntityPosition(ped1, true)
                SetBlockingOfNonTemporaryEvents(ped1, true)
            end
        end
    )
end
--- Hermano
Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            Coords = GetEntityCoords(Ped)
            Citizen.Wait(timess)
            local distance = GetDistanceBetweenCoords(Coords, Config.Ped.x, Config.Ped.y, Config.Ped.z, true)
            if distance < 10 then
                timess = 25
                if distance < 2 then
                    timess = 5
                    inmarkerss = true
                    if notifysss then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um Jobangebote zu finden",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.1 and distance <= 5 then
                        inmarkerss = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                if distance >= 8 and distance <= 12 then
                    timess = 100
                end
            end
        end
    end
)

local endjob = {}
Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(5)
            if inmarkerss then
                if IsControlJustPressed(0, 38) then
                    ESX.TriggerServerCallback(
                        "SevenLife:GetJobs",
                        function(result)
                            SetNuiFocus(true, true)
                            notifysss = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            inmarkerss = false
                            for v, k in pairs(result) do
                                table.insert(endjob, result[v])
                            end
                            SendNUIMessage(
                                {
                                    type = "OpenArbeitsAmt",
                                    job = endjob
                                }
                            )
                        end
                    )
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
        endjob = {}
        inmarkerss = true
        notifysss = true
    end
)

RegisterNUICallback(
    "giveJob",
    function(data)
        TriggerServerEvent("SevenLife:JobCenter:AddJob", data.job, data.label)
    end
)

-- Blips function

function MakeBlipsForArbeitsamt()
    local blip = AddBlipForCoord(Config.Ped.x, Config.Ped.y, Config.Ped.z)
    SetBlipSprite(blip, 269)
    SetBlipColour(blip, 5)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Arbeitsamt")
    EndTextCommandSetBlipName(blip)
end
