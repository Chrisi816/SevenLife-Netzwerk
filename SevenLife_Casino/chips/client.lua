--------------------------------------------------------------------------------------------------------------
---------------------------------------------Npc Spawner------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.WaitorChips.x,
                Config.WaitorChips.y,
                Config.WaitorChips.z,
                true
            )

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
                        Config.WaitorChips.x,
                        Config.WaitorChips.y,
                        Config.WaitorChips.z,
                        Config.WaitorChips.h,
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
                SetModelAsNoLongerNeeded(ped)
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
                GetDistanceBetweenCoords(coord, Config.WaitorChips.x, Config.WaitorChips.y, Config.WaitorChips.z, true)
            if distance < 15 then
                timemain = 15
                if distance < 2 then
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um Spiel Chips zu kaufen",
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
                        SendNUIMessage(
                            {
                                type = "OpenChipsMenu",
                                price = Config.ChipsPrice
                            }
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
    "KaufChips",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Casino:CheckIfEnoughMoney",
            function(enough)
                if enough then
                    TriggerServerEvent("SevenLife:Casino:GiveChips", data.inputt)
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Casino",
                        "Du besitzt zu wenig Bar geld um " .. data.inputt .. " Chips zu kaufen",
                        2000
                    )
                end
            end,
            data.inputt
        )
    end
)
RegisterNUICallback(
    "escape",
    function()
        notifys = true
        inmenu = false
        SetNuiFocus(false, false)
    end
)
RegisterNUICallback(
    "VerkaufChips",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Casino:CheckIfEnoughChips",
            function(enough)
                if enough then
                    TriggerServerEvent("SevenLife:Casino:GiveMoney", data.inputt)
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Casino", "Du besitzt zu wenig Chips ", 2000)
                end
            end,
            data.inputt
        )
    end
)
