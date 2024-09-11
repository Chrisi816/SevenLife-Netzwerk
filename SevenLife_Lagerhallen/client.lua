ESX = nil
local activeblip = {}
local inmenu = false
local auto = true
local blipscreated = false
local timemain = 100
local notifys1 = true
local inmarker1 = false
local inmenu1 = false
Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end
    end
)

function CreateNormalBlips(blipse)
    for i = 1, #blipse, 1 do
        for k, v in pairs(Config.Lagerhallen) do
            if v.Pos.lagerhalle == blipse[i].lagerNumber then
                local blip = AddBlipForCoord(vector3(v.Pos.x, v.Pos.y, v.Pos.z))
                SetBlipSprite(blip, 474)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.5)
                SetBlipColour(blip, 37)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Lagerhalle zum Verkauf")
                EndTextCommandSetBlipName(blip)
                table.insert(activeblip, blip)
            end
        end
    end
end
function createBlipses(blips)
    for i = 1, #blips, 1 do
        for k, v in pairs(Config.Lagerhallen) do
            if v.Pos.lagerhalle == blips[i].lagerNumber then
                local blip = AddBlipForCoord(vector3(v.Pos.x, v.Pos.y, v.Pos.z))
                SetBlipSprite(blip, 473)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.5)
                SetBlipColour(blip, 2)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Lagerhalle")
                EndTextCommandSetBlipName(blip)
                table.insert(activeblip, blip)
            end
        end
    end
end

local allowednotify = true
local inmarker = false
Citizen.CreateThread(
    function()
        Citizen.Wait(2000)

        while true do
            player = GetPlayerPed(-1)
            Citizen.Wait(250)
            for k, v in pairs(Config.Lagerhallen) do
                local coords = GetEntityCoords(player)
                local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)
                if distance < 3.5 then
                    inmarker = true
                    lager = v.Pos.lagerhalle
                    if allowednotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um das Lagermenü zu öffnen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 3.6 and distance <= 5 then
                        TriggerEvent("sevenliferp:closenotify", false)
                        inmarker = false
                    end
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
            if inmarker then
                if IsControlJustReleased(0, 38) then
                    if inmenu == false then
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        allowednotify = false
                        TriggerServerEvent("sevenlive:checkifownedlager", lager)
                        Citizen.Wait(100)
                    end
                end
            else
                Citizen.Wait(650)
            end
        end
    end
)
RegisterNetEvent("sevenlife:givetimednachricht")
AddEventHandler(
    "sevenlife:givetimednachricht",
    function(nachricht)
        allowednotify = false
        TriggerEvent("sevenliferp:closenotify", false)
        Citizen.Wait(200)
        TriggerEvent("sevenliferp:startnui", nachricht, "System - Nachricht", true)
        Citizen.Wait(3000)
        TriggerEvent("sevenliferp:closenotify", false)
        allowednotify = true
        inmenu = false
        Citizen.Wait(50)
        DisplayRadar(true)
        inmarker = true
    end
)

RegisterNetEvent("sevenlife:kaufnui")
AddEventHandler(
    "sevenlife:kaufnui",
    function(event, bool, boolen, id, preis, quali)
        SetNuiFocus(bool, boolen)
        SendNUIMessage(
            {
                type = event,
                id = id,
                preis = preis,
                quali = quali
            }
        )
    end
)

RegisterNUICallback(
    "close",
    function()
        TriggerEvent("sevenlife:kaufnui", "removelagerhallekaufen", false, false)
        allowednotify = true
        inmenu = false
        Citizen.Wait(50)
        DisplayRadar(true)
        allowednotify = true
        inmarker = true
    end
)
RegisterNUICallback(
    "buying",
    function()
        TriggerServerEvent("sevenlife:inserdatalagerkauf", lager)
        inmenu = false
        Citizen.Wait(50)
        DisplayRadar(true)
        allowednotify = true
        inmarker = true
    end
)
RegisterNetEvent("sevenlife:entfernalles")
AddEventHandler(
    "sevenlife:entfernalles",
    function()
        TriggerEvent("sevenlife:kaufnui", "removelagerhallekaufen", false, false)
        allowednotify = true
    end
)
RegisterNetEvent("sevenlife:removeblips")
AddEventHandler(
    "sevenlife:removeblips",
    function()
        for i = 1, #activeblip do
            RemoveBlip(activeblip[i])
        end
    end
)
RegisterNetEvent("sevenlife:addblibsyea")
AddEventHandler(
    "sevenlife:addblibsyea",
    function()
        ESX.TriggerServerCallback(
            "sevenlife:ownedblipse",
            function(blips)
                if blips ~= nil then
                    createBlipses(blips)
                end
            end
        )
        ESX.TriggerServerCallback(
            "sevenlife:getnormalblips",
            function(blips)
                if blips ~= nil then
                    CreateNormalBlips(blips)
                end
            end
        )
    end
)
local items = {}
local lageritemse = {}
RegisterNetEvent("sevenlife:invdata")
AddEventHandler(
    "sevenlife:invdata",
    function(lager, value, quali, btc, eth, lagerused, platz, mining)
        ESX.TriggerServerCallback(
            "sevenlife:getinvitem",
            function(inventory)
                ESX.TriggerServerCallback(
                    "sevenlife:getlageritems",
                    function(lageritems)
                        local items = {}
                        local lageritemse = {}
                        for key, value in pairs(inventory) do
                            if inventory[key].count <= 0 then
                                inventory[key] = nil
                            else
                                inventory[key].type = "item_standard"
                                table.insert(items, inventory[key])
                            end
                        end
                        for k, v in pairs(lageritems) do
                            if tonumber(lageritems[k].count) <= 0 then
                                lageritems[k] = nil
                            else
                                lageritems[k].type = "item_lagers"
                                table.insert(lageritemse, lageritems[k])
                            end
                        end
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenLager",
                                inventory = items,
                                id = lager,
                                btc = btc,
                                eth = eth,
                                lagerused = lagerused,
                                platzupgrade = platz,
                                mining = mining,
                                preis = value,
                                quali = quali,
                                lagers = lageritemse
                            }
                        )
                    end,
                    lager
                )
            end
        )
    end
)

RegisterNUICallback(
    "closeings",
    function()
        TriggerEvent("sevenlife:kaufnui", "removelagerhallekaufen", false, false)
        allowednotify = true
        inmenu = false
        Citizen.Wait(50)
        DisplayRadar(true)
        allowednotify = true
        inmarker = true
    end
)
RegisterNUICallback(
    "einlagern",
    function(data)
        TriggerEvent("sevenlife:closealls", false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Lager:NotOverLimit",
            function(notlimit)
                if notlimit then
                    TriggerServerEvent("Sevenlife:Lager:UpdateWeight", data.weight, data.lager)
                    TriggerServerEvent("sevenlife:transformdatas", data.item, data.count, data.lager, data.weight)
                    inmenu = false
                    Citizen.Wait(50)
                    DisplayRadar(true)
                    allowednotify = true
                    inmarker = true
                else
                    TriggerEvent("sevenlife:givetimednachricht", "Diese Lagerhalle zu ist voll")
                end
            end,
            lager,
            data.weight,
            data.max
        )
    end
)
RegisterNUICallback(
    "entnahmen",
    function(data)
        TriggerEvent("sevenlife:closealls", false, false)
        TriggerServerEvent("sevenlife:transformdataszwei", data.item, data.count, data.lager)
        ESX.TriggerServerCallback(
            "SevenLife:Lager:GetWeightOfItem",
            function(weight)
                local endweight = weight * data.count
                TriggerServerEvent("Sevenlife:Lager:RemoveWeight", endweight, data.lager)
            end,
            data.item
        )
        inmenu = false
        Citizen.Wait(50)
        DisplayRadar(false)
        allowednotify = true
        inmarker = true
    end
)
RegisterNetEvent("sevenlife:closealls")
AddEventHandler(
    "sevenlife:closealls",
    function(bool, boolen)
        SetNuiFocus(bool, boolen)
        SendNUIMessage(
            {
                type = "removenormallager"
            }
        )
    end
)
Citizen.CreateThread(
    function()
        Citizen.Wait(300)
        TriggerServerEvent("sevenlife:getownedblipsdatas")
        TriggerServerEvent("sevenlife:getrestdatablipslager")
    end
)

AddEventHandler(
    "playerSpawned",
    function(spawn)
        Citizen.Wait(500)
        TriggerServerEvent("sevenlife:getownedblipsdatas")
        TriggerServerEvent("sevenlife:getrestdatablipslager")
    end
)
RegisterNetEvent("sevenlife:transferdataownedblip")
AddEventHandler(
    "sevenlife:transferdataownedblip",
    function(blips)
        Citizen.Wait(200)
        if blips ~= nil then
            blipscreated = true
            createBlipses(blips)
        end
    end
)
RegisterNetEvent("sevenlife:transferdatanotownedblips")
AddEventHandler(
    "sevenlife:transferdatanotownedblips",
    function(blips)
        Citizen.Wait(200)
        if blips ~= nil then
            blipscreated = true
            CreateNormalBlips(blips)
        end
    end
)

RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
        allowednotify = true
        inmenu = false
        Citizen.Wait(50)
        DisplayRadar(true)
        allowednotify = true
        inmarker = true
        SetNuiFocus(false, false)
        inmenu1 = false
        notifys1 = true
    end
)
RegisterNUICallback(
    "keinplatzmehr",
    function()
        TriggerEvent("SevenLife:TimetCustom:Notify", "Lagerhallen", "Diese Lagerhalle ist voll!", 3000)
    end
)
RegisterNUICallback(
    "kaufmining",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        Citizen.Wait(50)
        DisplayRadar(true)
        allowednotify = true
        inmarker = true
        TriggerServerEvent("SevenLife:Upgrade:Mining", lager)
    end
)

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
RegisterNUICallback(
    "kaufplatz",
    function(data)
        SetNuiFocus(false, false)
        inmenu = false
        Citizen.Wait(50)
        DisplayRadar(true)
        allowednotify = true
        inmarker = true
        TriggerServerEvent("SevenLife:Lagerhallen:InsertUpgrade", data.id, lager)
    end
)
RegisterNUICallback(
    "OpenMiningPage",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Lagerhallen:GetInfosForRig",
            function(items, itemsee, mining)
                local itemse = {}

                for key, value in pairs(items) do
                    if items[key].count <= 0 then
                        items[key] = nil
                    else
                        if
                            items[key].name == "sGPU" or items[key].name == "lGPU" or items[key].name == "seGPU" or
                                items[key].name == "sCPU" or
                                items[key].name == "lCPU" or
                                items[key].name == "seCPU" or
                                items[key].name == "sRAM" or
                                items[key].name == "lRAM" or
                                items[key].name == "seRAM"
                         then
                            items[key].type = "item_standard"
                            table.insert(itemse, items[key])
                        end
                    end
                end
                local leistungscpu,
                    leistungsgpu,
                    leistungsram,
                    GPU,
                    CPU,
                    RAM,
                    STROMCPU,
                    STROMGPU,
                    STROMRAM,
                    RAM,
                    endleistung,
                    endstrom = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                for k, v in pairs(itemsee) do
                    if v ~= nil then
                        if v.types == "CPU" then
                            leistungscpu = Config.Stats[v.item].LEISTUNG
                            CPU = Config.Stats[v.item].CPUMHZ
                            STROMCPU = Config.Stats[v.item].WATT
                        elseif v.types == "RAM" then
                            leistungsram = Config.Stats[v.item].LEISTUNG
                            RAM = Config.Stats[v.item].RAM
                            STROMRAM = Config.Stats[v.item].WATT
                        elseif v.types == "GPU" then
                            leistungsgpu = Config.Stats[v.item].LEISTUNG
                            GPU = Config.Stats[v.item].GPUMHZ
                            STROMGPU = Config.Stats[v.item].WATT
                        end
                    end
                end
                endleistung = leistungscpu + leistungsgpu + leistungsram
                endstrom = STROMCPU + STROMGPU + STROMRAM
                SendNUIMessage(
                    {
                        type = "UpdateRig",
                        items = itemse,
                        itemse = itemsee,
                        leistung = endleistung,
                        endstrom = endstrom,
                        cpu = CPU,
                        ram = RAM,
                        gpu = GPU,
                        btc = mining[1].btc
                    }
                )
            end,
            lager
        )
    end
)
RegisterNUICallback(
    "InsertItem",
    function(data)
        TriggerServerEvent("SevenLife:Lagerhallen:InsertItemMining", data.name, data.label, data.type, lager)
    end
)
RegisterNetEvent("SevenLife:Lagerhallen:UpdateRigs")
AddEventHandler(
    "SevenLife:Lagerhallen:UpdateRigs",
    function(items)
        SendNUIMessage(
            {
                type = "UpdateKeys",
                items = items
            }
        )
    end
)
local normalbtc = 0.0000001
Citizen.CreateThread(
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Lagerhallen:GetInfosAboutRig",
            function(result)
                if result then
                    while true do
                        Citizen.Wait(60000 * 30)
                        local leistungscpu, leistungsram, leistungsgpu
                        for k, v in pairs(result) do
                            if v ~= nil then
                                if v.types == "CPU" then
                                    leistungscpu = Config.Stats[v.item].LEISTUNG
                                elseif v.types == "RAM" then
                                    leistungsram = Config.Stats[v.item].LEISTUNG
                                elseif v.types == "GPU" then
                                    leistungsgpu = Config.Stats[v.item].LEISTUNG
                                end
                            end
                        end
                        local prozent = leistungscpu + leistungsgpu + leistungsram
                        local endbtc = normalbtc * prozent
                        TriggerServerEvent("SevenLife:Lagerhallen:GiveBitCoins", endbtc, lager)
                    end
                end
            end
        )
    end
)
RegisterNUICallback(
    "Auszahlen",
    function(data)
        if tonumber(data.btc) >= 0.01 then
            TriggerServerEvent("SevenLife:Lagerhallen:PayOut", data.btc)
        else
            TriggerEvent(
                "SevenLife:TimetCustom:Notify",
                "Lagerhallen",
                "Du kannst diese Anzahl nicht auszahlen da du ein mindest bestand von 0.01BTC haben musst!",
                3000
            )
        end
    end
)
function Showsblips(x, y)
    local blips = AddBlipForCoord(x, y)
    SetBlipSprite(blips, 521)
    SetBlipDisplay(blips, 4)
    SetBlipScale(blips, 1.0)
    SetBlipColour(blips, 48)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Elektronik Laden")
    EndTextCommandSetBlipName(blips)
    SetBlipAsShortRange(blips, true)
end
local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_m_malibu_01")
Citizen.CreateThread(
    function()
        Showsblips(Config.ComputerLaden.x, Config.ComputerLaden.y)
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            Citizen.Wait(500)

            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.ComputerLaden.x,
                Config.ComputerLaden.y,
                Config.ComputerLaden.z,
                true
            )

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
                        Config.ComputerLaden.x,
                        Config.ComputerLaden.y,
                        Config.ComputerLaden.z,
                        Config.ComputerLaden.heading,
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

local timemain1 = 100

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain1)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance =
                GetDistanceBetweenCoords(
                coord,
                Config.ComputerLaden.x,
                Config.ComputerLaden.y,
                Config.ComputerLaden.z,
                true
            )
            if distance < 15 then
                area = true
                timemain1 = 15
                if distance < 2 then
                    inmarker1 = true
                    if notifys1 then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um mit dem Inhaber zu sprechen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.1 and distance <= 3 then
                        inmarker1 = false
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
            if inmarker1 then
                if IsControlJustPressed(0, 38) then
                    if inmenu1 == false then
                        inmenu1 = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys1 = false
                        SetNuiFocus(true, true)
                        openmenu1 = true
                        ESX.TriggerServerCallback(
                            "SevenLife:Bauern:GetMoney",
                            function(money)
                                SendNUIMessage(
                                    {
                                        type = "OpenComputer",
                                        items = Config.Items,
                                        money = money
                                    }
                                )
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
RegisterNUICallback(
    "BuyBauer",
    function(data)
        TriggerServerEvent("SevenLife:ComputerLaden:BuyItem", data.name, data.preis)
    end
)

RegisterNetEvent("SevenLife:ComputerLaden:Geld")
AddEventHandler(
    "SevenLife:ComputerLaden:Geld",
    function(money)
        SendNUIMessage(
            {
                type = "UpdateMoney",
                money = money
            }
        )
    end
)
