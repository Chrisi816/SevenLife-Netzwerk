-- Variables
local inofsprayarea = false
local InSpeedTime = 100
local InRangeOfSpray = false
local InProccess = false
local oldpainttype = nil
local oldpaint = nil
local oldpearl = nil
local oldr = nil
local oldg = nil
local oldb = nil
local changed = false
indienst = false
ESX = nil
Citizen.CreateThread(
    function()
        while ESX == nil do
            Citizen.Wait(10)
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
        end
    end
)
-- InPound
Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(
                coords,
                Config.Farbeeandern.x,
                Config.Farbeeandern.y,
                Config.Farbeeandern.z,
                true
            )
            if mechanik then
                if IsPedInAnyVehicle(player, true) then
                    if distance < 40 then
                        inofsprayarea = true
                        if distance < 5.5 then
                            InRangeOfSpray = true
                            if not InProccess then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um dein Fahrzeug zu Lackieren",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 5.6 and distance <= 7 then
                                InRangeOfSpray = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        inofsprayarea = false
                    end
                else
                    InRangeOfSpray = false
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
            Citizen.Wait(InSpeedTime)
            if inofsprayarea then
                if not InProccess then
                    InSpeedTime = 1
                    DrawMarker(
                        Config.MarkerType,
                        Config.Farbeeandern.x,
                        Config.Farbeeandern.y,
                        Config.Farbeeandern.z,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        Config.MarkerSize,
                        Config.MarkerColor.r,
                        Config.MarkerColor.g,
                        Config.MarkerColor.b,
                        100,
                        false,
                        true,
                        2,
                        false,
                        nil,
                        nil,
                        false
                    )
                end
            else
                InSpeedTime = 1000
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if InRangeOfSpray then
                if IsControlJustPressed(0, 38) then
                    if indienst == true then
                        SetNuiFocus(true, true)
                        InProccess = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        SendNUIMessage(
                            {
                                type = "OpenSprayMenu"
                            }
                        )
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Mechaniker", "Du bist nicht im Dienst", 2000)
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

RegisterNUICallback(
    "CheckIfMixed",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Mechaniker:GetInventoryMixedItem",
            function(havemixeditem)
                if havemixeditem then
                    if data.type == 1 then
                        SendNUIMessage(
                            {
                                type = "OpenLackierungMenuPrimear"
                            }
                        )
                    else
                        if data.type == 2 then
                            SendNUIMessage(
                                {
                                    type = "OpenLackierungMenuSekundär"
                                }
                            )
                        else
                            if data.type == 3 then
                                SendNUIMessage(
                                    {
                                        type = "OpenLackierungMenuPearl"
                                    }
                                )
                            end
                        end
                    end
                else
                    InProccess = false
                    SetNuiFocus(false, false)
                    SendNUIMessage(
                        {
                            type = "CloseAll"
                        }
                    )
                    Citizen.Wait(200)
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Mechaniker",
                        "Du besitzt zu wenig an gemixter Lackierung",
                        2000
                    )
                end
            end
        )
    end
)

RegisterNUICallback(
    "MakeColorTesting",
    function(data)
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local types = tonumber(data.type)
        if not changed then
            oldpainttype, oldpaint, oldpearl = GetVehicleModColor_1(vehicle)
            oldr, oldg, oldb = GetVehicleCustomPrimaryColour(vehicle)
            changed = true
        end
        Citizen.Wait(10)
        SetVehicleModColor_1(vehicle, types, 0, 0)
        SetVehicleCustomPrimaryColour(vehicle, data.r, data.g, data.b)
    end
)

RegisterNUICallback(
    "MakeColorTestingSekundär",
    function(data)
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local types = tonumber(data.type)
        if not changed then
            oldpainttype, oldpaint, oldpearl = GetVehicleModColor_1(vehicle)
            oldr, oldg, oldb = GetVehicleCustomPrimaryColour(vehicle)
            changed = true
        end
        Citizen.Wait(10)
        SetVehicleModColor_2(vehicle, types, 0, 0)
        SetVehicleCustomSecondaryColour(vehicle, data.r, data.g, data.b)
    end
)

RegisterNUICallback(
    "MakeColorTestingPearl",
    function(data)
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local tint = tonumber(data.tint)
        print(tint)
        Citizen.Wait(10)

        SetVehicleExtraColours(vehicle, tint, 0)
    end
)

RegisterNUICallback(
    "ResetCarPearl",
    function()
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        SetVehicleExtraColours(vehicle, 0, 0)
    end
)
RegisterNUICallback(
    "ResetCarColor",
    function()
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        changed = false
        SetVehicleModColor_1(vehicle, oldpainttype, 0, 0)
        SetVehicleCustomPrimaryColour(vehicle, oldr, oldg, oldb)
    end
)

RegisterNUICallback(
    "farbeapplybuy",
    function(data)
        local ped = GetPlayerPed(-1)
        local types = tonumber(data.type)
        SetNuiFocus(false, false)
        InProccess = false
        local vehicle = GetVehiclePedIsIn(ped, false)
        changed = false
        SetVehicleModColor_1(vehicle, types, 0, 0)
        SetVehicleCustomPrimaryColour(vehicle, data.r, data.g, data.b)
        TriggerServerEvent("SevenLife:Mechanik:SafeVehicle", ESX.Game.GetVehicleProperties(vehicle))
        TriggerServerEvent("SevenLife:PayandremoveMixed")
    end
)

RegisterNUICallback(
    "farbesekundearrapplybuy",
    function(data)
        local ped = GetPlayerPed(-1)
        local types = tonumber(data.type)
        SetNuiFocus(false, false)
        InProccess = false
        local vehicle = GetVehiclePedIsIn(ped, false)
        changed = false
        SetVehicleModColor_2(vehicle, types, 0, 0)
        SetVehicleCustomSecondaryColour(vehicle, data.r, data.g, data.b)
        TriggerServerEvent("SevenLife:Mechanik:SafeVehicle", ESX.Game.GetVehicleProperties(vehicle))
        TriggerServerEvent("SevenLife:PayandremoveMixed")
    end
)

RegisterNUICallback(
    "farbepearlapplybuy",
    function(data)
        local ped = GetPlayerPed(-1)
        local tint = tonumber(data.tint)
        SetNuiFocus(false, false)
        InProccess = false
        local vehicle = GetVehiclePedIsIn(ped, false)
        changed = false
        SetVehicleExtraColours(vehicle, tint, 0)
        TriggerServerEvent("SevenLife:Mechanik:SafeVehicle", ESX.Game.GetVehicleProperties(vehicle))
        TriggerServerEvent("SevenLife:PayandremoveMixed")
    end
)
-- Variables
local IsPlayerInMenuRange = false
local ActiveNotify = true
local IsInPadArea = false
local ped = GetHashKey("a_m_y_business_03")
local IsPlayerInMenu = false
local pedloaded = false

-- Mechaniker Menu

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(
                coords,
                Config.Arbeitskleidung.x,
                Config.Arbeitskleidung.y,
                Config.Arbeitskleidung.z,
                true
            )
            if mechanik then
                if IsPlayerInMenu == false then
                    if distance < 1.5 then
                        IsPlayerInMenuRange = true
                        if ActiveNotify then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um in den Dienst zu gehen",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 1.6 and distance <= 4 then
                            IsPlayerInMenuRange = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if IsPlayerInMenuRange then
                if IsControlJustPressed(0, 38) then
                    if not IsPlayerInMenu then
                        IsPlayerInMenu = true
                        ActiveNotify = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        SetNuiFocus(true, false)
                        SendNUIMessage(
                            {
                                type = "OpenDialogMenu"
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
                Config.Arbeitskleidung.x,
                Config.Arbeitskleidung.y,
                Config.Arbeitskleidung.z,
                true
            )

            Citizen.Wait(1000)
            IsInPadArea = false
            if distance < 40 then
                IsInPadArea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped4 =
                        CreatePed(
                        4,
                        ped,
                        Config.Arbeitskleidung.x,
                        Config.Arbeitskleidung.y,
                        Config.Arbeitskleidung.z,
                        Config.Arbeitskleidung.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped4, true)
                    FreezeEntityPosition(ped4, true)
                    SetBlockingOfNonTemporaryEvents(ped4, true)
                    RequestAnimDict("missfbi_s4mop")
                    while not HasAnimDictLoaded("missfbi_s4mop") do
                        Citizen.Wait(1)
                    end
                    TaskPlayAnim(ped4, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            end

            if pedloaded and not IsInPadArea then
                DeleteEntity(ped4)
                SetModelAsNoLongerNeeded(ped)
                pedloaded = false
            end
        end
    end
)
local haveoutfit = false
RegisterNUICallback(
    "MakeAction2",
    function(data)
        IsPlayerInMenu = false
        ActiveNotify = true
        local actions = tonumber(data.action)
        print("HEy")
        SetNuiFocus(false, false)
        if actions == 1 then
            if haveoutfit == false then
                haveoutfit = true
                TriggerEvent(
                    "SevenLife:TimetCustom:Notify",
                    "Mechaniker",
                    "Du hast die Kleidung erfolgreich angezogen",
                    2000
                )
                TriggerEvent(
                    "skinchanger:getSkin",
                    function(skin)
                        if skin.sex == 0 then
                            if Config.Kleidung.male ~= nil then
                                TriggerEvent("skinchanger:loadClothes", skin, Config.Kleidung.male)
                            end
                        else
                            if Config.Kleidung.female ~= nil then
                                TriggerEvent("skinchanger:loadClothes", skin, Config.Kleidung.female)
                            end
                        end
                    end
                )
            else
                if haveoutfit == true then
                    haveoutfit = false
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Mechaniker",
                        "Du hast die Kleidung erfolgreich ausgezogen",
                        2000
                    )
                    Resetskin()
                end
            end
        elseif actions == 2 then
            if indienst == false then
                indienst = true
                TriggerEvent("SevenLife:TimetCustom:Notify", "Mechaniker", "Du bist jetzt im Dienst", 2000)
            else
                if indienst == true then
                    indienst = false
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Mechaniker",
                        "Du besitzt ausserhalb des Dienstes",
                        2000
                    )
                end
            end
        elseif actions == 3 then
        elseif actions == 4 then
            if mechanik and PlayerData.job.grade == 4 then
                ESX.TriggerServerCallback(
                    "SevenLife:Mechaniker:GetMembersNumber",
                    function(result)
                        ESX.TriggerServerCallback(
                            "SevenLife:Mechaniker:GetMechanikerGeld",
                            function(cash)
                                local money = tonumber(cash[1].money)
                                SetNuiFocus(true, true)
                                SendNUIMessage(
                                    {
                                        type = "OpenBossMenu",
                                        result = result,
                                        cash = money
                                    }
                                )
                            end
                        )
                    end
                )
            else
                TriggerEvent("SevenLife:TimetCustom:Notify", "Mechaniker", "Du bist nicht in der Führungsebene", 2000)
            end
        end
    end
)

RegisterNUICallback(
    "CloseMenuPaint",
    function()
        IsPlayerInMenu = false
        InProccess = false
        ActiveNotify = true
    end
)

function Resetskin()
    ESX.TriggerServerCallback(
        "esx_skin:getPlayerSkin",
        function(skin)
            TriggerEvent("skinchanger:loadSkin", skin)
        end
    )
end
