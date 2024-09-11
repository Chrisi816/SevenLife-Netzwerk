ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

--------------------------------------------------------------------------------------------------------------
--------------------------------------------Get Items---------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

RegisterServerEvent("SevenLife:WaffenShops:MakeWeapon")
AddEventHandler(
    "SevenLife:WaffenShops:MakeWeapon",
    function(item, price)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getAccount("money").money
        local weapon, items = xPlayer.getWeapon(item)
        print(item)
        if items then
            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Waffenladen", "Du besitzt das item schon")
        else
            if money < price then
                local diffirenz = price - money
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Waffenladen",
                    "Dir fehlen " .. diffirenz .. "$"
                )
            else
                xPlayer.removeAccountMoney("money", price)
                xPlayer.addWeapon(item, 20)
            end
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:WaffenLaden:GetLicenses",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM seven_licenses WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(results)
                if results[1] ~= nil then
                    if results[1].gunlicense == "true" then
                        cb(true)
                    else
                        cb(false)
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Waffenladen",
                            "Du brauchst eine aktive Waffen Lizenz die du bei der Polizei erworben hast",
                            2000
                        )
                    end
                else
                    cb(false)
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Waffenladen",
                        "Du brauchst eine aktive Waffen Lizenz die du bei der Polizei erworben hast",
                        2000
                    )
                end
            end
        )
    end
)
