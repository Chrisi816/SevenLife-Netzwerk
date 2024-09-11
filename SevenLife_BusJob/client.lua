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

local activemission = false
local cars = 0
local beschwerden = 0
allownotifyforbus = true
indienst = false
buscar = nil
local busVehicle = nil
if Config.activebusline then
    Citizen.CreateThread(
        function()
            Localped()
            LocalBlip()
            while true do
                Citizen.Wait(1)
                local pos = vector3(Config.locations.npc.x, Config.locations.npc.y, Config.locations.npc.z)
                local difference =
                    GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vector3(pos.x, pos.y, pos.z), true)
                if difference < 1.5 then
                    if allownotifyforbus then
                        if indienst == false then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um in den Dienst zu gehen.",
                                "System-Nachricht",
                                true
                            )
                        else
                            if indienst == true then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um den Dienst zu verlassen.",
                                    "System-Nachricht",
                                    true
                                )
                            end
                        end
                    else
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("sevenliferp:closenotify", false)
                        allownotifyforbus = false
                        Citizen.Wait(10)
                        if indienst == false then
                            indienst = true
                            MakeUniform()
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Bus Job",
                                "Du bist jetzt im Dienst, Gehe zum marker um eine Tour zu starten",
                                3000
                            )
                            TriggerEvent("sevenlife:busaction")
                            allownotifyforbus = true
                        else
                            if indienst == true then
                                indienst = false
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Bus Job",
                                    "Du bist jetzt ausserhalb des Dienstes",
                                    3000
                                )

                                Resetskin()
                                allownotifyforbus = true
                            end
                        end
                    end
                else
                    if difference >= 1.5 and difference <= 2 then
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    )
end
RegisterNetEvent("sevenlife:busaction")
AddEventHandler(
    "sevenlife:busaction",
    function()
        Citizen.CreateThread(
            function()
                local spawnonlyonce = false
                Localpedtwo()
                while indienst do
                    Citizen.Wait(1)
                    local pos2 = vector3(Config.locations.npcs.x, Config.locations.npcs.y, Config.locations.npcs.z)
                    local difference =
                        GetDistanceBetweenCoords(
                        GetEntityCoords(GetPlayerPed(-1)),
                        vector3(pos2.x, pos2.y, pos2.z),
                        true
                    )
                    if difference < 50 then
                        DrawMarker(
                            20,
                            pos2.x,
                            pos2.y,
                            28.5,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0.6,
                            0.6,
                            0.6,
                            234,
                            0,
                            122,
                            200,
                            1,
                            1,
                            0,
                            0
                        )
                    end
                    if difference < 1.5 then
                        if allownotifyforbus then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um einen Bus herzuhollen.",
                                "System-Nachricht",
                                true
                            )
                        end
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("sevenliferp:closenotify", false)
                            allownotifyforbus = false
                            if spawnonlyonce == false then
                                SpawnBus()
                                spawnonlyonce = true
                            end
                        end
                    else
                        if difference >= 1.5 and difference <= 2 then
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                end
            end
        )
    end
)
local spawnedbus = 0
function SpawnBus()
    activemission = true
    Citizen.Wait(10)
    if not IsPedInSpawnBus() and not buscar then
        for ks, _v in pairs(Config.locations.Spawnbuses) do
            local vehiclearea = ESX.Game.GetVehiclesInArea(_v, 4.0)
            if #vehiclearea == 0 and spawnedbus == 0 then
                spawnedbus = 1
                ESX.Game.SpawnVehicle(
                    Config.BusHash,
                    _v,
                    _v.heading,
                    function(vehicle)
                        if busVehicle == nil then
                            if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                                Citizen.Wait(200)
                                cars = cars + 1
                                busVehicle = vehicle
                                TaskEnterVehicle(PlayerPedId(), vehicle, 5, -1, 2.0, 16, 0)
                                Firstmission()
                            end
                        end
                    end
                )
            end
        end
    end
end

function IsPedInSpawnBus()
    return (GetVehiclePedIsIn(PlayerPedId(), false) == busVehicle)
end

function MakeUniform()
    TriggerEvent(
        "skinchanger:getSkin",
        function(skin)
            if skin.sex == 0 then
                if Config.JobUniforms.male ~= nil then
                    TriggerEvent("skinchanger:loadClothes", skin, Config.JobUniforms.male)
                end
            else
                if Config.JobUniforms.female ~= nil then
                    TriggerEvent("skinchanger:loadClothes", skin, Config.JobUniforms.female)
                end
            end
        end
    )
end

function Resetskin()
    ESX.TriggerServerCallback(
        "esx_skin:getPlayerSkin",
        function(skin)
            TriggerEvent("skinchanger:loadSkin", skin)
        end
    )
end

function Localped()
    Citizen.CreateThread(
        function()
            local NpcSpawner = vector3(Config.locations.npc.x, Config.locations.npc.y, Config.locations.npc.z)
            local pedmodel = GetHashKey("a_m_y_business_03")
            if not HasModelLoaded(pedmodel) then
                RequestModel(pedmodel)
                while not HasModelLoaded(pedmodel) do
                    Citizen.Wait(1)
                end
                ped7 =
                    CreatePed(
                    3,
                    pedmodel,
                    NpcSpawner.x,
                    NpcSpawner.y,
                    NpcSpawner.z,
                    Config.locations.npc.heading,
                    false,
                    true
                )
                SetEntityInvincible(ped7, true)
                FreezeEntityPosition(ped7, true)
                SetBlockingOfNonTemporaryEvents(ped7, true)
            end
        end
    )
end
function LocalBlip()
    local blips = vector2(Config.locations.npc.x, Config.locations.npc.y)
    local blip = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blip, 513)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 61)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Bushof")
    EndTextCommandSetBlipName(blip)
end
AddEventHandler(
    "onResourceStart",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        DeletePed(ped7)
    end
)
function Localpedtwo()
    local pednumber = tonumber(1)
    for i = 1, pednumber, 1 do
        local NpcSpawner = vector3(Config.locations.npcs.x, Config.locations.npcs.y, Config.locations.npcs.z)
        local ped = GetHashKey("a_m_y_business_03")
        if not HasModelLoaded(ped) then
            RequestModel(ped)
            while not HasModelLoaded(ped) do
                Citizen.Wait(1)
            end

            ped7 =
                CreatePed(3, ped, NpcSpawner.x, NpcSpawner.y, NpcSpawner.z, Config.locations.npcs.heading, false, true)
            SetEntityInvincible(ped7, true)
            FreezeEntityPosition(ped7, true)
            SetBlockingOfNonTemporaryEvents(ped7, true)
        end
    end
end
local npcs
function Firstmission()
    Citizen.CreateThread(
        function()
            npcs = {}
            for i = 1, 9, 1 do
                Citizen.Wait(50)
                local rndPedHash = RandomPedHash()
                npcs[i] = CreatePedForVehicle(busVehicle, rndPedHash, i - 1)
            end
            local number = math.random(1, 8)
            local coords = Config.JobCoords[number]

            CreateBlipForMission(coords.x, coords.y)
            TriggerEvent("SevenLife:TimetCustom:Notify", "Bus Job", "Fahre zum Markierten Punkt!", 3000)
            TriggerEvent("SevenLife:Mission:AddCheck", coords.x, coords.y, coords.z)
            TriggerEvent("SevenLife:Mission:StartDemageCounter")
        end
    )
end
function RandomPedHash()
    local randomPed = Config.PedList[math.random(1, #Config.PedList)]
    local hashPed = GetHashKey(randomPed)
    Citizen.CreateThread(
        function()
            RequestModel(hashPed)
            while (not HasModelLoaded(hashPed)) do
                Citizen.Wait(1)
            end
        end
    )

    return hashPed
end

function CreatePedForVehicle(vehicle, hash, seat)
    local npc = nil

    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Citizen.Wait(5)
    end

    npc = CreatePedInsideVehicle(vehicle, 5, hash, seat, true, true)
    SetPedAlertness(npc, 0)
    SetPedAsCop(npc, false)
    SetPedAsEnemy(npc, false)
    SetPedCombatMovement(npc, 0)
    SetPedCombatAbility(npc, 0)
    SetPedCombatRange(npc, 0)
    SetPedFleeAttributes(npc, 0, 0)
    SetPedSeeingRange(npc, 0.0)
    SetPedHearingRange(npc, 0.0)
    SetPedCombatAbility(npc, 0)
    SetPedCombatAttributes(npc, 0, 0)
    SetPedCombatAttributes(npc, 1, 0)
    SetPedCombatAttributes(npc, 2, 0)
    SetPedCombatAttributes(npc, 3, 1)
    SetPedCombatAttributes(npc, 5, 0)
    SetPedCombatAttributes(npc, 20, 0)
    SetPedCombatAttributes(npc, 46, 0)
    SetPedCombatAttributes(npc, 52, 0)
    SetPedCombatAttributes(npc, 292, 0)
    SetCanAttackFriendly(npc, 0, 0)

    return npc
end

function CreateBlipForMission(x, y)
    local blips = vector2(x, y)
    blipmission = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blipmission, 513)
    SetBlipDisplay(blipmission, 4)
    SetBlipScale(blipmission, 0.8)
    SetBlipColour(blipmission, 61)
    SetBlipRoute(blipmission, true)
    SetBlipAsShortRange(blipmission, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Ablieferort")
    EndTextCommandSetBlipName(blipmission)
end
local endstory = true
RegisterNetEvent("SevenLife:Mission:AddCheck")
AddEventHandler(
    "SevenLife:Mission:AddCheck",
    function(x, y, z)
        local started1 = true
        local notifys = true
        local inmarker = false
        local inmenu = false
        local openshop = false
        local time = 100
        local allowmarker = false

        Citizen.CreateThread(
            function()
                Citizen.Wait(100)

                while activemission do
                    local player = GetPlayerPed(-1)
                    if openshop == false then
                        Citizen.Wait(time)
                        local coords = GetEntityCoords(player)
                        local distance = GetDistanceBetweenCoords(coords, x, y, z, true)
                        if distance < 70 then
                            time = 15
                            allowmarker = true
                            if distance < 7 then
                                time = 5
                                inmarker = true
                            else
                                if distance >= 7.1 and distance <= 25 then
                                    inmarker = false
                                    TriggerEvent("sevenliferp:closenotify", false)
                                end
                            end
                        else
                            if distance >= 70 and distance <= 100 then
                                allowmarker = false
                            end
                        end
                    else
                        Citizen.Wait(2000)
                    end
                end
            end
        )

        Citizen.CreateThread(
            function()
                Citizen.Wait(3000)
                while activemission do
                    Citizen.Wait(5)
                    if inmarker then
                        if inmenu == false then
                            notifys = false
                            activemission = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            FreezeEntityPosition(busVehicle, true)
                            for k, v in pairs(npcs) do
                                TaskLeaveVehicle(v, busVehicle, 1)
                            end
                            Citizen.Wait(6000)
                            FreezeEntityPosition(busVehicle, false)
                            for k, v in pairs(npcs) do
                                DeleteEntity(v)
                            end
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Bus Job",
                                "Du hast die Fahrgäste rausgelassen. Fahre wieder zum Bushof!",
                                3000
                            )
                            RemoveBlip(blipmission)
                            TriggerEvent("SevenLife:Mission:NextStep")
                            activemission = false
                        end
                    else
                        Citizen.Wait(1000)
                    end
                end
            end
        )

        Citizen.CreateThread(
            function()
                local time = 2000
                while activemission do
                    Citizen.Wait(time)
                    if allowmarker then
                        time = 1

                        DrawMarker(
                            Config.MarkerType,
                            x,
                            y,
                            z,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            vector3(3.8, 3.8, 2.8),
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
                        time = 2000
                    end
                end
            end
        )
    end
)
RegisterNetEvent("SevenLife:Mission:NextStep")
AddEventHandler(
    "SevenLife:Mission:NextStep",
    function()
        local notifys = true
        local inmarker = false
        local inmenu = false
        local openshop = false
        local time = 100
        local allowmarker = false
        CreateBlipForMission(459.73880004883, -578.57257080078)
        Citizen.CreateThread(
            function()
                Citizen.Wait(100)

                while endstory do
                    local player = GetPlayerPed(-1)
                    if openshop == false then
                        Citizen.Wait(time)
                        local coords = GetEntityCoords(player)
                        local distance =
                            GetDistanceBetweenCoords(coords, 459.73880004883, -578.57257080078, 27.494270324707, true)
                        if distance < 70 then
                            time = 15
                            allowmarker = true
                            if distance < 7 then
                                time = 5
                                inmarker = true
                            else
                                if distance >= 7 and distance <= 35 then
                                    inmarker = false
                                    TriggerEvent("sevenliferp:closenotify", false)
                                end
                            end
                        else
                            if distance >= 70 and distance <= 100 then
                                allowmarker = false
                            end
                        end
                    else
                        Citizen.Wait(2000)
                    end
                end
            end
        )

        Citizen.CreateThread(
            function()
                Citizen.Wait(3000)
                while endstory do
                    Citizen.Wait(5)
                    if inmarker then
                        if inmenu == false then
                            notifys = false
                            endstory = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            DeleteVehicle(busVehicle)
                            RemoveBlip(blipmission)
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Bus Job",
                                "Du hast deinen Bus abgegeben!",
                                3000
                            )
                            endstory = false
                            buscar = false
                            TriggerServerEvent("SevenLife:Mission:Pay", beschwerden)
                            beschwerden = 0
                            spawnedbus = 0
                            allownotifyforbus = true
                            spawnonlyonce = false
                        end
                    else
                        Citizen.Wait(1000)
                    end
                end
            end
        )

        Citizen.CreateThread(
            function()
                local time = 2000
                while endstory do
                    Citizen.Wait(time)
                    if allowmarker then
                        time = 1

                        DrawMarker(
                            Config.MarkerType,
                            459.73880004883,
                            -578.57257080078,
                            27.494270324707,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            vector3(3.8, 3.8, 2.8),
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
                        time = 2000
                    end
                end
            end
        )
    end
)
RegisterNetEvent("SevenLife:Mission:StartDemageCounter")
AddEventHandler(
    "SevenLife:Mission:StartDemageCounter",
    function()
        Citizen.CreateThread(
            function()
                while activemission do
                    Citizen.Wait(10)

                    local playerPed = PlayerPedId()

                    if IsPedInAnyVehicle(playerPed, false) then
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        local health = GetEntityHealth(vehicle)
                        local speed = GetEntitySpeed(vehicle) * 3.6
                        if health < LastVehicleHealth then
                            beschwerden = beschwerden + 1
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Bus Job",
                                "Die Fahrgäste Beschweren sich weil du holprig fährst!",
                                3000
                            )
                            LastVehicleHealth = health
                            Citizen.Wait(2000)
                        end
                        if speed > 60 then
                            beschwerden = beschwerden + 1
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Bus Job",
                                "Die Fahrgäste Beschweren sich weil du zu schnell gefahren bist!",
                                3000
                            )
                            Citizen.Wait(2000)
                        end
                    end
                end
            end
        )
    end
)
