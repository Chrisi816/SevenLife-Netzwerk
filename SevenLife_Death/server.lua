ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
RegisterServerEvent("SevenLife:Death:RemoveALL")
AddEventHandler(
    "SevenLife:Death:RemoveALL",
    function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        TriggerClientEvent("esx_status:add", _source, "hunger", 500000)
        TriggerClientEvent("esx_status:add", _source, "thirst", 500000)
        if xPlayer.getMoney() > 0 then
            xPlayer.removeMoney(xPlayer.getMoney())
        end

        if xPlayer.getAccount("black_money").money > 0 then
            xPlayer.setAccountMoney("black_money", 0)
        end

        for i = 1, #xPlayer.inventory, 1 do
            if xPlayer.inventory[i].count > 0 then
                xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
            end
        end

        for i = 1, #xPlayer.loadout, 1 do
            xPlayer.removeWeapon(xPlayer.loadout[i].name)
        end
    end
)
RegisterServerEvent("SevenLife:Death:WiederBeleben")
AddEventHandler(
    "SevenLife:Death:WiederBeleben",
    function(id)
        TriggerClientEvent("SevenLife:Death:WiederbelebenClient", id)
    end
)
RegisterServerEvent("SevenLife:Death:Pillen")
AddEventHandler(
    "SevenLife:Death:Pillen",
    function(id)
        TriggerClientEvent("SevenLife:Death:PillenClient", id)
    end
)
