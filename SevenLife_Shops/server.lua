ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "sevenlife:ownedshopblips",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_shops WHERE NOT identifier = @identifier",
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
    "sevenlife:getnormalshopblips",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_shops WHERE identifier = @identifier",
            {
                ["@identifier"] = "0"
            },
            function(results)
                cb(results)
            end
        )
    end
)
RegisterServerEvent("sevenlife:checkifownedshop")
AddEventHandler(
    "sevenlife:checkifownedshop",
    function(shop)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_shops WHERE ShopNumber = @shopnumber",
            {
                ["@shopnumber"] = shop
            },
            function(results)
                if results[1].identifier == "0" then
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Shop",
                        "Du kannst in diesem Shop nichts kaufen",
                        2000
                    )
                    TriggerClientEvent("SevenLife:Shops:NoShop", _source)
                else
                    TriggerClientEvent("sevenlife:shopdetails", _source, shop)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:getshopitems",
    function(source, cb, number)
        local identifier = ESX.GetPlayerFromId(source).identifier

        MySQL.Async.fetchAll(
            "SELECT * FROM shop WHERE shopnumber = @shopnumber",
            {
                ["@shopnumber"] = number
            },
            function(result)
                if result ~= nil then
                    cb(result)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Shops:GetShopsAv",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_shops WHERE identifier = @identifier",
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
RegisterServerEvent("sevenlife:shopkauf")
AddEventHandler(
    "sevenlife:shopkauf",
    function(shopnumber)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local shop = tonumber(shopnumber)
        if shop ~= nil then
            MySQL.Async.fetchAll(
                "SELECT * FROM owned_shops WHERE ShopNumber = @ShopNumber",
                {
                    ["@ShopNumber"] = shop
                },
                function(results)
                    local price = results[1].ShopValue
                    if xPlayer.getMoney() < results[1].ShopValue then
                        TriggerClientEvent("sevenlife:givetimednachrichts", _source, "Du hast zu wenig geld")
                        TriggerClientEvent("sevenlife:entfernallese", _source)
                    else
                        MySQL.Async.execute(
                            "UPDATE owned_shops SET identifier = @identifier WHERE ShopNumber = @ShopNumber",
                            {
                                ["@identifier"] = identifier,
                                ["@ShopNumber"] = shop
                            },
                            function(resultse)
                                xPlayer.removeAccountMoney("money", price)
                                TriggerClientEvent("sevenlife:entfernallese", _source)
                                TriggerClientEvent("sevenlife:removeblipses", -1)
                                Citizen.Wait(100)
                                TriggerClientEvent("sevenlife:addblibsyeas", -1)
                            end
                        )
                    end
                end
            )
        end
    end
)
RegisterServerEvent("sevenlife:checkifplayerhaveanyshop")
AddEventHandler(
    "sevenlife:checkifplayerhaveanyshop",
    function()
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        MySQL.Async.fetchAll(
            "SELECT * FROM owned_shops WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(results)
                if results[1] == nil then
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Vermietung",
                        "Du besitzt keinen Shop",
                        2000
                    )
                else
                    TriggerClientEvent("sevenlife:getalldatas", _source)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:getlogistikitemslebensmittel",
    function(source, cb, number)
        local identifier = ESX.GetPlayerFromId(source).identifier

        MySQL.Async.fetchAll(
            "SELECT * FROM lebensmittel_logistik ",
            {},
            function(result)
                if result ~= nil then
                    cb(result)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:getlogistikitemsbaustelle",
    function(source, cb, number)
        local identifier = ESX.GetPlayerFromId(source).identifier

        MySQL.Async.fetchAll(
            "SELECT * FROM baustelle_logistik",
            {},
            function(result)
                if result ~= nil then
                    MySQL.Async.fetchAll(
                        "SELECT * FROM Mechaniker_logistik",
                        {},
                        function(result2)
                            if result2 ~= nil then
                                cb(result, result2)
                            end
                        end
                    )
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:getlogistikitemsbaustelle",
    function(source, cb, number)
        local identifier = ESX.GetPlayerFromId(source).identifier

        MySQL.Async.fetchAll(
            "SELECT * FROM elektro_logistik",
            {},
            function(result)
                if result ~= nil then
                    cb(result)
                end
            end
        )
    end
)
RegisterServerEvent("sevenlife:givelogistikitems")
AddEventHandler(
    "sevenlife:givelogistikitems",
    function(name, count)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local counts = tonumber(count)
        xPlayer.addInventoryItem(name, counts)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Logistik:Check",
    function(source, cb, money, count, name)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local counts = tonumber(count)
        local preis = tonumber(money)

        if (xPlayer.getMoney() < preis * counts) then
            cb(false)
        else
            if (xPlayer.getMoney() >= preis * counts) then
                local preises = preis * counts
                xPlayer.removeAccountMoney("money", preises)
                cb(true)
            end
        end
    end
)

RegisterServerEvent("sevenlife:ownedshopblipse")
AddEventHandler(
    "sevenlife:ownedshopblipse",
    function()
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_shops WHERE NOT identifier = @identifier",
            {
                ["@identifier"] = "0"
            },
            function(results)
                TriggerClientEvent("sevenlife:transferdataownedshops", _source, results)
            end
        )
    end
)
RegisterServerEvent("sevenlife:normalshopblips")
AddEventHandler(
    "sevenlife:normalshopblips",
    function()
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_shops WHERE identifier = @identifier",
            {
                ["@identifier"] = "0"
            },
            function(results)
                TriggerClientEvent("sevenlife:transferdatanormalshop", _source, results)
            end
        )
    end
)
RegisterServerEvent("sevenlife:delteobj")
AddEventHandler(
    "sevenlife:delteobj",
    function(name)
        TriggerClientEvent("sevenlife:syncdelete", -1, name)
    end
)

RegisterNetEvent("SevenLife:Shops:Buy")
AddEventHandler(
    "SevenLife:Shops:Buy",
    function(id, Item, ItemCount, preis)
        local _source = source
        local preis = tonumber(preis)
        local xPlayer = ESX.GetPlayerFromId(_source)
        local id = tonumber(id)
        local ItemCount = tonumber(ItemCount)
        local Item = string.lower(Item)
        if ItemCount == 0 then
            ItemCount = 1
        end

        MySQL.Async.fetchAll(
            "SELECT * FROM shop WHERE shopnumber = @Number AND item = @item",
            {
                ["@Number"] = id,
                ["@item"] = Item
            },
            function(result)
                MySQL.Async.fetchAll(
                    "SELECT * FROM owned_shops WHERE ShopNumber = @Number",
                    {
                        ["@Number"] = id
                    },
                    function(result2)
                        if xPlayer.getMoney() < ItemCount * result[1].preis then
                            TriggerClientEvent(
                                "SevenLife:TimetCustom:Notify",
                                _source,
                                "Shop",
                                "Du hast zu wenig Geld um so eine Menge zu kaufen",
                                2000
                            )
                        else
                            xPlayer.removeMoney(ItemCount * result[1].preis)
                            xPlayer.addInventoryItem(Item, ItemCount)

                            MySQL.Async.execute(
                                "UPDATE owned_shops SET money = @money WHERE ShopNumber = @Number",
                                {
                                    ["@money"] = result2[1].money + (result[1].preis * ItemCount),
                                    ["@Number"] = id
                                }
                            )

                            if result[1].count >= ItemCount then
                                MySQL.Async.execute(
                                    "UPDATE shop SET count = @count WHERE item = @name AND ShopNumber = @Number",
                                    {
                                        ["@name"] = Item,
                                        ["@Number"] = id,
                                        ["@count"] = result[1].count - ItemCount
                                    }
                                )
                            elseif result[1].count == ItemCount then
                                MySQL.Async.fetchAll(
                                    "DELETE FROM shop WHERE item = @name AND ShopNumber = @Number",
                                    {
                                        ["@Number"] = id,
                                        ["@name"] = result[1].item
                                    }
                                )
                            end
                            MySQL.Async.execute(
                                "INSERT INTO shophistory (shopid, item, anzahl, preis) VALUES (@shopid, @item, @anzahl, @preis)",
                                {
                                    ["@shopid"] = id,
                                    ["@item"] = result[1].label,
                                    ["@anzahl"] = ItemCount,
                                    ["@preis"] = ItemCount * result[1].preis
                                }
                            )
                        end
                    end
                )
            end
        )
    end
)
