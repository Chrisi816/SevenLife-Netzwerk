RegisterNetEvent("sevenlife:opendienstmenu")
AddEventHandler(
    "sevenlife:opendienstmenu",
    function()
        SendNUIMessage(
            {
                type = "opendienstmenu"
            }
        )
    end
)
RegisterNetEvent("sevenlife:removedienstmenu")
AddEventHandler(
    "sevenlife:removedienstmenu",
    function()
        SendNUIMessage(
            {
                type = "removedienstmenu"
            }
        )
    end
)
