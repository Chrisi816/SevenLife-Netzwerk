RegisterNetEvent("sevenlife:opennavbar")
AddEventHandler(
    "sevenlife:opennavbar",
    function()
        SendNUIMessage(
            {
                type = "loadingaramid"
            }
        )
    end
)

RegisterNetEvent("sevenlife:removenavbar")
AddEventHandler(
    "sevenlife:removenavbar",
    function()
        SendNUIMessage(
            {
                type = "removearamidbar"
            }
        )
    end
)

RegisterNetEvent("sevenlife:opennavbarzwei")
AddEventHandler(
    "sevenlife:opennavbarzwei",
    function()
        SendNUIMessage(
            {
                type = "loadingbarnumerozwei"
            }
        )
    end
)

RegisterNetEvent("sevenlife:removenavbarzwei")
AddEventHandler(
    "sevenlife:removenavbarzwei",
    function()
        SendNUIMessage(
            {
                type = "loadingbarnumerozweihide"
            }
        )
    end
)

-----------------------------------------------------------------------------------------------------
--                                       Westen Calls
-----------------------------------------------------------------------------------------------------

RegisterNetEvent("sevenlife:opennavbarweste")
AddEventHandler(
    "sevenlife:opennavbarweste",
    function()
        SendNUIMessage(
            {
                type = "westeanlegenbar"
            }
        )
    end
)

RegisterNetEvent("sevenlife:removeopennavbarweste")
AddEventHandler(
    "sevenlife:removeopennavbarweste",
    function()
        SendNUIMessage(
            {
                type = "westeanlegebarremove"
            }
        )
    end
)
-----------------------------------------------------------------------------------------------------
--                                       Westen verarbeiter
-----------------------------------------------------------------------------------------------------
RegisterNetEvent("sevenlife:openverarbeiter")
AddEventHandler(
    "sevenlife:openverarbeiter",
    function()
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "openverarbeiter"
            }
        )
    end
)

RegisterNetEvent("sevenlife:removeverarbeiter")
AddEventHandler(
    "sevenlife:removeverarbeiter",
    function()
        SetNuiFocus(false, false)
        SendNUIMessage(
            {
                type = "removeverarbeiter"
            }
        )
    end
)
-----------------------------------------------------------------------------------------------------
--                                      Loadingbars
-----------------------------------------------------------------------------------------------------
RegisterNetEvent("sevenlife:openfirstloadingbar")
AddEventHandler(
    "sevenlife:openfirstloadingbar",
    function()
        SendNUIMessage(
            {
                type = "openfirstloadingbar"
            }
        )
    end
)

RegisterNetEvent("sevenlife:removefirstloadingbar")
AddEventHandler(
    "sevenlife:removefirstloadingbar",
    function()
        SendNUIMessage(
            {
                type = "removefirstbar"
            }
        )
    end
)
RegisterNetEvent("sevenlife:opensecondloadingbar")
AddEventHandler(
    "sevenlife:opensecondloadingbar",
    function()
        SendNUIMessage(
            {
                type = "opensecondloadingbar"
            }
        )
    end
)

RegisterNetEvent("sevenlife:removesecondloadingbar")
AddEventHandler(
    "sevenlife:removesecondloadingbar",
    function()
        SendNUIMessage(
            {
                type = "removesecondbar"
            }
        )
    end
)
RegisterNetEvent("sevenlife:openthirdloadingbar")
AddEventHandler(
    "sevenlife:openthirdloadingbar",
    function()
        SendNUIMessage(
            {
                type = "openthirdloadingbar"
            }
        )
    end
)

RegisterNetEvent("sevenlife:removethirdloadingbar")
AddEventHandler(
    "sevenlife:removethirdloadingbar",
    function()
        SendNUIMessage(
            {
                type = "removethirdbar"
            }
        )
    end
)
