ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:Animation:StoreAnim")
AddEventHandler(
    "SevenLife:Animation:StoreAnim",
    function(type, titel, dict, anim, prop, propbone, propplace, proptwo, propbonetwo, propplacetwo)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier

        MySQL.Async.execute(
            "INSERT INTO marked_emotes (identifier,types,titel,dict,anim,prop,propBone,propPlacement,propTwo,propTwoBone,propTwoPlacement) VALUES (@identifier,@types,@titel,@dict,@anim,@prop,@propBone,@propPlacement,@propTwo,@propTwoBone,@propTwoPlacement) ",
            {
                ["@identifier"] = identifier,
                ["@types"] = type,
                ["@titel"] = titel,
                ["@dict"] = dict,
                ["@anim"] = anim,
                ["@prop"] = prop,
                ["@propBone"] = propbone,
                ["@propPlacement"] = propplace,
                ["@propTwo"] = proptwo,
                ["@propTwoBone"] = propbonetwo,
                ["@propTwoPlacement"] = propplacetwo
            },
            function()
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Animation",
                    "Du hast diese Animation als Favourite ausgewählt",
                    1500
                )
                Citizen.Wait(300)
                TriggerClientEvent("SevenLife:Animation:UpdateList", _source)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Animationen:GetCount",
    function(source, cb)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT id FROM marked_emotes WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(results)
                local count = 0
                for k, v in pairs(results) do
                    count = count + 1
                end
                cb(count)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Animationen:GetMarked",
    function(source, cb)
        local _source = source
        local identifier = ESX.GetPlayerFromId(_source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM marked_emotes WHERE identifier = @identifier ",
            {
                ["@identifier"] = identifier
            },
            function(results)
                cb(results)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Animation:DeleteAnim")
AddEventHandler(
    "SevenLife:Animation:DeleteAnim",
    function(titel)
        local _source = source
        MySQL.Async.execute(
            "DELETE FROM marked_emotes WHERE titel = @titel ",
            {
                ["@titel"] = titel
            },
            function()
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Animation",
                    "Du hast diese Animation aus deiner Favouriten Liste gelöscht",
                    1500
                )
                Citizen.Wait(300)
                TriggerClientEvent("SevenLife:Animation:UpdateList", _source)
            end
        )
    end
)
