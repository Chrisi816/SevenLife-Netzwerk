--------------------------------------------------------------------------------------------------------------
--------------------------------------------Locale Blips------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
ESX = nil
Citizen.CreateThread(
    function()
        ShowWeaponBlips()
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

function ShowWeaponBlips()
    for _, Weapon in pairs(Config.WaffenShops) do
        local weapon = AddBlipForCoord(Weapon.x, Weapon.y, Weapon.z)
        SetBlipSprite(weapon, 110)
        SetBlipDisplay(weapon, 4)
        SetBlipScale(weapon, 1.0)
        SetBlipColour(weapon, 81)
        SetBlipAsShortRange(weapon, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Waffenladen")
        EndTextCommandSetBlipName(weapon)
    end
end

--------------------------------------------------------------------------------------------------------------
--------------------------------------------Locale Shops------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
local allowednotify = true
local inmarker = false
local inmenu = false
Citizen.CreateThread(
    function()
        Citizen.Wait(2000)

        while true do
            local player = GetPlayerPed(-1)
            for k, v in pairs(Config.WaffenShops) do
                Citizen.Wait(250)
                local coords = GetEntityCoords(player)
                local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                if distance < 2 then
                    inmarker = true
                    if allowednotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Waffen Shop zu begutachten",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.1 and distance <= 5 then
                        inmarker = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(1)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        Citizen.Wait(100)

                        ESX.TriggerServerCallback(
                            "SevenLife:WaffenLaden:GetLicenses",
                            function(havelicense)
                                if havelicense then
                                    inmenu = true
                                    allowednotify = false
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    SetNuiFocus(true, true)
                                    SendNUIMessage(
                                        {
                                            type = "OpenWeaponShop"
                                        }
                                    )
                                end
                            end
                        )
                    end
                end
            else
                Citizen.Wait(300)
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
-----------------------------------Transfer BT Server and Client----------------------------------------------
--------------------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "payforitem",
    function(data)
        SetNuiFocus(false, false)
        inmenu = false
        allowednotify = true
        TriggerServerEvent("SevenLife:WaffenShops:MakeWeapon", data.name, 100)
    end
)
--------------------------------------------------------------------------------------------------------------
-------------------------------------------Closing System-----------------------------------------------------
--------------------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        allowednotify = true
    end
)
