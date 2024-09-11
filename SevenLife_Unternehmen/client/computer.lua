local notifys = true
local inmarker = false
local inmenu = false
local timemain = 100
local area = false
local xviewcoords, yviewcoords, zviewcoords
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)
            for k, v in pairs(Config.Computer) do
                local distance = GetDistanceBetweenCoords(coord, v.x, v.y, v.z, true)
                if distance < 15 then
                    xviewcoords = v.x
                    yviewcoords = v.y
                    zviewcoords = v.z
                    timemain = 15
                    area = true
                    if distance < 2 then
                        inmarker = true
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um mit den Pc zu interagieren",
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
                    timemain = 100
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
                        SetNuiFocus(true, true)
                        ESX.TriggerServerCallback(
                            "SevenLife:Computer:GetÜbersichtData",
                            function(result, cars, shops, herstellung, tankstellen, angestellte)
                                local carnumber, shopse, angestellten, herstellungs = 0, 0, 0, 0
                                for k, v in pairs(cars) do
                                    carnumber = carnumber + 1
                                end
                                for k, v in pairs(shops) do
                                    shopse = shopse + 1
                                end
                                for k, v in pairs(angestellte) do
                                    angestellten = angestellten + 1
                                end
                                for k, v in pairs(herstellung) do
                                    herstellungs = herstellungs + 1
                                end
                                local activefuel, wert, preisproliter
                                if tankstellen[1] == nil then
                                    activefuel = 0
                                    wert = 0
                                    preisproliter = 0
                                else
                                    activefuel = tankstellen[1].activefuel
                                    wert = tankstellen[1].activefuel
                                    preisproliter = tankstellen[1].activefuel
                                end

                                SendNUIMessage(
                                    {
                                        type = "OpenPC",
                                        result = result[1].cash,
                                        cars = carnumber,
                                        shops = shopse,
                                        herstellung = herstellungs,
                                        LiterTanke = activefuel,
                                        TankenWert = wert,
                                        LiterPreis = preisproliter,
                                        angestellte = angestellten
                                    }
                                )
                            end,
                            firmennames
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
            Citizen.Wait(time)
            if area and not inmenu then
                time = 1
                DrawMarker(
                    20,
                    xviewcoords,
                    yviewcoords,
                    zviewcoords,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.6,
                    0.6,
                    0.6,
                    234,
                    0,
                    122,
                    200,
                    1,
                    1,
                    0,
                    0
                )
            else
                time = 2000
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5000)
            local player = GetPlayerPed(-1)
            if IsPlayerDead(player) or IsEntityDead(player) then
                notifys = true
                inmarker = false
                inmenu = false
                timemain = 100
                area = false
            end
        end
    end
)
RegisterNUICallback(
    "GetInfosÜbersicht",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Unternehmen:CheckBuero",
            function(buero, firmenname)
                firmennames = firmenname
                ESX.TriggerServerCallback(
                    "SevenLife:Computer:GetÜbersichtData",
                    function(result, cars, shops, herstellung, tankstellen, angestellte)
                        local carnumber, shopse, angestellten, herstellungs = 0, 0, 0, 0
                        for k, v in pairs(cars) do
                            carnumber = carnumber + 1
                        end
                        for k, v in pairs(shops) do
                            shopse = shopse + 1
                        end
                        for k, v in pairs(angestellte) do
                            angestellten = angestellten + 1
                        end
                        for k, v in pairs(herstellung) do
                            herstellungs = herstellungs + 1
                        end
                        SendNUIMessage(
                            {
                                type = "UpdateÜbersicht",
                                result = result[1].cash,
                                cars = carnumber,
                                shops = shopse,
                                herstellung = herstellungs,
                                LiterTanke = tankstellen[1].activefuel,
                                TankenWert = tankstellen[1].wert,
                                LiterPreis = tankstellen[1].preisproliter,
                                angestellte = angestellten
                            }
                        )
                    end,
                    firmennames
                )
            end
        )
    end
)
RegisterNUICallback(
    "closepc",
    function()
        notifys = true
        inmarker = false
        inmenu = false
    end
)
RegisterNUICallback(
    "GetInfosShops",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Admins:GetShopsInfos",
            function(shops)
                SendNUIMessage(
                    {
                        type = "UpdateShopList",
                        shops = shops
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "GetDetailsShops",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Admin:getDetailsShopsInfos",
            function(shops, shopitem, shopitemse)
                SendNUIMessage(
                    {
                        type = "OpenShopMenu",
                        shops = shops,
                        shopitem = shopitem,
                        shopitemse = shopitemse,
                        shopid = data.shopid
                    }
                )
            end,
            data.shopid
        )
    end
)
RegisterNUICallback(
    "GetDetailsEinlagern",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Unternehmen:GetItemsForEinlagern",
            function(items)
                local itemse = {}
                for key, value in pairs(items) do
                    if items[key].count <= 0 then
                        items[key] = nil
                    else
                        items[key].type = "item_standard"
                        table.insert(itemse, items[key])
                    end
                end
                SendNUIMessage(
                    {
                        type = "OpenEinlagern",
                        id = data.shopid,
                        items = items
                    }
                )
            end,
            data.shopid
        )
    end
)
RegisterNUICallback(
    "InsertEinlagern",
    function(data)
        TriggerServerEvent("SevenLife:Unternehmen:InsertEinlagern", data.shopid, data.name, data.count, data.label)
    end
)
RegisterNetEvent("SevenLife:Unternehmen:UpdateEinlagern")
AddEventHandler(
    "SevenLife:Unternehmen:UpdateEinlagern",
    function(items, id)
        local itemse = {}
        for key, value in pairs(items) do
            if items[key].count <= 0 then
                items[key] = nil
            else
                items[key].type = "item_standard"
                table.insert(itemse, items[key])
            end
        end
        SendNUIMessage(
            {
                type = "UpdateEinlagern",
                itemse = itemse,
                id = id
            }
        )
    end
)
RegisterNUICallback(
    "EinzahlenGeld",
    function(data)
        TriggerServerEvent("SevenLife:Unternehmen:GeldAuszahlen", data.money, data.id)
    end
)
RegisterNetEvent("SevenLife:Admin:UpdateMoneyShop")
AddEventHandler(
    "SevenLife:Admin:UpdateMoneyShop",
    function(money)
        SendNUIMessage({type = "UpdateShopGeld", money = money})
    end
)
RegisterNUICallback(
    "GetDetailsAuslagern",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Unternehmen:GetItemsInShop",
            function(item)
                SendNUIMessage(
                    {
                        type = "InsertAuslagernItems",
                        item = item,
                        id = data.shopid
                    }
                )
            end,
            data.shopid
        )
    end
)
RegisterNUICallback(
    "LagerItemAus",
    function(data)
        TriggerServerEvent("SevenLife:Unternehmen:Auslagern", data.shopid, data.name, data.count, data.label)
    end
)
RegisterNetEvent("SevenLife:Unternehmen:UpdateAuslagern")
AddEventHandler(
    "SevenLife:Unternehmen:UpdateAuslagern",
    function(items, id)
        SendNUIMessage(
            {
                type = "UpdateUnternehmenAuslagern",
                items = items,
                id = id
            }
        )
    end
)
RegisterNUICallback(
    "MakePreis",
    function(data)
        TriggerServerEvent("SevenLife:Unternehmen:UpdatePreis", data.money, data.id, data.name, data.label)
    end
)
RegisterNUICallback(
    "PreisVergeben",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Unternehmen:GetItemsPreis",
            function(result)
                SendNUIMessage(
                    {
                        type = "InsertPreisSachen",
                        id = data.shopid,
                        items = result
                    }
                )
            end,
            data.shopid
        )
    end
)
RegisterNUICallback(
    "MakeAuktion",
    function(data)
        local labelcar
        if data.type == "cars" then
            ESX.TriggerServerCallback(
                "SevenLife:Auktion:GetPlateVeh",
                function(result)
                    local hash = result.model
                    local vehname = GetDisplayNameFromVehicleModel(hash)
                    labelcar = GetLabelText(vehname)
                end,
                data.plate
            )
        end
        Citizen.Wait(500)
        ESX.TriggerServerCallback(
            "SevenLife:Unternehmen:CheckIfInAuktion",
            function(result)
                if result then
                    TriggerServerEvent(
                        "SevenLife:Auktion:MakeAuktion",
                        data.choice,
                        data.zeit,
                        data.preis,
                        data.type,
                        data.plate,
                        data.count,
                        labelcar,
                        data.vehicleid,
                        data.label
                    )
                end
            end,
            data.label
        )
    end
)

RegisterNUICallback(
    "GetInfosTanken",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Admins:GetTankeInfos",
            function(shops)
                SendNUIMessage(
                    {
                        type = "UpdateTankenList",
                        shops = shops
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "GetDetailsTanke",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Admin:getDetailsTankeInfos",
            function(money, fuel, history)
                SendNUIMessage(
                    {
                        type = "OpenTankeMenu",
                        money = money,
                        fuel = fuel,
                        history = history,
                        shopid = data.shopid
                    }
                )
            end,
            data.shopid
        )
    end
)
RegisterNUICallback(
    "EinzahlenGeld",
    function(data)
        TriggerServerEvent("SevenLife:Tankstelle:GeldAuszahlen", data.money, data.id)
    end
)
RegisterNetEvent("SevenLife:Admin:UpdateMoneyTanke")
AddEventHandler(
    "SevenLife:Admin:UpdateMoneyTanke",
    function(money)
        SendNUIMessage({type = "UpdateTankeGeld", money = money})
    end
)
local xcoords, ycoords, zcoords, hcoords, idfuel, fuelcap
RegisterNUICallback(
    "StartAuftrag",
    function(data)
        SetNuiFocus(false, false)
        inmenu = false
        inmarker = false
        notifys = true
        ESX.TriggerServerCallback(
            "SevenLife:Unternehmen:CheckIfEnoughMoney",
            function(resultse)
                if resultse then
                    local activemission = false
                    ESX.TriggerServerCallback(
                        "SevenLife:Unternehmen:CheckIfHaveCar",
                        function(result)
                            local results = true

                            if results then
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Unternehmen",
                                    "Fahre zum Anhänger um fortzufahren",
                                    3000
                                )
                                for k, v in pairs(Config.FuelLocales) do
                                    if k == tonumber(data.selectedfuel) then
                                        xcoords = v.x
                                        ycoords = v.y
                                        zcoords = v.z
                                        hcoords = v.h
                                    end
                                end
                                idfuel = data.id
                                fuelcap = data.currentliter
                                ConfiggurePlayer()
                                Blip()
                                activemission = true
                                Citizen.Wait(50)
                                inmenu = false
                                inmarker = false
                                notifys = true
                                TriggerEvent("sevenliferp:closenotify", false)

                                Citizen.CreateThread(
                                    function()
                                        while activemission do
                                            local coords = GetEntityCoords(PlayerPedId())
                                            Citizen.Wait(2)
                                            local distancese =
                                                GetDistanceBetweenCoords(
                                                coords,
                                                Config.TrailorSpawn.x,
                                                Config.TrailorSpawn.y,
                                                Config.TrailorSpawn.z,
                                                true
                                            )
                                            Citizen.Wait(1000)
                                            local retval, tailer =
                                                GetVehicleTrailerVehicle(GetVehiclePedIsUsing(PlayerPedId()))
                                            if distancese < 20 then
                                                if retval then
                                                    ClearAllBlipRoutes()
                                                    Citizen.Wait(500)
                                                    TriggerEvent("sevenliferp:closenotify", false)
                                                    TriggerEvent("SevenLife:Unternehmen:MainPart")
                                                    RemoveBlip(BlipTrailor)
                                                    activemission = false
                                                else
                                                    TriggerEvent(
                                                        "sevenliferp:startnui",
                                                        "Kopple den Anhänger an dein LKW",
                                                        "System - Nachricht",
                                                        true
                                                    )
                                                end
                                            else
                                                if distancese >= 21 and distancese <= 25 then
                                                    TriggerEvent("sevenliferp:closenotify", false)
                                                end
                                            end
                                        end
                                    end
                                )
                            else
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Unternehmen",
                                    "Du brauchst ein Lastwagen und einen dazu passenden Anhänger um diese Aktion auszuführen",
                                    3000
                                )
                            end
                        end,
                        data.id,
                        "tanker",
                        "Packer"
                    )
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Unternehmen",
                        "Du hast zu wenig Geld momentan dabei (Bar)",
                        3000
                    )
                end
            end,
            data.currentliter
        )
    end
)
function ConfiggurePlayer()
    local Ped = GetPlayerPed(-1)
    SetEntityCoords(Ped, Config.CarSpawn.x, Config.CarSpawn.y, Config.CarSpawn.z, 0, 0, 0, 0)
    print(1)
    ESX.Game.SpawnVehicle(
        "Packer",
        vector3(Config.CarSpawn.x, Config.CarSpawn.y, Config.CarSpawn.z),
        Config.CarSpawn.heading,
        function(vehicle)
            vehiclepacker = vehicle
            TaskWarpPedIntoVehicle(Ped, vehicle, -1)
            SetVehicleColours(vehicle, 112, 112)
            SetVehicleNumberPlateText(vehicle, "FUEL")
        end
    )
    ESX.Game.SpawnVehicle(
        "tanker",
        vector3(Config.TrailorSpawn.x, Config.TrailorSpawn.y, Config.TrailorSpawn.z),
        Config.TrailorSpawn.heading,
        function(vehicle)
            trailer = vehicle
            SetVehicleColours(vehicle, 112, 112)
            SetVehicleNumberPlateText(vehicle, "FUEL")
        end
    )
end
function Blip()
    BlipTrailor = AddBlipForCoord(Config.TrailorSpawn.x, Config.TrailorSpawn.y)
    SetBlipSprite(BlipTrailor, 479)
    SetBlipDisplay(BlipTrailor, 4)
    SetBlipScale(BlipTrailor, 1.0)
    SetBlipColour(BlipTrailor, 48)
    SetBlipRoute(BlipTrailor, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Anhänger")
    EndTextCommandSetBlipName(BlipTrailor)
end
function Blip2()
    BlipPferdepumpe = AddBlipForCoord(xcoords, ycoords)
    SetBlipSprite(BlipPferdepumpe, 431)
    SetBlipDisplay(BlipPferdepumpe, 4)
    SetBlipScale(BlipPferdepumpe, 1.0)
    SetBlipColour(BlipPferdepumpe, 48)
    SetBlipRoute(BlipPferdepumpe, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pferdepumpe")
    EndTextCommandSetBlipName(BlipPferdepumpe)
end
function Blip3()
    BlipAbgabeOrt = AddBlipForCoord(Config.CarSpawn.x, Config.CarSpawn.y)
    SetBlipSprite(BlipAbgabeOrt, 431)
    SetBlipDisplay(BlipAbgabeOrt, 4)
    SetBlipScale(BlipAbgabeOrt, 1.0)
    SetBlipColour(BlipAbgabeOrt, 48)
    SetBlipRoute(BlipAbgabeOrt, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Abgabe Punkt")
    EndTextCommandSetBlipName(BlipAbgabeOrt)
end

local secondmain = false
RegisterNetEvent("SevenLife:Unternehmen:MainPart")
AddEventHandler(
    "SevenLife:Unternehmen:MainPart",
    function()
        local mainpart = true
        Blip2()
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        secondmain = true
        Citizen.CreateThread(
            function()
                while secondmain do
                    Citizen.Wait(2000)

                    local ped = GetPlayerPed(-1)
                    local coords = GetEntityCoords(ped)
                    local distance = GetDistanceBetweenCoords(coords, xcoords, ycoords, zcoords, true)
                    if distance <= 15 then
                        secondmain = false
                        TaskLeaveVehicle(ped, vehicle, 0)
                        ClearAllBlipRoutes()
                        RemoveBlip(BlipPferdepumpe)
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Unternehmen", "Gehe und Bohre nach Öll", 3000)
                        TriggerEvent("SevenLife:Unternehmen:StartNotify")
                    end
                end
            end
        )
    end
)
RegisterNetEvent("SevenLife:Unternehmen:StartNotify")
AddEventHandler(
    "SevenLife:Unternehmen:StartNotify",
    function()
        local pumpfuel = true
        local notifys1 = true
        local inmarker1 = false
        local inmenu1 = false
        local timemain1 = 100

        Citizen.CreateThread(
            function()
                while pumpfuel do
                    Citizen.Wait(timemain1)
                    local ped = GetPlayerPed(-1)
                    local coord = GetEntityCoords(ped)

                    local distance = GetDistanceBetweenCoords(coord, xcoords, ycoords, zcoords, true)
                    if distance < 30 then
                        timemain1 = 15
                        if distance < 10 then
                            inmarker1 = true
                            if notifys1 then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um nach Öl zu bohren",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 10.1 and distance <= 11.1 then
                                inmarker1 = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        timemain1 = 100
                    end
                end
            end
        )

        Citizen.CreateThread(
            function()
                Citizen.Wait(10)
                while pumpfuel do
                    Citizen.Wait(5)
                    if inmarker1 then
                        if IsControlJustPressed(0, 38) then
                            if inmenu1 == false then
                                inmenu1 = true
                                TriggerEvent("sevenliferp:closenotify", false)
                                notifys1 = false
                                pumpfuel = false
                                SetNuiFocus(true, true)
                                SendNUIMessage(
                                    {
                                        type = "OpenHarvestMenu"
                                    }
                                )
                            end
                        end
                    else
                        Citizen.Wait(1000)
                    end
                end
            end
        )
    end
)
RegisterNUICallback(
    "FuelFertig",
    function()
        SetNuiFocus(false, false)
        Blip3()
        TriggerEvent(
            "SevenLife:TimetCustom:Notify",
            "Unternehmen",
            "Erfolgreich nach dem Öll gebohrt, kehre um und gebe deinen LKW ab",
            3000
        )
        TriggerEvent("SevenLife:Unternehmen:GiveAway")
    end
)
RegisterNetEvent("SevenLife:Unternehmen:GiveAway")
AddEventHandler(
    "SevenLife:Unternehmen:GiveAway",
    function()
        local abgabemission = true
        Citizen.CreateThread(
            function()
                while abgabemission do
                    local coords = GetEntityCoords(PlayerPedId())
                    Citizen.Wait(2)
                    local distancese =
                        GetDistanceBetweenCoords(coords, Config.CarSpawn.x, Config.CarSpawn.y, Config.CarSpawn.z, true)
                    Citizen.Wait(1000)
                    local retval, tailer = GetVehicleTrailerVehicle(GetVehiclePedIsUsing(PlayerPedId()))
                    if distancese < 20 then
                        if retval then
                            abgabemission = false
                            ClearAllBlipRoutes()
                            Citizen.Wait(500)
                            TriggerEvent("sevenliferp:closenotify", false)
                            DeleteVehicle(vehiclepacker)
                            DeleteVehicle(trailer)
                            RemoveBlip(BlipAbgabeOrt)
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Unternehmen",
                                "Lkw Erfolgreich abgegeben",
                                3000
                            )
                            TriggerServerEvent("SevenLife:Unternehmen:SchreibeOilGut", idfuel, fuelcap)
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
RegisterNUICallback(
    "OpenJobMenu",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Unternehmen:GetJobs",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenJobNui",
                        jobs = result,
                        firmennames = firmennames
                    }
                )
            end,
            firmennames
        )
    end
)
RegisterNUICallback(
    "StartJob",
    function(data)
        if data.check == 1 then
            SetNuiFocus(false, false)

            local results = true

            if results then
                TriggerEvent("SevenLife:TimetCustom:Notify", "Unternehmen", "Fahre zum Anhänger um fortzufahren", 3000)
                for k, v in pairs(Config.FuelLocales) do
                    if k == tonumber(data.detail1) then
                        xcoords = v.x
                        ycoords = v.y
                        zcoords = v.z
                        hcoords = v.h
                    end
                end
                idfuel = data.detail2
                fuelcap = data.detail3
                ConfiggurePlayer()
                Blip()
                activemission = true
                Citizen.Wait(50)
                inmenu = false
                inmarker = false
                notifys = true
                TriggerEvent("sevenliferp:closenotify", false)

                Citizen.CreateThread(
                    function()
                        while activemission do
                            local coords = GetEntityCoords(PlayerPedId())
                            Citizen.Wait(2)
                            local distancese =
                                GetDistanceBetweenCoords(
                                coords,
                                Config.TrailorSpawn.x,
                                Config.TrailorSpawn.y,
                                Config.TrailorSpawn.z,
                                true
                            )
                            Citizen.Wait(1000)
                            local retval, tailer = GetVehicleTrailerVehicle(GetVehiclePedIsUsing(PlayerPedId()))
                            if distancese < 20 then
                                if retval then
                                    ClearAllBlipRoutes()
                                    Citizen.Wait(500)
                                    TriggerEvent("sevenliferp:closenotify", false)
                                    TriggerEvent("SevenLife:Unternehmen:MainPart")
                                    RemoveBlip(BlipTrailor)
                                    activemission = false
                                else
                                    TriggerEvent(
                                        "sevenliferp:startnui",
                                        "Kopple den Anhänger an dein LKW",
                                        "System - Nachricht",
                                        true
                                    )
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
        end
    end
)
RegisterNUICallback(
    "GetInfosCars",
    function(data)
        local cars = Config.Cars
        SendNUIMessage(
            {
                type = "OpenCarMenu",
                cars = cars,
                firma = firmennames
            }
        )
    end
)
RegisterNUICallback(
    "BuyCar",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Unternehmen:GetIfEnoughMoney",
            function(result)
                if result then
                    TriggerServerEvent("SevenLife:Unternehmen:InsertCar", data.name, data.firma)
                end
            end,
            data.price
        )
    end
)
