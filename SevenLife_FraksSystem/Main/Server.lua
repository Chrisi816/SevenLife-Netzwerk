ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
RegisterServerEvent("SevenLife:FrakInvite:ShowPlayerInvite")
AddEventHandler(
    "SevenLife:FrakInvite:ShowPlayerInvite",
    function(id, fraktion, name)
        local _source = source
        TriggerClientEvent("SevenLife:FrakInvite:ShowInviteClient", id, fraktion, name, _source)
    end
)
RegisterServerEvent("SevenLife:FrakInvite:GiveJob")
AddEventHandler(
    "SevenLife:FrakInvite:GiveJob",
    function(job, id)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = string.lower(job)

        xPlayer.setJob(job, 0)
        TriggerClientEvent("SevenLife:Inventory:CloseInventoryTrunk", id, "Der Spieler hat deine Einladung angenommen")
    end
)
RegisterServerEvent("SevenLife:FrakInvite:GiveNotify")
AddEventHandler(
    "SevenLife:FrakInvite:GiveNotify",
    function(id)
        TriggerClientEvent("SevenLife:Inventory:CloseInventoryTrunk", id, "Der Spieler hat deine Einladung abgelehnt")
    end
)
ESX.RegisterServerCallback(
    "SevenLife:FrakSystem:GetInfoAboutFamilie",
    function(source, cb, frak)
        local result =
            MySQL.Sync.fetchAll(
            "SELECT * FROM fraktionen WHERE frak = @frak",
            {
                ["@frak"] = frak
            },
            function(result)
            end
        )
        local onlinepersonenvalue =
            MySQL.Sync.fetchAll(
            "SELECT * FROM fraktionenmitglieder WHERE frak = @frak",
            {
                ["@frak"] = frak
            }
        )
        local onlinepersonen = 0
        for k, v in pairs(onlinepersonenvalue) do
            local id = GetServerIdFromIdentifier(v.identifier)
            if id ~= nil then
                onlinepersonen = onlinepersonen + 1
            end
        end
        cb(result, onlinepersonen)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Frak:GetInfosAboutMitglider",
    function(source, cb, frak)
        local result =
            MySQL.Sync.fetchAll(
            "SELECT * FROM fraktionenmitglieder WHERE frak = @frak",
            {
                ["@frak"] = frak
            }
        )

        local list = {}
        local onlinepersonen = 0
        local playerinsgesamt = 0

        for k, v in pairs(result) do
            playerinsgesamt = playerinsgesamt + 1
            local online = "OFFLINE"
            local id = GetServerIdFromIdentifier(v.identifier)
            if id ~= nil then
                online = "ONLINE"
                onlinepersonen = onlinepersonen + 1
            end
            if v ~= nil then
                list[k] = {}
                list[k].id = v.id
                list[k].frak = v.frak
                list[k].iduniqe = v.iduniqe
                list[k].identifier = v.identifier
                list[k].name = v.name
                list[k].online = online
                list[k].rang = v.rang
                list[k].datajoin = v.datajoin
            end
        end

        cb(list, onlinepersonen, playerinsgesamt)
    end
)
function GetIdentifier(playerId)
    for k, v in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.match(v, "license:") then
            local identifier = string.gsub(v, "license:", "")
            return identifier
        end
    end
end

function GetServerIdFromIdentifier(identifier)
    local wanted_id = nil

    for k, v in pairs(GetPlayers()) do
        local id = tonumber(v)
        if GetIdentifier(id) == identifier then
            wanted_id = id
        end
    end

    return wanted_id
end
ESX.RegisterServerCallback(
    "SevenLife:Fraktionen:GetGarageCars",
    function(source, cb, frak)
        local ownedCars = {}

        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE owner = @owner AND `stored` = 1",
            {
                ["@owner"] = frak
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
RegisterServerEvent("SevenLife:Fraktion:AddCard")
AddEventHandler(
    "SevenLife:Fraktion:AddCard",
    function(frak, vehicleProps, id, types)
        local _source = source

        MySQL.Async.execute(
            "INSERT INTO owned_vehicles (owner, plate, vehicle, type, vehicleid) VALUES (@owner, @plate, @vehicle, @type, @vehicleid)",
            {
                ["@owner"] = frak,
                ["@plate"] = vehicleProps.plate,
                ["@vehicle"] = json.encode(vehicleProps),
                ["@type"] = types,
                ["@vehicleid"] = id
            },
            function()
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Information",
                    "Du hast das Auto erfolgreich gekauft"
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Fraktion:Buyvehicle",
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
ESX.RegisterServerCallback(
    "SevenLife:Fraktionen:CheckIfInFrak",
    function(source, cb, frak)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local result =
            MySQL.Sync.fetchAll(
            "SELECT * FROM fraktionenmitglieder WHERE frak = @frak AND identifier = @identifier",
            {
                ["@frak"] = frak,
                ["@identifier"] = identifier
            }
        )
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
)
RegisterServerEvent("SevenLife:FraksSystem:BuyItem")
AddEventHandler(
    "SevenLife:FraksSystem:BuyItem",
    function(label, preis, rang)
        local _source = source
        local identifier = ESX.GetPlayerFromId(source).identifier
        if rang == "ALL" then
            local preis = tonumber(preis)
            local xPlayer = ESX.GetPlayerFromId(source)
            local money = xPlayer.getMoney()
            if tonumber(money) >= preis then
                xPlayer.removeAccountMoney("money", preis)
                xPlayer.addInventoryItem(label, 1)
                local moneys = xPlayer.getMoney()
                TriggerClientEvent("SevenLife:FraksSystem:Geld", source, moneys)
            end
        else
            local result =
                MySQL.Sync.fetchAll(
                "SELECT * FROM fraktionenmitglieder WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifier
                }
            )
            if result[1].rang == rang then
                local preis = tonumber(preis)
                local xPlayer = ESX.GetPlayerFromId(_source)
                local money = xPlayer.getMoney()
                if tonumber(money) >= preis then
                    xPlayer.removeAccountMoney("money", preis)
                    xPlayer.addInventoryItem(label, 1)
                    local moneys = xPlayer.getMoney()
                    TriggerClientEvent("SevenLife:FraksSystem:Geld", _source, moneys)
                end
            else
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Chat",
                    "Du brauchst mindestens den Rang " .. rang .. "!",
                    2000
                )
            end
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:FraksSystem:GetInfosForBossMenu",
    function(source, cb, frak)
        local _source = source
        local identifier = ESX.GetPlayerFromId(source).identifier
        local result =
            MySQL.Sync.fetchAll(
            "SELECT * FROM fraktionenmitglieder WHERE frak = @frak AND identifier = @identifier",
            {
                ["@frak"] = frak,
                ["@identifier"] = identifier
            }
        )
        local moneyresult =
            MySQL.Sync.fetchAll(
            "SELECT * FROM fraktionen WHERE frak = @frak ",
            {
                ["@frak"] = frak
            }
        )
        cb(result, moneyresult)
    end
)
RegisterServerEvent("SevenLife:FraksSystem:Einzahlen")
AddEventHandler(
    "SevenLife:FraksSystem:Einzahlen",
    function(cash, frak)
        local cash = tonumber(cash)
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        local cash2 = xPlayer.getAccount("money").money
        if cash2 >= cash then
            MySQL.Async.fetchAll(
                "SELECT * FROM fraktionen WHERE frak = @frak ",
                {
                    ["@frak"] = frak
                },
                function(result)
                    MySQL.Async.execute(
                        "UPDATE fraktionen SET reichtum = @reichtum WHERE frak = @frak",
                        {
                            ["@reichtum"] = result[1].reichtum + cash,
                            ["@frak"] = frak
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
RegisterServerEvent("SevenLife:FraksSystem:Auszahlen")
AddEventHandler(
    "SevenLife:FraksSystem:Auszahlen",
    function(cash, frak)
        local xPlayer = ESX.GetPlayerFromId(source)
        local cash = tonumber(cash)
        local _source = source

        MySQL.Async.fetchAll(
            "SELECT * FROM fraktionen WHERE frak = @frak ",
            {
                ["@frak"] = frak
            },
            function(result)
                local money = tonumber(result[1].reichtum)
                if money >= cash then
                    MySQL.Async.execute(
                        "UPDATE fraktionen SET reichtum = @reichtum WHERE frak = @frak",
                        {
                            ["@reichtum"] = result[1].reichtum - cash,
                            ["@frak"] = frak
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
ESX.RegisterServerCallback(
    "SevenLife:FraksSystem:GetLohn",
    function(source, cb, frak)
        MySQL.Async.fetchAll(
            "SELECT * FROM job_grades WHERE job_name = @job_name ",
            {
                ["@job_name"] = frak
            },
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("SevenLife:FraksSystem:SetLohn")
AddEventHandler(
    "SevenLife:FraksSystem:SetLohn",
    function(types, lohn)
        local _source = source
        MySQL.Async.execute(
            "UPDATE job_grades SET salary = @salary WHERE label = @label",
            {
                ["@salary"] = lohn,
                ["@label"] = types
            },
            function()
                TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Erfolgreich Lohn geändert")
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:FraksSystem:GetAngestellte",
    function(source, cb, frak)
        MySQL.Async.fetchAll(
            "SELECT identifier, name, rang FROM fraktionenmitglieder WHERE frak = @frak ",
            {
                ["@frak"] = frak
            },
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("SevenLife:FraksSystem:RankUp")
AddEventHandler(
    "SevenLife:FraksSystem:RankUp",
    function(id, frak)
        local maxreange, Reange
        if frak == "LCN" then
            Reange = Config.Reange.LCN
            maxreange = Config.Mexreange.LCN
        end

        local _source = source
        MySQL.Async.fetchAll(
            "SELECT rang FROM fraktionenmitglieder WHERE identifier = @identifier ",
            {
                ["@identifier"] = id
            },
            function(result)
                print(Reange[maxreange])
                if result[1].rang ~= Reange[maxreange - 1] then
                    local rangid = 0
                    for k, v in pairs(Reange) do
                        if v == result[1].rang then
                            rangid = k
                        end
                    end

                    local results = rangid + 1
                    local name = Reange[results]
                    MySQL.Async.execute(
                        "UPDATE fraktionenmitglieder SET rang = @rang WHERE identifier = @identifier",
                        {
                            ["@rang"] = name,
                            ["@identifier"] = id
                        },
                        function()
                            TriggerClientEvent(
                                "SevenLife:TimetCustom:Notify",
                                _source,
                                "Spieler erfolgreich befördert!"
                            )
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
RegisterServerEvent("SevenLife:FraksSystem:DeRank")
AddEventHandler(
    "SevenLife:FraksSystem:DeRank",
    function(id, frak)
        local _source = source
        local Reange
        if frak == "LCN" then
            Reange = Config.Reange.LCN
        end

        MySQL.Async.fetchAll(
            "SELECT rang FROM fraktionenmitglieder WHERE identifier = @identifier ",
            {
                ["@identifier"] = id
            },
            function(result)
                if result[1].rang ~= Reange[0] then
                    local rangid = 0
                    for k, v in pairs(Reange) do
                        if v == result[1].rang then
                            rangid = k
                        end
                    end
                    print(rangid)
                    local results = rangid - 1
                    print(results)
                    local name = Reange[results]
                    MySQL.Async.execute(
                        "UPDATE fraktionenmitglieder SET rang = @rang WHERE identifier = @identifier",
                        {
                            ["@rang"] = name,
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
                    if result[1].rang == Reange[0] then
                        MySQL.Async.execute(
                            "DELETE FROM fraktionenmitglieder WHERE identifier = @identifier",
                            {
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

RegisterServerEvent("SevenLife:FraksSystem:Feuern")
AddEventHandler(
    "SevenLife:FraksSystem:Feuern",
    function(id)
        local _source = source

        MySQL.Async.execute(
            "DELETE FROM fraktionenmitglieder WHERE identifier = @identifier",
            {
                ["@identifier"] = id
            },
            function()
                TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Spieler erfolgreich gefeuert")
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:FraksSystem:CheckIfFraktionen",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM fraktionen ",
            {},
            function(result)
                cb(result)
            end
        )
    end
)

Citizen.CreateThread(
    function()
        while true do
            local currenttime = os.date("*t", os.time())
            if tonumber(currenttime["hour"]) == 21 and tonumber(currenttime["min"]) == 00 then
                local number = math.random(1, 3)
                TriggerClientEvent("SevenLife:StartMission", -1, number)
            end
            Citizen.Wait(60000)
        end
    end
)
