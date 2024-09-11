-- ESX

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
            Citizen.Wait(10)
        end
    end
)

local spawnedcarrotplants = 0
local coordsplantse = {}
local nearbyObject, nearbyID

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(500)
            local coords = GetEntityCoords(PlayerPedId())

            if GetDistanceBetweenCoords(coords, SevenConfig.locations.potato, true) < 60 then
                inarea = true
                SpanwPlantsForFarms()
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        while true do
            Citizen.Wait(1)
            local ped = PlayerPedId()
            local coordofped = GetEntityCoords(ped)

            for i = 1, #coordsplantse, 1 do
                if GetDistanceBetweenCoords(coordofped, GetEntityCoords(coordsplantse[i]), true) < 2 then
                    nearbyObject, nearbyID = coordsplantse[i], i
                    coord = GetEntityCoords(coordsplantse[i])
                end
            end

            local distance = GetDistanceBetweenCoords(coordofped, coord, true)
            if nearbyObject and IsPedOnFoot(ped) then
                if not inaction then
                    if distance >= 2.1 and distance <= 3 then
                        TriggerEvent("sevenliferp:closenotify", false)
                        nearbyObject = false
                    end
                    TriggerEvent("sevenliferp:startnui", "Drücke E um Kartoffeln zu sammeln", "System-Nachricht", true)
                    if IsControlJustPressed(0, 38) then
                        inaction = true

                        TriggerEvent("sevenliferp:closenotify", false)
                        ESX.TriggerServerCallback(
                            "SevenLife:FarmingRouten:HavePlayerEnoughSpace",
                            function(canPickUp)
                                if canPickUp then
                                    TaskStartScenarioInPlace(ped, "world_human_gardener_plant", 0, false)

                                    SendNUIMessage(
                                        {
                                            type = "opensammelkarrot"
                                        }
                                    )

                                    Citizen.Wait(8500)
                                    SendNUIMessage(
                                        {
                                            type = "removesammelnkarott"
                                        }
                                    )
                                    ClearPedTasks(ped)
                                    Citizen.Wait(500)

                                    ESX.Game.DeleteObject(nearbyObject)
                                    table.remove(coordsplantse, nearbyID)
                                    spawnedcarrotplants = spawnedcarrotplants - 1

                                    inaction = false
                                    nearbyObject = false
                                    TriggerServerEvent("SevenLife:Farming:GivePlayerItems")
                                    TriggerEvent("sevenliferp:closenotify", false)
                                else
                                    TriggerEvent(
                                        "SevenLife:Carrot:Time:Notify",
                                        "Du hast in deinem Rucksack kein Platz mehr"
                                    )
                                end
                            end,
                            "kartoffel"
                        )
                    end
                end
            else
                if distance >= 2.1 and distance <= 3 then
                    TriggerEvent("sevenliferp:closenotify", false)
                end

                Citizen.Wait(100)
            end
        end
    end
)
-- Timet Notify
RegisterNetEvent("SevenLife:Carrot:Time:Notify")
AddEventHandler(
    "SevenLife:Carrot:Time:Notify",
    function(msg)
        AllowSevenNotify = false
        TriggerEvent("sevenliferp:closenotify", false)
        Citizen.Wait(200)
        TriggerEvent("sevenliferp:startnui", msg, "System - Nachricht", true)
        Citizen.Wait(3000)
        TriggerEvent("sevenliferp:closenotify", false)
        AllowSevenNotify = true
    end
)

-- Spawn function
function SpanwPlantsForFarms()
    while spawnedcarrotplants < 30 do
        Citizen.Wait(1)
        local coordsforfarm = GenerateCoords()

        ESX.Game.SpawnLocalObject(
            "prop_bush_med_01",
            coordsforfarm,
            function(objekt)
                PlaceObjectOnGroundProperly(objekt)
                FreezeEntityPosition(objekt, true)
                table.insert(coordsplantse, objekt)
                spawnedcarrotplants = spawnedcarrotplants + 1
            end
        )
    end
end

-- Generate Coords
function GenerateCoords()
    while true do
        Citizen.Wait(1)

        local coordx, coordy

        math.randomseed(GetGameTimer())

        local modificationx = math.random(-90, 90)

        Citizen.Wait(100)

        math.randomseed(GetGameTimer())
        local modificationy = math.random(-90, 90)

        coordx = SevenConfig.locations.potato.x + modificationx
        coordy = SevenConfig.locations.potato.y + modificationy

        local coordz = GetCoordZ(coordx, coordy)

        local realcoord = vector3(coordx, coordy, coordz)

        if ValidatefarmCoord(realcoord) then
            return realcoord
        end
    end
end

-- Checking the Z coord

function GetCoordZ(x, y)
    local groundCheckHeights = {48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0}

    for i, height in ipairs(groundCheckHeights) do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

        if foundGround then
            return z
        end
    end

    return 43.0
end

-- Must Valide the Coord z

function ValidatefarmCoord(plantCoord)
    if spawnedcarrotplants > 0 then
        local validate = true

        for k, v in pairs(coordsplantse) do
            if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
                validate = false
            end
        end

        if GetDistanceBetweenCoords(plantCoord, SevenConfig.locations.potato, false) > 60 then
            validate = false
        end

        return validate
    else
        return true
    end
end
