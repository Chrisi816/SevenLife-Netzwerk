-- Regierung
--open
RegisterNetEvent("sevenlife:openregierungsmenu")
AddEventHandler(
    "sevenlife:openregierungsmenu",
    function(name)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "openregierungsmenu",
                name = name
            }
        )
    end
)
-- close
RegisterNetEvent("sevenlife:closeregierungsmenu")
AddEventHandler(
    "sevenlife:closeregierungsmenu",
    function()
        SetNuiFocus(false, false)
        SendNUIMessage(
            {
                type = "removeregierungsmenu"
            }
        )
    end
)
RegisterNetEvent("sevenlife:openimpounder")
AddEventHandler(
    "sevenlife:openimpounder",
    function()
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "openimpounder"
            }
        )
    end
)
