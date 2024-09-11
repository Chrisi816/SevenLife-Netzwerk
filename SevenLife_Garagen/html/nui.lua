RegisterNetEvent("sevenlife:openmenugarage")
AddEventHandler(
    "sevenlife:openmenugarage",
    function()
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "opengarage"
            }
        )
    end
)

RegisterNetEvent("sevenlife:removemenugarage")
AddEventHandler(
    "sevenlife:removemenugarage",
    function()
        SetNuiFocus(false, false)
        SendNUIMessage(
            {
                type = "removemenugarage"
            }
        )
    end
)
