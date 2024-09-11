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
            Citizen.Wait(0)
        end
    end
)

local props = {}
local propsUsabled = {}
local inmarker = false
local time = 500
local allownotify = true
local insearch = false

CreateThread(
    function()
        while true do
            Citizen.Wait(5000)
            props = {}
            local allProps = ESX.Game.GetObjects()

            for i = 1, #allProps do
                for k, v in pairs(SevenConfig.Props) do
                    if GetEntityModel(allProps[i]) == v then
                        table.insert(props, allProps[i])
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        local wait = 1000
        while true do
            local playerPed = PlayerPedId()
            local pos = GetEntityCoords(playerPed)

            for i = 1, #props do
                local propPos = GetEntityCoords(props[i])
                local dist = #(pos - propPos)

                if dist < 7.5 and not IsPedInAnyVehicle(PlayerPedId()) and not propsUsabled[props[i]] then
                    wait = 10
                    time = 5
                    if dist < 1.8 then
                        inmarker = true
                        propso = props[i]
                        if allownotify then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um den Mülleimmer zu durchsuchen",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if dist >= 1.9 and dist <= 5 then
                            inmarker = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    wait = 500
                end
            end

            Citizen.Wait(wait)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if insearch == false then
                        Ped = GetPlayerPed(-1)
                        insearch = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        allownotify = false
                        local randoms = math.random(1, 2)
                        local item = SevenConfig.AvailebeItems[math.random(#SevenConfig.AvailebeItems)]
                        FreezeEntityPosition(Ped, true)
                        TaskStartScenarioInPlace(Ped, "PROP_HUMAN_BUM_SHOPPING_CART", 0, true)
                        Citizen.Wait(5000)
                        ClearPedTasks(Ped)
                        FreezeEntityPosition(Ped, false)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mülleimer",
                            "Du hast " .. randoms .. "x " .. item .. " aus dem Mülleimer bekommen",
                            1000
                        )

                        propsUsabled[propso] = true
                        CreateThread(
                            function()
                                local prop = propso
                                Citizen.Wait(1000)
                                propsUsabled[prop] = false
                            end
                        )
                        insearch = false
                        allownotify = true
                        TriggerServerEvent("SevenLife:MüllDrop:GiveItem", item, randoms)
                    end
                end
            else
                time = 500
            end
        end
    end
)
