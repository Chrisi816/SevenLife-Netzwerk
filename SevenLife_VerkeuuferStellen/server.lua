ESX = nil
local DISCORDHALLOFSHAME_URL_ = Config.Webhook
local endpreisfleisch1
local endpreisfleisch2
local endpreisfleisch3
local endpreisnagel1
local endpreisnagel2
local endpreisnagel3
local endpreisleder1
local endpreisleder2
local endpreisleder3
local endpreiseisen1
local endpreiseisen2
local endpreiseisen3
local endpreisgold1
local endpreisgold2
local endpreisgold3
local endpreisplatin1
local endpreisplatin2
local endpreisplatin3
local endpreiskupfer1
local endpreiskupfer2
local endpreiskupfer3
local endpreisjade1
local endpreisjade2
local endpreisjade3
local endpreisglas1
local endpreisglas2
local endpreisglas3
local endpreisdiamond1
local endpreisdiamond2
local endpreisdiamond3
local endpreisorange1
local endpreisorange2
local endpreisorange3

local gebratenerbarsch1
local gebratenerbarsch2
local gebratenerbarsch3
local gebratenerkarpfen1
local gebratenerkarpfen2
local gebratenerkarpfen3
local gebratenerforelle1
local gebratenerforelle2
local gebratenerforelle3
local gebratenerlachs1
local gebratenerlachs2
local gebratenerlachs3

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Verakeufer:GetItems",
    function(source, cb, id)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT item, preis FROM verkeaufer WHERE id = @id",
            {
                ["@id"] = id
            },
            function(result)
                cb(result)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Verkeufer:GetEnough",
    function(source, cb, item, anzahl)
        local items
        local xPlayer = ESX.GetPlayerFromId(source)
        if item == "Verpackte_Orangen" then
            items = "verpackte_orange"
        else
            items = string.lower(item)
        end

        local itemcount = xPlayer.getInventoryItem(items).count
        if itemcount >= anzahl then
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:Verkeufer:MakeEndStep")
AddEventHandler(
    "SevenLife:Verkeufer:MakeEndStep",
    function(zahlen, name, anzahl)
        local names

        local xPlayer = ESX.GetPlayerFromId(source)
        if name == "Verpackte_Orangen" then
            names = "verpackte_orange"
        else
            names = string.lower(name)
        end

        xPlayer.addAccountMoney("money", zahlen)
        xPlayer.removeInventoryItem(names, anzahl)

        local _source = source
        local identifier = xPlayer.identifier
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM battlepassmissionen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )

        if check[1] ~= nil then
            if tonumber(check[1].index1) == 5 then
                if names == "verpackte_orange" then
                    if anzahl >= 100 then
                        TriggerEvent("SevenLife:SeasonPass:MakeProgress", 1, false, _source, tonumber(anzahl), 50)
                    end
                end
            elseif tonumber(check[1].index1) == 6 then
                if names == "kartoffelsalat" then
                    if anzahl >= 100 then
                        TriggerEvent("SevenLife:SeasonPass:MakeProgress", 1, false, _source, tonumber(anzahl), 50)
                    end
                end
            elseif tonumber(check[1].index1) == 7 then
                if names == "karottensaft" then
                    if anzahl >= 100 then
                        TriggerEvent("SevenLife:SeasonPass:MakeProgress", 1, false, _source, tonumber(anzahl), 50)
                    end
                end
            end
        end
    end
)
AddEventHandler(
    "onResourceStart",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end

        Citizen.Wait(50000)

        TriggerEvent("SevenLife:Verkäufer:MakePreis1")
        TriggerEvent("SevenLife:Verkäufer:MakePreis2")
        TriggerEvent("SevenLife:Verkäufer:MakePreis3")
        Citizen.Wait(15000)
        TriggerEvent("SevenLife:Verkäufer:MakeDiscordRequest")
    end
)

RegisterServerEvent("SevenLife:Verkäufer:MakePreis1")
AddEventHandler(
    "SevenLife:Verkäufer:MakePreis1",
    function()
        MySQL.Async.fetchAll(
            "SELECT * FROM verkeaufer WHERE id = @id",
            {
                ["@id"] = 1
            },
            function(result)
                for v, k in ipairs(result) do
                    if k.item == "Nagel" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-1, 1)
                            endpreisnagel1 = endpreis + y
                        else
                            endpreisnagel1 = endpreis + 1
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisnagel1,
                                ["@item"] = "Nagel",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Leder" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisleder1 = endpreis + y
                        else
                            endpreisleder1 = endpreis + 1
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id ",
                            {
                                ["@preis"] = endpreisleder1,
                                ["@item"] = "Leder",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Fleisch" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisfleisch1 = endpreis + y
                        else
                            endpreisfleisch1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisfleisch1,
                                ["@item"] = "Fleisch",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Eisen" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreiseisen1 = endpreis + y
                        else
                            endpreiseisen1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreiseisen1,
                                ["@item"] = "Eisen",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Gold" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisgold1 = endpreis + y
                        else
                            endpreisgold1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisgold1,
                                ["@item"] = "Gold",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Platin" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisplatin1 = endpreis + y
                        else
                            endpreisplatin1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisplatin1,
                                ["@item"] = "Platin",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Kupfer" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreiskupfer1 = endpreis + y
                        else
                            endpreiskupfer1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreiskupfer1,
                                ["@item"] = "Kupfer",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Jade" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisjade1 = endpreis + y
                        else
                            endpreisjade1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisjade1,
                                ["@item"] = "Jade",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Glas" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisglas1 = endpreis + y
                        else
                            endpreisglas1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisglas1,
                                ["@item"] = "Glas",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Diamond" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisdiamond1 = endpreis + y
                        else
                            endpreisdiamond1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisdiamond1,
                                ["@item"] = "Diamond",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Verpackte_Orangen" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisorange1 = endpreis + y
                        else
                            endpreisorange1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisorange1,
                                ["@item"] = "Verpackte_Orangen",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Barsch" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            gebratenerbarsch1 = endpreis + y
                        else
                            gebratenerbarsch1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = gebratenerbarsch1,
                                ["@item"] = "Barsch",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Karpfen" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            gebratenerkarpfen1 = endpreis + y
                        else
                            gebratenerkarpfen1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = gebratenerkarpfen1,
                                ["@item"] = "Karpfen",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Forelle" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            gebratenerforelle1 = endpreis + y
                        else
                            gebratenerforelle1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = gebratenerforelle1,
                                ["@item"] = "Forelle",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Lachs" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            gebratenerlachs1 = endpreis + y
                        else
                            gebratenerlachs1 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = gebratenerlachs1,
                                ["@item"] = "Lachs",
                                ["@id"] = 1
                            },
                            function(result)
                            end
                        )
                    end
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Verkäufer:MakePreis2")
AddEventHandler(
    "SevenLife:Verkäufer:MakePreis2",
    function()
        MySQL.Async.fetchAll(
            "SELECT * FROM verkeaufer WHERE id = @id",
            {
                ["@id"] = 2
            },
            function(result)
                for v, k in ipairs(result) do
                    if k.item == "Nagel" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-1, 1)
                            endpreisnagel2 = endpreis + y
                        else
                            endpreisnagel2 = endpreis + 1
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisnagel2,
                                ["@item"] = "Nagel",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Leder" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisleder2 = endpreis + y
                        else
                            endpreisleder2 = endpreis + 1
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id ",
                            {
                                ["@preis"] = endpreisleder2,
                                ["@item"] = "Leder",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Fleisch" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisfleisch2 = endpreis + y
                        else
                            endpreisfleisch2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisfleisch2,
                                ["@item"] = "Fleisch",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Eisen" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreiseisen2 = endpreis + y
                        else
                            endpreiseisen2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreiseisen2,
                                ["@item"] = "Eisen",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Gold" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisgold2 = endpreis + y
                        else
                            endpreisgold2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisgold2,
                                ["@item"] = "Gold",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Platin" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisplatin2 = endpreis + y
                        else
                            endpreisplatin2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisplatin2,
                                ["@item"] = "Platin",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Kupfer" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreiskupfer2 = endpreis + y
                        else
                            endpreiskupfer2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreiskupfer2,
                                ["@item"] = "Kupfer",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Jade" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisjade2 = endpreis + y
                        else
                            endpreisjade2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisjade2,
                                ["@item"] = "Jade",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Glas" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisglas2 = endpreis + y
                        else
                            endpreisglas2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisglas2,
                                ["@item"] = "Glas",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Diamond" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisdiamond2 = endpreis + y
                        else
                            endpreisdiamond2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisdiamond2,
                                ["@item"] = "Diamond",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Verpackte_Orangen" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisorange2 = endpreis + y
                        else
                            endpreisorange2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisorange2,
                                ["@item"] = "Verpackte_Orangen",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Barsch" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            gebratenerbarsch2 = endpreis + y
                        else
                            gebratenerbarsch2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = gebratenerbarsch2,
                                ["@item"] = "Barsch",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Karpfen" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            gebratenerkarpfen2 = endpreis + y
                        else
                            gebratenerkarpfen2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = gebratenerkarpfen2,
                                ["@item"] = "Karpfen",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Forelle" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            gebratenerforelle2 = endpreis + y
                        else
                            gebratenerforelle2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = gebratenerforelle2,
                                ["@item"] = "Forelle",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Lachs" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            gebratenerlachs2 = endpreis + y
                        else
                            gebratenerlachs2 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = gebratenerlachs2,
                                ["@item"] = "Lachs",
                                ["@id"] = 2
                            },
                            function(result)
                            end
                        )
                    end
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Verkäufer:MakePreis3")
AddEventHandler(
    "SevenLife:Verkäufer:MakePreis3",
    function()
        MySQL.Async.fetchAll(
            "SELECT * FROM verkeaufer WHERE id = @id",
            {
                ["@id"] = 3
            },
            function(result)
                for v, k in ipairs(result) do
                    if k.item == "Nagel" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-1, 1)
                            endpreisnagel3 = endpreis + y
                        else
                            endpreisnagel3 = endpreis + 1
                        end

                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisnagel3,
                                ["@item"] = "Nagel",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Leder" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisleder3 = endpreis + y
                        else
                            endpreisleder3 = endpreis + 1
                        end

                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id ",
                            {
                                ["@preis"] = endpreisleder3,
                                ["@item"] = "Leder",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Fleisch" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisfleisch3 = endpreis + y
                        else
                            endpreisfleisch3 = endpreis + 2
                        end

                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisfleisch3,
                                ["@item"] = "Fleisch",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Eisen" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreiseisen3 = endpreis + y
                        else
                            endpreiseisen3 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreiseisen3,
                                ["@item"] = "Eisen",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Gold" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisgold3 = endpreis + y
                        else
                            endpreisgold3 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisgold3,
                                ["@item"] = "Gold",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Platin" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisplatin3 = endpreis + y
                        else
                            endpreisplatin3 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisplatin3,
                                ["@item"] = "Platin",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Kupfer" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreiskupfer3 = endpreis + y
                        else
                            endpreiskupfer3 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreiskupfer3,
                                ["@item"] = "Kupfer",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Jade" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisjade3 = endpreis + y
                        else
                            endpreisjade3 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisjade3,
                                ["@item"] = "Jade",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Glas" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisglas3 = endpreis + y
                        else
                            endpreisglas3 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisglas3,
                                ["@item"] = "Glas",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Diamond" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisdiamond3 = endpreis + y
                        else
                            endpreisdiamond3 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisdiamond3,
                                ["@item"] = "Diamond",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end

                    if k.item == "Verpackte_Orangen" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            endpreisorange3 = endpreis + y
                        else
                            endpreisorange3 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = endpreisorange3,
                                ["@item"] = "Verpackte_Orangen",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Barsch" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            gebratenerbarsch3 = endpreis + y
                        else
                            gebratenerbarsch3 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = gebratenerbarsch3,
                                ["@item"] = "Barsch",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Karpfen" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            gebratenerkarpfen3 = endpreis + y
                        else
                            gebratenerkarpfen3 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = gebratenerkarpfen3,
                                ["@item"] = "Karpfen",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Forelle" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            gebratenerforelle3 = endpreis + y
                        else
                            gebratenerforelle3 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = gebratenerforelle3,
                                ["@item"] = "Forelle",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end
                    if k.item == "Lachs" then
                        local endpreis = tonumber(k.preis)
                        if endpreis >= 1 then
                            local y = math.random(-2, 2)
                            gebratenerlachs3 = endpreis + y
                        else
                            gebratenerlachs3 = endpreis + 2
                        end
                        MySQL.Async.execute(
                            "UPDATE verkeaufer SET preis = @preis WHERE item = @item AND id = @id",
                            {
                                ["@preis"] = gebratenerlachs3,
                                ["@item"] = "Lachs",
                                ["@id"] = 3
                            },
                            function(result)
                            end
                        )
                    end
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:Verkäufer:MakeDiscordRequest")
AddEventHandler(
    "SevenLife:Verkäufer:MakeDiscordRequest",
    function()
        local endpreisnagel1 = tonumber(endpreisnagel1)
        local endpreisnagel2 = tonumber(endpreisnagel2)
        local endpreisnagel3 = tonumber(endpreisnagel3)
        local endpreisfleisch1 = tonumber(endpreisfleisch1)
        local endpreisfleisch2 = tonumber(endpreisfleisch2)
        local endpreisfleisch3 = tonumber(endpreisfleisch3)
        local endpreisleder1 = tonumber(endpreisleder1)
        local endpreisleder2 = tonumber(endpreisleder2)
        local endpreisleder3 = tonumber(endpreisleder3)
        SendInfoToDiscord(
            16711680,
            "🛑 ! Preis Veränderung der Verkäufer !",
            "Verkäufer **#1** \n ```- Nägel: " ..
                endpreisnagel1 ..
                    "$\n- Fleisch: " ..
                        endpreisfleisch1 ..
                            "$\n- Leder: " ..
                                endpreisleder1 ..
                                    "$\n- Eisen: " ..
                                        endpreiseisen1 ..
                                            "$\n- Gold: " ..
                                                endpreisgold1 ..
                                                    "$\n- Platin: " ..
                                                        endpreisplatin1 ..
                                                            "$\n- Kupfer: " ..
                                                                endpreiskupfer1 ..
                                                                    "$\n- Jade: " ..
                                                                        endpreisjade1 ..
                                                                            "$\n- Glas: " ..
                                                                                endpreisglas1 ..
                                                                                    "$\n- Diamond: " ..
                                                                                        endpreisdiamond1 ..
                                                                                            "$\n- Verpackte Orangen: " ..
                                                                                                endpreisorange1 ..
                                                                                                    "$\n- Barsch: " ..
                                                                                                        gebratenerbarsch1 ..
                                                                                                            "$\n- Karpfen: " ..
                                                                                                                gebratenerkarpfen1 ..
                                                                                                                    "$\n- Forelle: " ..
                                                                                                                        gebratenerforelle1 ..
                                                                                                                            "$\n- Lachs: " ..
                                                                                                                                gebratenerlachs1 ..
                                                                                                                                    "$\n ``` Verkäufer **#2** \n ```- Nägel: " ..
                                                                                                                                        endpreisnagel2 ..
                                                                                                                                            "$\n- Fleisch: " ..
                                                                                                                                                endpreisfleisch2 ..
                                                                                                                                                    "$\n- Leder: " ..
                                                                                                                                                        endpreisleder2 ..
                                                                                                                                                            "$\n- Eisen: " ..
                                                                                                                                                                endpreiseisen2 ..
                                                                                                                                                                    "$\n- Gold: " ..
                                                                                                                                                                        endpreisgold2 ..
                                                                                                                                                                            "$\n- Platin: " ..
                                                                                                                                                                                endpreisplatin2 ..
                                                                                                                                                                                    "$\n- Kupfer: " ..
                                                                                                                                                                                        endpreiskupfer2 ..
                                                                                                                                                                                            "$\n- Jade: " ..
                                                                                                                                                                                                endpreisjade2 ..
                                                                                                                                                                                                    "$\n- Glas: " ..
                                                                                                                                                                                                        endpreisglas2 ..
                                                                                                                                                                                                            "$\n- Diamond: " ..
                                                                                                                                                                                                                endpreisdiamond2 ..
                                                                                                                                                                                                                    "$\n- Verpackte Orangen: " ..
                                                                                                                                                                                                                        endpreisorange2 ..
                                                                                                                                                                                                                            "$\n- Barsch: " ..
                                                                                                                                                                                                                                gebratenerbarsch2 ..
                                                                                                                                                                                                                                    "$\n- Karpfen: " ..
                                                                                                                                                                                                                                        gebratenerkarpfen2 ..
                                                                                                                                                                                                                                            "$\n- Forelle: " ..
                                                                                                                                                                                                                                                gebratenerforelle2 ..
                                                                                                                                                                                                                                                    "$\n- Lachs: " ..
                                                                                                                                                                                                                                                        gebratenerlachs2 ..
                                                                                                                                                                                                                                                            "$\n```\n Verkäufer **#3** \n ```- Nägel: " ..
                                                                                                                                                                                                                                                                endpreisnagel3 ..
                                                                                                                                                                                                                                                                    "$\n- Fleisch: " ..
                                                                                                                                                                                                                                                                        endpreisfleisch3 ..
                                                                                                                                                                                                                                                                            "$\n- Leder: " ..
                                                                                                                                                                                                                                                                                endpreisleder3 ..
                                                                                                                                                                                                                                                                                    "$\n- Eisen: " ..
                                                                                                                                                                                                                                                                                        endpreiseisen3 ..
                                                                                                                                                                                                                                                                                            "$\n- Gold: " ..
                                                                                                                                                                                                                                                                                                endpreisgold3 ..
                                                                                                                                                                                                                                                                                                    "$\n- Platin: " ..
                                                                                                                                                                                                                                                                                                        endpreisplatin3 ..
                                                                                                                                                                                                                                                                                                            "$\n- Kupfer: " ..
                                                                                                                                                                                                                                                                                                                endpreiskupfer3 ..
                                                                                                                                                                                                                                                                                                                    "$\n- Jade: " ..
                                                                                                                                                                                                                                                                                                                        endpreisjade3 ..
                                                                                                                                                                                                                                                                                                                            "$\n- Glas: " ..
                                                                                                                                                                                                                                                                                                                                endpreisglas3 ..
                                                                                                                                                                                                                                                                                                                                    "$\n- Diamond: " ..
                                                                                                                                                                                                                                                                                                                                        endpreisdiamond3 ..
                                                                                                                                                                                                                                                                                                                                            "$\n- Verpackte Orangen: " ..
                                                                                                                                                                                                                                                                                                                                                endpreisorange3 ..
                                                                                                                                                                                                                                                                                                                                                    "$\n- Barsch: " ..
                                                                                                                                                                                                                                                                                                                                                        gebratenerbarsch3 ..
                                                                                                                                                                                                                                                                                                                                                            "$\n- Karpfen: " ..
                                                                                                                                                                                                                                                                                                                                                                gebratenerkarpfen3 ..
                                                                                                                                                                                                                                                                                                                                                                    "$\n- Forelle: " ..
                                                                                                                                                                                                                                                                                                                                                                        gebratenerforelle3 ..
                                                                                                                                                                                                                                                                                                                                                                            "$\n- Lachs: " ..
                                                                                                                                                                                                                                                                                                                                                                                gebratenerlachs3 ..
                                                                                                                                                                                                                                                                                                                                                                                    "$\n ```",
            "SevenLife_InfoSystem"
        )
    end
)

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
