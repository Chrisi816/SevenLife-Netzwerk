ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:KD:AddKill")
AddEventHandler(
    "SevenLife:KD:AddKill",
    function(killer)
        local identifier = ESX.GetPlayerFromId(killer).identifier
        MySQL.Async.execute(
            "UPDATE users SET deaths = (deaths + 1) WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
    end
)
RegisterServerEvent("SevenLife:KD:AddDeath")
AddEventHandler(
    "SevenLife:KD:AddDeath",
    function()
        local Ply = ESX.GetPlayerFromId(source)
        MySQL.Async.execute(
            "UPDATE users SET deaths = (deaths + 1) WHERE identifier = @identifier",
            {
                ["@identifier"] = Ply.identifier
            }
        )
    end
)
