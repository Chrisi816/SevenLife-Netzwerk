ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
Weight = {}
Stashes = {}

RegisterServerEvent("SevenLife:Inventory:OpenWaffenschrankLCN")
AddEventHandler(
    "SevenLife:Inventory:OpenWaffenschrankLCN",
    function()
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM waffenschrank WHERE frak = @frak",
            {
                ["@frak"] = "LCN"
            },
            function(result)
                local xPlayer = ESX.GetPlayerFromId(_source)
                local inv = xPlayer.inventory
                local weight = xPlayer.getWeight()
                local loadoutNum, weapon = xPlayer.getWeapon("WEAPON_PISTOL")
                local loadout = xPlayer.getLoadout()

                TriggerClientEvent("SevenLife:Inventory:OpenItWaffenschrankFRAK", _source, inv, weight, result, loadout)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Inventory:FrakStandard",
    function(source, cb, label, anzahl, types)
        local xPlayer = ESX.GetPlayerFromId(source)
        local weight = xPlayer.getWeight()
        local _source = source
        local accept

        if tonumber(weight) <= 100 then
            MySQL.Async.fetchAll(
                "SELECT * FROM waffenschrank WHERE items = @item AND frak = @frak",
                {
                    ["@item"] = label,
                    ["@frak"] = "LCN"
                },
                function(result)
                    if tonumber(result[1].anzahl) >= tonumber(anzahl) then
                        if
                            label == "WEAPON_PISTOL" or label == "WEAPON_PISTOL50" or label == "WEAPON_ASSAULTRIFLE" or
                                label == "WEAPON_COMBATPDW"
                         then
                            local xPlayer = ESX.GetPlayerFromId(source)
                            local loadout = xPlayer.getLoadout()
                            if loadout[1] ~= nil then
                                for k, v in ipairs(loadout) do
                                    if v.name == label then
                                        accept = false
                                    else
                                        accept = true
                                        xPlayer.addWeapon(label, 30)
                                    end
                                end
                            else
                                accept = true
                                xPlayer.addWeapon(label, 30)
                            end
                        else
                            accept = true
                            xPlayer.addInventoryItem(label, anzahl)
                        end
                        if accept then
                            local endzahl = tonumber(result[1].anzahl) - anzahl
                            if endzahl >= 1 then
                                MySQL.Async.execute(
                                    "UPDATE waffenschrank SET anzahl = @anzahl WHERE items = @items AND frak = @frak",
                                    {
                                        ["@items"] = label,
                                        ["@anzahl"] = result[1].anzahl - anzahl,
                                        ["@frak"] = "LCN"
                                    },
                                    function()
                                        MySQL.Async.fetchAll(
                                            "SELECT * FROM waffenschrank WHERE  frak = @frak",
                                            {
                                                ["@frak"] = "LCN"
                                            },
                                            function(result)
                                                local xPlayer = ESX.GetPlayerFromId(source)
                                                local inv = xPlayer.inventory
                                                local loadout = xPlayer.getLoadout()
                                                cb(result, inv, loadout)
                                            end
                                        )
                                    end
                                )
                            else
                                MySQL.Async.execute(
                                    "DELETE FROM waffenschrank WHERE items = @item AND frak = @frak",
                                    {
                                        ["@item"] = label,
                                        ["@frak"] = "LCN"
                                    },
                                    function()
                                        MySQL.Async.fetchAll(
                                            "SELECT * FROM waffenschrank WHERE  frak = @frak",
                                            {
                                                ["@frak"] = "LCN"
                                            },
                                            function(result)
                                                local xPlayer = ESX.GetPlayerFromId(source)
                                                local inv = xPlayer.inventory
                                                local loadout = xPlayer.getLoadout()
                                                cb(result, inv, loadout)
                                            end
                                        )
                                    end
                                )
                            end
                        else
                            TriggerClientEvent(
                                "SevenLife:Inventory:CloseInventoryTrunk",
                                _source,
                                "Du hast schon eine Waffe"
                            )
                        end
                    else
                        TriggerClientEvent(
                            "SevenLife:Inventory:CloseInventoryTrunk",
                            _source,
                            "Du hast zu wenige Items"
                        )
                    end
                end
            )
        else
            TriggerClientEvent("SevenLife:Inventory:CloseInventoryTrunk", _source, "Du hast zu viele Items im Inventar")
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Inventar:InsertItemTrunkdreiFrak",
    function(source, cb, item, anzahl, label, types)
        local xPlayer = ESX.GetPlayerFromId(source)
        local itemcount

        if types == "weapon" then
            itemcount = 1
            xPlayer.removeWeapon(item)
        else
            itemcount = xPlayer.getInventoryItem(item).count
            xPlayer.removeInventoryItem(item, anzahl)
        end

        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM waffenschrank WHERE items = @items AND frak = @frak",
            {
                ["@items"] = item,
                ["@frak"] = "LCN"
            },
            function(result)
                if tonumber(itemcount) >= tonumber(anzahl) then
                    if result[1] ~= nil then
                        if result[1].items == item and result[1].label == label then
                            MySQL.Async.execute(
                                "UPDATE waffenschrank SET anzahl = @anzahl WHERE items = @items  AND frak = @frak",
                                {
                                    ["@items"] = item,
                                    ["@label"] = label,
                                    ["@anzahl"] = result[1].anzahl + anzahl,
                                    ["@frak"] = "LCN"
                                },
                                function()
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM waffenschrank  WHERE frak = @frak",
                                        {
                                            ["@frak"] = "LCN"
                                        },
                                        function(result)
                                            local xPlayer = ESX.GetPlayerFromId(source)
                                            local inv = xPlayer.inventory
                                            local loadout = xPlayer.getLoadout()
                                            cb(result, inv, loadout)
                                        end
                                    )
                                end
                            )
                        else
                            MySQL.Async.fetchAll(
                                "INSERT INTO waffenschrank (frak, items,label,anzahl) VALUES (@frak @items,@label,@anzahl)",
                                {
                                    ["@items"] = item,
                                    ["@label"] = label,
                                    ["@anzahl"] = anzahl,
                                    ["@frak"] = "LCN"
                                },
                                function(result)
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM waffenschrank WHERE frak = @frak",
                                        {
                                            ["@frak"] = "LCN"
                                        },
                                        function(result)
                                            local xPlayer = ESX.GetPlayerFromId(source)
                                            local inv = xPlayer.inventory
                                            local loadout = xPlayer.getLoadout()
                                            cb(result, inv, loadout)
                                        end
                                    )
                                end
                            )
                        end
                    else
                        MySQL.Async.fetchAll(
                            "INSERT INTO waffenschrank (frak, items,label,anzahl) VALUES (@frak, @items,@label,@anzahl)",
                            {
                                ["@items"] = item,
                                ["@label"] = label,
                                ["@anzahl"] = anzahl,
                                ["@frak"] = "LCN"
                            },
                            function(result)
                                MySQL.Async.fetchAll(
                                    "SELECT * FROM waffenschrank WHERE frak = @frak",
                                    {
                                        ["@frak"] = "LCN"
                                    },
                                    function(result)
                                        local xPlayer = ESX.GetPlayerFromId(source)
                                        local inv = xPlayer.inventory
                                        local loadout = xPlayer.getLoadout()
                                        cb(result, inv, loadout)
                                    end
                                )
                            end
                        )
                    end
                else
                    TriggerClientEvent(
                        "SevenLife:Inventory:CloseInventoryTrunk",
                        _source,
                        "Du hast zu viele Items ausgewählt"
                    )
                end
            end
        )
    end
)
