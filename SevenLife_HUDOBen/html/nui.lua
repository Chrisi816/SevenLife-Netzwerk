RegisterNetEvent("sevenlife:openallhud")
RegisterNetEvent("sevenlife:removeallhud")
RegisterNetEvent("sevenlife:refreshallhud")
AddEventHandler(
    "sevenlife:openallhud",
    function(cash, job, date, onlinePlayers, deutschzeit)
        SendNUIMessage(
            {
                type = "openallhud",
                cash = cash,
                job = job,
                data = date,
                onlinePlayers = onlinePlayers,
                deutschzeit = deutschzeit
            }
        )
    end
)
AddEventHandler(
    "sevenlife:removeallhud",
    function()
        SendNUIMessage(
            {
                type = "removeallhud"
            }
        )
    end
)

AddEventHandler(
    "sevenlife:refreshallhud",
    function(cash, job)
        SendNUIMessage(
            {
                type = "refreshallhud",
                cash = cash,
                job = job
            }
        )
    end
)
