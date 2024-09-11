ESX.RegisterServerCallback(
    "SevenLife:Casino:CheckIfEnoughMoney",
    function(source, cb, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        local price = tonumber(amount) * tonumber(Config.ChipsPrice)
        if money >= price then
            cb(true)
            xPlayer.removeAccountMoney("money", price)
        else
            cb(false)
        end
    end
)
RegisterServerEvent("SevenLife:Casino:GiveChips")
AddEventHandler(
    "SevenLife:Casino:GiveChips",
    function(Inputt)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("casino_chips", Inputt)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Casino:CheckIfEnoughChips",
    function(source, cb, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        local amountofchips = xPlayer.getInventoryItem("casino_chips").count
        if amountofchips >= tonumber(amount) then
            cb(true)
        else
            cb(false)
        end
    end
)
RegisterServerEvent("SevenLife:Casino:GiveMoney")
AddEventHandler(
    "SevenLife:Casino:GiveMoney",
    function(Inputt)
        local Inputt = tonumber(Inputt)
        local xPlayer = ESX.GetPlayerFromId(source)
        local endmoney = Inputt * 10
        xPlayer.addAccountMoney("money", endmoney)
        xPlayer.removeInventoryItem("casino_chips", Inputt)
    end
)
