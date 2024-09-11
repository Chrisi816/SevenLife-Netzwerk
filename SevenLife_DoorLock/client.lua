ESX = nil
local havestarted = false
Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(250)
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(250)
        end

        ESX.PlayerData = ESX.GetPlayerData()

        ESX.TriggerServerCallback(
            "SevenLife:DoorLock:GetState",
            function(doorState)
                for index, state in pairs(doorState) do
                    SevenConfig.ListOfDoors[index].locked = state
                end
            end
        )
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(job)
        ESX.PlayerData.job = job
    end
)

RegisterNetEvent("SevenLife:DoorLock:setState")
AddEventHandler(
    "SevenLife:DoorLock:setState",
    function(index, state)
        SevenConfig.DoorList[index].locked = state
    end
)

Citizen.CreateThread(
    function()
        while true do
            local playerCoords = GetEntityCoords(PlayerPedId())

            for k, v in ipairs(SevenConfig.ListOfDoors) do
                v.isAuthorized = isAuthorized(v)

                if v.doors then
                    for k2, v2 in ipairs(v.doors) do
                        if v2.object and DoesEntityExist(v2.object) then
                            if k2 == 1 then
                                v.distanceToPlayer =
                                    GetDistanceBetweenCoords(playerCoords, GetEntityCoords(v2.object), true)
                            end

                            if
                                v.locked and v2.objHeading and
                                    ESX.Math.Round(GetEntityHeading(v2.object)) ~= v2.objHeading
                             then
                                SetEntityHeading(v2.object, v2.objHeading)
                            end
                        else
                            v.distanceToPlayer = nil
                            v2.object = GetClosestObjectOfType(v2.objCoords, 1.0, v2.objHash, false, false, false)
                        end
                    end
                else
                    if v.object and DoesEntityExist(v.object) then
                        v.distanceToPlayer = GetDistanceBetweenCoords(playerCoords, GetEntityCoords(v.object), true)

                        if v.locked and v.objHeading and ESX.Math.Round(GetEntityHeading(v.object)) ~= v.objHeading then
                            SetEntityHeading(v.object, v.objHeading)
                        end
                    else
                        v.distanceToPlayer = nil
                        v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
                    end
                end
            end

            Citizen.Wait(1000)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(4)
            local letSleep = true

            for k, v in ipairs(SevenConfig.ListOfDoors) do
                if v.distanceToPlayer and v.distanceToPlayer < 50 then
                    letSleep = false

                    if v.doors then
                        for k2, v2 in ipairs(v.doors) do
                            FreezeEntityPosition(v2.object, v.locked)
                        end
                    else
                        FreezeEntityPosition(v.object, v.locked)
                    end
                end

                if v.distanceToPlayer and v.distanceToPlayer < v.maxDistance then
                    if IsControlJustPressed(0, 38) then
                        if v.isAuthorized then
                            v.locked = not v.locked

                            if v.locked then
                                TriggerEvent("SevenLife:TimetCustom:Notify", "Tür", "Tür erfolgreich geöffnet!", 2000)
                            else
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Tür",
                                    "Tür erfolgreich geschlossen!",
                                    2000
                                )
                            end

                            TriggerServerEvent("SevenLife:DoorLock:UpdateState", k, v.locked)
                        end
                    end
                end
            end

            if letSleep then
                Citizen.Wait(500)
            end
        end
    end
)

function isAuthorized(door)
    if not ESX or not ESX.PlayerData.job then
        return false
    end

    for k, job in pairs(door.authorizedJobs) do
        if job == ESX.PlayerData.job.name then
            return true
        end
    end

    return false
end

-- Staatsbank

RegisterNetEvent("SevenLife:Doorlock:OpenApp")
AddEventHandler(
    "SevenLife:Doorlock:OpenApp",
    function()
        local pos = GetEntityCoords(GetPlayerPed(-1))
        for k, v in pairs(SevenConfig.ListOfDoors) do
            local dist =
                GetDistanceBetweenCoords(
                pos,
                SevenConfig.ListOfDoors[k].textCoords.x,
                SevenConfig.ListOfDoors[k].textCoords.y,
                SevenConfig.ListOfDoors[k].textCoords.z,
                true
            )
            if dist < 1.5 then
                if SevenConfig.ListOfDoors[k].carduseable then
                    if SevenConfig.ListOfDoors[k].locked then
                        cDk, cDv = k, v
                        RequestAnimDict("mp_arresting")
                        while (not HasAnimDictLoaded("mp_arresting")) do
                            Citizen.Wait(0)
                        end
                        TaskPlayAnim(
                            GetPlayerPed(-1),
                            "mp_arresting",
                            "a_uncuff",
                            8.0,
                            -8.0,
                            10000,
                            1,
                            0,
                            false,
                            false,
                            false
                        )
                        local PedCoords = GetEntityCoords(GetPlayerPed(-1))
                        propcards =
                            CreateObject(
                            GetHashKey("prop_cs_r_business_card"),
                            PedCoords.x,
                            PedCoords.y,
                            PedCoords.z,
                            true,
                            true,
                            true
                        )
                        AttachEntityToEntity(
                            propcards,
                            GetPlayerPed(-1),
                            GetPedBoneIndex(GetPlayerPed(-1), 0xDEAD),
                            0.1,
                            0.1,
                            0.0,
                            0.0,
                            10.0,
                            90.0,
                            false,
                            false,
                            false,
                            false,
                            2,
                            true
                        )
                        Citizen.Wait(10000)
                        ClearPedTasks(GetPlayerPed(-1))
                        SevenConfig.ListOfDoors[k].locked = not SevenConfig.ListOfDoors[k].locked
                        TriggerServerEvent("SevenLife:DoorLock:UpdateState", k, SevenConfig.ListOfDoors[k].locked)
                        DeleteObject(propcards)
                        if not havestarted then
                            havestarted = true
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Tür-Diebstahl",
                                "Die Polizei wurde gemeldet da du in das Archiv der Staatsbank eingebrochen bist",
                                2000
                            )
                            TriggerEvent("SevenLife:BankRaub:GiveArchive")
                            TriggerServerEvent("SevenLife:PD:MakeWarning", "Staatsbank")
                        end
                    end
                end
            end
        end
    end
)

RegisterNetEvent("SevenLife:Doorlock:StartHacking")
AddEventHandler(
    "SevenLife:Doorlock:StartHacking",
    function()
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        for k, v in pairs(SevenConfig.ListOfDoors) do
            local dist =
                GetDistanceBetweenCoords(
                pos,
                SevenConfig.ListOfDoors[k].textCoords.x,
                SevenConfig.ListOfDoors[k].textCoords.y,
                SevenConfig.ListOfDoors[k].textCoords.z
            )
            if dist < 1.5 then
                if SevenConfig.ListOfDoors[k].hackable then
                    if SevenConfig.ListOfDoors[k].locked then
                        cDk, cDv = k, v
                        local animDict = "anim@heists@ornate_bank@hack"

                        RequestAnimDict(animDict)
                        RequestModel("hei_prop_hst_laptop")

                        while not HasAnimDictLoaded(animDict) or not HasModelLoaded("hei_prop_hst_laptop") do
                            Citizen.Wait(100)
                        end

                        local ped = PlayerPedId()
                        local targetPosition, targetRotation =
                            (vector3(GetEntityCoords(ped))),
                            vector3(GetEntityRotation(ped))
                        local animPos =
                            GetAnimInitialOffsetPosition(
                            animDict,
                            "hack_enter",
                            SevenConfig.ListOfDoors[k].textCoords.x,
                            SevenConfig.ListOfDoors[k].textCoords.y,
                            SevenConfig.ListOfDoors[k].textCoords.z - 0.4,
                            253.34,
                            228.25,
                            101.39,
                            0,
                            2
                        )
                        local animPos2 =
                            GetAnimInitialOffsetPosition(
                            animDict,
                            "hack_loop",
                            SevenConfig.ListOfDoors[k].textCoords.x,
                            SevenConfig.ListOfDoors[k].textCoords.y,
                            SevenConfig.ListOfDoors[k].textCoords.z - 0.4,
                            253.34,
                            228.25,
                            101.39,
                            0,
                            2
                        )
                        local animPos3 =
                            GetAnimInitialOffsetPosition(
                            animDict,
                            "hack_exit",
                            SevenConfig.ListOfDoors[k].textCoords.x,
                            SevenConfig.ListOfDoors[k].textCoords.y,
                            SevenConfig.ListOfDoors[k].textCoords.z - 0.4,
                            253.34,
                            228.25,
                            101.39,
                            0,
                            2
                        )

                        FreezeEntityPosition(ped, true)
                        local netScene =
                            NetworkCreateSynchronisedScene(animPos, targetRotation, 2, false, false, 1065353216, 0, 1.3)
                        NetworkAddPedToSynchronisedScene(
                            ped,
                            netScene,
                            animDict,
                            "hack_enter",
                            1.5,
                            -4.0,
                            1,
                            16,
                            1148846080,
                            0
                        )
                        local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), targetPosition, 1, 1, 0)
                        NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "hack_enter_bag", 4.0, -8.0, 1)
                        local laptop = CreateObject(GetHashKey("hei_prop_hst_laptop"), targetPosition, 1, 1, 0)
                        NetworkAddEntityToSynchronisedScene(
                            laptop,
                            netScene,
                            animDict,
                            "hack_enter_laptop",
                            4.0,
                            -8.0,
                            1
                        )
                        local card = CreateObject(GetHashKey("hei_prop_heist_card_hack_02"), targetPosition, 1, 1, 0)
                        NetworkAddEntityToSynchronisedScene(card, netScene, animDict, "hack_enter_card", 4.0, -8.0, 1)

                        local netScene2 =
                            NetworkCreateSynchronisedScene(
                            animPos2,
                            targetRotation,
                            2,
                            false,
                            false,
                            1065353216,
                            0,
                            1.3
                        )
                        NetworkAddPedToSynchronisedScene(
                            ped,
                            netScene2,
                            animDict,
                            "hack_loop",
                            1.5,
                            -4.0,
                            1,
                            16,
                            1148846080,
                            0
                        )
                        NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "hack_loop_bag", 4.0, -8.0, 1)
                        NetworkAddEntityToSynchronisedScene(
                            laptop,
                            netScene2,
                            animDict,
                            "hack_loop_laptop",
                            4.0,
                            -8.0,
                            1
                        )
                        NetworkAddEntityToSynchronisedScene(card, netScene2, animDict, "hack_loop_card", 4.0, -8.0, 1)

                        local netScene3 =
                            NetworkCreateSynchronisedScene(
                            animPos3,
                            targetRotation,
                            2,
                            false,
                            false,
                            1065353216,
                            0,
                            1.3
                        )
                        NetworkAddPedToSynchronisedScene(
                            ped,
                            netScene3,
                            animDict,
                            "hack_exit",
                            1.5,
                            -4.0,
                            1,
                            16,
                            1148846080,
                            0
                        )
                        NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "hack_exit_bag", 4.0, -8.0, 1)
                        NetworkAddEntityToSynchronisedScene(
                            laptop,
                            netScene3,
                            animDict,
                            "hack_exit_laptop",
                            4.0,
                            -8.0,
                            1
                        )
                        NetworkAddEntityToSynchronisedScene(card, netScene3, animDict, "hack_exit_card", 4.0, -8.0, 1)

                        SetPedComponentVariation(ped, 5, 0, 0, 0)
                        SetEntityHeading(ped, 63.60)

                        NetworkStartSynchronisedScene(netScene)
                        Citizen.Wait(4500)
                        NetworkStopSynchronisedScene(netScene)

                        NetworkStartSynchronisedScene(netScene2)
                        Citizen.Wait(4500)
                        NetworkStopSynchronisedScene(netScene2)

                        NetworkStartSynchronisedScene(netScene3)
                        Citizen.Wait(4500)
                        NetworkStopSynchronisedScene(netScene3)

                        DeleteObject(laptop)
                        DeleteObject(bag)
                        DeleteObject(card)

                        FreezeEntityPosition(ped, false)
                        SetPedComponentVariation(ped, 5, 45, 0, 0)
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Tür", "Tür erfolgreich geöffnet", 2000)
                        SevenConfig.ListOfDoors[k].locked = not SevenConfig.ListOfDoors[k].locked
                        TriggerServerEvent("SevenLife:DoorLock:UpdateState", k, SevenConfig.ListOfDoors[k].locked)
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Tür", "Tür ist geöffnet", 2000)
                    end
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Tür", "Diese Tür kannst du nicht öffnen", 2000)
                end
            end
        end
    end
)

RegisterNetEvent("SevenLife:Doorlock:OpenDoor")
AddEventHandler(
    "SevenLife:Doorlock:OpenDoor",
    function(id)
        Citizen.CreateThread(
            function()
                for k, doorID in ipairs(SevenConfig.ListOfDoors) do
                    if doorID.id == id then
                        SevenConfig.ListOfDoors[k].locked = not SevenConfig.ListOfDoors[k].locked
                        TriggerServerEvent("SevenLife:DoorLock:UpdateState", k, SevenConfig.ListOfDoors[k].locked)
                        break
                    end
                end
            end
        )
    end
)

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function OpenDoorAnim(player)
    LoadAnimDict("anim@heists@keycard@")
    TaskPlayAnim(player, "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    SetTimeout(
        400,
        function()
            ClearPedTasks(player)
        end
    )
end
