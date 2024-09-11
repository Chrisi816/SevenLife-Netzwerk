ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("sevenlife:getdatsssa")
AddEventHandler(
    "sevenlife:getdatsssa",
    function(sources, source)
        local _source = source
        local xPlayer = sources
        local kredit
        local cash = xPlayer.getAccount("bank").money
        if cash >= 0 and cash <= 10000 then
            kredit = "12300"
        else
            if cash >= 10001 and cash <= 50000 then
                kredit = "34000"
            else
                if cash >= 50001 and cash <= 100000 then
                    kredit = "99600"
                else
                    if cash >= 100001 and cash <= 200000 then
                        kredit = "150030"
                    else
                        if cash >= 200001 and cash <= 1000000 then
                            kredit = "300000"
                        else
                            if cash >= 1000001 and cash <= 5000000 then
                                kredit = "550500"
                            else
                                if cash >= 5000001 then
                                    kredit = 743200
                                end
                            end
                        end
                    end
                end
            end
        end
        TriggerClientEvent("sevenlife:transferdata", _source, cash, kredit)
    end
)
-----------------------------------------------------------------------------------------------------
--                                        Auszahlen
-----------------------------------------------------------------------------------------------------
RegisterServerEvent("sevenlife:gibgeld")
AddEventHandler(
    "sevenlife:gibgeld",
    function(howmany)
        local xPlayer = ESX.GetPlayerFromId(source)
        amount = tonumber(howmany)
        accountbase = xPlayer.getAccount("bank").money
        if amount == nil or amount <= 0 or amount > accountbase then
            TriggerClientEvent("sevenlife:bank:fehler", source, "Du hast kein Geld auf der Bank")
        else
            xPlayer.removeAccountMoney("bank", amount)
            xPlayer.addMoney(amount)
            TriggerClientEvent("sevenlife:okey ", source)
        end
    end
)
-----------------------------------------------------------------------------------------------------
--                                        Einzahlen
-----------------------------------------------------------------------------------------------------
RegisterServerEvent("sevenlife:nehmgeld")
AddEventHandler(
    "sevenlife:nehmgeld",
    function(howmany)
        howmany = tonumber(howmany)
        local xPlayer = ESX.GetPlayerFromId(source)
        if howmany == nil or howmany <= 0 or howmany > xPlayer.getMoney() then
            TriggerClientEvent("sevenlife:bank:fehler", source, "Der Automat ist momentan nicht erreichbar ")
        else
            xPlayer.removeMoney(howmany)
            xPlayer.addAccountMoney("bank", howmany)
            TriggerClientEvent("sevenlife:okey ", source)
        end
    end
)
-----------------------------------------------------------------------------------------------------
--                                       Data
-----------------------------------------------------------------------------------------------------
RegisterServerEvent("sevenlife:accepteddata")
AddEventHandler(
    "sevenlife:accepteddata",
    function(vorname, nachname, geburtsort)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM accountsavings WHERE id = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] == nil then
                    MySQL.Async.fetchAll(
                        "INSERT INTO accountsavings (id, vorname, nachname, geburtsort) VALUES (@id, @vorname, @nachname, @geburtsort)",
                        {
                            ["@id"] = identifiers,
                            ["@vorname"] = vorname,
                            ["@nachname"] = nachname,
                            ["@geburtsort"] = geburtsort
                        },
                        function(result)
                        end
                    )
                else
                    TriggerClientEvent("sevenlife:closeall", -1)
                end
            end
        )
    end
)
-----------------------------------------------------------------------------------------------------
--                                    Insert a Iban
-----------------------------------------------------------------------------------------------------

RegisterServerEvent("sevenlife:registerIban")
AddEventHandler(
    "sevenlife:registerIban",
    function()
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local pin = "1234"
        local Ibannumber1 = math.random(1, 9)
        local Ibannumber2 = math.random(1, 9)
        local Ibannumber3 = math.random(1, 9)
        local Ibannumber4 = math.random(1, 9)
        local Ibannumber21 = math.random(1, 9)
        local Ibannumber22 = math.random(1, 9)
        local Ibannumber23 = math.random(1, 9)
        local Ibannumber24 = math.random(1, 9)
        local fullyiban =
            Ibannumber1 ..
            Ibannumber2 ..
                Ibannumber3 .. Ibannumber4 .. "-" .. Ibannumber21 .. Ibannumber22 .. Ibannumber23 .. Ibannumber24
        MySQL.Async.fetchAll(
            "SELECT * FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1].Iban == nil then
                    MySQL.Async.execute(
                        "UPDATE users SET iban = @Iban WHERE identifier = @identifier ",
                        {
                            ["@identifier"] = identifiers,
                            ["@Iban"] = fullyiban
                        },
                        function(result)
                        end
                    )
                else
                    TriggerClientEvent("sevenlife:closeall", _source)
                end
            end
        )
    end
)
-----------------------------------------------------------------------------------------------------
--                                   Check Status of Bank
-----------------------------------------------------------------------------------------------------

RegisterNetEvent("sevenlife:checkstatus")
AddEventHandler(
    "sevenlife:checkstatus",
    function()
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        local cash = xPlayer.getAccount("bank").money
        MySQL.Async.fetchAll(
            "SELECT * FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1].iban == nil then
                    TriggerClientEvent(
                        "sevenlife:firstbank",
                        _source,
                        "yes",
                        result[1].firstname,
                        cash,
                        Config.Inflation,
                        "Wird Berechnet..."
                    )
                else
                    TriggerEvent("sevenlife:getdatsssa", xPlayer, _source)
                end
            end
        )
    end
)
-----------------------------------------------------------------------------------------------------
--                                   Check if Player have a Konto
-----------------------------------------------------------------------------------------------------
RegisterNetEvent("sevenlife:checkstatuszwei")
AddEventHandler(
    "sevenlife:checkstatuszwei",
    function()
        local _source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.fetchAll(
            "SELECT * FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1].iban == nil then
                    TriggerClientEvent("sevenlife:showdontaccount", _source)
                else
                    TriggerEvent("sevenlife:findoutdata", xPlayer, _source)
                end
            end
        )
    end
)
-----------------------------------------------------------------------------------------------------
--                                   Find out about data
-----------------------------------------------------------------------------------------------------
RegisterNetEvent("sevenlife:findoutdata")
AddEventHandler(
    "sevenlife:findoutdata",
    function(xPlayer, source)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local cash = xPlayer.getAccount("bank").money
        local handcash = xPlayer.getAccount("money").money
        MySQL.Async.fetchAll(
            "SELECT * FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                TriggerClientEvent(
                    "sevenlife:opennormalbankmenu",
                    _source,
                    cash,
                    handcash,
                    result[1].iban,
                    result[1].firstname
                )
            end
        )
    end
)

RegisterServerEvent("sevenlife:nehmgelds")
AddEventHandler(
    "sevenlife:nehmgelds",
    function(howmany)
        howmany = tonumber(howmany)
        local xPlayer = ESX.GetPlayerFromId(source)
        if howmany == nil or howmany <= 0 or howmany > xPlayer.getMoney() then
            TriggerClientEvent("sevenlife:bank:fehler", source, "Der Automat ist momentan nicht erreichbar ")
        else
            xPlayer.removeMoney(howmany)
        end
    end
)
