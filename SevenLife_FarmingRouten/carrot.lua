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

local inmarkers = false
local AllowSevenNotify = true
local inaction = false
local timebetweenchecking = 200
local spawnedcarrotplants = 0
local coordsplants = {}
local nearbyObject, nearbyID
local default = true

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(500)
            local coords = GetEntityCoords(PlayerPedId())
            local distance =
                GetDistanceBetweenCoords(
                coords,
                SevenConfig.locations.carrot.x,
                SevenConfig.locations.carrot.y,
                SevenConfig.locations.carrot.z,
                true
            )
            if distance < 60 then
                inarea = true
                SpanwPlantsForFarm2()
            else
                inarea = false
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

            for i = 1, #coordsplants, 1 do
                if GetDistanceBetweenCoords(coordofped, GetEntityCoords(coordsplants[i]), true) < 2 then
                    nearbyObject, nearbyID = coordsplants[i], i
                    coord = GetEntityCoords(coordsplants[i])
                end
            end

            local distance = GetDistanceBetweenCoords(coordofped, coord, true)
            if nearbyObject and IsPedOnFoot(ped) then
                if not inaction then
                    if distance >= 2.1 and distance <= 3 then
                        TriggerEvent("sevenliferp:closenotify", false)
                        nearbyObject = false
                    end
                    TriggerEvent("sevenliferp:startnui", "Drücke E um Karotten zu sammeln", "System-Nachricht", true)
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
                                    table.remove(coordsplants, nearbyID)
                                    spawnedcarrotplants = spawnedcarrotplants - 1

                                    inaction = false
                                    nearbyObject = false
                                    TriggerServerEvent("SevenLife:Farming:GivePlayerItem")
                                    TriggerEvent("sevenliferp:closenotify", false)
                                else
                                    TriggerEvent(
                                        "SevenLife:Carrot:Time:Notify",
                                        "Du hast in deinem Rucksack kein Platz mehr"
                                    )
                                end
                            end,
                            "karotten"
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
        inaction = false
    end
)
-- Spawn function
function SpanwPlantsForFarm2()
    while spawnedcarrotplants < 50 do
        Citizen.Wait(1)
        local coordsforfarm = GenerateCoords2()
        print(1)
        ESX.Game.SpawnLocalObject(
            "prop_plant_fern_02a",
            coordsforfarm,
            function(objekt)
                PlaceObjectOnGroundProperly(objekt)
                FreezeEntityPosition(objekt, true)
                table.insert(coordsplants, objekt)
                spawnedcarrotplants = spawnedcarrotplants + 1
            end
        )
    end
end

-- Generate Coords
function GenerateCoords2()
    while true do
        Citizen.Wait(1)

        local coordx, coordy

        math.randomseed(GetGameTimer())

        local modificationx = math.random(-90, 90)

        Citizen.Wait(100)

        math.randomseed(GetGameTimer())
        local modificationy = math.random(-90, 90)

        coordx = SevenConfig.locations.carrot.x + modificationx
        coordy = SevenConfig.locations.carrot.y + modificationy

        local coordz = GetCoordZ2(coordx, coordy)

        local realcoord = vector3(coordx, coordy, coordz)

        if ValidatefarmCoord2(realcoord) then
            return realcoord
        end
    end
end

-- Checking the Z coord

function GetCoordZ2(x, y)
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

function ValidatefarmCoord2(plantCoord)
    if spawnedcarrotplants > 0 then
        local validate = true

        for k, v in pairs(coordsplants) do
            if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
                validate = false
            end
        end

        if GetDistanceBetweenCoords(plantCoord, SevenConfig.locations.carrot, false) > 30 then
            validate = false
        end

        return validate
    else
        return true
    end
end

AddEventHandler(
    "onResourceStop",
    function(resource)
        if resource == GetCurrentResourceName() then
            for k, v in pairs(coordsplants) do
                ESX.Game.DeleteObject(v)
            end
        end
    end
)
