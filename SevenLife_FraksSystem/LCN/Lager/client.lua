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
---------------------------------------------Npc Spawner------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local pedloaded = false
local area = false
local pedarea = false
local inmenu = false
local ped = GetHashKey("a_m_y_business_03")

--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------

local notifys = true
local inmarker = false
local inmenu = false
local timemain = 100
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance =
                GetDistanceBetweenCoords(coord, Config.LCN.Lager.x, Config.LCN.Lager.y, Config.LCN.Lager.z, true)
            if distance < 15 then
                area = true
                timemain = 15
                if distance < 1.2 then
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um das Lager zu öffnen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.2 and distance <= 2.2 then
                        inmarker = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                area = false
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

                        TriggerEvent("SevenLife:Inventory:MakeWeaponSchrankLCN")
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

-- Callbacks

RegisterNetEvent("SevenLife:Inventory:MakeWeaponSchrankLCN")
AddEventHandler(
    "SevenLife:Inventory:MakeWeaponSchrankLCN",
    function()
        TriggerServerEvent("SevenLife:Inventory:OpenWaffenschrankLCN")
    end
)
RegisterNetEvent("SevenLife:Inventory:OpenItWaffenschrankFRAK")
AddEventHandler(
    "SevenLife:Inventory:OpenItWaffenschrankFRAK",
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
                type = "OpenInventoryWaffenSchrankFRAK",
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
    "giveiteminventorywaffenschrankfrak",
    function(data)
        local label = data.item
        local weapons = data.type

        local anzahl = data.anzahl
        PlayerData = ESX.GetPlayerData()
        ESX.TriggerServerCallback(
            "SevenLife:Inventory:FrakStandard",
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
                        type = "UpdateWaffenschrankFRAK",
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
    "giveiteminwaffenschrankfrak",
    function(data)
        local ped = GetPlayerPed(-1)
        local weapons = data.type
        PlayerData = ESX.GetPlayerData()
        ESX.TriggerServerCallback(
            "SevenLife:Inventar:InsertItemTrunkdreiFrak",
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
                        type = "UpdateWaffenschrankFRAK",
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
    "CloseWaffenSchrank",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
    end
)
local time = 2000
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time)
            if area and not inmenu then
                time = 1
                DrawMarker(
                    1,
                    Config.LCN.Lager.x,
                    Config.LCN.Lager.y,
                    Config.LCN.Lager.z - 1,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.8,
                    0.8,
                    0.8,
                    236,
                    80,
                    80,
                    155,
                    false,
                    false,
                    2,
                    false,
                    0,
                    0,
                    0,
                    0
                )
            else
                time = 2000
            end
        end
    end
)
