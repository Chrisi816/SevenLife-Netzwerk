ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

function MakePayCheck()
    local data = MySQL.Sync.fetchAll("SELECT * FROM job_grades", {})
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xPlayers = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayers ~= nil then
            for k, v in pairs(data) do
                if data.name == xPlayers.job.name then
                    local wage = data.salary
                    local job = xPlayers.job.name

                    xPlayersxPlayer.addAccountMoney("bank", wage)

                    TriggerClientEvent("SevenLife:Pay:MakeSociatyMessage", xPlayers[i], wage, job)
                end
            end
        end
    end
    SetTimeout(
        1000 * 60 * 30,
        function()
            MakePayCheck()
        end
    )
end

MakePayCheck()
