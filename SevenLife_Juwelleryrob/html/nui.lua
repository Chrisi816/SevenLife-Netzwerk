RegisterNetEvent("sevenlife:showcomputermenuejewellery")
AddEventHandler(
    "sevenlife:showcomputermenuejewellery",
    function()
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "openmenujewellery"
            }
        )
    end
)
RegisterNetEvent("sevenlife:removecomputermenuejewellery")
AddEventHandler(
    "sevenlife:removecomputermenuejewellery",
    function()
        SetNuiFocus(false, false)
        SendNUIMessage(
            {
                type = "removemenujewellery"
            }
        )
    end
)
