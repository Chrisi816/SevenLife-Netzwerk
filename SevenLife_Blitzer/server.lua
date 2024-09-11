ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:Blitzer:MakeBill")
AddEventHandler(
    "SevenLife:Blitzer:MakeBill",
    function(fine)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local amount = tonumber(fine)

        if xPlayer ~= nil then
            MySQL.Async.execute(
                "INSERT INTO bill_options (identifier, title, reason, price, stand, firma) VALUES (@identifier, @title, @reason, @price, @stand, @firma)",
                {
                    ["@identifier"] = xPlayer.identifier,
                    ["@title"] = "Überschreitung",
                    ["@reason"] = "Zu schnell gefahren",
                    ["@price"] = amount,
                    ["@stand"] = "notpaid",
                    ["@firma"] = "police"
                },
                function()
                end
            )
        end
    end
)
