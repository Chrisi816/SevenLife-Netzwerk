ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

-- Account Checking
ESX.RegisterServerCallback(
    "SevenLife:Bank:CheckIfPlayerHaveBankAccount",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT iban FROM users WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(result)
                if result[1].iban == nil then
                    print("dey")
                    cb(false)
                else
                    cb(true)
                end
            end
        )
    end
)

-- Normal Bank Info
RegisterServerEvent("SevenLife:Bank:OpenNormalBankInfo")
AddEventHandler(
    "SevenLife:Bank:OpenNormalBankInfo",
    function()
        local identifier = ESX.GetPlayerFromId(source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)
        local bankmoney = xPlayer.getAccount("bank").money
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM users WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(result)
                TriggerClientEvent(
                    "SevenLife:Bank:OpenNormalBankEnd",
                    _source,
                    bankmoney,
                    result[1].iban,
                    result[1].name,
                    result[1].BankCard
                )
            end
        )
    end
)

RegisterServerEvent("SevenLife:Bank:nehmgeld")
AddEventHandler(
    "SevenLife:Bank:nehmgeld",
    function(howmany)
        howmany = tonumber(howmany)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        if howmany == nil or howmany <= 0 or howmany > xPlayer.getMoney() then
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Bank - Fehler",
                "Ein Fehler ist bei der Einzahlung passiert",
                "1500"
            )
        else
            xPlayer.removeMoney(howmany)
            xPlayer.addAccountMoney("bank", howmany)
            TriggerEvent("SevenLife:Bank:Addtransaktion", 1, howmany, "Aus", _source)
            TriggerClientEvent(
                "SevenLife:Handy:Message",
                source,
                "../src/appsymbols/bankAmerica.png",
                "Bank - Nachricht",
                "Geld in höhe von " .. howmany .. "$ abgehoben"
            )
        end
    end
)

RegisterServerEvent("SevenLife:Bank:gibgeld")
AddEventHandler(
    "SevenLife:Bank:gibgeld",
    function(howmany)
        local xPlayer = ESX.GetPlayerFromId(source)
        local amount = tonumber(howmany)
        print(amount)
        local accountbase = xPlayer.getAccount("bank").money
        local _source = source
        if amount == nil or amount > accountbase then
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Bank - Fehler",
                "Du besitzt zu wenig Geld auf der Bank",
                "1500"
            )
        else
            xPlayer.removeAccountMoney("bank", amount)
            xPlayer.addMoney(amount)
            TriggerEvent("SevenLife:Bank:Addtransaktion", 2, howmany, "Ein", _source)
            TriggerClientEvent(
                "SevenLife:Handy:Message",
                source,
                "../src/appsymbols/bankAmerica.png",
                "Bank - Nachricht",
                "Geld in höhe von " .. howmany .. "$ abgehoben"
            )
            local identifier = xPlayer.identifier
            local check =
                MySQL.Sync.fetchAll(
                "SELECT * FROM battlepassmissionen WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifier
                }
            )
            if check[1] ~= nil then
                if tonumber(check[1].index2) == 4 then
                    if amount >= 500 then
                        TriggerEvent("SevenLife:SeasonPass:MakeProgress", 2, true, _source)
                    end
                elseif tonumber(check[1].index2) == 5 then
                    if amount >= 1000 then
                        TriggerEvent("SevenLife:SeasonPass:MakeProgress", 2, true, _source)
                    end
                elseif tonumber(check[1].index2) == 6 then
                    if amount >= 2000 then
                        TriggerEvent("SevenLife:SeasonPass:MakeProgress", 2, true, _source)
                    end
                end
            end
        end
    end
)
RegisterServerEvent("SevenLife:Bank:Transferdata")
AddEventHandler(
    "SevenLife:Bank:Transferdata",
    function(anzahl, iban)
        local _source = source

        local xPlayer = ESX.GetPlayerFromId(source)
        local anzahl = tonumber(anzahl)
        xPlayer.removeAccountMoney("bank", anzahl)
        TriggerEvent("SevenLife:Bank:Addtransaktion", 2, anzahl, "Aus", _source)
        MySQL.Async.fetchAll(
            "SELECT transfermoney FROM users WHERE iban = @iban",
            {
                ["@iban"] = iban
            },
            function(result)
                if result[1].transfermoney == nil then
                    MySQL.Async.execute(
                        "UPDATE users SET transfermoney = @transfermoney WHERE iban = @iban",
                        {
                            ["@iban"] = iban,
                            ["@transfermoney"] = anzahl
                        },
                        function(result)
                        end
                    )
                else
                    local anzahls = result[1].transfermoney + anzahl
                    MySQL.Async.execute(
                        "UPDATE users SET transfermoney = @transfermoney WHERE iban = @iban",
                        {
                            ["@iban"] = iban,
                            ["@transfermoney"] = anzahls
                        },
                        function(result)
                            TriggerClientEvent(
                                "SevenLife:Handy:Message",
                                _source,
                                "../src/appsymbols/bankAmerica.png",
                                "Nachricht - Bank",
                                "Überweisung in höhe von " .. anzahl .. "$ erfolgreich"
                            )
                        end
                    )
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Bank:CheckIfPlayerHaveEnoughMoney",
    function(source, cb, anzahl)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        local cash = xPlayer.getAccount("bank").money
        local cashs = tonumber(cash)
        local anzahls = tonumber(anzahl)
        if cashs >= anzahls then
            cb(true)
        else
            cb(false)
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Bank:CheckifIbanExist",
    function(source, cb, iban)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM users WHERE iban = @iban",
            {
                ["@iban"] = iban
            },
            function(result)
                if result[1] == nil then
                    print("eins")
                    cb(false)
                else
                    cb(true)
                    print("zins")
                end
            end
        )
    end
)
RegisterServerEvent("SevenLife:Bank:GiveIBAN")
AddEventHandler(
    "SevenLife:Bank:GiveIBAN",
    function(iban)
        local identifiers = ESX.GetPlayerFromId(source).identifier

        TriggerClientEvent("SevenLife:Quest:UpdateIfPossible", source, 2)
        print(1)
        MySQL.Async.execute(
            "UPDATE users SET iban = @Iban WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifiers,
                ["@Iban"] = iban
            },
            function(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Bank:IsIbanTaken",
    function(source, cb, iban)
        MySQL.Async.fetchAll(
            "SELECT * FROM users WHERE iban = @iban",
            {
                ["@iban"] = iban
            },
            function(result)
                cb(result[1] ~= nil)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Bank:CheckIfPlayerHaveCard",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT BankCard FROM users WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(result)
                cb(result[1].BankCard)
            end
        )
    end
)

RegisterServerEvent("SevenLife:Bank:GiveCard")
AddEventHandler(
    "SevenLife:Bank:GiveCard",
    function(types, preis)
        local typ = tonumber(types)
        local _source = source
        local identifier = ESX.GetPlayerFromId(source).identifier
        preis = tonumber(preis)
        local xPlayer = ESX.GetPlayerFromId(source)
        local accountbank = xPlayer.getAccount("bank").money
        print(preis)
        if preis == nil or preis > accountbank then
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Bank - Fehler",
                "Du besitzt zu wenig Geld auf der Bank",
                "1500"
            )
        else
            xPlayer.removeAccountMoney("bank", preis)
            MySQL.Async.execute(
                "UPDATE users SET BankCard = @BankCard WHERE identifier = @identifier ",
                {
                    ["@identifier"] = identifier,
                    ["@BankCard"] = typ
                },
                function(result)
                    TriggerClientEvent(
                        "SevenLife:Handy:Message",
                        _source,
                        "../src/appsymbols/bankAmerica.png",
                        "Nachricht - Bank",
                        "Bankarte erfolgreich gewechselt"
                    )
                end
            )
        end
    end
)

RegisterServerEvent("SevenLife:Bank:Addtransaktion")
AddEventHandler(
    "SevenLife:Bank:Addtransaktion",
    function(typ, geld, who, source)
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.execute(
            "INSERT INTO transaktion_logs (identifier, typ, geld, who) VALUES (@Identifier,@typ,@geld,@who)",
            {
                ["@Identifier"] = identifier,
                ["@typ"] = typ,
                ["@geld"] = geld,
                ["@who"] = who
            }
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Bank:GetTransaktionsdata",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM transaktion_logs WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(result)
                cb(result)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Bank:CheckIfAccountExists",
    function(source, cb, benutzer, passwort)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM cryptos WHERE benutzername = @benutzername and passwort = @passwort and id = @id ",
            {["@id"] = player, ["@benutzername"] = benutzer, ["@passwort"] = passwort},
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
    "SevenLife:Bank:CheckInfos",
    function(source, cb)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM cryptos WHERE id = @identifier",
            {["@identifier"] = player},
            function(result)
                cb(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Bank:CheckInfos2",
    function(source, cb)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM crypto_handelszentrum",
            {},
            function(result)
                cb(result)
            end
        )
    end
)

RegisterServerEvent("SevenLife:Bank:MakeCrypto")
AddEventHandler(
    "SevenLife:Bank:MakeCrypto",
    function()
        MySQL.Async.fetchAll(
            "SELECT * FROM crypto_handelszentrum",
            {},
            function(result)
                local btcnumber = result[1].btcwert
                local ethnumber = result[1].ethwert
                local x = math.random(-50, 50)
                local y = math.random(-50, 50)
                local endeth = ethnumber + x
                local endbtc = btcnumber + y
                MySQL.Async.execute(
                    "UPDATE crypto_handelszentrum SET btcwert = @btcwert, ethwert = @ethwert ",
                    {
                        ["@btcwert"] = endbtc,
                        ["@ethwert"] = endeth
                    },
                    function(result)
                    end
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Bank:CheckIfPlayerHaveEnoughCoins",
    function(source, cb, typ, coins)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM cryptos WHERE id = @identifier",
            {["@identifier"] = player},
            function(result)
                if typ == "btc" then
                    local btccount = result[1].btc
                    if btccount >= coins then
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    if typ == "eth" then
                        local ethcount = result[1].eth
                        if ethcount >= coins then
                            cb(true)
                        else
                            cb(false)
                        end
                    end
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Bank:CheckIfPlayerHaveEnoughCash",
    function(source, cb, coins)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)
        local bankmoney = xPlayer.getAccount("bank").money
        local coinse = tonumber(coins)

        if bankmoney >= coinse then
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:Bank:SellCoins")
AddEventHandler(
    "SevenLife:Bank:SellCoins",
    function(typ, coins, cash)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        local xPlayer = ESX.GetPlayerFromId(_source)
        MySQL.Async.fetchAll(
            "SELECT * FROM cryptos WHERE id = @identifier ",
            {["@identifier"] = player},
            function(result)
                if typ == "btc" then
                    local endcoin = result[1].btc - coins

                    xPlayer.addAccountMoney("bank", cash)
                    MySQL.Async.execute(
                        "UPDATE cryptos SET btc = @btc WHERE id = @identifier  ",
                        {
                            ["@btc"] = endcoin,
                            ["@identifier"] = player
                        },
                        function(result)
                            TriggerClientEvent(
                                "SevenLife:Handy:Message",
                                _source,
                                "../src/appsymbols/crypto.png",
                                "Nachricht - Bank",
                                "Coins erfolgreich Verkauft"
                            )
                        end
                    )
                else
                    if typ == "eth" then
                        xPlayer.addAccountMoney("bank", cash)
                        local endcoin = result[1].eth - coins
                        MySQL.Async.execute(
                            "UPDATE cryptos SET eth = @eth WHERE id = @identifier  ",
                            {
                                ["@eth"] = endcoin,
                                ["@identifier"] = player
                            },
                            function(result)
                                TriggerClientEvent(
                                    "SevenLife:Handy:Message",
                                    _source,
                                    "../src/appsymbols/crypto.png",
                                    "Nachricht - Bank",
                                    "Coins erfolgreich Verkauft"
                                )
                            end
                        )
                    end
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Bank:BuyCoins")
AddEventHandler(
    "SevenLife:Bank:BuyCoins",
    function(typ, coinskaufen, endcash)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        local xPlayer = ESX.GetPlayerFromId(_source)
        MySQL.Async.fetchAll(
            "SELECT * FROM cryptos WHERE id = @identifier ",
            {["@identifier"] = player},
            function(result)
                if typ == "btc" then
                    local endcoin = result[1].btc + coinskaufen

                    xPlayer.removeAccountMoney("bank", endcash)
                    MySQL.Async.execute(
                        "UPDATE cryptos SET btc = @btc WHERE id = @identifier  ",
                        {
                            ["@btc"] = endcoin,
                            ["@identifier"] = player
                        },
                        function(result)
                            TriggerClientEvent(
                                "SevenLife:Handy:Message",
                                _source,
                                "../src/appsymbols/crypto.png",
                                "Nachricht - Bank",
                                "Coins erfolgreich Verkauft"
                            )
                        end
                    )
                else
                    if typ == "eth" then
                        local endcoin = result[1].eth - coinskaufen

                        xPlayer.removeAccountMoney("bank", endcash)
                        MySQL.Async.execute(
                            "UPDATE cryptos SET eth = @eth WHERE id = @identifier  ",
                            {
                                ["@eth"] = endcoin,
                                ["@identifier"] = player
                            },
                            function(result)
                                TriggerClientEvent(
                                    "SevenLife:Handy:Message",
                                    _source,
                                    "../src/appsymbols/crypto.png",
                                    "Nachricht - Bank",
                                    "Coins erfolgreich Verkauft"
                                )
                            end
                        )
                    end
                end
            end
        )
    end
)
AddEventHandler(
    "onResourceStart",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        Citizen.Wait(20000)
        TriggerEvent("SevenLife:Bank:MakeCrypto")
    end
)
RegisterServerEvent("SevenLife:Bank:nehmgeldnormal")
AddEventHandler(
    "SevenLife:Bank:nehmgeldnormal",
    function(howmany)
        howmany = tonumber(howmany)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)

        if howmany <= 10000 then
            if howmany == nil or howmany <= 0 or howmany > xPlayer.getMoney() then
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    source,
                    "Bank - Fehler",
                    "Ein Fehler ist bei der Einzahlung passiert",
                    "1500"
                )
            else
                xPlayer.removeMoney(howmany)
                xPlayer.addAccountMoney("bank", howmany)
                TriggerEvent("SevenLife:Bank:Addtransaktion", 1, howmany, "Aus", _source)
                TriggerClientEvent(
                    "SevenLife:Handy:Message",
                    source,
                    "../src/appsymbols/bankAmerica.png",
                    "Bank - Nachricht",
                    "Geld in höhe von " .. howmany .. "$ abgehoben"
                )
            end
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Bank - Fehler",
                "Du kannst maximal 10000$ einzahlen",
                "1500"
            )
        end
    end
)

RegisterServerEvent("SevenLife:Bank:gibgeldnormal")
AddEventHandler(
    "SevenLife:Bank:gibgeldnormal",
    function(howmany)
        local xPlayer = ESX.GetPlayerFromId(source)
        local amount = tonumber(howmany)

        local accountbase = xPlayer.getAccount("bank").money
        local _source = source
        if amount <= 5000 then
            if amount == nil or amount > accountbase then
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    source,
                    "Bank - Fehler",
                    "Du besitzt zu wenig Geld auf der Bank",
                    "1500"
                )
            else
                xPlayer.removeAccountMoney("bank", amount)
                xPlayer.addMoney(amount)
                TriggerEvent("SevenLife:Bank:Addtransaktion", 2, howmany, "Ein", _source)
                TriggerClientEvent(
                    "SevenLife:Handy:Message",
                    source,
                    "../src/appsymbols/bankAmerica.png",
                    "Bank - Nachricht",
                    "Geld in höhe von " .. howmany .. "$ abgehoben"
                )
            end
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Bank - Fehler",
                "Du kannst maximal 5000$ auszahlen",
                "1500"
            )
        end
    end
)
