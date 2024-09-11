ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
Weight = {}
Stashes = {}
RegisterServerEvent("SevenLife:Inventory:Open")
AddEventHandler(
    "SevenLife:Inventory:Open",
    function(other)
        if other == nil then
            local src = source
            local xPlayer = ESX.GetPlayerFromId(source)
            local inv = xPlayer.inventory
            local weight = xPlayer.getWeight()
            TriggerClientEvent("SevenLife:Inventory:OpenIt", src, inv, weight)
            Weight[source] = 100
        else
            local src = source
            local xPlayer = ESX.GetPlayerFromId(source)
            local inv = xPlayer.inventory
            local weight = xPlayer.getWeight()
            Weight[source] = 130
            TriggerClientEvent("SevenLife:Inventory:OpenItExtra30KD", src, inv, weight)
        end
    end
)

function GetWeight(source)
    return Weight[source]
end

Drops = {}
RegisterServerEvent("SevenLife:Inventory:DropItem")
AddEventHandler(
    "SevenLife:Inventory:DropItem",
    function(name, anzahl)
        local anzahl = tonumber(anzahl)
        local src = source
        local name = name
        local xPlayer = ESX.GetPlayerFromId(src)
        local itemcount = xPlayer.getInventoryItem(name).count
        local endanzahl
        if anzahl ~= nil then
            endanzahl = 1
        else
            endanzahl = anzahl
        end
        if itemcount >= endanzahl then
            local id = SevenLifeDrop()
            Drops[id] = {
                coords = GetEntityCoords(GetPlayerPed(source)),
                item = name,
                amount = endanzahl,
                info = "nice"
            }
            xPlayer.removeInventoryItem(name, 1)
            TriggerClientEvent("SevenLife:Inventory:GetDrop", src, Drops)
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Inventory",
                "Du besitzt so viel vom dem nicht!",
                2000
            )
        end
    end
)
IDs = {}

SevenLifeDrop = function()
    local id = "Drop-" .. math.random(10000, 60000)
    while IDs[id] do
        Wait(0)
        id = "Drop-" .. math.random(10000, 60000)
    end
    IDs[id] = true
    return id
end

RegisterServerEvent("SevenLife:Inventory:RemoveDrop")
AddEventHandler(
    "SevenLife:Inventory:RemoveDrop",
    function(id)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        if Drops[id] then
            local item = Drops[id]
            xPlayer.addInventoryItem(item.item, item.amount)
            Drops[id] = nil
            TriggerClientEvent("SevenLife:Inventory:GetDrop", src, Drops)
        end
    end
)

RegisterServerEvent("SevenLife:Inventory:OpenGloveBox")
AddEventHandler(
    "SevenLife:Inventory:OpenGloveBox",
    function(plate, vehicle, other)
        local _source = source
        local plate = string.gsub(plate, "%s+", "")
        MySQL.Async.fetchAll(
            "SELECT * FROM gloveboxitems WHERE plate = @plate",
            {
                ["@plate"] = plate
            },
            function(result)
                if other ~= nil then
                    local xPlayer = ESX.GetPlayerFromId(_source)
                    local inv = xPlayer.inventory
                    local weight = xPlayer.getWeight()

                    TriggerClientEvent("SevenLife:Inventory:OpenItGloveBox30KG", _source, inv, weight, vehicle, result)
                else
                    local xPlayer = ESX.GetPlayerFromId(_source)
                    local inv = xPlayer.inventory
                    local weight = xPlayer.getWeight()

                    TriggerClientEvent("SevenLife:Inventory:OpenItGloveBox", _source, inv, weight, vehicle, result)
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Inventory:OpenTrunk")
AddEventHandler(
    "SevenLife:Inventory:OpenTrunk",
    function(vehicles, plate, other)
        local _source = source
        local plate = string.gsub(plate, "%s+", "")

        MySQL.Async.fetchAll(
            "SELECT * FROM trunkitems WHERE plate = @plate",
            {
                ["@plate"] = plate
            },
            function(result)
                if other ~= nil then
                    local xPlayer = ESX.GetPlayerFromId(_source)
                    local inv = xPlayer.inventory
                    local weight = xPlayer.getWeight()

                    TriggerClientEvent("SevenLife:Inventory:OpenItTrunk30KG", _source, inv, weight, vehicles, result)
                else
                    local xPlayer = ESX.GetPlayerFromId(_source)
                    local inv = xPlayer.inventory
                    local weight = xPlayer.getWeight()

                    TriggerClientEvent("SevenLife:Inventory:OpenItTrunk", _source, inv, weight, vehicles, result)
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Inventar:InsertItemTrunk",
    function(source, cb, plate, item, anzahl, label)
        local plate = string.gsub(plate, "%s+", "")
        local xPlayer = ESX.GetPlayerFromId(source)
        local itemcount = xPlayer.getInventoryItem(item).count
        xPlayer.removeInventoryItem(item, anzahl)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM trunkitems WHERE plate = @plate AND items = @items ",
            {
                ["@plate"] = plate,
                ["@items"] = item
            },
            function(result)
                if tonumber(itemcount) >= tonumber(anzahl) then
                    if result[1] ~= nil then
                        if result[1].items == item and result[1].label == label then
                            MySQL.Async.execute(
                                "UPDATE trunkitems SET anzahl = @anzahl WHERE plate = @plate AND items = @items",
                                {
                                    ["@plate"] = plate,
                                    ["@items"] = item,
                                    ["@label"] = label,
                                    ["@anzahl"] = result[1].anzahl + anzahl
                                },
                                function()
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM trunkitems WHERE plate = @plate ",
                                        {
                                            ["@plate"] = plate
                                        },
                                        function(result)
                                            local xPlayer = ESX.GetPlayerFromId(source)
                                            local inv = xPlayer.inventory
                                            cb(result, inv)
                                        end
                                    )
                                end
                            )
                        else
                            MySQL.Async.fetchAll(
                                "INSERT INTO trunkitems (plate, items,label,anzahl) VALUES (@plate, @items,@label,@anzahl)",
                                {
                                    ["@plate"] = plate,
                                    ["@items"] = item,
                                    ["@label"] = label,
                                    ["@anzahl"] = anzahl
                                },
                                function(result)
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM trunkitems WHERE plate = @plate ",
                                        {
                                            ["@plate"] = plate
                                        },
                                        function(result)
                                            local xPlayer = ESX.GetPlayerFromId(source)
                                            local inv = xPlayer.inventory
                                            cb(result, inv)
                                        end
                                    )
                                end
                            )
                        end
                    else
                        MySQL.Async.fetchAll(
                            "INSERT INTO trunkitems (plate, items,label,anzahl) VALUES (@plate, @items,@label,@anzahl)",
                            {
                                ["@plate"] = plate,
                                ["@items"] = item,
                                ["@label"] = label,
                                ["@anzahl"] = anzahl
                            },
                            function(result)
                                MySQL.Async.fetchAll(
                                    "SELECT * FROM trunkitems WHERE plate = @plate ",
                                    {
                                        ["@plate"] = plate
                                    },
                                    function(result)
                                        local xPlayer = ESX.GetPlayerFromId(source)
                                        local inv = xPlayer.inventory
                                        cb(result, inv)
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

ESX.RegisterServerCallback(
    "SevenLife:Inventory:GiveItemToInventory",
    function(source, cb, label, anzahl, plate)
        local xPlayer = ESX.GetPlayerFromId(source)
        local plate = string.gsub(plate, "%s+", "")
        local weight = xPlayer.getWeight()
        local _source = source
        if tonumber(weight) <= 100 then
            MySQL.Async.fetchAll(
                "SELECT * FROM trunkitems WHERE plate = @plate AND items = @item",
                {
                    ["@plate"] = plate,
                    ["@item"] = label
                },
                function(result)
                    if tonumber(result[1].anzahl) >= tonumber(anzahl) then
                        xPlayer.addInventoryItem(label, anzahl)
                        local endzahl = tonumber(result[1].anzahl) - anzahl
                        if endzahl >= 1 then
                            MySQL.Async.execute(
                                "UPDATE trunkitems SET anzahl = @anzahl WHERE plate = @plate AND items = @items",
                                {
                                    ["@plate"] = plate,
                                    ["@items"] = label,
                                    ["@anzahl"] = result[1].anzahl - anzahl
                                },
                                function()
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM trunkitems WHERE plate = @plate ",
                                        {
                                            ["@plate"] = plate
                                        },
                                        function(result)
                                            local xPlayer = ESX.GetPlayerFromId(source)
                                            local inv = xPlayer.inventory
                                            cb(result, inv)
                                        end
                                    )
                                end
                            )
                        else
                            MySQL.Async.execute(
                                "DELETE FROM trunkitems WHERE plate = @plate AND items = @item",
                                {
                                    ["@plate"] = plate,
                                    ["@item"] = label
                                },
                                function()
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM trunkitems WHERE plate = @plate ",
                                        {
                                            ["@plate"] = plate
                                        },
                                        function(result)
                                            local xPlayer = ESX.GetPlayerFromId(source)
                                            local inv = xPlayer.inventory
                                            cb(result, inv)
                                        end
                                    )
                                end
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
    "SevenLife:Inventory:GiveItemToInventoryzwei",
    function(source, cb, label, anzahl, plate)
        local xPlayer = ESX.GetPlayerFromId(source)
        local plate = string.gsub(plate, "%s+", "")
        local weight = xPlayer.getWeight()
        local _source = source
        if tonumber(weight) <= 100 then
            MySQL.Async.fetchAll(
                "SELECT * FROM gloveboxitems WHERE plate = @plate AND items = @item",
                {
                    ["@plate"] = plate,
                    ["@item"] = label
                },
                function(result)
                    if tonumber(result[1].anzahl) >= tonumber(anzahl) then
                        xPlayer.addInventoryItem(label, anzahl)
                        local endzahl = tonumber(result[1].anzahl) - anzahl
                        if endzahl >= 1 then
                            MySQL.Async.execute(
                                "UPDATE gloveboxitems SET anzahl = @anzahl WHERE plate = @plate AND items = @items",
                                {
                                    ["@plate"] = plate,
                                    ["@items"] = label,
                                    ["@anzahl"] = result[1].anzahl - anzahl
                                },
                                function()
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM gloveboxitems WHERE plate = @plate ",
                                        {
                                            ["@plate"] = plate
                                        },
                                        function(result)
                                            local xPlayer = ESX.GetPlayerFromId(source)
                                            local inv = xPlayer.inventory
                                            cb(result, inv)
                                        end
                                    )
                                end
                            )
                        else
                            MySQL.Async.execute(
                                "DELETE FROM gloveboxitems WHERE plate = @plate AND items = @item",
                                {
                                    ["@plate"] = plate,
                                    ["@item"] = label
                                },
                                function()
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM gloveboxitems WHERE plate = @plate ",
                                        {
                                            ["@plate"] = plate
                                        },
                                        function(result)
                                            local xPlayer = ESX.GetPlayerFromId(source)
                                            local inv = xPlayer.inventory
                                            cb(result, inv)
                                        end
                                    )
                                end
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
    "SevenLife:Inventar:InsertItemTrunkzwei",
    function(source, cb, plate, item, anzahl, label)
        local plate = string.gsub(plate, "%s+", "")
        local xPlayer = ESX.GetPlayerFromId(source)
        local itemcount = xPlayer.getInventoryItem(item).count
        xPlayer.removeInventoryItem(item, anzahl)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM gloveboxitems WHERE plate = @plate AND items = @items ",
            {
                ["@plate"] = plate,
                ["@items"] = item
            },
            function(result)
                if tonumber(itemcount) >= tonumber(anzahl) then
                    if result[1] ~= nil then
                        if result[1].items == item and result[1].label == label then
                            MySQL.Async.execute(
                                "UPDATE gloveboxitems SET anzahl = @anzahl WHERE plate = @plate AND items = @items",
                                {
                                    ["@plate"] = plate,
                                    ["@items"] = item,
                                    ["@label"] = label,
                                    ["@anzahl"] = result[1].anzahl + anzahl
                                },
                                function()
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM gloveboxitems WHERE plate = @plate ",
                                        {
                                            ["@plate"] = plate
                                        },
                                        function(result)
                                            local xPlayer = ESX.GetPlayerFromId(source)
                                            local inv = xPlayer.inventory
                                            cb(result, inv)
                                        end
                                    )
                                end
                            )
                        else
                            MySQL.Async.fetchAll(
                                "INSERT INTO gloveboxitems (plate, items,label,anzahl) VALUES (@plate, @items,@label,@anzahl)",
                                {
                                    ["@plate"] = plate,
                                    ["@items"] = item,
                                    ["@label"] = label,
                                    ["@anzahl"] = anzahl
                                },
                                function(result)
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM gloveboxitems WHERE plate = @plate ",
                                        {
                                            ["@plate"] = plate
                                        },
                                        function(result)
                                            local xPlayer = ESX.GetPlayerFromId(source)
                                            local inv = xPlayer.inventory
                                            cb(result, inv)
                                        end
                                    )
                                end
                            )
                        end
                    else
                        MySQL.Async.fetchAll(
                            "INSERT INTO gloveboxitems (plate, items,label,anzahl) VALUES (@plate, @items,@label,@anzahl)",
                            {
                                ["@plate"] = plate,
                                ["@items"] = item,
                                ["@label"] = label,
                                ["@anzahl"] = anzahl
                            },
                            function(result)
                                MySQL.Async.fetchAll(
                                    "SELECT * FROM gloveboxitems WHERE plate = @plate ",
                                    {
                                        ["@plate"] = plate
                                    },
                                    function(result)
                                        local xPlayer = ESX.GetPlayerFromId(source)
                                        local inv = xPlayer.inventory
                                        cb(result, inv)
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

RegisterServerEvent("SevenLife:Inventory:OpenWaffenschrank")
AddEventHandler(
    "SevenLife:Inventory:OpenWaffenschrank",
    function()
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM waffenschrankitems",
            {},
            function(result)
                local xPlayer = ESX.GetPlayerFromId(_source)
                local inv = xPlayer.inventory
                local weight = xPlayer.getWeight()
                local loadoutNum, weapon = xPlayer.getWeapon("WEAPON_PISTOL")
                local loadout = xPlayer.getLoadout()

                TriggerClientEvent("SevenLife:Inventory:OpenItWaffenschrank", _source, inv, weight, result, loadout)
            end
        )
    end
)

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
    "SevenLife:Inventar:InsertItemTrunkdrei",
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
            "SELECT * FROM waffenschrankitems WHERE items = @items ",
            {
                ["@items"] = item
            },
            function(result)
                if tonumber(itemcount) >= tonumber(anzahl) then
                    if result[1] ~= nil then
                        if result[1].items == item and result[1].label == label then
                            MySQL.Async.execute(
                                "UPDATE waffenschrankitems SET anzahl = @anzahl WHERE items = @items",
                                {
                                    ["@items"] = item,
                                    ["@label"] = label,
                                    ["@anzahl"] = result[1].anzahl + anzahl
                                },
                                function()
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM waffenschrankitems ",
                                        {},
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
                                "INSERT INTO waffenschrankitems (items,label,anzahl) VALUES ( @items,@label,@anzahl)",
                                {
                                    ["@items"] = item,
                                    ["@label"] = label,
                                    ["@anzahl"] = anzahl
                                },
                                function(result)
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM waffenschrankitems ",
                                        {},
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
                            "INSERT INTO waffenschrankitems (items,label,anzahl) VALUES (@items,@label,@anzahl)",
                            {
                                ["@items"] = item,
                                ["@label"] = label,
                                ["@anzahl"] = anzahl
                            },
                            function(result)
                                MySQL.Async.fetchAll(
                                    "SELECT * FROM waffenschrankitems ",
                                    {},
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
ESX.RegisterServerCallback(
    "SevenLife:Inventory:GiveItemToInventorydrei",
    function(source, cb, label, anzahl, types)
        local xPlayer = ESX.GetPlayerFromId(source)
        local weight = xPlayer.getWeight()
        local _source = source
        local accept

        if tonumber(weight) <= 100 then
            MySQL.Async.fetchAll(
                "SELECT * FROM waffenschrankitems WHERE items = @item",
                {
                    ["@item"] = label
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
                                    "UPDATE waffenschrankitems SET anzahl = @anzahl WHERE items = @items",
                                    {
                                        ["@items"] = label,
                                        ["@anzahl"] = result[1].anzahl - anzahl
                                    },
                                    function()
                                        MySQL.Async.fetchAll(
                                            "SELECT * FROM waffenschrankitems ",
                                            {},
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
                                    "DELETE FROM waffenschrankitems WHERE items = @item",
                                    {
                                        ["@item"] = label
                                    },
                                    function()
                                        MySQL.Async.fetchAll(
                                            "SELECT * FROM waffenschrankitems",
                                            {},
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
RegisterServerEvent("SevenLife:Inventory:Change")
AddEventHandler(
    "SevenLife:Inventory:Change",
    function(trues)
        if trues then
            Weight[source] = 130
        else
            Weight[source] = 100
        end
    end
)
RegisterServerEvent("SevenLife:Inventory:GiveItemToPlayer")
AddEventHandler(
    "SevenLife:Inventory:GiveItemToPlayer",
    function(id, anzahl, item)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local targetplayer = ESX.GetPlayerFromId(tonumber(id))
        local itemcount = xPlayer.getInventoryItem(item).count
        if tonumber(itemcount) >= tonumber(anzahl) then
            local targetplayerweight = xPlayer.getWeight()
            local check =
                MySQL.Sync.fetchAll(
                "SELECT * FROM items WHERE name = @name",
                {
                    ["@name"] = item
                }
            )
            local weightitem = check[1].weight
            if Weight[targetplayer] ~= nil then
                if tonumber(targetplayerweight + weightitem) >= tonumber(Weight[targetplayer]) then
                    xPlayer.removeInventoryItem(item, tonumber(anzahl))
                    targetplayer.addInventoryItem(item, tonumber(anzahl))
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Inventory",
                        "Erfolgreicher Transfer!",
                        2000
                    )
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        tonumber(id),
                        "Inventory",
                        "Dir wurden " .. check[1].label .. "x" .. anzahl .. "zugesteckt",
                        2000
                    )
                end
            else
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Inventory",
                    "Es ist ein Fehler aufgetreten!",
                    2000
                )
            end
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Inventory",
                "Du besitzt so viel vom dem nicht!",
                2000
            )
        end
    end
)
RegisterServerEvent("SevenLife:Inventory:OpenInvDurchsuchen")
AddEventHandler(
    "SevenLife:Inventory:OpenInvDurchsuchen",
    function(targetid)
        local xtarget = ESX.GetPlayerFromId(targetid)
        local xPlayer = ESX.GetPlayerFromId(source)
        local targetinventory = xtarget.inventory
        local inv = xPlayer.inventory
        local weight = xPlayer.getWeight()
        TriggerClientEvent("SevenLife:Inventory:ShowPlayerInv", source, inv, weight, targetinventory, targetid)
        TriggerClientEvent("SevenLife:TimetCustom:Notify", targetid, "Durchsuchung", "Du wist durchsucht!", 2000)
    end
)
RegisterServerEvent("SevenLife:Inventory:giveitemtoplayerdurchsuchen")
AddEventHandler(
    "SevenLife:Inventory:giveitemtoplayerdurchsuchen",
    function(item, anzahl, label, targetid)
        local xtarget = ESX.GetPlayerFromId(targetid)
        local xPlayer = ESX.GetPlayerFromId(source)
        local targetplayer = ESX.GetPlayerFromId(tonumber(id))
        local itemcount = xPlayer.getInventoryItem(item).count
        if tonumber(itemcount) >= tonumber(anzahl) then
            local targetplayerweight = xPlayer.getWeight()
            local check =
                MySQL.Sync.fetchAll(
                "SELECT * FROM items WHERE name = @name",
                {
                    ["@name"] = item
                }
            )
            local weightitem = check[1].weight
            if Weight[targetplayer] ~= nil then
                if tonumber(targetplayerweight + weightitem) >= tonumber(Weight[targetplayer]) then
                    xPlayer.removeInventoryItem(item, tonumber(anzahl))
                    targetplayer.addInventoryItem(item, tonumber(anzahl))
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Inventory",
                        "Erfolgreicher Transfer!",
                        2000
                    )
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        tonumber(id),
                        "Inventory",
                        "Dir wurden " .. check[1].label .. "x" .. anzahl .. "zugesteckt",
                        2000
                    )
                end
            else
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Inventory",
                    "Es ist ein Fehler aufgetreten!",
                    2000
                )
            end
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Inventory",
                "Du besitzt so viel vom dem nicht!",
                2000
            )
        end
    end
)
RegisterServerEvent("SevenLife:Inventory:getitemfromplayer")
AddEventHandler(
    "SevenLife:Inventory:getitemfromplayer",
    function(item, anzahl, label, targetid)
        local xtarget = ESX.GetPlayerFromId(targetid)
        local xPlayer = ESX.GetPlayerFromId(source)
        local targetplayer = ESX.GetPlayerFromId(tonumber(id))
        local itemcount = xPlayer.getInventoryItem(item).count
        if tonumber(itemcount) >= tonumber(anzahl) then
            local targetplayerweight = xPlayer.getWeight()
            local check =
                MySQL.Sync.fetchAll(
                "SELECT * FROM items WHERE name = @name",
                {
                    ["@name"] = item
                }
            )
            local weightitem = check[1].weight
            if Weight[targetplayer] ~= nil then
                if tonumber(targetplayerweight + weightitem) >= tonumber(Weight[targetplayer]) then
                    xPlayer.addInventoryItem(item, tonumber(anzahl))
                    targetplayer.removeInventoryItem(item, tonumber(anzahl))
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Inventory",
                        "Erfolgreicher Transfer!",
                        2000
                    )
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        tonumber(id),
                        "Inventory",
                        "Dir wurden " .. check[1].label .. "x" .. anzahl .. "zugesteckt",
                        2000
                    )
                end
            else
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Inventory",
                    "Es ist ein Fehler aufgetreten!",
                    2000
                )
            end
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Inventory",
                "Du besitzt so viel vom dem nicht!",
                2000
            )
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Inventar:CheckIfCarHaveEnoughSpace",
    function(source, cb, plate, slots)
        local plate = string.gsub(plate, "%s+", "")
        print(plate)
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM trunkitems WHERE plate = @plate",
            {
                ["@plate"] = plate
            }
        )

        local itemcount = 0
        for k, v in pairs(check) do
            itemcount = itemcount + 1
        end

        if itemcount == slots then
            cb(false)
        else
            cb(true)
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Inventar:CheckIfCarHaveEnoughSpaceGlove",
    function(source, cb, plate, slots)
        local plate = string.gsub(plate, "%s+", "")
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM gloveboxitems WHERE plate = @plate",
            {
                ["@plate"] = plate
            }
        )
        local itemcount = 0
        for k, v in pairs(check) do
            itemcount = itemcount + 1
        end

        if itemcount == slots then
            cb(false)
        else
            cb(true)
        end
    end
)
