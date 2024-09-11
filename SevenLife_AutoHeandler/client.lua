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
local coords, heading, LastVehicle, vehiclecoords, headingToCam, types
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
        MakeBlips1("Autohändler", 225, autohaeandler.x, autohaeandler.y)
        MakeBlips2("Musclecarhändler", 530, autoheandlerimpounder.x, autoheandlerimpounder.y)
        MakeBlips3("Lkwhändler", 532, autoheandlerlkw.x, autoheandlerlkw.y)
        MakeBlips4("Luxusautohändler", 523, autohaeandlerluxus.x, autohaeandlerluxus.y)
        MakeBlips5("Boot Händler", 455, boatshop.x, boatshop.y)
        MakeBlips6("Flugzeug Händler", 585, flugzeugheandler.x, flugzeugheandler.y)
    end
)

function MakeBlips1(name, sprite, x, y)
    local blips = vector2(x, y)
    local blip1 = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blip1, sprite)
    SetBlipDisplay(blip1, 4)
    SetBlipScale(blip1, 1.0)
    SetBlipColour(blip1, 55)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip1)
end

function MakeBlips2(name, sprite, x, y)
    local blips = vector2(x, y)
    local blip2 = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blip2, sprite)
    SetBlipDisplay(blip2, 4)
    SetBlipScale(blip2, 1.0)
    SetBlipColour(blip2, 55)
    SetBlipAsShortRange(blip2, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip2)
end
function MakeBlips3(name, sprite, x, y)
    local blips = vector2(x, y)
    local blip3 = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blip3, sprite)
    SetBlipDisplay(blip3, 4)
    SetBlipScale(blip3, 1.0)
    SetBlipColour(blip3, 55)
    SetBlipAsShortRange(blip3, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip3)
end
function MakeBlips4(name, sprite, x, y)
    local blips = vector2(x, y)
    local blip4 = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blip4, sprite)
    SetBlipDisplay(blip4, 4)
    SetBlipScale(blip4, 1.0)
    SetBlipColour(blip4, 55)
    SetBlipAsShortRange(blip4, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip4)
end
function MakeBlips5(name, sprite, x, y)
    local blips = vector2(x, y)
    local blip5 = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blip5, sprite)
    SetBlipDisplay(blip5, 4)
    SetBlipScale(blip5, 1.0)
    SetBlipColour(blip5, 55)
    SetBlipAsShortRange(blip5, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip5)
end

function MakeBlips6(name, sprite, x, y)
    local blips = vector2(x, y)
    local blip6 = AddBlipForCoord(blips.x, blips.y)

    SetBlipSprite(blip6, sprite)
    SetBlipDisplay(blip6, 4)
    SetBlipScale(blip6, 1.0)
    SetBlipColour(blip6, 55)
    SetBlipAsShortRange(blip6, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip6)
end
local carshop
local notifys = true
local inmarker = false
local inmenu = false
local openshop = false
local xcoords, ycoords, zcoords
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
                        xcoords = v.x
                        ycoords = v.y
                        zcoords = v.z
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
                Citizen.Wait(500)
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
        types = "car"
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
        types = "car"
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
        types = "car"
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
        types = "car"
    elseif carshop == "boot" then
        coords = vector3(Config.lieferpos.dealerbot.x, Config.lieferpos.dealerbot.y, Config.lieferpos.dealerbot.z + 2)
        vehiclecoords =
            vector3(Config.lieferpos.dealerbot.x, Config.lieferpos.dealerbot.y, Config.lieferpos.dealerbot.z)
        heading = Config.lieferpos.dealerbot.heading
        types = "boot"
    elseif carshop == "helis" then
        coords = vector3(Config.lieferpos.helisshop.x, Config.lieferpos.helisshop.y, Config.lieferpos.helisshop.z + 2)
        vehiclecoords =
            vector3(Config.lieferpos.helisshop.x, Config.lieferpos.helisshop.y, Config.lieferpos.helisshop.z)
        heading = Config.lieferpos.helisshop.heading
        types = "heli"
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
        SpawnCar(data)
        Citizen.Wait(150)
        local maxSpeed = GetVehicleModelEstimatedMaxSpeed(data.label)
        local brake = GetVehicleMaxBraking(LastVehicle)
        local torque = GetVehicleMaxTraction(LastVehicle)
        local seatplace = GetVehicleMaxNumberOfPassengers(LastVehicle)
        local curspeed = math.floor(maxSpeed * 3.6)

        SendNUIMessage(
            {
                type = "OpenRight",
                price = data.price,
                label = data.label,
                name = data.name,
                maxSpeed = curspeed,
                brake = brake,
                torque = torque,
                seatplace = seatplace
            }
        )
    end
)
function SpawnCar(data)
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
            SetVehicleModColor_2(vehicle, 3, 0, 0)
            SetVehicleModColor_1(vehicle, 3, 0, 0)
            SetVehicleCustomSecondaryColour(vehicle, 255, 255, 255)
            SetVehicleCustomPrimaryColour(vehicle, 255, 255, 255)
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
RegisterNUICallback(
    "Raus",
    function()
        ESX.Game.DeleteVehicle(LastVehicle)
        LastVehicle = nil
        SetNuiFocus(false, false)
        SetCamActive(camara, false)
        camara = nil
        openshop = false
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
            SetNuiFocus(false, false)
            DeleteEntity(ped1)
        end
    end
)
RegisterNUICallback(
    "buyCar",
    function(data)
        ESX.Game.DeleteVehicle(LastVehicle)
        LastVehicle = nil
        SetNuiFocus(false, false)
        openshop = false
        TriggerServerEvent("SevenLife:AutoHeandler:NormalBucket")
        -- Buy
        ESX.TriggerServerCallback(
            "SevenLife:AutoHeandler:CheckIfEnoughMoney",
            function(enoughmoney)
                SetCamActive(camara, false)
                camara = nil
                RenderScriptCams(false, true, 500, true, true)
                inmenu = false
                notifys = true
                inmarker = false
                if enoughmoney then
                    ESX.Game.SpawnVehicle(
                        data.label,
                        coords,
                        heading,
                        function(vehicle)
                            local ped = GetPlayerPed(-1)
                            local id = MakeID()
                            local plate = MakePlate()

                            SetVehicleModColor_2(vehicle, 3, 0, 0)
                            SetVehicleModColor_1(vehicle, 3, 0, 0)
                            SetVehicleCustomSecondaryColour(vehicle, 255, 255, 255)
                            SetVehicleCustomPrimaryColour(vehicle, 255, 255, 255)
                            SetVehicleNumberPlateText(vehicle, plate)
                            SetPedIntoVehicle(ped, vehicle, -1)
                            local props = ESX.Game.GetVehicleProperties(vehicle)
                            TriggerServerEvent("SevenLife:AutoHeander:MakeAutoOwned", props, id, types)
                            Citizen.Wait(50)
                            openshop = false
                            inmenu = false
                            inmarker = false
                            notifys = true
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    )
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Auto Heandler", "Du Besitzt zu wenig Geld", 2000)
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

        MakePlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))

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

function MakeID()
    local MakePlate
    local doBreak = false

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())

        MakePlate = string.upper(GetRandomLetter(Config.IDLetter) .. GetRandomNumber(Config.IDNumber))

        ESX.TriggerServerCallback(
            "sevenlife:isidTaken",
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

local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_m_mexlabor_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            for k, v in pairs(Config.carshops) do
                local distance = GetDistanceBetweenCoords(PlayerCoord, v.x, v.y, v.z, true)

                Citizen.Wait(500)

                if distance < 50 then
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
                    if distance >= 50.1 and distance <= 100 then
                        pedarea = false
                    end
                end

                if pedloaded and not pedarea then
                    DeleteEntity(ped1)
                    SetModelAsNoLongerNeeded(ped1)
                    pedloaded = false
                end
            end
        end
    end
)
RegisterNUICallback(
    "ProbeFahren",
    function(data)
        local activekey = true
        local Ped = GetPlayerPed(-1)
        RequestCollisionAtCoord()
        FreezeEntityPosition(Ped, true)

        SetEntityCoords(Ped, -907.97680664063, -3195.6928710938, 12.939420700073, false, false, false, false)
        while not HasCollisionLoadedAroundEntity(Ped) do
            Citizen.Wait(0)
        end
        FreezeEntityPosition(Ped, false)

        SetNuiFocus(false, false)
        SetCamActive(camara, false)
        camara = nil
        openshop = false
        RenderScriptCams(false, true, 500, true, true)
        inmenu = false

        notifys = true

        ESX.Game.SpawnVehicle(
            data.label,
            vector3(-907.97680664063, -3195.6928710938, 12.939420700073),
            57.203807830811,
            function(vehicle)
                vehicletext = vehicle
                coords = GetEntityCoords(vehicle)
                WashDecalsFromVehicle(vehicle, 1.0)
                SetVehicleDirtLevel(vehicle, 0.0)
                SetVehicleModColor_2(vehicle, 3, 0, 0)
                SetVehicleModColor_1(vehicle, 3, 0, 0)
                SetVehicleCustomSecondaryColour(vehicle, 255, 255, 255)
                SetVehicleCustomPrimaryColour(vehicle, 255, 255, 255)
            end
        )
        Citizen.Wait(50)
        TaskWarpPedIntoVehicle(Ped, vehicletext, -1)
        Citizen.CreateThread(
            function()
                TriggerEvent(
                    "SevenLife:TimetCustom:Notify",
                    "Auto Heandler",
                    "Du hast 40 Sec zeit bis du zurück geportet wirst / Wenn du aussteigst wird die Fahrt unterbrochen",
                    2000
                )
                if activekey then
                    Citizen.Wait(40000)
                    ESX.Game.DeleteVehicle(vehicletext)
                    local Ped = GetPlayerPed(-1)
                    RequestCollisionAtCoord()
                    FreezeEntityPosition(Ped, true)

                    SetEntityCoords(Ped, xcoords, ycoords, zcoords, false, false, false, false)
                    while not HasCollisionLoadedAroundEntity(Ped) do
                        Citizen.Wait(0)
                    end
                    FreezeEntityPosition(Ped, false)
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Auto Heandler",
                        "Du wurdest wieder zurück geportet",
                        2000
                    )
                    TriggerServerEvent("SevenLife:AutoHeandler:NormalBucket")
                end
            end
        )
        Citizen.CreateThread(
            function()
                while activekey do
                    Citizen.Wait(100)
                    if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                        ESX.Game.DeleteVehicle(vehicletext)
                        local Ped = GetPlayerPed(-1)
                        RequestCollisionAtCoord()
                        FreezeEntityPosition(Ped, true)

                        SetEntityCoords(Ped, xcoords, ycoords, zcoords, false, false, false, false)
                        while not HasCollisionLoadedAroundEntity(Ped) do
                            Citizen.Wait(0)
                        end
                        FreezeEntityPosition(Ped, false)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Auto Heandler",
                            "Du wurdest wieder zurück geportet",
                            2000
                        )
                        activekey = false
                        TriggerServerEvent("SevenLife:AutoHeandler:NormalBucket")
                    end
                end
            end
        )
    end
)
