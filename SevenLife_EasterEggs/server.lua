ESX = nil

-- ESX

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

function restart_server()
    SetTimeout(
        60000 * 30,
        function()
            TriggerEvent("SevenLife:EasterEgg:Start")
            restart_server()
        end
    )
end

restart_server()

RegisterServerEvent("SevenLife:EasterEgg:Start")
AddEventHandler(
    "SevenLife:EasterEgg:Start",
    function()
        local number = math.random(0, 1)

        TriggerClientEvent("SevenLife:EasterEgg:StartCall", -1, number)
    end
)
RegisterServerEvent("SevenLife:EasterEgg:PhoneFound")
AddEventHandler(
    "SevenLife:EasterEgg:PhoneFound",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = math.random(10, 100)
        xPlayer.addAccountMoney("money", money)
        local _source = source

        TriggerClientEvent(
            "SevenLife:TimetCustom:Notify",
            source,
            "Telefon",
            "Dadurch das du das Telefon entgegen genommen hast, hast du einen kleinen Visa Bonus bekommen. Ausserdem hast du in der Wechselgeld sektion " ..
                money .. "$ gefunden! ** EASTER EGG ** ",
            2000
        )
        local identifier = xPlayer.identifier
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM battlepassmissionen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        if check[1] ~= nil then
            if tonumber(check[1].index3) == 1 then
                TriggerEvent("SevenLife:SeasonPass:MakeProgress", 3, true, _source)
            end
        end

        if xPlayer ~= nil then
            MySQL.Async.fetchAll(
                "SELECT xp, level, skillpoints FROM skillsystem_level WHERE id = @id",
                {
                    ["@id"] = xPlayer.identifier
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
                                        ["@id"] = xPlayer.identifier,
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
                                        ["@id"] = xPlayer.identifier,
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
        TriggerClientEvent("SevenLife:EasterEgg:Sync", source)
    end
)
