ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
RegisterServerEvent("sevenlife:gettankdata")
AddEventHandler(
    "sevenlife:gettankdata",
    function(tankzahl)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM tankstellen WHERE tankstellennummer = @tankenummer",
            {
                ["@tankenummer"] = tankzahl
            },
            function(result)
                if result[1] == nil then
                    local tankenummer = tankzahl
                    local owner = "Staat"
                    local name = "Zu verkaufen"
                    local fuel = "0 Liter"
                    local wert = "Preis: 50000$"
                    local preisliter = "0 Liter"
                    local numberofowner = "~ Regierung / Unternehmen"

                    TriggerClientEvent(
                        "sevenlife:getclientdata",
                        _source,
                        tankenummer,
                        owner,
                        name,
                        fuel,
                        wert,
                        preisliter,
                        numberofowner
                    )
                else
                    local tankenummer = tankzahl
                    local owner = result[1].owner
                    local name = result[1].firmenname
                    local fuel = result[1].activefuel
                    local wert = result[1].wert
                    local preisliter = result[1].preisproliter
                    local numberofowner = result[1].numberofowner
                    TriggerClientEvent(
                        "sevenlife:getclientdata",
                        _source,
                        tankenummer,
                        owner,
                        name,
                        fuel,
                        wert,
                        preisliter,
                        numberofowner
                    )
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:fuel:gettankedata",
    function(source, cb, nummer)
        MySQL.Async.fetchAll(
            "SELECT owner,firmenname,activefuel,wert,numberofowner, preisproliter FROM tankstellen WHERE tankstellennummer = @tankenumme",
            {["@tankenumme"] = nummer},
            function(data)
                cb(data)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:fuel:getplayermoney",
    function(source, cb, nummer)
        xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        cb(money)
    end
)

RegisterServerEvent("sevenlife:fuel:pay")
AddEventHandler(
    "sevenlife:fuel:pay",
    function(price, tanke, liter)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local amount = ESX.Math.Round(price)

        if price > 0 then
            xPlayer.removeMoney(amount)
        end
        local fuel =
            MySQL.Sync.fetchAll(
            "SELECT activefuel,money FROM tankstellen WHERE tankstellennummer = @tankstellennummer",
            {
                ["@tankstellennummer"] = tanke
            }
        )
        print(tanke)
        MySQL.Async.execute(
            "UPDATE tankstellen SET activefuel = @activefuel, money = @money WHERE tankstellennummer = @tankstellennummer",
            {
                ["@activefuel"] = tonumber(fuel[1].activefuel) - tonumber(liter),
                ["@tankstellennummer"] = tanke,
                ["@money"] = tonumber(fuel[1].money) + tonumber(price)
            },
            function(resultse)
            end
        )
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
            if tonumber(check[1].index3) == 5 then
                TriggerEvent("SevenLife:SeasonPass:MakeProgress", 3, false, _source, tonumber(liter), 50)
            end
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:GetTankeInfos",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM tankstellen WHERE identifer = @identifier",
            {
                ["@identifier"] = "0"
            },
            function(result)
                if result ~= nil then
                    cb(result)
                end
            end
        )
    end
)
RegisterServerEvent("sevenlife:buytanke")
AddEventHandler(
    "sevenlife:buytanke",
    function(tankenumber)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local shop = tonumber(tankenumber)
        if shop ~= nil then
            MySQL.Async.fetchAll(
                "SELECT * FROM tankstellen WHERE tankstellennummer = @tankstellennummer",
                {
                    ["@tankstellennummer"] = shop
                },
                function(results)
                    if xPlayer.getMoney() < results[1].wert then
                        TriggerClientEvent("sevenlife:givetimednachrichts", _source, "Du hast zu wenig geld")
                    else
                        MySQL.Async.execute(
                            "UPDATE tankstellen SET identifer = @identifer WHERE tankstellennummer = @tankstellennummer",
                            {
                                ["@identifer"] = identifier,
                                ["@tankstellennummer"] = shop
                            },
                            function(resultse)
                                xPlayer.removeAccountMoney("money", results[1].wert)
                                TriggerClientEvent(
                                    "sevenlife:givetimednachrichts",
                                    _source,
                                    "Tankstelle Erfolgreich gekauft"
                                )
                            end
                        )
                    end
                end
            )
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Fuel:CheckIfEnoughGas",
    function(source, cb, nummer)
        local fuel =
            MySQL.Sync.fetchAll(
            "SELECT activefuel FROM tankstellen WHERE tankstellennummer = @tankstellennummer",
            {
                ["@tankstellennummer"] = nummer
            }
        )
        if tonumber(fuel[1].activefuel) >= 50 then
            cb(true)
        else
            cb(false)
        end
    end
)
