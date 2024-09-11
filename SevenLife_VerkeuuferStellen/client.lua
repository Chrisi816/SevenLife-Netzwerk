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
        for k, v in pairs(Config.locations) do
            Citizen.Wait(500)

            local blips = vector3(v.x, v.y, v.z)
            local blip = AddBlipForCoord(blips.x, blips.y, blips.z)

            SetBlipSprite(blip, 500)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, 47)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Verkäufer #" .. v.verkeufer)
            EndTextCommandSetBlipName(blip)
        end
    end
)

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

            for k, v in pairs(Config.locations) do
                local distance = GetDistanceBetweenCoords(PlayerCoord, v.x, v.y, v.z, true)

                Citizen.Wait(500)

                if distance < 30 then
                    pedarea = true
                    if not pedloaded then
                        RequestModel(ped)
                        while not HasModelLoaded(ped) do
                            Citizen.Wait(1)
                        end
                        ped1 = CreatePed(4, ped, v.x, v.y, v.z, v.heading, false, true)
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

            for k, v in pairs(Config.locations) do
                local distance = GetDistanceBetweenCoords(coord, v.x, v.y, v.z, true)
                if distance < 15 then
                    timemain = 15
                    if distance < 2 then
                        verkuefer = v.verkeufer
                        inmarker = true
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um den Verkäufer zu begutachten",
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
                            "SevenLife:Verakeufer:GetItems",
                            function(result)
                                SendNUIMessage(
                                    {
                                        type = "OpenVerkeaufer",
                                        result = result
                                    }
                                )
                            end,
                            verkuefer
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
    "Verkauf",
    function(data)
        local anzahls = tonumber(data.anzahl)
        if anzahls ~= nil then
            local preis = tonumber(data.preis)
            local name = data.name
            local endammount = anzahls * preis
            ESX.TriggerServerCallback(
                "SevenLife:Verkeufer:GetEnough",
                function(enough)
                    if enough then
                        TriggerServerEvent("SevenLife:Verkeufer:MakeEndStep", endammount, name, anzahls)
                    else
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Tier",
                            "Du hast nicht genug Items um das zu verkaufen",
                            2000
                        )
                    end
                end,
                name,
                anzahls
            )
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Tier", "Du musst eine Anzahl eingeben", 2000)
        end
    end
)

local pedloaded1 = false
local pedarea1 = false
local ped = GetHashKey("a_m_y_business_03")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            for k, v in pairs(Config.locations) do
                local distance =
                    GetDistanceBetweenCoords(
                    PlayerCoord,
                    Config.DarkSeller.x,
                    Config.DarkSeller.y,
                    Config.DarkSeller.z,
                    true
                )

                Citizen.Wait(500)

                if distance < 30 then
                    pedarea1 = true
                    if not pedloaded1 then
                        RequestModel(ped)
                        while not HasModelLoaded(ped) do
                            Citizen.Wait(1)
                        end
                        ped2 =
                            CreatePed(
                            4,
                            ped,
                            Config.DarkSeller.x,
                            Config.DarkSeller.y,
                            Config.DarkSeller.z,
                            Config.DarkSeller.h,
                            false,
                            true
                        )
                        SetEntityInvincible(ped2, true)
                        FreezeEntityPosition(ped2, true)
                        SetBlockingOfNonTemporaryEvents(ped2, true)
                        TaskPlayAnim(ped2, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                        pedloaded1 = true
                    end
                else
                    if distance >= 30.1 and distance <= 50 then
                        pedarea1 = false
                    end
                end

                if pedloaded1 and not pedarea1 then
                    DeleteEntity(ped2)
                    SetModelAsNoLongerNeeded(ped2)
                    pedloaded1 = false
                end
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------

local notifys1 = true
local inmarker1 = false
local inmenu1 = false

local timemain1 = 100
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain1)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance =
                GetDistanceBetweenCoords(coord, Config.DarkSeller.x, Config.DarkSeller.y, Config.DarkSeller.z, true)
            if distance < 15 then
                timemain1 = 15
                if distance < 2 then
                    inmarker1 = true
                    if notifys1 then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Schwarz Markt Verkäufer zu begutachten",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.1 and distance <= 3 then
                        inmarker1 = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                timemain1 = 100
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmarker1 then
                if IsControlJustPressed(0, 38) then
                    if inmenu1 == false then
                        inmenu1 = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys1 = false
                        SetNuiFocus(true, true)

                        SendNUIMessage(
                            {
                                type = "OpenDarkVerkäufer",
                                result = Config.DarkItems
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
    "escape",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
        notifys1 = true
        inmarker1 = false
        inmenu1 = false

        timemain1 = 100
    end
)
