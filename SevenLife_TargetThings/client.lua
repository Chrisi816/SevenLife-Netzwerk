local Models = {}
local Zones = {}

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

        PlayerJob = ESX.GetPlayerData().job

        RegisterNetEvent("esx:setJob")
        AddEventHandler(
            "esx:setJob",
            function(job)
                PlayerJob = job
            end
        )
    end
)
Citizen.CreateThread(
    function()
        local mstime = 250
        while true do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1))
            local hit, coords, entity = RayCastGamePlayCamera(20.0)

            if hit == 1 then
                if GetEntityType(entity) ~= 0 then
                    for key, model in pairs(Models) do
                        if key == GetEntityModel(entity) then
                            if GetDistanceBetweenCoords(plyCoords, coords, true) <= 4.0 then
                                active = true
                                SendNUIMessage(
                                    {
                                        type = "OpenTarget2"
                                    }
                                )
                                for k, v in ipairs(Models[key]["job"]) do
                                    if v == "all" or v == PlayerJob.name then
                                        mstime = 5

                                        if GetDistanceBetweenCoords(plyCoords, coords, true) <= Models[key]["distance"] then
                                            SendNUIMessage(
                                                {
                                                    type = "OpenTarget",
                                                    data = Models[key]["options"]
                                                }
                                            )
                                            success = true

                                            while success and targetActive do
                                                local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                                                local hit, coords, entity = RayCastGamePlayCamera(20.0)

                                                DisablePlayerFiring(PlayerPedId(), true)

                                                if
                                                    (IsControlJustReleased(0, 24) or
                                                        IsDisabledControlJustReleased(0, 24))
                                                 then
                                                    SetNuiFocus(true, true)
                                                    SetCursorLocation(0.5, 0.5)
                                                end

                                                if
                                                    GetEntityType(entity) == 0 or
                                                        GetDistanceBetweenCoords(plyCoords, coords, true) >
                                                            Models[key]["distance"]
                                                 then
                                                    success = false
                                                end

                                                Citizen.Wait(1)
                                            end
                                        else
                                            SendNUIMessage(
                                                {
                                                    type = "DeleteMann2"
                                                }
                                            )
                                        end
                                    end
                                end
                            else
                                if
                                    GetDistanceBetweenCoords(plyCoords, coords, true) > 3.0 and
                                        GetDistanceBetweenCoords(plyCoords, coords, true) < 10.0
                                 then
                                    active = false
                                    SendNUIMessage(
                                        {
                                            type = "DeleteMann"
                                        }
                                    )
                                    SendNUIMessage(
                                        {
                                            type = "DeleteMann2"
                                        }
                                    )
                                end
                            end
                        else
                            active = false
                            SendNUIMessage(
                                {
                                    type = "DeleteMann2"
                                }
                            )
                        end
                    end
                end
            end

            Citizen.Wait(mstime)
        end
    end
)

RegisterNUICallback(
    "CloseTarget",
    function()
        SetNuiFocus(false, false)
        success = false
        targetActive = false
    end
)

RegisterNUICallback(
    "selectTarget",
    function(data, cb)
        SetNuiFocus(false, false)

        success = false

        targetActive = false
        SendNUIMessage(
            {
                type = "DeleteMann"
            }
        )
        SendNUIMessage(
            {
                type = "DeleteMann2"
            }
        )
        TriggerEvent(data.event)
    end
)

function AddTargetModel(models, parameteres)
    for _, model in pairs(models) do
        Models[model] = parameteres
    end
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            if IsControlPressed(0, 19) then
                SendNUIMessage(
                    {
                        type = "OpenTarget2"
                    }
                )
            else
                SendNUIMessage(
                    {
                        type = "DeleteMann"
                    }
                )
            end
            if active then
                if IsControlJustPressed(0, 38) then
                    SendNUIMessage(
                        {
                            type = "Valid"
                        }
                    )
                end
            end
        end
    end
)
