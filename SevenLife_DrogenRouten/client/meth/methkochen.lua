--------------------------------------------------------------------------------------------------------------
--------------------------------------------Variables--------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local area = false
local time = 2000
local timemain = 200
local inmarker = false
local Stage = 1
local Started = false
local activenotify = true
Abbrechen = false
local endone = true
local inmenu = false
local endone2 = true
local CanLeaveBox = false
local jobstarted = false

local canprocess = false

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
        while true do
            Citizen.Wait(timemain)
            local coords = GetEntityCoords(GetPlayerPed(-1))
            local distance =
                GetDistanceBetweenCoords(coords, Config.Meth.Kochen.x, Config.Meth.Kochen.y, Config.Meth.Kochen.z, true)
            if distance < 15 then
                area = true
                timemain = 15
                if distance < 1.1 then
                    inmarker = true
                    if activenotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um Meth herzustellen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.1 and distance <= 2 then
                        inmarker = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                Citizen.Wait(200)
                area = false
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    TriggerEvent("sevenliferp:closenotify", false)
                    activenotify = false
                    if not Started then
                        Started = true
                        TriggerEvent("SevenLife:Drogen:GetChemicals", 1)
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Meth", "Gehe und holle die Chemikalien", 2000)
                    end
                end
            else
                Citizen.Wait(150)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time)
            if area and not inmenu then
                time = 1
                DrawMarker(
                    1,
                    Config.Meth.Kochen.x,
                    Config.Meth.Kochen.y,
                    Config.Meth.Kochen.z,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.8,
                    0.8,
                    0.8,
                    236,
                    80,
                    80,
                    155,
                    false,
                    false,
                    2,
                    false,
                    0,
                    0,
                    0,
                    0
                )
            else
                time = 2000
            end
        end
    end
)
local inmenu6 = false
local time2 = 200
local time2betweenchecking = 200
local AllowSevenNotify6 = true
local inarea6 = false
local inmarker6 = false

RegisterNetEvent("SevenLife:Drogen:GetChemicals")
AddEventHandler(
    "SevenLife:Drogen:GetChemicals",
    function(Stage)
        local ped = GetPlayerPed(-1)
        if Stage == 1 then
            Citizen.CreateThread(
                function()
                    while endone do
                        Citizen.Wait(time2)

                        local ped = GetPlayerPed(-1)
                        local coordofped = GetEntityCoords(ped)
                        local distance =
                            GetDistanceBetweenCoords(
                            coordofped,
                            Config.Meth.Chemikalien.x,
                            Config.Meth.Chemikalien.y,
                            Config.Meth.Chemikalien.z,
                            true
                        )
                        if distance < 20 then
                            time2 = 110
                            inarea6 = true
                            if distance < 1.1 then
                                if AllowSevenNotify6 then
                                    TriggerEvent(
                                        "sevenliferp:startnui",
                                        "Drücke E um die Chemicalien zu nehmen ",
                                        "System-Nachricht",
                                        true
                                    )
                                end
                                inmarker6 = true
                            else
                                if distance >= 1.1 and distance <= 2.5 then
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    inmarker6 = false
                                end
                            end
                        else
                            inarea6 = false
                            time2 = 200
                        end
                    end
                end
            )

            -- KeyCheck
            Citizen.CreateThread(
                function()
                    while endone do
                        Citizen.Wait(time2betweenchecking)
                        if inarea6 then
                            time2betweenchecking = 5

                            if inmarker6 then
                                if IsControlJustPressed(0, 38) then
                                    if not inmenu6 then
                                        AllowSevenNotify6 = false

                                        TriggerEvent("sevenliferp:closenotify", false)

                                        endone = false
                                        inmenu6 = true

                                        TriggerEvent("SevenLife:Meth:StartJobMeth")
                                        Citizen.Wait(100)
                                    else
                                        TriggerEvent(
                                            "SevenLife:TimetCustom:Notify",
                                            "Gefängnis",
                                            "Du hast schon ein Packet",
                                            2000
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
                    while endone do
                        Citizen.Wait(misoftime2)

                        if inarea6 then
                            misoftime2 = 1
                            DrawMarker(
                                Config.MarkerType,
                                Config.Meth.Chemikalien.x,
                                Config.Meth.Chemikalien.y,
                                Config.Meth.Chemikalien.z,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0.8,
                                0.8,
                                0.8,
                                236,
                                80,
                                80,
                                155,
                                false,
                                false,
                                2,
                                false,
                                0,
                                0,
                                0,
                                0
                            )
                        else
                            misoftime2 = 1000
                        end
                    end
                end
            )
        end
        if Stage == 2 then
            Citizen.CreateThread(
                function()
                    while endone2 do
                        Citizen.Wait(time2)

                        local ped = GetPlayerPed(-1)
                        local coordofped = GetEntityCoords(ped)
                        local distance =
                            GetDistanceBetweenCoords(
                            coordofped,
                            Config.Meth.Kochen.x,
                            Config.Meth.Kochen.y,
                            Config.Meth.Kochen.z,
                            true
                        )
                        if distance < 20 then
                            time2 = 110
                            inarea6 = true
                            if distance < 1.1 then
                                if AllowSevenNotify6 then
                                    TriggerEvent(
                                        "sevenliferp:startnui",
                                        "Drücke E um die Chemikalien hinzulegen ",
                                        "System-Nachricht",
                                        true
                                    )
                                end
                                inmarker6 = true
                            else
                                if distance >= 1.1 and distance <= 2.5 then
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    inmarker6 = false
                                end
                            end
                        else
                            inarea6 = false
                            time2 = 200
                        end
                    end
                end
            )

            -- KeyCheck
            Citizen.CreateThread(
                function()
                    while endone2 do
                        local ped = GetPlayerPed(-1)
                        Citizen.Wait(time2betweenchecking)
                        if inarea6 then
                            time2betweenchecking = 5

                            if inmarker6 then
                                if IsControlJustPressed(0, 38) then
                                    endone2 = false
                                    inmenu6 = true
                                    jobstarted = false
                                    CanLeaveBox = false
                                    AllowSevenNotify6 = false
                                    DeleteEntity(HoldObjekt)
                                    ClearPedTasksImmediately(ped)
                                    endone2 = false
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    Citizen.Wait(100)
                                    TriggerEvent("SevenLife:Drogen:GetChemicals", 3)
                                end
                            end
                        else
                            time2betweenchecking = 200
                        end
                    end
                end
            )
        end
        if Stage == 3 then
            endone2 = false

            SendNUIMessage(
                {
                    type = "OpenBarDrogen"
                }
            )

            RequestAnimDict("amb@prop_human_bum_bin@idle_b")
            while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
                Citizen.Wait(10)
            end
            TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 2.0, -2.0, -1, 49, 0, true, false, true)

            Citizen.Wait(11000)
            ClearPedTasksImmediately(ped)
            TriggerEvent("SevenLife:Drogen:GetChemicals", 4)
            local random = math.random(1, 10)
            if random >= 8 then
                ApplyDamageToPed(ped, 10, false)
                TriggerEvent("SevenLife:TimetCustom:Notify", "Meth", "Du hast dich verbrannt", 2000)
            end
        end
        if Stage == 4 then
            TriggerServerEvent("SevenLife:Meth:GetItems")
            area = false
            time = 2000
            timemain = 100
            inmarker = false
            Stage = 1
            Started = false
            activenotify = true
            AllowSevenNotify6 = true
            Abbrechen = false
            endone = true
            inmenu = false
            endone2 = true
            CanLeaveBox = false
            jobstarted = false
            inmenu6 = false
        end
    end
)
RegisterNetEvent("SevenLife:Meth:StartJobMeth")
AddEventHandler(
    "SevenLife:Meth:StartJobMeth",
    function()
        endone = false
        jobstarted = true
        local pP = PlayerPedId()

        TriggerEvent("SevenLife:TimetCustom:Notify", "Meth", "Box erfolgreich gepackt", 2000)

        ClearPedTasksImmediately(pP)
        ClearPedSecondaryTask(pP)

        LoadModel("prop_paper_box_02")
        CanLeaveBox = true
        local x, y, z = table.unpack(GetEntityCoords(pP))
        HoldObjekt = CreateObject(GetHashKey("prop_paper_box_02"), x + 5.5, y + 5.5, z + 0.2, true, true, true)
        FreezeEntityPosition(pP, false)
        AttachEntityToEntity(
            HoldObjekt,
            pP,
            GetPedBoneIndex(pP, 11816),
            -0.2,
            0.38,
            0.001,
            10.0,
            285.0,
            270.0,
            true,
            true,
            false,
            true,
            1,
            true
        )

        ClearPedTasks(pP)

        LoadAnim("anim@heists@box_carry@")

        Citizen.CreateThread(
            function()
                while jobstarted do
                    Citizen.Wait(10)
                    if not IsEntityPlayingAnim(pP, "anim@heists@box_carry@", "idle", 3) then
                        TaskPlayAnim(pP, "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
                    end
                end
            end
        )
        TriggerEvent("SevenLife:Drogen:GetChemicals", 2)
        Citizen.Wait(2000)
        AllowSevenNotify6 = true
        TriggerEvent("sevenliferp:closenotify", false)
        repeat
            Citizen.Wait(100)
            if CanLeaveBox == false then
                DeleteEntity(HoldObjekt)
                ClearPedTasksImmediately(pP)
            end
        until (CanLeaveBox == false)
    end
)
function LoadAnim(animDict)
    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
end

function LoadModel(model)
    RequestModel(model)

    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end
end
