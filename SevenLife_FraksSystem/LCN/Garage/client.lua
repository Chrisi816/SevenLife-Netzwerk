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
local NumberCharset = {}
local Charset = {}
local ingaragerange = false
local notifys = true
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
local inmenu = false
local list = {}
lcn = false
local pedloaded = false
for i = 48, 57 do
    table.insert(NumberCharset, string.char(i))
end

for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

Carlist = {
    {
        name = "Feltzer",
        lable = "feltzer3",
        Costs = 20000
    },
    {
        name = "Super Diamond",
        lable = "superd",
        Costs = 20000
    },
    {
        name = "Toros",
        lable = "toros",
        Costs = 10000
    },
    {
        name = "Infernus",
        lable = "infernus",
        Costs = 10000
    },
    {
        name = "Dubsta",
        lable = "dubsta",
        Costs = 20000
    },
    {
        name = "Windsor",
        lable = "windsor",
        Costs = 20000
    }
}

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        PlayerData = xPlayer
        ESX.TriggerServerCallback(
            "SevenLife:Fraktionslcn:getjob",
            function(havejob)
                if havejob then
                    lcn = true
                end
            end
        )
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance = GetDistanceBetweenCoords(coords, Config.garage.x, Config.garage.y, Config.garage.z, true)
            if lcn then
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
                        for i, k in pairs(Carlist) do
                            table.insert(list, Carlist[i])
                        end
                        inmenu = true

                        notifys = false
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenGarageLCN",
                                list = list
                            }
                        )
                        TriggerEvent("sevenliferp:closenotify", false)
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
                GetDistanceBetweenCoords(PlayerCoord, Config.garage.x, Config.garage.y, Config.garage.z, true)

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
                        Config.garage.x,
                        Config.garage.y,
                        Config.garage.z,
                        Config.garage.heading,
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
            "SevenLife:Fraktion:Buyvehicle",
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
                            SetVehicleColours(vehicle, 0, 0)
                            SetVehicleNumberPlateText(vehicle, plate)
                            TriggerServerEvent("SevenLife:Fraktion:AddCard", "LCN", vehicleprops, caridentifier, "car")
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
            "SevenLife:Fraktionen:GetGarageCars",
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
            end,
            "LCN"
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
Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            if lcn then
                local player = GetPlayerPed(-1)
                local coords = GetEntityCoords(player)
                local distance =
                    GetDistanceBetweenCoords(
                    coords,
                    Config.EinparkPunkt.x,
                    Config.EinparkPunkt.y,
                    Config.EinparkPunkt.z,
                    true
                )

                if IsPedInAnyVehicle(player, true) then
                    if distance < 40 then
                        outarea = true
                        if distance < 3 then
                            ingarageparkrange = true

                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um das Fahrzeug einzulagern",
                                "System - Nachricht",
                                true
                            )
                        else
                            if distance >= 3.1 and distance <= 5 then
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
                    1,
                    Config.EinparkPunkt.x,
                    Config.EinparkPunkt.y,
                    Config.EinparkPunkt.z - 1,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    vector3(4.0, 4.0, 1.1),
                    143,
                    0,
                    71,
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
                    if lcn then
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
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Du bist nicht im Dienst", 2000)
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
