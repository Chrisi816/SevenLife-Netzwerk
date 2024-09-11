-- Variables
local time = 200
local timebetweenchecking = 200
local AllowSevenNotify = true
local inarea = false
local OpenMenu = false
local inmarker = false
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
    end
)

-- Local Start
Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        MakeMaklerBLips()
        while true do
            Citizen.Wait(time)
            local ped = GetPlayerPed(-1)
            local coordofped = GetEntityCoords(ped)
            local distance =
                GetDistanceBetweenCoords(coordofped, Config.TankeKauf.x, Config.TankeKauf.y, Config.TankeKauf.z, true)
            if distance < 20 then
                time = 110
                inarea = true
                if distance < 2 then
                    if AllowSevenNotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um den Katalog zu begutachten",
                            "System-Nachricht",
                            true
                        )
                    end
                    inmarker = true
                else
                    if distance >= 2.1 and distance <= 3 then
                        TriggerEvent("sevenliferp:closenotify", false)
                        inmarker = false
                    end
                end
            else
                inarea = false
                time = 200
            end
        end
    end
)
-- KeyCheck
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timebetweenchecking)
            if inarea then
                timebetweenchecking = 20
                if inmarker and not OpenMenu then
                    if IsControlJustPressed(0, 38) then
                        OpenMenu = true
                        AllowSevenNotify = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        ESX.TriggerServerCallback(
                            "SevenLife:GetTankeInfos",
                            function(shopsdetails)
                                SetNuiFocus(true, true)
                                SendNUIMessage(
                                    {
                                        type = "openTankeBuyNUI",
                                        result = shopsdetails
                                    }
                                )
                            end
                        )
                    end
                end
            else
                timebetweenchecking = 200
            end
        end
    end
)

function MakeMaklerBLips()
    local blips = vector2(Config.TankeKauf.x, Config.TankeKauf.y)
    local blip = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blip, 350)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 25)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Tankstellen Makler")
    EndTextCommandSetBlipName(blip)
end

RegisterNUICallback(
    "buytanke",
    function(data)
        SetNuiFocus(false, false)
        OpenMenu = false
        AllowSevenNotify = true
        TriggerServerEvent("sevenlife:buytanke", data.id)
    end
)

RegisterNUICallback(
    "location",
    function(data)
        SetNuiFocus(false, false)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Makler", "Shop Location ist auf deiner Map markiert", 2000)

        OpenMenu = false
        AllowSevenNotify = true

        for k, va in pairs(Config.Tankstellens) do
            Citizen.Wait(1)
            if tonumber(va.Pos.tanknumber) == tonumber(data.id) then
                blips = AddBlipForCoord(vector3(va.Pos.x, va.Pos.y, va.Pos.z))
                SetBlipSprite(blips, 40)
                SetBlipDisplay(blips, 4)
                SetBlipScale(blips, 0.9)
                SetBlipColour(blips, 76)
                SetBlipRoute(blips, true)
                SetBlipRouteColour(blips, 76)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Shop Location")
                EndTextCommandSetBlipName(blips)
            end
        end

        Citizen.Wait(6000)
        ClearAllBlipRoutes()
        RemoveBlip(blips)
    end
)
RegisterNUICallback(
    "rauses",
    function()
        SetNuiFocus(false, false)
        OpenMenu = false
        AllowSevenNotify = true
    end
)

local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance =
                GetDistanceBetweenCoords(PlayerCoord, Config.TankeKauf.x, Config.TankeKauf.y, Config.TankeKauf.z, true)

            Citizen.Wait(500)

            if distance < 30 then
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
                        Config.TankeKauf.x,
                        Config.TankeKauf.y,
                        Config.TankeKauf.z,
                        Config.TankeKauf.heading,
                        false,
                        true
                    )
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
)
