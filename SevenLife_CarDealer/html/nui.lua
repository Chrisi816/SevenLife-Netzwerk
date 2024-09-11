--------------------------------------------------------------------------------------------------------------
--------------------------------------------Open Menue--------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

RegisterNetEvent("sevenlife:opencarshop")
AddEventHandler(
    "sevenlife:opencarshop",
    function(heandler, nachrichteins, nachrichtzwei, cars)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "opencarshops",
                heandler = heandler,
                nachrichteins = nachrichteins,
                nachrichtzwei = nachrichtzwei,
                cars = cars
            }
        )
    end
)
