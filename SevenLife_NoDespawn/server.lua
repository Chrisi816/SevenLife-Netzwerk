ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

local vehicles = {}

RegisterServerEvent("SevenLive:NODS:UpdateCarID")
AddEventHandler(
    "SevenLive:NODS:UpdateCarID",
    function(oldId, newId)
        for i = 1, #vehicles, 1 do
            if vehicles[i].id == oldId then
                vehicles[i].id = newId
            end
        end
    end
)

function InsertIntoTable(index, id, model, x, y, z, heading, props)
    vehicles[index] = {
        ["id"] = id,
        ["model"] = model,
        ["position"] = {
            ["x"] = x,
            ["y"] = y,
            ["z"] = z
        },
        ["heading"] = heading,
        ["props"] = props
    }
end

RegisterServerEvent("SevenLife:NODS:SaveVehicle")
AddEventHandler(
    "SevenLife:NODS:SaveVehicle",
    function(id, model, x, y, z, heading, props)
        if vehicles[1] ~= nil then
            for i = 1, #vehicles, 1 do
                if vehicles[i].id == id then
                    InsertIntoTable(i, id, model, x, y, z, heading, props)
                elseif i == #vehicles then
                    InsertIntoTable(#vehicles + 1, id, model, x, y, z, heading, props)
                end
            end
        else
            InsertIntoTable(#vehicles + 1, id, model, x, y, z, heading, props)
        end
    end
)

RegisterServerEvent("SevenLife:NODS:GetContent")
AddEventHandler(
    "SevenLife:NODS:GetContent",
    function()
        TriggerClientEvent("SevenLife:NODS:InsertTable", GetPlayers()[1], vehicles)
    end
)
