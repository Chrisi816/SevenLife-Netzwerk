-- ESX
local near = false

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

        coordx = Config.potato.x + modificationx
        coordy = Config.potato.y + modificationy

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

        if GetDistanceBetweenCoords(plantCoord, Config.potato.x, Config.potato.y, Config.potato.z, false) > 60 then
            validate = false
        end

        return validate
    else
        return true
    end
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(500)
            local coords = GetEntityCoords(PlayerPedId())

            if GetDistanceBetweenCoords(coords, Config.potato.x, Config.potato.y, Config.potato.z, true) < 60 then
                inarea = true
                near = true
                SpanwPlantsForFarms()
            else
                near = false
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        while true do
            Citizen.Wait(5)
            if near then
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
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um Kartoffeln zu sammeln",
                            "System-Nachricht",
                            true
                        )
                        if IsControlJustPressed(0, 38) then
                            inaction = true

                            TriggerEvent("sevenliferp:closenotify", false)
                            ESX.TriggerServerCallback(
                                "SevenLife:FarmingRouten:HavePlayerEnoughSpace",
                                function(canPickUp)
                                    if canPickUp then
                                        TaskStartScenarioInPlace(ped, "world_human_gardener_plant", 0, false)

                                        SetNuiFocus(true, true)
                                        SendNUIMessage(
                                            {
                                                type = "OpenKartoffelFarmen"
                                            }
                                        )
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
            else
                Citizen.Wait(200)
            end
        end
    end
)
RegisterNUICallback(
    "GiveKartoffeln",
    function()
        SetNuiFocus(false, false)
        SendNUIMessage(
            {
                type = "OpenKarottenNUI"
            }
        )
        Citizen.Wait(11000)
        TriggerServerEvent("SevenLife:Routen:GiveItem", "kartoffel", 3)
        local ped = GetPlayerPed(-1)
        ClearPedTasksImmediately(ped)
        ESX.Game.DeleteObject(nearbyObject)
        table.remove(coordsplantse, nearbyID)
        spawnedcarrotplants = spawnedcarrotplants - 1

        inaction = false
        nearbyObject = false
        TriggerEvent("sevenliferp:closenotify", false)
    end
)
