ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("sevenlive:checkifownedlager")
AddEventHandler(
    "sevenlive:checkifownedlager",
    function(lagernumber)
        local lager = lagernumber
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_lager WHERE lagerNumber = @lager",
            {
                ["@lager"] = lager
            },
            function(results)
                if results[1].identifier == "0" then
                    TriggerClientEvent(
                        "sevenlife:kaufnui",
                        _source,
                        "openlagerhallekaufen",
                        true,
                        true,
                        lagernumber,
                        results[1].lagerValue,
                        results[1].quali
                    )
                else
                    if results[1].identifier == identifier then
                        TriggerClientEvent(
                            "sevenlife:invdata",
                            _source,
                            lager,
                            results[1].lagerValue,
                            results[1].quali,
                            results[1].btc,
                            results[1].eth,
                            results[1].lagerused,
                            results[1].platz,
                            results[1].mining
                        )
                    else
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Lagerhallen",
                            "Diese Lagerhalle ist voll!",
                            3000
                        )
                    end
                end
            end
        )
    end
)
RegisterServerEvent("sevenlife:inserdatalagerkauf")
AddEventHandler(
    "sevenlife:inserdatalagerkauf",
    function(lagernumber)
        local lager = lagernumber
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = ESX.GetPlayerFromId(_source).identifier

        MySQL.Async.fetchAll(
            "SELECT * FROM owned_lager WHERE lagerNumber = @lager",
            {
                ["@lager"] = lager
            },
            function(results)
                local price = results[1].lagerValue
                if xPlayer.getMoney() < results[1].lagerValue then
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Lagerhallen",
                        "Du besitzt zu wenig Geld!",
                        3000
                    )

                    TriggerClientEvent("sevenlife:entfernalles", _source)
                else
                    MySQL.Async.execute(
                        "UPDATE owned_lager SET identifier = @identifier WHERE lagerNumber = @lager",
                        {
                            ["@identifier"] = identifier,
                            ["@lager"] = lager
                        },
                        function(results)
                            xPlayer.removeAccountMoney("money", price)
                            TriggerClientEvent("sevenlife:entfernalles", _source)
                            TriggerClientEvent("sevenlife:removeblips", -1)
                            Citizen.Wait(100)
                            TriggerClientEvent("sevenlife:addblibsyea", -1)
                        end
                    )
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:getinvitem",
    function(source, cb)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local inv = xPlayer.inventory
        cb(inv)
    end
)
ESX.RegisterServerCallback(
    "sevenlife:getlageritems",
    function(source, cb, number)
        local identifier = ESX.GetPlayerFromId(source).identifier

        MySQL.Async.fetchAll(
            "SELECT * FROM lager WHERE lagerNumber = @lagernumber",
            {
                ["@lagernumber"] = number
            },
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("sevenlife:transformdatas")
AddEventHandler(
    "sevenlife:transformdatas",
    function(items, count, lager, weight)
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source

        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM items WHERE label = @label",
            {
                ["@label"] = items
            }
        )
        local item = check[1].name

        xPlayer.removeInventoryItem(item, count)
        MySQL.Async.fetchAll(
            "SELECT * FROM lager WHERE lagerNumber = @lagernumber AND item = @item",
            {
                ["@lagernumber"] = lager,
                ["@item"] = item
            },
            function(result)
                if result[1] == nil then
                    MySQL.Async.execute(
                        "INSERT INTO lager (lagerNumber, src, count, item , label, weight) VALUES (@lagernumber, @src, @count, @item , @label, @weight )",
                        {
                            ["@lagernumber"] = lager,
                            ["@src"] = "bottle",
                            ["@count"] = count,
                            ["@item"] = item,
                            ["@label"] = items,
                            ["@weight"] = tonumber(check[1].weight) * tonumber(count)
                        }
                    )
                else
                    if result[1] ~= nil then
                        local counts = result[1].count
                        local endcount = counts + count
                        local oldweight = result[1].weight
                        local newcount = oldweight + weight
                        MySQL.Async.execute(
                            "UPDATE lager SET count = @count, weight = @weight WHERE lagerNumber = @lagernumber and item = @item",
                            {
                                ["@lagernumber"] = lager,
                                ["@count"] = endcount,
                                ["@item"] = item,
                                ["@weight"] = newcount
                            }
                        )
                    end
                end
            end
        )
    end
)
RegisterServerEvent("sevenlife:transformdataszwei")
AddEventHandler(
    "sevenlife:transformdataszwei",
    function(items, count, lager)
        local xPlayer = ESX.GetPlayerFromId(source)
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM items WHERE label = @label",
            {
                ["@label"] = items
            }
        )
        local item = check[1].name
        print(items)
        print(item)
        print(count)

        MySQL.Async.fetchAll(
            "SELECT * FROM lager WHERE lagerNumber = @lagernumber AND label = @label",
            {
                ["@lagernumber"] = lager,
                ["@label"] = items
            },
            function(result)
                if result[1] ~= nil then
                    if tonumber(result[1].count) >= tonumber(count) then
                        local counts = result[1].count
                        local endcount = tonumber(counts) - count
                        MySQL.Async.execute(
                            "UPDATE lager SET count = @count WHERE lagerNumber = @lagernumber AND label = @label",
                            {
                                ["@lagernumber"] = lager,
                                ["@label"] = items,
                                ["@count"] = endcount
                            }
                        )
                        xPlayer.addInventoryItem(item, count)
                    end
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:ownedblipse",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_lager WHERE NOT identifier = @identifier",
            {
                ["@identifier"] = "0"
            },
            function(results)
                cb(results)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:getnormalblips",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_lager WHERE identifier = @identifier",
            {
                ["@identifier"] = "0"
            },
            function(results)
                cb(results)
            end
        )
    end
)

RegisterServerEvent("sevenlife:getownedblipsdatas")
AddEventHandler(
    "sevenlife:getownedblipsdatas",
    function()
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_lager WHERE NOT identifier = @identifier",
            {
                ["@identifier"] = "0"
            },
            function(results)
                TriggerClientEvent("sevenlife:transferdataownedblip", _source, results)
            end
        )
    end
)
RegisterServerEvent("sevenlife:getrestdatablipslager")
AddEventHandler(
    "sevenlife:getrestdatablipslager",
    function()
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_lager WHERE identifier = @identifier",
            {
                ["@identifier"] = "0"
            },
            function(results)
                TriggerClientEvent("sevenlife:transferdatanotownedblips", _source, results)
            end
        )
    end
)

RegisterServerEvent("Sevenlife:Lager:UpdateWeight")
AddEventHandler(
    "Sevenlife:Lager:UpdateWeight",
    function(weight, lager)
        MySQL.Async.fetchAll(
            "SELECT lagerused FROM owned_lager WHERE lagerNumber = @lagernumber",
            {
                ["@lagernumber"] = lager
            },
            function(result)
                local oldweight = result[1].lagerused
                local newweight = oldweight + weight
                MySQL.Async.execute(
                    "UPDATE owned_lager SET lagerused = @lagerused WHERE lagerNumber = @lagernumber",
                    {
                        ["@lagernumber"] = lager,
                        ["@lagerused"] = newweight
                    }
                )
            end
        )
    end
)

RegisterServerEvent("Sevenlife:Lager:RemoveWeight")
AddEventHandler(
    "Sevenlife:Lager:RemoveWeight",
    function(weight, lager)
        MySQL.Async.fetchAll(
            "SELECT lagerused FROM owned_lager WHERE lagerNumber = @lagernumber",
            {
                ["@lagernumber"] = lager
            },
            function(result)
                local oldweight = result[1].lagerused
                local newweight = oldweight - weight
                MySQL.Async.execute(
                    "UPDATE owned_lager SET lagerused = @lagerused WHERE lagerNumber = @lagernumber",
                    {
                        ["@lagernumber"] = lager,
                        ["@lagerused"] = newweight
                    }
                )
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Lager:GetWeightOfItem",
    function(source, cb, item)
        MySQL.Async.fetchAll(
            "SELECT * FROM items WHERE label = @label",
            {
                ["@label"] = item
            },
            function(result)
                cb(result[1].weight)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Lager:NotOverLimit",
    function(source, cb, lager, weight, max)
        local lager = tonumber(lager)
        print(lager)
        MySQL.Async.fetchAll(
            "SELECT lagerused FROM owned_lager WHERE lagerNumber = @lagernumber",
            {
                ["@lagernumber"] = lager
            },
            function(result)
                local oldweight = result[1].lagerused
                local newweight = oldweight + weight
                if newweight <= max then
                    cb(true)
                else
                    cb(false)
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Lagerhallen:InsertUpgrade")
AddEventHandler(
    "SevenLife:Lagerhallen:InsertUpgrade",
    function(id, lager)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local cash = xPlayer.getMoney()
        local item1 = xPlayer.getInventoryItem("kupfer").count
        local item2 = xPlayer.getInventoryItem("spaten").count
        local item3 = xPlayer.getInventoryItem("glas").count
        local check =
            MySQL.Sync.fetchAll(
            "SELECT platz FROM owned_lager WHERE lagerNumber = @lagerNumber",
            {
                ["@lagerNumber"] = lager
            }
        )
        if tonumber(id) == 1 then
            if check[1].platz == "false" then
                if cash >= 2000 then
                    if item1 >= 3 and item2 >= 2 and item3 >= 3 then
                        xPlayer.removeAccountMoney("money", 2000)
                        xPlayer.removeInventoryItem("kupfer", 3)
                        xPlayer.removeInventoryItem("spaten", 2)
                        xPlayer.removeInventoryItem("glas", 3)

                        MySQL.Async.execute(
                            "UPDATE owned_lager SET platz = @platz WHERE lagerNumber = @lagernumber",
                            {
                                ["@lagernumber"] = lager,
                                ["@platz"] = "1"
                            }
                        )
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Lagerhallen",
                            "Du hast die Modifikation erfolgreich gekauft!",
                            3000
                        )
                    else
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Lagerhallen",
                            "Du hast nicht die nötigen Items!",
                            3000
                        )
                    end
                else
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Lagerhallen",
                        "Du hast zu wenig Geld!",
                        3000
                    )
                end
            else
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Lagerhallen",
                    "Du besitzt diese Modifikation schon oder besitzt die Upgrade stufe davor nicht!",
                    3000
                )
            end
        elseif tonumber(id) == 2 then
            if check[1].platz == "2" then
                if cash >= 8000 then
                    if item1 >= 5 and item2 >= 2 and item3 >= 5 then
                        xPlayer.removeAccountMoney("money", 8000)
                        xPlayer.removeInventoryItem("kupfer", 5)
                        xPlayer.removeInventoryItem("spaten", 2)
                        xPlayer.removeInventoryItem("glas", 5)

                        MySQL.Async.execute(
                            "UPDATE owned_lager SET platz = @platz WHERE lagerNumber = @lagernumber",
                            {
                                ["@lagernumber"] = lager,
                                ["@platz"] = "2"
                            }
                        )
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Lagerhallen",
                            "Du hast die Modifikation erfolgreich gekauft!",
                            3000
                        )
                    else
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Lagerhallen",
                            "Du hast nicht die nötigen Items!",
                            3000
                        )
                    end
                else
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Lagerhallen",
                        "Du hast zu wenig Geld!",
                        3000
                    )
                end
            else
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Lagerhallen",
                    "Du besitzt diese Modifikation schon oder besitzt die Upgrade stufe davor nicht!",
                    3000
                )
            end
        elseif tonumber(id) == 3 then
            if check[1].platz == "3" then
                if cash >= 15000 then
                    if item1 >= 5 and item2 >= 2 and item3 >= 5 then
                        xPlayer.removeAccountMoney("money", 15000)
                        xPlayer.removeInventoryItem("kupfer", 10)
                        xPlayer.removeInventoryItem("spaten", 2)
                        xPlayer.removeInventoryItem("glas", 10)

                        MySQL.Async.execute(
                            "UPDATE owned_lager SET platz = @platz WHERE lagerNumber = @lagernumber",
                            {
                                ["@lagernumber"] = lager,
                                ["@platz"] = "3"
                            }
                        )
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Lagerhallen",
                            "Du hast die Modifikation erfolgreich gekauft!",
                            3000
                        )
                    else
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Lagerhallen",
                            "Du hast nicht die nötigen Items!",
                            3000
                        )
                    end
                else
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Lagerhallen",
                        "Du hast zu wenig Geld!",
                        3000
                    )
                end
            else
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Lagerhallen",
                    "Du besitzt diese Modifikation schon oder besitzt die Upgrade stufe davor nicht!",
                    3000
                )
            end
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Lagerhallen:GetInfosForRig",
    function(source, cb, lager)
        local xPlayer = ESX.GetPlayerFromId(source)
        local items = xPlayer.inventory

        local checks =
            MySQL.Sync.fetchAll(
            "SELECT * FROM miningrigs WHERE lagerNumber = @lagerNumber",
            {
                ["@lagerNumber"] = lager
            }
        )
        local mining =
            MySQL.Sync.fetchAll(
            "SELECT btc FROM owned_lager WHERE lagerNumber = @lagerNumber",
            {
                ["@lagerNumber"] = lager
            }
        )

        cb(items, checks, mining)
    end
)
RegisterServerEvent("SevenLife:Lagerhallen:InsertItemMining")
AddEventHandler(
    "SevenLife:Lagerhallen:InsertItemMining",
    function(name, label, type, lager)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local precheck =
            MySQL.Sync.fetchAll(
            "SELECT * FROM miningrigs WHERE lagerNumber = @lagerNumber AND types = @types",
            {
                ["@lagerNumber"] = lager,
                ["@types"] = type
            }
        )

        if precheck[1] == nil then
            xPlayer.removeInventoryItem(name, 1)
            MySQL.Async.execute(
                "INSERT INTO miningrigs (lagerNumber, src, item , label, types) VALUES (@lagernumber, @src, @item , @label, @types )",
                {
                    ["@lagernumber"] = lager,
                    ["@src"] = "bottle",
                    ["@item"] = name,
                    ["@label"] = label,
                    ["@types"] = type
                }
            )
        else
            xPlayer.removeInventoryItem(name, 1)
            xPlayer.addInventoryItem(precheck[1].item, 1)
            MySQL.Async.execute(
                "UPDATE miningrigs SET item = @item, label = @label WHERE lagerNumber = @lagernumber AND types = @types",
                {
                    ["@lagernumber"] = lager,
                    ["@item"] = name,
                    ["@label"] = label,
                    ["@types"] = type
                }
            )
        end

        Citizen.Wait(100)
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM miningrigs WHERE lagerNumber = @lagerNumber",
            {
                ["@lagerNumber"] = lager
            }
        )
        TriggerClientEvent("SevenLife:Lagerhallen:UpdateRigs", _source, check)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Lagerhallen:GetInfosAboutRig",
    function(source, cb)
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM miningrigs WHERE lagerNumber = @lagerNumber",
            {
                ["@lagerNumber"] = lager
            }
        )
        cb(check)
    end
)
RegisterServerEvent("SevenLife:Lagerhallen:GiveBitCoins")
AddEventHandler(
    "SevenLife:Lagerhallen:GiveBitCoins",
    function(btc, lager)
        local mining =
            MySQL.Sync.fetchAll(
            "SELECT btc FROM owned_lager WHERE lagerNumber = @lagerNumber",
            {
                ["@lagerNumber"] = lager
            }
        )

        local endbtcvalue = tonumber(btc) + tonumber(mining[1].btc)

        MySQL.Async.execute(
            "UPDATE owned_lager SET btc = @btc WHERE lagerNumber = @lagernumber ",
            {
                ["@lagernumber"] = lager,
                ["@btc"] = endbtcvalue
            }
        )
    end
)
RegisterServerEvent("SevenLife:Lagerhallen:PayOut")
AddEventHandler(
    "SevenLife:Lagerhallen:PayOut",
    function(btc)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        local _source = source
        local btc = tonumber(btc)
        local cryptos =
            MySQL.Sync.fetchAll(
            "SELECT btc FROM cryptos WHERE id = @id",
            {
                ["@id"] = identifier
            }
        )
        if cryptos ~= nil then
            local endbtc = tonumber(cryptos) + btc
            MySQL.Async.execute(
                "UPDATE cryptos SET btc = @btc WHERE id = @id ",
                {
                    ["@id"] = identifier,
                    ["@btc"] = endbtc
                }
            )
            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Lagerhallen", "Transfer erfolgreich!", 3000)
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                _source,
                "Lagerhallen",
                "Du brauchst eine Wallet bei Cryptonic!",
                3000
            )
        end
    end
)

RegisterServerEvent("SevenLife:ComputerLaden:BuyItem")
AddEventHandler(
    "SevenLife:ComputerLaden:BuyItem",
    function(label, preis)
        local preis = tonumber(preis)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        if tonumber(money) >= preis then
            xPlayer.removeAccountMoney("money", preis)
            xPlayer.addInventoryItem(label, 1)
            local moneys = xPlayer.getMoney()
            TriggerClientEvent("SevenLife:ComputerLaden:Geld", source, moneys)
        end
    end
)
