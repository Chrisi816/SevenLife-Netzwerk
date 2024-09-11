ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterUsableItem(
    "rasierer",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local number = math.random(1, 100)
        if number <= 5 then
            xPlayer.removeInventoryItem("rasierer", 1)
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Rasierer",
                "Dein Rasierer ist gerade kaputt gegangen",
                2000
            )
        end
        TriggerClientEvent("SevenLife:Beard:Shave", source)
    end
)
