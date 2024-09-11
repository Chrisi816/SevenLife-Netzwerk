RegisterNetEvent("sevenlife:openhud")
RegisterNetEvent("sevenlife:removehud")
RegisterNetEvent("sevenlife:refreshhud")

AddEventHandler(
    "sevenlife:openhud",
    function(kmh, gear, liter, strassenname)
        SendNUIMessage(
            {
                type = "openhud",
                kmh = kmh,
                gears = gear,
                liter = liter,
                streetnames = strassenname
            }
        )
    end
)
AddEventHandler(
    "sevenlife:removehud",
    function()
        SendNUIMessage(
            {
                type = "removehud"
            }
        )
    end
)

AddEventHandler(
    "sevenlife:refreshhud",
    function(kmh, gear, liter, strassenname)
        SendNUIMessage(
            {
                type = "updatehud",
                kmh = kmh,
                gears = gear,
                liter = liter,
                streetnames = strassenname
            }
        )
    end
)
AddEventHandler(
    "sevenlife:activeaccounts",
    function(event)
        SendNUIMessage(
            {
                type = event
            }
        )
    end
)