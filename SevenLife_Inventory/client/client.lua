local openinv = false
local currentWeapon
local isvehiclehud
local disabled = false
local morekg = 100
local slots
ESX = nil
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1300)
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    bag = skin["bags_1"]
                end
            )
        end
    end
)

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
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        PlayerData = ESX.GetPlayerData()
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)
            if bag == 40 or bag == 41 or bag == 44 or bag == 45 then
                TriggerServerEvent("SevenLife:Inventory:Change", true)
            else
                TriggerServerEvent("SevenLife:Inventory:Change")
            end
            Citizen.Wait(4000)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if not disabled then
                if IsControlJustPressed(0, 289) then
                    if bag == 40 or bag == 41 or bag == 44 or bag == 45 then
                        morekg = 130
                        TriggerServerEvent("SevenLife:Inventory:Open", 30)
                    else
                        morekg = 130
                        TriggerServerEvent("SevenLife:Inventory:Open")
                    end
                end

                if IsControlJustPressed(0, 354) then
                    local ped = GetPlayerPed(-1)
                    if IsPedInAnyVehicle(ped, false) then
                        -- Open Vehicle GloveBox
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        local plate = GetVehicleNumberPlateText(vehicle)
                        if bag == 40 or bag == 41 or bag == 44 or bag == 45 then
                            TriggerServerEvent("SevenLife:Inventory:OpenGloveBox", plate, vehicle, 30)
                        else
                            TriggerServerEvent("SevenLife:Inventory:OpenGloveBox", plate, vehicle)
                        end
                    else
                        local corrds = GetEntityCoords(ped)
                        local vehicle = ESX.Game.GetClosestVehicle(corrds)
                        if vehicle ~= 0 and vehicle ~= nil then
                            local pos = GetEntityCoords(ped)
                            local dimensionMin, dimensionMax = GetModelDimensions(GetEntityModel(vehicle))
                            local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, (dimensionMin.y), 0.0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, (dimensionMax.y), 0.0)
                            end
                            if #(pos - trunkpos) < 1.5 and not IsPedInAnyVehicle(ped) then
                                if GetVehicleDoorLockStatus(vehicle) < 2 then
                                    -- Open Vehicle Trunk
                                    local plate = GetVehicleNumberPlateText(vehicle)
                                    if bag == 40 or bag == 41 or bag == 44 or bag == 45 then
                                        TriggerServerEvent("SevenLife:Inventory:OpenTrunk", vehicle, plate, 30)
                                    else
                                        TriggerServerEvent("SevenLife:Inventory:OpenTrunk", vehicle, plate)
                                    end

                                    isvehiclehud = true
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Tankstelle",
                                        "Auto zugeschlossen",
                                        2000
                                    )
                                    return
                                end
                            end
                        end
                    end
                end
            else
                Citizen.Wait(500)
            end
        end
    end
)

RegisterNetEvent("SevenLife:Inventory:OpenIt")
AddEventHandler(
    "SevenLife:Inventory:OpenIt",
    function(items, weight)
        local itemse = {}
        for key, value in pairs(items) do
            if items[key].count <= 0 then
                items[key] = nil
            else
                items[key].type = "item_standard"
                table.insert(itemse, items[key])
            end
        end
        local listofplayers = {}
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local players = ESX.Game.GetPlayersInArea(coords, 4.0)

        for k, v in pairs(players) do
            listofplayers[k].id = GetPlayerServerId(k)
            listofplayers[k].name = GetPlayerName(v)
            local distanz = GetDistanceBetweenCoords(coords, GetEntityCoords(v), false)
            listofplayers[k].distanz = distanz
        end

        TriggerScreenblurFadeIn(2000)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "OpenInventory",
                items = itemse,
                weight = weight,
                people = listofplayers
            }
        )
    end
)
RegisterNetEvent("SevenLife:Inventory:OpenItExtra30KD")
AddEventHandler(
    "SevenLife:Inventory:OpenItExtra30KD",
    function(items, weight)
        local itemse = {}
        for key, value in pairs(items) do
            if items[key].count <= 0 then
                items[key] = nil
            else
                items[key].type = "item_standard"
                table.insert(itemse, items[key])
            end
        end
        local listofplayers = {}
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local players = ESX.Game.GetPlayersInArea(coords, 4.0)

        for k, v in pairs(players) do
            listofplayers[k].id = GetPlayerServerId(k)
            listofplayers[k].name = GetPlayerName(v)
            local distanz = GetDistanceBetweenCoords(coords, GetEntityCoords(v), false)
            listofplayers[k].distanz = distanz
        end
        TriggerScreenblurFadeIn(2000)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "OpenInventory30KG",
                items = itemse,
                weight = weight,
                people = listofplayers
            }
        )
    end
)

RegisterNUICallback(
    "CloseInventory",
    function()
        SetNuiFocus(false, false)
        TriggerScreenblurFadeOut(2000)
        if isvehiclehud then
            local ped = GetPlayerPed(-1)
            local corrds = GetEntityCoords(ped)
            local vehicle = ESX.Game.GetClosestVehicle(corrds)
            SetVehicleDoorShut(vehicle, 5, false)
        end
    end
)

RegisterNUICallback(
    "useItem",
    function(data, cb)
        print(data.item)
        TriggerServerEvent("esx:useItem", data.item)
    end
)

RegisterNUICallback(
    "SetInventoryData",
    function(data)
        if not data.toinventory or not data.frominventory then
            return
        end
        if string.find(data.frominventory, "Other") or string.find(data.toinventory, "Other") then
            TriggerServerEvent("SevenLife:Inventory:SetInventoryData:Player", data)
        else
            TriggerServerEvent("SevenLife:Inventory:SetInventoryData", data)
        end
    end
)

RegisterNetEvent("SevenLife:Inventory:RefreshInventory")
AddEventHandler(
    "SevenLife:Inventory:RefreshInventory",
    function(other)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                action = "refresh",
                items = InvFunctions.GetPlayer().inventory,
                other = other,
                plyweight = GetPlayerWeight()
            }
        )
    end
)

RegisterNUICallback(
    "DropItem",
    function(data, cb)
        TriggerServerEvent("SevenLife:Inventory:DropItem", data.item, data.anzahl)
    end
)
local Drops = {}

RegisterNetEvent("SevenLife:Inventory:GetDrop")
AddEventHandler(
    "SevenLife:Inventory:GetDrop",
    function(data)
        Drops = data
        TriggerEvent("sevenliferp:closenotify", false)
    end
)

CreateThread(
    function()
        while true do
            local sleep = 1500
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)
            for k, v in pairs(Drops) do
                local dist = #(coords - v.coords)
                if dist <= 2 then
                    TriggerEvent(
                        "sevenliferp:startnui",
                        "Drücke <span1 color = white>E</span1> um ein Item ausfzuheben",
                        "System - Nachricht",
                        true
                    )
                    sleep = 3
                    DrawMarker(
                        2,
                        v.coords.x,
                        v.coords.y,
                        v.coords.z - 0.5,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.15,
                        0.15,
                        0.15,
                        255,
                        255,
                        255,
                        155,
                        false,
                        false,
                        false,
                        0,
                        false,
                        false,
                        false
                    )
                    if IsControlJustReleased(0, 38) then
                        RequestAnimDict("pickup_object")
                        while not HasAnimDictLoaded("pickup_object") do
                            Citizen.Wait(7)
                        end
                        TaskPlayAnim(
                            GetPlayerPed(-1),
                            "pickup_object",
                            "pickup_low",
                            8.0,
                            -8.0,
                            -1,
                            1,
                            0,
                            false,
                            false,
                            false
                        )
                        Citizen.Wait(2000)
                        ClearPedTasks(GetPlayerPed(-1))
                        TriggerServerEvent("SevenLife:Inventory:RemoveDrop", k)
                    end
                else
                    if dist >= 2 and dist <= 4 then
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end
)

RegisterNetEvent("SevenLife:Inventory:SlowDownPlayer")
AddEventHandler(
    "SevenLife:Inventory:SlowDownPlayer",
    function()
        local ped = GetPlayerPed(-1)

        local set = "MOVE_M@DRUNK@VERYDRUNK"
        RequestAnimSet(set)
        repeat
            Citizen.Wait(100)
        until HasAnimSetLoaded(set)
        SetPedMovementClipset(ped, set, 4)
        TriggerEvent(
            "SevenLife:TimetCustom:Notify",
            "Inventory",
            "Du läufst jetzt langsamer da du überladen bist",
            3000
        )
    end
)

RegisterNetEvent("SevenLife:Inventory:FreezePlayer")
AddEventHandler(
    "SevenLife:Inventory:FreezePlayer",
    function()
        local ped = GetPlayerPed(-1)
        FreezeEntityPosition(ped, true)
        Animation("anim@gangops@morgue@table@", "ko_front", ped)
        TriggerEvent(
            "SevenLife:TimetCustom:Notify",
            "Inventory",
            "Du kannst dich nicht mehr bewegen weil du zu viele Items im Inventar hast",
            3000
        )
    end
)

RegisterNetEvent("SevenLife:Inventory:CleenAll")
AddEventHandler(
    "SevenLife:Inventory:CleenAll",
    function()
        local ped = GetPlayerPed(-1)
        ClearPedTasks(ped)
        ClearPedSecondaryTask(ped)

        FreezeEntityPosition(ped, false)
        SetEntityMaxSpeed(ped, 10000.0)
    end
)

function Animation(dict, anim, ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
end

RegisterNetEvent("SevenLife:Inventory:OpenItGloveBox")
AddEventHandler(
    "SevenLife:Inventory:OpenItGloveBox",
    function(items, weight, vehicles, itemskoffereaum)
        SetNuiFocus(true, true)

        local itemse = {}
        for key, value in pairs(items) do
            if items[key].count <= 0 then
                items[key] = nil
            else
                items[key].type = "item_standard"
                table.insert(itemse, items[key])
            end
        end
        slots = Config.Classes[GetVehicleClass(vehicles)] or 1.0
        SendNUIMessage(
            {
                type = "OpenInventoryGlove",
                items = itemse,
                plyweight = weight,
                boxexglov = Config.GloveKlasses[GetVehicleClass(vehicles)] or 1.0,
                carweight = Config.CarWeightTrunk[GetVehicleClass(vehicles)] or 1.0,
                inventorykofferaum = itemskoffereaum
            }
        )
    end
)

RegisterNetEvent("SevenLife:Inventory:OpenItGloveBox30KG")
AddEventHandler(
    "SevenLife:Inventory:OpenItGloveBox30KG",
    function(items, weight, vehicles, itemskoffereaum)
        SetNuiFocus(true, true)

        local itemse = {}
        for key, value in pairs(items) do
            if items[key].count <= 0 then
                items[key] = nil
            else
                items[key].type = "item_standard"
                table.insert(itemse, items[key])
            end
        end
        slots = Config.Classes[GetVehicleClass(vehicles)] or 1.0
        SendNUIMessage(
            {
                type = "OpenInventoryGlove30KG",
                items = itemse,
                plyweight = weight,
                boxexglov = Config.GloveKlasses[GetVehicleClass(vehicles)] or 1.0,
                carweight = Config.CarWeightTrunk[GetVehicleClass(vehicles)] or 1.0,
                inventorykofferaum = itemskoffereaum
            }
        )
    end
)

RegisterNetEvent("SevenLife:Inventory:OpenItTrunk")
AddEventHandler(
    "SevenLife:Inventory:OpenItTrunk",
    function(items, weight, vehicles, itemskoffereaum)
        SetNuiFocus(true, true)

        local itemse = {}
        for key, value in pairs(items) do
            if items[key].count <= 0 then
                items[key] = nil
            else
                items[key].type = "item_standard"
                table.insert(itemse, items[key])
            end
        end
        slots = Config.Classes[GetVehicleClass(vehicles)] or 1.0

        SetVehicleDoorOpen(vehicles, 5, false, false)
        SendNUIMessage(
            {
                type = "OpenInventoryTrunk",
                items = itemse,
                plyweight = weight,
                boxexglov = Config.Classes[GetVehicleClass(vehicles)] or 1.0,
                carweight = Config.CarWeightTrunk[GetVehicleClass(vehicles)] or 1.0,
                inventorykofferaum = itemskoffereaum
            }
        )
    end
)

RegisterNetEvent("SevenLife:Inventory:OpenItTrunk30KG")
AddEventHandler(
    "SevenLife:Inventory:OpenItTrunk30KG",
    function(items, weight, vehicles, itemskoffereaum)
        SetNuiFocus(true, true)

        local itemse = {}
        for key, value in pairs(items) do
            if items[key].count <= 0 then
                items[key] = nil
            else
                items[key].type = "item_standard"
                table.insert(itemse, items[key])
            end
        end
        slots = Config.Classes[GetVehicleClass(vehicles)] or 1.0

        SetVehicleDoorOpen(vehicles, 5, false, false)
        SendNUIMessage(
            {
                type = "OpenInventoryTrunk30KG",
                items = itemse,
                plyweight = weight,
                boxexglov = Config.Classes[GetVehicleClass(vehicles)] or 1.0,
                carweight = Config.CarWeightTrunk[GetVehicleClass(vehicles)] or 1.0,
                inventorykofferaum = itemskoffereaum
            }
        )
    end
)
function IsBackEngine(vehModel)
    return BackEngineVehicles[vehModel]
end
local list = {}
local message = {}
RegisterNUICallback(
    "givekofferraumitem",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local vehicle = ESX.Game.GetClosestVehicle(coords)
        local plate = GetVehicleNumberPlateText(vehicle)
        ESX.TriggerServerCallback(
            "SevenLife:Inventar:CheckIfCarHaveEnoughSpace",
            function(result)
                if result then
                    ESX.TriggerServerCallback(
                        "SevenLife:Inventar:InsertItemTrunk",
                        function(result, items)
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
                                    type = "UpdateKofferraum",
                                    list = result,
                                    items = itemse
                                }
                            )
                        end,
                        plate,
                        data.item,
                        data.anzahl,
                        data.label
                    )
                end
            end,
            plate,
            slots
        )
    end
)

RegisterNUICallback(
    "giveiteminventory",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local vehicle = ESX.Game.GetClosestVehicle(coords)
        local plate = GetVehicleNumberPlateText(vehicle)
        local label = data.item

        local anzahl = data.anzahl
        ESX.TriggerServerCallback(
            "SevenLife:Inventory:GiveItemToInventory",
            function(result, items)
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
                        type = "UpdateKofferraum",
                        list = result,
                        items = itemse
                    }
                )
            end,
            label,
            anzahl,
            plate
        )
    end
)

RegisterNetEvent("SevenLife:Inventory:CloseInventoryTrunk")
AddEventHandler(
    "SevenLife:Inventory:CloseInventoryTrunk",
    function(message)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Inventory", message, 3000)
        SendNUIMessage(
            {
                type = "CloseTrunk"
            }
        )
    end
)

RegisterNUICallback(
    "giveiteminventorygloves",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local vehicle = ESX.Game.GetClosestVehicle(coords)
        local plate = GetVehicleNumberPlateText(vehicle)
        local label = data.item

        local anzahl = data.anzahl
        ESX.TriggerServerCallback(
            "SevenLife:Inventory:GiveItemToInventoryzwei",
            function(result, items)
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
                        type = "UpdateGloves",
                        list = result,
                        items = itemse
                    }
                )
            end,
            label,
            anzahl,
            plate
        )
    end
)
RegisterNUICallback(
    "givekofferraumitemgloves",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local vehicle = ESX.Game.GetClosestVehicle(coords)
        local plate = GetVehicleNumberPlateText(vehicle)
        ESX.TriggerServerCallback(
            "SevenLife:Inventar:CheckIfCarHaveEnoughSpaceGlove",
            function(result)
                if result then
                    ESX.TriggerServerCallback(
                        "SevenLife:Inventar:InsertItemTrunkzwei",
                        function(result, items)
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
                                    type = "UpdateGloves",
                                    list = result,
                                    items = itemse
                                }
                            )
                        end,
                        plate,
                        data.item,
                        data.anzahl,
                        data.label
                    )
                end
            end,
            plate,
            slots
        )
    end
)

RegisterNetEvent("SevenLife:Inventory:MakeWeaponSchrankPolice")
AddEventHandler(
    "SevenLife:Inventory:MakeWeaponSchrankPolice",
    function()
        TriggerServerEvent("SevenLife:Inventory:OpenWaffenschrank")
    end
)

RegisterNetEvent("SevenLife:Inventory:OpenItWaffenschrank")
AddEventHandler(
    "SevenLife:Inventory:OpenItWaffenschrank",
    function(items, weight, itemskoffereaum, loadout)
        SetNuiFocus(true, true)
        local weapon = {}
        local itemse = {}
        for i = 1, #weapon do
            weapon[i] = nil
        end
        for key, value in pairs(items) do
            if items[key].count <= 0 then
                items[key] = nil
            else
                items[key].type = "item_standard"
                table.insert(itemse, items[key])
            end
        end
        for k, v in ipairs(loadout) do
            if v.name == "WEAPON_PISTOL" then
                v.label = "Pistole"
                table.insert(weapon, v)
            elseif v.name == "WEAPON_PISTOL50" then
                v.label = "50.Pistole"
                table.insert(weapon, v)
            elseif v.name == "WEAPON_ASSAULTRIFLE" then
                v.label = "AK 47"
                table.insert(weapon, v)
            elseif v.name == "WEAPON_COMBATPDW" then
                v.label = "PDW"
                table.insert(weapon, v)
            end
        end
        SendNUIMessage(
            {
                type = "OpenInventoryWaffenSchrank",
                items = itemse,
                plyweight = weight,
                boxexglov = 1000,
                inventorykofferaum = itemskoffereaum,
                weapons = weapon
            }
        )
    end
)

RegisterNUICallback(
    "giveiteminwaffenschrank",
    function(data)
        local ped = GetPlayerPed(-1)
        local weapons = data.type
        PlayerData = ESX.GetPlayerData()
        ESX.TriggerServerCallback(
            "SevenLife:Inventar:InsertItemTrunkdrei",
            function(result, items, loadout)
                local itemse = {}
                local weapon = {}
                for i = 1, #weapon do
                    weapon[i] = nil
                end
                for key, value in pairs(items) do
                    if items[key].count <= 0 then
                        items[key] = nil
                    else
                        items[key].type = "item_standard"
                        table.insert(itemse, items[key])
                    end
                end
                for k, v in ipairs(loadout) do
                    if v.name == "WEAPON_PISTOL" then
                        v.label = "Pistole"
                        table.insert(weapon, v)
                    elseif v.name == "WEAPON_PISTOL50" then
                        v.label = "50.Pistole"
                        table.insert(weapon, v)
                    elseif v.name == "WEAPON_ASSAULTRIFLE" then
                        v.label = "AK 47"
                        table.insert(weapon, v)
                    elseif v.name == "WEAPON_COMBATPDW" then
                        v.label = "PDW"
                        table.insert(weapon, v)
                    end
                end
                SendNUIMessage(
                    {
                        type = "UpdateWaffenschrank",
                        list = result,
                        items = itemse,
                        weapons = weapon
                    }
                )
            end,
            data.item,
            data.anzahl,
            data.label,
            weapons
        )
    end
)

RegisterNUICallback(
    "giveiteminventorywaffenschrank",
    function(data)
        local label = data.item
        local weapons = data.type

        local anzahl = data.anzahl
        PlayerData = ESX.GetPlayerData()
        ESX.TriggerServerCallback(
            "SevenLife:Inventory:GiveItemToInventorydrei",
            function(result, items, loadout)
                local itemse = {}
                local weapon = {}
                for i = 1, #weapon do
                    weapon[i] = nil
                end

                for key, value in pairs(items) do
                    if items[key].count <= 0 then
                        items[key] = nil
                    else
                        items[key].type = "item_standard"
                        table.insert(itemse, items[key])
                    end
                end
                for k, v in ipairs(loadout) do
                    if v.name == "WEAPON_PISTOL" then
                        v.label = "Pistole"
                        table.insert(weapon, v)
                    elseif v.name == "WEAPON_PISTOL50" then
                        v.label = "50.Pistole"
                        table.insert(weapon, v)
                    elseif v.name == "WEAPON_ASSAULTRIFLE" then
                        v.label = "AK 47"
                        table.insert(weapon, v)
                    elseif v.name == "WEAPON_COMBATPDW" then
                        v.label = "PDW"
                        table.insert(weapon, v)
                    end
                end
                SendNUIMessage(
                    {
                        type = "UpdateWaffenschrank",
                        list = result,
                        items = itemse,
                        weapons = weapon
                    }
                )
            end,
            label,
            anzahl,
            weapons
        )
    end
)

RegisterNUICallback(
    "CloseWaffenSchrank",
    function()
        TriggerEvent("SevenLife:PD:DeleteAll")
    end
)
RegisterNetEvent("SevenLife:Inventory:DisableInventory")
AddEventHandler(
    "SevenLife:Inventory:DisableInventory",
    function()
        disabled = true
    end
)
RegisterNetEvent("SevenLife:Inventory:AnableInventory")
AddEventHandler(
    "SevenLife:Inventory:AnableInventory",
    function()
        disabled = false
    end
)
RegisterNUICallback(
    "GiveItemToPlayer",
    function(data)
        TriggerServerEvent("SevenLife:Inventory:GiveItemToPlayer", data.id, data.anzahl, data.item)
    end
)
local targetid = nil
RegisterNetEvent("SevenLife:Inventory:ShowPlayerInv")
AddEventHandler(
    "SevenLife:Inventory:ShowPlayerInvt",
    function(items, weight, targetinventory, targetid)
        local itemse = {}
        for key, value in pairs(items) do
            if items[key].count <= 0 then
                items[key] = nil
            else
                items[key].type = "item_standard"
                table.insert(itemse, items[key])
            end
        end
        targetid = targetid
        TriggerScreenblurFadeIn(2000)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "OpenInventoryDurchsuchen",
                items = itemse,
                weight = weight,
                targetinventory = targetinventory
            }
        )
    end
)
RegisterNUICallback(
    "giveitemtoplayerdurchsuchen",
    function(data)
        TriggerServerEvent(
            "SevenLife:Inventory:giveitemtoplayerdurchsuchen",
            data.item,
            data.anzahl,
            data.label,
            targetid
        )
    end
)
RegisterNUICallback(
    "giveitemtoinventory",
    function(data)
        TriggerServerEvent("SevenLife:Inventory:getitemfromplayer", data.item, data.anzahl, data.label, targetid)
    end
)
