-- Variables

ESX = nil
local searchped = {}
local leatherToGive = nil
local cam = nil
local animalsSpawnedCount = 0
local pedCoords = 0
local animalModels = {}
local notifys = true
-- Core
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
        for k, v in pairs(SevenConfig.HuntingPoints) do
            AddHuntingBlipOnMap(v.x, v.y, v.z)
        end
    end
)

-- Hashes
WeaponHashGroups = {
    [-1609580060] = "unarmed",
    [-728555052] = "melee",
    [416676503] = "pistol",
    [-957766203] = "subgun",
    [860033945] = "shootgun",
    [970310034] = "rifle",
    [-1212426201] = "snip"
}

-- Blips
function AddHuntingBlipOnMap(coordsx, coordsy, coordsz)
    local blips = vector3(coordsx, coordsy, coordsz)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 442)
    SetBlipColour(blip1, 48)
    SetBlipDisplay(blip1, 4)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Jagd revier")
    EndTextCommandSetBlipName(blip1)
end

-- Spawn Animal
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)
            IsPedNear = ESX.Game.GetPeds()
            for i = 1, #IsPedNear, 1 do
                if IsEntityAPed(IsPedNear[i]) and not IsPedAPlayer(IsPedNear[i]) and not IsPedHuman(IsPedNear[i]) then
                    if (getDistance(IsPedNear[i]) < 50) then
                        if not animalExists(IsPedNear[i]) and animalModelExists(IsPedNear[i]) then
                            table.insert(searchped, IsPedNear[i])
                        end
                    end
                end
            end
        end
    end
)
-- Check if near animal
function IsPlayerNearAnimal(dist, ped, i)
    local player = PlayerPedId(-1)
    if IsControlJustPressed(0, 38) then
        local model = GetEntityModel(ped)
        local animal = getAnimalMatch(model)
        if GetPedSourceOfDeath(ped) == player then
            HarvestAnimal(ped, animal, i)
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Tier", "Du hast dieses Tier noch nicht getötet", 2000)
        end
    end
end
-- Check if player have Knife
function HasPlayerKnife()
    local player = PlayerPedId(-1)
    for i, knife in pairs(SevenConfig.AvailebleKnifes) do
        if GetHashKey(knife) == GetSelectedPedWeapon(player) then
            return true
        end
    end
    return false
end

-- Harvest Animal
function HarvestAnimal(ped, model, i)
    local player = PlayerPedId(-1)

    if HasPlayerKnife() then
        notifys = false
        TriggerEvent("sevenliferp:closenotify", false)
        for k, v in pairs(SevenConfig.AnimalsInfo) do
            if v.model == model then
                specialItem = v.specialItem
                dimension = v.dimension
                bad = v.bad
                good = v.good
                perfect = v.perfect
            end
        end
        local a, b = GetPedLastDamageBone(ped)

        if b == 31086 then
            WasPedShootedInHead = true
        else
            WasPedShootedInHead = false
        end
        local groupH = GetWeapontypeGroup(GetPedCauseOfDeath(ped))
        local groupName = WeaponHashGroups[groupH]
        for k, v in pairs(SevenConfig.WeaponDamages) do
            if v.category == groupName then
                LederDimension(v.small, v.medium, v.medBig, v.big)
            end
        end
        local r = math.random(1, 2)
        if leatherToGive ~= nil and groupName ~= nil then
            SetCurrentPedWeapon(player, -1569615261, true)
            ensureAnimDict("amb@medic@standing@kneel@base")
            TaskPlayAnim(player, "amb@medic@standing@kneel@base", "base", 1.0, -1.0, -1, 1, 0, false, false, false)
            ensureAnimDict("anim@gangops@facility@servers@bodysearch@")
            TaskPlayAnim(
                player,
                "anim@gangops@facility@servers@bodysearch@",
                "player_search",
                1.0,
                -1.0,
                -1,
                1,
                0,
                false,
                false,
                false
            )
            TriggerEvent("SevenLife:TimetCustom:Notify", "Tier", "Du startest das sammeln der Güter", 2000)
            SecondProcessCamControls(ped)
            Citizen.Wait(10000)
            ClearPedTasksImmediately(player)
            TriggerEvent("SevenLife:TimetCustom:Notify", "Tier", "Du hast leder bekommen", 2000)
            local random = math.random(1, 20)
            if random >= 1 and random <= 9 then
                TriggerServerEvent("SevenLife:AnimalHunting:GiveReward", "leatherschlecht", r)
            elseif random >= 10 and random <= 19 then
                TriggerServerEvent("SevenLife:AnimalHunting:GiveReward", "leathergood", r)
            elseif random == 20 then
                TriggerServerEvent("SevenLife:AnimalHunting:GiveReward", "leatherperfekt", r)
            end

            local fleichnummer = math.random(1, 3)
            TriggerServerEvent("SevenLife:AnimalHunting:GiveReward", "rohesfleisch", fleichnummer)
            TriggerEvent("SevenLife:TimetCustom:Notify", "Tier", "Du hast rohes Fleich bekommen", 2000)
        elseif leatherToGive == nil or groupName == nil then
            TriggerEvent("SevenLife:TimetCustom:Notify", "Tier", "Das Leder ist zu stark beschädigt", 2000)
            Citizen.Wait(2000)
        end
        SetEntityCoords(ped, -7763.0, 8610.0, -100.0)
        Citizen.Wait(1000)
        deletePed(ped, i)
        Citizen.Wait(3000)
        notifys = true
    else
        TriggerEvent("SevenLife:TimetCustom:Notify", "Tier", "Du musst ein Messer in deiner Hand halten", 2000)
        Citizen.Wait(200)
    end
end

function StartAnimCam()
    ClearFocus()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, 0, 0, 0, GetGameplayCamFov())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
end

function EndAnimCam()
    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    cam = nil
end

function GetCategoryOfLether(quality)
    if quality == "bad" then
        leatherToGive = "leatherschlecht"
    elseif quality == "good" then
        leatherToGive = "leathergood"
    elseif quality == "perfect" then
        leatherToGive = "leatherperfekt"
    end
end

function ProcessCamControls(ped)
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local playerCoords = coords
    local entityCoords = GetEntityCoords(ped)
    DisableFirstPersonCamThisFrame()

    SetCamCoord(cam, entityCoords.x + 3, entityCoords.y + 3, entityCoords.z)
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.9)
end

function SecondProcessCamControls(ped)
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local playerCoords = coords
    local entityCoords = GetEntityCoords(ped)
    DisableFirstPersonCamThisFrame()

    SetCamCoord(cam, entityCoords.x, entityCoords.y, entityCoords.z + 6.0)
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z)
end

function getAnimalMatch(hash)
    for _, v in pairs(SevenConfig.AnimalsInfo) do
        if (v.hash == hash) then
            return v.model
        end
    end
end

function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(100)
        end
    end
    return animDict
end

function deletePed(entity, i)
    local model = GetEntityModel(entity)
    SetEntityAsNoLongerNeeded(entity)
    SetModelAsNoLongerNeeded(model)
    DeleteEntity(entity)
    table.remove(searchped, i)
    animalsSpawnedCount = animalsSpawnedCount - 1
end

function LederDimension(small, medium, medBig, big)
    if dimension == "small" then
        GetCategoryOfLether(small)
    elseif dimension == "medium" then
        GetCategoryOfLether(medium)
    elseif dimension == "medBig" then
        GetCategoryOfLether(medBig)
    elseif dimension == "big" then
        GetCategoryOfLether(big)
    end
end

function animalExists(entity)
    for i, ped in pairs(searchped) do
        if ped == entity then
            return true
        end
    end
    return false
end

function animalModelExists(entity)
    for i, ped in pairs(SevenConfig.AnimalsInfo) do
        if ped.hash == GetEntityModel(entity) then
            return true
        end
    end
    return false
end

Citizen.CreateThread(
    function()
        for i, animal in pairs(SevenConfig.AnimalsInfo) do
            table.insert(animalModels, animal.model)
        end
        while true do
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)
            Citizen.Wait(3000)
            local pos = coords
            local land = false
            local X, Y, ZLoc = 0

            if IsInSpawnAnimalZone(pos) then
                if animalsSpawnedCount < 50 then
                    for k, v in pairs(SevenConfig.HuntingPoints) do
                        if GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 100 then
                            X = v.x
                            Y = v.y
                            ZLoc = v.z
                        end
                    end
                    local r = math.random(1, #animalModels)
                    local pedModel = GetHashKey(animalModels[r])
                    RequestModel(pedModel)
                    while not HasModelLoaded(pedModel) or not HasCollisionForModelLoaded(pedModel) do
                        Citizen.Wait(100)
                    end
                    posX = X + math.random(-100, 100)
                    posY = Y + math.random(-100, 100)
                    Z = ZLoc + 999.0
                    land, posZ = GetGroundZFor_3dCoord(posX + .0, posY + .0, Z, 1)
                    if land then
                        entity = CreatePed(5, pedModel, posX, posY, posZ, 0.0, true, false)
                        animalsSpawnedCount = animalsSpawnedCount + 1
                        TaskWanderStandard(entity, true, true)
                        SetEntityAsMissionEntity(entity, true, true)
                        table.insert(searchped, entity)
                    end
                end
            else
                for i, entity in pairs(searchped) do
                    deletePed(entity, i)
                end
                animalsSpawnedCount = 0
            end

            for i, entity in pairs(searchped) do
                if IsEntityInWater(entity) then
                    deletePed(entity, i)
                end
            end
        end
    end
)

function IsInSpawnAnimalZone(coords)
    for k, v in pairs(SevenConfig.HuntingPoints) do
        if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 100 then
            return true
        end
    end
    return false
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(7)
            local player = PlayerPedId(-1)
            for i = 1, #searchped, 1 do
                local ped = searchped[i]

                local distancePedPlayer = getDistance(ped)

                if distancePedPlayer < 1.5 and not IsPedInAnyVehicle(player, false) and IsPedDeadOrDying(ped, true) then
                    if IsInSpawnAnimalZone(pedCoords) then
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um zu ernten",
                                "System - Nachricht",
                                true
                            )
                        end
                        IsPlayerNearAnimal(distancePedPlayer, ped, i)
                    end
                else
                    if distancePedPlayer >= 1.6 and distancePedPlayer <= 3 then
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    end
)

function getDistance(pedToGetCoords)
    pedCoords = GetEntityCoords(pedToGetCoords, true)
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, pedCoords.x, pedCoords.y, pedCoords.z)
    return dist
end
RegisterNetEvent("SevenLife:AnimalHunting:onfleisch")
AddEventHandler(
    "SevenLife:AnimalHunting:onfleisch",
    function(prop_name)
        if not IsAnimated then
            prop_name = "prop_cs_steak"
            IsAnimated = true

            CreateThread(
                function()
                    local playerPed = PlayerPedId()
                    local x, y, z = table.unpack(GetEntityCoords(playerPed))
                    local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
                    local boneIndex = GetPedBoneIndex(playerPed, 18905)
                    AttachEntityToEntity(
                        prop,
                        playerPed,
                        boneIndex,
                        0.12,
                        0.028,
                        0.001,
                        10.0,
                        175.0,
                        0.0,
                        true,
                        true,
                        false,
                        true,
                        1,
                        true
                    )

                    ESX.Streaming.RequestAnimDict(
                        "mp_player_inteat@burger",
                        function()
                            TaskPlayAnim(
                                playerPed,
                                "mp_player_inteat@burger",
                                "mp_player_int_eat_burger_fp",
                                8.0,
                                -8,
                                -1,
                                49,
                                0,
                                0,
                                0,
                                0
                            )

                            Wait(3000)
                            IsAnimated = false
                            ClearPedSecondaryTask(playerPed)
                            DeleteObject(prop)
                        end
                    )
                end
            )
        end
    end
)
