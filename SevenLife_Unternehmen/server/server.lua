--------------------------------------------------------------------------------------------------------------
------------------------------------------------ESX-----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Unternehmen:CheckIfPlayerHaveUnternehmen",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM unternehmen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] ~= nil then
                    cb(true)
                else
                    cb(false)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Unternehmen:CheckBuero",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT bueronummer, firmenname FROM unternehmen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                cb(result[1].bueronummer, result[1].firmenname)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Garage:GetCars",
    function(source, cb, firmenname)
        MySQL.Async.fetchAll(
            "SELECT automodel FROM unternehmensautos WHERE firmenid = @firmenname",
            {
                ["@firmenname"] = firmenname
            },
            function(result)
                cb(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Computer:GetÜbersichtData",
    function(source, cb, firmenname)
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT bueronummer, firmenname FROM unternehmen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(resulting)
                firmenname = resulting[1].firmenname
                local result =
                    MySQL.Sync.fetchAll(
                    "SELECT cash FROM unternehmen WHERE firmenname = @firmenname",
                    {
                        ["@firmenname"] = firmenname
                    }
                )
                local cars =
                    MySQL.Sync.fetchAll(
                    "SELECT automodel FROM unternehmensautos WHERE firmenid = @firmenid",
                    {
                        ["@firmenid"] = firmenname
                    }
                )
                local shops =
                    MySQL.Sync.fetchAll(
                    "SELECT * FROM owned_shops WHERE identifier = @identifier",
                    {
                        ["@identifier"] = identifier
                    }
                )
                local herstellung =
                    MySQL.Sync.fetchAll(
                    "SELECT * FROM herstellungsitems WHERE firmenname = @firmenname",
                    {
                        ["@identifier"] = firmenname
                    }
                )
                local tankstellen =
                    MySQL.Sync.fetchAll(
                    "SELECT * FROM tankstellen WHERE identifer = @identifer",
                    {
                        ["@identifer"] = identifier
                    }
                )
                local angestellte =
                    MySQL.Sync.fetchAll(
                    "SELECT * FROM angestellte WHERE firmenname = @firmenname",
                    {
                        ["@firmenname"] = firmenname
                    }
                )

                cb(result, cars, shops, herstellung, tankstellen, angestellte)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Admins:GetShopsInfos",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local shops =
            MySQL.Sync.fetchAll(
            "SELECT ShopNumber FROM owned_shops WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        cb(shops)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Admin:getDetailsShopsInfos",
    function(source, cb, number)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local shops =
            MySQL.Sync.fetchAll(
            "SELECT money FROM owned_shops WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        local shopitem =
            MySQL.Sync.fetchAll(
            "SELECT count FROM shop WHERE shopnumber = @Number",
            {
                ["@shopnumber"] = number
            }
        )
        local shopitemhistory =
            MySQL.Sync.fetchAll(
            "SELECT * FROM shophistory WHERE shopid = @shopid",
            {
                ["@shopid"] = number
            }
        )
        local itemcount = 0
        for k, v in pairs(shopitem) do
            itemcount = itemcount + 1
        end
        cb(shops[1].money, itemcount, shopitemhistory)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Unternehmen:GetItemsForEinlagern",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local inventoryitem = xPlayer.inventory
        cb(inventoryitem)
    end
)
RegisterServerEvent("SevenLife:Unternehmen:InsertEinlagern")
AddEventHandler(
    "SevenLife:Unternehmen:InsertEinlagern",
    function(id, name, count, label)
        local count = tonumber(count)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(name, count)
        local _source = source
        local items =
            MySQL.Sync.fetchAll(
            "SELECT * FROM shop WHERE shopnumber = @ShopNumber AND item = @item",
            {
                ["@ShopNumber"] = id
            }
        )
        if items[1] ~= nil then
            MySQL.Async.execute(
                "UPDATE shop SET src = @src, count = @count, preis = @preis, item = @item, label = @label WHERE shopnumber = @shopnumber",
                {
                    ["@shopnumber"] = id,
                    ["@src"] = name,
                    ["@count"] = tonumber(items[1].count) + count,
                    ["@preis"] = 10,
                    ["@item"] = name,
                    ["@label"] = label
                },
                function()
                    Citizen.Wait(500)
                    local updateitem = xPlayer.inventory
                    TriggerClientEvent("SevenLife:Unternehmen:UpdateEinlagern", _source, updateitem, id)
                end
            )
        else
            MySQL.Async.execute(
                "INSERT INTO shop (shopnumber,src,count,preis,item, label) VALUES (@shopnumber,@src,@count,@preis,@item,@label)",
                {
                    ["@shopnumber"] = id,
                    ["@src"] = name,
                    ["@count"] = count,
                    ["@preis"] = 10,
                    ["@item"] = name,
                    ["@label"] = label
                },
                function(result)
                    Citizen.Wait(500)
                    local updateitem = xPlayer.inventory
                    TriggerClientEvent("SevenLife:Unternehmen:UpdateEinlagern", _source, updateitem, id)
                end
            )
        end
    end
)
RegisterServerEvent("SevenLife:Unternehmen:GeldAuszahlen")
AddEventHandler(
    "SevenLife:Unternehmen:GeldAuszahlen",
    function(money, id)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local moneyamount =
            MySQL.Sync.fetchAll(
            "SELECT money FROM owned_shops WHERE shopnumber = @ShopNumber",
            {
                ["@ShopNumber"] = id
            }
        )
        if tonumber(moneyamount[1].money) >= tonumber(money) then
            local money = tonumber(money)
            xPlayer.addAccountMoney("money", money)
            local endmoney = tonumber(moneyamount[1].money) - money
            MySQL.Async.execute(
                "UPDATE owned_shops SET money = @money WHERE shopnumber = @ShopNumber",
                {
                    ["@money"] = endmoney,
                    ["@ShopNumber"] = id
                },
                function()
                    TriggerClientEvent("SevenLife:Admin:UpdateMoneyShop", _source, endmoney)
                end
            )
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                _source,
                "Unternehmen",
                "In diesem Shop ist momentan zu wenig Geld drinne",
                3000
            )
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Unternehmen:GetItemsInShop",
    function(source, cb, id)
        local items =
            MySQL.Sync.fetchAll(
            "SELECT * FROM shop WHERE shopnumber = @shopnumber",
            {
                ["@shopnumber"] = id
            }
        )
        cb(items)
    end
)
RegisterServerEvent("SevenLife:Unternehmen:Auslagern")
AddEventHandler(
    "SevenLife:Unternehmen:Auslagern",
    function(shopid, name, count, label)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM shop WHERE shopNumber = @shopNumber",
            {
                ["@shopNumber"] = shopid
            },
            function(result)
                if result[1].item == name and tonumber(result[1].count) >= tonumber(count) then
                    xPlayer.addInventoryItem(name, count)
                    if tonumber(result[1].count) - count >= 1 then
                        MySQL.Async.execute(
                            "UPDATE shop SET count = @count WHERE shopnumber = @shopnumber AND item = @item",
                            {
                                ["@shopnumber"] = shopid,
                                ["@item"] = name,
                                ["@count"] = tonumber(result[1].count) - count
                            },
                            function()
                                Citizen.Wait(500)
                                local items =
                                    MySQL.Sync.fetchAll(
                                    "SELECT * FROM shop WHERE shopNumber = @shopNumber",
                                    {
                                        ["@shopNumber"] = shopid
                                    }
                                )

                                TriggerClientEvent("SevenLife:Unternehmen:UpdateAuslagern", _source, items, shopid)
                            end
                        )
                    else
                        MySQL.Async.execute(
                            "DELETE FROM shop WHERE shopnumber = @shopnumber AND item = @item",
                            {
                                ["@shopnumber"] = shopid,
                                ["@item"] = name
                            },
                            function()
                                Citizen.Wait(500)
                                local items =
                                    MySQL.Sync.fetchAll(
                                    "SELECT * FROM shop WHERE shopNumber = @shopNumber",
                                    {
                                        ["@shopNumber"] = shopid
                                    }
                                )

                                TriggerClientEvent("SevenLife:Unternehmen:UpdateAuslagern", _source, items)
                            end
                        )
                    end
                else
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Unternehmen",
                        "Ein unerwarteter Fehler ist aufgetreten!",
                        3000
                    )
                end
            end
        )
    end
)
RegisterServerEvent("SevenLife:Unternehmen:UpdatePreis")
AddEventHandler(
    "SevenLife:Unternehmen:UpdatePreis",
    function(money, id, name, label)
        local _source = source
        MySQL.Async.execute(
            "UPDATE shop SET preis = @preis WHERE shopnumber = @shopnumber AND item = @item",
            {
                ["@shopnumber"] = id,
                ["@item"] = name,
                ["@preis"] = money
            },
            function()
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Unternehmen",
                    "Preis von " .. label .. " wurde auf " .. money .. "$ gesetzt",
                    3000
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Unternehmen:GetItemsPreis",
    function(source, cb, id)
        local items =
            MySQL.Sync.fetchAll(
            "SELECT * FROM shop WHERE shopnumber = @shopNumber",
            {
                ["@shopNumber"] = id
            }
        )
        cb(items)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Unternehmen:CheckIfInAuktion",
    function(source, cb, id)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM auktionen WHERE kategorie = @kategorie AND label = @label",
            {
                ["@kategorie"] = "shops",
                ["@label"] = id
            },
            function(res)
                if res[1] ~= nil then
                    cb(false)
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Unternehmen",
                        "Du hast diesen Shop schon unter Verkauf gesetzt",
                        3000
                    )
                else
                    cb(true)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Admins:GetTankeInfos",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local tanken =
            MySQL.Sync.fetchAll(
            "SELECT * FROM tankstellen WHERE identifer = @identifer",
            {
                ["@identifer"] = identifier
            }
        )
        cb(tanken)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Admin:getDetailsTankeInfos",
    function(source, cb, number)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local tanke =
            MySQL.Sync.fetchAll(
            "SELECT money, activefuel FROM tankstellen WHERE identifer = @identifer",
            {
                ["@identifer"] = identifier
            }
        )
        local tankeitemhistory =
            MySQL.Sync.fetchAll(
            "SELECT * FROM tankehistory WHERE shopid = @shopid",
            {
                ["@shopid"] = number
            }
        )

        cb(tanke[1].money, tanke[1].activefuel, tankeitemhistory)
    end
)
RegisterServerEvent("SevenLife:Tankstelle:GeldAuszahlen")
AddEventHandler(
    "SevenLife:Tankstelle:GeldAuszahlen",
    function(money, id)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local moneyamount =
            MySQL.Sync.fetchAll(
            "SELECT money FROM tankstellen WHERE tankstellennummer = @tankstellennummer",
            {
                ["@tankstellennummer"] = id
            }
        )
        if tonumber(moneyamount[1].money) >= tonumber(money) then
            local money = tonumber(money)
            xPlayer.addAccountMoney("money", money)
            local endmoney = tonumber(moneyamount[1].money) - money
            MySQL.Async.execute(
                "UPDATE tankstellen SET money = @money WHERE tankstellennummer = @tankstellennummer",
                {
                    ["@money"] = endmoney,
                    ["@tankstellennummer"] = id
                },
                function()
                    TriggerClientEvent("SevenLife:Admin:UpdateMoneyTanke", _source, endmoney)
                end
            )
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                _source,
                "Unternehmen",
                "In dieser Tankstelle ist momentan zu wenig Geld drinne",
                3000
            )
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Unternehmen:CheckIfHaveCar",
    function(source, cb, id, name1, name2)
        print(1)
        local vehicle =
            MySQL.Sync.fetchAll(
            "SELECT automodel FROM unternehmensautos WHERE firmenid = @firmenid",
            {
                ["@firmenid"] = id
            }
        )
        if vehicle[1] ~= nil then
            for k, v in pairs(vehicle) do
                if v.automodel == name1 and v.automodel == name2 then
                    cb(true)
                else
                    cb(false)
                end
            end
        else
            cb(false)
        end
    end
)
RegisterServerEvent("SevenLife:Unternehmen:SchreibeOilGut")
AddEventHandler(
    "SevenLife:Unternehmen:SchreibeOilGut",
    function(dataid, fuel)
        local _source = source
        local fuelid = tonumber(dataid)
        local endmoney = tonumber(fuel) * 10
        local xPlayer = ESX.GetPlayerFromId(source)
        local tankeninfo =
            MySQL.Sync.fetchAll(
            "SELECT activefuel FROM tankstellen WHERE tankstellennummer = @tankstellennummer",
            {
                ["@tankstellennummer"] = fuelid
            }
        )
        if tankeninfo[1] ~= nil then
            xPlayer.removeAccountMoney("money", endmoney)
            MySQL.Async.execute(
                "UPDATE tankstellen SET activefuel = @activefuel WHERE tankstellennummer = @tankstellennummer",
                {
                    ["@activefuel"] = tonumber(tankeninfo[1].activefuel) + tonumber(fuel),
                    ["@tankstellennummer"] = dataid
                },
                function()
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Unternehmen",
                        "Deiner Tankstelle wurde Insgesamt " ..
                            fuel ..
                                "L gutgeschrieben. Insgesamt hat diese Tankstelle jetzt " ..
                                    tonumber(tankeninfo[1].activefuel) + fuel .. "L",
                        3000
                    )
                end
            )
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Unternehmen:CheckIfEnoughMoney",
    function(source, cb, liter)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        if money >= tonumber(liter) * 10 then
            cb(true)
        else
            cb(false)
        end
    end
)
RegisterNetEvent("SevenLife:Unternehmen:Buy")
AddEventHandler(
    "SevenLife:Unternehmen:Buy",
    function(Item, ItemCount, preis)
        local _source = source
        local preis = tonumber(preis)
        local xPlayer = ESX.GetPlayerFromId(_source)

        local ItemCount = tonumber(ItemCount)
        local Item = string.lower(Item)

        if xPlayer.getMoney() < preis then
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                _source,
                "Unternehmen",
                "Du hast zu wenig Geld um so eine Menge zu kaufen",
                2000
            )
        else
            xPlayer.removeMoney(preis)
            xPlayer.addInventoryItem(Item, ItemCount)
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Unternehmen:GetJobs",
    function(source, cb, fuelid)
        local result =
            MySQL.Sync.fetchAll(
            "SELECT * FROM unternehmenjobs WHERE firmenid = @firmenid",
            {
                ["@firmenid"] = fuelid
            }
        )
        cb(result)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Unternehmen:GetIfEnoughMoney",
    function(source, cb, moneys)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        if money >= tonumber(moneys) then
            cb(true)
        else
            cb(false)
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Unternehmen",
                "DU hast zu wenig Geld dabei um dieses Auto zu kaufen",
                2000
            )
        end
    end
)
RegisterServerEvent("SevenLife:Unternehmen:InsertCar")
AddEventHandler(
    "SevenLife:Unternehmen:InsertCar",
    function(name, firma)
        local _source = source
        MySQL.Async.execute(
            "INSERT INTO unternehmensautos (firmenid,automodel) VALUES (@firmenid,@automodel)",
            {
                ["@firmenid"] = firma,
                ["@automodel"] = name
            },
            function(result)
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Unternehmen",
                    "Du hast dieses Auto gekauft. Wenn das Auto in die Garage passt wird es dort gespawnt",
                    2000
                )
            end
        )
    end
)
