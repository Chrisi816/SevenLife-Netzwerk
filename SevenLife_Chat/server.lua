local ESX = nil
local carryng = {}
local previous = {}

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Chat:GetPerms",
    function(source, cb)
        local player = ESX.GetPlayerFromId(source)

        if player ~= nil then
            local playerGroup = player.getGroup()

            if playerGroup ~= nil then
                cb(playerGroup)
            else
                cb("user")
            end
        else
            cb("user")
        end
    end
)
RegisterNetEvent("SevenLife:Chat:GiveItem")
AddEventHandler(
    "SevenLife:Chat:GiveItem",
    function(id, item, count)
        if IsPlayerAceAllowed(source, "antibypass") then
            local id = id:match("^%s*(.-)%s*$")
            local item = item:match("^%s*(.-)%s*$")
            local count = count:match("^%s*(.-)%s*$")
            if id == "me" then
                id = source
            else
                id = id
            end
            local xPlayer = ESX.GetPlayerFromId(id)
            if xPlayer ~= nil then
                xPlayer.addInventoryItem(item, count)
            else
                TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Chat", "Spieler ID nicht vorhanden", 2000)
            end
        else
            TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Chat", "Du besitzt zu wenig Rechte", 2000)
        end
    end
)
RegisterNetEvent("SevenLife:Chat:SetAcccountmoney")
AddEventHandler(
    "SevenLife:Chat:SetAcccountmoney",
    function(id, type, money)
        if IsPlayerAceAllowed(source, "antibypass") then
            local id = id:match("^%s*(.-)%s*$")
            local type = type:match("^%s*(.-)%s*$")
            local money = tonumber(money:match("^%s*(.-)%s*$"))
            if id == "me" then
                id = source
            else
                id = id
            end
            local xPlayer = ESX.GetPlayerFromId(id)
            if xPlayer ~= nil then
                if type == "money" then
                    xPlayer.setAccountMoney("money", money)
                elseif type == "bank" then
                    xPlayer.setAccountMoney("bank", money)
                end
            else
                TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Chat", "Spieler ID nicht vorhanden", 2000)
            end
        else
            TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Chat", "Du besitzt zu wenig Rechte", 2000)
        end
    end
)
RegisterNetEvent("SevenLife:Chat:addaccountmoney")
AddEventHandler(
    "SevenLife:Chat:addaccountmoney",
    function(id, type, money)
        if IsPlayerAceAllowed(source, "antibypass") then
            local id = id:match("^%s*(.-)%s*$")
            local type = type:match("^%s*(.-)%s*$")
            local money = tonumber(money:match("^%s*(.-)%s*$"))
            if id == "me" then
                id = source
            else
                id = id
            end
            local xPlayer = ESX.GetPlayerFromId(id)
            if xPlayer ~= nil then
                if type == "money" then
                    xPlayer.addAccountMoney("money", money)
                elseif type == "bank" then
                    xPlayer.addAccountMoney("money", money)
                end
            else
                TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Chat", "Spieler ID nicht vorhanden", 2000)
            end
        else
            TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Chat", "Du besitzt zu wenig Rechte", 2000)
        end
    end
)
RegisterNetEvent("SevenLife:Chat:MakeOOCNachricht")

AddEventHandler(
    "SevenLife:Chat:MakeOOCNachricht",
    function(titel, nachricht, id)
        for k, v in ipairs(id) do
            TriggerClientEvent("SevenLife:Chat:InsertOOCNachricht", v, titel, nachricht)
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Chat:GetPlayerID",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local name = GetPlayerName(source)
        local identifier = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT id FROM users where identifier = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(result)
                cb(result[1].id, name)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Chat:StopPeopleCarry")
AddEventHandler(
    "SevenLife:Chat:StopPeopleCarry",
    function(target)
        local source = source

        if carryng[source] then
            TriggerClientEvent("SevenLife:Chat:StopCarry", target)
            carryng[source] = nil
            previous[target] = nil
        elseif previous[source] then
            TriggerClientEvent("SevenLife:Chat:StopCarry", previous[source])
            carryng[previous[source]] = nil
            previous[source] = nil
        end
    end
)
RegisterNetEvent("SevenLife:Chat:SyncPlayer")
AddEventHandler(
    "SevenLife:Chat:SyncPlayer",
    function(target)
        local source = source
        local sourcePed = GetPlayerPed(source)
        local sourceCoords = GetEntityCoords(sourcePed)
        local targetPed = GetPlayerPed(target)
        local targetCoords = GetEntityCoords(targetPed)
        if #(sourceCoords - targetCoords) <= 3.0 then
            TriggerClientEvent("SevenLife:Chat:Sync", target, source)
            carryng[source] = target
            previous[target] = source
        end
    end
)
RegisterServerEvent("SevenLife:Chat:SyncWheather")
AddEventHandler(
    "SevenLife:Chat:SyncWheather",
    function(weather)
        TriggerClientEvent("SevenLife:Chat:SyncWheather", -1, weather)
    end
)
RegisterServerEvent("SevenLife:Chat:SyncTime")
AddEventHandler(
    "SevenLife:Chat:SyncTime",
    function(time)
        TriggerClientEvent("SevenLife:Chat:SyncTime", -1, time)
    end
)
RegisterServerEvent("SevenLife:Chat:GiveWeapon")
AddEventHandler(
    "SevenLife:Chat:GiveWeapon",
    function(id, type, ammo)
        local type = type:match("^%s*(.-)%s*$")
        local ammo = tonumber(ammo:match("^%s*(.-)%s*$"))
        print(type)
        local xPlayer = ESX.GetPlayerFromId(id)
        xPlayer.addWeapon(type, ammo)
    end
)
RegisterServerEvent("SevenLife:Chat:ClearWeapons")
AddEventHandler(
    "SevenLife:Chat:ClearWeapons",
    function(id)
        local xPlayer = ESX.GetPlayerFromId(id)
        local Weapons = xPlayer.getLoadout()
        for k, v in ipairs(Weapons) do
            xPlayer.removeWeapon(v)
        end
        TriggerClientEvent(
            "SevenLife:TimetCustom:Notify",
            id,
            "ADMIN",
            "Deine Waffen wurde von einem Admin geleert.",
            2000
        )
    end
)
RegisterServerEvent("SevenLife:Chat:ClearInventory")
AddEventHandler(
    "SevenLife:Chat:ClearInventory",
    function(id)
        local xPlayer = ESX.GetPlayerFromId(id)
        local Inventory = xPlayer.inventory
        for k, v in ipairs(Inventory) do
            print(v.name)
            local count = xPlayer.getInventoryItem(v.name).count
            xPlayer.removeInventoryItem(v.name, count)
        end
        TriggerClientEvent(
            "SevenLife:TimetCustom:Notify",
            id,
            "ADMIN",
            "Dein Inventar wurde von einem Admin geleert.",
            2000
        )
    end
)
RegisterServerEvent("SevenLife:Chat:ShowInventory")
AddEventHandler(
    "SevenLife:Chat:ShowInventory",
    function(id)
        local src = id
        local xPlayer = ESX.GetPlayerFromId(src)
        local inv = xPlayer.inventory
        local weight = xPlayer.getWeight()
        TriggerClientEvent("SevenLife:Inventory:OpenIt", source, inv, weight)
    end
)
RegisterServerEvent("SevenLife:Chat:TransferMoney")
AddEventHandler(
    "SevenLife:Chat:TransferMoney",
    function(id, amount)
        local amount = tonumber(amount)
        local xPlayer = ESX.GetPlayerFromId(source)

        local xTarget = ESX.GetPlayerFromId(id)

        local tidentifier = xTarget.identifier
        local _source = source
        local money = xPlayer.getMoney()
        local identifier = xPlayer.identifier
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM battlepassmissionen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        if check[1] ~= nil then
            if tonumber(check[1].index2) == 1 then
                if amount >= 100 then
                    TriggerEvent("SevenLife:SeasonPass:MakeProgress", 2, true, _source)
                end
            elseif tonumber(check[1].index2) == 2 then
                if amount >= 150 then
                    TriggerEvent("SevenLife:SeasonPass:MakeProgress", 2, true, _source)
                end
            elseif tonumber(check[1].index2) == 3 then
                if amount >= 200 then
                    TriggerEvent("SevenLife:SeasonPass:MakeProgress", 2, true, _source)
                end
            end
        end
        if money >= amount then
            SendInfoToDiscord(
                16711680,
                "Neue Bar Transaktion",
                "```Höhe:``` **" ..
                    amount ..
                        " **$" .. "```Von:``` **" .. identifier .. " **\n" .. "```Für:```  **" .. tidentifier .. " **\n",
                "SevenLife_InfoSystem"
            )
            if xTarget ~= nil then
                xPlayer.removeAccountMoney("money", amount)
                xTarget.addAccountMoney("money", amount)
                TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Money", "Geld erfolgreich übergeben", 2000)
            else
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    source,
                    "Money",
                    "Spieler mit dieser Id nicht vorhanden",
                    2000
                )
            end
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Money",
                "Zu wenig Geld auf der Hand um diese Aktion auszuführen",
                2000
            )
        end
    end
)
local DISCORDHALLOFSHAME_URL_ =
    "https://discord.com/api/webhooks/1071477571977498765/PcZb8kgne9uXZB-cBdHi4HBAsV8A7vaITqeiWDakZ-P-aj17CRiPXSP6ODvyq_2w6-AS"
function SendInfoToDiscord(color, name, message, footer)
    if DISCORDHALLOFSHAME_URL_ == nil or DISCORDHALLOFSHAME_URL_ == "" then
        return false
    end
    local embed = {
        {
            ["color"] = color,
            ["title"] = "**" .. name .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer
            }
        }
    }
    PerformHttpRequest(
        DISCORDHALLOFSHAME_URL_,
        function()
        end,
        "POST",
        json.encode({username = name, embeds = embed}),
        {["Content-Type"] = "application/json"}
    )
end
ESX.RegisterServerCallback(
    "SevenLife:FrakInvite:GetName",
    function(source, cb)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local check =
            MySQL.Sync.fetchAll(
            "SELECT name FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        cb(check[1].name)
    end
)
