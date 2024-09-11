ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
local number
RegisterServerEvent("SevenLife:Phone:GetEinstellungen")
AddEventHandler(
    "SevenLife:Phone:GetEinstellungen",
    function()
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM phone_einstellungen WHERE identifer = @identifier",
            {["@identifier"] = player},
            function(result)
                if result[1] ~= nil then
                    MySQL.Async.fetchAll(
                        "SELECT phone_number FROM users WHERE identifier = @identifier",
                        {["@identifier"] = player},
                        function(results)
                            if results[1].phone_number ~= nil then
                                number = results[1].phone_number
                                TriggerClientEvent(
                                    "SevenLife:PhoneLogDaten",
                                    _source,
                                    result[1],
                                    results[1].phone_number
                                )
                            else
                                MySQL.Async.execute(
                                    "INSERT INTO phone_einstellungen (identifer) VALUES (@identifer)",
                                    {
                                        ["@identifer"] = player
                                    },
                                    function(result)
                                        TriggerClientEvent("SevenLife:Phone:GenerateNumber", _source)
                                    end
                                )
                            end
                        end
                    )
                else
                    MySQL.Async.execute(
                        "INSERT INTO phone_einstellungen (identifer) VALUES (@identifer)",
                        {
                            ["@identifer"] = player
                        },
                        function(result)
                            TriggerClientEvent("SevenLife:Phone:GenerateNumber", _source)
                        end
                    )
                end
            end
        )
    end
)

RegisterNetEvent("SevenLife:Phone:SafeEinstellungsdata")
AddEventHandler(
    "SevenLife:Phone:SafeEinstellungsdata",
    function(item, name)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        if name == "flugmodus" then
            MySQL.Async.execute(
                "UPDATE phone_einstellungen SET flugmodus = @flugmodus WHERE identifer = @identifer",
                {
                    ["@identifer"] = player,
                    ["@flugmodus"] = item
                },
                function(result)
                end
            )
        elseif name == "gps" then
            MySQL.Async.execute(
                "UPDATE phone_einstellungen SET gps = @gps WHERE identifer = @identifer",
                {
                    ["@identifer"] = player,
                    ["@gps"] = item
                },
                function(result)
                end
            )
        elseif name == "push" then
            MySQL.Async.execute(
                "UPDATE phone_einstellungen SET push = @push WHERE identifer = @identifer",
                {
                    ["@identifer"] = player,
                    ["@push"] = item
                },
                function(result)
                    TriggerClientEvent("SevenLife:Phone:SafeEinstellungenUpdate", _source, item)
                end
            )
        elseif name == "kontakte" then
            MySQL.Async.execute(
                "UPDATE phone_einstellungen SET onlykontakte = @onlykontakte WHERE identifer = @identifer",
                {
                    ["@identifer"] = player,
                    ["@onlykontakte"] = item
                },
                function(result)
                end
            )
        elseif name == "wifi" then
            MySQL.Async.execute(
                "UPDATE phone_einstellungen SET  wlan = @wlan WHERE identifer = @identifer",
                {
                    ["@identifer"] = player,
                    ["@wlan"] = item
                },
                function(result)
                end
            )
        elseif name == "wallpaper" then
            MySQL.Async.execute(
                "UPDATE phone_einstellungen SET  wallpaper = @wallpaper  WHERE identifer = @identifer",
                {
                    ["@identifer"] = player,
                    ["@wallpaper"] = item
                },
                function(result)
                end
            )
        elseif name == "linksrechts" then
            MySQL.Async.execute(
                "UPDATE phone_einstellungen SET  linksrechts = @linksrechts WHERE identifer = @identifer",
                {
                    ["@identifer"] = player,
                    ["@linksrechts"] = item
                },
                function(result)
                end
            )
        elseif name == "obenunten" then
            MySQL.Async.execute(
                "UPDATE phone_einstellungen SET oben = @oben WHERE identifer = @identifer",
                {
                    ["@identifer"] = player,
                    ["@oben"] = item
                },
                function(result)
                end
            )
        elseif name == "gresse" then
            MySQL.Async.execute(
                "UPDATE phone_einstellungen SET gresse = @gresse  WHERE identifer = @identifer",
                {
                    ["@identifer"] = player,
                    ["@gresse"] = item
                },
                function(result)
                end
            )
        end
    end
)
RegisterServerEvent("SevenLife:Phone:GiveNumber")
AddEventHandler(
    "SevenLife:Phone:GiveNumber",
    function(nummer, cleannumber)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.execute(
            "UPDATE users SET phone_number = @phone_number,cleannumber = @cleannumber WHERE identifier = @identifier",
            {
                ["@identifier"] = player,
                ["@phone_number"] = nummer,
                ["@cleannumber"] = cleannumber
            },
            function(result)
                TriggerClientEvent("SevenLife:Phone:SetDataToPhone", _source, nummer)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "sevenlife:nummer",
    function(source, cb, numbers)
        local player = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM users WHERE phone_number = @phone_number",
            {
                ["@phone_number"] = numbers
            },
            function(result)
                cb(result[1] ~= nil)
            end
        )
    end
)

RegisterServerEvent("SevenLife:LifeInvader:CreateAccount")
AddEventHandler(
    "SevenLife:LifeInvader:CreateAccount",
    function(icon, benuter, pass)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.execute(
            "INSERT INTO lifeinvader_accounts (benutzername, Passwort, icon, identifier) VALUES (@benutzername, @Passwort, @icon, @identifer)",
            {
                ["@benutzername"] = benuter,
                ["@Passwort"] = pass,
                ["@icon"] = icon,
                ["@identifer"] = player
            },
            function(result)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Lifeinvader:Werbung",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM lifeinvader_werbungen",
            {},
            function(result)
                if result[1] ~= nil then
                    cb(result)
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Lifeinvader:HaveAccount",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM lifeinvader_accounts",
            {},
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
    "SevenLife:Lifeinvader:GetNameOfPerson",
    function(source, cb)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM lifeinvader_accounts WHERE identifier = @identifier",
            {["@identifier"] = player},
            function(result)
                if result[1] ~= nil then
                    cb(result[1].benutzername)
                else
                    cb("Anonym")
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Lifeinvader:SendNachricht")
AddEventHandler(
    "SevenLife:Lifeinvader:SendNachricht",
    function(nachricht, titel, benutzer)
        MySQL.Async.execute(
            "INSERT INTO lifeinvader_werbungen (benutzername, titel, nachricht, premiumornot) VALUES (@benutzername, @titel, @nachricht, @premiumornot)",
            {
                ["@benutzername"] = benutzer,
                ["@titel"] = titel,
                ["@nachricht"] = nachricht,
                ["@premiumornot"] = "1"
            },
            function(result)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Crypto:CheckIfAccountExists",
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

RegisterServerEvent("SevenLife:Crypto:RegisterAccount")
AddEventHandler(
    "SevenLife:Crypto:RegisterAccount",
    function(benutzer, passwort, key)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.execute(
            "INSERT INTO cryptos (id, benutzername, passwort, keyse, btc, eth) VALUES (@id, @benutzername, @passwort, @keyse, @btc, @eth)",
            {
                ["@id"] = player,
                ["@benutzername"] = benutzer,
                ["@passwort"] = passwort,
                ["@keyse"] = key,
                ["@btc"] = "0",
                ["@eth"] = "0"
            },
            function(result)
                TriggerClientEvent("SevenLife:Crypto:OpenLogin", _source)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:IsKeyTaken",
    function(source, cb, key)
        MySQL.Async.fetchAll(
            "SELECT * FROM cryptos WHERE keyse = @keyse",
            {["@keyse"] = key},
            function(result)
                cb(result[1] ~= nil)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Crypto:CheckInfos",
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
    "SevenLife:Crypto:CeckWallet",
    function(source, cb, wallet)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM cryptos WHERE keyse = @keyse",
            {["@keyse"] = wallet},
            function(result)
                cb(result[1] ~= nil)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Crypto:CheckIfPlayerHaveAmmount",
    function(source, cb, cash, form)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        if form == "btc" then
            MySQL.Async.fetchAll(
                "SELECT btc FROM cryptos WHERE id = @id",
                {["@id"] = player},
                function(result)
                    if result[1].btc >= cash then
                        cb(true)
                    else
                        cb(false)
                    end
                end
            )
        else
            if form == "eth" then
                MySQL.Async.fetchAll(
                    "SELECT eth FROM cryptos WHERE id = @id",
                    {["@id"] = player},
                    function(result)
                        if result[1].eth >= cash then
                            cb(true)
                        else
                            cb(false)
                        end
                    end
                )
            end
        end
    end
)
RegisterNetEvent("SevenLife:Crypto:TransferCrypto")
AddEventHandler(
    "SevenLife:Crypto:TransferCrypto",
    function(form, wallet, cash)
        local _source = source
        local player = ESX.GetPlayerFromId(_source).identifier
        if form == "btc" then
            MySQL.Async.fetchAll(
                "SELECT btc FROM cryptos WHERE id = @id",
                {["@id"] = player},
                function(result)
                    local endbtc = result[1].btc - cash
                    MySQL.Async.execute(
                        "UPDATE cryptos SET btc = @btc WHERE id = @id",
                        {
                            ["@id"] = player,
                            ["@btc"] = endbtc
                        },
                        function(result)
                            MySQL.Async.fetchAll(
                                "SELECT btc FROM cryptos WHERE keyse = @wallet",
                                {["@wallet"] = wallet},
                                function(result)
                                    local cash = tonumber(cash)
                                    local oldcahs = tonumber(result[1].btc)
                                    local endbtcempfenger = oldcahs + cash
                                    MySQL.Async.execute(
                                        "UPDATE cryptos SET btc = @btc WHERE keyse = @keyse",
                                        {
                                            ["@keyse"] = wallet,
                                            ["@btc"] = endbtcempfenger
                                        },
                                        function(result)
                                            TriggerClientEvent(
                                                "SevenLife:Cryptos:Erfolgreichertransfer",
                                                _source,
                                                "Es wurden " .. cash .. " Btc transferiert"
                                            )
                                        end
                                    )
                                end
                            )
                        end
                    )
                end
            )
        else
            if form == "eth" then
                MySQL.Async.fetchAll(
                    "SELECT eth FROM cryptos WHERE id = @id",
                    {["@id"] = player},
                    function(result)
                        local endbtc = result[1].eth - cash
                        MySQL.Async.execute(
                            "UPDATE cryptos SET eth = @eth WHERE id = @id",
                            {
                                ["@id"] = player,
                                ["@eth"] = endbtc
                            },
                            function(result)
                                MySQL.Async.fetchAll(
                                    "SELECT eth FROM cryptos WHERE keyse = @wallet",
                                    {["@wallet"] = wallet},
                                    function(result)
                                        local endbtcempfenger = result[1].eth + cash
                                        MySQL.Async.execute(
                                            "UPDATE cryptos SET eth = @eth WHERE keyse = @keyse",
                                            {
                                                ["@keyse"] = wallet,
                                                ["@eth"] = endbtcempfenger
                                            },
                                            function(result)
                                                TriggerClientEvent(
                                                    "SevenLife:Cryptos:Erfolgreichertransfer",
                                                    _source,
                                                    "Es wurden " .. cash .. " Eth transferiert"
                                                )
                                            end
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
            end
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:BankPhone:CheckIfPlayerHaveBank",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        local cash = xPlayer.getAccount("bank").money
        MySQL.Async.fetchAll(
            "SELECT iban FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1].iban == nil then
                    cb(false)
                else
                    cb(cash)
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:BankPhone:CheckIfPlayerHaveEnoughMoney",
    function(source, cb, anzahl)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        local cash = xPlayer.getAccount("bank").money
        local cash = tonumber(cash)
        local anzahl = tonumber(anzahl)
        if cash >= anzahl then
            cb(true)
        else
            cb(false)
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:BankPhone:CheckifIbanExist",
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

RegisterServerEvent("SevenLife:PhoneBank:Transferdata")
AddEventHandler(
    "SevenLife:PhoneBank:Transferdata",
    function(anzahl, iban)
        local _source = source

        local xPlayer = ESX.GetPlayerFromId(source)
        local anzahl = tonumber(anzahl)
        xPlayer.removeAccountMoney("bank", anzahl)
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
                                "Überweisung in höche von " .. anzahl .. "$ erfolgreich"
                            )
                        end
                    )
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:CheckIfMoneyTransfer")
AddEventHandler(
    "SevenLife:CheckIfMoneyTransfer",
    function()
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT transfermoney FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1].transfermoney ~= nil then
                    local money = tonumber(result[1].transfermoney)
                    xPlayer.addAccountMoney("bank", money)
                    MySQL.Async.execute(
                        "UPDATE users SET transfermoney = @transfermoney WHERE identifier = @identifier",
                        {
                            ["@identifier"] = identifiers,
                            ["@transfermoney"] = nil
                        },
                        function(result)
                        end
                    )
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:BillApp:GetBillData",
    function(source, cb, iban)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM bill_options WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                cb(result)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:BillApp:CheckBillCash",
    function(source, cb, id)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        local bankmoney = xPlayer.getAccount("bank").money
        MySQL.Async.fetchAll(
            "SELECT * FROM bill_options WHERE identifier = @identifier and id = @id",
            {
                ["@identifier"] = identifiers,
                ["@id"] = id
            },
            function(result)
                if result[1] ~= nil then
                    local price = tonumber(result[1].price)
                    if bankmoney >= price then
                        xPlayer.removeAccountMoney("bank", price)
                        MySQL.Async.execute(
                            "UPDATE bill_options SET stand = @stand WHERE id = @id AND identifier = @identifier",
                            {
                                ["@identifier"] = identifiers,
                                ["@id"] = id,
                                ["@stand"] = "paid"
                            },
                            function(results)
                                if result[1].firma == "mechaniker" then
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM mechaniker_cash WHERE name = @name",
                                        {
                                            ["@name"] = "mechaniker"
                                        },
                                        function(resultmech)
                                            MySQL.Async.execute(
                                                "UPDATE mechaniker_cash SET money = @money WHERE name = @name",
                                                {
                                                    ["@name"] = "mechaniker",
                                                    ["@money"] = resultmech[1].money + price
                                                },
                                                function(result)
                                                    TriggerClientEvent(
                                                        "SevenLife:Handy:Message",
                                                        _source,
                                                        "../src/appsymbols/bill.png",
                                                        "Rechnungen",
                                                        "Rechnung erfolgreich bezahlt"
                                                    )

                                                    MySQL.Async.fetchAll(
                                                        "SELECT * FROM bill_options WHERE identifier = @identifier",
                                                        {
                                                            ["@identifier"] = identifiers
                                                        },
                                                        function(resultoptions)
                                                            TriggerClientEvent(
                                                                "SevenLife:Handy:Update",
                                                                _source,
                                                                resultoptions
                                                            )
                                                        end
                                                    )
                                                end
                                            )
                                        end
                                    )
                                elseif result[1].firma == "police" then
                                    TriggerClientEvent(
                                        "SevenLife:Handy:Message",
                                        _source,
                                        "../src/appsymbols/bill.png",
                                        "Rechnungen",
                                        "Rechnung erfolgreich bezahlt"
                                    )
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM bill_options WHERE identifier = @identifier",
                                        {
                                            ["@identifier"] = identifiers
                                        },
                                        function(resultoptions)
                                            TriggerClientEvent("SevenLife:Handy:Update", _source, resultoptions)
                                        end
                                    )
                                elseif result[1].firma == "miete" then
                                    TriggerClientEvent(
                                        "SevenLife:Handy:Message",
                                        _source,
                                        "../src/appsymbols/bill.png",
                                        "Rechnungen",
                                        "Rechnung erfolgreich bezahlt"
                                    )
                                    MySQL.Async.fetchAll(
                                        "SELECT * FROM bill_options WHERE identifier = @identifier",
                                        {
                                            ["@identifier"] = identifiers
                                        },
                                        function(resultoptions)
                                            TriggerClientEvent("SevenLife:Handy:Update", _source, resultoptions)
                                        end
                                    )
                                end
                            end
                        )
                    else
                        TriggerClientEvent(
                            "SevenLife:Handy:Message",
                            _source,
                            "../src/appsymbols/bill.png",
                            "Rechnungen",
                            "Du hast zu wenig Geld auf der Bank"
                        )
                    end
                else
                    TriggerClientEvent(
                        "SevenLife:Handy:Message",
                        _source,
                        "../src/appsymbols/bill.png",
                        "Rechnungen",
                        "Fehler bei Zahlung"
                    )
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Phone:CheckIfPlayerHaveHandyItem",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        local itemcount = xPlayer.getInventoryItem("phone").count
        if itemcount >= 1 then
            MySQL.Async.fetchAll(
                "SELECT name, download FROM downloadedapps WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifier
                },
                function(results)
                    cb(true, results)
                end
            )
        else
            cb(false)
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Phone:DropName",
    function(source, cb, nummer)
        MySQL.Async.fetchAll(
            "SELECT name FROM users WHERE phone_number = @phone_number",
            {["@phone_number"] = nummer},
            function(results)
                cb(results[1].name)
            end
        )
    end
)

RegisterServerEvent("SevenLife:Handy:MakeDrop")
AddEventHandler(
    "SevenLife:Handy:MakeDrop",
    function(id, nummer, name)
        local _source = source
        local xTarget = ESX.GetPlayerFromId(id)

        if xTarget ~= nil then
            TriggerClientEvent("SevenLife:OpenEinspeicherMenu:Oppesite", xTarget, nummer, name)
            TriggerClientEvent(
                "SevenLife:Handy:Message",
                _source,
                "../src/appsymbols/bill.png",
                "SevenDrop",
                "Du hast deine Nummer erfolgreich geteilt"
            )
        else
            TriggerClientEvent("sevenlife:displaynachrichtse", _source, "Es gibt keinen Spieler in deiner Nähe")
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Phone:GetVehicles",
    function(source, cb)
        local ownedCars = {}
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE owner = @owner",
            {["@owner"] = identifiers},
            function(results)
                for _, v in pairs(results) do
                    if v.type == "car" then
                        local vehicle = json.decode(v.vehicle)
                        table.insert(
                            ownedCars,
                            {vehicle = vehicle, stored = v.stored, plate = v.plate, fuel = v.fuel, garage = v.garage}
                        )
                    end
                end
                cb(ownedCars)
            end
        )
    end
)

RegisterServerEvent("SevenLife:Phone:MakeContakt")
AddEventHandler(
    "SevenLife:Phone:MakeContakt",
    function(name, nummer, bio, url)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.execute(
            "INSERT INTO kontakte (identifier, name, telefonnummer, bio, profilbild) VALUES (@identifier,@name, @telefonnummer, @bio, @profilbild)",
            {
                ["@identifier"] = identifiers,
                ["@name"] = name,
                ["@telefonnummer"] = nummer,
                ["@bio"] = bio,
                ["@profilbild"] = url
            },
            function(result)
                TriggerClientEvent(
                    "SevenLife:Handy:Message",
                    _source,
                    "../src/appsymbols/contacts1.png",
                    "Kontakte",
                    "Nummer erfolgreich gespeichert"
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Phone:AppData",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.fetchAll(
            "SELECT download,name FROM downloadedapps WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(results)
                if results[1] ~= nil then
                    MySQL.Async.fetchAll(
                        "SELECT name FROM downloadedapps WHERE identifier = @identifier AND download = @download",
                        {
                            ["@identifier"] = identifiers,
                            ["@download"] = "true"
                        },
                        function(resultse)
                            if results[1].name == "appstore" and results[1].download == "true" then
                                cb(results, true, resultse)
                            else
                                cb(results, false, resultse)
                            end
                        end
                    )
                else
                    MySQL.Async.execute(
                        "INSERT INTO downloadedapps (identifier, download,name) VALUES (@identifier, @download, @name)",
                        {
                            ["@identifier"] = identifiers,
                            ["@name"] = "appstore",
                            ["@download"] = "true"
                        },
                        function(result)
                            cb(results, false)
                        end
                    )
                end
            end
        )
    end
)
RegisterServerEvent("SevenLife:Phone:InsertDownLoadApp")
AddEventHandler(
    "SevenLife:Phone:InsertDownLoadApp",
    function(name)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT download FROM downloadedapps WHERE name = @name AND identifier = @identifier",
            {
                ["@name"] = name,
                ["@identifier"] = identifiers
            },
            function(results)
                if results[1] ~= nil then
                    if results[1].download == "true" then
                        TriggerClientEvent(
                            "SevenLife:Handy:Message",
                            _source,
                            "../src/appsymbols/appstore.png",
                            "Nachricht - PlayStore",
                            "Fehler. App schon heruntergeladen!"
                        )
                    elseif results[1].download == "false" then
                        MySQL.Async.execute(
                            "INSERT INTO downloadedapps (identifier, name, download) VALUES (@identifer,@name, @download)",
                            {
                                ["@identifer"] = identifiers,
                                ["@name"] = name,
                                ["@download"] = "true"
                            },
                            function(result)
                                TriggerClientEvent(
                                    "SevenLife:Handy:Message",
                                    _source,
                                    "../src/appsymbols/appstore.png",
                                    "Nachricht - PlayStore",
                                    "App heruntergeladen"
                                )
                            end
                        )
                    end
                else
                    MySQL.Async.execute(
                        "INSERT INTO downloadedapps (identifier, name, download) VALUES (@identifer,@name, @download)",
                        {
                            ["@identifer"] = identifiers,
                            ["@name"] = name,
                            ["@download"] = "true"
                        },
                        function(result)
                            TriggerClientEvent(
                                "SevenLife:Handy:Message",
                                _source,
                                "../src/appsymbols/appstore.png",
                                "Nachricht - PlayStore",
                                "App heruntergeladen"
                            )
                        end
                    )
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Phone:DeleteApp")
AddEventHandler(
    "SevenLife:Phone:DeleteApp",
    function(name)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT download FROM downloadedapps WHERE name = @name AND identifier = @identifier",
            {
                ["@name"] = name,
                ["@identifier"] = identifiers
            },
            function(results)
                if results[1] ~= nil then
                    if results[1].download == "true" then
                        MySQL.Async.execute(
                            "DELETE FROM downloadedapps WHERE name = @name AND identifier = @identifier",
                            {
                                ["@name"] = name,
                                ["@identifier"] = identifiers
                            },
                            function()
                                TriggerClientEvent(
                                    "SevenLife:Handy:Message",
                                    _source,
                                    "../src/appsymbols/appstore.png",
                                    "Nachricht - PlayStore",
                                    "App erfolgreich Deinstalliert"
                                )
                            end
                        )
                    elseif results[1].download == "false" then
                        TriggerClientEvent(
                            "SevenLife:Handy:Message",
                            _source,
                            "../src/appsymbols/appstore.png",
                            "Nachricht - PlayStore",
                            "Fehler. App hat Probleme"
                        )
                    end
                else
                    TriggerClientEvent(
                        "SevenLife:Handy:Message",
                        _source,
                        "../src/appsymbols/appstore.png",
                        "Nachricht - PlayStore",
                        "Fehler. App hat Probleme"
                    )
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Phone:GetActicDispatches",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM dipatches WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] ~= nil then
                    cb(true, result)
                else
                    cb(true)
                end
            end
        )
    end
)
RegisterServerEvent("SevenLife:Phone:InsertDispatchDB")
AddEventHandler(
    "SevenLife:Phone:InsertDispatchDB",
    function(frak, titel, desc, coords)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local time = os.date("*t")
        local actualltime = ("%02d:%02d:%02d"):format(time.hour, time.min, time.sec)
        local LastPos = "{" .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. "}"
        local _source = source
        print(desc)
        MySQL.Async.execute(
            "INSERT INTO dipatches (identifier, coords, titel, description, fraktion, uhrzeit) VALUES (@identifier, @coords, @titel, @desc, @fraktion, @uhrzeit)",
            {
                ["@identifier"] = identifiers,
                ["@coords"] = LastPos,
                ["@titel"] = titel,
                ["@desc"] = desc,
                ["@fraktion"] = frak,
                ["@uhrzeit"] = actualltime
            },
            function(result)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Phone:GetNotizen",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM notizen_db WHERE identifer = @identifer",
            {
                ["@identifer"] = identifiers
            },
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Phone:DeleteNotiz")
AddEventHandler(
    "SevenLife:Phone:DeleteNotiz",
    function(id)
        local _source = source
        MySQL.Async.execute(
            "DELETE FROM notizen_db WHERE id = @id ",
            {
                ["@id"] = id
            },
            function()
                TriggerClientEvent(
                    "SevenLife:Handy:Message",
                    _source,
                    "../src/appsymbols/appstore.png",
                    "Nachricht - PlayStore",
                    "Notiz erfolgreich gelöscht"
                )
            end
        )
    end
)
RegisterServerEvent("SevenLife:Phone:AddNotiz")
AddEventHandler(
    "SevenLife:Phone:AddNotiz",
    function()
        local _source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.execute(
            "INSERT INTO notizen_db (identifer) VALUES (@identifer)",
            {
                ["@identifer"] = identifiers
            },
            function()
                Citizen.Wait(500)
                MySQL.Async.fetchAll(
                    "SELECT * FROM notizen_db WHERE identifer = @identifer",
                    {
                        ["@identifer"] = identifiers
                    },
                    function(result)
                        TriggerClientEvent("SevenLife:Phone:UpdateNotiz", _source, result)
                    end
                )
            end
        )
    end
)
RegisterServerEvent("SevenLife:Phone:SaveList")
AddEventHandler(
    "SevenLife:Phone:SaveList",
    function(id, beschreigung, titel)
        local _source = source
        MySQL.Async.execute(
            "UPDATE notizen_db SET titel = @titel,beschreibung = @beschreibung WHERE id = @id",
            {
                ["@id"] = id,
                ["@titel"] = titel,
                ["@beschreibung"] = beschreigung
            },
            function(result)
                TriggerClientEvent(
                    "SevenLife:Handy:Message",
                    _source,
                    "../src/appsymbols/appstore.png",
                    "Nachricht - PlayStore",
                    "Notiz erfolgreich gespeichert"
                )
            end
        )
    end
)
RegisterServerEvent("SevenLife:Phone:AddToGalerry")
AddEventHandler(
    "SevenLife:Phone:AddToGalerry",
    function(src)
        local _source = source
        local Player = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.execute(
            "INSERT INTO phone_gallery (`identifier`, `image`) VALUES (@identifier, @image)",
            {
                ["@identifier"] = Player,
                ["@image"] = src
            },
            function()
                TriggerClientEvent(
                    "SevenLife:Handy:Message",
                    _source,
                    "../src/appsymbols/photo.png",
                    "Nachricht - Kamer",
                    "Foto erfolgreich gespeichert"
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Phone:GetPhotos",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM phone_gallery WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Phone:DeleteIMG")
AddEventHandler(
    "SevenLife:Phone:DeleteIMG",
    function(src)
        local _source = source
        MySQL.Async.execute(
            "DELETE FROM phone_gallery WHERE image = @image ",
            {
                ["@image"] = src
            },
            function()
                TriggerClientEvent("SevenLife:IMG:Update", _source)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Phone:SevenDropIMG")
AddEventHandler(
    "SevenLife:Phone:SevenDropIMG",
    function(target, src)
        TriggerClientEvent(
            "SevenLife:Handy:Message",
            source,
            "../src/appsymbols/photo.png",
            "Nachricht - SevenDrop",
            "Foto erfolgreich verschickt"
        )
        TriggerClientEvent("SevenLife:Phone:SevenDropIMG:Target", target, src)
    end
)
RegisterNetEvent("SevenLife:Phone:InsertIMG")
AddEventHandler(
    "SevenLife:Phone:InsertIMG",
    function(src)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.execute(
            "INSERT INTO phone_gallery (`identifier`, `image`) VALUES (@identifier, @image)",
            {
                ["@identifier"] = identifiers,
                ["@image"] = src
            },
            function()
                TriggerClientEvent(
                    "SevenLife:Handy:Message",
                    _source,
                    "../src/appsymbols/photo.png",
                    "Nachricht - SevenDrop",
                    "Foto erfolgreich angenommen"
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Phone:GetKontakte",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM kontakte WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Phone:InsertNummer")
AddEventHandler(
    "SevenLife:Phone:InsertNummer",
    function(nummer, name)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.execute(
            "INSERT INTO kontakte (`identifier`, `name`,`telefonnummer`) VALUES (@identifier, @name, @telefonnummer)",
            {
                ["@identifier"] = identifiers,
                ["@telefonnummer"] = name,
                ["@number"] = nummer
            },
            function()
                TriggerClientEvent(
                    "SevenLife:Handy:Message",
                    _source,
                    "../src/appsymbols/photo.png",
                    "Nachricht - SevenDrop",
                    "Neue nummer namens " .. name
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Phone:GetKontakteOnPhone",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM kontakte WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Phone:MakeNewChat")
AddEventHandler(
    "SevenLife:Phone:MakeNewChat",
    function(id)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        local _source = source

        MySQL.Async.fetchAll(
            "SELECT * FROM kontakte WHERE id = @id",
            {
                ["@id"] = id
            },
            function(result)
                local playeridentifier =
                    MySQL.Sync.fetchAll(
                    "SELECT `identifier` FROM users WHERE cleannumber = @cleannumber",
                    {
                        ["@cleannumber"] = result[1].telefonnummer
                    }
                )
                local existingchat =
                    MySQL.Sync.fetchAll(
                    "SELECT `id` FROM chats WHERE empfenger1 = @empfenger1 AND empfenger2 = @empfenger2 ",
                    {
                        ["@empfenger1"] = identifier,
                        ["@empfenger2"] = playeridentifier[1].identifier
                    }
                )
                local existingchat2 =
                    MySQL.Sync.fetchAll(
                    "SELECT `id` FROM chats WHERE empfenger1 = @empfenger1 AND empfenger2 = @empfenger2 ",
                    {
                        ["@empfenger1"] = playeridentifier[1].identifier,
                        ["@empfenger2"] = identifier
                    }
                )
                if existingchat[1] == nil and existingchat2[1] == nil then
                    if playeridentifier[1] ~= nil then
                        MySQL.Async.execute(
                            "INSERT INTO chats (`idchat`,`identifier`,`name`, `telefonnummer`,`bio`,`profilbild`,`premiumornot`, `empfenger1`,`empfenger2`) VALUES ( @idchat,@identifier,@name, @telefonnummer,@bio,@profilbild,@premiumornot, @empfenger1, @empfenger2)",
                            {
                                ["@idchat"] = id,
                                ["@identifier"] = identifier,
                                ["@name"] = result[1].name,
                                ["@telefonnummer"] = result[1].telefonnummer,
                                ["@bio"] = result[1].bio,
                                ["@profilbild"] = result[1].profilbild,
                                ["@premiumornot"] = result[1].premiumornot,
                                ["@empfenger1"] = identifier,
                                ["@empfenger2"] = playeridentifier[1].identifier
                            }
                        )
                        MySQL.Async.execute(
                            "INSERT INTO chats (`idchat`,`identifier`,`name`, `telefonnummer`,`bio`,`profilbild`,`premiumornot`, `empfenger1`,`empfenger2`) VALUES ( @idchat,@identifier,@name, @telefonnummer,@bio,@profilbild,@premiumornot, @empfenger1, @empfenger2)",
                            {
                                ["@idchat"] = id,
                                ["@identifier"] = playeridentifier[1].identifier,
                                ["@name"] = result[1].telefonnummer,
                                ["@telefonnummer"] = result[1].telefonnummer,
                                ["@bio"] = result[1].bio,
                                ["@profilbild"] = result[1].profilbild,
                                ["@premiumornot"] = result[1].premiumornot,
                                ["@empfenger1"] = identifier,
                                ["@empfenger2"] = playeridentifier[1].identifier
                            }
                        )
                        MySQL.Async.execute(
                            "INSERT INTO chatsmessages (`idchat`, `identifier`, `message`, `gelesen`, `firstnachricht`) VALUES (@idchat,@identifier, @message, @gelesen, @firstnachricht)",
                            {
                                ["@idchat"] = id,
                                ["@identifier"] = identifier,
                                ["@message"] = "Das hier ist der beginnt des Chats. Chats sind Ende zu Ende Verschlüsselt.",
                                ["@gelesen"] = true,
                                ["@firstnachricht"] = true
                            }
                        )
                        Citizen.Wait(50)
                        local chatmessagesinfo =
                            MySQL.Sync.fetchAll(
                            "SELECT * FROM chatsmessages WHERE idchat = @idchat",
                            {
                                ["@idchat"] = id
                            }
                        )
                        local chatinfo =
                            MySQL.Sync.fetchAll(
                            "SELECT * FROM chats WHERE idchat = @idchat",
                            {
                                ["@idchat"] = id
                            }
                        )
                        local chatinfo2 =
                            MySQL.Sync.fetchAll(
                            "SELECT * FROM chats WHERE identifier = @identifier ",
                            {
                                ["@identifier"] = identifier
                            }
                        )
                        local chatinfo3 =
                            MySQL.Sync.fetchAll(
                            "SELECT * FROM chats WHERE identifier = @identifier ",
                            {
                                ["@identifier"] = playeridentifier[1].identifier
                            }
                        )
                        TriggerClientEvent("SevenLife:Phone:OpenMessageSite", _source, chatmessagesinfo, chatinfo)
                        TriggerClientEvent("SevenLife:Phone:UpdateKontaktList", _source, chatinfo2)
                        local notifyid = GetServerIdFromIdentifier(chatinfo[1].empfenger2)
                        if notifyid ~= nil then
                            TriggerClientEvent(
                                "SevenLife:Handy:Message",
                                notifyid,
                                "../src/appsymbols/whatsapp.png",
                                "Nachricht - ChatApp",
                                chatinfo[1].name .. " hat einen Neuen Chat aufgemacht!"
                            )

                            TriggerClientEvent("SevenLife:Phone:UpdateKontaktList", _source, chatinfo3)
                        end
                    else
                        TriggerClientEvent(
                            "SevenLife:Handy:Message",
                            _source,
                            "../src/appsymbols/photo.png",
                            "Nachricht - ChatApp",
                            "Du kannst dieser Nummer nicht schreiben da sie niemand besitzt!"
                        )
                    end
                else
                    TriggerClientEvent(
                        "SevenLife:Handy:Message",
                        _source,
                        "../src/appsymbols/whatsapp.png",
                        "Nachricht - ChatApp",
                        "Du hast mit dieser Person schon ein Chat"
                    )
                end
            end
        )
    end
)
RegisterServerEvent("SevenLife:Phone:InsertNewNachricht")
AddEventHandler(
    "SevenLife:Phone:InsertNewNachricht",
    function(id, chat)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        local id = tonumber(id)
        local _source = source

        local chats =
            MySQL.Sync.fetchAll(
            "SELECT * FROM chats WHERE identifier = @identifier AND idchat = @idchat ",
            {
                ["@identifier"] = identifier,
                ["@idchat"] = id
            }
        )
        MySQL.Async.execute(
            "INSERT INTO chatsmessages (`idchat`, `identifier`, `message`, `gelesen`, `firstnachricht`) VALUES (@idchat,@identifier, @message, @gelesen, @firstnachricht)",
            {
                ["@idchat"] = id,
                ["@identifier"] = identifier,
                ["@message"] = chat,
                ["@gelesen"] = false,
                ["@firstnachricht"] = false
            }
        )

        Citizen.Wait(50)
        local chatmessagesinfo =
            MySQL.Sync.fetchAll(
            "SELECT * FROM chatsmessages WHERE idchat = @idchat",
            {
                ["@idchat"] = id
            }
        )
        local chatinfo =
            MySQL.Sync.fetchAll(
            "SELECT * FROM chats WHERE idchat = @idchat",
            {
                ["@idchat"] = id
            }
        )
        local notifyid = GetServerIdFromIdentifier(chatinfo[1].empfenger2)
        if notifyid ~= nil then
            TriggerClientEvent(
                "SevenLife:Handy:Message",
                notifyid,
                "../src/appsymbols/whatsapp.png",
                "Nachricht - ChatApp",
                chats[1].name .. " hat dir geschrieben!"
            )

            TriggerClientEvent("SevenLife:Phone:UpdateMessageList", notifyid, chatmessagesinfo, chatinfo)
        end

        TriggerClientEvent("SevenLife:Phone:UpdateMessageSite", _source, chatmessagesinfo, chatinfo, identifier)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Phone:GetChats",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM chats WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(result1)
                cb(result1)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Phone:GetChatsID",
    function(source, cb, id)
        local id = tonumber(id)

        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier

        local chatmessagesinfo =
            MySQL.Sync.fetchAll(
            "SELECT * FROM chatsmessages WHERE idchat = @idchat",
            {
                ["@idchat"] = id
            }
        )
        local chatinfo =
            MySQL.Sync.fetchAll(
            "SELECT * FROM chats WHERE idchat = @idchat",
            {
                ["@idchat"] = id
            }
        )

        cb(chatmessagesinfo, chatinfo, identifier)
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
RegisterServerEvent("SevenLife:Phone:SendImage")
AddEventHandler(
    "SevenLife:Phone:SendImage",
    function(id, chat)
        print(1)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        local id = tonumber(id)
        local _source = source

        local chats =
            MySQL.Sync.fetchAll(
            "SELECT * FROM chats WHERE identifier = @identifier AND idchat = @idchat ",
            {
                ["@identifier"] = identifier,
                ["@idchat"] = id
            }
        )
        MySQL.Async.execute(
            "INSERT INTO chatsmessages (`idchat`, `identifier`, `message`, `gelesen`, `firstnachricht` ,`types`) VALUES (@idchat,@identifier, @message, @gelesen, @firstnachricht,@types)",
            {
                ["@idchat"] = id,
                ["@identifier"] = identifier,
                ["@message"] = chat,
                ["@gelesen"] = false,
                ["@firstnachricht"] = false,
                ["@types"] = 1
            }
        )
        Citizen.Wait(50)
        local chatmessagesinfo =
            MySQL.Sync.fetchAll(
            "SELECT * FROM chatsmessages WHERE idchat = @idchat",
            {
                ["@idchat"] = id
            }
        )
        local chatinfo =
            MySQL.Sync.fetchAll(
            "SELECT * FROM chats WHERE idchat = @idchat",
            {
                ["@idchat"] = id
            }
        )
        local notifyid = GetServerIdFromIdentifier(chatinfo[1].empfenger2)
        if notifyid ~= nil then
            TriggerClientEvent(
                "SevenLife:Handy:Message",
                notifyid,
                "../src/appsymbols/whatsapp.png",
                "Nachricht - ChatApp",
                chats[1].name .. " hat dir geschrieben!"
            )

            TriggerClientEvent("SevenLife:Phone:UpdateMessageList", notifyid, chatmessagesinfo, chatinfo)
        end

        TriggerClientEvent("SevenLife:Phone:UpdateMessageSite", _source, chatmessagesinfo, chatinfo, identifier)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Phone:GetDataStorys",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local statusinfo = MySQL.Sync.fetchAll("SELECT * FROM status ", {})
        local chatinfo =
            MySQL.Sync.fetchAll(
            "SELECT * FROM chats WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        local name =
            MySQL.Sync.fetchAll(
            "SELECT name FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        cb(statusinfo, name[1].name)
    end
)
RegisterServerEvent("SevenLife:Phone:InsertNewStory")
AddEventHandler(
    "SevenLife:Phone:InsertNewStory",
    function(id, url)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local name =
            MySQL.Sync.fetchAll(
            "SELECT name FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        MySQL.Async.execute(
            "INSERT INTO status (`identifier`, `img`, `name`) VALUES (@identifier,@img, @name)",
            {
                ["@identifier"] = identifier,
                ["@img"] = url,
                ["@name"] = name[1].name
            }
        )
    end
)
local users = {}

RegisterServerEvent("SevenLife:Phone:sendData")
AddEventHandler(
    "SevenLife:Phone::sendData",
    function(data)
        local user = findUser(data.callId)

        if data.type == "store_user" then
            if user ~= nil then
                return
            end
            local newUser = {
                serverId = data.serverId,
                callId = data.callId
            }
            table.insert(users, newUser)
        elseif data.type == "store_offer" then
            if user == nil then
                return
            end
            user.offer = data.offer
        elseif data.type == "store_candidate" then
            if user == nil then
                return
            end
            if user.candidates == nil then
                user.candidates = {}
            end
            table.insert(user.candidates, data.candidate)
        elseif data.type == "send_answer" then
            if user == nil then
                return
            end
            sendData(
                {
                    type = "answer",
                    answer = data.answer
                },
                user.serverId
            )
        elseif data.type == "send_candidate" then
            if user == nil then
                return
            end
            sendData(
                {
                    type = "candidate",
                    candidate = data.candidate
                },
                user.serverId
            )
        elseif data.type == "join_call" then
            if user == nil then
                return
            end
            sendData(
                {
                    type = "offer",
                    offer = user.offer
                },
                user.callId
            )

            for index, value in ipairs(user.candidates) do
                sendData(
                    {
                        type = "candidate",
                        candidate = value
                    },
                    user.callId
                )
            end
        end
    end
)

function sendData(data, src)
    TriggerClientEvent("nakres_videocall:sendData", src, data)
end
function findUser(callId)
    for i, user in ipairs(users) do
        if user.callId == callId then
            return user
        end
    end
end
RegisterServerEvent("SevenLife:Phone:SaveFunk")
AddEventHandler(
    "SevenLife:Phone:SaveFunk",
    function(id)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local _source = source
        local funk =
            MySQL.Sync.fetchAll(
            "SELECT * FROM funkid WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        for k, v in pairs(funk) do
            if tonumber(v.funkid) == tonumber(id) then
                MySQL.Async.execute(
                    "DELETE FROM battlepassmissionen WHERE funkid = @funkid",
                    {
                        ["@funkid"] = id
                    }
                )
                MySQL.Async.execute(
                    "INSERT INTO funkid (`identifier`, `funkid`) VALUES (@identifier,@funkid)",
                    {
                        ["@identifier"] = identifier,
                        ["@funkid"] = id
                    }
                )
            else
                MySQL.Async.execute(
                    "INSERT INTO funkid (`identifier`, `funkid`) VALUES (@identifier,@funkid)",
                    {
                        ["@identifier"] = identifier,
                        ["@funkid"] = id
                    }
                )
            end
        end
        Citizen.Wait(100)
        local funk =
            MySQL.Sync.fetchAll(
            "SELECT * FROM funkid WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        TriggerClientEvent("SevenLife:Phone:UpdateFunkChannels", _source, funk)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Phone:GetHistoryFunk",
    function(source, cb)
        local funk =
            MySQL.Sync.fetchAll(
            "SELECT * FROM funkid WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        cb(funk)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Phone:CheckIfInBusiness",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local business =
            MySQL.Sync.fetchAll(
            "SELECT * FROM business WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        if business[1] ~= nil then
            if (business[1].id) ~= nil then
                local businessallinfo =
                    MySQL.Sync.fetchAll(
                    "SELECT * FROM business WHERE code = code",
                    {
                        ["@identifier"] = business[1].code
                    }
                )
                local yourselfadmin
                if tonumber(business[1].admin) == 1 then
                    yourselfadmin = true
                else
                    yourselfadmin = false
                end
                cb(true, businessallinfo, yourselfadmin)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end
)
RegisterServerEvent("SevenLife:Phone:DeletePlayerFromBusiness")
AddEventHandler(
    "SevenLife:Phone:DeletePlayerFromBusiness",
    function(id)
        local _source = source
        MySQL.Async.execute(
            "DELETE FROM business WHERE id = @id ",
            {
                ["@id"] = id
            },
            function()
                TriggerClientEvent(
                    "SevenLife:Handy:Message",
                    _source,
                    "../src/appsymbols/Business.png",
                    "Nachricht - Business",
                    "Du hast das Business erfolgreich verlassen"
                )
            end
        )
    end
)
RegisterServerEvent("SevenLife:Phone:InsertPlayerIntoBusiness")
AddEventHandler(
    "SevenLife:Phone:InsertPlayerIntoBusiness",
    function(id)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local _source = source
        local business =
            MySQL.Sync.fetchAll(
            "SELECT * FROM business WHERE id = @id",
            {
                ["@id"] = id
            }
        )
        local infos =
            MySQL.Sync.fetchAll(
            "SELECT * FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        if business[1] ~= nil then
            MySQL.Async.execute(
                "INSERT INTO business (`identifier`, `code`,`admin`,`name`,`nummer`) VALUES (@identifier,@code, @admin,@name,@nummer)",
                {
                    ["@identifier"] = identifier,
                    ["@code"] = id,
                    ["@admin"] = 2,
                    ["@name"] = infos[1].name,
                    ["@nummer"] = infos[1].phone_number
                }
            )
        else
            MySQL.Async.execute(
                "INSERT INTO business (`identifier`, `code`,`admin`,`name`,`nummer`) VALUES (@identifier,@code, @admin,@name,@nummer)",
                {
                    ["@identifier"] = identifier,
                    ["@code"] = id,
                    ["@admin"] = 1,
                    ["@name"] = infos[1].name,
                    ["@nummer"] = infos[1].phone_number
                }
            )
        end

        TriggerClientEvent("SevenLife:Phone:OpenPageBusiness", _source)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Phone:GetNachrichten",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local business =
            MySQL.Sync.fetchAll(
            "SELECT * FROM business WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        local businessallinfo =
            MySQL.Sync.fetchAll(
            "SELECT * FROM businesschat where idchat = idchat",
            {
                ["@idchat"] = business[1].code
            }
        )
        cb(businessallinfo, identifier)
    end
)
RegisterServerEvent("SevenLife:Phone:InsertNewNachrichtBusiness")
AddEventHandler(
    "SevenLife:Phone:InsertNewNachrichtBusiness",
    function(id, chat)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        local id = tonumber(id)
        local _source = source

        MySQL.Async.execute(
            "INSERT INTO businesschat (`idchat`, `identifier`, `message`, `gelesen`, `firstnachricht`) VALUES (@idchat,@identifier, @message, @gelesen, @firstnachricht)",
            {
                ["@idchat"] = id,
                ["@identifier"] = identifier,
                ["@message"] = chat,
                ["@gelesen"] = false,
                ["@firstnachricht"] = false
            }
        )

        TriggerClientEvent("SevenLife:Phone:InsertUpdatetNachricht", _source)
    end
)
