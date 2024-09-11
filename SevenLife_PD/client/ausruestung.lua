-- Variables
waffenschrankcoords =
    vector3(Config.Polizei.WaffenSchrank.x, Config.Polizei.WaffenSchrank.y, Config.Polizei.WaffenSchrank.z)
inmenu2 = false
local time2 = 200
local time2betweenchecking = 200
AllowSevenNotify2 = true
inarea2 = false
local infogardrobe
inmarker2 = false
-- ESX

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
            Citizen.Wait(10)
        end
    end
)

-- Local Start
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time2)
            if IsPlayerInPD and inoutservice then
                local ped = GetPlayerPed(-1)
                local coordofped = GetEntityCoords(ped)
                local distance =
                    GetDistanceBetweenCoords(
                    coordofped,
                    Config.Polizei.WaffenSchrank.x,
                    Config.Polizei.WaffenSchrank.y,
                    Config.Polizei.WaffenSchrank.z,
                    true
                )
                if distance < 20 then
                    time2 = 110
                    inarea2 = true
                    if distance < 2 then
                        if AllowSevenNotify2 then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke E um den Waffenschrank zu öffnen",
                                "System-Nachricht",
                                true
                            )
                        end
                        inmarker2 = true
                    else
                        if distance >= 2.1 and distance <= 3 then
                            TriggerEvent("sevenliferp:closenotify", false)
                            inmarker2 = false
                        end
                    end
                else
                    inarea2 = false
                    time2 = 200
                end
            else
                Citizen.Wait(5000)
            end
        end
    end
)
-- KeyCheck
Citizen.CreateThread(
    function()
        while true do
            local ped = GetPlayerPed(-1)
            Citizen.Wait(time2betweenchecking)
            if inarea2 then
                time2betweenchecking = 5
                if IsPlayerInPD and inoutservice then
                    if inmarker2 and not inmenu2 then
                        if IsControlJustPressed(0, 38) then
                            inmenu2 = true
                            SetNuiFocus(true, false)
                            AllowSevenNotify2 = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            if PlayerData.job.grade == 0 then
                                infogardrobe = Config.Reange.Waffenschrank.Names.Kadett
                            elseif PlayerData.job.grade == 1 then
                                infogardrobe = Config.Reange.Waffenschrank.Names.RekrutOfficer
                            elseif PlayerData.job.grade == 2 then
                                infogardrobe = Config.Reange.Waffenschrank.Names.PoliceOfficer
                            elseif PlayerData.job.grade == 3 then
                                infogardrobe = Config.Reange.Waffenschrank.Names.Detective
                            elseif PlayerData.job.grade == 4 then
                                infogardrobe = Config.Reange.Waffenschrank.Names.Sergeant
                            elseif PlayerData.job.grade == 5 then
                                infogardrobe = Config.Reange.Waffenschrank.Names.Leutnant
                            elseif PlayerData.job.grade == 6 then
                                infogardrobe = Config.Reange.Waffenschrank.Names.Agent
                            elseif PlayerData.job.grade == 7 then
                                infogardrobe = Config.Reange.Waffenschrank.Names.Captain
                            elseif PlayerData.job.grade == 8 then
                                infogardrobe = Config.Reange.Waffenschrank.Names.Inspector
                            elseif PlayerData.job.grade == 9 then
                                infogardrobe = Config.Reange.Waffenschrank.Names.DeputyChief
                            elseif PlayerData.job.grade == 10 then
                                infogardrobe = Config.Reange.Waffenschrank.Names.AssistantChief
                            elseif PlayerData.job.grade == 11 then
                                infogardrobe = Config.Reange.Waffenschrank.Names.ChiefofDepartment
                            end
                            SendNUIMessage(
                                {
                                    type = "OpenWaffen",
                                    result = infogardrobe
                                }
                            )
                        end
                    end
                end
            else
                time2betweenchecking = 200
            end
        end
    end
)
local misoftime2 = 1000
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(misoftime2)
            if IsPlayerInPD and inoutservice then
                if inarea2 then
                    misoftime2 = 1
                    DrawMarker(
                        Config.MarkerType,
                        waffenschrankcoords,
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
                else
                    misoftime2 = 1000
                end
            else
                Citizen.Wait(2000)
            end
        end
    end
)

RegisterNUICallback(
    "ActionMake",
    function(data)
        local number = tonumber(data.action)
        SetNuiFocus(false, false)
        local ped = GetPlayerPed(-1)
        inmenu2 = false
        AllowSevenNotify2 = true
        inmarker2 = false
        if number == 1 then
            SetPedArmour(ped, 10000)
        elseif number == 2 then
            TriggerServerEvent("SevenLife:PD:GiveItem", "handschenllen")
        elseif number == 3 then
            TriggerServerEvent("SevenLife:PD:GiveItem", "gps")
        elseif number == 4 then
            TriggerServerEvent("SevenLife:PD:GiveWeapon", "WEAPON_STUNGUN")
        elseif number == 5 then
            TriggerServerEvent("SevenLife:PD:GiveWeapon", "WEAPON_PISTOL")
        elseif number == 6 then
            TriggerServerEvent("SevenLife:PD:GiveWeapon", "WEAPON_COMBATPDW")
        elseif number == 7 then
            TriggerServerEvent("SevenLife:PD:GiveItem", "munition19")
        elseif number == 8 then
            TriggerServerEvent("SevenLife:PD:GiveItem", "pdwmunition")
        end
    end
)

RegisterNetEvent("SevenLife:Weapon:AddMuniPDW")
AddEventHandler(
    "SevenLife:Weapon:AddMuniPDW",
    function()
        local ped = GetPlayerPed(-1)

        local weapon = GetSelectedPedWeapon(ped)
        if weapon ~= nil then
            if weapon == 171789620 then
                TriggerServerEvent("SevenLife:Weapon:GiveWeaponItem", "WEAPON_COMBATPDW", 30)
            else
                TriggerEvent(
                    "SevenLife:TimetCustom:Notify",
                    "Waffe",
                    "Diese Munition ist nicht für diese Waffe gemacht",
                    3000
                )
            end
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Waffe", "Du musst die Waffe in der Hand Halten", 3000)
        end
    end
)
