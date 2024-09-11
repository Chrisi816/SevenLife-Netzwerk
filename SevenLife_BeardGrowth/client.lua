Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(30 * 60000)
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    if skin ~= nil then
                        if skin["beard_2"] >= 0 and skin["beard_2"] < 10 then
                            skin["beard_2"] = skin["beard_2"] + 1
                            TriggerEvent("skinchanger:loadSkin", skin)
                            TriggerServerEvent("esx_skin:save", skin)
                        end
                    end
                end
            )
        end
    end
)

RegisterNetEvent("SevenLife:Beard:Shave")
AddEventHandler(
    "SevenLife:Beard:Shave",
    function()
        TriggerEvent(
            "skinchanger:getSkin",
            function(skin)
                if skin ~= nil then
                    if skin["beard_2"] >= 0 and skin["beard_2"] < 10 then
                        skin["beard_2"] = 1
                        TriggerEvent("skinchanger:loadSkin", skin)
                        TriggerServerEvent("esx_skin:save", skin)
                    end
                end
            end
        )
    end
)
