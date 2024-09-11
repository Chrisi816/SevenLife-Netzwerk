ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

local list = {}
ESX.RegisterServerCallback(
    "SevenLife:Limbo:GetPrevious",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local itemchipcount = xPlayer.getInventoryItem("casino_chips").count
        cb(list, itemchipcount)
    end
)
RegisterServerEvent("SevenLife:Dishes:Gewonnen")
AddEventHandler(
    "SevenLife:Dishes:Gewonnen",
    function(einsatz, multi)
        local einsatz = tonumber(einsatz)

        local xPlayer = ESX.GetPlayerFromId(source)

        local endtime = einsatz * 0.5
        endtime = round(endtime)

        xPlayer.addInventoryItem("casino_chips", endtime)

        local itemchipcount2 = xPlayer.getInventoryItem("casino_chips").count
        local identifier = xPlayer.identifier
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT name FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(result)
                local listing = {}
                listing.multi = multi
                listing.name = result[1].name
                table.insert(list, listing)
                TriggerClientEvent("SevenLife:Dishes:UpdateAll", _source, itemchipcount2, list)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Dishes:Verloren")
AddEventHandler(
    "SevenLife:Dishes:Verloren",
    function(einsatz, multi)
        local einsatz = tonumber(einsatz)
        local xPlayer = ESX.GetPlayerFromId(source)

        local endtime = einsatz / 1.3

        xPlayer.removeInventoryItem("casino_chips", endtime)

        local itemchipcount2 = xPlayer.getInventoryItem("casino_chips").count
        local identifier = xPlayer.identifier
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT name FROM users WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(result)
                local listing = {}
                listing.multi = multi
                listing.name = result[1].name
                table.insert(list, listing)
                TriggerClientEvent("SevenLife:Dishes:UpdateAll", _source, itemchipcount2, list)
            end
        )
    end
)
function round(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end
