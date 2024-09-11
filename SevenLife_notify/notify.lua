local nodes = true
--Nui Registration
RegisterNetEvent("sevenliferp:startnui")
AddEventHandler(
    "sevenliferp:startnui",
    function(text, header, show)
        nodes = false
        SendNUIMessage(
            {
                action = "shownui",
                text = text,
                header = header,
                show = show
            }
        )
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1100)
            if nodes then
                SendNUIMessage(
                    {
                        action = "shownui",
                        show = false
                    }
                )
            else
                Citizen.Wait(100)
                nodes = true
            end
        end
    end
)
RegisterNetEvent("sevenliferp:closenotify")
AddEventHandler(
    "sevenliferp:closenotify",
    function(show)
        SendNUIMessage(
            {
                action = "shownui",
                show = show
            }
        )
    end
)
zeit = true
RegisterNetEvent("sevenlife:timenotify")
AddEventHandler(
    function(text, header, time)
        SendNUIMessage(
            {
                action = "showtimetnui",
                text = text,
                header = header,
                time = time
            }
        )
    end
)

--Dont start the Nui at the start
AddEventHandler(
    "onResourceStart",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        Citizen.Wait(100)
        TriggerEvent("sevenliferp:closenotify", false)
    end
)
AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        TriggerEvent("sevenliferp:closenotify", false)
    end
)
-- New Nui
RegisterNetEvent("sevenlife:notifyinfo")
AddEventHandler(
    "sevenlife:notifyinfo",
    function(msg)
        PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 1)
        SendNUIMessage(
            {
                type = "infos",
                msg = msg
            }
        )
    end
)

RegisterNetEvent("sevenlife:notifyerror")
AddEventHandler(
    "sevenlife:notifyerror",
    function(msg)
        PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 1)
        SendNUIMessage(
            {
                type = "error",
                msg = msg
            }
        )
    end
)

RegisterNetEvent("sevenlife:notifyscuccess")
AddEventHandler(
    "sevenlife:notifyscuccess",
    function(msg)
        PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 1)
        SendNUIMessage(
            {
                type = "success",
                msg = msg
            }
        )
    end
)
RegisterNetEvent("sevenlife:removenotifyinfo")
AddEventHandler(
    "sevenlife:removenotifyinfo",
    function(msg)
        SendNUIMessage(
            {
                type = "removeinfo",
                msg = msg
            }
        )
    end
)

RegisterNetEvent("sevenlife:removenotifyerror")
AddEventHandler(
    "sevenlife:removenotifyerror",
    function(msg)
        SendNUIMessage(
            {
                type = "removeerror",
                msg = msg
            }
        )
    end
)

RegisterNetEvent("sevenlife:removenotifyscuccess")
AddEventHandler(
    "sevenlife:removenotifyscuccess",
    function(msg)
        SendNUIMessage(
            {
                type = "removesuccess",
                msg = msg
            }
        )
    end
)
RegisterNetEvent("SevenLife:TimetCustom:Notify")
AddEventHandler(
    "SevenLife:TimetCustom:Notify",
    function(title, message, time)
        SendNUIMessage(
            {
                type = "TimetSeven",
                bignachricht = title,
                smallnachricht = message,
                time = time
            }
        )

        PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
)

RegisterNetEvent("SevenLife:TimetCustom:PoliceNotify")
AddEventHandler(
    "SevenLife:TimetCustom:PoliceNotify",
    function(smallnachricht)
        SendNUIMessage(
            {
                type = "PoliceNotify",
                smallnachricht = smallnachricht
            }
        )
    end
)

RegisterNetEvent("SevenLife:TimetCustom:NotifyAlarm")
AddEventHandler(
    "SevenLife:TimetCustom:NotifyAlarm",
    function(smallnachricht, bignachricht)
        SendNUIMessage(
            {
                type = "NotifyInfo",
                smallnachricht = smallnachricht,
                bignachricht = bignachricht
            }
        )
    end
)

RegisterNetEvent("SevenLife:Tankstelle:AddInfo")
AddEventHandler(
    "SevenLife:Tankstelle:AddInfo",
    function(message)
        SendNUIMessage(
            {
                type = "OpenTankeMessage",
                message = message
            }
        )
    end
)
RegisterNetEvent("SevenLife:Notify:MakeMoneyNotify")
AddEventHandler(
    "SevenLife:Notify:MakeMoneyNotify",
    function(wage, job)
        local message =
            "Dein Arbeitgeber hat dir deinen Lohn in höhe von " ..
            wage .. "$ überwiesen. Mehr Informationen sind in der Bank App verfügbar!"
        SendNUIMessage(
            {
                type = "OpenMoneyMessage",
                message = message
            }
        )
    end
)
