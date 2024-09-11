--------------------------------------------------------------------------------------------------------------
------------------------------------------------Local ESX-----------------------------------------------------
--------------------------------------------------------------------------------------------------------------
ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
local itemsmarkers = {}
ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:Buyvehicle",
    function(source, cb, price)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local bankMoney = xPlayer.getAccount("bank").money
        local price = tonumber(price)

        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            cb(true)
        else
            if bankMoney >= price then
                xPlayer.setAccountMoney("bank", bankMoney - price)
                cb(true)
            else
                cb(false)
            end
        end
    end
)

RegisterServerEvent("SevenLife:Mechaniker:AddCard")
AddEventHandler(
    "SevenLife:Mechaniker:AddCard",
    function(vehicleProps, id, types)
        local _source = source

        MySQL.Async.execute(
            "INSERT INTO owned_vehicles (owner, plate, vehicle, type, vehicleid) VALUES (@owner, @plate, @vehicle, @type, @vehicleid)",
            {
                ["@owner"] = "Mechaniker",
                ["@plate"] = vehicleProps.plate,
                ["@vehicle"] = json.encode(vehicleProps),
                ["@type"] = types,
                ["@vehicleid"] = id
            },
            function()
                TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Du hast das Auto erfolgreich gekauft")
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:GetGarageCars",
    function(source, cb)
        local ownedCars = {}

        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE owner = @owner AND `stored` = 1",
            {
                ["@owner"] = "Mechaniker"
            },
            function(results)
                if results[1] ~= nil then
                    for _, v in pairs(results) do
                        if v.type == "car" then
                            local vehicle = json.decode(v.vehicle)
                            table.insert(
                                ownedCars,
                                {vehicle = vehicle, stored = v.stored, plate = v.plate, fuel = v.fuel}
                            )
                        end
                    end
                    cb(ownedCars)
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:GetItemImLager",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM mechaniker_lager",
            {},
            function(result)
                cb(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:GetReadyItems",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM mechaniker_werkzeug",
            {},
            function(result)
                cb(result)
            end
        )
    end
)

RegisterServerEvent("SevenLife:Mechaniker:GiveItem")
AddEventHandler(
    "SevenLife:Mechaniker:GiveItem",
    function(item)
        local xPlayer = ESX.GetPlayerFromId(source)
        print("hey")
        if item == "repairkit" or item == "lackierung" then
            MySQL.Async.fetchAll(
                "SELECT * FROM mechaniker_werkzeug WHERE name = @name",
                {
                    ["@name"] = item
                },
                function(results)
                    MySQL.Async.execute(
                        "UPDATE mechaniker_werkzeug SET amount = @amount WHERE name = @name",
                        {
                            ["@name"] = item,
                            ["@amount"] = results[1].amount - 1
                        },
                        function(result)
                            xPlayer.addInventoryItem(item, 1)
                        end
                    )
                end
            )
        else
            MySQL.Async.fetchAll(
                "SELECT * FROM mechaniker_lager WHERE name = @name",
                {
                    ["@name"] = item
                },
                function(results)
                    print(results[1].amount)
                    MySQL.Async.execute(
                        "UPDATE mechaniker_lager SET amount = @amount WHERE name = @name",
                        {
                            ["@name"] = item,
                            ["@amount"] = results[1].amount - 1
                        },
                        function(result)
                            xPlayer.addInventoryItem(item, 1)
                        end
                    )
                end
            )
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:CheckIfEnoughInLagerOrGerät",
    function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        if item == "repairkit" or item == "lackierung" then
            MySQL.Async.fetchAll(
                "SELECT * FROM mechaniker_werkzeug WHERE name = @name",
                {
                    ["@name"] = item
                },
                function(results)
                    if results[1].amount >= 1 then
                        cb(true)
                    else
                        cb(false)
                    end
                end
            )
        else
            MySQL.Async.fetchAll(
                "SELECT * FROM mechaniker_lager WHERE name = @name",
                {
                    ["@name"] = item
                },
                function(results)
                    if results[1].amount >= 1 then
                        cb(true)
                    else
                        cb(false)
                    end
                end
            )
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:GetItemsFarbeMix",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local itemcount = xPlayer.getInventoryItem("lackierung").count
        if itemcount >= 1 then
            xPlayer.removeInventoryItem("lackierung", 1)
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:Mechaniker:GiveMixedFarbeItem")
AddEventHandler(
    "SevenLife:Mechaniker:GiveMixedFarbeItem",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("mixedlakeriung", 1)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:GetInventoryItems",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local inv = xPlayer.inventory
        cb(inv)
    end
)

RegisterServerEvent("SevenLife:Mechaniker:AddLagerItem")
AddEventHandler(
    "SevenLife:Mechaniker:AddLagerItem",
    function(item)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(item, 1)
        if item == "repairkit" or item == "lackierung" then
            MySQL.Async.fetchAll(
                "SELECT * FROM mechaniker_werkzeug WHERE name = @name",
                {
                    ["@name"] = item
                },
                function(results)
                    MySQL.Async.execute(
                        "UPDATE mechaniker_werkzeug SET amount = @amount WHERE name = @name",
                        {
                            ["@name"] = item,
                            ["@amount"] = results[1].amount + 1
                        },
                        function(result)
                        end
                    )
                end
            )
        else
            MySQL.Async.fetchAll(
                "SELECT * FROM mechaniker_lager WHERE name = @name",
                {
                    ["@name"] = item
                },
                function(results)
                    MySQL.Async.execute(
                        "UPDATE mechaniker_lager SET amount = @amount WHERE name = @name",
                        {
                            ["@name"] = item,
                            ["@amount"] = results[1].amount + 1
                        },
                        function(result)
                        end
                    )
                end
            )
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:GetInventoryMixedItem",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local item = xPlayer.getInventoryItem("mixedlakeriung").count
        if item >= 1 then
            cb(true)
        else
            cb(false)
        end
    end
)
RegisterServerEvent("SevenLife:Mechanik:SafeVehicle")
AddEventHandler(
    "SevenLife:Mechanik:SafeVehicle",
    function(vehicleprop)
        SaveVehicle(vehicleprop, source)
    end
)

function SaveVehicle(vehprops, source)
    MySQL.Async.fetchAll(
        "SELECT vehicle FROM owned_vehicles WHERE plate = @plate",
        {
            ["@plate"] = vehprops.plate
        },
        function(result)
            if result[1] then
                local vehicle = json.decode(result[1].vehicle)

                if vehprops.model == vehicle.model then
                    MySQL.Async.execute(
                        "UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate",
                        {
                            ["@plate"] = vehprops.plate,
                            ["@vehicle"] = json.encode(vehprops)
                        }
                    )
                else
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        source,
                        "Der Spieler welchem das Auto gehört ist höchst wahrscheinlich ein Cheater, melde dies umgehend im Support oder via Ticket, solltest du das nicht tun, wirst du mit bestraft als mittäter"
                    )
                end
            end
        end
    )
end
RegisterServerEvent("SevenLife:PayandremoveMixed")
AddEventHandler(
    "SevenLife:PayandremoveMixed",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("mixedlakeriung", 1)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:GetRechnungen",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM bill_options WHERE firma = @firma ",
            {
                ["@firma"] = "Mechaniker"
            },
            function(result)
                cb(result)
            end
        )
    end
)

RegisterServerEvent("SevenLife:Mechaniker:SetLohn")
AddEventHandler(
    "SevenLife:Mechaniker:SetLohn",
    function(types, lohn)
        local _source = source
        MySQL.Async.execute(
            "UPDATE job_grades SET salary = @salary WHERE name = @name",
            {
                ["@salary"] = lohn,
                ["@name"] = types
            },
            function()
                TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Erfolgreich Lohn geändert")
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:GetAngestellte",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT identifier, name, job_grade FROM users WHERE job = @firma ",
            {
                ["@firma"] = "mechaniker"
            },
            function(result)
                cb(result)
            end
        )
    end
)

RegisterServerEvent("SevenLife:Mechaniker:RankUp")
AddEventHandler(
    "SevenLife:Mechaniker:RankUp",
    function(id)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT job_grade FROM users WHERE identifier = @identifier ",
            {
                ["@identifier"] = id
            },
            function(result)
                if result[1].job_grade < 4 then
                    local results = result[1].job_grade
                    MySQL.Async.execute(
                        "UPDATE users SET job_grade = @job_grade WHERE identifier = @identifier",
                        {
                            ["@job_grade"] = results + 1,
                            ["@identifier"] = id
                        },
                        function()
                            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Spieler erfolgreich gefeuert")
                        end
                    )
                else
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Spieler kann nicht zum Chef befördert werden "
                    )
                end
            end
        )
    end
)
RegisterServerEvent("SevenLife:Mechaniker:DeRank")
AddEventHandler(
    "SevenLife:Mechaniker:DeRank",
    function(id)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT job_grade FROM users WHERE identifier = @identifier ",
            {
                ["@identifier"] = id
            },
            function(result)
                if result[1].job_grade >= 2 then
                    local results = result[1].job_grade
                    MySQL.Async.execute(
                        "UPDATE users SET job_grade = @job_grade WHERE identifier = @identifier",
                        {
                            ["@job_grade"] = results - 1,
                            ["@identifier"] = id
                        },
                        function()
                            TriggerClientEvent(
                                "SevenLife:TimetCustom:NotifySevenLife:TimetCustom:Notify",
                                _source,
                                "Spieler erfolgreich De - ranked"
                            )
                        end
                    )
                else
                    if result[1].job_grade == 1 then
                        MySQL.Async.execute(
                            "UPDATE users SET job_grade = @job_grade, job = @job WHERE identifier = @identifier",
                            {
                                ["@job_grade"] = 0,
                                ["@job"] = "unemployed",
                                ["@identifier"] = id
                            },
                            function()
                                TriggerClientEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    _source,
                                    "Spieler erfolgreich gefeuert"
                                )
                            end
                        )
                    end
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Mechaniker:Feuern")
AddEventHandler(
    "SevenLife:Mechaniker:Feuern",
    function(id)
        local _source = source

        MySQL.Async.execute(
            "UPDATE users SET job_grade = @job_grade, job = @job WHERE identifier = @identifier",
            {
                ["@job_grade"] = 0,
                ["@job"] = "unemployed",
                ["@identifier"] = id
            },
            function()
                TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Erfolgreich gefeuert")
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:GetMechanikerGeld",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM mechaniker_cash WHERE name = @name ",
            {
                ["@name"] = "mechaniker"
            },
            function(result)
                cb(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:GetMembersNumber",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT identifier FROM users WHERE job = @job ",
            {
                ["@job"] = "mechaniker"
            },
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Mechaniker:Einzahlen")
AddEventHandler(
    "SevenLife:Mechaniker:Einzahlen",
    function(cash)
        local cash = tonumber(cash)
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        local cash2 = xPlayer.getAccount("money").money
        if cash2 >= cash then
            MySQL.Async.fetchAll(
                "SELECT * FROM mechaniker_cash WHERE name = @name ",
                {
                    ["@name"] = "mechaniker"
                },
                function(result)
                    MySQL.Async.execute(
                        "UPDATE mechaniker_cash SET money = @money WHERE name = @name",
                        {
                            ["@money"] = result[1].money + cash,
                            ["@name"] = "mechaniker"
                        },
                        function()
                            xPlayer.removeAccountMoney("money", cash)
                            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Geld Erfolgreich eingezahlt")
                        end
                    )
                end
            )
        else
            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Du besitzt zu wenig Geld!")
        end
    end
)
RegisterServerEvent("SevenLife:Mechaniker:Auszahlen")
AddEventHandler(
    "SevenLife:Mechaniker:Auszahlen",
    function(cash)
        local xPlayer = ESX.GetPlayerFromId(source)
        local cash = tonumber(cash)
        local _source = source

        MySQL.Async.fetchAll(
            "SELECT * FROM mechaniker_cash WHERE name = @name ",
            {
                ["@name"] = "mechaniker"
            },
            function(result)
                local money = tonumber(result[1].money)
                if money >= cash then
                    MySQL.Async.execute(
                        "UPDATE mechaniker_cash SET money = @money WHERE name = @name",
                        {
                            ["@money"] = result[1].money - cash,
                            ["@name"] = "mechaniker"
                        },
                        function()
                            xPlayer.addAccountMoney("money", cash)
                            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Geld Erfolgreich abgehoben")
                        end
                    )
                else
                    TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Dein Business besitztz zu wenig Geld")
                end
            end
        )
    end
)
RegisterServerEvent("SevenLife:Mechaniker:MakeBill")
AddEventHandler(
    "SevenLife:Mechaniker:MakeBill",
    function(id, label, reason, amount)
        local _source = source
        local xTarget = ESX.GetPlayerFromId(id)
        local amount = tonumber(amount)
        if amount < 0 then
            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Du musst über 0 Euro als Rechnung eingeben")
        else
            if xTarget ~= nil then
                MySQL.Async.execute(
                    "INSERT INTO bill_options (identifier, title, reason, price, stand, firma) VALUES (@identifier, @title, @reason, @price, @stand, @firma)",
                    {
                        ["@identifier"] = xTarget.identifier,
                        ["@title"] = label,
                        ["@reason"] = reason,
                        ["@price"] = amount,
                        ["@stand"] = "notpaid",
                        ["@firma"] = "mechaniker"
                    },
                    function()
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            xTarget.source,
                            "Du hast eine Rechnung in höche von " .. amount .. "bekommen"
                        )
                    end
                )
            else
                TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Es gibt keinem Spieler in deiner Nähe")
            end
        end
    end
)

RegisterServerEvent("SevenLife:Mechaniker:ClearList")
AddEventHandler(
    "SevenLife:Mechaniker:ClearList",
    function()
        itemsmarkers = {}
    end
)

RegisterServerEvent("SevenLife:Mechaniker:BuyUpgrades")
AddEventHandler(
    "SevenLife:Mechaniker:BuyUpgrades",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        for k, v in pairs(itemsmarkers) do
            xPlayer.removeInventoryItem(v, 1)
        end

        MySQL.Async.fetchAll(
            "SELECT * FROM mechaniker_cash WHERE name = @name ",
            {
                ["@name"] = "mechaniker"
            },
            function(result)
                MySQL.Async.execute(
                    "UPDATE mechaniker_cash SET money = @money WHERE name = @name",
                    {
                        ["@money"] = result[1].money - 100,
                        ["@name"] = "mechaniker"
                    },
                    function()
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Upgrades für 100$ Erfolgreich gekauft"
                        )
                    end
                )
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:GetItemForUpgrade",
    function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local numberofitem = xPlayer.getInventoryItem(item).count
        if has_value(itemsmarkers, item) then
            print("hey")
        else
            table.insert(itemsmarkers, item)
        end

        if numberofitem >= 1 then
            cb(true)
        else
            cb(false)
        end
    end
)

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

RegisterServerEvent("SevenLife:Mechaniker:GiveRepairKit")
AddEventHandler(
    "SevenLife:Mechaniker:GiveRepairKit",
    function(isinmarker)
        local xPlayer = ESX.GetPlayerFromId(source)
        if isinmarker == true then
            xPlayer.addInventoryItem("repairkit", 1)
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Mechaniker:GetLohn",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM job_grades WHERE job_name = @job_name ",
            {
                ["@job_name"] = "mechaniker"
            },
            function(result)
                cb(result)
            end
        )
    end
)
