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
Citizen.CreateThread(
    function()
        local blips = vector3(Config.Coords.x, Config.Coords.y, Config.Coords.z)
        local blip = AddBlipForCoord(blips.x, blips.y, blips.z)

        SetBlipSprite(blip, 171)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.1)
        SetBlipColour(blip, 61)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Versicherung")
        EndTextCommandSetBlipName(blip)
    end
)
local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_m_bevhills_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance =
                GetDistanceBetweenCoords(PlayerCoord, Config.Coords.x, Config.Coords.y, Config.Coords.z, true)

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
                        Config.Coords.x,
                        Config.Coords.y,
                        Config.Coords.z,
                        Config.Coords.heading,
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
            Citizen.Wait(500)
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

            local distance = GetDistanceBetweenCoords(coord, Config.Coords.x, Config.Coords.y, Config.Coords.z, true)
            if distance < 15 then
                timemain = 15
                if distance < 2 then
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um eine Versicherung abzuschließen",
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
                            "SevenLife:Versicherung:GetNotVersicherungen",
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
    "MakeVersicherung",
    function(data)
        notifys = true
        inmenu = false
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Versicherung:CheckMoney",
            function(enough)
                if enough then
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Versicherung",
                        "Versicherung erfolgreich gekauft!",
                        2000
                    )
                    TriggerServerEvent("SevenLife:Versicherung:UpdateVersicherung", data.plate)
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Versicherung",
                        "Du besitzt zu wenig Geld um die Versicherung zu kaufen",
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
