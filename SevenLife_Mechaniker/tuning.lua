-- ESX
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
-- Variables
local inareaoftuning = false
local InRangeOfTuning = false
local TimeSpeed = 100
local wheeltype
local proccesing = false
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
                Config.MakeWerstatt.x,
                Config.MakeWerstatt.y,
                Config.MakeWerstatt.z,
                true
            )
            if mechanik then
                if IsPedInAnyVehicle(player, true) then
                    if distance < 40 then
                        inareaoftuning = true
                        if distance < 5.5 then
                            InRangeOfTuning = true
                            if not proccesing then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um dein Fahrzeug zu Tunen",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 5.6 and distance <= 7 then
                                InRangeOfTuning = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        inareaoftuning = false
                    end
                else
                    InRangeOfTuning = false
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
            Citizen.Wait(TimeSpeed)
            if inareaoftuning then
                if not proccesing then
                    TimeSpeed = 1
                    DrawMarker(
                        Config.MarkerType,
                        Config.MakeWerstatt.x,
                        Config.MakeWerstatt.y,
                        Config.MakeWerstatt.z,
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
                TimeSpeed = 1000
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if InRangeOfTuning then
                if IsControlJustPressed(0, 38) then
                    if indienst == true then
                        SetNuiFocus(true, true)
                        proccesing = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        TriggerServerEvent("SevenLife:Mechaniker:ClearList")
                        SendNUIMessage(
                            {
                                type = "OpenTuning",
                                result = lsc
                            }
                        )
                        EnableCam()
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
    "GetTuningOptions",
    function(data)
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped)
        local mod = 1
        local frontbumper = {}
        local rarebumper = {}
        local exhaust = {}
        local fenders = {}
        local rollcage = {}
        local grille = {}
        local hood = {}
        if data.name == "frontbumper" then
            SetVehicleModKit(veh, 0)
            if GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh, mod) ~= false then
                for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
                    local lbl = GetModTextLabel(veh, mod, i)
                    if lbl ~= nil then
                        local name = tostring(GetLabelText(lbl))
                        if name ~= "NULL" then
                            table.insert(
                                frontbumper,
                                {
                                    name = name,
                                    modtype = mod,
                                    costs = 1000,
                                    mod = i,
                                    description = ""
                                }
                            )
                        end
                    end
                end
            end
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = frontbumper,
                    names = "frontbumper"
                }
            )
        elseif data.name == "rearbumper" then
            mod = 2
            SetVehicleModKit(veh, 0)
            if GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh, mod) ~= false then
                for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
                    local lbl = GetModTextLabel(veh, mod, i)
                    if lbl ~= nil then
                        local name = tostring(GetLabelText(lbl))
                        if name ~= "NULL" then
                            table.insert(
                                rarebumper,
                                {
                                    name = name,
                                    modtype = mod,
                                    costs = 1000,
                                    mod = i,
                                    description = ""
                                }
                            )
                        end
                    end
                end
            end
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = rarebumper,
                    names = "rearbumper"
                }
            )
        elseif data.name == "exhaust" then
            mod = 4
            SetVehicleModKit(veh, 0)
            if GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh, mod) ~= false then
                for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
                    local lbl = GetModTextLabel(veh, mod, i)
                    if lbl ~= nil then
                        local name = tostring(GetLabelText(lbl))
                        if name ~= "NULL" then
                            table.insert(
                                exhaust,
                                {
                                    name = name,
                                    modtype = mod,
                                    costs = 1000,
                                    mod = i,
                                    description = ""
                                }
                            )
                        end
                    end
                end
            end
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = exhaust,
                    names = "exhaust"
                }
            )
        elseif data.name == "fenders" then
            mod = 8

            SetVehicleModKit(veh, 0)

            if GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh, mod) ~= false then
                for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
                    local lbl = GetModTextLabel(veh, mod, i)
                    if lbl ~= nil then
                        local name = tostring(GetLabelText(lbl))
                        if name ~= "NULL" then
                            table.insert(
                                fenders,
                                {
                                    name = name,
                                    modtype = mod,
                                    costs = 1000,
                                    mod = i,
                                    description = ""
                                }
                            )
                        end
                    end
                end
            end
            mod = 9
            if GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh, mod) ~= false then
                for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
                    local lbl = GetModTextLabel(veh, mod, i)
                    if lbl ~= nil then
                        local name = tostring(GetLabelText(lbl))
                        if name ~= "NULL" then
                            table.insert(
                                fenders,
                                {
                                    name = name,
                                    modtype = mod,
                                    costs = 1000,
                                    mod = i,
                                    description = ""
                                }
                            )
                        end
                    end
                end
            end
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = fenders,
                    names = "fenders"
                }
            )
        elseif data.name == "grille" then
            local grille = {}
            mod = 6
            SetVehicleModKit(veh, 0)

            if GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh, mod) ~= false then
                for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
                    local lbl = GetModTextLabel(veh, mod, i)

                    if lbl ~= nil then
                        local name = tostring(GetLabelText(lbl))
                        if name ~= "NULL" then
                            table.insert(
                                grille,
                                {
                                    name = name,
                                    modtype = mod,
                                    costs = 1000,
                                    mod = i,
                                    description = ""
                                }
                            )
                        end
                    end
                end
            end
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = grille,
                    names = "grille"
                }
            )
        elseif data.name == "hood" then
            mod = 7
            SetVehicleModKit(veh, 0)
            if GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh, mod) ~= false then
                for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
                    local lbl = GetModTextLabel(veh, mod, i)

                    if lbl ~= nil then
                        local name = tostring(GetLabelText(lbl))
                        if name ~= "NULL" then
                            table.insert(
                                hood,
                                {
                                    name = name,
                                    modtype = mod,
                                    costs = 1000,
                                    mod = i,
                                    description = ""
                                }
                            )
                        end
                    end
                end
            end
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = hood,
                    names = "hood"
                }
            )
        elseif data.name == "rollcage" then
            mod = 5
            SetVehicleModKit(veh, 0)
            if GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh, mod) ~= false then
                for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
                    local lbl = GetModTextLabel(veh, mod, i)
                    if lbl ~= nil then
                        local name = tostring(GetLabelText(lbl))
                        if name ~= "NULL" then
                            table.insert(
                                rollcage,
                                {
                                    name = name,
                                    modtype = mod,
                                    costs = 1000,
                                    mod = i,
                                    description = ""
                                }
                            )
                        end
                    end
                end
            end
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = rollcage,
                    names = "rollcage"
                }
            )
        elseif data.name == "roof" then
            local roof = {}
            mod = 10

            SetVehicleModKit(veh, 0)

            if GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh, mod) ~= false then
                for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
                    local lbl = GetModTextLabel(veh, mod, i)

                    if lbl ~= nil then
                        local name = tostring(GetLabelText(lbl))
                        if name ~= "NULL" then
                            table.insert(
                                roof,
                                {
                                    name = name,
                                    modtype = mod,
                                    costs = 1000,
                                    mod = i,
                                    description = ""
                                }
                            )
                        end
                    end
                end
            end
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = roof,
                    names = "roof"
                }
            )
        elseif data.name == "skirts" then
            local skirts = {}
            mod = 3
            SetVehicleModKit(veh, 0)

            if GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh, mod) ~= false then
                for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
                    local lbl = GetModTextLabel(veh, mod, i)

                    if lbl ~= nil then
                        local name = tostring(GetLabelText(lbl))
                        if name ~= "NULL" then
                            table.insert(
                                skirts,
                                {
                                    name = name,
                                    modtype = mod,
                                    costs = 1000,
                                    mod = i,
                                    description = ""
                                }
                            )
                        end
                    end
                end
            end
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = skirts,
                    names = "skirts"
                }
            )
        elseif data.name == "spoiler" then
            local spoiler = {}
            mod = 0

            SetVehicleModKit(veh, 0)

            if GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh, mod) ~= false then
                for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
                    local lbl = GetModTextLabel(veh, mod, i)

                    if lbl ~= nil then
                        local name = tostring(GetLabelText(lbl))
                        if name ~= "NULL" then
                            table.insert(
                                spoiler,
                                {
                                    name = name,
                                    modtype = mod,
                                    costs = 1000,
                                    mod = i,
                                    description = ""
                                }
                            )
                        end
                    end
                end
            end
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = spoiler,
                    names = "spoiler"
                }
            )
        elseif data.name == "chassis" then
            local chassis = {}
            mod = 5
            SetVehicleModKit(veh, 0)

            if GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh, mod) ~= false then
                for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
                    local lbl = GetModTextLabel(veh, mod, i)

                    if lbl ~= nil then
                        local name = tostring(GetLabelText(lbl))
                        if name ~= "NULL" then
                            table.insert(
                                chassis,
                                {
                                    name = name,
                                    modtype = mod,
                                    costs = 1000,
                                    mod = i,
                                    description = ""
                                }
                            )
                        end
                    end
                end
            end
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = chassis,
                    names = "chassis"
                }
            )
        elseif data.name == "windows" then
            SetVehicleModKit(veh, 0)
            local windows = {
                {
                    name = "None",
                    tint = false,
                    costs = 100
                },
                {
                    name = "Schwarz",
                    tint = 1,
                    costs = 100
                },
                {
                    name = "Schwarzer Rauch",
                    tint = 2,
                    costs = 100
                },
                {
                    name = "Weißer Rauch",
                    tint = 3,
                    costs = 100
                },
                {
                    name = "Limo",
                    tint = 4,
                    costs = 100
                },
                {
                    name = "Grün",
                    tint = 5,
                    costs = 100
                }
            }

            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = windows,
                    names = "windows"
                }
            )
        elseif data.name == "wheelaccessories" then
            SetVehicleModKit(veh, 0)
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.wheelaccessories.buttons,
                    names = "wheelaccessories"
                }
            )
        elseif data.name == "suspensions" then
            SetVehicleModKit(veh, 0)
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.suspension.buttons,
                    names = "suspensions"
                }
            )
        elseif data.name == "transmission" then
            SetVehicleModKit(veh, 0)
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.transmission.buttons,
                    names = "transmission"
                }
            )
        elseif data.name == "turbo" then
            SetVehicleModKit(veh, 0)
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.turbo.buttons,
                    names = "turbo"
                }
            )
        elseif data.name == "sport" then
            SetVehicleModKit(veh, 0)
            wheeltype = 0
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.sport.buttons,
                    names = "sport"
                }
            )
        elseif data.name == "suv" then
            SetVehicleModKit(veh, 0)
            wheeltype = 3
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.suv.buttons,
                    names = "suv"
                }
            )
        elseif data.name == "offroad" then
            SetVehicleModKit(veh, 0)
            wheeltype = 4
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.offroad.buttons,
                    names = "offroad"
                }
            )
        elseif data.name == "tuner" then
            SetVehicleModKit(veh, 0)
            wheeltype = 5
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.tuner.buttons,
                    names = "tuner"
                }
            )
        elseif data.name == "highend" then
            SetVehicleModKit(veh, 0)
            wheeltype = 7
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.highend.buttons,
                    names = "highend"
                }
            )
        elseif data.name == "lowrider" then
            SetVehicleModKit(veh, 0)
            wheeltype = 2
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.lowrider.buttons,
                    names = "lowrider"
                }
            )
        elseif data.name == "muscle" then
            SetVehicleModKit(veh, 0)
            wheeltype = 1
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.muscle.buttons,
                    names = "muscle"
                }
            )
        elseif data.name == "frontwheel" then
            SetVehicleModKit(veh, 0)
            wheeltype = 6
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.frontwheel.buttons,
                    names = "frontwheel"
                }
            )
        elseif data.name == "backwheel" then
            SetVehicleModKit(veh, 0)
            wheeltype = 8
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.backwheel.buttons,
                    names = "backwheel"
                }
            )
        elseif data.name == "lights" then
            SetVehicleModKit(veh, 0)
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.lights.buttons,
                    names = "lights"
                }
            )
        elseif data.name == "headlights" then
            SetVehicleModKit(veh, 0)
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.headlights.buttons,
                    names = "headlights"
                }
            )
        elseif data.name == "brakes" then
            SetVehicleModKit(veh, 0)
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.brakes.buttons,
                    names = "brakes"
                }
            )
        elseif data.name == "engine" then
            SetVehicleModKit(veh, 0)
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.engine.buttons,
                    names = "engine"
                }
            )
        elseif data.name == "horn" then
            SetVehicleModKit(veh, 0)
            SendNUIMessage(
                {
                    type = "OpenTuningID",
                    result = lsc.horn.buttons,
                    names = "horn"
                }
            )
        end
    end
)

RegisterNUICallback(
    "TryTuning",
    function(data)
        local ped = GetPlayerPed(-1)
        local car = GetVehiclePedIsIn(ped)
        local tint

        local modnumber
        if data.tint ~= nil then
            tint = tonumber(data.tint)
        end

        if data.modnumber ~= nil then
            if data.modnumber == "true" or data.modnumber == "false" then
                modnumber = data.modnumber
            else
                modnumber = tonumber(data.modnumber)
            end
        end

        if
            data.name == "sport" or data.name == "muscle" or data.name == "lowrider" or data.name == "frontwheel" or
                data.name == "highend" or
                data.name == "suv" or
                data.name == "offroad" or
                data.name == "tuner"
         then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        SetVehicleWheelType(car, wheeltype)
                        SetVehicleMod(car, 23, modnumber)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Upgrade erfolgreich installiert",
                            2000
                        )
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du ein Rad (Item) ",
                            2000
                        )
                    end
                end,
                "rad"
            )
        elseif data.name == "backwheel" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        SetVehicleWheelType(car, wheeltype)
                        SetVehicleMod(car, 24, modnumber)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Upgrade erfolgreich installiert",
                            2000
                        )
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du ein Rad (Item) ",
                            2000
                        )
                    end
                end,
                "rad"
            )
        elseif data.name == "spoiler" then
            SetVehicleMod(car, 0, modnumber)
            TriggerEvent("SevenLife:TimetCustom:Notify", "Mechaniker", "Upgrade erfolgreich installiert", 2000)
        elseif data.name == "frontbumper" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        SetVehicleMod(car, 1, modnumber)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Upgrade erfolgreich installiert",
                            2000
                        )
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du eine Vordere Stoßstange (Item) ",
                            2000
                        )
                    end
                end,
                "vorderestoßstangen"
            )
        elseif data.name == "rearbumper" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        SetVehicleMod(car, 2, modnumber)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Upgrade erfolgreich installiert",
                            2000
                        )
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du eine Hintere Stoßstange (Item) ",
                            2000
                        )
                    end
                end,
                "hinterestoßstangen"
            )
        elseif data.name == "skirts" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        SetVehicleMod(car, 3, modnumber)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Upgrade erfolgreich installiert",
                            2000
                        )
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du einen Seitenschweller (Item) ",
                            2000
                        )
                    end
                end,
                "seitenschweller"
            )
        elseif data.name == "exhaust" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        SetVehicleMod(car, 4, modnumber)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Upgrade erfolgreich installiert",
                            2000
                        )
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du einen Auspuff (Item) ",
                            2000
                        )
                    end
                end,
                "auspuff"
            )
        elseif data.name == "rollcage" then
            SetVehicleMod(car, 5, modnumber)
            TriggerEvent("SevenLife:TimetCustom:Notify", "Mechaniker", "Upgrade erfolgreich installiert", 2000)
        elseif data.name == "grille" then
            SetVehicleMod(car, 6, modnumber)
            TriggerEvent("SevenLife:TimetCustom:Notify", "Mechaniker", "Upgrade erfolgreich installiert", 2000)
        elseif data.name == "hood" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        SetVehicleMod(car, 7, modnumber)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Upgrade erfolgreich installiert",
                            2000
                        )
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du eine Motorhaube (Item) ",
                            2000
                        )
                    end
                end,
                "motorhaube"
            )
        elseif data.name == "fenders" then
            SetVehicleMod(car, 8, modnumber)
            SetVehicleMod(car, 9, modnumber)
            TriggerEvent("SevenLife:TimetCustom:Notify", "Mechaniker", "Upgrade erfolgreich installiert", 2000)
        elseif data.name == "roof" then
            SetVehicleMod(car, 10, modnumber)
            TriggerEvent("SevenLife:TimetCustom:Notify", "Mechaniker", "Upgrade erfolgreich installiert", 2000)
        elseif data.name == "horn" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        SetVehicleMod(car, 14, modnumber)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Upgrade erfolgreich installiert",
                            2000
                        )
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du eine Hupe (Item) ",
                            2000
                        )
                    end
                end,
                "hupe"
            )
        elseif data.name == "suspension" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        SetVehicleMod(car, 15, modnumber)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Upgrade erfolgreich installiert",
                            2000
                        )
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du eine Federung (Item) ",
                            2000
                        )
                    end
                end,
                "federung"
            )
        elseif data.name == "windows" then
            SetVehicleWindowTint(car, tint)
            TriggerEvent("SevenLife:TimetCustom:Notify", "Mechaniker", "Upgrade erfolgreich installiert", 2000)
        elseif data.name == "turbo" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        if modnumber == false then
                            ToggleVehicleMod(car, 18, false)
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Mechaniker",
                                "Upgrade erfolgreich installiert",
                                2000
                            )
                        else
                            if modnumber == true then
                                ToggleVehicleMod(car, 18, true)
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Mechaniker",
                                    "Upgrade erfolgreich installiert",
                                    2000
                                )
                            end
                        end
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du einen Turbo (Item) ",
                            2000
                        )
                    end
                end,
                "turbo"
            )
        elseif data.name == "headlights" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        if modnumber == false then
                            ToggleVehicleMod(car, 22, false)
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Mechaniker",
                                "Upgrade erfolgreich installiert",
                                2000
                            )
                        else
                            if modnumber == true then
                                ToggleVehicleMod(car, 22, true)
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Mechaniker",
                                    "Upgrade erfolgreich installiert",
                                    2000
                                )
                            end
                        end
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du einen Xenon (Item) ",
                            2000
                        )
                    end
                end,
                "xenon"
            )
        elseif data.name == "engine" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        ToggleVehicleMod(car, 11, data.modnumber)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Upgrade erfolgreich installiert",
                            2000
                        )
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du einen Motor (Item) ",
                            2000
                        )
                    end
                end,
                "motor"
            )
        elseif data.name == "brakes" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        ToggleVehicleMod(car, 12, data.modnumber)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Upgrade erfolgreich installiert",
                            2000
                        )
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du eine Bremse (Item) ",
                            2000
                        )
                    end
                end,
                "bremsen"
            )
        elseif data.name == "transmission" then
            ESX.TriggerServerCallback(
                "SevenLife:Mechaniker:GetItemForUpgrade",
                function(result)
                    if result then
                        ToggleVehicleMod(car, 13, data.modnumber)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Upgrade erfolgreich installiert",
                            2000
                        )
                    else
                        SendNUIMessage(
                            {
                                type = "CloseAll"
                            }
                        )
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Für dieses Upgrade benötigst du ein Getriebe (Item) ",
                            2000
                        )
                    end
                end,
                "getriebe"
            )
        end
    end
)

RegisterNUICallback(
    "BuyUpgrades",
    function()
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped)
        TriggerServerEvent("SevenLife:Mechaniker:BuyUpgrades", 100)
        TriggerServerEvent(
            "sevenlife:savecartile",
            GetVehicleNumberPlateText(vehicle),
            ESX.Game.GetVehicleProperties(vehicle)
        )
    end
)
function EnableCam()
    local ped = GetPlayerPed(-1)
    coords = vector3(-226.11143493652, -1321.1864013672, 31.890298843384)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local pedPos = GetEntityCoords(vehicle)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(camara, false)
    if (not DoesCamExist(camara)) then
        camara = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(camara, true)
        RenderScriptCams(true, false, 0, true, true)
        SetCamCoord(camara, coords)
        PointCamAtCoord(camara, pedPos.x, pedPos.y, 31.890298843384)
    end
    headingToCam = GetEntityHeading(PlayerPedId()) + 90
end

RegisterNUICallback(
    "rotationleft",
    function(data)
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local pedPos = GetEntityCoords(vehicle)
        local camPos = GetCamCoord(camara)
        local headings = headingToCam
        headings = headings + 2.5
        headingToCam = headings
        local cx, cy = GetPositionByRelativeHeading(vehicle, headings, 6)
        SetCamCoord(camara, cx, cy, camPos.z)
        PointCamAtCoord(camara, pedPos.x, pedPos.y, camPos.z)
    end
)
RegisterNUICallback(
    "rotationright",
    function(data)
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local pedPos = GetEntityCoords(vehicle)
        local camPos = GetCamCoord(camara)
        local headings = headingToCam
        headings = headings - 2.5
        headingToCam = headings
        local cx, cy = GetPositionByRelativeHeading(vehicle, headings, 6)
        SetCamCoord(camara, cx, cy, camPos.z)
        PointCamAtCoord(camara, pedPos.x, pedPos.y, camPos.z)
    end
)
function GetPositionByRelativeHeading(ped, head, dist)
    local pedPos = GetEntityCoords(ped)

    local finPosx = pedPos.x + math.cos(head * (math.pi / 180)) * dist
    local finPosy = pedPos.y + math.sin(head * (math.pi / 180)) * dist

    return finPosx, finPosy
end
RegisterNUICallback(
    "Raus",
    function()
        SetNuiFocus(false, false)
        SetCamActive(camara, false)
        camara = nil
        RenderScriptCams(false, true, 500, true, true)
    end
)
RegisterNUICallback(
    "CloseMenuTuning",
    function()
        SetNuiFocus(false, false)
        SetCamActive(camara, false)
        camara = nil
        RenderScriptCams(false, true, 500, true, true)
        proccesing = false
    end
)