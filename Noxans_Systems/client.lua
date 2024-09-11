ESX = nil
local firstSpawn = true

Citizen.CreateThread(
    function()
        while ESX == nil do
            Citizen.Wait(10)
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
        end
    end
)

function GetRoles()
    ESX.TriggerServerCallback(
        "SevenLife:Whitelist:GetRoles",
        function(roles)
            if roles then
                return roles
            else
                return false
            end
        end
    )
end

function getchecking()
    ESX.TriggerServerCallback(
        "SevenLife:Whitelist:HasRole",
        function(perms)
            return perms
        end
    )
end

AddEventHandler(
    "playerSpawned",
    function()
        if firstSpawn then
            TriggerServerEvent("SevenLife:Whitelist:RemovePlayerFromQueue")
            firstSpawn = false
        end
    end
)
