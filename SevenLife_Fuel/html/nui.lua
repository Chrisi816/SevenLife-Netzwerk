RegisterNetEvent("sevenlife:openinfobar")
AddEventHandler(
    "sevenlife:openinfobar",
    function(name, owner, liter, value, preisproliter, nummer)
        SendNUIMessage(
            {
                type = "openinfobar",
                name = name,
                owner = owner,
                liter = liter,
                avergevalue = value,
                preisproliter = preisproliter
            }
        )
    end
)
RegisterNetEvent("sevenlife:removeinfobar")
AddEventHandler(
    "sevenlife:removeinfobar",
    function()
        SendNUIMessage(
            {
                type = "removeinfobar"
            }
        )
    end
)
