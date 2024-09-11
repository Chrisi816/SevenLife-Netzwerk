-- Variables
local distance
local index
local SevenLife = {}
local ped
local CheckIfNpc = true
-- Core

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(7)
            if IsControlJustPressed(0, 75) then
                ped = PlayerPedId()
                if not IsPedInAnyVehicle(ped) then
                    local vehicle = GetVehiclePedIsTryingToEnter(ped)
                    if vehicle ~= 0 then
                        if SevenLife.CanPlayerSit(vehicle) then
                            local coords = GetEntityCoords(ped)
                            if #(coords - GetEntityCoords(vehicle)) <= 3.5 then
                                ClearPedTasks(ped)
                                ClearPedSecondaryTask(ped)
                                for i = 0, GetNumberOfVehicleDoors(vehicle), 1 do
                                    local coord = GetEntryPositionOfDoor(vehicle, i)
                                    if (IsVehicleSeatFree(vehicle, i - 1) and GetVehicleDoorLockStatus(vehicle) ~= 2) then
                                        if distance == nil then
                                            distance = #(coords - coord)
                                            index = i
                                        end
                                        if #(coords - coord) < distance then
                                            distance = #(coords - coord)
                                            index = i
                                        end
                                    end
                                end
                                if index then
                                    TaskEnterVehicle(ped, vehicle, 10000, index - 1, 1.0, 1, 0)
                                end
                                index, distance = nil, nil
                            end
                        end
                    end
                end
            end
        end
    end
)

SevenLife.CanPlayerSit = function(vehicle)
    if not CheckIfNpc then
        return true
    end
    for i = -1, 15 do
        if IsEntityAPed(GetPedInVehicleSeat(vehicle, i)) then
            return false
        end
    end
    return true
end
