ESX = nil

local ingaragerange = false
local notifys = true
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
local inmenu = false
local pedloaded = false

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
                Config.LocationSchwarzMarkt.x,
                Config.LocationSchwarzMarkt.y,
                Config.LocationSchwarzMarkt.z,
                true
            )

            if inmenu == false then
                if distance < 1.5 then
                    ingaragerange = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Schwarzmarkt zu öffnen",
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
                        ESX.TriggerServerCallback(
                            "SevenLife:SchwarzMarkt:GetData",
                            function(money)
                                inmenu = true
                                notifys = false
                                TriggerScreenblurFadeIn(3000)
                                SetNuiFocus(true, true)
                                TriggerEvent("sevenliferp:closenotify", false)
                                SendNUIMessage(
                                    {
                                        type = "OpenSchwarzMarkt",
                                        money = money
                                    }
                                )
                                Citizen.Wait(200)
                                RemoveHUD()
                            end
                        )
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
                Config.LocationSchwarzMarkt.x,
                Config.LocationSchwarzMarkt.y,
                Config.LocationSchwarzMarkt.z,
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
                        Config.LocationSchwarzMarkt.x,
                        Config.LocationSchwarzMarkt.y,
                        Config.LocationSchwarzMarkt.z,
                        Config.LocationSchwarzMarkt.heading,
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
    "Escape",
    function()
        SetNuiFocus(false, false)
        TriggerScreenblurFadeOut(3000)
        inmenu = false
        ingaragerange = false
        notifys = true
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

function RemoveHUD()
    while inmenu do
        Citizen.Wait(1)
        DisplayRadar(false)
    end
end

local function SpawnCar(model)
    local player = GetPlayerPed(-1)
    ESX.Game.SpawnVehicle(
        model,
        Config.SpawnCar,
        269.28,
        function(vehicles)
            SetVehRadioStation(vehicles, "OFF")
            TaskWarpPedIntoVehicle(player, vehicles, -1)
            Citizen.Wait(50)
            TriggerEvent("sevenliferp:closenotify", false)

            TriggerEvent(
                "SevenLife:TimetCustom:Notify",
                "Success",
                "Auto erfolgreich gekauft. Auto nach restart nicht mehr Verfügbar",
                3000
            )
            SetVehicleNumberPlateText(vehicles, "  ")
            inmenu = false
            notifys = true
            SetNuiFocus(false, false)
            Citizen.Wait(1000)
            exports["SevenLife_Fuel"]:SetFuel(vehicles, 100)
        end
    )
end

RegisterNUICallback(
    "MakeItem",
    function(data)
        local anzahl
        if tonumber(data.anzahl) == 0 then
            anzahl = 1
        end
        if data.itemtype == "item" then
            ESX.TriggerServerCallback(
                "SevenLife:SchwarzMarkt:GetMoney",
                function(money)
                    if tonumber(money) >= tonumber(data.preis * anzahl) then
                        TriggerServerEvent("SevenLife:SchwarzMarkt:GivesItem", tonumber(data.preis), anzahl, data.name)
                    end
                end
            )
        elseif data.itemtype == "car" then
            SpawnCar(data.name)
        end
    end
)

RegisterNetEvent("SevenLife:Weapon:AddMuniSmall")
AddEventHandler(
    "SevenLife:Weapon:AddMuniSmall",
    function()
        local ped = GetPlayerPed(-1)

        local weapon = GetSelectedPedWeapon(ped)
        if weapon ~= nil then
            if weapon == 453432689 then
                TriggerServerEvent("SevenLife:Weapon:GiveWeaponItem", "WEAPON_PISTOL", 19)
            elseif weapon == 2578377531 then
                TriggerServerEvent("SevenLife:Weapon:GiveWeaponItem", "WEAPON_PISTOL50", 19)
            else
                TriggerEvent(
                    "SevenLife:TimetCustom:Notify",
                    "Waffe",
                    "Diese Munition ist nicht für diese Waffe gemacht",
                    3000
                )
            end
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Waffe", "Du musst die Waffe in der Hand Halten", 3000)
        end
    end
)
RegisterNetEvent("SevenLife:Weapon:AddMuniBig")
AddEventHandler(
    "SevenLife:Weapon:AddMuniBig",
    function()
        local ped = GetPlayerPed(-1)

        local weapon = GetSelectedPedWeapon(ped)
        if weapon ~= nil then
            if weapon == -1074790547 then
                TriggerServerEvent("SevenLife:Weapon:GiveWeaponItem", "WEAPON_ASSAULTRIFLE", 30)
            else
                TriggerEvent(
                    "SevenLife:TimetCustom:Notify",
                    "Waffe",
                    "Diese Munition ist nicht für diese Waffe gemacht",
                    3000
                )
            end
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Waffe", "Du musst die Waffe in der Hand Halten", 3000)
        end
    end
)
local currentGear = {
    mask = 0,
    tank = 0,
    oxygen = 0,
    enabled = false
}

RegisterNetEvent("TaucherAnzugAnziehen")
AddEventHandler(
    "TaucherAnzugAnziehen",
    function()
        local ped = GetPlayerPed(-1)
        local maskModel = "p_d_scuba_mask_s"
        local tankModel = "p_s_scuba_tank_s"
        RequestModel(tankModel)
        while not HasModelLoaded(tankModel) do
            Wait(0)
        end
        currentGear.tank = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
        local bone1 = GetPedBoneIndex(ped, 24818)
        AttachEntityToEntity(currentGear.tank, ped, bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)

        RequestModel(maskModel)
        while not HasModelLoaded(maskModel) do
            Wait(0)
        end
        currentGear.mask = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
        local bone2 = GetPedBoneIndex(ped, 12844)
        AttachEntityToEntity(currentGear.mask, ped, bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
        SetEnableScuba(ped, true)
        SetPedMaxTimeUnderwater(ped, 2000.00)
        currentGear.enabled = true
    end
)
