--------------------------------------------------------------------------------------------------------------
------------------------------------------------ESX-----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

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
--------------------------------------------------------------------------------------------------------------
------------------------------------------------Blips---------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        for k, v in pairs(Config.Impounder) do
            Citizen.Wait(500)
            if v.impounder ~= 4 and v.impounder ~= 5 and v.impounder ~= 6 and v.impounder ~= 7 then
                local blips = vector3(v.x, v.y, v.z)
                local blip = AddBlipForCoord(blips.x, blips.y, blips.z)

                SetBlipSprite(blip, 461)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipColour(blip, 61)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Auto Sicherstellungs Platz")
                EndTextCommandSetBlipName(blip)
            else
                if v.impounder == 4 or v.impounder == 7 then
                    local blips = vector3(v.x, v.y, v.z)
                    local blip = AddBlipForCoord(blips.x, blips.y, blips.z)

                    SetBlipSprite(blip, 461)
                    SetBlipDisplay(blip, 4)
                    SetBlipScale(blip, 1.0)
                    SetBlipColour(blip, 61)
                    SetBlipAsShortRange(blip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Flugzeug Sicherstellungs Platz")
                    EndTextCommandSetBlipName(blip)
                else
                    if v.impounder == 5 or v.impounder == 6 then
                        local blips = vector3(v.x, v.y, v.z)
                        local blip = AddBlipForCoord(blips.x, blips.y, blips.z)

                        SetBlipSprite(blip, 461)
                        SetBlipDisplay(blip, 4)
                        SetBlipScale(blip, 1.0)
                        SetBlipColour(blip, 61)
                        SetBlipAsShortRange(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Boots Sicherstellungs Platz")
                        EndTextCommandSetBlipName(blip)
                    end
                end
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
---------------------------------------------Npc Spawner------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            for k, v in pairs(Config.Impounder) do
                local distance = GetDistanceBetweenCoords(PlayerCoord, v.x, v.y, v.z, true)

                Citizen.Wait(500)

                if distance < 30 then
                    pedarea = true
                    if not pedloaded then
                        RequestModel(ped)
                        while not HasModelLoaded(ped) do
                            Citizen.Wait(1)
                        end
                        ped1 = CreatePed(4, ped, v.x, v.y, v.z, v.heading, false, true)
                        SetEntityInvincible(ped1, true)
                        FreezeEntityPosition(ped1, true)
                        SetBlockingOfNonTemporaryEvents(ped1, true)
                        TaskPlayAnim(ped1, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                        pedloaded = true
                    end
                else
                    if distance >= 30.1 and distance <= 50 then
                        pedarea = false
                    end
                end

                if pedloaded and not pedarea then
                    DeleteEntity(ped1)
                    SetModelAsNoLongerNeeded(ped)
                    pedloaded = false
                end
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------
local msg
local msgeins
local msgzwei
local garage
local notifys = true
local inmarker = false
local inmenu = false
local openmenu = false

local timemain = 100
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            for k, v in pairs(Config.Impounder) do
                local distance = GetDistanceBetweenCoords(coord, v.x, v.y, v.z, true)
                if distance < 15 then
                    area = true
                    timemain = 15
                    if distance < 2 then
                        impoundernummer = v.impounder
                        inmarker = true
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um deine Fahrzeuge zu begutachten",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 2.1 and distance <= 3 then
                            inmarker = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    area = false
                end
            end
        end
    end
)
Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        openmenu = true
                        TriggerEvent("sevenlife:getimpoundedcars")
                        TriggerEvent("sevenlife:openimpounder")
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
RegisterNetEvent("sevenlife:getimpoundedcars")
AddEventHandler(
    "sevenlife:getimpoundedcars",
    function(data, cb)
        if impoundernummer ~= 4 and impoundernummer ~= 5 and impoundernummer ~= 6 and impoundernummer ~= 7 then
            ESX.TriggerServerCallback(
                "sevenlife:loadimpoundedvehicles",
                function(ownedCars)
                    for _, v in pairs(ownedCars) do
                        local haverversicherung = v.versichert
                        local hash = v.vehicle.model
                        local vehname = GetDisplayNameFromVehicleModel(hash)
                        local labelname = GetLabelText(vehname)
                        local plate = v.plate
                        AddCarsImpounder(plate, v.fuel, labelname, haverversicherung)
                    end
                end
            )
        else
            if impoundernummer == 4 or impoundernummer == 7 then
                ESX.TriggerServerCallback(
                    "SevenLife:Impounder:GetFlugzeuge",
                    function(ownedflugzeug)
                        for _, v in pairs(ownedflugzeug) do
                            local haverversicherung = v.versichert
                            local hash = v.vehicle.model
                            local vehname = GetDisplayNameFromVehicleModel(hash)
                            local labelname = GetLabelText(vehname)
                            local plate = v.plate
                            AddCarsImpounder(plate, v.fuel, labelname, haverversicherung)
                        end
                    end
                )
            else
                if impoundernummer == 5 or impoundernummer == 6 then
                    ESX.TriggerServerCallback(
                        "SevenLife:Impounder:GetBoote",
                        function(ownedflugzeug)
                            for _, v in pairs(ownedflugzeug) do
                                local haverversicherung = v.versichert
                                local hash = v.vehicle.model
                                local vehname = GetDisplayNameFromVehicleModel(hash)
                                local labelname = GetLabelText(vehname)
                                local plate = v.plate
                                AddCarsImpounder(plate, v.fuel, labelname, haverversicherung)
                            end
                        end
                    )
                end
            end
        end
    end
)
function AddCarsImpounder(plate, fuel, model, versicherung)
    SendNUIMessage(
        {
            type = "addcarimpounder",
            plate = plate,
            model = model,
            fuel = fuel,
            versicherung = versicherung
        }
    )
end
RegisterNUICallback(
    "escape",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
        openmenu = false
    end
)

RegisterNUICallback(
    "park-outs",
    function(data, cb)
        ESX.TriggerServerCallback(
            "SevenLife:Impounder:GetEnoughMoney",
            function(valid)
                if valid then
                    SetNuiFocus(false, false)
                    ESX.TriggerServerCallback(
                        "sevenlife:spawnvehiclese",
                        function(vehicle)
                            local player = GetPlayerPed(-1)

                            local carmechanic = json.decode(vehicle[1].vehicle)
                            local plate = vehicle[1].plate
                            if impoundernummer == 1 then
                                spawner =
                                    vector3(
                                    Config.Anmeldestelle.carspawner1.x,
                                    Config.Anmeldestelle.carspawner1.y,
                                    Config.Anmeldestelle.carspawner1.z
                                )
                                headingspawn = Config.Anmeldestelle.carspawner1.heading
                            else
                                if impoundernummer == 2 then
                                    spawner =
                                        vector3(
                                        Config.Anmeldestelle.carspawner2.x,
                                        Config.Anmeldestelle.carspawner2.y,
                                        Config.Anmeldestelle.carspawner2.z
                                    )
                                    headingspawn = Config.Anmeldestelle.carspawner2.heading
                                else
                                    if impoundernummer == 3 then
                                        spawner =
                                            vector3(
                                            Config.Anmeldestelle.carspawner3.x,
                                            Config.Anmeldestelle.carspawner3.y,
                                            Config.Anmeldestelle.carspawner3.z
                                        )
                                        headingspawn = Config.Anmeldestelle.carspawner3.heading
                                    else
                                        if impoundernummer == 4 then
                                            spawner =
                                                vector3(
                                                Config.Anmeldestelle.carspawner4.x,
                                                Config.Anmeldestelle.carspawner4.y,
                                                Config.Anmeldestelle.carspawner4.z
                                            )
                                            headingspawn = Config.Anmeldestelle.carspawner4.heading
                                        else
                                            if impoundernummer == 5 then
                                                spawner =
                                                    vector3(
                                                    Config.Anmeldestelle.carspawner5.x,
                                                    Config.Anmeldestelle.carspawner5.y,
                                                    Config.Anmeldestelle.carspawner5.z
                                                )
                                                headingspawn = Config.Anmeldestelle.carspawner5.heading
                                            else
                                                if impoundernummer == 6 then
                                                    spawner =
                                                        vector3(
                                                        Config.Anmeldestelle.carspawner6.x,
                                                        Config.Anmeldestelle.carspawner6.y,
                                                        Config.Anmeldestelle.carspawner6.z
                                                    )
                                                    headingspawn = Config.Anmeldestelle.carspawner6.heading
                                                else
                                                    if impoundernummer == 7 then
                                                        spawner =
                                                            vector3(
                                                            Config.Anmeldestelle.carspawner7.x,
                                                            Config.Anmeldestelle.carspawner7.y,
                                                            Config.Anmeldestelle.carspawner7.z
                                                        )
                                                        headingspawn = Config.Anmeldestelle.carspawner7.heading
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end

                            ESX.Game.SpawnVehicle(
                                carmechanic.model,
                                spawner,
                                headingspawn,
                                function(vehicles)
                                    ESX.Game.SetVehicleProperties(vehicles, carmechanic)
                                    SetVehRadioStation(vehicles, "OFF")
                                    TaskWarpPedIntoVehicle(player, vehicles, -1)

                                    Citizen.Wait(30)
                                    inmarker = false
                                    inmenu = false
                                    notifys = true
                                    SetVehicleNumberPlateText(vehicles, plate)

                                    Citizen.Wait(50)
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Success",
                                        "Auto erfolgreich ausgeparkt",
                                        3000
                                    )
                                    TriggerServerEvent("sevenlife:ziehegeldimpounderab", data.price)

                                    openmenu = false
                                end
                            )
                        end,
                        data.plate
                    )
                else
                    SetNuiFocus(false, false)
                    inmenu = false
                    notifys = true
                    openmenu = false
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Impounder", "Du hast zu wenig Geld mit dabei", 3000)
                end
            end,
            data.price
        )
    end
)
