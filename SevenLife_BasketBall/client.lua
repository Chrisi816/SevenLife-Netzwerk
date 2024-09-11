local notifys = true
local isNearExersices = false
local isAtExersice = false
local IsInMatch = false
local typeoflocation
local inMenu = false
local help = false
basketball = nil
tasks = {}
Citizen.CreateThread(
    function()
        for k, v in ipairs(Config.BaskeBallMeannnerStanding) do
            if v.type ~= "Gefeangnis" then
                BlipBasketBall(v.x, v.y, v.z)
            end
        end
    end
)
function BlipBasketBall(x, y, z)
    local blips = vector3(x, y, z)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 486)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 9)
    SetBlipScale(blip1, 0.9)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Basketball")
    EndTextCommandSetBlipName(blip1)
end
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(250)

            for k, v in pairs(Config.BaskeBallMeannnerStanding) do
                local coords = GetEntityCoords(GetPlayerPed(-1), false)
                local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z)
                if distance < 20.0 then
                    isNearExersices = true

                    typeoflocation = v.type
                elseif distance >= 20.1 and distance <= 30.0 then
                    isNearExersices = false
                    Citizen.Wait(1000)
                end

                if distance < 1 then
                    isAtExersice = true

                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um mit dem Baskeball Manager zu sprechen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.1 and distance <= 10 then
                        isAtExersice = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(6)
            if isNearExersices then
                if isAtExersice then
                    if IsControlJustPressed(0, 38) then
                        if not inMenu then
                            notifys = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            if not IsInMatch then
                                SetNuiFocus(true, true)

                                SendNUIMessage(
                                    {
                                        type = "OpenMenuStartMatch"
                                    }
                                )
                            else
                                SetNuiFocus(true, true)
                                SendNUIMessage(
                                    {
                                        type = "OpenMenuCancelMatch"
                                    }
                                )
                            end
                        end
                    end
                end
            else
                Citizen.Wait(300)
            end
        end
    end
)

local pedloaded = false
local pedarea = false

Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            for k, v in pairs(Config.BaskeBallMeannnerStanding) do
                local distance = GetDistanceBetweenCoords(PlayerCoord, v.x, v.y, v.z, true)
                Citizen.Wait(500)
                if distance < 10 then
                    pedarea = true
                    ped = GetHashKey(v.npc)
                    if not pedloaded then
                        RequestModel(ped)
                        while not HasModelLoaded(ped) do
                            Citizen.Wait(1)
                        end
                        Ped1 = CreatePed(4, ped, v.x, v.y, v.z, v.heading, false, true)
                        SetEntityInvincible(Ped1, true)
                        FreezeEntityPosition(Ped1, true)
                        SetBlockingOfNonTemporaryEvents(Ped1, true)
                        TaskPlayAnim(Ped1, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                        pedloaded = true
                    end
                else
                    if distance >= 10.1 and distance <= 20 then
                        pedarea = false
                        entity = nil
                    end
                end

                if pedloaded and not pedarea then
                    DeleteEntity(Ped1)
                    SetModelAsNoLongerNeeded(ped)
                    pedloaded = false
                end
            end
            Citizen.Wait(1500)
        end
    end
)
RegisterNUICallback(
    "escape",
    function()
        inMenu = false
        notifys = true
        SetNuiFocus(false, false)
    end
)
entity = nil
RegisterNUICallback(
    "StartMatchBaskeball",
    function()
        SendNUIMessage(
            {
                type = "OpenHelpButtons"
            }
        )
        help = true
        notifys = true
        for k, v in pairs(Config.SpawnPlaces) do
            if v.type == typeoflocation then
                print(typeoflocation)
                if entity == nil then
                    entity = CreateObject(GetHashKey("prop_bskball_01"), v.x, v.y, v.z, true, true, true)
                    SetEntityVelocity(entity, 0.0001, 0.0, 0.0)
                    SetEntityAsMissionEntity(entity, true, true)
                end
            end
        end
    end
)
RegisterNUICallback(
    "deleteclosematch",
    function()
        notifys = true
        DeleteEntity(entity)
    end
)

function PickupBasketball(entity)
    NetworkRequestControlOfEntity(entity)
    while (NetworkGetEntityOwner(entity) ~= PlayerId()) and (NetworkGetEntityOwner(entity) ~= -1) do
        Citizen.Wait(0)
    end
    LoadAnim("anim@mp_snowball")
    TaskPlayAnim(PlayerPedId(), "anim@mp_snowball", "pickup_snowball", 8.0, 8.0, -1, 32, 1, false, false, false)
    Citizen.Wait(150)
    AttachEntityToEntity(
        entity,
        PlayerPedId(),
        GetPedBoneIndex(PlayerPedId(), 28422),
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        true,
        true,
        true,
        false,
        0.0,
        true
    )
    basketball = entity
    SetEntityAsMissionEntity(entity, true, true)
    Citizen.Wait(1500)
    ClearPedTasksImmediately(PlayerPedId())
end

function DetachBasketball()
    DetachEntity(basketball)
    basketball = nil
    tasks = {}
end

function LoadAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    return true
end

Citizen.CreateThread(
    function()
        while true do
            if basketball and tasks.isDribbling then
                local playerPed = PlayerPedId()
                if IsPedWalking(playerPed) or IsPedRunning(playerPed) then
                    DetachEntity(basketball)
                    local forwardX = GetEntityForwardX(playerPed)
                    local forwardY = GetEntityForwardY(playerPed)
                    SetEntityVelocity(basketball, forwardX * 2, forwardY * 2, -3.8)
                    Citizen.Wait(300)
                    forwardX = GetEntityForwardX(playerPed)
                    forwardY = GetEntityForwardY(playerPed)
                    SetEntityVelocity(basketball, forwardX * 1.9, forwardY * 1.9, 4.0)
                    Citizen.Wait(450)
                    AttachEntityToEntity(
                        basketball,
                        playerPed,
                        GetPedBoneIndex(playerPed, 28422),
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        true,
                        true,
                        true,
                        false,
                        0.0,
                        true
                    )
                elseif IsPedSprinting(playerPed) then
                    DetachEntity(basketball)
                    local forwardX = GetEntityForwardX(playerPed)
                    local forwardY = GetEntityForwardY(playerPed)
                    SetEntityVelocity(basketball, forwardX * 9, forwardY * 9, -10.0)
                    Citizen.Wait(200)
                    forwardX = GetEntityForwardX(playerPed)
                    forwardY = GetEntityForwardY(playerPed)
                    SetEntityVelocity(basketball, forwardX * 8, forwardY * 8, 3.0)
                    Citizen.Wait(300)
                    AttachEntityToEntity(
                        basketball,
                        playerPed,
                        GetPedBoneIndex(playerPed, 28422),
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        true,
                        true,
                        true,
                        false,
                        0.0,
                        true
                    )
                else
                    DetachEntity(basketball)
                    SetEntityVelocity(basketball, 0.0, 0.0, -3.8)
                    Citizen.Wait(250)
                    SetEntityVelocity(basketball, 0, 0, 4.0)
                    Citizen.Wait(450)
                    AttachEntityToEntity(
                        basketball,
                        playerPed,
                        GetPedBoneIndex(playerPed, 28422),
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        true,
                        true,
                        true,
                        false,
                        0.0,
                        true
                    )
                end
            end
            Citizen.Wait(1)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if IsControlJustReleased(0, 38) then
                if not basketball then
                    local closestEntity, closestEntityDistance =
                        GetClosestObjectOfType(
                        GetEntityCoords(PlayerPedId()),
                        1.5,
                        GetHashKey("prop_bskball_01"),
                        false,
                        false,
                        false
                    )
                    local closestEntityDistance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(closestEntity))
                    if GetEntityModel(closestEntity) == GetHashKey("prop_bskball_01") and closestEntityDistance <= 1.5 then
                        PickupBasketball(closestEntity)
                    end
                end
            end
            if IsControlJustReleased(0, 303) then
                if basketball then
                    if not tasks.isRolling then
                        tasks.isRolling = true
                        LoadAnim("amb@world_human_mobile_film_shocking@male@base")
                        TaskPlayAnim(
                            PlayerPedId(),
                            "amb@world_human_mobile_film_shocking@male@base",
                            "base",
                            8.0,
                            8.0,
                            -1,
                            51,
                            0,
                            false,
                            false,
                            false
                        )
                        local ballRotation = 0.0
                        Citizen.CreateThread(
                            function()
                                while tasks.isRolling do
                                    if ballRotation > 360 then
                                        ballRotation = 0.0
                                        AttachEntityToEntity(
                                            basketball,
                                            PlayerPedId(),
                                            GetPedBoneIndex(PlayerPedId(), 28422),
                                            0.0,
                                            0.0,
                                            0.0,
                                            0.0,
                                            0.0,
                                            0.0,
                                            true,
                                            true,
                                            true,
                                            false,
                                            0.0,
                                            false
                                        )
                                    else
                                        ballRotation = ballRotation + 60
                                        AttachEntityToEntity(
                                            basketball,
                                            PlayerPedId(),
                                            GetPedBoneIndex(PlayerPedId(), 28422),
                                            0.0,
                                            0.0,
                                            0.0,
                                            0.0,
                                            0.0,
                                            ballRotation,
                                            true,
                                            true,
                                            true,
                                            false,
                                            0.0,
                                            false
                                        )
                                    end
                                    Citizen.Wait(0)
                                end
                            end
                        )
                        Citizen.CreateThread(
                            function()
                                Citizen.Wait(12000)
                                if tasks.isRolling then
                                    DetachBasketball()
                                    tasks.isRolling = false
                                end
                            end
                        )
                    else
                        ClearPedTasks(PlayerPedId())
                        tasks.isRolling = false
                    end
                end
            end
            if IsDisabledControlPressed(0, 263) then
                if basketball then
                    if not tasks.normalShootForce then
                        tasks.normalShootForce = 0.1
                    end
                    if tasks.normalShootForce < 2 then
                        tasks.normalShootForce = tasks.normalShootForce + 0.05
                    end
                end
            end
            if IsDisabledControlJustReleased(0, 263) then
                if basketball then
                    if not tasks.isShooting then
                        tasks.isShooting = true
                        LoadAnim("amb@prop_human_movie_bulb@exit")
                        ClearPedTasksImmediately(PlayerPedId())
                        local forwardX = GetEntityForwardX(PlayerPedId())
                        local forwardY = GetEntityForwardY(PlayerPedId())
                        DetachEntity(basketball)
                        SetEntityVelocity(
                            basketball,
                            forwardX * (tasks.normalShootForce * 10),
                            forwardY * (tasks.normalShootForce * 10),
                            tasks.normalShootForce * 10
                        )
                        basketball = nil
                        TaskPlayAnim(
                            PlayerPedId(),
                            "amb@prop_human_movie_bulb@exit",
                            "exit",
                            8.0,
                            8.0,
                            -1,
                            48,
                            1,
                            false,
                            false,
                            false
                        )

                        Citizen.Wait(1000)
                        ClearPedTasks(PlayerPedId())
                        tasks.isShooting = false
                        tasks.normalShootForce = 0.1
                        tasks.isDribbling = false
                    end
                end
            end
            if IsControlPressed(0, 44) then
                if basketball and not tasks.isDribbling then
                    LoadAnim("anim@move_m@trash")
                    TaskPlayAnim(PlayerPedId(), "anim@move_m@trash", "walk", 8.0, 8.0, -1, 51, 1, false, false, false)
                    tasks.isDribbling = true
                end
            else
                if basketball and tasks.isDribbling then
                    tasks.isDribbling = false
                    StopAnimTask(PlayerPedId(), "anim@move_m@trash", "walk", 51)
                    ClearPedTasksImmediately(PlayerPedId())
                end
            end
            if IsControlJustReleased(0, 73) then
                if basketball then
                    DetachBasketball()
                end
            end
            if basketball then
                DisableControlAction(0, 263, true)
                DisableControlAction(0, 264, true)
                DisableControlAction(0, 257, true)
                DisableControlAction(0, 140, true)
            end
            if help then
                if IsControlJustPressed(0, 73) then
                    SendNUIMessage(
                        {
                            type = "RemoveHelpButtons"
                        }
                    )
                    help = false
                end
            end
            Citizen.Wait(1)
        end
    end
)
