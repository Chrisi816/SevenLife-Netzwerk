ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Item:GetPackungen",
    function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local itemcount = xPlayer.getInventoryItem(item).count
        cb(itemcount)
    end
)

RegisterServerEvent("SevenLife:Meth:GiveGeld")
AddEventHandler(
    "SevenLife:Meth:GiveGeld",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local aufpreis = math.random(1, 10)
        xPlayer.addAccountMoney("money", 100 + aufpreis)
        xPlayer.removeInventoryItem("meth_verpackt", 1)
    end
)
RegisterServerEvent("SevenLife:Koks:GiveGeld")
AddEventHandler(
    "SevenLife:Koks:GiveGeld",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local aufpreis = math.random(1, 10)
        xPlayer.addAccountMoney("money", 100 + aufpreis)
        xPlayer.removeInventoryItem("meth_verpackt", 1)
    end
)
RegisterServerEvent("SevenLife:Weed:GiveGeld")
AddEventHandler(
    "SevenLife:Weed:GiveGeld",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local aufpreis = math.random(1, 10)
        xPlayer.addAccountMoney("money", 100 + aufpreis)
        xPlayer.removeInventoryItem("meth_verpackt", 1)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Item:GetPackungenAll",
    function(source, cb, item, item2, item3)
        local xPlayer = ESX.GetPlayerFromId(source)
        local item = xPlayer.getInventoryItem(item).count
        local item2 = xPlayer.getInventoryItem(item2).count
        local item3 = xPlayer.getInventoryItem(item3).count
        cb(item, item2, item3)
    end
)
RegisterServerEvent("SevenLife:Valid:GiveGeld")
AddEventHandler(
    "SevenLife:Valid:GiveGeld",
    function(droge)
        local xPlayer = ESX.GetPlayerFromId(source)
        local count = xPlayer.getInventoryItem(droge).count

        if count >= 10 then
            xPlayer.removeInventoryItem(droge, 10)
            local money = 100 * 10
            xPlayer.addAccountMoney("money", money)
        else
            xPlayer.removeInventoryItem(droge, count)
            local money = 100 * count
            xPlayer.addAccountMoney("money", money)
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Drogen:HavePlayerEnoughSpace",
    function(source, cb, space)
        local xPlayer = ESX.GetPlayerFromId(source)
        local weightplayer = xPlayer.getWeight()
        local getWeight = exports["SevenLife_Inventory"]:GetWeight(source)

        if getWeight >= weightplayer + space then
            cb(true)
        else
            cb(false)
        end
    end
)
RegisterServerEvent("SevenLife:Weed:GivePlayerItems")
AddEventHandler(
    "SevenLife:Weed:GivePlayerItems",
    function(random)
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.addInventoryItem("weed", random)
    end
)
RegisterServerEvent("SevenLife:Koks:GivePlayerItems")
AddEventHandler(
    "SevenLife:Koks:GivePlayerItems",
    function(random)
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.addInventoryItem("koks", random)
    end
)
RegisterServerEvent("SevenLife:DrogenRouten:BucketList")
AddEventHandler(
    "SevenLife:DrogenRouten:BucketList",
    function()
        local id = 2
        SetPlayerRoutingBucket(source, id)
        SetRoutingBucketPopulationEnabled(id, false)
    end
)
RegisterServerEvent("SevenLife:DrogenRouten:BucketListReset")
AddEventHandler(
    "SevenLife:DrogenRouten:BucketListReset",
    function()
        local _source = source
        SetPlayerRoutingBucket(_source, 0)
    end
)
RegisterServerEvent("SevenLife:Meth:GetItems")
AddEventHandler(
    "SevenLife:Meth:GetItems",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("giftmüll", 1)
        xPlayer.addInventoryItem("meth", 4)
    end
)
RegisterServerEvent("SevenLife:Weed:ChangeItem")
AddEventHandler(
    "SevenLife:Weed:ChangeItem",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("gestrektesweed", 6)
    end
)
RegisterServerEvent("SevenLife:Koks:ChangeItem")
AddEventHandler(
    "SevenLife:Koks:ChangeItem",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("gestrekteskoks", 6)
    end
)
RegisterServerEvent("SevenLife:Meth:ChangeItem")
AddEventHandler(
    "SevenLife:Meth:ChangeItem",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("gestrektesmeth", 6)
    end
)
RegisterServerEvent("SevenLife:Weed:RemoveItem")
AddEventHandler(
    "SevenLife:Weed:RemoveItem",
    function(item, count)
        print(item)
        print(count)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(item, count)
    end
)
RegisterServerEvent("SevenLife:Weed:ChangeItem2")
AddEventHandler(
    "SevenLife:Weed:ChangeItem2",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("weed_verpackt", 6)
    end
)
RegisterServerEvent("SevenLife:Koks:ChangeItem2")
AddEventHandler(
    "SevenLife:Koks:ChangeItem2",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("koks_verpackt", 6)
    end
)
RegisterServerEvent("SevenLife:Meth:ChangeItem2")
AddEventHandler(
    "SevenLife:Meth:ChangeItem2",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("meth_verpackt", 6)
    end
)
