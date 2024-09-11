ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("sevenlife:giveeisen")
AddEventHandler(
    "sevenlife:giveeisen",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        local eisen = xplayer.getInventoryItem("eisen").count
        if eisen < 40 then
            xplayer.addInventoryItem("eisen", math.random(Config.eisenmindestens, Config.eisenhuechstens))
        else
            TriggerClientEvent("sevenlife:givenotify", source)
        end
    end
)

RegisterServerEvent("sevenlife:aramidfaser")
AddEventHandler(
    "sevenlife:aramidfaser",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        local aramid = xplayer.getInventoryItem("aramidfasern").count
        if aramid < 40 then
            xplayer.addInventoryItem("aramidfasern", Config.amountofaramid)
        else
            TriggerClientEvent("sevenlife:givenotify", source)
        end
    end
)

RegisterServerEvent("sevenlife:aramidverarbeitenremove")
AddEventHandler(
    "sevenlife:aramidverarbeitenremove",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        local aramid = xplayer.getInventoryItem("aramidfasern").count
        if aramid >= 4 then
            xplayer.removeInventoryItem("aramidfasern", 4)
            TriggerClientEvent("sevenlife:moresteps", source)
        else
            TriggerClientEvent("sevenlife:notenoughitems", source)
        end
    end
)

RegisterServerEvent("sevenlife:aramidverarbeitengivegewebe")
AddEventHandler(
    "sevenlife:aramidverarbeitengivegewebe",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        local aramidgewebe = xplayer.getInventoryItem("aramidgewebe").count
        if aramidgewebe < 30 then
            xplayer.addInventoryItem("aramidgewebe", 1)
        else
            xplayer.addInventoryItem("aramidfasern", 4)
            TriggerClientEvent("sevenlife:enougharamidgewebe", source)
        end
    end
)
-----------------------------------------------------------------------------------------------------
--                                       Westen Mechanic
-----------------------------------------------------------------------------------------------------

RegisterServerEvent("sevenlife:removeitemsleichteweste")
AddEventHandler(
    "sevenlife:removeitemsleichteweste",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        local aramidgewebe = xplayer.getInventoryItem("aramidgewebe").count
        local eisen = xplayer.getInventoryItem("eisen").count
        if aramidgewebe >= 5 and eisen >= 20 then
            xplayer.removeInventoryItem("aramidgewebe", 5)
            xplayer.removeInventoryItem("eisen", 20)
            TriggerClientEvent("sevenlife:nextstep", source)
        else
            TriggerClientEvent("sevenlife:notenoughitemsverarbeiter", source)
        end
    end
)

RegisterServerEvent("sevenlife:giveliechteweste")
AddEventHandler(
    "sevenlife:giveliechteweste",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        xplayer.addInventoryItem("leichteweste", 1)
    end
)
RegisterServerEvent("sevenlife:removeitemsmitterwesete")
AddEventHandler(
    "sevenlife:removeitemsmitterwesete",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        local leichteweste = xplayer.getInventoryItem("leichteweste").count
        local aramidgewebe = xplayer.getInventoryItem("aramidgewebe").count
        local eisen = xplayer.getInventoryItem("eisen").count
        if aramidgewebe >= 5 and eisen >= 20 and leichteweste >= 1 then
            xplayer.removeInventoryItem("aramidgewebe", 5)
            xplayer.removeInventoryItem("leichteweste", 1)
            xplayer.removeInventoryItem("eisen", 20)
            TriggerClientEvent("sevenlife:nextstepmittlere", source)
        else
            TriggerClientEvent("sevenlife:notenoughitemsverarbeiter", source)
        end
    end
)

RegisterServerEvent("sevenlife:givemittlereweste")
AddEventHandler(
    "sevenlife:givemittlereweste",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        xplayer.addInventoryItem("mitllereweste", 1)
    end
)
RegisterServerEvent("sevenlife:removeitemsschwereweste")
AddEventHandler(
    "sevenlife:removeitemsschwereweste",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        local aramidgewebe = xplayer.getInventoryItem("aramidgewebe").count
        local mittlereweste = xplayer.getInventoryItem("mitllereweste").count
        local eisen = xplayer.getInventoryItem("eisen").count
        if aramidgewebe >= 5 and eisen >= 20 and mittlereweste >= 2 then
            xplayer.removeInventoryItem("aramidgewebe", 5)
            xplayer.removeInventoryItem("eisen", 20)
            xplayer.removeInventoryItem("mitllereweste", 1)
            TriggerClientEvent("sevenlife:nextstepschwer", source)
        else
            TriggerClientEvent("sevenlife:notenoughitemsverarbeiter", source)
        end
    end
)

RegisterServerEvent("sevenlife:giveschwereweste")
AddEventHandler(
    "sevenlife:giveschwereweste",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        xplayer.addInventoryItem("schwereweste", 1)
    end
)
-- Westen
ESX.RegisterUsableItem(
    "leichteweste",
    function(source)
        local _source = source

        TriggerClientEvent("sevenlife:leichteweste", _source, 0)
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeInventoryItem("leichteweste", 1)
    end
)
ESX.RegisterUsableItem(
    "mitllereweste",
    function(source)
        local _source = source

        TriggerClientEvent("sevenlife:mittlereweste", _source, 0)
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeInventoryItem("mitllereweste", 1)
    end
)
ESX.RegisterUsableItem(
    "schwereweste",
    function(source)
        local _source = source

        TriggerClientEvent("sevenlife:schwereweste", _source)
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeInventoryItem("schwereweste", 1)
    end
)

-- Farben
ESX.RegisterUsableItem(
    "normalefarbe",
    function(source)
        local _source = source

        TriggerClientEvent("SevenLife:Farbe:OnWeapon", _source, 0)
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeInventoryItem("normalefarbe", 1)
    end
)

ESX.RegisterUsableItem(
    "grünefarbe",
    function(source)
        local _source = source

        TriggerClientEvent("SevenLife:Farbe:OnWeapon", _source, 1)
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeInventoryItem("grünefarbe", 1)
    end
)
ESX.RegisterUsableItem(
    "goldenefarbe",
    function(source)
        local _source = source

        TriggerClientEvent("SevenLife:Farbe:OnWeapon", _source, 2)
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeInventoryItem("goldenefarbe", 1)
    end
)

ESX.RegisterUsableItem(
    "pinkefarbe",
    function(source)
        local _source = source

        TriggerClientEvent("SevenLife:Farbe:OnWeapon", _source, 3)
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeInventoryItem("pinkefarbe", 1)
    end
)

ESX.RegisterUsableItem(
    "orangefarbe",
    function(source)
        local _source = source

        TriggerClientEvent("SevenLife:Farbe:OnWeapon", _source, 6)
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeInventoryItem("orangefarbe", 1)
    end
)
ESX.RegisterUsableItem(
    "platinfarbe",
    function(source)
        local _source = source

        TriggerClientEvent("SevenLife:Farbe:OnWeapon", _source, 7)
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.removeInventoryItem("platinfarbe", 1)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Mine:CheckIfPlayerHavePickaxe",
    function(source, cb)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local itemcount = xPlayer.getInventoryItem("pickaxe").count
        if itemcount >= 1 then
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:Mining:GetPlayerItems")
AddEventHandler(
    "SevenLife:Mining:GetPlayerItems",
    function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        local itemluck1 = math.random(1, 100)
        local itemluck2 = math.random(1, 100)

        local randomitem = math.random(1, 3)
        local rand = math.random(1, 2)
        if itemluck1 < 15 then
            xPlayer.addInventoryItem("platin", 1)
        else
            if itemluck1 >= 15 and itemluck1 <= 47 then
                xPlayer.addInventoryItem("jade", 2)
            end
        end

        if itemluck2 < 2 then
            xPlayer.addInventoryItem("pinkerkristall", 1)
        else
            if itemluck2 >= 3 and itemluck2 <= 47 then
                xPlayer.addInventoryItem("gold", rand)
            else
                xPlayer.addInventoryItem("kupfer", randomitem)
            end
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Chekifenoughitems",
    function(source, cb, item1, anzahl1, item2, anzahl2, item3, anzahl3)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        local items1 = xPlayer.getInventoryItem(item1).count
        local items2 = xPlayer.getInventoryItem(item2).count
        if item3 ~= nil then
            items3 = xPlayer.getInventoryItem(item3).count
        end

        if item3 ~= nil then
            if items1 >= anzahl1 and items2 >= anzahl2 and items3 >= anzahl3 then
                cb(true)
            else
                cb(false)
            end
        else
            if items1 >= anzahl1 and items2 >= anzahl2 then
                cb(true)
            else
                cb(false)
            end
        end
    end
)

RegisterServerEvent("SevenLife:Mine:Crafter:RemoveItems")
AddEventHandler(
    "SevenLife:Mine:Crafter:RemoveItems",
    function(item1, anzahl1, item2, anzahl2, item3, anzahl3)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        xPlayer.removeInventoryItem(item1, anzahl1)
        xPlayer.removeInventoryItem(item2, anzahl2)
        if item3 ~= nil then
            xPlayer.removeInventoryItem(item3, anzahl3)
        end
    end
)

RegisterServerEvent("SevenLife:Mine:Crafter:GiveItemEnd")
AddEventHandler(
    "SevenLife:Mine:Crafter:GiveItemEnd",
    function(item)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        xPlayer.addInventoryItem(item, 1)
    end
)

RegisterServerEvent("sevenlife:removeitemstasche")
AddEventHandler(
    "sevenlife:removeitemstasche",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        local aramidgewebe = xplayer.getInventoryItem("leatherperfekt").count
        local eisen = xplayer.getInventoryItem("nagel").count
        if aramidgewebe >= 5 and eisen >= 20 then
            xplayer.removeInventoryItem("leatherperfekt", 5)
            xplayer.removeInventoryItem("nagel", 20)
            TriggerClientEvent("sevenlife:nextsteptasche", source)
        else
            TriggerClientEvent("sevenlife:notenoughitemsverarbeiter", source)
        end
    end
)

RegisterServerEvent("sevenlife:givetasche")
AddEventHandler(
    "sevenlife:givetasche",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        xplayer.addInventoryItem("tasche", 1)
    end
)
ESX.RegisterUsableItem(
    "tasche",
    function(source)
        local _source = source

        TriggerClientEvent("SevenLife:Tasche:Anziehen", _source)
    end
)

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

AddEventHandler(
    "esx:playerLogout",
    function(source)
        src = source

        if src == nil then
            return
        end

        Save(src)
    end
)

local StatusOfPlayer = {}

MySQL.Async.fetchAll(
    "SELECT identifier, health FROM `users`",
    {},
    function(data)
        for k, v in ipairs(data) do
            StatusOfPlayer[v.identifier] = v.health
        end
    end
)

RegisterServerEvent("SevenLife:Westen:Save")
AddEventHandler(
    "SevenLife:Westen:Save",
    function()
        src = source

        if src == nil then
            return
        end

        local xPlayer = ESX.GetPlayerFromId(src)
        local identifier = xPlayer.identifier

        if StatusOfPlayer[identifier] == nil then
            MySQL.Async.execute(
                "UPDATE users SET health = @health WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifier,
                    ["@health"] = "{}"
                }
            )

            StatusOfPlayer[identifier] = {}
        end

        local health =
            MySQL.Sync.fetchAll(
            "SELECT `health` FROM `users` WHERE `identifier` = @identifier",
            {
                ["@identifier"] = identifier
            },
            function(result)
            end
        )

        if health[1] then
            data = json.decode(health[1].health)

            if data.Health == nil then
                return
            end

            TriggerClientEvent("SevenLife:SaveWeste:SetData", src, data)
        end
    end
)

AddEventHandler(
    "playerDropped",
    function(reason)
        src = source

        if src == nil then
            return
        end
        Save(src)
    end
)

function Save(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier

    local playerPed = GetPlayerPed(src)
    local health = GetEntityHealth(playerPed)
    local armour = GetPedArmour(playerPed)

    local data = {}
    data.Health = health
    data.Armour = armour

    local jsonData = json.encode(data)

    MySQL.Async.execute(
        "UPDATE `users` SET `health` = '" .. jsonData .. "' WHERE `identifier` = '" .. identifier .. "'"
    )
end
