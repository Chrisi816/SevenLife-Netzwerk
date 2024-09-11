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

RegisterNetEvent("SevenLife:KaufVertrag:OpenCard")
AddEventHandler(
    "SevenLife:KaufVertrag:OpenCard",
    function()
        local ped = GetPlayerPed(-1)
        if IsPedInAnyVehicle(ped, false) then
            Anim("anim@amb@nightclub@peds@")
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, false)
            SetNuiFocus(true, true)
            SendNUIMessage(
                {
                    type = "openverkauf"
                }
            )
        else
            TriggerEvent("sevenliferp:closenotify", false)
            Citizen.Wait(200)
            TriggerEvent("sevenliferp:startnui", "Du musst in einem Auto sein", "System - Nachricht", true)
            Citizen.Wait(3000)
            TriggerEvent("sevenliferp:closenotify", false)
        end
    end
)
function Anim(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

RegisterNUICallback(
    "CloseMenu",
    function()
        local ped = GetPlayerPed(-1)
        ClearPedTasks(ped)
        SetNuiFocus(false, false)
    end
)
