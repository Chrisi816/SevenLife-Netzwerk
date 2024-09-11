ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:Fischer:GiveJobToPlayer")
AddEventHandler(
    "SevenLife:Fischer:GiveJobToPlayer",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.setJob("fischer", 0)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Fischer:CheckJob",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = xPlayer.getJob()
        if job.name == "fischer" then
            cb(true)
        else
            cb(false)
        end
    end
)
ESX.RegisterUsableItem(
    "angel",
    function(source)
        local _source = source
        TriggerClientEvent("SevenLife:Fischer:StartFisching", _source)
    end
)

ESX.RegisterUsableItem(
    "würmer",
    function(source)
        local _source = source
        TriggerClientEvent("SevenLife:Fischer:ChangeKoeder", _source, "würmer")
    end
)
ESX.RegisterUsableItem(
    "maden",
    function(source)
        local _source = source
        TriggerClientEvent("SevenLife:Fischer:ChangeKoeder", _source, "maden")
    end
)

ESX.RegisterUsableItem(
    "gummifisch",
    function(source)
        local _source = source
        TriggerClientEvent("SevenLife:Fischer:ChangeKoeder", _source, "gummifisch")
    end
)

RegisterServerEvent("SevenLife:Fischer:FischGefangen")
AddEventHandler(
    "SevenLife:Fischer:FischGefangen",
    function(bait)
        local _source = source
        local rnd = math.random(1, 100)
        local xPlayer = ESX.GetPlayerFromId(_source)
        if bait == "gummifisch" then
            xPlayer.removeInventoryItem("gummifisch", 1)
            if rnd >= 78 then
                if rnd >= 94 then
                    TriggerClientEvent("SevenLife:Fischer:ChangeKoeder", _source, "keins")
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Information",
                        "Deine Angel Route ist gebrochen, da der Fisch zu schwer war",
                        2000
                    )
                    TriggerClientEvent("SevenLife:Fischer:StopFisching", _source)
                    xPlayer.removeInventoryItem("angel", 1)
                else
                    TriggerClientEvent("SevenLife:Fischer:ChangeKoeder", _source, "keins")
                    if xPlayer.getInventoryItem("barsch").count > 6 then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du kannst keine Barsche mehr halten!",
                            2000
                        )
                    else
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du hast Barsche erhalten! " .. weight .. " KG!",
                            2000
                        )
                        xPlayer.addInventoryItem("barsch", 1)
                    end
                end
            else
                if rnd >= 75 then
                    if xPlayer.getInventoryItem("karpfen").count > 10 then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du kannst keine Karpfen mehr erhalten!",
                            2000
                        )
                    else
                        weight = math.random(4, 9)
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du hast einen Karpfen gefangen! " .. weight .. " KG!",
                            2000
                        )
                        xPlayer.addInventoryItem("karpfen", weight)
                    end
                else
                    if xPlayer.getInventoryItem("karpfen").count > 100 then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du kannst keine Karpfen mehr erhalten!",
                            2000
                        )
                    else
                        weight = math.random(2, 6)
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du hast einen Karpfen gefangen! " .. weight .. " KG!",
                            2000
                        )
                        xPlayer.addInventoryItem("karpfen", weight)
                    end
                end
            end
        else
            if bait == "maden" then
                xPlayer.addInventoryItem("maden", 1)
                if rnd >= 75 then
                    TriggerClientEvent("SevenLife:Fischer:ChangeKoeder", _source, "keins")
                    if xPlayer.getInventoryItem("barsch").count > 100 then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du kannst keine Barsche mehr erhalten!",
                            2000
                        )
                    else
                        weight = math.random(4, 11)
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du hast einen Barsch gefangen!",
                            2000
                        )
                        xPlayer.addInventoryItem("barsch", weight)
                    end
                else
                    if xPlayer.getInventoryItem("barsch").count > 100 then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du kannst keine Barsche mehr erhalten!",
                            2000
                        )
                    else
                        weight = math.random(1, 6)
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du hast einen Barsch gefangen! " .. weight .. " KG!",
                            2000
                        )
                        xPlayer.addInventoryItem("barsch", weight)
                    end
                end
            end
            if bait == "keins" then
                if rnd >= 70 then
                    if xPlayer.getInventoryItem("forelle").count > 100 then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du kannst keine Forellen mehr erhalten!",
                            2000
                        )
                    else
                        weight = math.random(2, 4)
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du hast eine Forelle gefangen!",
                            2000
                        )
                        xPlayer.addInventoryItem("forelle", weight)
                    end
                else
                    if xPlayer.getInventoryItem("forelle").count > 100 then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du kannst keine Forellen mehr erhalten!",
                            2000
                        )
                    else
                        weight = math.random(1, 2)
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du hast eine Forelle gefangen! " .. weight .. " KG!",
                            2000
                        )
                        xPlayer.addInventoryItem("forelle", weight)
                    end
                end
            end
            if bait == "würmer" then
                xPlayer.removeInventoryItem("würmer", 1)
                if rnd >= 82 then
                    if rnd >= 91 then
                        TriggerClientEvent("SevenLife:Fischer:ChangeKoeder", _source, "keins")
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Deine Angel Route ist gebrochen, da der Fisch zu schwer war",
                            2000
                        )
                        TriggerClientEvent("SevenLife:Fischer:StopFisching", _source)
                        xPlayer.removeInventoryItem("angel", 1)
                    else
                        if xPlayer.getInventoryItem("lachs").count > 0 then
                            TriggerClientEvent("SevenLife:Fischer:ChangeKoeder", _source, "keins")
                            TriggerClientEvent(
                                "SevenLife:TimetCustom:Notify",
                                _source,
                                "Information",
                                "Du kannst keine Lachse mehr erhalten!",
                                2000
                            )
                        else
                            TriggerClientEvent(
                                "SevenLife:TimetCustom:Notify",
                                _source,
                                "Information",
                                "Du hast einen Lachs gefangen! " .. weight .. " KG!",
                                2000
                            )
                            xPlayer.addInventoryItem("lachs", 1)
                        end
                    end
                else
                    if xPlayer.getInventoryItem("fish").count > 100 then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du kannst keine Lachse mehr erhalten!",
                            2000
                        )
                    else
                        weight = math.random(4, 8)
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            _source,
                            "Information",
                            "Du hast einen Lachs gefangen! " .. weight .. " KG!",
                            2000
                        )
                        xPlayer.addInventoryItem("lachs", weight)
                    end
                end
            end
        end
    end
)
ESX.RegisterUsableItem(
    "feuerholz",
    function(source)
        local _source = source
        TriggerClientEvent("SevenLife:Fischer:FuerHolz", _source)
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Fischer:GetIfEnoughFische",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local barsch = xPlayer.getInventoryItem("barsch").count
        local karpfen = xPlayer.getInventoryItem("karpfen").count
        local forelle = xPlayer.getInventoryItem("forelle").count
        local lachs = xPlayer.getInventoryItem("lachs").count
        if barsch >= 1 then
            cb(true, false, false, false)
        elseif karpfen >= 1 then
            cb(false, true, false, false)
        elseif forelle >= 1 then
            cb(false, false, true, false)
        elseif lachs >= 1 then
            cb(false, false, false, true)
        end
    end
)
RegisterServerEvent("SevenLife:MakeFischBraten")
AddEventHandler(
    "SevenLife:MakeFischBraten",
    function(type)
        local xPlayer = ESX.GetPlayerFromId(source)
        if type >= "barsch" then
            xPlayer.removeInventoryItem("barsch", 1)
            xPlayer.addInventoryItem("gebratenerbarsch", 1)
        elseif type >= "karpfen" then
            xPlayer.removeInventoryItem("karpfen", 1)
            xPlayer.addInventoryItem("gebratenerkarpfen", 1)
        elseif type >= "forelle" then
            xPlayer.removeInventoryItem("forelle", 1)
            xPlayer.addInventoryItem("gebratenerforelle", 1)
        elseif type >= "lachs" then
            xPlayer.removeInventoryItem("lachs", 1)
            xPlayer.addInventoryItem("gebratenerlachs", 1)
        end
    end
)
ESX.RegisterUsableItem(
    "gebratenerbarsch",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("bread", 1)

        TriggerClientEvent("esx_status:add", source, "hunger", 200000)
        TriggerClientEvent("esx_basicneeds:onEat", source)
    end
)
ESX.RegisterUsableItem(
    "gebratenerkarpfen",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("bread", 1)

        TriggerClientEvent("esx_status:add", source, "hunger", 200000)
        TriggerClientEvent("esx_basicneeds:onEat", source)
    end
)
ESX.RegisterUsableItem(
    "gebratenerforelle",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("bread", 1)

        TriggerClientEvent("esx_status:add", source, "hunger", 200000)
        TriggerClientEvent("esx_basicneeds:onEat", source)
    end
)
ESX.RegisterUsableItem(
    "gebratenerlachs",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("bread", 1)

        TriggerClientEvent("esx_status:add", source, "hunger", 200000)
        TriggerClientEvent("esx_basicneeds:onEat", source)
    end
)
