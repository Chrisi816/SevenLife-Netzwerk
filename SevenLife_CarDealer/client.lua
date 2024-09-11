ESX = nil
Citizen.CreateThread(
    function()
        while not ESX do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(500)
        end
    end
)
local coords, heading, LastVehicle, vehiclecoords, headingToCam
local autohaeandler =
    vector3(Config.carshops.cardealernormal.x, Config.carshops.cardealernormal.y, Config.carshops.cardealernormal.z)
local autoheandlerimpounder =
    vector3(
    Config.carshops.cardealerimpounder.x,
    Config.carshops.cardealerimpounder.y,
    Config.carshops.cardealerimpounder.z
)
local autoheandlerlkw =
    vector3(Config.carshops.cardealerlkw.x, Config.carshops.cardealerlkw.y, Config.carshops.cardealerlkw.z)
local autohaeandlerluxus =
    vector3(Config.carshops.cardealerluxus.x, Config.carshops.cardealerluxus.y, Config.carshops.cardealerluxus.z)

local boatshop = vector3(Config.carshops.dealerbot.x, Config.carshops.dealerbot.y, Config.carshops.dealerbot.z)
local flugzeugheandler = vector3(Config.carshops.helisshop.x, Config.carshops.helisshop.y, Config.carshops.helisshop.z)

Citizen.CreateThread(
    function()
        MakeBlips("Autohändler", 225, autohaeandler.x, autohaeandler.y)
        MakeBlips("Musclecarhändler", 530, autoheandlerimpounder.x, autoheandlerimpounder.y)
        MakeBlips("Lkwhändler", 532, autoheandlerlkw.x, autoheandlerlkw.y)
        MakeBlips("Luxusautohändler", 523, autohaeandlerluxus.x, autohaeandlerluxus.y)
        MakeBlips("Boot Händler", 455, boatshop.x, boatshop.y)
        MakeBlips("Flugzeug Händler", 585, flugzeugheandler.x, flugzeugheandler.y)
    end
)

function MakeBlips(name, sprite, x, y)
    local blips = vector2(x, y)
    local blip = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 55)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

local carshop
local notifys = true
local inmarker = false
local inmenu = false
local openshop = false
Citizen.CreateThread(
    function()
        while true do
            local player = GetPlayerPed(-1)
            if openshop == false then
                Citizen.Wait(150)
                for k, v in pairs(Config.carshops) do
                    local coords = GetEntityCoords(player)
                    local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                    if distance < 2 then
                        carshop = v.dealer
                        inmarker = true
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke E um den Händler zu begutachten",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 2.1 and distance <= 5 then
                            inmarker = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                end
            else
                Citizen.Wait(5000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        local name
                        openshop = true
                        if carshop == "normal" then
                            name = "Normaler Auto"
                        elseif carshop == "impounder" then
                            name = "Muscle Auto"
                        elseif carshop == "lkw" then
                            name = "LKW Auto"
                        elseif carshop == "luxus" then
                            name = "Luxus Auto"
                        elseif carshop == "boot" then
                            name = "Normaler Boot"
                        elseif carshop == "helis" then
                            name = "Normaler Heli"
                        end
                        ESX.TriggerServerCallback(
                            "SevenLife:Cars:GetCarsForValue",
                            function(resultcars)
                                SetNuiFocus(true, true)
                                SendNUIMessage(
                                    {
                                        type = "OpenNuiCarShop",
                                        resultcars = resultcars,
                                        name = name
                                    }
                                )
                                EnableCam()
                            end,
                            carshop
                        )
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

function EnableCam()
    if carshop == "normal" then
        coords =
            vector3(
            Config.lieferpos.cardealernormal.x,
            Config.lieferpos.cardealernormal.y,
            Config.lieferpos.cardealernormal.z + 2
        )
        vehiclecoords =
            vector3(
            Config.lieferpos.cardealernormal.x,
            Config.lieferpos.cardealernormal.y,
            Config.lieferpos.cardealernormal.z
        )
    elseif carshop == "impounder" then
        coords =
            vector3(
            Config.lieferpos.cardealerimpounder.x,
            Config.lieferpos.cardealerimpounder.y,
            Config.lieferpos.cardealerimpounder.z + 2
        )
        vehiclecoords =
            vector3(
            Config.lieferpos.cardealerimpounder.x,
            Config.lieferpos.cardealerimpounder.y,
            Config.lieferpos.cardealerimpounder.z
        )
        heading = Config.lieferpos.cardealerimpounder.heading
    elseif carshop == "lkw" then
        coords =
            vector3(
            Config.lieferpos.cardealerlkw.x,
            Config.lieferpos.cardealerlkw.y,
            Config.lieferpos.cardealerlkw.z + 2
        )
        vehiclecoords =
            vector3(Config.lieferpos.cardealerlkw.x, Config.lieferpos.cardealerlkw.y, Config.lieferpos.cardealerlkw.z)
        heading = Config.lieferpos.cardealerlkw.heading
    elseif carshop == "luxus" then
        coords =
            vector3(
            Config.lieferpos.cardealerluxus.x,
            Config.lieferpos.cardealerluxus.y,
            Config.lieferpos.cardealerluxus.z + 2
        )
        vehiclecoords =
            vector3(
            Config.lieferpos.cardealerluxus.x,
            Config.lieferpos.cardealerluxus.y,
            Config.lieferpos.cardealerluxus.z
        )
        heading = Config.lieferpos.cardealerluxus.heading
    elseif carshop == "boot" then
        coords = vector3(Config.lieferpos.dealerbot.x, Config.lieferpos.dealerbot.y, Config.lieferpos.dealerbot.z + 2)
        vehiclecoords =
            vector3(Config.lieferpos.dealerbot.x, Config.lieferpos.dealerbot.y, Config.lieferpos.dealerbot.z)
        heading = Config.lieferpos.dealerbot.heading
    elseif carshop == "helis" then
        coords = vector3(Config.lieferpos.helisshop.x, Config.lieferpos.helisshop.y, Config.lieferpos.helisshop.z + 2)
        vehiclecoords =
            vector3(Config.lieferpos.helisshop.x, Config.lieferpos.helisshop.y, Config.lieferpos.helisshop.z)
        heading = Config.lieferpos.helisshop.heading
    end

    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(camara, false)
    if (not DoesCamExist(camara)) then
        camara = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(camara, true)
        RenderScriptCams(true, false, 0, true, true)
        SetCamCoord(camara, coords)
    end
    headingToCam = GetEntityHeading(PlayerPedId()) + 90
end
RegisterNUICallback(
    "SpawnCar",
    function(data)
        ESX.Game.DeleteVehicle(LastVehicle)
        ESX.Game.SpawnVehicle(
            data.label,
            vehiclecoords,
            heading,
            function(vehicle)
                if LastVehicle == nil then
                    EnableCam()
                end
                LastVehicle = vehicle
                coords = GetEntityCoords(vehicle)
                WashDecalsFromVehicle(vehicle, 1.0)
                SetVehicleDirtLevel(vehicle, 0.0)
                -- Cam
                local camPos = GetCamCoord(camara)
                local headings = headingToCam
                headings = headings + 2.5
                headingToCam = headings
                local cx, cy = GetPositionByRelativeHeading(LastVehicle, headings, 6)
                SetCamCoord(camara, cx, cy, camPos.z)
                PointCamAtCoord(camara, coords.x, coords.y, camPos.z)
            end
        )
    end
)
RegisterNUICallback(
    "Raus",
    function()
        ESX.Game.DeleteVehicle(LastVehicle)
        LastVehicle = nil
        SetNuiFocus(false, false)
        SetCamActive(camara, false)
        camara = nil
        RenderScriptCams(false, true, 500, true, true)
        inmenu = false
        TriggerServerEvent("SevenLife:AutoHeandler:NormalBucket")
        notifys = true
    end
)

RegisterNUICallback(
    "rotationleft",
    function(data)
        local pedPos = GetEntityCoords(LastVehicle)
        local camPos = GetCamCoord(camara)
        local headings = headingToCam
        headings = headings + 2.5
        headingToCam = headings
        local cx, cy = GetPositionByRelativeHeading(LastVehicle, headings, 6)
        SetCamCoord(camara, cx, cy, camPos.z)
        PointCamAtCoord(camara, pedPos.x, pedPos.y, camPos.z)
    end
)
RegisterNUICallback(
    "rotationright",
    function(data)
        local pedPos = GetEntityCoords(LastVehicle)
        local camPos = GetCamCoord(camara)
        local headings = headingToCam
        headings = headings - 2.5
        headingToCam = headings
        local cx, cy = GetPositionByRelativeHeading(LastVehicle, headings, 6)
        SetCamCoord(camara, cx, cy, camPos.z)
        PointCamAtCoord(camara, pedPos.x, pedPos.y, camPos.z)
    end
)

function GetPositionByRelativeHeading(ped, head, dist)
    local pedPos = GetEntityCoords(ped)

    local finPosx = pedPos.x + math.cos(head * (math.pi / 180)) * dist
    local finPosy = pedPos.y + math.sin(head * (math.pi / 180)) * dist

    return finPosx, finPosy
end

AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if resourceName == GetCurrentResourceName() then
            ESX.Game.DeleteVehicle(LastVehicle)
        end
    end
)
