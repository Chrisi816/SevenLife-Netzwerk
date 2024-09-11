local NumberCharset = {}
local Charset = {}
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
ingaragerange3 = false
notifys3 = true
local pedarea1 = false
local ped = GetHashKey("a_m_y_business_03")
inmenu3 = false
local list2 = {}
local pedloaded = false
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
                Config.Polizei.AusParkenNPC.x,
                Config.Polizei.AusParkenNPC.y,
                Config.Polizei.AusParkenNPC.z,
                true
            )
            if IsPlayerInPD and inoutservice then
                if inmenu3 == false then
                    if distance < 1.5 then
                        ingaragerange3 = true
                        if notifys3 then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um die Garage anzusehen",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 1.6 and distance <= 4 then
                            ingaragerange3 = false
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
            if IsPlayerInPD and inoutservice then
                if ingaragerange3 then
                    if IsControlJustPressed(0, 38) then
                        if inmenu3 == false then
                            if PlayerData.job.grade == 0 then
                                infolist2 = Config.Reange.Autos.Kadett
                            elseif PlayerData.job.grade == 1 then
                                infolist2 = Config.Reange.Autos.RekrutOfficer
                            elseif PlayerData.job.grade == 2 then
                                infolist2 = Config.Reange.Autos.PoliceOfficer
                            elseif PlayerData.job.grade == 3 then
                                infolist2 = Config.Reange.Autos.Detective
                            elseif PlayerData.job.grade == 4 then
                                infolist2 = Config.Reange.Autos.Sergeant
                            elseif PlayerData.job.grade == 5 then
                                infolist2 = Config.Reange.Autos.Leutnant
                            elseif PlayerData.job.grade == 6 then
                                infolist2 = Config.Reange.Autos.Agent
                            elseif PlayerData.job.grade == 7 then
                                infolist2 = Config.Reange.Autos.Captain
                            elseif PlayerData.job.grade == 8 then
                                infolist2 = Config.Reange.Autos.Inspector
                            elseif PlayerData.job.grade == 9 then
                                infolist2 = Config.Reange.Autos.DeputyChief
                            elseif PlayerData.job.grade == 10 then
                                infolist2 = Config.Reange.Autos.AssistantChief
                            elseif PlayerData.job.grade == 11 then
                                infolist2 = Config.Reange.Autos.ChiefofDepartment
                            end
                            inmenu3 = true

                            notifys3 = false
                            SetNuiFocus(true, true)
                            SendNUIMessage(
                                {
                                    type = "OpenGaragePolizei",
                                    list2 = infolist2
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
                Config.Polizei.AusParkenNPC.x,
                Config.Polizei.AusParkenNPC.y,
                Config.Polizei.AusParkenNPC.z,
                true
            )

            Citizen.Wait(1000)
            pedarea1 = false
            if distance < 40 then
                pedarea1 = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped2 =
                        CreatePed(
                        4,
                        ped,
                        Config.Polizei.AusParkenNPC.x,
                        Config.Polizei.AusParkenNPC.y,
                        Config.Polizei.AusParkenNPC.z,
                        Config.Polizei.AusParkenNPC.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped2, true)
                    FreezeEntityPosition(ped2, true)
                    SetBlockingOfNonTemporaryEvents(ped2, true)
                    RequestAnimDict("missfbi_s4mop")
                    while not HasAnimDictLoaded("missfbi_s4mop") do
                        Citizen.Wait(1)
                    end
                    TaskPlayAnim(ped2, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            end

            if pedloaded and not pedarea1 then
                DeleteEntity(ped2)
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
        inmenu3 = false
        notifys3 = false
        ingaragerange3 = false

        ESX.TriggerServerCallback(
            "SevenLife:Mechaniker:Buyvehicle",
            function(enoughmoney)
                if enoughmoney then
                    DoScreenFadeOut(2000)
                    Citizen.Wait(2000)
                    local Spawnpoint =
                        vector3(
                        Config.Polizei.AusParkPunkt.x,
                        Config.Polizei.AusParkPunkt.y,
                        Config.Polizei.AusParkPunkt.z
                    )
                    ESX.Game.SpawnVehicle(
                        model,
                        Spawnpoint,
                        Config.Polizei.AusParkPunkt.heading,
                        function(vehicle)
                            TaskWarpPedIntoVehicle(player, vehicle, -1)
                            DoScreenFadeIn(2000)
                            local plate = MakePlate()
                            local caridentifier = CarID()
                            local vehicleprops = ESX.Game.GetVehicleProperties(vehicle)
                            vehicleprops.plate = plate
                            SetVehicleColours(vehicle, 112, 112)
                            SetVehicleNumberPlateText(vehicle, plate)
                            TriggerServerEvent("SevenLife:Police:AddCard", vehicleprops, caridentifier, "car")
                            Citizen.Wait(500)
                            inmenu3 = false
                            notifys3 = true

                            list2 = {}
                            ingaragerange3 = false
                        end
                    )
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Polizei", "Du besitzt zu wenig Geld", 2000)
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
            "SevenLife:Police:GetGarageCars",
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
                local Spawnpoint =
                    vector3(Config.Polizei.AusParkPunkt.x, Config.Polizei.AusParkPunkt.y, Config.Polizei.AusParkPunkt.z)
                DoScreenFadeOut(2000)
                Citizen.Wait(2000)
                ESX.Game.SpawnVehicle(
                    carmechanic.model,
                    Spawnpoint,
                    Config.Polizei.AusParkPunkt.heading,
                    function(vehicles)
                        DoScreenFadeIn(3000)
                        ESX.Game.SetVehicleProperties(vehicles, carmechanic)
                        SetVehRadioStation(vehicles, "OFF")
                        TaskWarpPedIntoVehicle(player, vehicles, -1)

                        Citizen.Wait(30)
                        inmenu3 = false
                        notifys3 = false
                        ingaragerange3 = false
                        SetVehicleNumberPlateText(vehicles, plate)

                        Citizen.Wait(50)
                        TriggerEvent("sevenliferp:closenotify", false)
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Success", "Auto erfolgreich ausgeparkt", 3000)
                        TriggerServerEvent("sevenlife:changemode", data.plate, false)
                        inmenu3 = false
                        notifys3 = true
                        list2 = {}
                        ingaragerange3 = false
                    end
                )
            end,
            data.plate
        )
    end
)
