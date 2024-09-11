ESX = nil
local inmarker = false
local notifys = true
local inarea = false
local inmenu = false
local chopping = false
local spawned = false
local coordx, coordy, coordz, obje

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(1)
        end
    end
)
RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        Citizen.Wait(6000)
        TriggerServerEvent("SevenLife:Trees:GetData")
    end
)

RegisterNetEvent("SevenLife:Trees:SyncFallenTree3")
AddEventHandler(
    "SevenLife:Trees:SyncFallenTree3",
    function(table)
        ESX.Game.SpawnObject(
            "prop_tree_fallen_01",
            vector3(table.x, table.y, table.z - 1.7),
            function(obj)
                obje = obj
                coordx = table.x
                coordy = table.y
                coordz = table.z
                spawned = true
                SetEntityHeading(obj, table.heading + 90)
                SetEntityInvincible(obj, true)
                FreezeEntityPosition(obj, true)
            end
        )
    end
)
Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            if spawned then
                Citizen.Wait(250)
                local player = GetPlayerPed(-1)
                local coords = GetEntityCoords(player)
                local distance = GetDistanceBetweenCoords(coords, coordx, coordy, coordz, true)

                if inmenu == false then
                    if distance < 40 then
                        inarea = true
                        if distance < 1.5 then
                            inmarker = true
                            if notifys then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um den Stamm zu entfernen!",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 1.6 and distance <= 4 then
                                inmarker = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        if distance >= 40.1 and distance <= 60.0 then
                            inarea = false
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(10000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inarea then
                if inmarker then
                    if IsControlJustPressed(0, 38) then
                        if inmenu == false then
                            ESX.TriggerServerCallback(
                                "SevenLife:Trees:GetItem",
                                function(result)
                                    if result then
                                        inmenu = true
                                        notifys = false
                                        TriggerEvent("sevenliferp:closenotify", false)
                                        ChopLumber()
                                    else
                                        TriggerEvent(
                                            "SevenLife:TimetCustom:Notify",
                                            "Baum",
                                            "Du brauchst eine Axt um diesen Baum zu fällen",
                                            2000
                                        )
                                    end
                                end
                            )
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(5000)
            end
        end
    end
)
function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(3)
    end
end

function ChopLumber()
    local animDict = "melee@hatchet@streamed_core"
    local animName = "plyr_rear_takedown_b"
    local ped = PlayerPedId()
    chopping = true
    CreateThread(
        function()
            while chopping do
                loadAnimDict(animDict)
                TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                Citizen.Wait(3000)
                TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                Citizen.Wait(3000)
                chopping = false
                DeleteObject(obje)
                ESX.Game.DeleteObject(obje)
                DeleteEntity(obje)
                ClearPedTasks(ped)
                FreezeEntityPosition(ped, false)
                TriggerServerEvent("SevenLife:Trees:RemoveAll")
                TriggerEvent("SevenLife:TimetCustom:Notify", "Baum", "Erfolgreich einen Baum entfernt!", 2000)
            end
        end
    )
end
RegisterNetEvent("SevenLife:Trees:Remove")
AddEventHandler(
    "SevenLife:Trees:Remove",
    function()
        DeleteObject(obje)
        ESX.Game.DeleteObject(obje)
        DeleteEntity(obje)
    end
)
