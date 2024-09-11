--------------------------------------------------------------------------------------------------------------
---------------------------------------------Variables--------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
local inmenu = false
local timemain = 100
local inmarker = false
local activenotify = true
local flytext = false
local CurrentZoneType = nil
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
            Citizen.Wait(10)
        end
    end
)

--------------------------------------------------------------------------------------------------------------
------------------------------------------------Start---------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        MakeFlyLicense("Flug Lizenz", 251, 58, Config.FlyLicense.x, Config.FlyLicense.y)
        SpawnNPCverarbeiter()
    end
)

--------------------------------------------------------------------------------------------------------------
-----------------------------------------Blip Spawner function------------------------------------------------
--------------------------------------------------------------------------------------------------------------
function MakeFlyLicense(name, sprite, color, x, y)
    local blips = vector2(x, y)
    local blip = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 61)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

--------------------------------------------------------------------------------------------------------------
-----------------------------------------Npc Spawner function-------------------------------------------------
--------------------------------------------------------------------------------------------------------------
function SpawnNPCverarbeiter()
    local pednumber = tonumber(1)
    for i = 1, pednumber do
        local NpcSpawner = vector3(Config.FlyLicense.x, Config.FlyLicense.y, Config.FlyLicense.z)
        local ped = GetHashKey("cs_floyd")
        if not HasModelLoaded(ped) then
            RequestModel(ped)
            while not HasModelLoaded(ped) do
                Citizen.Wait(1)
            end
            ped1 = CreatePed(8, ped, NpcSpawner.x, NpcSpawner.y, NpcSpawner.z, Config.FlyLicense.heading, true, false)
            SetEntityInvincible(ped1, true)
            FreezeEntityPosition(ped1, true)
            SetBlockingOfNonTemporaryEvents(ped1, true)
        end
    end
end
--------------------------------------------------------------------------------------------------------------
----------------------------------------------Start Locale----------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)
            local distance =
                GetDistanceBetweenCoords(coord, Config.FlyLicense.x, Config.FlyLicense.y, Config.FlyLicense.z, true)
            if distance < 20 then
                timemain = 10
                if distance < 2 then
                    inmarker = true
                    if activenotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um das Licensen Menü zu öffnen",
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
                timemain = 100
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
----------------------------------------------Keys Check------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    ESX.TriggerServerCallback(
                        "SevenLife:TestFly:CheckIfPlayerHaveTheorie",
                        function(theorie)
                            if theorie then
                                ESX.TriggerServerCallback(
                                    "SevenLife:HavePractical",
                                    function(practical)
                                        if practical then
                                            SetNuiFocus(true, true)
                                            inmenu = true
                                            activenotify = false
                                            TriggerEvent("sevenliferp:closenotify", false)
                                            timemain = 2000
                                            time = 2000
                                            SendNUIMessage(
                                                {
                                                    type = "OpenNuiFlyLicensePractical",
                                                    theorie = true
                                                }
                                            )
                                        else
                                            TriggerEvent(
                                                "SevenLife:TimetCustom:Notify",
                                                "Lizenzen",
                                                "Du hast deine Lizenz schon",
                                                2000
                                            )
                                        end
                                    end
                                )
                            else
                                SetNuiFocus(true, true)
                                inmenu = true
                                activenotify = false
                                TriggerEvent("sevenliferp:closenotify", false)
                                timemain = 2000
                                time = 2000
                                SendNUIMessage(
                                    {
                                        type = "OpenNuiFlyLicenseTeorie",
                                        theorie = false
                                    }
                                )
                            end
                        end
                    )
                end
            end
        end
    end
)
--------------------------------------------------------------------------------------------------------------
----------------------------------------------Hud remove------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
function Removenormalhud()
    Citizen.CreateThread(
        function()
            while inmenu do
                Citizen.Wait(1)
                DisplayRadar(false)
                TriggerEvent("sevenlife:removeallhud")
            end
        end
    )
end

--------------------------------------------------------------------------------------------------------------
----------------------------------------------Close function------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "CloseMenufly",
    function()
        inmenu = false
        SetNuiFocus(false, false)
        activenotify = true
        openmenu = false
        Citizen.Wait(50)
        DisplayRadar(true)
    end
)
--------------------------------------------------------------------------------------------------------------
----------------------------------------Quastion Handle System------------------------------------------------
--------------------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "MakeQuestion",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Pay:HaveEnoughMoney",
            function(enoughmoney)
                if enoughmoney then
                    TriggerServerEvent("SevenLife:Pay:FlyLicense")
                    SendNUIMessage(
                        {
                            type = "startquestions"
                        }
                    )
                else
                    SetNuiFocus(false, false)
                    SendNUIMessage(
                        {
                            type = "RemoveNuiflylicense"
                        }
                    )
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Lizenzen", "Du hast zu wenig Geld", 2000)
                end
            end
        )
    end
)
--------------------------------------------------------------------------------------------------------------
----------------------..........------------------License-----------------------------------------------------
--------------------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "GiveLicense",
    function()
        inmenu = false
        SetNuiFocus(false, false)
        activenotify = true
        openmenu = false
        Citizen.Wait(50)
        DisplayRadar(true)
        TriggerServerEvent("SevenLife:Lizenzen:GiveLizenzenTheoretival")
    end
)
--------------------------------------------------------------------------------------------------------------
----------------------..........------------------Rause-----------------------------------------------------
--------------------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "raus",
    function()
        inmenu = false
        SetNuiFocus(false, false)
        activenotify = true
        openmenu = false
        Citizen.Wait(50)
        DisplayRadar(true)
    end
)
--------------------------------------------------------------------------------------------------------------
-----------------------------------------------------Practical start------------------------------------------
--------------------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "MakePractical",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Pay:HasEnoughMoneyForePractical",
            function(enoguh)
                if enoguh then
                    flytext = true
                    startflytext()

                    Citizen.Wait(100)
                    activenotify = true
                    inmenu = false
                    SetNuiFocus(false, false)
                    inmarker = false

                    TriggerEvent("sevenliferp:closenotify", false)
                    TriggerEvent("SevenLife:FlyTest:Practical")
                    TriggerEvent("SevenLife:Practical:CheckDemage")
                    TriggerServerEvent("SevenLife:Pay:Practical")
                else
                    activenotify = true
                    inmenu = false
                    inmarker = false
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Lizenzen", "Du hast zu wenig Geld", 2000)
                end
            end
        )
    end
)

RegisterNetEvent("SevenLife:Practical:CheckDemage")
AddEventHandler(
    "SevenLife:Practical:CheckDemage",
    function()
        Citizen.CreateThread(
            function()
                while flytext do
                    Citizen.Wait(10)

                    local playerPed = PlayerPedId()

                    if IsPedInAnyVehicle(playerPed, false) then
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        local health = GetEntityHealth(vehicle)
                        if health < LastVehicleHealth then
                            FlyErrors = FlyErrors + 1
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Lizenzen",
                                "Du hast " ..
                                    FlyErrors ..
                                        "von 3 Fehler Punkten, solltest du mehr als 3 haben, hast du die Prüfung automatisch verkackt",
                                2000
                            )
                            LastVehicleHealth = health
                            Citizen.Wait(1500)
                        end
                    end
                end
            end
        )
    end
)

function startflytext()
    TriggerEvent("sevenliferp:closenotify", false)
    ESX.Game.SpawnVehicle(
        Config.FlySpawn,
        Config.flypoint.coords,
        Config.flypoint.heading,
        function(vehicle)
            SetVehicleNumberPlateText(vehicle, "Chrisibest")
            flytext = true
            CurrentTestType = type
            ActuallCheckPoint = 0
            LastCheckPoint = -1
            CurrentZoneType = "residence"
            FlyErrors = 0
            CurrentVehicle = vehicle
            LastVehicleHealth = GetEntityHealth(vehicle)

            local playerPed = PlayerPedId()
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        end
    )
end

RegisterNetEvent("SevenLife:FlyTest:Practical")
AddEventHandler(
    "SevenLife:FlyTest:Practical",
    function()
        Citizen.CreateThread(
            function()
                while flytext do
                    Citizen.Wait(5)
                    local ped = GetPlayerPed(-1)
                    local coordsofped = GetEntityCoords(ped)
                    local nextcheckpoints = ActuallCheckPoint + 1

                    if Config.CheckPoints[nextcheckpoints] == nil then
                        if DoesBlipExist(CurrentBlip) then
                            RemoveBlip(CurrentBlip)
                        end

                        flytext = false

                        if FlyErrors < 3 then
                            RemoveBlip(CurrentBlip)
                            SetEntityCoords(ped, Config.flypoint.coords, false, false, false, false)
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Lizenzen",
                                "Herzlichen Glückwunsch du hast die Prüfung bestanden",
                                2000
                            )

                            CurrentTest = nil
                            CurrentTestType = nil
                            ESX.Game.DeleteVehicle(CurrentVehicle)

                            TriggerServerEvent("SevenLife:FlyLicenses:GiveLicense")
                        else
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Lizenzen",
                                "Du hattest leider zu viele Fehlerpunkte, weshalb du nicht bestanden hast",
                                2000
                            )
                            CurrentTest = nil
                            CurrentTestType = nil
                        end
                    else
                        if ActuallCheckPoint ~= LastCheckPoint then
                            if DoesBlipExist(CurrentBlip) then
                                RemoveBlip(CurrentBlip)
                            end

                            CurrentBlip =
                                AddBlipForCoord(
                                Config.CheckPoints[nextcheckpoints].Pos.x,
                                Config.CheckPoints[nextcheckpoints].Pos.y,
                                Config.CheckPoints[nextcheckpoints].Pos.z
                            )

                            SetBlipRoute(CurrentBlip, 90)

                            LastCheckPoint = ActuallCheckPoint
                        end
                        local distance =
                            GetDistanceBetweenCoords(
                            coordsofped,
                            Config.CheckPoints[nextcheckpoints].Pos.x,
                            Config.CheckPoints[nextcheckpoints].Pos.y,
                            Config.CheckPoints[nextcheckpoints].Pos.z,
                            true
                        )

                        if distance <= 7000.0 then
                            DrawMarker(
                                7,
                                Config.CheckPoints[nextcheckpoints].Pos.x,
                                Config.CheckPoints[nextcheckpoints].Pos.y,
                                Config.CheckPoints[nextcheckpoints].Pos.z,
                                0.0,
                                0.0,
                                0.0,
                                0,
                                0.0,
                                0.0,
                                20.5,
                                20.5,
                                20.5,
                                171,
                                62,
                                243,
                                100,
                                false,
                                true,
                                2,
                                false,
                                false,
                                false,
                                false
                            )
                        end
                        if distance <= 17.0 then
                            Config.CheckPoints[nextcheckpoints].Action(CurrentVehicle)
                            ActuallCheckPoint = ActuallCheckPoint + 1
                        end
                    end
                end
            end
        )
    end
)
