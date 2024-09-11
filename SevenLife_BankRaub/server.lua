ESX = nil
local ActivRaub, KlingeGestarted = false, false

-- ESX

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:BankRaub:CheckIfPlayerHaveItem",
    function(source, cb, item, howmuch)
        local xPlayer = ESX.GetPlayerFromId(source)
        local itemammount = xPlayer.getInventoryItem(item).count
        if itemammount >= tonumber(howmuch) then
            cb(true)
        else
            cb(false)
        end
    end
)
RegisterServerEvent("SevenLife:BankRob:SyncPlaceOfBomb")
AddEventHandler(
    "SevenLife:BankRob:SyncPlaceOfBomb",
    function(x, y, z, h, id)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("bigc4", 2)
        ActivRaub = true
        TriggerClientEvent("SevenLife:BankRob:ApplyBomba", -1, y, x, z, h)
        SetTimeout(
            10000,
            function()
                TriggerClientEvent("SevenLife:BankRob:SyncPlayerBomb", -1, y, x, z, h, id)
                TriggerEvent("SevenLife:PD:MakeWarning", "Staatsbank")
            end
        )
    end
)
RegisterServerEvent("SevenLife:BankRob:SyncPlaceOfBomb2")
AddEventHandler(
    "SevenLife:BankRob:SyncPlaceOfBomb2",
    function(x, y, z, h, id)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("bigc4", 2)
        ActivRaub = true
        TriggerClientEvent("SevenLife:BankRob:ApplyBomba", -1, y, x, z, h)
        SetTimeout(
            10000,
            function()
                TriggerClientEvent("SevenLife:BankRob:SyncPlayerBomb", -1, y, x, z, h, id)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:BankRaub:CheckIfRaubIsOnGoing",
    function(source, cb)
        if ActivRaub then
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:BankRob:DeleteBomba")
AddEventHandler(
    "SevenLife:BankRob:DeleteBomba",
    function(bomba)
        TriggerClientEvent("SevenLife:BankRob:DeleteBombaSync", -1, bomba)
    end
)

RegisterServerEvent("SevenLife:BankRaub:GiveItem")
AddEventHandler(
    "SevenLife:BankRaub:GiveItem",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local number = math.random(1, 10)
        if 2 >= number then
            xPlayer.addInventoryItem("halskette", 1)
            xPlayer.addInventoryItem("juwelen", 3)
        elseif 2 > number and 8 < number then
            xPlayer.addInventoryItem("halskette", 1)
            xPlayer.addInventoryItem("armband", 1)
        elseif 10 >= number and 8 <= number then
            xPlayer.addInventoryItem("halskette", 2)
            xPlayer.addInventoryItem("juwelen", 1)
        end
    end
)
RegisterServerEvent("SevenLife:BankRaub:OpenVault")
AddEventHandler(
    "SevenLife:BankRaub:OpenVault",
    function(method)
        TriggerClientEvent("SevenLife:BankRaubC:OpenVault", -1, method)
    end
)
RegisterServerEvent("SevenLife:BankRaub:GiveCash")
AddEventHandler(
    "SevenLife:BankRaub:GiveCash",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local number = math.random(1, 100)
        xPlayer.addAccountMoney("money", number)
        TriggerEvent("SevenLife:BankRaub:MakeTimer")
    end
)

RegisterServerEvent("SevenLife:BankRaub:MakeTimer")
AddEventHandler(
    "SevenLife:BankRaub:MakeTimer",
    function()
        if not KlingeGestarted then
            KlingeGestarted = true
            SetTimeout(
                30 * 60000,
                function()
                    KlingeGestarted = false
                    TriggerClientEvent("SevenLife:BankRaub:Ausgeklungen", -1)
                end
            )
        end
    end
)
RegisterServerEvent("SevenLife:BankRuab:StartGas")
AddEventHandler(
    "SevenLife:BankRuab:StartGas",
    function()
        TriggerClientEvent("SevenLife:BankRaub:MakeGas", -1)
        TriggerClientEvent(
            "SevenLife:TimetCustom:Notify",
            source,
            "Bankraub",
            "Du hast 300 Sec / 5min Zeit bis das Gaß kommt",
            2000
        )
    end
)
RegisterServerEvent("SevenLife:BankRaub:GiveReward")
AddEventHandler(
    "SevenLife:BankRaub:GiveReward",
    function()
        local number = math.random(1, 5)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("goldbarren", number)
    end
)
RegisterServerEvent("SevenLife:BankRaub:GetMoneyFromKasseS")

AddEventHandler(
    "SevenLife:BankRaub:GetMoneyFromKasseS",
    function()
        TriggerClientEvent("SevenLife:BankRaub:GetMoneyFromKasseC", -1)
    end
)
RegisterServerEvent("SevenLife:BankRaub:ResetEveryThingS")
AddEventHandler(
    "SevenLife:BankRaub:ResetEveryThingS",
    function()
        TriggerClientEvent("SevenLife:BankRaub:ResetEveryThingC", -1)
    end
)
RegisterServerEvent("SevenLife:BankRaub:MakeAlarm")
AddEventHandler(
    "SevenLife:BankRaub:MakeAlarm",
    function(status)
        TriggerClientEvent("SevenLife:BankRaub:MakeAlarmC", -1, status)
    end
)
