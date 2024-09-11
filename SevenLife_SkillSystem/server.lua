ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:SkillSystem:GetDataLevel",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM skillsystem_level WHERE id = @id",
            {
                ["@id"] = identifier
            },
            function(results)
                if results[1] ~= nil then
                    cb(results)
                else
                    MySQL.Async.execute(
                        "INSERT INTO skillsystem_level (id, name, level, xp) VALUES (@id, @name, @level, @xp)",
                        {
                            ["@id"] = identifier,
                            ["@name"] = xPlayer.getName(),
                            ["@level"] = 0,
                            ["@xp"] = 0
                        },
                        function()
                            MySQL.Async.execute(
                                "INSERT INTO skillsystem_tree (id) VALUES (@id)",
                                {
                                    ["@id"] = identifier
                                },
                                function()
                                end
                            )
                        end
                    )
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:SkillSystem:GetData",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM skillsystem_tree WHERE id = @id",
            {
                ["@id"] = identifier
            },
            function(results)
                cb(results)
            end
        )
    end
)

RegisterServerEvent("SevenLife:SkillSystem:AllowDots")
AddEventHandler(
    "SevenLife:SkillSystem:AllowDots",
    function(item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier

        local _source = source
        if item == "obenbutton1" then
            MySQL.Async.fetchAll(
                "SELECT obenbutton1 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].obenbutton1 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "linksuntenbutton1" then
            MySQL.Async.fetchAll(
                "SELECT linksuntenbutton1 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].linksuntenbutton1 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "rechtsuntenbutton1" then
            MySQL.Async.fetchAll(
                "SELECT rechtsuntenbutton1 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].rechtsuntenbutton1 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "obenobenbutton2" then
            MySQL.Async.fetchAll(
                "SELECT obenobenbutton2 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].obenobenbutton2 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "obenrechtsbutton1" then
            MySQL.Async.fetchAll(
                "SELECT obenrechtsbutton1 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].obenrechtsbutton1 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "obenlinksbutton1" then
            MySQL.Async.fetchAll(
                "SELECT obenlinksbutton1 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].obenlinksbutton1 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "obenlinksbutton2" then
            MySQL.Async.fetchAll(
                "SELECT obenlinksbutton2 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].obenlinksbutton2 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "obenrechtsbutton2" then
            MySQL.Async.fetchAll(
                "SELECT obenrechtsbutton2 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].obenrechtsbutton2 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "linksuntenmittebutton1" then
            MySQL.Async.fetchAll(
                "SELECT linksuntenmittebutton1 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].linksuntenmittebutton1 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "linksuntenuntenbutton1" then
            MySQL.Async.fetchAll(
                "SELECT linksuntenuntenbutton1 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].linksuntenuntenbutton1 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "linksuntenobenbutton1" then
            MySQL.Async.fetchAll(
                "SELECT linksuntenobenbutton1 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].linksuntenobenbutton1 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "linksuntenobenbutton2" then
            MySQL.Async.fetchAll(
                "SELECT linksuntenobenbutton2 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].linksuntenobenbutton2 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "linksuntenmittebutton2" then
            MySQL.Async.fetchAll(
                "SELECT linksuntenmittebutton2 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].linksuntenmittebutton2 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "linksuntenmittebutton3" then
            MySQL.Async.fetchAll(
                "SELECT linksuntenmittebutton3 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].linksuntenmittebutton3 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "linksuntenuntenbutton2" then
            MySQL.Async.fetchAll(
                "SELECT linksuntenuntenbutton2 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].linksuntenuntenbutton2 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "rechtsuntenuntenbutton1" then
            MySQL.Async.fetchAll(
                "SELECT rechtsuntenuntenbutton1 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].rechtsuntenuntenbutton1 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "rechtsuntenmittebutton1" then
            MySQL.Async.fetchAll(
                "SELECT rechtsuntenmittebutton1 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].rechtsuntenmittebutton1 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "rechtsuntenobenbutton1" then
            MySQL.Async.fetchAll(
                "SELECT rechtsuntenobenbutton1 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].rechtsuntenobenbutton1 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "rechtsuntenobenbutton3" then
            MySQL.Async.fetchAll(
                "SELECT rechtsuntenobenbutton3 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].rechtsuntenobenbutton3 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "rechtsuntenobenbutton2" then
            MySQL.Async.fetchAll(
                "SELECT rechtsuntenobenbutton2 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].rechtsuntenobenbutton2 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "rechtsuntenmittebutton2" then
            MySQL.Async.fetchAll(
                "SELECT rechtsuntenmittebutton2 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].rechtsuntenmittebutton2 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "rechtsuntenmittebutton3" then
            MySQL.Async.fetchAll(
                "SELECT rechtsuntenmittebutton3 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].rechtsuntenmittebutton3 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        elseif item == "rechtsuntenuntenbutton2" then
            MySQL.Async.fetchAll(
                "SELECT rechtsuntenuntenbutton2 FROM skillsystem_tree WHERE id = @id",
                {
                    ["@id"] = identifier
                },
                function(resultscheck)
                    if resultscheck[1].rechtsuntenuntenbutton2 == "false" then
                        RemovePoint(identifier, _source, item)
                    else
                        TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                        TriggerClientEvent("sevenlife:displaynachrichtse", _source, "SkillPunkt ist schon aktiv")
                    end
                end
            )
        end
    end
)

function RemovePoint(identifier, _source, item)
    MySQL.Async.fetchAll(
        "SELECT skillpoints FROM skillsystem_level WHERE id = @id",
        {
            ["@id"] = identifier
        },
        function(results)
            if results[1].skillpoints >= 1 then
                MySQL.Async.execute(
                    "UPDATE skillsystem_level SET skillpoints = @skillpoints WHERE id = @id",
                    {
                        ["@id"] = identifier,
                        ["@skillpoints"] = results[1].skillpoints - 1
                    },
                    function(result)
                        TriggerEvent("SevenLife:SkillBaum:GivePerk", item, _source, identifier)
                    end
                )
            else
                TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                TriggerClientEvent("sevenlife:displaynachrichtse", _source, "Du hast zu wenige SkillPoints")
            end
        end
    )
end

RegisterServerEvent("SevenLife:SkillBaum:GivePerk")
AddEventHandler(
    "SevenLife:SkillBaum:GivePerk",
    function(item, _source, identifier)
        MySQL.Async.execute(
            "UPDATE skillsystem_tree SET " .. item .. " = @changebal WHERE id = @id",
            {
                ["@id"] = identifier,
                ["@changebal"] = "true"
            },
            function(result)
                TriggerClientEvent("SevenLife:SkillTree:CloseMenu", _source)
                TriggerClientEvent("sevenlife:displaynachrichtse", _source, "Erfolgreich Perk gekauft")
            end
        )
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(15 * 60000)
            for k, playerid in pairs(GetPlayers()) do
                local xplayer = ESX.GetPlayerFromId(playerid)
                if xplayer ~= nil then
                    MySQL.Async.fetchAll(
                        "SELECT xp, level, skillpoints FROM skillsystem_level WHERE id = @id",
                        {
                            ["@id"] = xplayer.identifier
                        },
                        function(result)
                            if result[1] ~= nil then
                                for k, v in pairs(Config.levels) do
                                    if result[1].level == v.level then
                                        local endproduct = result[1].xp + 0.5
                                        if endproduct >= v.xp then
                                            local endlevel = result[1].level + 1
                                            MySQL.Async.execute(
                                                "UPDATE skillsystem_level SET xp = @xp , level = @level, skillpoints = @skillpoints WHERE id = @id",
                                                {
                                                    ["@id"] = xplayer.identifier,
                                                    ["@xp"] = 0,
                                                    ["@level"] = endlevel,
                                                    ["@skillpoints"] = result[1].skillpoints + 1
                                                },
                                                function()
                                                    TriggerClientEvent(
                                                        "SevenLife:SkillTree:MakeLevelUpShowing",
                                                        playerid,
                                                        endlevel
                                                    )
                                                end
                                            )
                                        else
                                            MySQL.Async.execute(
                                                "UPDATE skillsystem_level SET xp = @xp WHERE id = @id",
                                                {
                                                    ["@id"] = xplayer.identifier,
                                                    ["@xp"] = endproduct
                                                },
                                                function()
                                                end
                                            )
                                        end
                                    end
                                end
                            end
                        end
                    )
                end
            end
        end
    end
)
