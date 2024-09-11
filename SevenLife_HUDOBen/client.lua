local started = false

Citizen.CreateThread(
    function()
        while true do
            if started then
                if not IsPauseMenuActive() then
                    TriggerServerEvent("sevenlife:getallinfos")
                    TriggerEvent(
                        "esx_status:getStatus",
                        "hunger",
                        function(hungerStatus)
                            TriggerEvent(
                                "esx_status:getStatus",
                                "thirst",
                                function(thirstStatus)
                                    UpdateHungerandthirst(hungerStatus.val / 15000, thirstStatus.val / 15000)
                                end
                            )
                        end
                    )
                else
                    SendNUIMessage(
                        {
                            type = "removeallhud"
                        }
                    )
                end
            end

            Citizen.Wait(300)
        end
    end
)

RegisterNetEvent("SevenLife:Start:OpenHud")
AddEventHandler(
    "SevenLife:Start:OpenHud",
    function()
        started = true
    end
)
RegisterNetEvent("SevenLife:Start:removeHUD")
AddEventHandler(
    "SevenLife:Start:removeHUD",
    function()
        started = false
        SendNUIMessage(
            {
                type = "removeallhud"
            }
        )
    end
)
RegisterNetEvent("ActivateAllHUD")
AddEventHandler(
    "ActivateAllHUD",
    function()
        SendNUIMessage(
            {
                type = "ActivateAllHUD"
            }
        )
    end
)

RegisterNetEvent("sevenlife:getdatas")
AddEventHandler(
    "sevenlife:getdatas",
    function(cash, job, date, onlinePlayers, deutschzeit)
        local cash = cash
        local job = job
        TriggerEvent("sevenlife:openallhud", cash, job, date, onlinePlayers, deutschzeit)
        hud = true
    end
)

function UpdateHungerandthirst(hunger, thirst)
    SendNUIMessage(
        {
            type = "updatehungerfirst",
            hunger = hunger,
            thirst = thirst
        }
    )
end

-- right
Citizen.CreateThread(
    function()
        allowright = true
        if allowright then
            SendNUIMessage({type = "OpenNuiInfo"})
        end
    end
)

RegisterNetEvent("SevenLife:OpenIt:Right")
AddEventHandler(
    "SevenLife:OpenIt:Right",
    function()
        SendNUIMessage({type = "OpenNuiInfo"})
    end
)
RegisterNetEvent("SevenLife:OpenIt:remove")
AddEventHandler(
    "SevenLife:OpenIt:remove",
    function()
        SendNUIMessage({type = "removeNUiInfo"})
    end
)
