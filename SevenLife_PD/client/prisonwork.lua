coordsofmarker = vector3(Config.WorkingPackStation.x, Config.WorkingPackStation.y, Config.WorkingPackStation.z)

inmenu6 = false
local time2 = 200
local time2betweenchecking = 200
AllowSevenNotify6 = true
inarea6 = false
inmarker6 = false
local time3 = 200
local CanLeaveBox = false
local jobstarted = false
local TimeLeft = 0
local canprocess = false

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
        BlipGefeangnisPacken()
        BlipGefeangnisPackenabgeben()
    end
)

-- Local Start
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time2)

            local ped = GetPlayerPed(-1)
            local coordofped = GetEntityCoords(ped)
            local distance =
                GetDistanceBetweenCoords(
                coordofped,
                Config.WorkingPackStation.x,
                Config.WorkingPackStation.y,
                Config.WorkingPackStation.z,
                true
            )
            if distance < 20 then
                time2 = 110
                inarea6 = true
                if distance < 2 then
                    if AllowSevenNotify6 then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um die Pakete zu packen ",
                            "System-Nachricht",
                            true
                        )
                    end
                    inmarker6 = true
                else
                    if distance >= 2.1 and distance <= 3 then
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
        while true do
            local ped = GetPlayerPed(-1)
            Citizen.Wait(time2betweenchecking)
            if inarea6 then
                time2betweenchecking = 5

                if inmarker6 then
                    if IsControlJustPressed(0, 38) then
                        if not inmenu6 then
                            inmenu6 = true
                            AllowSevenNotify6 = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            TriggerEvent("SevenLife:Gefeangnis:StartJobPostal")
                        else
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Gefängnis", "Du hast schon ein Packet", 2000)
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

            if inarea6 then
                misoftime2 = 1
                DrawMarker(
                    Config.MarkerType,
                    coordsofmarker,
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
        end
    end
)
local HashKeyBox = GetHashKey("prop_paper_box_02")
RegisterNetEvent("SevenLife:Gefeangnis:StartJobPostal")
AddEventHandler(
    "SevenLife:Gefeangnis:StartJobPostal",
    function()
        jobstarted = true
        local pP = PlayerPedId()
        LoadModel("prop_cs_cardbox_01")
        local SpawnObject = CreateObject(GetHashKey("prop_paper_box_01"), 1689.65, 2552.03, 44.56, true, false)
        PlaceObjectOnGroundProperly(SpawnObject)
        TaskStartScenarioInPlace(pP, "PROP_HUMAN_BUM_BIN", 0, false)
        SetEntityHeading(pP, 43.43)

        Citizen.CreateThread(
            function()
                while not CanLeaveBox do
                    Citizen.Wait(10)
                    if not IsPedUsingScenario(pP, "PROP_HUMAN_BUM_BIN") and not CanLeaveBox then
                        DeleteEntity(SpawnObject)

                        TriggerEvent("SevenLife:TimetCustom:Notify", "Gefängnis", "Verpacken abgebrochen", 2000)

                        jobstarted = false
                        canprocess = false
                    end
                end
                canprocess = true
            end
        )
        Citizen.Wait(19000)
        CanLeaveBox = true
        Citizen.Wait(1000)
        AllowSevenNotify6 = true
        if canprocess then
            TriggerEvent("SevenLife:TimetCustom:Notify", "Gefängnis", "Box erfolgreich gepackt", 2000)
            ClearPedTasksImmediately(pP)
            ClearPedSecondaryTask(pP)
            DeleteEntity(SpawnObject)
            LoadModel("prop_paper_box_02")

            local x, y, z = table.unpack(GetEntityCoords(pP))
            local HoldObjekt =
                CreateObject(GetHashKey("prop_paper_box_02"), x + 5.5, y + 5.5, z + 0.2, true, true, true)
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

            repeat
                Citizen.Wait(1000)
                if CanLeaveBox == false then
                    DeleteEntity(HoldObjekt)
                    ClearPedTasksImmediately(pP)
                end
            until (CanLeaveBox == false)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            local ped = GetHashKey("a_f_m_bevhills_01")
            Citizen.Wait(500)

            pedarea = true
            if not pedloaded then
                RequestModel(ped)
                while not HasModelLoaded(ped) do
                    Citizen.Wait(1)
                end
                ped6 =
                    CreatePed(
                    4,
                    ped,
                    Config.Endstation.x,
                    Config.Endstation.y,
                    Config.Endstation.z,
                    Config.Endstation.heading,
                    false,
                    true
                )
                SetEntityInvincible(ped6, true)
                FreezeEntityPosition(ped6, true)
                SetBlockingOfNonTemporaryEvents(ped6, true)
                TaskPlayAnim(ped6, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                pedloaded = true
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time3)
            local ped = GetPlayerPed(-1)
            local coordofped = GetEntityCoords(ped)
            local distance =
                GetDistanceBetweenCoords(
                coordofped,
                Config.Endstation.x,
                Config.Endstation.y,
                Config.Endstation.z,
                true
            )

            if jobstarted then
                if distance < 20 then
                    time3 = 110
                    inarea7 = true
                    if distance < 2 then
                        if AllowSevenNotify6 then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke E um die Pakete abzugeben",
                                "System-Nachricht",
                                true
                            )
                        end
                        inmarker7 = true
                    else
                        if distance >= 2.1 and distance <= 3 then
                            TriggerEvent("sevenliferp:closenotify", false)
                            inmarker7 = false
                        end
                    end
                else
                    inarea7 = false
                    time3 = 200
                end
            end
        end
    end
)

-- KeyCheck
Citizen.CreateThread(
    function()
        while true do
            local ped = PlayerPedId()
            Citizen.Wait(time3betweenchecking)
            if jobstarted then
                if inarea7 then
                    time3betweenchecking = 5

                    if inmarker7 and not inmenu7 then
                        if IsControlJustPressed(0, 38) then
                            inmenu7 = true

                            AllowSevenNotify6 = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            TriggerServerEvent("SevenLife:Gefeangnis:PayToPlayer")
                            jobstarted = false
                            CanLeaveBox = false
                            inmenu7 = false
                            AllowSevenNotify6 = true
                            inmenu6 = false
                        end
                    end
                else
                    time3betweenchecking = 200
                end
            end
        end
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

function BlipGefeangnisPacken()
    local blips = vector3(Config.WorkingPackStation.x, Config.WorkingPackStation.y, Config.WorkingPackStation.z)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 237)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 9)
    SetBlipScale(blip1, 0.9)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Packet packen")
    EndTextCommandSetBlipName(blip1)
end
function BlipGefeangnisPackenabgeben()
    local blips = vector3(Config.Endstation.x, Config.Endstation.y, Config.Endstation.z)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 479)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 9)
    SetBlipScale(blip1, 0.9)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Packet abgeben")
    EndTextCommandSetBlipName(blip1)
end
