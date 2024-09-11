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

local spawnedkoks = 0
local coordsplantse = {}
local nearbyObject, nearbyID

Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        while true do
            Citizen.Wait(4)
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
                    TriggerEvent("sevenliferp:startnui", "Drücke E um Kokain zu sammeln", "System-Nachricht", true)
                    if IsControlJustPressed(0, 38) then
                        inaction = true
                        local random = 2
                        local weight = random * 2
                        TriggerEvent("sevenliferp:closenotify", false)
                        ESX.TriggerServerCallback(
                            "SevenLife:Drogen:HavePlayerEnoughSpace",
                            function(canPickUp)
                                if canPickUp then
                                    TaskStartScenarioInPlace(ped, "world_human_gardener_plant", 0, false)

                                    SendNUIMessage(
                                        {
                                            type = "OpenBarDrogen"
                                        }
                                    )

                                    Citizen.Wait(11000)

                                    ClearPedTasks(ped)
                                    Citizen.Wait(500)

                                    ESX.Game.DeleteObject(nearbyObject)
                                    table.remove(coordsplantse, nearbyID)
                                    spawnedkoks = spawnedkoks - 1

                                    inaction = false
                                    nearbyObject = false
                                    TriggerServerEvent("SevenLife:Koks:GivePlayerItems", random)
                                    TriggerEvent("sevenliferp:closenotify", false)
                                else
                                    inaction = false
                                    nearbyObject = false
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Kokain",
                                        "Deine Taschen sind voll",
                                        2000
                                    )
                                end
                            end,
                            weight
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

-- Spawn function
function SpanwPlantsForFarms2()
    while spawnedkoks < 15 do
        Citizen.Wait(1)
        local coordsforfarm = GenerateCoords1()

        ESX.Game.SpawnLocalObject(
            "prop_plant_cane_02b",
            coordsforfarm,
            function(objekt)
                PlaceObjectOnGroundProperly(objekt)
                FreezeEntityPosition(objekt, true)
                table.insert(coordsplantse, objekt)
                spawnedkoks = spawnedkoks + 1
            end
        )
    end
end

-- Generate Coords
function GenerateCoords1()
    while true do
        Citizen.Wait(1)

        local coordx, coordy

        math.randomseed(GetGameTimer())

        local modificationx = math.random(-10, 10)

        Citizen.Wait(100)

        math.randomseed(GetGameTimer())
        local modificationy = math.random(-10, 10)

        coordx = Config.Sammler.Koks.x + modificationx
        coordy = Config.Sammler.Koks.y + modificationy

        local coordz = GetCoordZ1(coordx, coordy)

        local realcoord = vector3(coordx, coordy, coordz)

        if ValidatefarmCoord1(realcoord) then
            return realcoord
        end
    end
end

-- Checking the Z coord

function GetCoordZ1(x, y)
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

function ValidatefarmCoord1(plantCoord)
    if spawnedkoks > 0 then
        local validate = true

        for k, v in pairs(coordsplantse) do
            if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
                validate = false
            end
        end

        if
            GetDistanceBetweenCoords(
                plantCoord,
                Config.Sammler.Koks.x,
                Config.Sammler.Koks.y,
                Config.Sammler.Koks.z,
                false
            ) > 60
         then
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

            if
                GetDistanceBetweenCoords(
                    coords,
                    Config.Sammler.Koks.x,
                    Config.Sammler.Koks.y,
                    Config.Sammler.Koks.z,
                    true
                ) < 60
             then
                SpanwPlantsForFarms2()
            end
        end
    end
)
