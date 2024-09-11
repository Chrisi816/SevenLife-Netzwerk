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
    end
)

function SpawnSavedVehicle(model, x, y, z, heading, props)
    RequestModel(model)

    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    local coords = vector3(x, y, z)
    ESX.Game.SpawnVehicle(
        model,
        coords,
        heading,
        function(vehicles)
            ESX.Game.SetVehicleProperties(vehicles, props)
            SetVehicleHasBeenOwnedByPlayer(vehicles, true)
            return vehicles
        end
    )
end

function SaveVehicle(vehicle)
    local model = GetEntityModel(vehicle)
    local x, y, z = table.unpack(GetEntityCoords(vehicle))
    local heading = GetEntityHeading(vehicle)
    local props = ESX.Game.GetVehicleProperties(vehicle)

    TriggerServerEvent("SevenLife:NODS:SaveVehicle", vehicle, model, x, y, z, heading, props)
end

local PlayerInVehicle = false
local vehicle = 0
Citizen.CreateThread(
    function()
        while true do
            local Ped = PlayerPedId()
            if IsPedInAnyVehicle(Ped) then
                PlayerInVehicle = true
                vehicle = GetVehiclePedIsUsing(Ped)
                SaveVehicle(vehicle)
                SetVehicleHasBeenOwnedByPlayer(vehicle, true)
            else
                if PlayerInVehicle then
                    SaveVehicle(vehicle)
                end
                PlayerInVehicle = false
            end

            Citizen.Wait(4000)
        end
    end
)

RegisterNetEvent("SevenLife:NODS:InsertTable")
AddEventHandler(
    "SevenLife:NODS:InsertTable",
    function(table)
        for i = 1, #table, 1 do
            if GetEntityModel(table[i].id) ~= table[i].model then
                local newId =
                    SpawnSavedVehicle(
                    table[i].model,
                    table[i].position.x,
                    table[i].position.y,
                    table[i].position.z,
                    table[i].heading,
                    table[i].props
                )
                TriggerServerEvent("SevenLive:NODS:UpdateCarID", table[i].id, newId)

                Citizen.Wait(100)
            end
        end
    end
)

AddEventHandler(
    "playerSpawned",
    function(spawnInfo)
        if GetNumberOfPlayers() == 1 then
            TriggerServerEvent("SevenLife:NODS:GetContent")
        end
    end
)
