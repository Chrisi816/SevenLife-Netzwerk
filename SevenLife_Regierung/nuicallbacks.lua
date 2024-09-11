ESX = nil

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(10)
        end
    end
)

RegisterNUICallback(
    "fertig",
    function()
        inmenu = false
        TriggerEvent("sevenlife:closeregierungsmenu")
        notifys = true
        openshop = false
        TriggerServerEvent("sevenlife:checkout")
    end
)

-- Checking Cash
RegisterNUICallback(
    "checkcash",
    function()
        TriggerServerEvent("sevenlife:checkcashings")
        TriggerServerEvent("sevenlife:haveplayeracompeny")
    end
)

RegisterNetEvent("sevenlife:closeall")
AddEventHandler(
    "sevenlife:closeall",
    function()
        TriggerEvent("sevenlife:closeregierungsmenu")
        Citizen.Wait(11)
        TriggerEvent(
            "sevenliferp:startnui",
            "Du hast zu wenig Geld um ein Unternehmen zu gründen",
            "System-Nachricht",
            true
        )
        Citizen.Wait("3000")
        TriggerEvent("sevenliferp:closenotify", false)
        notifys = true
        openshop = false
        inmenu = false
    end
)

RegisterNUICallback(
    "Buero",
    function(data)
        TriggerServerEvent("sevenlife:selctbuere", data.buero)
    end
)
RegisterNUICallback(
    "Perso",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Regierung:Perso:CheckIfPlayerhaveenoughmoney",
            function(have)
                if have then
                    TriggerServerEvent("SevenLife:Regierung:Perso:Payforit", 100, "IDcard")
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Regierung", "Du hast nicht genug Geld dabei", 2000)
                end
            end,
            100
        )
    end
)
RegisterNUICallback(
    "Buch",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Regierung:Perso:CheckIfPlayerhaveenoughmoney",
            function(have)
                if have then
                    TriggerServerEvent("SevenLife:Regierung:Perso:Payforit", 1200, "lizenzbuch")
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Regierung", "Du hast nicht genug Geld dabei", 2000)
                end
            end,
            1200
        )
    end
)
