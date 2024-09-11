ESX = nil

-- ESX

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:Golf:GiveBealle")
AddEventHandler(
    "SevenLife:Golf:GiveBealle",
    function(name, amount, preis)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        local _source = source
        if money >= tonumber(preis) then
            xPlayer.removeAccountMoney("money", tonumber(preis))
            xPlayer.addInventoryItem(name, tonumber(amount))
        else
            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Golf", "Du hast zu wenig Geld", 2000)
        end
    end
)
ESX.RegisterUsableItem(
    "gball",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("gball", 1)
        TriggerClientEvent("SevenLife:Golf:AddFunktionToBall", source)
    end
)
RegisterServerEvent("SevenLife:Golf:GiveXP")
AddEventHandler(
    "SevenLife:Golf:GiveXP",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        if xplayer ~= nil then
            MySQL.Async.fetchAll(
                "SELECT xp, level, skillpoints FROM skillsystem_level WHERE id = @id",
                {
                    ["@id"] = xplayer.identifier
                },
                function(result)
                    for k, v in pairs(Config.levels) do
                        if result[1].level == v.level then
                            local endproduct = result[1].xp + 0.1
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
                                        TriggerClientEvent("SevenLife:SkillTree:MakeLevelUpShowing", source, endlevel)
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
            )
        end
    end
)
