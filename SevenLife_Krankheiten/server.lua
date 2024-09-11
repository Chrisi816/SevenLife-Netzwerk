ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Krankheiten:GetData",
    function(source, cb)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        local userData = {}

        MySQL.Async.fetchAll(
            "SELECT krankheit FROM users WHERE identifier = @identifier",
            {["@identifier"] = identifier},
            function(resulto)
                if (resulto[1] ~= nil) then
                    malato = resulto[1].malato
                    cb(malato)
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Krankheiten:husten")
AddEventHandler(
    "SevenLife:Krankheiten:husten",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.execute(
            "UPDATE users SET krankheit = @krankheit WHERE identifier = @identifier",
            {
                ["@krankheit"] = "husten",
                ["@identifier"] = xPlayer.identifier
            }
        )
    end
)

RegisterServerEvent("SevenLife:Krankheiten:bauchschmerzen")
AddEventHandler(
    "SevenLife:Krankheiten:bauchschmerzen",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.execute(
            "UPDATE users SET krankheit = @krankheit WHERE identifier = @identifier",
            {
                ["@krankheit"] = "bauchschmerzen",
                ["@identifier"] = xPlayer.identifier
            }
        )
    end
)

RegisterServerEvent("SevenLife:Krankheiten:Rosazea")
AddEventHandler(
    "SevenLife:Krankheiten:Rosazea",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.execute(
            "UPDATE users SET krankheit = @krankheit WHERE identifier = @identifier",
            {
                ["@krankheit"] = "rosazea",
                ["@identifier"] = xPlayer.identifier
            }
        )
    end
)

RegisterServerEvent("SevenLife:Krankheiten:DeleteIllnes")
AddEventHandler(
    "SevenLife:Krankheiten:DeleteIllnes",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.execute(
            "UPDATE users SET krankheit = @krankheit WHERE identifier = @identifier",
            {
                ["@krankheit"] = "false",
                ["@identifier"] = xPlayer.identifier
            }
        )
    end
)
RegisterServerEvent("SevenLife:Krankheiten:Corona")
AddEventHandler(
    "SevenLife:Krankheiten:Corona",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.execute(
            "UPDATE users SET krankheit = @krankheit WHERE identifier = @identifier",
            {
                ["@krankheit"] = "corona",
                ["@identifier"] = xPlayer.identifier
            }
        )
    end
)

RegisterServerEvent("SevenLife:Krankheiten:Fieber")
AddEventHandler(
    "SevenLife:Krankheiten:Fieber",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.execute(
            "UPDATE users SET krankheit = @krankheit WHERE identifier = @identifier",
            {
                ["@krankheit"] = "fieber",
                ["@identifier"] = xPlayer.identifier
            }
        )
    end
)

RegisterServerEvent("SevenLife:Krankheiten:Durchfall")
AddEventHandler(
    "SevenLife:Krankheiten:Durchfall",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.execute(
            "UPDATE users SET krankheit = @krankheit WHERE identifier = @identifier",
            {
                ["@krankheit"] = "durchfall",
                ["@identifier"] = xPlayer.identifier
            }
        )
    end
)

ESX.RegisterUsableItem(
    "hustensaft",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem("hustensaft", 1)

        TriggerClientEvent("SevenLife:KrankHeit:Husten", source)
    end
)

ESX.RegisterUsableItem(
    "antibiotikum",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem("antibiotikum", 1)

        TriggerClientEvent("SevenLife:KrankHeit:Bauchschmerzen", source)
    end
)

ESX.RegisterUsableItem(
    "antibiotikumRosazea",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem("antibiotikumRosazea", 1)

        TriggerClientEvent("SevenLife:KrankHeit:Haut", source)
    end
)

ESX.RegisterUsableItem(
    "coronaimpfung",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem("coronaimpfung", 1)

        TriggerClientEvent("SevenLife:KrankHeit:Corona", source)
    end
)

-- Fieber
ESX.RegisterUsableItem(
    "aspirin",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem("antibiotikumRosazea", 1)

        TriggerClientEvent("SevenLife:KrankHeit:fieber", source)
    end
)
-- Durchfall
ESX.RegisterUsableItem(
    "imodium",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem("coronaimpfung", 1)

        TriggerClientEvent("SevenLife:KrankHeit:durchfall", source)
    end
)

RegisterServerEvent("SevenLife:Pharma:MakeServer")
AddEventHandler(
    "SevenLife:Pharma:MakeServer",
    function(price, types)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney("money", price)

        if types == "1" then
            xPlayer.addInventoryItem("hustensaft", 1)
        elseif types == "2" then
            xPlayer.addInventoryItem("antibiotikum", 1)
        elseif types == "3" then
            xPlayer.addInventoryItem("antibiotikumRosazea", 1)
        elseif types == "4" then
            xPlayer.addInventoryItem("imodium", 1)
        elseif types == "5" then
            xPlayer.addInventoryItem("aspirin", 1)
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Pharma:CheckIfPlayerHaveRecipt",
    function(source, cb, types)
        local xPlayer = ESX.GetPlayerFromId(source)
        if types == "3" then
            local count = xPlayer.getInventoryItem("rosarezept").count
            if count >= 1 then
                xPlayer.removeInventoryItem("rosarezept", 1)
                cb(true)
            else
                cb(false)
            end
        elseif types == "4" then
            local count = xPlayer.getInventoryItem("imodiumrezept").count
            if count >= 1 then
                xPlayer.removeInventoryItem("imodiumrezept", 1)
                cb(true)
            else
                cb(false)
            end
        elseif types == "5" then
            local count = xPlayer.getInventoryItem("aspirinrezept").count
            if count >= 1 then
                xPlayer.removeInventoryItem("aspirinrezept", 1)
                cb(true)
            else
                cb(false)
            end
        end
    end
)
