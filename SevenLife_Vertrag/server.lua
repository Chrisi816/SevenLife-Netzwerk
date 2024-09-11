ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:Vertrag:VertragÜbergeben")
AddEventHandler(
    "SevenLife:Vertrag:VertragÜbergeben",
    function(player, unterschrift, beschreibung, titel)
        local identifier = ESX.GetPlayerFromId(source).identifier
        TriggerClientEvent("SevenLife:Vertrag:VertragGeben", player, unterschrift, beschreibung, titel, identifier)
    end
)

RegisterServerEvent("SevenLife:Vertrag:InsertIntoDb")
AddEventHandler(
    "SevenLife:Vertrag:InsertIntoDb",
    function(unterschrift, beschreibung, titel, unterschrift2, identifier)
        MySQL.Async.execute(
            "INSERT INTO vertrag_db (identifer,titel,beschreibung,unterschrift,unterschrift2) VALUES (@identifer,@titel,@beschreibung,@unterschrift,@unterschrift2)",
            {
                ["@identifer"] = identifier,
                ["@titel"] = titel,
                ["@beschreibung"] = beschreibung,
                ["@unterschrift"] = unterschrift,
                ["@unterschrift2"] = unterschrift2
            },
            function()
            end
        )
    end
)

ESX.RegisterUsableItem(
    "custom_vertrag",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local itemcount = xPlayer.getInventoryItem("custom_vertrag").count

        if itemcount >= 1 then
            xPlayer.removeInventoryItem("custom_vertrag", 1)
            TriggerClientEvent("SevenLife:Vertrag:MakeVertrag", source)
        else
            TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Vertrag", "Du hast kein Vertrag mehr", 1500)
        end
    end
)
ESX.RegisterUsableItem(
    "vertrag_tasche",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local itemcount = xPlayer.getInventoryItem("vertrag_tasche").count
        local identifier = ESX.GetPlayerFromId(source).identifier
        local source = source
        if itemcount >= 1 then
            MySQL.Async.fetchAll(
                "SELECT * FROM vertrag_db WHERE identifer = @identifer ",
                {
                    ["@identifer"] = identifier
                },
                function(result)
                    TriggerClientEvent("SevenLife:Vertrag:OpenVertragsTasche", source, result)
                end
            )
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Vertrag",
                "Du hast keinen Aktenkoffer mehr",
                1500
            )
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:OpenAkteInformationen",
    function(source, cb, id)
        local id = tonumber(id)
        MySQL.Async.fetchAll(
            "SELECT * FROM vertrag_db WHERE id = @id ",
            {
                ["@id"] = id
            },
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Vertrag:GiveVertrag")
AddEventHandler(
    "SevenLife:Vertrag:GiveVertrag",
    function(target, id)
        local id = tonumber(id)
        MySQL.Async.fetchAll(
            "SELECT * FROM vertrag_db WHERE id = @id ",
            {
                ["@id"] = id
            },
            function(result)
                TriggerClientEvent("SevenLife:Vertrag:GiverVertagy", target, result)
            end
        )
    end
)
