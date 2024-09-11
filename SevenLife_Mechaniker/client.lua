Carlist = {
    {
        name = "Abschlepper No.1",
        lable = "TOWTRUCK",
        Costs = 20000
    },
    {
        name = "Abschlepper No.2",
        lable = "Towtruck2",
        Costs = 20000
    },
    {
        name = "Bulldozer",
        lable = "bulldozer",
        Costs = 10000
    },
    {
        name = "Hilfewagen",
        lable = "utillitruck2",
        Costs = 10000
    },
    {
        name = "Geländefahrzeug",
        lable = "sandking",
        Costs = 20000
    },
    {
        name = "Abschlepper No.3",
        lable = "FLATBED",
        Costs = 20000
    }
}
local mistime = 1000
local NumberCharset = {}
local Charset = {}
local timemenu = 5
local inmenudialog = false
for i = 48, 57 do
    table.insert(NumberCharset, string.char(i))
end

for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end
-- Variables
local IsCommandRegistered = false
local ingaragerange = false
local notifys = true
local pedarea = false
local ingarageparkrange = false
local ped = GetHashKey("a_m_y_business_03")
local inmenu = false
local outarea = false
local list = {}
local pedloaded = false
mechanik = false
-- RegisterAll
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

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        PlayerData = xPlayer
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(job)
        PlayerData.job = job
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        BlipsWerkstatt(Config.bliplocation.x, Config.bliplocation.y, Config.bliplocation.z)
        while true do
            Citizen.Wait(10)

            if PlayerData.job.name == "mechaniker" then
                mechanik = true
            end
        end
    end
)
--Blips

function BlipsWerkstatt(coordx, coordy, coordz)
    local blips = vector3(coordx, coordy, coordz)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 446)
    SetBlipScale(blip1, 0.8)
    SetBlipColour(blip1, 5)
    SetBlipDisplay(blip1, 4)
    SetBlipAsShortRange(blip1, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Werkstatt")
    EndTextCommandSetBlipName(blip1)
end

-- Mechaniker Garage

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
                Config.garaglocations.x,
                Config.garaglocations.y,
                Config.garaglocations.z,
                true
            )
            if mechanik then
                if inmenu == false then
                    if distance < 1.5 then
                        ingaragerange = true
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um die Garage anzusehen",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 1.6 and distance <= 4 then
                            ingaragerange = false
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
            if ingaragerange then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        if indienst then
                            for i, k in pairs(Carlist) do
                                table.insert(list, Carlist[i])
                            end
                            inmenu = true

                            notifys = false
                            SetNuiFocus(true, true)
                            SendNUIMessage(
                                {
                                    type = "OpenGarageWerkstatt",
                                    list = list
                                }
                            )
                            TriggerEvent("sevenliferp:closenotify", false)
                        else
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Mechaniker", "Du bist nicht im Dienst", 2000)
                        end
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
                Config.garaglocations.x,
                Config.garaglocations.y,
                Config.garaglocations.z,
                true
            )

            Citizen.Wait(1000)
            pedarea = false
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
                        Config.garaglocations.x,
                        Config.garaglocations.y,
                        Config.garaglocations.z,
                        Config.garaglocations.heading,
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
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped1)
                SetModelAsNoLongerNeeded(ped)
                pedloaded = false
            end
        end
    end
)

RegisterNUICallback(
    "BuyVehicle",
    function(data)
        SetNuiFocus(false, false)
        local model = data.car
        local player = GetPlayerPed(-1)
        inmenu = false
        notifys = false
        ingaragerange = false

        ESX.TriggerServerCallback(
            "SevenLife:Mechaniker:Buyvehicle",
            function(enoughmoney)
                if enoughmoney then
                    DoScreenFadeOut(2000)
                    Citizen.Wait(2000)
                    local Spawnpoint = vector3(Config.CarSpawn.x, Config.CarSpawn.y, Config.CarSpawn.z)
                    ESX.Game.SpawnVehicle(
                        model,
                        Spawnpoint,
                        Config.CarSpawn.heading,
                        function(vehicle)
                            TaskWarpPedIntoVehicle(player, vehicle, -1)
                            DoScreenFadeIn(2000)
                            local plate = MakePlate()
                            local caridentifier = CarID()
                            local vehicleprops = ESX.Game.GetVehicleProperties(vehicle)
                            vehicleprops.plate = plate
                            SetVehicleColours(vehicle, 112, 112)
                            SetVehicleNumberPlateText(vehicle, plate)
                            TriggerServerEvent("SevenLife:Mechaniker:AddCard", vehicleprops, caridentifier, "car")
                            inmenu = false
                            notifys = true
                            list = {}
                            ingaragerange = false
                        end
                    )
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Tankstelle", "Du besitzt zu wenig Geld", 2000)
                end
            end,
            data.price
        )
    end
)

function MakePlate()
    local MakePlate
    local doBreak = false

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())
        if Config.PlateUseSpace then
            MakePlate =
                string.upper(GetRandomLetter(Config.PlateLetters) .. " " .. GetRandomNumber(Config.PlateNumbers))
        else
            MakePlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))
        end

        ESX.TriggerServerCallback(
            "sevenlife:platetaken",
            function(isPlateTaken)
                if not isPlateTaken then
                    doBreak = true
                end
            end,
            MakePlate
        )

        if doBreak then
            break
        end
    end

    return MakePlate
end

function GetRandomNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ""
    end
end

function GetRandomLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ""
    end
end

function CarID()
    local MakeID
    local doBreaks = false

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())
        if Config.PlateUseSpace then
            MakeID =
                string.upper(
                GetRandomVhehicleIDLetter(Config.IDLetter) .. " " .. GetRandomVehicleIDNumber(Config.IDNumber)
            )
        else
            MakeID =
                string.upper(GetRandomVhehicleIDLetter(Config.IDLetter) .. GetRandomVehicleIDNumber(Config.IDNumber))
        end

        ESX.TriggerServerCallback(
            "sevenlife:isidTaken",
            function(isidtaken)
                if not isidtaken then
                    doBreaks = true
                end
            end,
            MakeID
        )

        if doBreaks then
            break
        end
    end

    return MakeID
end

function GetRandomVehicleIDNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomVehicleIDNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ""
    end
end

function GetRandomVhehicleIDLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomVhehicleIDLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ""
    end
end

RegisterNUICallback(
    "GetVehicles",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Mechaniker:GetGarageCars",
            function(cars)
                for _, v in pairs(cars) do
                    print(v)
                    local hash = v.vehicle.model
                    local vehname = GetDisplayNameFromVehicleModel(hash)
                    local labelname = GetLabelText(vehname)
                    local plate = v.plate
                    SendNUIMessage(
                        {
                            type = "AddGarage",
                            name = labelname,
                            plate = plate
                        }
                    )
                end
            end
        )
    end
)

RegisterNUICallback(
    "ParkVehicleOut",
    function(data)
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "sevenlife:spawnvehiclese",
            function(vehicle)
                local player = GetPlayerPed(-1)

                local carmechanic = json.decode(vehicle[1].vehicle)
                local plate = vehicle[1].plate
                local Spawnpoint = vector3(Config.CarSpawn.x, Config.CarSpawn.y, Config.CarSpawn.z)
                DoScreenFadeOut(2000)
                Citizen.Wait(2000)
                ESX.Game.SpawnVehicle(
                    carmechanic.model,
                    Spawnpoint,
                    Config.CarSpawn.heading,
                    function(vehicles)
                        DoScreenFadeIn(3000)
                        ESX.Game.SetVehicleProperties(vehicles, carmechanic)
                        SetVehRadioStation(vehicles, "OFF")
                        TaskWarpPedIntoVehicle(player, vehicles, -1)

                        Citizen.Wait(30)
                        inmenu = false
                        notifys = false
                        ingaragerange = false
                        SetVehicleNumberPlateText(vehicles, plate)

                        Citizen.Wait(50)
                        TriggerEvent("sevenliferp:closenotify", false)
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Success", "Auto erfolgreich ausgeparkt", 3000)
                        TriggerServerEvent("sevenlife:changemode", data.plate, false)
                        inmenu = false
                        notifys = true
                        list = {}
                        ingaragerange = false
                    end
                )
            end,
            data.plate
        )
    end
)

RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        list = {}
        inmenudialog = false
        notifys = true
        ingaragerange = false
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
            local distance = GetDistanceBetweenCoords(coords, Config.InDel.x, Config.InDel.y, Config.InDel.z, true)
            if mechanik then
                if IsPedInAnyVehicle(player, true) then
                    if distance < 40 then
                        outarea = true
                        if distance < 2.5 then
                            ingarageparkrange = true

                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um das Fahrzeug einzulagern",
                                "System - Nachricht",
                                true
                            )
                        else
                            if distance >= 2.6 and distance <= 5 then
                                ingarageparkrange = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        outarea = false
                    end
                else
                    ingarageparkrange = false
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
            Citizen.Wait(mistime)
            if outarea then
                mistime = 1
                DrawMarker(
                    Config.MarkerType,
                    Config.InDel.x,
                    Config.InDel.y,
                    Config.InDel.z,
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
                mistime = 1000
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if ingarageparkrange then
                if IsControlJustPressed(0, 38) then
                    if indienst then
                        TriggerEvent("sevenliferp:closenotify", false)
                        local vehiclese = ESX.Game.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(-1)), 7.0)
                        for k, v in pairs(vehiclese) do
                            local fuel = exports["SevenLife_Fuel"]:GetFuelLevel(v)
                            TriggerServerEvent(
                                "sevenlife:savecartile",
                                GetVehicleNumberPlateText(v),
                                ESX.Game.GetVehicleProperties(v)
                            )
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Success", "Auto erfolgreich eingeparkt", 3000)
                            TriggerServerEvent("sevenlife:changemode", GetVehicleNumberPlateText(v), true)
                            ESX.Game.DeleteVehicle(v)
                        end
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

-- Farb Mixer
local TimeForMarker = 100
local InMarkerFarbeMixArea = false
local InMixerMarker = false
local process = false
-- Marker

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(TimeForMarker)
            if InMarkerFarbeMixArea then
                TimeForMarker = 1
                DrawMarker(
                    20,
                    Config.FarbenMixer.x,
                    Config.FarbenMixer.y,
                    Config.FarbenMixer.z,
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
            else
                TimeForMarker = 1000
            end
        end
    end
)

-- Core
Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(coords, Config.FarbenMixer.x, Config.FarbenMixer.y, Config.FarbenMixer.z, true)
            if mechanik then
                if distance < 40 then
                    InMarkerFarbeMixArea = true
                    if distance < 1.9 then
                        InMixerMarker = true
                        if not process then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um die Farbe zu mixen",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 2 and distance <= 3.5 then
                            InMixerMarker = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    InMarkerFarbeMixArea = false
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
            if InMixerMarker then
                if IsControlJustPressed(0, 38) then
                    if indienst then
                        ESX.TriggerServerCallback(
                            "SevenLife:Mechaniker:GetItemsFarbeMix",
                            function(haveit)
                                if haveit then
                                    process = true
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    RequestAnimDict("mp_player_int_upperwank")
                                    local myPed = PlayerPedId(-1)
                                    local animation = "mp_player_int_wank_01_enter"
                                    local animation2 = "mp_player_int_wank_01_exit"
                                    local flags = 8
                                    TaskPlayAnim(
                                        myPed,
                                        "mp_player_int_upperwank",
                                        animation,
                                        8.0,
                                        -8,
                                        -1,
                                        flags,
                                        0,
                                        0,
                                        0,
                                        0
                                    )
                                    Citizen.Wait(650)
                                    TaskPlayAnim(
                                        myPed,
                                        "mp_player_int_upperwank",
                                        animation,
                                        8.0,
                                        -8,
                                        -1,
                                        flags,
                                        0,
                                        0,
                                        0,
                                        0
                                    )
                                    Citizen.Wait(650)
                                    TaskPlayAnim(
                                        myPed,
                                        "mp_player_int_upperwank",
                                        animation,
                                        8.0,
                                        -8,
                                        -1,
                                        flags,
                                        0,
                                        0,
                                        0,
                                        0
                                    )
                                    Citizen.Wait(650)
                                    TaskPlayAnim(
                                        myPed,
                                        "mp_player_int_upperwank",
                                        animation,
                                        8.0,
                                        -8,
                                        -1,
                                        flags,
                                        0,
                                        0,
                                        0,
                                        0
                                    )
                                    Citizen.Wait(650)
                                    TaskPlayAnim(
                                        myPed,
                                        "mp_player_int_upperwank",
                                        animation,
                                        8.0,
                                        -8,
                                        -1,
                                        flags,
                                        0,
                                        0,
                                        0,
                                        0
                                    )
                                    Citizen.Wait(650)
                                    TaskPlayAnim(
                                        myPed,
                                        "mp_player_int_upperwank",
                                        animation2,
                                        8.0,
                                        -8,
                                        -1,
                                        flags,
                                        0,
                                        0,
                                        0,
                                        0
                                    )
                                    TriggerServerEvent("SevenLife:Mechaniker:GiveMixedFarbeItem")
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Success",
                                        "Du hast Erfolgreich die Lackierung zusammen gemixt",
                                        3000
                                    )
                                    process = false
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Success",
                                        "Du besitzt zu wenig Lackierung",
                                        3000
                                    )
                                end
                            end
                        )
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Success", "Du bist nicht im Dienst", 3000)
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
            Citizen.Wait(5)
            if mechanik then
                if not inmenudialog then
                    if IsControlJustPressed(0, 57) then
                        if indienst then
                            inmenudialog = true
                            SetNuiFocus(true, false)
                            SendNUIMessage(
                                {
                                    type = "OpenMenuMenu"
                                }
                            )
                        else
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Success", "Du bist nicht im Dienst", 3000)
                        end
                    end
                end
            end
        end
    end
)
local currentowedvehicle = nil
RegisterNUICallback(
    "MakeAction",
    function(data)
        inmenudialog = false
        local actions = tonumber(data.action)
        SetNuiFocus(false, false)
        if actions == 1 then
            local ped = GetPlayerPed(-1)
            local vehicle = GetPlayersLastVehicle(ped, true)

            local towmodel = GetHashKey("FLATBED")
            local IsVehicleCurrentTow = IsVehicleModel(vehicle, towmodel)
            if IsVehicleCurrentTow then
                local coordA = GetEntityCoords(ped)
                local targetVehicle = ESX.Game.GetClosestVehicle(coordA)
                if currentowedvehicle == nil then
                    if targetVehicle ~= 0 then
                        if not IsPedInAnyVehicle(ped, true) then
                            if vehicle ~= targetVehicle then
                                AttachEntityToEntity(
                                    targetVehicle,
                                    vehicle,
                                    20,
                                    -0.5,
                                    -5.0,
                                    1.0,
                                    0.0,
                                    0.0,
                                    0.0,
                                    false,
                                    false,
                                    false,
                                    false,
                                    20,
                                    true
                                )
                                currentowedvehicle = targetVehicle
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Mechaniker",
                                    "Du hast das Auto auf deinen TowTruck aufgeladen",
                                    2000
                                )
                            else
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Mechaniker",
                                    "Willst du gerade das gleiche Auto abschleppen",
                                    2000
                                )
                            end
                        else
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Mechaniker",
                                "Du kannst kein Auto während du im Auto bist abschleppen",
                                2000
                            )
                        end
                    else
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Es gibt keine Autos die du abschleppen kannst",
                            2000
                        )
                    end
                else
                    AttachEntityToEntity(
                        currentowedvehicle,
                        vehicle,
                        20,
                        -0.5,
                        -12.0,
                        1.0,
                        0.0,
                        0.0,
                        0.0,
                        false,
                        false,
                        false,
                        false,
                        20,
                        true
                    )
                    DetachEntity(currentowedvehicle, true, true)
                    currentowedvehicle = nil
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Mechaniker",
                        "Du hast das Fahrzeug heruntergebracht",
                        2000
                    )
                end
            else
                TriggerEvent(
                    "SevenLife:TimetCustom:Notify",
                    "Mechaniker",
                    "Dieses Auto kann ein anderes Auto nicht aufnehmen",
                    2000
                )
            end
        elseif actions == 2 then
            SetNuiFocus(true, true)
            SendNUIMessage(
                {
                    type = "OpenRechnung"
                }
            )
        elseif actions == 3 then
            local player = GetPlayerPed(-1)

            local coords = GetEntityCoords(player)
            local vehicles = ESX.Game.GetClosestVehicle(coords)
            local hood = GetWorldPositionOfEntityBone(vehicles, GetEntityBoneIndexByName(vehicles, "door_dside_f"))
            local distance = GetDistanceBetweenCoords(hood, coords, true)
            if vehicles ~= nil then
                if distance < 2 then
                    Startlockpicking(vehicles)
                else
                    if distance >= 2.1 then
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mechaniker",
                            "Du musst an die Vordertür eines Autos",
                            2000
                        )
                    end
                end
            end
        elseif actions == 4 then
        end
    end
)
function Startlockpicking(vehicles)
    local playerPed = GetPlayerPed(-1)

    local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
    local animName = "machinic_loop_mechandplayer"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(50)
    end
    SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
    Citizen.Wait(500)
    FreezeEntityPosition(playerPed, true)
    TaskPlayAnim(playerPed, animDict, animName, 3.0, 1.0, -1, 31, 0, 0, 0)

    SetVehicleAlarm(vehicles, true)
    SetVehicleAlarmTimeLeft(vehicles, (45000))
    StartVehicleAlarm(vehicles)
    Citizen.Wait(7500)
    SetVehicleNeedsToBeHotwired(vehicles, true)
    IsVehicleNeedsToBeHotwired(vehicles)

    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)

    SetVehicleDoorsLocked(vehicles, 1)
end

local OutOfMarkerArea = false
local miliseconds = 1000
local InRangeOfAbschleppen = false
-- Delete Vehicle
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
                Config.DeleteVehicle.x,
                Config.DeleteVehicle.y,
                Config.DeleteVehicle.z,
                true
            )
            if mechanik then
                if IsPedInAnyVehicle(player, true) then
                    if distance < 40 then
                        OutOfMarkerArea = true
                        if distance < 2.5 then
                            InRangeOfAbschleppen = true

                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um das Fahrzeug einzulagern",
                                "System - Nachricht",
                                true
                            )
                        else
                            if distance >= 2.6 and distance <= 5 then
                                InRangeOfAbschleppen = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        OutOfMarkerArea = false
                    end
                else
                    InRangeOfAbschleppen = false
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
            Citizen.Wait(miliseconds)
            if OutOfMarkerArea then
                miliseconds = 1
                DrawMarker(
                    Config.MarkerType,
                    Config.DeleteVehicle.x,
                    Config.DeleteVehicle.y,
                    Config.DeleteVehicle.z,
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
                miliseconds = 1000
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if InRangeOfAbschleppen then
                if IsControlJustPressed(0, 38) then
                    if indienst then
                        TriggerEvent("sevenliferp:closenotify", false)
                        local vehiclese = ESX.Game.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(-1)), 7.0)
                        for k, v in pairs(vehiclese) do
                            TriggerServerEvent(
                                "sevenlife:savecartile",
                                GetVehicleNumberPlateText(v),
                                ESX.Game.GetVehicleProperties(v)
                            )
                            ESX.Game.DeleteVehicle(v)
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Success",
                                "Auto erfolgreich Abgeschleppt",
                                3000
                            )
                        end
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
    "GetRechnungen",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Mechaniker:GetRechnungen",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenRechnungen",
                        result = result
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "SetLohn",
    function(data)
        local lohn = data.lohn
        if lohn <= 500 then
            TriggerServerEvent("SevenLife:Mechaniker:SetLohn", data.type, lohn)
        else
            TriggerEvent(
                "SevenLife:TimetCustom:Notify",
                "Mechaniker",
                "Du kannst nicht mehr als 500$ als Lohn einstellen",
                2000
            )
        end
    end
)

RegisterNUICallback(
    "GetMembers",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Mechaniker:GetAngestellte",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenAngestellte",
                        result = result
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "DeRank",
    function(data)
        TriggerServerEvent("SevenLife:Mechaniker:DeRank", data.id)

        Citizen.Wait(1000)
        ESX.TriggerServerCallback(
            "SevenLife:Mechaniker:GetAngestellte",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateAngestellte",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "RankUp",
    function(data)
        TriggerServerEvent("SevenLife:Mechaniker:RankUp", data.id)
        Citizen.Wait(1000)
        ESX.TriggerServerCallback(
            "SevenLife:Mechaniker:GetAngestellte",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateAngestellte",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "feuern",
    function(data)
        TriggerServerEvent("SevenLife:Mechaniker:Feuern", data.id)
        Citizen.Wait(1000)
        ESX.TriggerServerCallback(
            "SevenLife:Mechaniker:GetAngestellte",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateAngestellte",
                        result = result
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "Einzahlen",
    function(data)
        TriggerServerEvent("SevenLife:Mechaniker:Einzahlen", data.cash)
    end
)
RegisterNUICallback(
    "Auszahlen",
    function(data)
        TriggerServerEvent("SevenLife:Mechaniker:Auszahlen", data.cash)
    end
)
RegisterNUICallback(
    "Fehler",
    function()
        SetNuiFocus(false, false)
        TriggerEvent(
            "SevenLife:TimetCustom:Notify",
            "Mechaniker",
            "Fehler bei Rechnung austellen => Inputt muss eine Nummer sein",
            2000
        )
    end
)
RegisterNUICallback(
    "MakeRechnung",
    function(data)
        SetNuiFocus(false, false)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local player = ESX.Game.GetClosestPlayer(coords)
        TriggerServerEvent(
            "SevenLife:Mechaniker:MakeBill",
            GetPlayerServerId(player),
            data.titel,
            data.grund,
            data.hohe
        )
    end
)
RegisterNUICallback(
    "GetOldLohn",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Mechaniker:GetLohn",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateLohn",
                        result = result
                    }
                )
            end
        )
    end
)
