ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("sevenlife:checkcash")
AddEventHandler(
    "sevenlife:checkcash",
    function(cash)
        local enoughmoney
        local xplayer = ESX.GetPlayerFromId(source)
        local geldhand = xplayer.getMoney()
        local _source = source
        if geldhand < cash then
            enoughmoney = false
            local neededcash = cash - geldhand
            TriggerClientEvent("sevenlife:cashisnotenough", source, neededcash)
        else
            if geldhand >= cash then
                xplayer.removeMoney(cash)
                enoughmoney = true
                TriggerClientEvent("sevenlife:lieferung", source)
                local identifier = xplayer.identifier
                local check =
                    MySQL.Sync.fetchAll(
                    "SELECT * FROM battlepassmissionen WHERE identifier = @identifier",
                    {
                        ["@identifier"] = identifier
                    }
                )
                if check[1] ~= nil then
                    if tonumber(check[1].index3) == 2 then
                        TriggerEvent("SevenLife:SeasonPass:MakeProgress", 3, true, _source)
                    end
                end
            end
        end
    end
)
RegisterServerEvent("sevenlife:giveblackweapon")
AddEventHandler(
    "sevenlife:giveblackweapon",
    function(wichweapon)
        local xplayer = ESX.GetPlayerFromId(source)
        print("dhdh hsada")
        if wichweapon == "1" then
            xplayer.addWeapon("WEAPON_PISTOL", 30)
        else
            if wichweapon == "2" then
                print("dhdh h")
                xplayer.addWeapon("WEAPON_HEAVYPISTOL", 30)
            else
                if wichweapon == "3" then
                    xplayer.addWeapon("WEAPON_ASSAULTRIFLE", 30)
                end
            end
        end
    end
)
