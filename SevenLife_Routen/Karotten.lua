local Plants = {}
local spawnedcarrotplants = 0
local inaction = false
local nears = false
local nearbyObject, nearbyID
function SpanwPlantsForFarmKarotte()
    while spawnedcarrotplants < 50 do
        Citizen.Wait(1)
        local coordsforfarm = GenerateCoordsKarotte()

        ESX.Game.SpawnLocalObject(
            "prop_plant_fern_02a",
            coordsforfarm,
            function(objekt)
                PlaceObjectOnGroundProperly(objekt)
                FreezeEntityPosition(objekt, true)
                table.insert(Plants, objekt)
                spawnedcarrotplants = spawnedcarrotplants + 1
            end
        )
    end
end

-- Generate Coords
function GenerateCoordsKarotte()
    while true do
        Citizen.Wait(1)

        local coordx, coordy

        math.randomseed(GetGameTimer())

        local modificationx = math.random(-90, 90)

        Citizen.Wait(100)

        math.randomseed(GetGameTimer())
        local modificationy = math.random(-90, 90)

        coordx = Config.Karotte.x + modificationx
        coordy = Config.Karotte.y + modificationy

        local coordz = GetCoordZPlants(coordx, coordy)

        local realcoord = vector3(coordx, coordy, coordz)

        if ValidatefarmCoordPlants(realcoord) then
            return realcoord
        end
    end
end

-- Checking the Z coord

function GetCoordZPlants(x, y)
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

function ValidatefarmCoordPlants(plantCoord)
    if spawnedcarrotplants > 0 then
        local validate = true

        for k, v in pairs(Plants) do
            if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
                validate = false
            end
        end

        if GetDistanceBetweenCoords(plantCoord, Config.Karotte.x, Config.Karotte.y, Config.Karotte.z, false) > 30 then
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
            local distance =
                GetDistanceBetweenCoords(coords, Config.Karotte.x, Config.Karotte.y, Config.Karotte.z, true)
            if distance < 60 then
                nears = true
                SpanwPlantsForFarmKarotte()
            else
                nears = false
                for k, v in pairs(Plants) do
                    ESX.Game.DeleteObject(v)
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        while true do
            Citizen.Wait(5)
            if nears then
                local ped = PlayerPedId()
                local coordofped = GetEntityCoords(ped)

                for i = 1, #Plants, 1 do
                    if GetDistanceBetweenCoords(coordofped, GetEntityCoords(Plants[i]), true) < 2 then
                        nearbyObject, nearbyID = Plants[i], i
                        coord = GetEntityCoords(Plants[i])
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
                            "Drücke E um Karotten zu sammeln",
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
                                                type = "OpenKarottenFarmen"
                                            }
                                        )
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
            else
                Citizen.Wait(200)
            end
        end
    end
)
RegisterNUICallback(
    "GiveKarotten",
    function()
        SetNuiFocus(false, false)
        SendNUIMessage(
            {
                type = "OpenKarottenNUI"
            }
        )
        Citizen.Wait(11000)
        TriggerServerEvent("SevenLife:Routen:GiveItem", "karotten", 3)
        local ped = GetPlayerPed(-1)
        ClearPedTasks(ped)
        ESX.Game.DeleteObject(nearbyObject)
        table.remove(Plants, nearbyID)
        spawnedcarrotplants = spawnedcarrotplants - 1

        inaction = false
        nearbyObject = false
        TriggerEvent("sevenliferp:closenotify", false)
    end
)
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
