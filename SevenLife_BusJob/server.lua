ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:Mission:Pay")
AddEventHandler(
    "SevenLife:Mission:Pay",
    function(beschwerden)
        local xPlayer = ESX.GetPlayerFromId(source)
        local beschwerden = beschwerden + 1
        local lohn = 100 / beschwerden
        xPlayer.addAccountMoney("money", lohn)
        TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Bus job", "Du hast " .. lohn .. "$ bekommen!", 2000)
    end
)
