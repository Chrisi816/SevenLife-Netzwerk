-- Variables

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
            Citizen.Wait(1)
        end
    end
)

-- Check in which Part of Los Santos he is
local incity
local inmiddle
local upper
local states
local elses
Citizen.CreateThread(
    function()
        Citizen.Wait(5000)
        while true do
            Citizen.Wait(3000)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distancebetweencoordscity =
                GetDistanceBetweenCoords(
                coords,
                SevenLifeEnergy.MiddleOfCity.x,
                SevenLifeEnergy.MiddleOfCity.y,
                SevenLifeEnergy.MiddleOfCity.z,
                false
            )
            local distancebetweencoordsmiddle =
                GetDistanceBetweenCoords(
                coords,
                SevenLifeEnergy.MiddleofMap.x,
                SevenLifeEnergy.MiddleofMap.y,
                SevenLifeEnergy.MiddleofMap.z,
                false
            )
            local distancebetweenupper =
                GetDistanceBetweenCoords(
                coords,
                SevenLifeEnergy.UpperMap.x,
                SevenLifeEnergy.UpperMap.y,
                SevenLifeEnergy.UpperMap.z,
                false
            )

            if distancebetweencoordscity < 3000 then
                incity = true
                inmiddle = false
                upper = false
                elses = false
                if states == 1 then
                    SetArtificialLightsState(true)
                else
                    SetArtificialLightsState(false)
                end
            else
                if distancebetweencoordsmiddle < 1600 then
                    inmiddle = true
                    incity = false
                    upper = false
                    elses = false
                    if states == 2 then
                        SetArtificialLightsState(true)
                    else
                        SetArtificialLightsState(false)
                    end
                else
                    if distancebetweenupper < 1600 then
                        upper = true
                        inmiddle = false
                        incity = false
                        elses = false
                        if states == 3 then
                            SetArtificialLightsState(true)
                        else
                            SetArtificialLightsState(false)
                        end
                    else
                        elses = true
                        upper = false
                        SetArtificialLightsState(false)
                        inmiddle = false
                        incity = false
                        if states == 4 then
                            SetArtificialLightsState(true)
                        else
                            SetArtificialLightsState(false)
                        end
                    end
                end
            end
        end
    end
)

--- Check Locations BlackOut upper
local firstplanted = false
local secontplanted = false
local inmarker
local plantedbombs = 0
onlyonce = false

Citizen.CreateThread(
    function()
        Citizen.Wait(2000)
        local time = 120
        local triggeronlyonemarker = false
        while true do
            player = GetPlayerPed(-1)
            Citizen.Wait(time)
            local coord = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(
                coord,
                SevenLifeEnergy.location.firstdestroyerupper.x,
                SevenLifeEnergy.location.firstdestroyerupper.y,
                SevenLifeEnergy.location.firstdestroyerupper.z,
                true
            )
            if distance < 20 then
                time = 20
                activemarker = true
                if triggeronlyonemarker == false then
                    MakeMarker(
                        true,
                        SevenLifeEnergy.location.firstdestroyerupper.x,
                        SevenLifeEnergy.location.firstdestroyerupper.y,
                        SevenLifeEnergy.location.firstdestroyerupper.z
                    )
                    triggeronlyonemarker = true
                end
                if distance < 2 then
                    inmarker = true
                    if not onlyonce then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um das kleine c4 anzubringen",
                            "System - Nachricht",
                            true
                        )
                        onlyonce = true
                    end
                else
                    if distance >= 2.1 and distance <= 3 then
                        inmarker = false
                        onlyonce = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                if distance > 20 then
                    time = 120
                    triggeronlyonemarker = false
                    MakeMarker(false)
                end
            end
        end
    end
)

function MakeMarker(active, x, y, z)
    Citizen.CreateThread(
        function()
            active = active
            while active do
                Citizen.Wait(1)
                DrawMarker(
                    1,
                    x,
                    y,
                    z,
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
            end
        end
    )
end
local recentlydone = false
Citizen.CreateThread(
    function()
        local times = 100
        while true do
            Citizen.Wait(times)

            if not firstplanted then
                if inmarker then
                    times = 10
                    if IsControlJustPressed(0, 38) then
                        if not recentlydone then
                            times = 200
                            TriggerEvent("sevenliferp:closenotify", false)
                            ESX.TriggerServerCallback(
                                "SevenLife:Energy:CheckIfHaveItem",
                                function(haveitem)
                                    if haveitem then
                                        firstplanted = true
                                        plantedbombs = 1
                                        TriggerServerEvent("SevenLife:Energy:RemoveItem", "smallc4")
                                        PlantBomb()
                                        active = false
                                        Citizen.Wait(10000)
                                        AddExplosion(
                                            SevenLifeEnergy.location.firstdestroyerupper.x + 0.75,
                                            SevenLifeEnergy.location.firstdestroyerupper.y + 0.75,
                                            SevenLifeEnergy.location.firstdestroyerupper.z + 1,
                                            33,
                                            1.0,
                                            true,
                                            false,
                                            1.0,
                                            true
                                        )
                                        AddExplosion(
                                            SevenLifeEnergy.location.firstdestroyerupper.x + 1,
                                            SevenLifeEnergy.location.firstdestroyerupper.y + 1,
                                            SevenLifeEnergy.location.firstdestroyerupper.z + 1,
                                            33,
                                            1.0,
                                            true,
                                            false,
                                            1.0,
                                            true
                                        )
                                        AddExplosion(1339.95, 6380.59, 33.41, 33, 1.0, true, false, 1.0, true)
                                        AddExplosion(1339.95, 6380.59, 33.41, 33, 1.0, true, false, 1.0, true)
                                        AddExplosion(1343.95, 6382.59, 33.41, 33, 1.0, true, false, 1.0, true)
                                        TriggerServerEvent("SevenLife:Energy:BlackOut", true, 3)
                                        plantedbombs = 0
                                        recentlydone = true
                                        firstplanted = false
                                        Citizen.SetTimeout(
                                            60000 * 10,
                                            function()
                                                recentlydone = false
                                            end
                                        )
                                    else
                                        TriggerEvent(
                                            "SevenLife:TimetCustom:Notify",
                                            "BlackOut",
                                            "Du hast zu wenig vom kleinem C4",
                                            2000
                                        )
                                        onlyonce = false
                                    end
                                end,
                                "smallc4"
                            )
                        else
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "BlackOut",
                                "BlackOut wurde vor kurzer Zeit ausgelöst",
                                2000
                            )
                        end
                    end
                else
                    time = 100
                end
            end
        end
    end
)

function MakeShortNotify(msg, duration)
    TriggerEvent("sevenliferp:startnui", msg, "System - Nachricht", true)
    Citizen.Wait(duration)
    TriggerEvent("sevenliferp:closenotify", false)
end

function PlantBomb()
    if plantedbombs == 1 then
        loc =
            vector3(
            SevenLifeEnergy.location.firstdestroyerupper.x + 0.75,
            SevenLifeEnergy.location.firstdestroyerupper.y + 0.75,
            SevenLifeEnergy.location.firstdestroyerupper.z + 1
        )
        heading = 3.67
    end
    if plantedbombse == 1 then
        loc =
            vector3(
            SevenLifeEnergy.location.middlemap1.x - 0.45,
            SevenLifeEnergy.location.middlemap1.y - 0.45,
            SevenLifeEnergy.location.middlemap1.z
        )
        heading = SevenLifeEnergy.location.middlemap1.heading
    end
    if plantedbombse == 2 then
        loc =
            vector3(
            SevenLifeEnergy.location.middlemap2.x - 0.45,
            SevenLifeEnergy.location.middlemap2.y - 0.45,
            SevenLifeEnergy.location.middlemap2.z
        )
        heading = SevenLifeEnergy.location.middlemap2.heading
    end
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestModel("prop_bomb_01")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and
        not HasModelLoaded("hei_p_m_bag_var22_arm_s") and
        not HasModelLoaded("prop_bomb_01") do
        Citizen.Wait(50)
    end
    local ped = PlayerPedId()
    SetEntityHeading(ped, heading)
    Citizen.Wait(100)
    local rot = vec3(GetEntityRotation(ped))
    local bagscene =
        NetworkCreateSynchronisedScene(loc.x - 0.70, loc.y + 0.50, loc.z, rot, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), loc.x, loc.y, loc.z, true, true, false)

    NetworkAddPedToSynchronisedScene(
        ped,
        bagscene,
        "anim@heists@ornate_bank@thermal_charge",
        "thermal_charge",
        1.5,
        -4.0,
        1,
        16,
        1148846080,
        0
    )
    NetworkAddEntityToSynchronisedScene(
        bag,
        bagscene,
        "anim@heists@ornate_bank@thermal_charge",
        "bag_thermal_charge",
        4.0,
        -8.0,
        1
    )
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bomba = CreateObject(GetHashKey("prop_bomb_01"), x, y, z + 0.2, true, true, true)

    AttachEntityToEntity(
        bomba,
        ped,
        GetPedBoneIndex(ped, 28422),
        0,
        0,
        0,
        0,
        0,
        200.0,
        true,
        true,
        false,
        true,
        1,
        true
    )
    Citizen.Wait(3000)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)
    NetworkStopSynchronisedScene(bagscene)
end

RegisterNetEvent("SevenLife:Energy:SyncBlackOut")
AddEventHandler(
    "SevenLife:Energy:SyncBlackOut",
    function(status, state)
        states = state
        if state == 1 then
            if incity then
                SetArtificialLightsState(status)
            end
        else
            if state == 2 then
                if inmiddle then
                    SetArtificialLightsState(status)
                end
            else
                if state == 3 then
                    if upper then
                        SetArtificialLightsState(status)
                    end
                else
                    SetArtificialLightsState(false)
                end
            end
        end
    end
)

--- Second
local firstplanted = false
local secontplanted = false
local inmarker
plantedbombse = 0
onlyonce = false
Citizen.CreateThread(
    function()
        Citizen.Wait(2000)
        local time = 120

        local triggeronlyonemarker = false
        while true do
            player = GetPlayerPed(-1)
            Citizen.Wait(time)
            local coord = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(
                coord,
                SevenLifeEnergy.location.middlemap1.x,
                SevenLifeEnergy.location.middlemap1.y,
                SevenLifeEnergy.location.middlemap1.z,
                true
            )
            if distance < 20 then
                time = 20
                activemarker = true
                if triggeronlyonemarker == false then
                    MakeMarker(
                        true,
                        SevenLifeEnergy.location.middlemap1.x,
                        SevenLifeEnergy.location.middlemap1.y,
                        SevenLifeEnergy.location.middlemap1.z - 1
                    )
                    triggeronlyonemarker = true
                end
                if distance < 2 then
                    inmarker = true
                    if not onlyonce then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um das mittlere c4 anzubringen",
                            "System - Nachricht",
                            true
                        )
                        onlyonce = true
                    end
                else
                    if distance >= 2.1 and distance <= 3 then
                        inmarker = false
                        onlyonce = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                if distance > 20 then
                    time = 120
                    triggeronlyonemarker = false
                    MakeMarker(false)
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        local times = 100
        while true do
            Citizen.Wait(times)
            if not firstplanted then
                if inmarker then
                    times = 10
                    if IsControlJustPressed(0, 38) then
                        times = 200
                        TriggerEvent("sevenliferp:closenotify", false)
                        ESX.TriggerServerCallback(
                            "SevenLife:Energy:CheckIfHaveItem",
                            function(haveitem)
                                if haveitem then
                                    firstplanted = true
                                    plantedbombse = 1
                                    TriggerServerEvent("SevenLife:Energy:RemoveItem", "middlec4")
                                    PlantBomb()
                                    active = false
                                    TriggerEvent("SevenLife:Energy:SecondStep:CheckDistance")
                                    TriggerEvent("SevenLife:Energy:SecondStep:CheckKey")
                                    TriggerEvent(
                                        "sevenliferp:startnui",
                                        "Suche die nächste Stelle",
                                        "System - Nachricht",
                                        true
                                    )
                                    Citizen.Wait(2000)
                                    TriggerEvent("sevenliferp:closenotify", false)
                                else
                                    MakeShortNotify("Du hast zu wenig C4", 2000)
                                    onlyonce = false
                                end
                            end,
                            "middlec4"
                        )
                    end
                else
                    time = 100
                end
            end
        end
    end
)
RegisterNetEvent("SevenLife:Energy:SecondStep:CheckDistance")
AddEventHandler(
    "SevenLife:Energy:SecondStep:CheckDistance",
    function()
        inprogress = true
        MakeMarker(
            true,
            SevenLifeEnergy.location.middlemap2.x,
            SevenLifeEnergy.location.middlemap2.y,
            SevenLifeEnergy.location.middlemap2.z - 1
        )

        while true do
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)
            local distance =
                GetDistanceBetweenCoords(
                coords,
                SevenLifeEnergy.location.middlemap2.x,
                SevenLifeEnergy.location.middlemap2.y,
                SevenLifeEnergy.location.middlemap2.z,
                true
            )
            Citizen.Wait(25)
            if distance < 2 then
                inprogress = true
                if inprogress then
                    TriggerEvent(
                        "sevenliferp:startnui",
                        "Drücke <span1 color = white>E</span1> um das mittlere c4 anzubringen",
                        "System - Nachricht",
                        true
                    )
                end

                inmarkers = true
            else
                if distance >= 2.1 and distance <= 3 then
                    inmarkers = false
                    inprogress = false
                    TriggerEvent("sevenliferp:closenotify", false)
                end
            end
        end
    end
)

RegisterNetEvent("SevenLife:Energy:SecondStep:CheckKey")
AddEventHandler(
    "SevenLife:Energy:SecondStep:CheckKey",
    function()
        Citizen.CreateThread(
            function()
                local times = 100
                while true do
                    Citizen.Wait(times)
                    if inmarkers then
                        times = 10
                        if IsControlJustPressed(0, 38) then
                            times = 200
                            TriggerEvent("sevenliferp:closenotify", false)
                            ESX.TriggerServerCallback(
                                "SevenLife:Energy:CheckIfHaveItem",
                                function(haveitem)
                                    if haveitem then
                                        firstplanted = true
                                        plantedbombse = 2
                                        inprogress = false
                                        TriggerServerEvent("SevenLife:Energy:RemoveItem", "middlec4")
                                        PlantBomb()
                                        active = false
                                        Citizen.Wait(10000)
                                        AddExplosion(
                                            SevenLifeEnergy.location.middlemap1.x,
                                            SevenLifeEnergy.location.middlemap1.y,
                                            SevenLifeEnergy.location.middlemap1.z,
                                            51,
                                            1.0,
                                            true,
                                            false,
                                            1.0,
                                            true
                                        )
                                        AddExplosion(
                                            SevenLifeEnergy.location.middlemap2.x,
                                            SevenLifeEnergy.location.middlemap2.y,
                                            SevenLifeEnergy.location.middlemap2.z,
                                            51,
                                            1.0,
                                            true,
                                            false,
                                            1.0,
                                            true
                                        )
                                        TriggerServerEvent("SevenLife:Energy:BlackOut", true, 2)
                                        plantedbombs = 0
                                    else
                                        MakeShortNotify("Du hast zu wenig C4", 2000)
                                        onlyonce = false
                                    end
                                end,
                                "middlec4"
                            )
                        end
                    else
                        time = 100
                    end
                end
            end
        )
    end
)
RegisterNetEvent("SevenLife:Energy:Activate")
AddEventHandler(
    "SevenLife:Energy:Activate",
    function()
        states = 5
        SetArtificialLightsState(false)
    end
)
