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
            Citizen.Wait(1000)
        end
    end
)
local menuonline = false
RegisterNetEvent("SevenLife:FrakInvite:ShowInviteClient")
AddEventHandler(
    "SevenLife:FrakInvite:ShowInviteClient",
    function(frak, name, id)
        if not menuonline then
            SetNuiFocus(true, true)
            menuonline = true
            SendNUIMessage(
                {
                    type = "OpenFrakInvite",
                    id = id,
                    frak = frak,
                    name = name
                }
            )
        end
    end
)
RegisterNUICallback(
    "CloseMenuAblehnen",
    function(data)
        SetNuiFocus(false)
        menuonline = false
        TriggerServerEvent("SevenLife:FrakInvite:GiveNotify", data.id)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du hast dieses Angebot abgelehnt", 2000)
    end
)
RegisterNUICallback(
    "GiveMenuJob",
    function(data)
        TriggerServerEvent("SevenLife:FrakInvite:GiveJob", data.job, data.id)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du hast dieses Angebot angenommen", 2000)
    end
)

RegisterNetEvent("SevenLife:StartMission")
AddEventHandler(
    "SevenLife:StartMission",
    function()
    end
)
