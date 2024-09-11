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

local IsPlayerInMenu = false
local endxp

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if not IsPlayerInMenu then
                if IsControlJustPressed(0, 167) then
                    SetNuiFocus(true, true)
                    ESX.TriggerServerCallback(
                        "SevenLife:SkillSystem:GetDataLevel",
                        function(datalevel)
                            ESX.TriggerServerCallback(
                                "SevenLife:SkillSystem:GetData",
                                function(result1)
                                    for k, v in pairs(Config.levels) do
                                        if datalevel[1].level == v.level then
                                            endxp = v.xp
                                        end
                                    end
                                    SendNUIMessage(
                                        {
                                            type = "OpenSkillTree",
                                            level = datalevel,
                                            skillpoints = datalevel[1].skillpoints,
                                            xp = datalevel[1].xp,
                                            levels = datalevel[1].level,
                                            name = datalevel[1].name,
                                            endxp = endxp,
                                            obenbutton1 = result1[1].obenbutton1,
                                            obenobenbutton2 = result1[1].obenobenbutton2,
                                            obenrechtsbutton1 = result1[1].obenrechtsbutton1,
                                            obenrechtsbutton2 = result1[1].obenrechtsbutton2,
                                            obenlinksbutton1 = result1[1].obenlinksbutton1,
                                            obenlinksbutton2 = result1[1].obenlinksbutton2,
                                            rechtsuntenbutton1 = result1[1].rechtsuntenbutton1,
                                            rechtsuntenobenbutton1 = result1[1].rechtsuntenobenbutton1,
                                            rechtsuntenobenbutton2 = result1[1].rechtsuntenobenbutton2,
                                            rechtsuntenobenbutton3 = result1[1].rechtsuntenobenbutton3,
                                            rechtsuntenmittebutton1 = result1[1].rechtsuntenmittebutton1,
                                            rechtsuntenmittebutton2 = result1[1].rechtsuntenmittebutton2,
                                            rechtsuntenmittebutton3 = result1[1].rechtsuntenmittebutton3,
                                            rechtsuntenuntenbutton1 = result1[1].rechtsuntenuntenbutton1,
                                            rechtsuntenuntenbutton2 = result1[1].rechtsuntenuntenbutton2,
                                            linksuntenbutton1 = result1[1].linksuntenbutton1,
                                            linksuntenobenbutton1 = result1[1].linksuntenobenbutton1,
                                            linksuntenobenbutton2 = result1[1].linksuntenobenbutton2,
                                            linksuntenobenbutton3 = result1[1].linksuntenobenbutton3,
                                            linksuntenmittebutton1 = result1[1].linksuntenmittebutton1,
                                            linksuntenmittebutton2 = result1[1].linksuntenmittebutton2,
                                            linksuntenmittebutton3 = result1[1].linksuntenmittebutton3,
                                            linksuntenuntenbutton1 = result1[1].linksuntenuntenbutton1,
                                            linksuntenuntenbutton2 = result1[1].linksuntenuntenbutton2
                                        }
                                    )
                                end
                            )
                        end
                    )
                end
            else
                Citizen.Wait(500)
            end
        end
    end
)

RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
        IsPlayerInMenu = false
    end
)

RegisterNUICallback(
    "DotMenu",
    function(data)
        if data.dot == 1 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "obenbutton1")
        elseif data.dot == 2 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "linksuntenbutton1")
        elseif data.dot == 3 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "rechtsuntenbutton1")
        elseif data.dot == 11 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "obenobenbutton2")
        elseif data.dot == 12 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "obenrechtsbutton1")
        elseif data.dot == 13 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "obenlinksbutton1")
        elseif data.dot == 14 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "obenlinksbutton2")
        elseif data.dot == 15 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "obenrechtsbutton2")
        elseif data.dot == 21 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "linksuntenuntenbutton1")
        elseif data.dot == 22 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "linksuntenmittebutton1")
        elseif data.dot == 23 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "linksuntenobenbutton1")
        elseif data.dot == 24 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "linksuntenobenbutton2")
        elseif data.dot == 25 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "linksuntenmittebutton2")
        elseif data.dot == 26 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "linksuntenmittebutton3")
        elseif data.dot == 27 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "linksuntenuntenbutton2")
        elseif data.dot == 31 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "rechtsuntenuntenbutton1")
        elseif data.dot == 32 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "rechtsuntenmittebutton1")
        elseif data.dot == 33 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "rechtsuntenobenbutton1")
        elseif data.dot == 34 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "rechtsuntenobenbutton3")
        elseif data.dot == 35 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "rechtsuntenobenbutton2")
        elseif data.dot == 36 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "rechtsuntenmittebutton2")
        elseif data.dot == 37 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "rechtsuntenmittebutton3")
        elseif data.dot == 38 then
            TriggerServerEvent("SevenLife:SkillSystem:AllowDots", "rechtsuntenuntenbutton2")
        end
    end
)

RegisterNetEvent("SevenLife:SkillTree:CloseMenu")
AddEventHandler(
    "SevenLife:SkillTree:CloseMenu",
    function()
        SetNuiFocus(false, false)
        IsPlayerInMenu = false
        SendNUIMessage(
            {
                type = "CloseMenu"
            }
        )
    end
)

RegisterNetEvent("SevenLife:SkillTree:MakeLevelUpShowing")
AddEventHandler(
    "SevenLife:SkillTree:MakeLevelUpShowing",
    function(newlevel)
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
        SendNUIMessage(
            {
                type = "levelup",
                newlevel = newlevel
            }
        )
    end
)
