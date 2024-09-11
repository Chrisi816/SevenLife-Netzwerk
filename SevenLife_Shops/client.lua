local activeblip = {}
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

Citizen.CreateThread(
    function()
        Citizen.Wait(500)
        CreateBlipse(Config.logistik.Pos.x, Config.logistik.Pos.y, Config.logistik.Pos.z, "Logistik-Zentrum", 85, 61)
        CreateBlipse(Config.markler.Pos.x, Config.markler.Pos.y, Config.markler.Pos.z, "Shop Makler", 350, 25)
        TriggerServerEvent("sevenlife:ownedshopblipse")
        TriggerServerEvent("sevenlife:normalshopblips")
    end
)
function CreateNormalshopBlips(blips)
    for i = 1, #blips, 1 do
        for k, v in pairs(Config.Zones) do
            if v.Pos.number == blips[i].ShopNumber then
                local blip = AddBlipForCoord(vector3(v.Pos.x, v.Pos.y, v.Pos.z))
                SetBlipSprite(blip, 52)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.9)
                SetBlipColour(blip, 76)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Geschlossene Shops")
                EndTextCommandSetBlipName(blip)
                table.insert(activeblip, blip)
            end
        end
    end
end
function CreateshopBlip(blips)
    for i = 1, #blips, 1 do
        for k, v in pairs(Config.Zones) do
            if v.Pos.number == blips[i].ShopNumber then
                local blip = AddBlipForCoord(vector3(v.Pos.x, v.Pos.y, v.Pos.z))
                SetBlipSprite(blip, 52)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.9)
                SetBlipColour(blip, 25)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Shops")
                EndTextCommandSetBlipName(blip)
                table.insert(activeblip, blip)
            end
        end
    end
end
function CreateBlipse(x, y, z, name, sprite, colour)
    local blip = AddBlipForCoord(vector3(x, y, z))
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end
local allowednotify = true
local inmarker = false
local inmenu = false
local allowednotifys = true
Citizen.CreateThread(
    function()
        Citizen.Wait(20)

        while true do
            player = GetPlayerPed(-1)
            Citizen.Wait(200)
            for k, v in pairs(Config.Zones) do
                local coords = GetEntityCoords(player)
                local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)
                if distance < 2 then
                    inmarker = true
                    shop = v.Pos.number
                    if allowednotifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Shop zu begutachten",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.1 and distance <= 6.5 then
                        inmarker = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    end
)
RegisterNetEvent("SevenLife:Shops:NoShop")
AddEventHandler(
    "SevenLife:Shops:NoShop",
    function()
        SetNuiFocus(false, false)
        allowednotifys = true
        inmenu = false
    end
)
Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        while true do
            Citizen.Wait(1)
            if inmarker then
                if IsControlJustReleased(0, 38) then
                    if inmenu == false then
                        Citizen.Wait(100)
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        allowednotifys = false
                        TriggerServerEvent("sevenlife:checkifownedshop", shop)
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
RegisterNetEvent("sevenlife:givetimednachrichtshop")
AddEventHandler(
    "sevenlife:givetimednachrichtshop",
    function(nachricht)
        allowednotify = false
        TriggerEvent("sevenliferp:closenotify", false)
        Citizen.Wait(200)
        TriggerEvent("sevenliferp:startnui", nachricht, "System - Nachricht", true)
        Citizen.Wait(3000)
        TriggerEvent("sevenliferp:closenotify", false)
        allowednotify = true
        inmenus = false
    end
)
RegisterNetEvent("sevenlife:shopdetails")
AddEventHandler(
    "sevenlife:shopdetails",
    function(shop, value, quali)
        ESX.TriggerServerCallback(
            "sevenlife:getshopitems",
            function(shopsdetail)
                local items = {}
                for key, value in pairs(shopsdetail) do
                    if shopsdetail[key].count <= 0 then
                        shopsdetail[key] = nil
                    else
                        shopsdetail[key].type = "item_standard"
                        table.insert(items, shopsdetail[key])
                    end
                end
                SetNuiFocus(true, true)
                SendNUIMessage(
                    {
                        type = "openshopnui",
                        result = items,
                        id = shop,
                        preis = value,
                        quali = quali
                    }
                )
            end,
            shop
        )
    end
)
RegisterNUICallback(
    "close",
    function()
        SetNuiFocus(false, false)
        allowednotifys = true
        inmenu = false
    end
)

RegisterNetEvent("sevenlife:opennuikaufen")
AddEventHandler(
    "sevenlife:opennuikaufen",
    function(event, bool, boolean)
        SetNuiFocus(bool, boolean)
        SendNUIMessage(
            {
                type = event
            }
        )
    end
)
local inkmarkers = false
Citizen.CreateThread(
    function()
        Citizen.Wait(1000)

        while true do
            player = GetPlayerPed(-1)
            Citizen.Wait(250)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(coords, Config.markler.Pos.x, Config.markler.Pos.y, Config.markler.Pos.z, true)
            if distance < 2 then
                inkmarkers = true
                if allowednotify then
                    TriggerEvent(
                        "sevenliferp:startnui",
                        "Drücke <span1 color = white>E</span1> um die Aktuellen Angebote zu begutachten",
                        "System - Nachricht",
                        true
                    )
                end
            else
                if distance >= 2.1 and distance <= 5 then
                    inkmarkers = false
                    TriggerEvent("sevenliferp:closenotify", false)
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(1)
            if inkmarkers then
                if IsControlJustReleased(0, 38) then
                    if inmenu == false then
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        allowednotify = false
                        ESX.TriggerServerCallback(
                            "SevenLife:Shops:GetShopsAv",
                            function(shopsdetails)
                                SetNuiFocus(true, true)
                                SendNUIMessage(
                                    {
                                        type = "OpenShopBuy",
                                        result = shopsdetails
                                    }
                                )
                            end,
                            shop
                        )
                    end
                end
            else
                Citizen.Wait(500)
            end
        end
    end
)

RegisterNUICallback(
    "location",
    function(data)
        SetNuiFocus(false, false)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Makler", "Shop Location ist auf deiner Map markiert", 2000)
        allowednotify = true
        inmenu = false

        for k, va in pairs(Config.Zones) do
            Citizen.Wait(1)
            if va.Pos.locations == data.id then
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
RegisterNetEvent("sevenlife:opennuikaufens")
AddEventHandler(
    "sevenlife:opennuikaufens",
    function(event, bool, boolean)
        SetNuiFocus(bool, boolean)
        SendNUIMessage(
            {
                type = event
            }
        )
    end
)

RegisterNUICallback(
    "buyshop",
    function(data)
        TriggerServerEvent("sevenlife:shopkauf", data.id)
    end
)

RegisterNetEvent("sevenlife:entfernallese")
AddEventHandler(
    "sevenlife:entfernallese",
    function()
        TriggerEvent("sevenlife:opennuikaufens", "removehobbuynui", false, false)
        allowednotify = true
        inmenu = false
    end
)
RegisterNetEvent("sevenlife:addblibsyeas")
AddEventHandler(
    "sevenlife:addblibsyeas",
    function()
        ESX.TriggerServerCallback(
            "sevenlife:ownedshopblips",
            function(blips)
                if blips ~= nil then
                    CreateshopBlip(blips)
                end
            end
        )
        ESX.TriggerServerCallback(
            "sevenlife:getnormalshopblips",
            function(blips)
                if blips ~= nil then
                    CreateNormalshopBlips(blips)
                end
            end
        )
    end
)
RegisterNetEvent("sevenlife:removeblipses")
AddEventHandler(
    "sevenlife:removeblipses",
    function()
        for i = 1, #activeblip do
            RemoveBlip(activeblip[i])
        end
    end
)
RegisterNetEvent("sevenlife:givetimednachrichts")
AddEventHandler(
    "sevenlife:givetimednachrichts",
    function(nachricht)
        allowednotify = false
        TriggerEvent("sevenliferp:closenotify", false)
        Citizen.Wait(200)
        TriggerEvent("sevenliferp:startnui", nachricht, "System - Nachricht", true)
        Citizen.Wait(3000)
        TriggerEvent("sevenliferp:closenotify", false)
        allowednotify = true
    end
)
RegisterNUICallback(
    "BuyItems",
    function(data)
        TriggerServerEvent("SevenLife:Shops:Buy", shop, data.Item, data.Count, data.preis)
    end
)
local inkmarkerse = false
inmenus = false
Citizen.CreateThread(
    function()
        Citizen.Wait(10)

        while true do
            player = GetPlayerPed(-1)
            Citizen.Wait(250)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(
                coords,
                Config.logistik.Pos.x,
                Config.logistik.Pos.y,
                Config.logistik.Pos.z,
                true
            )
            if distance < 1.4 then
                inkmarkerse = true
                if allowednotify then
                    TriggerEvent(
                        "sevenliferp:startnui",
                        "Drücke <span1 color = white>E</span1> um das Logistik Menü zu öffnen",
                        "System - Nachricht",
                        true
                    )
                end
            else
                if distance >= 1.5 and distance <= 4 then
                    inkmarkerse = false
                    TriggerEvent("sevenliferp:closenotify", false)
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(5)
            if inkmarkerse then
                if IsControlJustPressed(0, 38) then
                    if inmenus == false then
                        Citizen.Wait(100)
                        inmenus = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        allowednotify = false
                        TriggerServerEvent("sevenlife:checkifplayerhaveanyshop")
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

RegisterNetEvent("sevenlife:getalldatas")
AddEventHandler(
    "sevenlife:getalldatas",
    function()
        ESX.TriggerServerCallback(
            "sevenlife:getlogistikitemslebensmittel",
            function(logistiklebensmittel)
                ESX.TriggerServerCallback(
                    "sevenlife:getlogistikitemsbaustelle",
                    function(logsitikbaustelle)
                        ESX.TriggerServerCallback(
                            "sevenlife:getlogistikitemsbaustelle",
                            function(logsitikelektronik, mechanikers)
                                SetNuiFocus(true, true)
                                SendNUIMessage(
                                    {
                                        type = "openlogistikmarkt",
                                        resulteins = logistiklebensmittel,
                                        resultzwei = logsitikbaustelle,
                                        resultdrei = logsitikelektronik,
                                        resultvier = mechanikers
                                    }
                                )
                            end
                        )
                    end
                )
            end
        )
    end
)

RegisterNUICallback(
    "rauses",
    function()
        SetNuiFocus(false, false)
        inmenus = false
        allowednotify = true
        allowednotifys = true
        inmenu = false
    end
)
function SpawnVehicle(car, x, y, z, heading)
    local spaen = vector3(x, y, z)

    ESX.Game.SpawnVehicle(
        car,
        spaen,
        heading,
        function(vehicle)
            vehicles = vehicle
            SetVehicleColours(vehicle, 112, 112)
            SetVehicleNumberPlateText(vehicle, "FORTNITE")
        end
    )
end

RegisterNUICallback(
    "makejob",
    function(data)
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Logistik:Check",
            function(EnoughMoney)
                if EnoughMoney then
                    TriggerEvent("sevenlife:jobing", data.name, tonumber(data.count))
                else
                    SetNuiFocus(false, false)
                    inmenus = false
                    allowednotify = true
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Logistik",
                        "Du hast zu wenig Geld um so eine Menge zu bestellen",
                        2000
                    )
                end
            end,
            data.price,
            data.count,
            data.name
        )
    end
)

RegisterNetEvent("sevenlife:jobing")
AddEventHandler(
    "sevenlife:jobing",
    function(name, count)
        SetNuiFocus(false, false)
        local rand = math.random(#Config.delivery_locations)
        local x, y, z = table.unpack(Config.delivery_locations[rand])
        local bliproute = createBlip(x, y)
        local einmal = false
        TriggerEvent("sevenlife:opennachricht", "openmelde", false, false, "Lieferung", "Fahr zu dem Markierten Punkt.")
        local job = true
        SpawnVehicle(
            "gburrito",
            Config.logistik.CarSpawn.x,
            Config.logistik.CarSpawn.y,
            Config.logistik.CarSpawn.z,
            Config.logistik.CarSpawn.heading
        )
        local player = GetPlayerPed(-1)

        local timer = 2000
        local firstmission = 1

        TriggerEvent("sevenlife:opennachricht", "openmelde", false, false, "Lieferung", "Fahr zu dem Markierten Punkt.")
        TriggerEvent("sevenlife:checkifinmarkermittel")
        TriggerEvent("sevenlife:markersmittel")
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
        Citizen.Wait(4000)
        TriggerEvent("sevenlife:opennachricht", "removemelde", false, false)
        while job do
            local coords = GetEntityCoords(player)
            local distance = GetDistanceBetweenCoords(coords, x, y, z, true)
            Citizen.Wait(timer)
            if firstmission == 1 then
                if distance <= 40 then
                    timer = 5
                    DrawText3Ds(x, y, z, "Drücke E um das Packet auf zu heben")
                    if distance <= 2 then
                        if not (IsPedSittingInAnyVehicle(player) or IsPedInAnyVehicle(player, true)) then
                            if IsControlJustPressed(0, 38) then
                                ResetPedMovementClipset(PlayerPedId(), 0)
                                SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                                CreateObjekt("anim@heists@box_carry@", "idle", "hei_prop_heist_box", 50, 28422)
                                SetVehicleDoorOpen(vehicles, 2, 0, 0)
                                SetVehicleDoorOpen(vehicles, 3, 0, 0)
                                SetVehicleDoorOpen(vehicles, 5, 0, 0)
                                firstmission = 2
                                RemoveBlip(blipse)
                                timer = 1000
                            end
                        end
                    end
                end
            end
            if firstmission == 2 then
                local distance2 =
                    (GetEntityCoords(player) -
                    GetWorldPositionOfEntityBone(vehicles, GetEntityBoneIndexByName(vehicles, "door_dside_r")))
                local xa, ya, za =
                    table.unpack(
                    GetWorldPositionOfEntityBone(vehicles, GetEntityBoneIndexByName(vehicles, "door_dside_r"))
                )

                local distance2 =
                    (GetEntityCoords(player) -
                    GetWorldPositionOfEntityBone(vehicles, GetEntityBoneIndexByName(vehicles, "door_pside_r")))
                local xb, yb, zb =
                    table.unpack(
                    GetWorldPositionOfEntityBone(vehicles, GetEntityBoneIndexByName(vehicles, "door_pside_r"))
                )

                local xs = (xa + xb) / 2
                local ys = (ya + yb) / 2
                local zs = (za + zb) / 2

                local distances = GetDistanceBetweenCoords(coords, xs, ys, zs, true)

                if distances <= 50 then
                    timer = 5
                    DrawText3Ds(xs, ys, zs, "Drücke E um das Packet in deinen Wagen zu Packen")
                    if distances <= 1 then
                        if not (IsPedSittingInAnyVehicle(player) or IsPedInAnyVehicle(player, true)) then
                            if IsControlJustPressed(0, 38) then
                                DeletarObjeto(player)
                                creategarageBlip(Config.logistik.CarSpawn.x, Config.logistik.CarSpawn.y)
                                TriggerEvent(
                                    "sevenlife:opennachricht",
                                    "openmelde",
                                    false,
                                    false,
                                    "Lieferung",
                                    "Fahre zurück zur Garage um das Auto abzugeben"
                                )
                                SetVehicleDoorShut(vehicles, 2, 0)
                                SetVehicleDoorShut(vehicles, 3, 0)
                                SetVehicleDoorShut(vehicles, 5, 0)
                                firstmission = 3
                                TriggerEvent("sevenlife:checkifinmarkermittel")
                                TriggerEvent("sevenlife:markersmittel")
                                PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
                                Citizen.Wait(4000)
                                TriggerEvent("sevenlife:opennachricht", "removemelde", false, false)
                                timer = 1000
                            end
                        end
                    end
                end
            end
            if firstmission == 3 then
                local distancezwei =
                    GetDistanceBetweenCoords(coords, Config.logistik.CarSpawn.x, Config.logistik.CarSpawn.y, true)
                if distancezwei <= 50 then
                    timer = 5
                    if distancezwei <= 4 then
                        DrawText3Ds(
                            Config.logistik.CarSpawn.x,
                            Config.logistik.CarSpawn.y,
                            Config.logistik.CarSpawn.z + 1,
                            "Drücke E um dein Auto abzugeben"
                        )

                        if IsControlJustPressed(0, 38) then
                            if einmal == false then
                                einmal = true
                                job = false
                                SetNuiFocus(false, false)
                                inmenus = false

                                allowednotify = true
                                ESX.Game.DeleteVehicle(vehicles)
                                TriggerServerEvent("sevenlife:givelogistikitems", name, count)
                                RemoveBlip(blipses)
                                TriggerEvent("sevenliferp:closenotify", false)
                                firstmission = nil
                            end
                        end
                    end
                end
            end
        end
    end
)

function createBlip(x, y)
    blipse = AddBlipForCoord(x, y)
    SetBlipSprite(blipse, 652)
    SetBlipDisplay(blipse, 4)
    SetBlipScale(blipse, 1.1)
    SetBlipRoute(blipse, true)
    SetBlipRouteColour(blipse, 61)
    SetBlipColour(blipse, 61)
    SetBlipAsShortRange(blipse, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Lieferung")
    EndTextCommandSetBlipName(blipse)
end
function creategarageBlip(x, y)
    blipses = AddBlipForCoord(x, y)
    SetBlipSprite(blipses, 357)
    SetBlipDisplay(blipses, 4)
    SetBlipScale(blipses, 1.1)
    SetBlipRoute(blipses, true)
    SetBlipRouteColour(blipses, 61)
    SetBlipColour(blipses, 61)
    SetBlipAsShortRange(blipses, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Garage")
    EndTextCommandSetBlipName(blipses)
end

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local object = nil
function CreateObjekt(dict, anim, prop, flag, hand, pos1, pos2, pos3, pos4, pos5, pos6)
    local ped = PlayerPedId()

    RequestModel(GetHashKey(prop))
    while not HasModelLoaded(GetHashKey(prop)) do
        Citizen.Wait(10)
    end

    if pos1 then
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -5.0)
        object = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z, true, true, true)
        SetEntityCollision(object, false, false)
        AttachEntityToEntity(
            object,
            ped,
            GetPedBoneIndex(ped, hand),
            pos1,
            pos2,
            pos3,
            pos4,
            pos5,
            pos6,
            true,
            true,
            false,
            true,
            1,
            true
        )
    else
        RequestAdict(dict)
        TaskPlayAnim(ped, dict, anim, 3.0, 3.0, -1, flag, 0, 0, 0, 0)
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -5.0)
        object = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z, true, true, true)
        SetEntityCollision(object, false, false)
        AttachEntityToEntity(
            object,
            ped,
            GetPedBoneIndex(ped, hand),
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            false,
            false,
            false,
            false,
            2,
            true
        )
    end
    Citizen.InvokeNative(0xAD738C3085FE7E11, object, true, true)
end

function DeletarObjeto(ped)
    ClearPedTasks(ped)
    if DoesEntityExist(object) then
        TriggerServerEvent("sevenlife:delteobj", ObjToNet(object))
        object = nil
    end
end

function RequestAdict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end
end
RegisterNetEvent("sevenlife:transferdataownedshops")
AddEventHandler(
    "sevenlife:transferdataownedshops",
    function(blips)
        if blips ~= nil then
            CreateshopBlip(blips)
        end
    end
)
RegisterNetEvent("sevenlife:transferdatanormalshop")
AddEventHandler(
    "sevenlife:transferdatanormalshop",
    function(blips)
        if blips ~= nil then
            CreateNormalshopBlips(blips)
        end
    end
)
RegisterNetEvent("sevenlife:syncdelete")
AddEventHandler(
    "sevenlife:syncdelete",
    function(index)
        if NetworkDoesNetworkIdExist(index) then
            local v = NetToPed(index)
            if DoesEntityExist(v) and IsEntityAnObject(v) then
                Citizen.InvokeNative(0xAD738C3085FE7E11, v, true, true)
                SetEntityAsMissionEntity(v, true, true)
                NetworkRequestControlOfEntity(v)
                Citizen.InvokeNative(0x539E0AE3E6634B9F, Citizen.PointerValueIntInitialized(v))
                DeleteEntity(v)
                DeleteObject(v)
                SetObjectAsNoLongerNeeded(v)
            end
        end
    end
)

local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_m_business_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.logistik.Pos.x,
                Config.logistik.Pos.y,
                Config.logistik.Pos.z,
                true
            )

            Citizen.Wait(500)

            if distance < 30 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped3 =
                        CreatePed(
                        4,
                        ped,
                        Config.logistik.Pos.x,
                        Config.logistik.Pos.y,
                        Config.logistik.Pos.z - 1,
                        357.46,
                        false,
                        true
                    )
                    SetEntityInvincible(ped3, true)
                    FreezeEntityPosition(ped3, true)
                    SetBlockingOfNonTemporaryEvents(ped3, true)
                    TaskPlayAnim(ped3, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped3)
                SetModelAsNoLongerNeeded(ped)
                pedloaded = false
            end
        end
    end
)
local pedloaded = false
local pedarea = false
local ped = GetHashKey("cs_siemonyetarian")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            for k, v in pairs(Config.Locations) do
                local distance = GetDistanceBetweenCoords(PlayerCoord, v.x, v.y, v.z, true)

                Citizen.Wait(500)

                if distance < 40 then
                    pedarea = true
                    if not pedloaded then
                        RequestModel(ped)
                        while not HasModelLoaded(ped) do
                            Citizen.Wait(1)
                        end
                        ped1 = CreatePed(4, ped, v.x, v.y, v.z - 1, v.heading, false, true)
                        SetEntityInvincible(ped1, true)
                        FreezeEntityPosition(ped1, true)
                        SetBlockingOfNonTemporaryEvents(ped1, true)
                        TaskPlayAnim(ped1, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                        pedloaded = true
                    end
                else
                    if distance >= 40.1 and distance <= 90.0 then
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
AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if resourceName == GetCurrentResourceName() then
            DeleteEntity(ped1)
        end
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
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.markler.Pos.x,
                Config.markler.Pos.y,
                Config.markler.Pos.z,
                true
            )

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
                        Config.markler.Pos.x,
                        Config.markler.Pos.y,
                        Config.markler.Pos.z,
                        Config.markler.Pos.heading,
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
