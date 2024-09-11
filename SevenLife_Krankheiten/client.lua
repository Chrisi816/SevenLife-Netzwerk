local isPlayerIll = false
local bauchschmerzen = false
local husten = false
local rosazea = false
local corona = false
local fieber = false
local durchfall = false
local chance = 2
local chance2 = 2
local chance3 = 2
local chance4 = 2
local chance5 = 2
local chance6 = 2

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
-- Chance of Illnes
Citizen.CreateThread(
    function()
        BlipApotheke()
        while true do
            Citizen.Wait(5000000)
            local ChanceOfPlayerIllness = math.random(1, 100)
            local ChanceOfPlayerIllness1 = math.random(1, 100)
            local ChanceOfPlayerIllness2 = math.random(1, 100)
            local ChanceOfPlayerIllness3 = math.random(1, 100)
            local ChanceOfPlayerIllness4 = math.random(1, 100)
            local ChanceOfPlayerIllness5 = math.random(1, 100)
            if ChanceOfPlayerIllness <= chance then
                if not isPlayerIll then
                    isPlayerIll = true
                    husten = true
                    TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Husten", 2000)
                    TriggerServerEvent("SevenLife:Krankheiten:husten")
                end
            elseif ChanceOfPlayerIllness1 <= chance2 then
                if not isPlayerIll then
                    isPlayerIll = true
                    bauchschmerzen = true
                    TriggerServerEvent("SevenLife:Krankheiten:bauchschmerzen")
                    TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Bauschschmerzen bekommen", 2000)
                end
            elseif ChanceOfPlayerIllness2 <= chance3 then
                if not isPlayerIll then
                    isPlayerIll = true
                    rosazea = true
                    TriggerEvent(
                        "sevenlife:openannounce",
                        "Krankheit",
                        "Du hast einen Hautauschlag namens Rosazea",
                        2000
                    )
                    TriggerServerEvent("SevenLife:Krankheiten:Rosazea")
                end
            elseif ChanceOfPlayerIllness3 <= chance4 then
                if not isPlayerIll then
                    isPlayerIll = true
                    corona = true
                    TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Corona", 2000)
                    TriggerServerEvent("SevenLife:Krankheiten:Rosazea")
                end
            elseif ChanceOfPlayerIllness4 <= chance5 then
                -- Fieber
                if not isPlayerIll then
                    isPlayerIll = true
                    fieber = true
                    TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Fieber", 2000)
                    TriggerServerEvent("SevenLife:Krankheiten:Fieber")
                end
            elseif ChanceOfPlayerIllness5 <= chance6 then
                -- Durchfall
                if not isPlayerIll then
                    isPlayerIll = true
                    durchfall = true
                    TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Durchfall", 2000)
                    TriggerServerEvent("SevenLife:Krankheiten:Durchfall")
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            local ChncefueHusten = math.random(30000, 100000)

            Citizen.Wait(ChncefueHusten)
            local playerPed = GetPlayerPed(-1)
            if husten then
                TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Husten", 2000)
                RequestAnimDict("timetable@gardener@smoking_joint")
                while not HasAnimDictLoaded("timetable@gardener@smoking_joint") do
                    Citizen.Wait(100)
                end

                TaskPlayAnim(
                    GetPlayerPed(-1),
                    "timetable@gardener@smoking_joint",
                    "idle_cough",
                    8.0,
                    8.0,
                    -1,
                    50,
                    0,
                    false,
                    false,
                    false
                )
                Citizen.Wait(3000)
                ClearPedSecondaryTask(GetPlayerPed(-1))
            elseif bauchschmerzen then
                TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Bauschschmerzen bekommen", 2000)
                local maxHealth = GetEntityMaxHealth(playerPed)
                local health = GetEntityHealth(playerPed)
                local newHealth = math.min(maxHealth, math.floor(health - maxHealth / 19))
                RequestAnimDict("oddjobs@taxi@tie")
                while not HasAnimDictLoaded("oddjobs@taxi@tie") do
                    Citizen.Wait(100)
                end

                TaskPlayAnim(
                    GetPlayerPed(-1),
                    "oddjobs@taxi@tie",
                    "vomit_outside",
                    8.0,
                    8.0,
                    -1,
                    50,
                    0,
                    false,
                    false,
                    false
                )
                Citizen.Wait(7000)

                ClearPedSecondaryTask(GetPlayerPed(-1))
                SetEntityHealth(playerPed, newHealth)
            elseif rosazea then
                SetPedHeadOverlay(playerPed, 5, 26, (3 / 10) + 0.0)
                SetPedHeadOverlayColor(playerPed, 5, 2, 0)
                SetPedHeadOverlay(playerPed, 7, 10, (10 / 10) + 0.0)
                TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast einen Hautauschlag namens Rosazea", 2000)
            elseif corona then
                TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Corona", 2000)
                RequestAnimDict("timetable@gardener@smoking_joint")
                while not HasAnimDictLoaded("timetable@gardener@smoking_joint") do
                    Citizen.Wait(100)
                end

                TaskPlayAnim(
                    GetPlayerPed(-1),
                    "timetable@gardener@smoking_joint",
                    "idle_cough",
                    8.0,
                    8.0,
                    -1,
                    50,
                    0,
                    false,
                    false,
                    false
                )
                Citizen.Wait(3000)
                ClearPedSecondaryTask(GetPlayerPed(-1))
            elseif fieber then
                TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Fieber", 2000)
                RequestAnimDict("timetable@gardener@smoking_joint")
                while not HasAnimDictLoaded("timetable@gardener@smoking_joint") do
                    Citizen.Wait(100)
                end

                TaskPlayAnim(
                    GetPlayerPed(-1),
                    "timetable@gardener@smoking_joint",
                    "idle_cough",
                    8.0,
                    8.0,
                    -1,
                    50,
                    0,
                    false,
                    false,
                    false
                )
                Citizen.Wait(3000)
                ClearPedSecondaryTask(GetPlayerPed(-1))
            elseif durchfall then
                TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Durchfall", 2000)
                RequestAnimDict("timetable@gardener@smoking_joint")
                while not HasAnimDictLoaded("timetable@gardener@smoking_joint") do
                    Citizen.Wait(100)
                end

                TaskPlayAnim(
                    GetPlayerPed(-1),
                    "timetable@gardener@smoking_joint",
                    "idle_cough",
                    8.0,
                    8.0,
                    -1,
                    50,
                    0,
                    false,
                    false,
                    false
                )
                Citizen.Wait(3000)
                ClearPedSecondaryTask(GetPlayerPed(-1))
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            local ChancefueHeal = math.random(900000, 1800000) -- Chance of being healthy by yourself

            Citizen.Wait(ChancefueHeal)

            if isPlayerIll then
                isPlayerIll = false
                bauchschmerzen = false
                husten = false
                rosazea = false
                corona = false
                fieber = false
                durchfall = false
                TriggerEvent("SevenLife:KrankHeit:Bauchschmerzen")
            end
        end
    end
)

AddEventHandler(
    "playerSpawned",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Krankheiten:GetData",
            function(Krankheiten)
                if Krankheiten == "husten" then
                    husten = true
                    TriggerServerEvent("SevenLife:Krankheiten:husten")
                    TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Husten", 2000)
                elseif Krankheiten == "bauchschmerzen" then
                    bauchschmerzen = true
                    TriggerServerEvent("SevenLife:Krankheiten:bauchschmerzen")
                    TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Bauschschmerzen bekommen", 2000)
                elseif Krankheiten == "Rosazea" then
                    rosazea = true
                    TriggerServerEvent("SevenLife:Krankheiten:Rosazea")
                    TriggerEvent(
                        "sevenlife:openannounce",
                        "Krankheit",
                        "Du hast einen Hautauschlag namens Rosazea",
                        2000
                    )
                elseif Krankheiten == "corona" then
                    corona = true
                    TriggerServerEvent("SevenLife:Krankheiten:Corona")
                    TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Corona", 2000)
                elseif Krankheiten == "fieber" then
                    fieber = true
                    TriggerServerEvent("SevenLife:Krankheiten:Fieber")
                    TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Fieber", 2000)
                elseif Krankheiten == "durchfall" then
                    durchfall = true
                    TriggerServerEvent("SevenLife:Krankheiten:Durchfall")
                    TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Furchfall", 2000)
                end
            end
        )
    end
)

-- Remove Krankheiten

RegisterNetEvent("SevenLife:KrankHeit:Husten")
AddEventHandler(
    "SevenLife:KrankHeit:Husten",
    function()
        husten = false

        Citizen.Wait(3000)

        TriggerServerEvent("SevenLife:Krankheiten:DeleteIllnes")
        TriggerEvent("sevenlife:openannounce", "Krankheit", "Krankheit erfolgreich geheilt", 2000)
    end
)

RegisterNetEvent("SevenLife:KrankHeit:Bauchschmerzen")
AddEventHandler(
    "SevenLife:KrankHeit:Bauchschmerzen",
    function()
        bauchschmerzen = false
        local playerPed = GetPlayerPed(-1)
        local maxHealth = GetEntityMaxHealth(playerPed)

        RequestAnimDict("mp_suicide")
        while not HasAnimDictLoaded("mp_suicide") do
            Citizen.Wait(100)
        end

        TaskPlayAnim(GetPlayerPed(-1), "mp_suicide", "pill_fp", 8.0, 8.0, -1, 50, 0, false, false, false)
        Citizen.Wait(3000)
        ClearPedSecondaryTask(GetPlayerPed(-1))
        TriggerServerEvent("SevenLife:Krankheiten:DeleteIllnes")
        TriggerEvent("sevenlife:openannounce", "Krankheit", "Du hast Bauschschmerzen", 2000)
    end
)

RegisterNetEvent("SevenLife:KrankHeit:Haut")
AddEventHandler(
    "SevenLife:KrankHeit:Haut",
    function()
        rosazea = false
        local playerPed = GetPlayerPed(-1)

        RequestAnimDict("mp_suicide")
        while not HasAnimDictLoaded("mp_suicide") do
            Citizen.Wait(100)
        end

        TaskPlayAnim(GetPlayerPed(-1), "mp_suicide", "pill_fp", 8.0, 8.0, -1, 50, 0, false, false, false)
        Citizen.Wait(3000)
        ClearPedSecondaryTask(GetPlayerPed(-1))
        TriggerServerEvent("SevenLife:Krankheiten:DeleteIllnes")
        TriggerEvent("sevenlife:openannounce", "Krankheit", "Krankheit erfolgreich geheilt", 2000)
        ESX.TriggerServerCallback(
            "esx_skin:getPlayerSkin",
            function(skin)
                TriggerEvent("skinchanger:loadSkin", skin)
            end
        )
    end
)
RegisterNetEvent("SevenLife:KrankHeit:Corona")
AddEventHandler(
    "SevenLife:KrankHeit:Corona",
    function()
        corona = false

        Citizen.Wait(3000)

        TriggerServerEvent("SevenLife:Krankheiten:DeleteIllnes")
        TriggerEvent("sevenlife:openannounce", "Krankheit", "Krankheit erfolgreich geheilt", 2000)
    end
)
RegisterNetEvent("SevenLife:KrankHeit:fieber")
AddEventHandler(
    "SevenLife:KrankHeit:fieber",
    function()
        fieber = false
        local playerPed = GetPlayerPed(-1)

        RequestAnimDict("mp_suicide")
        while not HasAnimDictLoaded("mp_suicide") do
            Citizen.Wait(100)
        end

        TaskPlayAnim(GetPlayerPed(-1), "mp_suicide", "pill_fp", 8.0, 8.0, -1, 50, 0, false, false, false)
        Citizen.Wait(3000)
        ClearPedSecondaryTask(GetPlayerPed(-1))
        TriggerServerEvent("SevenLife:Krankheiten:DeleteIllnes")
        TriggerEvent("sevenlife:openannounce", "Krankheit", "Krankheit erfolgreich geheilt", 2000)
        ESX.TriggerServerCallback(
            "esx_skin:getPlayerSkin",
            function(skin)
                TriggerEvent("skinchanger:loadSkin", skin)
            end
        )
    end
)
RegisterNetEvent("SevenLife:KrankHeit:durchfall")
AddEventHandler(
    "SevenLife:KrankHeit:durchfall",
    function()
        durchfall = false
        local playerPed = GetPlayerPed(-1)

        RequestAnimDict("mp_suicide")
        while not HasAnimDictLoaded("mp_suicide") do
            Citizen.Wait(100)
        end

        TaskPlayAnim(GetPlayerPed(-1), "mp_suicide", "pill_fp", 8.0, 8.0, -1, 50, 0, false, false, false)
        Citizen.Wait(3000)
        ClearPedSecondaryTask(GetPlayerPed(-1))
        TriggerServerEvent("SevenLife:Krankheiten:DeleteIllnes")
        TriggerEvent("sevenlife:openannounce", "Krankheit", "Krankheit erfolgreich geheilt", 2000)
        ESX.TriggerServerCallback(
            "esx_skin:getPlayerSkin",
            function(skin)
                TriggerEvent("skinchanger:loadSkin", skin)
            end
        )
    end
)

local inapothekerange = false
local notifys = true
local inmenu = false
local ped = GetHashKey("a_m_y_business_03")
-- Pharma Apotheke

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)

            local distance =
                GetDistanceBetweenCoords(
                coords,
                SevenConfig.LocationApotheke.x,
                SevenConfig.LocationApotheke.y,
                SevenConfig.LocationApotheke.z,
                true
            )

            if not IsPedInAnyVehicle(player, true) then
                if distance < 2.5 then
                    inapothekerange = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um dir das Apotheken Sortiment anzugucken",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.6 and distance <= 6 then
                        inapothekerange = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                inapothekerange = false
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inapothekerange then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        TriggerEvent("sevenliferp:closenotify", false)
                        inmenu = true
                        notifys = false
                        TriggerScreenblurFadeIn(2000)
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenApothekenMenu"
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

Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                SevenConfig.LocationApotheke.x,
                SevenConfig.LocationApotheke.y,
                SevenConfig.LocationApotheke.z,
                true
            )

            Citizen.Wait(1000)

            if distance < 40 then
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
                        SevenConfig.LocationApotheke.x,
                        SevenConfig.LocationApotheke.y,
                        SevenConfig.LocationApotheke.z,
                        SevenConfig.LocationApotheke.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped1, true)
                    FreezeEntityPosition(ped1, true)
                    SetBlockingOfNonTemporaryEvents(ped1, true)
                    RequestAnimDict("missfbi_s4mop")
                    while not HasAnimDictLoaded("missfbi_s4mop") do
                        Citizen.Wait(1)
                    end
                    TaskPlayAnim(ped1, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                pedarea = false
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped1)
                SetModelAsNoLongerNeeded(ped1)
                pedloaded = false
            end
        end
    end
)

RegisterNUICallback(
    "BuyItem",
    function(data)
        local types = data.type

        local price = tonumber(data.price)
        TriggerScreenblurFadeOut(2000)
        SetNuiFocus(false, false)
        notifys = true
        inmenu = false
        ESX.TriggerServerCallback(
            "SevenLife:MaskeMenu:CheckIfEnoughMoney",
            function(enoughmoney)
                if enoughmoney then
                    if types == "1" then
                        TriggerServerEvent("SevenLife:Pharma:MakeServer", price, types)
                    elseif types == "2" then
                        TriggerServerEvent("SevenLife:Pharma:MakeServer", price, types)
                    elseif types == "3" then
                        ESX.TriggerServerCallback(
                            "SevenLife:Pharma:CheckIfPlayerHaveRecipt",
                            function(haverecipt)
                                if haverecipt then
                                    TriggerServerEvent("SevenLife:Pharma:MakeServer", price, types)
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Apotheke",
                                        "Du brauchst für dieses Medikament einen gültigen Arzt - Rezept",
                                        2000
                                    )
                                end
                            end,
                            types
                        )
                    elseif types == "4" then
                        ESX.TriggerServerCallback(
                            "SevenLife:Pharma:CheckIfPlayerHaveRecipt",
                            function(haverecipt)
                                if haverecipt then
                                    TriggerServerEvent("SevenLife:Pharma:MakeServer", price, types)
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Apotheke",
                                        "Du brauchst für dieses Medikament einen gültigen Arzt - Rezept",
                                        2000
                                    )
                                end
                            end,
                            types
                        )
                    elseif types == "5" then
                        ESX.TriggerServerCallback(
                            "SevenLife:Pharma:CheckIfPlayerHaveRecipt",
                            function(haverecipt)
                                if haverecipt then
                                    TriggerServerEvent("SevenLife:Pharma:MakeServer", price, types)
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Apotheke",
                                        "Du brauchst für dieses Medikament einen gültigen Arzt - Rezept",
                                        2000
                                    )
                                end
                            end,
                            types
                        )
                    end
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Apotheke", "Du besitzt zu wenig Geld", 2000)
                end
            end,
            price
        )
    end
)
function BlipApotheke()
    local blips =
        vector3(SevenConfig.LocationApotheke.x, SevenConfig.LocationApotheke.y, SevenConfig.LocationApotheke.z)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 621)
    SetBlipScale(blip1, 0.9)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 4)
    SetBlipAsShortRange(blip1, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Apotheke")
    EndTextCommandSetBlipName(blip1)
end

RegisterNUICallback(
    "CloseMenu",
    function()
        TriggerScreenblurFadeOut(2000)
        SetNuiFocus(false, false)
        notifys = true
        inmenu = false
    end
)
