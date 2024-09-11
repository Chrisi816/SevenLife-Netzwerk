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

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        PlayerData = ESX.GetPlayerData()
    end
)
local dragStatus = {}
dragStatus.isDragged = false
local isincar = false
local IsHandcuffed = false

RegisterNetEvent("SevenLife:PD:HandCuffAction")
AddEventHandler(
    "SevenLife:PD:HandCuffAction",
    function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= nil then
            TriggerServerEvent("SevenLife:PD:Server:MakeAction", GetPlayerServerId(closestPlayer))
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Polizei", "Kein Spieler in der nähe", 3000)
        end
    end
)

RegisterNetEvent("SevenLife:PD:HandCuff")
AddEventHandler(
    "SevenLife:PD:HandCuff",
    function()
        IsHandcuffed = not IsHandcuffed
        local playerPed = PlayerPedId()
        TriggerEvent("SevenLife:PD:DeleteActions", playerPed)

        Citizen.CreateThread(
            function()
                if IsHandcuffed then
                    RequestAnimDict("mp_arresting")
                    while not HasAnimDictLoaded("mp_arresting") do
                        Citizen.Wait(100)
                    end

                    TaskPlayAnim(playerPed, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)

                    SetEnableHandcuffs(playerPed, true)
                    DisablePlayerFiring(playerPed, true)
                    SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
                    SetPedCanPlayGestureAnims(playerPed, false)
                    FreezeEntityPosition(playerPed, true)
                    DisplayRadar(false)
                else
                    ClearPedSecondaryTask(playerPed)
                    SetEnableHandcuffs(playerPed, false)
                    DisablePlayerFiring(playerPed, false)
                    SetPedCanPlayGestureAnims(playerPed, true)
                    FreezeEntityPosition(playerPed, false)
                    DisplayRadar(true)
                end
            end
        )
    end
)

RegisterNetEvent("SevenLife:PD:DeleteActions")
AddEventHandler(
    "SevenLife:PD:DeleteActions",
    function(playerPed)
        Citizen.CreateThread(
            function()
                Citizen.Wait(1)

                if IsHandcuffed then
                    DisableControlAction(0, 1, true) -- Disable pan
                    DisableControlAction(0, 2, true) -- Disable tilt
                    DisableControlAction(0, 24, true) -- Attack
                    DisableControlAction(0, 257, true) -- Attack 2
                    DisableControlAction(0, 25, true) -- Aim
                    DisableControlAction(0, 263, true) -- Melee Attack 1
                    DisableControlAction(0, 32, true) -- W
                    DisableControlAction(0, 34, true) -- A
                    DisableControlAction(0, 31, true) -- S
                    DisableControlAction(0, 30, true) -- D

                    DisableControlAction(0, 45, true) -- Reload
                    DisableControlAction(0, 22, true) -- Jump
                    DisableControlAction(0, 44, true) -- Cover
                    DisableControlAction(0, 37, true) -- Select Weapon
                    DisableControlAction(0, 23, true) -- Also 'enter'?

                    DisableControlAction(0, 288, true) -- Disable phone
                    DisableControlAction(0, 289, true) -- Inventory
                    DisableControlAction(0, 170, true) -- Animations
                    DisableControlAction(0, 167, true) -- Job

                    DisableControlAction(0, 0, true) -- Disable changing view
                    DisableControlAction(0, 26, true) -- Disable looking behind
                    DisableControlAction(0, 73, true) -- Disable clearing animation
                    DisableControlAction(2, 199, true) -- Disable pause screen

                    DisableControlAction(0, 59, true) -- Disable steering in vehicle
                    DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
                    DisableControlAction(0, 72, true) -- Disable reversing in vehicle

                    DisableControlAction(2, 36, true) -- Disable going stealth

                    DisableControlAction(0, 47, true) -- Disable weapon
                    DisableControlAction(0, 264, true) -- Disable melee
                    DisableControlAction(0, 257, true) -- Disable melee
                    DisableControlAction(0, 140, true) -- Disable melee
                    DisableControlAction(0, 141, true) -- Disable melee
                    DisableControlAction(0, 142, true) -- Disable melee
                    DisableControlAction(0, 143, true) -- Disable melee
                    DisableControlAction(0, 75, true) -- Disable exit vehicle
                    DisableControlAction(27, 75, true) -- Disable exit vehicle

                    if IsEntityPlayingAnim(playerPed, "mp_arresting", "idle", 3) ~= 1 then
                        ESX.Streaming.RequestAnimDict(
                            "mp_arresting",
                            function()
                                TaskPlayAnim(
                                    playerPed,
                                    "mp_arresting",
                                    "idle",
                                    8.0,
                                    -8,
                                    -1,
                                    49,
                                    0.0,
                                    false,
                                    false,
                                    false
                                )
                            end
                        )
                    end
                else
                    Citizen.Wait(500)
                end
            end
        )
    end
)

RegisterNetEvent("SevenLife:PD:tragen")
AddEventHandler(
    "SevenLife:PD:tragen",
    function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= nil then
            TriggerServerEvent("SevenLife:PD:Server:Tragen", GetPlayerServerId(closestPlayer))
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Polizei", "Kein Spieler in der nähe", 3000)
        end
    end
)

RegisterNetEvent("SevenLife:PD:Server:Tragen")
AddEventHandler(
    "SevenLife:PD:Server:Tragen",
    function(copId)
        if not IsHandcuffed then
            return
        end
        TriggerEvent("SevenLife:PD:TragenAktion")
        dragStatus.isDragged = not dragStatus.isDragged
        dragStatus.CopId = copId
    end
)

RegisterNetEvent("SevenLife:PD:TragenAktion")
AddEventHandler(
    "SevenLife:PD:TragenAktion",
    function()
        local targetPed

        if IsHandcuffed then
            playerPed = PlayerPedId()

            if dragStatus.isDragged then
                targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

                if not IsPedSittingInAnyVehicle(targetPed) then
                    AttachEntityToEntity(
                        playerPed,
                        targetPed,
                        11816,
                        0.54,
                        0.54,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        false,
                        false,
                        false,
                        false,
                        2,
                        true
                    )
                else
                    dragStatus.isDragged = false
                    DetachEntity(playerPed, true, false)
                end

                if IsPedDeadOrDying(targetPed, true) then
                    dragStatus.isDragged = false
                    DetachEntity(playerPed, true, false)
                end
            else
                DetachEntity(playerPed, true, false)
            end
        else
            Citizen.Wait(1000)
        end
    end
)
RegisterNetEvent("SevenLife:PD:autotragen")
AddEventHandler(
    "SevenLife:PD:autotragen",
    function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= nil then
            TriggerServerEvent("SevenLife:PD:GetVehicle", GetPlayerServerId(closestPlayer))
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Polizei", "Kein Spieler in der nähe", 3000)
        end
    end
)

RegisterNetEvent("SevenLife:PD:GetVehicle")
AddEventHandler(
    "SevenLife:PD:GetVehicle",
    function()
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        isincar = not isincar
        if not IsHandcuffed then
            return
        end
        if isincar then
            if IsAnyVehicleNearPoint(coords, 5.0) then
                local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

                if DoesEntityExist(vehicle) then
                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

                    for i = maxSeats - 1, 0, -1 do
                        if IsVehicleSeatFree(vehicle, i) then
                            freeSeat = i
                            break
                        end
                    end

                    if freeSeat then
                        TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
                        dragStatus.isDragged = false
                    end
                end
            end
        else
            if not IsPedSittingInAnyVehicle(playerPed) then
                return
            end

            local vehicle = GetVehiclePedIsIn(playerPed, false)
            TaskLeaveVehicle(playerPed, vehicle, 16)
        end
    end
)
