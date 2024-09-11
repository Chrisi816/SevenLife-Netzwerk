ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:MaskeMenu:CheckIfEnoughMoney",
    function(source, cb, money)
        local money1 = tonumber(money)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getMoney() >= money1 then
            xPlayer.removeMoney(money1)
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:Kleidungsladen:SaveOutfit")
AddEventHandler(
    "SevenLife:Kleidungsladen:SaveOutfit",
    function(outfitName, model, skinData)
        local src = source
        local Player = ESX.GetPlayerFromId(src)
        local identifiers = ESX.GetPlayerFromId(source).identifier

        if model ~= nil and skinData ~= nil then
            local outfitId = "outfit-" .. math.random(1, 10) .. "-" .. math.random(1111, 9999)
            MySQL.Async.execute(
                "INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (@citizenid, @outfitname, @model, @skin, @outfitId)",
                {
                    ["@citizenid"] = identifiers,
                    ["@outfitname"] = outfitName,
                    ["@model"] = model,
                    ["@skin"] = json.encode(skinData),
                    ["@outfitId"] = outfitId
                },
                function()
                    TriggerClientEvent("SevenLife:Klamotten:Erfolgreichgespeichert", src)
                end
            )
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Kleidungsladen:GetOutfits",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM player_outfits WHERE citizenid = @citizenid ",
            {
                ["@citizenid"] = identifiers
            },
            function(result)
                cb(result)
            end
        )
    end
)

RegisterServerEvent("SevenLife:Kleidungsladen:DeleteOutfit")
AddEventHandler(
    "SevenLife:Kleidungsladen:DeleteOutfit",
    function(name, model, skin, outfitId)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.execute(
            "DELETE FROM player_outfits WHERE outfitId = @outfitId AND citizenid  = @citizenid",
            {
                ["@outfitId"] = outfitId,
                ["@citizenid"] = identifiers
            },
            function()
            end
        )
    end
)
