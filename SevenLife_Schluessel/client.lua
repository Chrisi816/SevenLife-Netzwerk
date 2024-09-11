--------------------------------------------------------------------------------------------------------------
------------------------------------------------ESX-----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

ESX = nil
local verkuefer

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
--------------------------------------------------------------------------------------------------------------
------------------------------------------------Blips---------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        local blips = vector3(Config.location.x, Config.location.y, Config.location.z)
        local blip = AddBlipForCoord(blips.x, blips.y, blips.z)

        SetBlipSprite(blip, 134)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.1)
        SetBlipColour(blip, 39)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Schlosser")
        EndTextCommandSetBlipName(blip)
    end
)

--------------------------------------------------------------------------------------------------------------
---------------------------------------------Npc Spawner------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_y_clubcust_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance =
                GetDistanceBetweenCoords(PlayerCoord, Config.location.x, Config.location.y, Config.location.z, true)

            Citizen.Wait(500)

            if distance < 30 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped1 =
                        CreatePed(
                        4,
                        ped,
                        Config.location.x,
                        Config.location.y,
                        Config.location.z,
                        Config.location.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped1, true)
                    FreezeEntityPosition(ped1, true)
                    SetBlockingOfNonTemporaryEvents(ped1, true)
                    TaskPlayAnim(ped1, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped1)
                SetModelAsNoLongerNeeded(ped1)
                pedloaded = false
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------

local notifys = true
local inmarker = false
local inmenu = false
local timemain = 100

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance =
                GetDistanceBetweenCoords(coord, Config.location.x, Config.location.y, Config.location.z, true)
            if distance < 15 then
                timemain = 15
                if distance < 2 then
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um mit den Schlosser zu reden",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.1 and distance <= 3 then
                        inmarker = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                timemain = 100
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        SetNuiFocus(true, true)
                        ESX.TriggerServerCallback(
                            "SevenLife:Schlosser:GetSchloss",
                            function(result)
                                SendNUIMessage(
                                    {
                                        type = "OpenVerkeaufer"
                                    }
                                )
                                for _, v in pairs(result) do
                                    local hash = v.vehicle.model
                                    local vehname = GetDisplayNameFromVehicleModel(hash)
                                    local labelname = GetLabelText(vehname)
                                    local plate = v.plate
                                    SendNUIMessage(
                                        {
                                            type = "UpdateCars",
                                            plate = plate,
                                            labelname = labelname
                                        }
                                    )
                                end
                            end
                        )
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
RegisterNUICallback(
    "makenewschluessel",
    function(data)
        notifys = true
        inmenu = false
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Schlosser:CheckMoney",
            function(enough)
                if enough then
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Schlosser", "Schlüssel erfolgreich geändert", 2000)
                    TriggerServerEvent("SevenLife:Schlosser:RemoveSchlüssel", data.plate)
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Schlosser",
                        "Du besitzt zu wenig Geld um die Schlüssel zu ändern",
                        2000
                    )
                end
            end
        )
    end
)
RegisterNUICallback(
    "CloseMenu",
    function()
        notifys = true
        inmenu = false
        SetNuiFocus(false, false)
    end
)
