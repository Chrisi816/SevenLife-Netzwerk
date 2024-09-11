ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:Bauern:BuyItem")
AddEventHandler(
    "SevenLife:Bauern:BuyItem",
    function(label, preis)
        local preis = tonumber(preis)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        if tonumber(money) >= preis then
            xPlayer.removeAccountMoney("money", preis)
            xPlayer.addInventoryItem(label, 1)
            local moneys = xPlayer.getMoney()
            TriggerClientEvent("SevenLife:Bauern:Geld", source, moneys)
        end
        local _source = source
        local identifier = xPlayer.identifier
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM battlepassmissionen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )

        if check[1] ~= nil then
            if tonumber(check[1].index3) == 3 then
                TriggerEvent("SevenLife:SeasonPass:MakeProgress", 3, true, _source, 1, 10)
            end
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Bauern:GetMoney",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local moneys = xPlayer.getMoney()
        cb(moneys)
    end
)
ESX.RegisterUsableItem(
    "apfel",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("apfel", 1)
        TriggerClientEvent("esx_status:add", source, "hunger", 50000)
        TriggerClientEvent("esx_status:add", source, "thirst", 5000)
        TriggerClientEvent("esx_basicneeds:onEat", source, "sf_prop_sf_apple_01a")
    end
)
ESX.RegisterUsableItem(
    "banane",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("banane", 1)
        TriggerClientEvent("esx_status:add", source, "hunger", 50000)
        TriggerClientEvent("esx_status:add", source, "thirst", 5000)
        TriggerClientEvent("esx_basicneeds:onEat", source, "v_res_tre_banana")
    end
)
ESX.RegisterUsableItem(
    "birne",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("birne", 1)
        TriggerClientEvent("esx_status:add", source, "hunger", 50000)
        TriggerClientEvent("esx_status:add", source, "thirst", 5000)
        TriggerClientEvent("esx_basicneeds:onEat", source, "v_res_tre_banana")
    end
)
ESX.RegisterUsableItem(
    "brombeeren",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("brombeeren", 1)
        TriggerClientEvent("esx_status:add", source, "hunger", 50000)
        TriggerClientEvent("esx_status:add", source, "thirst", 5000)
        TriggerClientEvent("esx_basicneeds:onEat", source, "v_res_tre_banana")
    end
)
ESX.RegisterUsableItem(
    "erdbeeren",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("erdbeeren", 1)
        TriggerClientEvent("esx_status:add", source, "hunger", 50000)
        TriggerClientEvent("esx_status:add", source, "thirst", 5000)
        TriggerClientEvent("esx_basicneeds:onEat", source, "v_res_tre_banana")
    end
)
ESX.RegisterUsableItem(
    "heidelbeeren",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("heidelbeeren", 1)
        TriggerClientEvent("esx_status:add", source, "hunger", 50000)
        TriggerClientEvent("esx_status:add", source, "thirst", 5000)
        TriggerClientEvent("esx_basicneeds:onEat", source, "v_res_tre_banana")
    end
)
