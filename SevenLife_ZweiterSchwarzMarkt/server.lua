ESX = nil
-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:SchwarzMarkt:GetData",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getAccount("money").money
        cb(money)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:SchwarzMarkt:GetMoney",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getAccount("money").money
        cb(money)
    end
)

RegisterServerEvent("SevenLife:SchwarzMarkt:GivesItem")
AddEventHandler(
    "SevenLife:SchwarzMarkt:GivesItem",
    function(preis, anzahl, name)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeAccountMoney("money", preis)
        xPlayer.addInventoryItem(name, anzahl)
    end
)

ESX.RegisterUsableItem(
    "munition19",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerClientEvent("SevenLife:Weapon:AddMuniSmall", source)
    end
)

ESX.RegisterUsableItem(
    "munition36",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        TriggerClientEvent("SevenLife:Weapon:AddMuniBig", source)
    end
)

RegisterServerEvent("SevenLife:Weapon:GiveWeaponItem")
AddEventHandler(
    "SevenLife:Weapon:GiveWeaponItem",
    function(weapon, number)
        local xPlayer = ESX.GetPlayerFromId(source)
        if weapon == "WEAPON_PISTOL" or weapon == "WEAPON_PISTOL50" then
            xPlayer.removeInventoryItem("munition19", 1)
        elseif weapon == "WEAPON_ASSAULTRIFLE" then
            xPlayer.removeInventoryItem("munition36", 1)
        elseif weapon == "WEAPON_COMBATPDW" then
            xPlayer.removeInventoryItem("pdwmunition", 1)
        end

        xPlayer.addWeaponAmmo(weapon, number)
    end
)

ESX.RegisterUsableItem(
    "taucheranzug",
    function(source)
        TriggerClientEvent("TaucherAnzugAnziehen", source)
    end
)
