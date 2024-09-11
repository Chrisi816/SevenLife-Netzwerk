RegisterNetEvent("sevenlife:openbankingnui")
AddEventHandler(
    "sevenlife:openbankingnui",
    function()
        print("hey")
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "openbankingnui"
            }
        )
    end
)
RegisterNetEvent("sevenlife:openmainbankmenu")
AddEventHandler(
    "sevenlife:openmainbankmenu",
    function(crypting, name, bankgeld, inflation, kreditwuerdigkeit)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "openmainbankmenu",
                crypt = crypting,
                name = name,
                bankgeld = bankgeld,
                inflation = inflation,
                kreditwuerdigkeit = kreditwuerdigkeit
            }
        )
    end
)
RegisterNetEvent("sevenlife:removemainbankmenu")
AddEventHandler(
    "sevenlife:removemainbankmenu",
    function()
        SetNuiFocus(false, false)
        SendNUIMessage(
            {
                type = "removemainbankmenu"
            }
        )
    end
)
RegisterNetEvent("sevenlife:closeall")
AddEventHandler(
    "sevenlife:closeall",
    function()
        SetNuiFocus(false, false)
        SendNUIMessage(
            {
                type = "closeall"
            }
        )
    end
)

RegisterNetEvent("sevenlife:firstbank")
AddEventHandler(
    "sevenlife:firstbank",
    function(crypting, name, bankgeld, inflation, kreditwuerdigkeit)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "openmainbankmenu",
                crypt = crypting,
                name = name,
                bankgeld = bankgeld,
                inflation = inflation,
                kreditwuerdigkeit = kreditwuerdigkeit,
                iban = "first"
            }
        )
    end
)
-----------------------------------------------------------------------------------------------------
--                                        normalebank
-----------------------------------------------------------------------------------------------------
RegisterNetEvent("sevenlife:opennormalbankmenu")
AddEventHandler(
    "sevenlife:opennormalbankmenu",
    function(bankgeld, handgeld, iban, name)
        playAnim("mp_common", "givetake1_a", 2500)
        Citizen.Wait(2500)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "opennormalbank",
                bankgeld = bankgeld,
                handgeld = handgeld,
                iban = iban,
                name = name
            }
        )
    end
)
