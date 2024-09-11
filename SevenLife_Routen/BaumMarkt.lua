-- Variables
local time = 200
local timebetweenchecking = 200
local AllowSevenNotify = true
local inarea = false
local OpenMenu = false
local inmarker = false
-- ESX

-- Local Start
Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        CreateBlip(Config.NPCBaumarkt.x, Config.NPCBaumarkt.y, Config.NPCBaumarkt.z, "Baumarkt", 566, 61)
        while true do
            Citizen.Wait(time)
            local ped = GetPlayerPed(-1)
            local coordofped = GetEntityCoords(ped)
            local distance =
                GetDistanceBetweenCoords(
                coordofped,
                Config.NPCBaumarkt.x,
                Config.NPCBaumarkt.y,
                Config.NPCBaumarkt.z,
                true
            )
            if distance < 20 then
                time = 110
                inarea = true
                if distance < 2 then
                    if AllowSevenNotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um den Katalog zu begutachten",
                            "System-Nachricht",
                            true
                        )
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
            Citizen.Wait(timebetweenchecking)
            if inarea then
                timebetweenchecking = 5
                if inmarker and not OpenMenu then
                    if IsControlJustPressed(0, 38) then
                        OpenMenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "openbaumarkt-container"
                            }
                        )
                        AllowSevenNotify = false
                    end
                end
            else
                timebetweenchecking = 200
            end
        end
    end
)

function CreateBlip(x, y, z, name, sprite, colour)
    local blip = AddBlipForCoord(x, y)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

--------------------------------------------------------------------------------------------------------------
-------------------------------------------Closing System-----------------------------------------------------
--------------------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "close",
    function()
        SetNuiFocus(false, false)
        AllowSevenNotify = true
        OpenMenu = false
    end
)
Citizen.CreateThread(
    function()
        Citizen.Wait(2000)

        SpawnNPC()
    end
)
-- NPC Function
function SpawnNPC()
    local pednumber = tonumber(1)
    for i = 1, pednumber do
        local NpcSpawner = vector3(Config.NPCBaumarkt.x, Config.NPCBaumarkt.y, Config.NPCBaumarkt.z)
        local ped = GetHashKey("u_m_y_juggernaut_")
        if not HasModelLoaded(ped) then
            RequestModel(ped)
            while not HasModelLoaded(ped) do
                Citizen.Wait(1)
            end
            ped1 = CreatePed(4, ped, NpcSpawner.x, NpcSpawner.y, NpcSpawner.z, Config.NPCBaumarkt.heading, false, true)
            SetEntityInvincible(ped1, true)
            FreezeEntityPosition(ped1, true)
            SetBlockingOfNonTemporaryEvents(ped1, true)
        end
    end
end

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
                Config.NPCBaumarkt.x,
                Config.NPCBaumarkt.y,
                Config.NPCBaumarkt.z,
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
                        Config.NPCBaumarkt.x,
                        Config.NPCBaumarkt.y,
                        Config.NPCBaumarkt.z,
                        Config.NPCBaumarkt.heading,
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
RegisterNUICallback(
    "payforitem",
    function(data)
        SetNuiFocus(false, false)
        AllowSevenNotify = true
        OpenMenu = false
        TriggerServerEvent("SevenLife:FarmingRouten:GiveItem", data.name, data.price)
    end
)
