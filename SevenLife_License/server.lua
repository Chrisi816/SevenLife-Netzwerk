--------------------------------------------------------------------------------------------------------------
---------------------------------------------------------ESX--------------------------------------------------
--------------------------------------------------------------------------------------------------------------

ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------Send Licenses Back-------------------------------------------
--------------------------------------------------------------------------------------------------------------

ESX.RegisterServerCallback(
    "sevenlife:getlicensesofplayer",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM seven_licenses WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                cb(result)
            end
        )
    end
)
--------------------------------------------------------------------------------------------------------------
-------------------------------------------Check if Player have Theorie---------------------------------------
--------------------------------------------------------------------------------------------------------------

ESX.RegisterServerCallback(
    "SevenLife:TestFly:CheckIfPlayerHaveTheorie",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM seven_licenses WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] ~= nil then
                    if result[1].flyllicensetheorie == "true" then
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                    MySQL.Async.fetchAll(
                        "INSERT INTO seven_licenses (identifier) VALUES (@identifier)",
                        {
                            ["@identifier"] = identifiers
                        },
                        function(result)
                        end
                    )
                end
            end
        )
    end
)
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------Check Player Money-------------------------------------------
--------------------------------------------------------------------------------------------------------------

ESX.RegisterServerCallback(
    "SevenLife:Pay:HaveEnoughMoney",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getAccount("money").money
        if money >= 200 then
            cb(true)
        else
            cb(false)
        end
    end
)
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------Pay Player Money-------------------------------------------
--------------------------------------------------------------------------------------------------------------

RegisterServerEvent("SevenLife:Pay:FlyLicense")
AddEventHandler(
    "SevenLife:Pay:FlyLicense",
    function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        xPlayer.removeMoney(200)
    end
)

RegisterServerEvent("SevenLife:Lizenzen:GiveLizenzenTheoretival")
AddEventHandler(
    "SevenLife:Lizenzen:GiveLizenzenTheoretival",
    function()
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.execute(
            "UPDATE seven_licenses SET flyllicensetheorie = @flyllicensetheorie WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers,
                ["@flyllicensetheorie"] = "true"
            }
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Pay:HasEnoughMoneyForePractical",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        if money >= 500 then
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:Pay:Practical")
AddEventHandler(
    "SevenLife:Pay:Practical",
    function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        xPlayer.removeMoney(200)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:HavePractical",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM seven_licenses WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] ~= nil then
                    if result[1].flylicense == "false" then
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:FlyLicenses:GiveLicense")
AddEventHandler(
    "SevenLife:FlyLicenses:GiveLicense",
    function()
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.execute(
            "UPDATE seven_licenses SET flylicense = @flylicense WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers,
                ["@flylicense"] = "true"
            }
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:GetLizenzenTheo",
    function(source, cb, wich)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(_source).identifier
        if wich == "car" then
            MySQL.Async.fetchAll(
                "SELECT driverlicensetheorie FROM seven_licenses WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifiers
                },
                function(result)
                    if result[1] ~= nil then
                        if result[1].driverlicensetheorie == "false" then
                            cb(false)
                        else
                            cb(true)
                        end
                    else
                        MySQL.Async.fetchAll(
                            "INSERT INTO seven_licenses (identifier) VALUES (@identifier)",
                            {
                                ["@identifier"] = identifiers
                            },
                            function(result)
                                cb(false)
                            end
                        )
                    end
                end
            )
        elseif wich == "lkw" then
            MySQL.Async.fetchAll(
                "SELECT lkwtheorie FROM seven_licenses WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifiers
                },
                function(result)
                    if result[1] ~= nil then
                        if result[1].lkwtheorie == "false" then
                            cb(false)
                        else
                            cb(true)
                        end
                    else
                        MySQL.Async.fetchAll(
                            "INSERT INTO seven_licenses (identifier) VALUES (@identifier)",
                            {
                                ["@identifier"] = identifiers
                            },
                            function(result)
                                cb(false)
                            end
                        )
                    end
                end
            )
        elseif wich == "motor" then
            MySQL.Async.fetchAll(
                "SELECT motorlicensetheorie FROM seven_licenses WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifiers
                },
                function(result)
                    if result[1] ~= nil then
                        if result[1].motorlicensetheorie == "false" then
                            cb(false)
                        else
                            cb(true)
                        end
                    else
                        MySQL.Async.fetchAll(
                            "INSERT INTO seven_licenses (identifier) VALUES (@identifier)",
                            {
                                ["@identifier"] = identifiers
                            },
                            function(result)
                                cb(false)
                            end
                        )
                    end
                end
            )
        end
    end
)

RegisterServerEvent("SevenLife:Lizenzen:GiveLicenseTheo")
AddEventHandler(
    "SevenLife:Lizenzen:GiveLicenseTheo",
    function(state)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        if state == "car" then
            MySQL.Async.execute(
                "UPDATE seven_licenses SET driverlicensetheorie = @driverlicensetheorie WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifiers,
                    ["@driverlicensetheorie"] = "true"
                }
            )
        else
            if state == "motor" then
                MySQL.Async.execute(
                    "UPDATE seven_licenses SET motorlicensetheorie = @motorlicensetheorie WHERE identifier = @identifier",
                    {
                        ["@identifier"] = identifiers,
                        ["@motorlicensetheorie"] = "true"
                    }
                )
            else
                if state == "lkw" then
                    MySQL.Async.execute(
                        "UPDATE seven_licenses SET lkwtheorie = @lkwtheorie WHERE identifier = @identifier",
                        {
                            ["@identifier"] = identifiers,
                            ["@lkwtheorie"] = "true"
                        }
                    )
                end
            end
        end
    end
)

RegisterNetEvent("SevenLife:License:GivePracticalLicense")
AddEventHandler(
    "SevenLife:License:GivePracticalLicense",
    function(state)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        TriggerClientEvent("SevenLife:Quest:UpdateIfPossible", source, 3)
        if state == "car" then
            MySQL.Async.execute(
                "UPDATE seven_licenses SET driverlicense = @driverlicense WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifiers,
                    ["@driverlicense"] = "true"
                }
            )
        else
            if state == "motor" then
                MySQL.Async.execute(
                    "UPDATE seven_licenses SET motorlicense = @motorlicense WHERE identifier = @identifier",
                    {
                        ["@identifier"] = identifiers,
                        ["@motorlicense"] = "true"
                    }
                )
            else
                if state == "lkw" then
                    MySQL.Async.execute(
                        "UPDATE seven_licenses SET lkwlicense = @lkwlicense WHERE identifier = @identifier",
                        {
                            ["@identifier"] = identifiers,
                            ["@lkwlicense"] = "true"
                        }
                    )
                end
            end
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:License:CheckIfPlayerHavePractical",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM seven_licenses WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] ~= nil then
                    if result[1].driverlicense == "false" then
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:License:CheckIfPlayerHavePracticalLKW",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM seven_licenses WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] ~= nil then
                    if result[1].lkwlicense == "false" then
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:License:CheckIfPlayerHavePracticalMotor",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM seven_licenses WHERE identifier = @identifier",
            {
                ["@identifier"] = identifiers
            },
            function(result)
                if result[1] ~= nil then
                    if result[1].motorlicense == "false" then
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            end
        )
    end
)
