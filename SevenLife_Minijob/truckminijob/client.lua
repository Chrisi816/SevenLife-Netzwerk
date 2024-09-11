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
local nolimit = true
local npcposhaupt = vector3(Config.locations.firstpos.x, Config.locations.firstpos.y, Config.locations.firstpos.z)
local missioneins =
    vector3(Config.locations.erstemission.x, Config.locations.erstemission.y, Config.locations.erstemission.z)
local notopenshop = false
local allowednotify = true
local missionzwei =
    vector3(Config.locations.zweitemission.x, Config.locations.zweitemission.y, Config.locations.zweitemission.z)
local missiondrei =
    vector3(Config.locations.missiondrei.x, Config.locations.missiondrei.y, Config.locations.missiondrei.z)
local anheanger = vector3(Config.locations.anheanger.x, Config.locations.anheanger.y, Config.locations.anheanger.z)
Citizen.CreateThread(
    function()
        Spawnrentalnpc()
        MakeBLips()
        while true do
            if notopenshop == false then
                local coords = GetEntityCoords(PlayerPedId())
                Citizen.Wait(2)
                local distance = GetDistanceBetweenCoords(coords, npcposhaupt.x, npcposhaupt.y, npcposhaupt.z, true)
                if distance < 1.5 then
                    if notopenshop == false then
                        if nolimit then
                            Opennotify("Drücke E mit Peter Pedal zu reden")
                            if IsControlJustReleased(0, 38) then
                                Menu("openfarminghauptnui", true, true)
                                allowednotify = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        else
                            Opennotify("Du hast vor kurzem einen Minijob gemacht, komm in einigen Minuten wieder")
                        end
                    end
                else
                    if distance >= 1.5 and distance <= 3 then
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                if notopenshop then
                    Citizen.Wait(2000)
                end
            end
        end
    end
)

function Menu(event, bool, boolen)
    SetNuiFocus(bool, boolen)
    SendNUIMessage(
        {
            type = event
        }
    )
end

function Opennotify(text)
    if allowednotify then
        TriggerEvent("sevenliferp:startnui", text, "System-Nachricht", true)
    end
end

function MakeBLips()
    local blips = AddBlipForCoord(npcposhaupt.x, npcposhaupt.y)
    SetBlipSprite(blips, 616)
    SetBlipDisplay(blips, 4)
    SetBlipScale(blips, 1.0)
    SetBlipColour(blips, 48)
    SetBlipAsShortRange(blips, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Lieferjob")
    EndTextCommandSetBlipName(blips)
end

RegisterNUICallback(
    "erstemission",
    function()
        TriggerEvent("sevenliferp:closenotify", false)
        Citizen.Wait(100)

        Menu("removefarminghauptnui", false, false)
        Citizen.CreateThread(
            function()
                allowednotify = true
                Spawncar("mule")
                local activemission = true
                local player = GetPlayerPed(-1)
                local blips = AddBlipForCoord(missioneins.x, missioneins.y)
                SetBlipSprite(blips, 162)
                SetBlipDisplay(blips, 4)
                SetBlipScale(blips, 1.0)
                SetBlipColour(blips, 48)
                SetBlipRoute(blips, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Lieferort")
                EndTextCommandSetBlipName(blips)
                local anzahl = 20
                while activemission do
                    local coords = GetEntityCoords(PlayerPedId())
                    Citizen.Wait(2)
                    local distances =
                        GetDistanceBetweenCoords(coords, missioneins.x, missioneins.y, missioneins.z, true)
                    if distances < 10 and IsPedInAnyVehicle(player, false) then
                        Opennotify("Drücke E um deine Ware abzuliferen")
                        if IsControlJustReleased(0, 38) then
                            allowednotify = true
                            ESX.Game.DeleteVehicle(vehicles)
                            TriggerServerEvent("sevenlife:giveaccountcash", anzahl)
                            TriggerEvent("sevenliferp:closenotify", false)
                            ClearAllBlipRoutes()
                            RemoveBlip(blips)
                            nolimit = false
                            TriggerEvent("sevenlife:limit")
                            activemission = false
                        end
                    else
                        if distances >= 10.1 and distances <= 12 then
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                end
            end
        )
    end
)

function Spawncar(car)
    local player = PlayerPedId()
    ESX.Game.SpawnVehicle(
        car,
        Config.locationspawn,
        60.91,
        function(vehicle)
            vehicles = vehicle
            TaskWarpPedIntoVehicle(player, vehicle, -1)
            SetVehicleColours(vehicle, 112, 112)
            SetVehicleNumberPlateText(vehicle, "MINIJOB")
            TriggerEvent("SevenLife:TimetCustom:Notify", "Mission", "Deine Mission läuft in 15 Minuten aus", 3000)
            Citizen.SetTimeout(
                Config.RentTime,
                function()
                    ESX.Game.DeleteVehicle(vehicle)
                    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                end
            )

            Citizen.SetTimeout(
                Config.WarningRentTime1,
                function()
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Mission",
                        "Deine Mission läuft in 7 Minuten aus",
                        3000
                    )
                end
            )

            Citizen.SetTimeout(
                Config.WarningRentTime2,
                function()
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Mission",
                        "Deine Mission läuft in einer Minute aus",
                        3000
                    )
                end
            )
        end
    )
end
function Spawnrentalnpc()
    local pednumber = tonumber(1)
    for i = 1, pednumber do
        local NpcSpawner =
            vector3(Config.locations.firstpos.x, Config.locations.firstpos.y, Config.locations.firstpos.z)
        local ped = GetHashKey("a_m_y_business_03")
        if not HasModelLoaded(ped) then
            RequestModel(ped)
            while not HasModelLoaded(ped) do
                Citizen.Wait(1)
            end
            ped1 =
                CreatePed(
                4,
                ped,
                NpcSpawner.x,
                NpcSpawner.y,
                NpcSpawner.z,
                Config.locations.firstpos.heading,
                false,
                true
            )
            SetEntityInvincible(ped1, true)
            FreezeEntityPosition(ped1, true)
            SetBlockingOfNonTemporaryEvents(ped1, true)
        end
    end
end
RegisterNUICallback(
    "zweitemission",
    function()
        TriggerEvent("sevenliferp:closenotify", false)
        Menu("removefarminghauptnui", false, false)
        Citizen.CreateThread(
            function()
                allowednotify = true
                Spawncar("mule")
                local activemission = true
                local player = GetPlayerPed(-1)
                local blips = AddBlipForCoord(missionzwei.x, missionzwei.y)
                SetBlipSprite(blips, 162)
                SetBlipDisplay(blips, 4)
                SetBlipScale(blips, 1.0)
                SetBlipColour(blips, 48)
                SetBlipRoute(blips, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Lieferort")
                EndTextCommandSetBlipName(blips)
                local anzahl = 50
                while activemission do
                    local coords = GetEntityCoords(PlayerPedId())
                    Citizen.Wait(2)
                    local distances =
                        GetDistanceBetweenCoords(coords, missionzwei.x, missionzwei.y, missionzwei.z, true)
                    if distances < 10 and IsPedInAnyVehicle(player, false) then
                        Opennotify("Drücke E um deine Ware abzuliferen")
                        if IsControlJustReleased(0, 38) then
                            allowednotify = true
                            ESX.Game.DeleteVehicle(vehicles)
                            TriggerServerEvent("sevenlife:giveaccountcash", anzahl)
                            TriggerEvent("sevenliferp:closenotify", false)
                            ClearAllBlipRoutes()
                            RemoveBlip(blips)
                            nolimit = false
                            TriggerEvent("sevenlife:limit")
                            activemission = false
                        end
                    else
                        if distances >= 10.1 and distances <= 12 then
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                end
            end
        )
    end
)
RegisterNetEvent("sevenlife:limit")
AddEventHandler(
    "sevenlife:limit",
    function()
        Citizen.SetTimeout(
            1800000,
            function()
                nolimit = true
            end
        )
    end
)
RegisterNUICallback(
    "drittemission",
    function()
        Menu("removefarminghauptnui", false, false)
        Citizen.CreateThread(
            function()
                allowednotify = true
                local player = PlayerPedId()
                ESX.Game.SpawnVehicle(
                    "Packer",
                    Config.locationspawn,
                    60.91,
                    function(vehicle)
                        vehiclese = vehicle
                        TaskWarpPedIntoVehicle(player, vehicle, -1)
                        SetVehicleColours(vehicle, 112, 112)
                        SetVehicleNumberPlateText(vehicle, "MINIJOB")
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Mission",
                            "Deine Mission läuft in 15 Minuten aus",
                            3000
                        )
                        Citizen.SetTimeout(
                            Config.RentTime,
                            function()
                                ESX.Game.DeleteVehicle(vehicle)
                                PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                            end
                        )

                        Citizen.SetTimeout(
                            Config.WarningRentTime1,
                            function()
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Mission",
                                    "Deine Mission läuft in 7 Minuten aus",
                                    3000
                                )
                            end
                        )

                        Citizen.SetTimeout(
                            Config.WarningRentTime2,
                            function()
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Mission",
                                    "Deine Mission läuft in einer Minute aus",
                                    3000
                                )
                            end
                        )
                    end
                )
                ESX.Game.SpawnVehicle(
                    "docktrailer",
                    anheanger,
                    132.50,
                    function(vehicle)
                        trailer = vehicle
                        SetVehicleColours(vehicle, 112, 112)
                        SetVehicleNumberPlateText(vehicle, "MINIJOB")
                    end
                )

                allowednotify = true
                local activemission = true
                local blips = AddBlipForCoord(anheanger.x, anheanger.y)
                SetBlipSprite(blips, 479)
                SetBlipDisplay(blips, 4)
                SetBlipScale(blips, 1.0)
                SetBlipColour(blips, 48)
                SetBlipRoute(blips, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Anhänger")
                EndTextCommandSetBlipName(blips)
                TriggerEvent("sevenliferp:closenotify", false)
                while activemission do
                    local coords = GetEntityCoords(PlayerPedId())
                    Citizen.Wait(2)
                    local distancese = GetDistanceBetweenCoords(coords, anheanger.x, anheanger.y, anheanger.z, true)
                    Citizen.Wait(1000)
                    local retval, tailer = GetVehicleTrailerVehicle(GetVehiclePedIsUsing(player))
                    if distancese < 20 then
                        if retval then
                            ClearAllBlipRoutes()
                            Citizen.Wait(500)
                            TriggerEvent("sevenliferp:closenotify", false)
                            TriggerEvent("sevenlife:liferesende")
                            RemoveBlip(blips)
                            activemission = false
                        else
                            Opennotify("Kopple den Anhänger an dein LKW")
                        end
                    else
                        if distancese >= 21 and distancese <= 25 then
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                end
            end
        )
    end
)

RegisterNetEvent("sevenlife:liferesende")
AddEventHandler(
    "sevenlife:liferesende",
    function()
        allowednotify = true
        Citizen.CreateThread(
            function()
                local activemissione = true
                local player = GetPlayerPed(-1)
                local blips = AddBlipForCoord(missiondrei.x, missiondrei.y)
                SetBlipSprite(blips, 162)
                SetBlipDisplay(blips, 4)
                SetBlipScale(blips, 1.0)
                SetBlipColour(blips, 48)
                SetBlipRoute(blips, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Lieferort")
                EndTextCommandSetBlipName(blips)
                local anzahl = 100
                while activemissione do
                    local coords = GetEntityCoords(PlayerPedId())
                    Citizen.Wait(2)
                    local distances =
                        GetDistanceBetweenCoords(coords, missiondrei.x, missiondrei.y, missiondrei.z, true)
                    if distances < 10 and IsPedInAnyVehicle(player, false) then
                        Opennotify("Drücke E um deine Ware abzuliferen")
                        if IsControlJustReleased(0, 38) then
                            allowednotify = true
                            ESX.Game.DeleteVehicle(vehiclese)
                            ESX.Game.DeleteVehicle(trailer)
                            TriggerServerEvent("sevenlife:giveaccountcash", anzahl)
                            TriggerEvent("sevenliferp:closenotify", false)
                            ClearAllBlipRoutes()
                            nolimit = false
                            TriggerEvent("sevenlife:limit")
                            RemoveBlip(blips)
                            activemissione = false
                        end
                    else
                        if distances >= 10.1 and distances <= 12 then
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                end
            end
        )
    end
)
RegisterNUICallback(
    "close",
    function()
        SetNuiFocus(false, false)
        allowednotify = true
    end
)
