local inmenu = false
local Amarbeiten = false
local notifyaramidfasern = true
Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance = GetDistanceBetweenCoords(coords, Config.feld.x, Config.feld.y, Config.feld.z, true)

            if not Amarbeiten then
                if distance < 20 then
                    InAramidFasernCircle = true
                    if notifyaramidfasern then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um Aramid fasern zu sammeln",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 20.1 and distance <= 26.9 then
                        InAramidFasernCircle = false
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
            Citizen.Wait(7)
            if InAramidFasernCircle then
                if not Amarbeiten then
                    if IsControlJustPressed(0, 38) then
                        Amarbeiten = true
                        Citizen.Wait(100)
                        local Ped = GetPlayerPed(-1)
                        notifyaramidfasern = false
                        TriggerEvent("sevenliferp:closenotify", false)

                        SendNUIMessage(
                            {
                                type = "loadingsand"
                            }
                        )
                        TaskStartScenarioInPlace(Ped, "WORLD_HUMAN_GARDENER_PLANT", 0, false)
                        Citizen.Wait(8500)
                        SendNUIMessage(
                            {
                                type = "removeloadingsand"
                            }
                        )
                        ClearPedTasks(Ped)
                        TriggerServerEvent("sevenlife:aramidfaser")
                        Amarbeiten = false
                        Citizen.Wait(1500)
                        notifyaramidfasern = true
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

local Amverarbeiten = false
local notifyverarbeitenaramidfasern = true
Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance = GetDistanceBetweenCoords(coords, Config.npc.x, Config.npc.y, Config.npc.z, true)

            if not Amverarbeiten then
                if distance < 1.5 then
                    InAramidFasernVerarbeitenCircle = true
                    if notifyverarbeitenaramidfasern then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um Aramidfasern zu verarbeiten",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.6 and distance <= 4 then
                        InAramidFasernVerarbeitenCircle = false
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
            Citizen.Wait(7)
            if InAramidFasernVerarbeitenCircle then
                if not Amverarbeiten then
                    if IsControlJustPressed(0, 38) then
                        Amverarbeiten = true
                        notifyverarbeitenaramidfasern = false
                        TriggerServerEvent("sevenlife:aramidverarbeitenremove")
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
local AmWesteverarbeiten = false
local notifyverarbeitenweste = true
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
                Config.westeverarbeiten.x,
                Config.westeverarbeiten.y,
                Config.westeverarbeiten.z,
                true
            )

            if not AmWesteverarbeiten then
                if distance < 1.5 then
                    InWesteVerarbeitenCircle = true
                    if notifyverarbeitenweste then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Verarbeiter zu öffnen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.6 and distance <= 4 then
                        InWesteVerarbeitenCircle = false
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
            Citizen.Wait(7)
            if InWesteVerarbeitenCircle then
                if not AmWesteverarbeiten then
                    if IsControlJustPressed(0, 38) then
                        AmWesteverarbeiten = true
                        notifyverarbeitenweste = false
                        SendNUIMessage(
                            {
                                type = "Opencrafter"
                            }
                        )

                        Removenormalhud()
                        SetNuiFocus(true, true)
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

local AmEisenverarbeiten = false
local notifyverarbeiteneisen = true
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
                Config.eisenlocation.x,
                Config.eisenlocation.y,
                Config.eisenlocation.z,
                true
            )

            if not AmEisenverarbeiten then
                if distance < 15 then
                    InEisenVerarbeitenCircle = true
                    if notifyverarbeiteneisen then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um Eisen zu sammeln",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 15.1 and distance <= 18.9 then
                        InEisenVerarbeitenCircle = false
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
            Citizen.Wait(7)
            if InEisenVerarbeitenCircle then
                if not AmEisenverarbeiten then
                    if IsControlJustPressed(0, 38) then
                        AmEisenverarbeiten = true
                        notifyverarbeiteneisen = false
                        local ped = GetPlayerPed(-1)

                        TriggerEvent("sevenliferp:closenotify", false)

                        SendNUIMessage(
                            {
                                type = "loadingverarbeitersand"
                            }
                        )
                        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, false)
                        Citizen.Wait(8500)
                        SendNUIMessage(
                            {
                                type = "removeverarbeiterloadingsand"
                            }
                        )
                        ClearPedTasks(ped)
                        TriggerServerEvent("sevenlife:giveeisen")
                        Citizen.Wait(500)
                        AmEisenverarbeiten = false
                        notifyverarbeiteneisen = true
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

local SpawnPed = GetHashKey("a_m_y_acult_02")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance = GetDistanceBetweenCoords(PlayerCoord, Config.npc.x, Config.npc.y, Config.npc.z, true)

            Citizen.Wait(1000)
            pedarea = false
            if distance < 40 then
                pedarea = true
                if not pedloaded then
                    RequestModel(SpawnPed)
                    while not HasModelLoaded(SpawnPed) do
                        Citizen.Wait(1)
                    end
                    ped1 =
                        CreatePed(
                        4,
                        SpawnPed,
                        Config.npc.x,
                        Config.npc.y,
                        Config.npc.z,
                        Config.npc.heading,
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
                SetModelAsNoLongerNeeded(ped1)
                pedloaded = false
            end
        end
    end
)

RegisterNetEvent("sevenlife:moresteps")
AddEventHandler(
    "sevenlife:moresteps",
    function()
        Amverarbeiten = true
        notifyverarbeitenaramidfasern = false
        TriggerEvent("sevenliferp:closenotify", false)
        SendNUIMessage(
            {
                type = "verarbeiternav"
            }
        )
        Citizen.Wait(15000)
        TriggerServerEvent("sevenlife:aramidverarbeitengivegewebe")
        SendNUIMessage(
            {
                type = "removeverarbeiternav"
            }
        )
        Citizen.Wait(2000)
        Amverarbeiten = false
        notifyverarbeitenaramidfasern = true
    end
)

RegisterNetEvent("sevenlife:notenoughitems")
AddEventHandler(
    "sevenlife:notenoughitems",
    function()
        TriggerEvent(
            "SevenLife:TimetCustom:Notify",
            "Craften",
            "Zu wenige Aramidfasern um Aramidgewebe herzustellen",
            2000
        )

        Amverarbeiten = false
        notifyverarbeitenaramidfasern = true
    end
)

RegisterNetEvent("sevenlife:notenoughitemsverarbeiter")
AddEventHandler(
    "sevenlife:notenoughitemsverarbeiter",
    function()
        TriggerEvent("sevenlife:removeverarbeiter")
        TriggerEvent("SevenLife:TimetCustom:Notify", "Craften", "Du besitzt zu wenige Items", 2000)
        AmWesteverarbeiten = false
        notifyverarbeitenweste = true
    end
)

RegisterNetEvent("sevenlife:givenotify")
AddEventHandler(
    "sevenlife:givenotify",
    function()
        TriggerEvent("SevenLife:TimetCustom:Notify", "Craften", "Du hast in deinem Rucksack kein Platz mehr", 2000)
        Amarbeiten = false

        notifyaramidfasern = true
    end
)
RegisterNetEvent("sevenlife:enougharamidgewebe")
AddEventHandler(
    "sevenlife:enougharamidgewebe",
    function()
        TriggerEvent("SevenLife:TimetCustom:Notify", "Craften", "Du hast in deinem Rucksack kein Platz mehr", 2000)
        Amverarbeiten = false
        notifyverarbeitenaramidfasern = true
    end
)

-----------------------------------------------------------------------------------------------------
--                                       Westen Mechanic
-----------------------------------------------------------------------------------------------------
local lib = "clothingtie"
local src = "try_tie_neutral_a"
RegisterNetEvent("sevenlife:leichteweste")
AddEventHandler(
    "sevenlife:leichteweste",
    function()
        local playerPed = PlayerPedId()
        ESX.Streaming.RequestAnimDict(
            lib,
            function()
                TaskPlayAnim(playerPed, lib, src, 8.0, 1.0, -1, 49, 0, false, false, false)
                RemoveAnimDict(lib)
            end
        )
        FreezeEntityPosition(playerPed, true)
        Wait(5000)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(playerPed)
        SetPedComponentVariation(playerPed, 9, 20, 7, 2)
        AddArmourToPed(playerPed, 30)
        SetPedArmour(playerPed, 30)
    end
)

RegisterNetEvent("sevenlife:mittlereweste")
AddEventHandler(
    "sevenlife:mittlereweste",
    function()
        local playerPed = PlayerPedId()
        ESX.Streaming.RequestAnimDict(
            lib,
            function()
                TaskPlayAnim(playerPed, lib, src, 8.0, 1.0, -1, 49, 0, false, false, false)
                RemoveAnimDict(lib)
            end
        )
        FreezeEntityPosition(playerPed, true)
        Wait(5000)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(playerPed)
        SetPedComponentVariation(playerPed, 9, 20, 6, 2)
        AddArmourToPed(playerPed, 50)
        SetPedArmour(playerPed, 50)
    end
)

RegisterNetEvent("sevenlife:schwereweste")
AddEventHandler(
    "sevenlife:schwereweste",
    function()
        local playerPed = PlayerPedId()
        ESX.Streaming.RequestAnimDict(
            lib,
            function()
                TaskPlayAnim(playerPed, lib, src, 8.0, 1.0, -1, 49, 0, false, false, false)
                RemoveAnimDict(lib)
            end
        )
        FreezeEntityPosition(playerPed, true)
        Wait(5000)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(playerPed)
        SetPedComponentVariation(playerPed, 9, 9, 3, 2)
        AddArmourToPed(playerPed, 100)
        SetPedArmour(playerPed, 100)
    end
)

-----------------------------------------------------------------------------------------------------
--                                       Crafter Callbacks
-----------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "Leichte",
    function()
        AmWesteverarbeiten = false
        notifyverarbeitenweste = true
        TriggerServerEvent("sevenlife:removeitemsleichteweste")
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)
RegisterNUICallback(
    "Mittlere",
    function()
        AmWesteverarbeiten = false
        notifyverarbeitenweste = true
        TriggerServerEvent("sevenlife:removeitemsmitterwesete")
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)
RegisterNUICallback(
    "Schwere",
    function()
        AmWesteverarbeiten = false
        notifyverarbeitenweste = true
        TriggerServerEvent("sevenlife:removeitemsschwereweste")
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

RegisterNetEvent("sevenlife:nextstep")
AddEventHandler(
    "sevenlife:nextstep",
    function()
        local opennav = true
        while opennav do
            TriggerEvent("sevenlife:removeverarbeiter")
            TriggerEvent("sevenlife:openfirstloadingbar")
            Citizen.Wait(20000)
            TriggerEvent("sevenlife:removefirstloadingbar")
            TriggerServerEvent("sevenlife:giveliechteweste")
            opennav = false
            AmWesteverarbeiten = false
            notifyverarbeitenweste = true
        end
    end
)
RegisterNetEvent("sevenlife:nextstepmittlere")
AddEventHandler(
    "sevenlife:nextstepmittlere",
    function()
        local opennav = true
        while opennav do
            TriggerEvent("sevenlife:removeverarbeiter")
            TriggerEvent("sevenlife:opensecondloadingbar")
            Citizen.Wait(120000)
            TriggerEvent("sevenlife:removesecondloadingbar")
            TriggerServerEvent("sevenlife:givemittlereweste")
            opennav = false
            AmWesteverarbeiten = false
            notifyverarbeitenweste = true
        end
    end
)
RegisterNetEvent("sevenlife:nextstepschwer")
AddEventHandler(
    "sevenlife:nextstepschwer",
    function()
        local opennav = true
        while opennav do
            TriggerEvent("sevenlife:removeverarbeiter")
            TriggerEvent("sevenlife:openthirdloadingbar")
            Citizen.Wait(320000)
            TriggerEvent("sevenlife:removethirdloadingbar")
            TriggerServerEvent("sevenlife:giveschwereweste")
            opennav = false
            AmWesteverarbeiten = false
            notifyverarbeitenweste = true
        end
    end
)

RegisterNUICallback(
    "CloseMenu",
    function()
        AmWesteverarbeiten = false
        notifyverarbeitenweste = true
        SetNuiFocus(false, false)

        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

RegisterNetEvent("SevenLife:Farbe:OnWeapon")
AddEventHandler(
    "SevenLife:Farbe:OnWeapon",
    function(color)
        local ped = GetPlayerPed(-1)
        local weapon = GetSelectedPedWeapon(ped)
        SetPedWeaponTintIndex(ped, weapon, color)
    end
)

--Nui Callbacks
RegisterNUICallback(
    "NormaleFarbe",
    function()
        AmWesteverarbeiten = false
        notifyverarbeitenweste = true
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Chekifenoughitems",
            function(enough)
                if enough then
                    TriggerServerEvent("SevenLife:Mine:Crafter:RemoveItems", "eisen", 50, "behälter", 1)
                    SendNUIMessage(
                        {
                            type = "loadingverkauf"
                        }
                    )
                    Citizen.Wait(8500)
                    SendNUIMessage(
                        {
                            type = "removeloadingverkauf"
                        }
                    )
                    TriggerServerEvent("SevenLife:Mine:Crafter:GiveItemEnd", "normalefarbe")
                else
                    TriggerEvent("sevenlife:mine:notenoughitemse")
                end
            end,
            "eisen",
            50,
            "behälter",
            1
        )
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

RegisterNUICallback(
    "GrueneFarbe",
    function()
        AmWesteverarbeiten = false
        notifyverarbeitenweste = true
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Chekifenoughitems",
            function(enough)
                if enough then
                    TriggerServerEvent("SevenLife:Mine:Crafter:RemoveItems", "Eisen", 50, "behälter", 1)
                    SendNUIMessage(
                        {
                            type = "loadingverkauf"
                        }
                    )
                    Citizen.Wait(8500)
                    SendNUIMessage(
                        {
                            type = "removeloadingverkauf"
                        }
                    )
                    TriggerServerEvent("SevenLife:Mine:Crafter:GiveItemEnd", "normalefarbe")
                else
                    TriggerEvent("sevenlife:mine:notenoughitemse")
                end
            end,
            "normalefarbe",
            1,
            "jade",
            1,
            "behälter",
            1
        )
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

RegisterNUICallback(
    "GoldeneFarbe",
    function()
        AmWesteverarbeiten = false
        notifyverarbeitenweste = true
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Chekifenoughitems",
            function(enough)
                if enough then
                    TriggerServerEvent("SevenLife:Mine:Crafter:RemoveItems", "Eisen", 50, "behälter", 1)
                    SendNUIMessage(
                        {
                            type = "loadingverkauf"
                        }
                    )
                    Citizen.Wait(8500)
                    SendNUIMessage(
                        {
                            type = "removeloadingverkauf"
                        }
                    )
                    TriggerServerEvent("SevenLife:Mine:Crafter:GiveItemEnd", "normalefarbe")
                else
                    TriggerEvent("sevenlife:mine:notenoughitemse")
                end
            end,
            "normalefarbe",
            1,
            "gold",
            30,
            "behälter",
            1
        )
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

RegisterNUICallback(
    "PinkeFarbe",
    function()
        AmWesteverarbeiten = false
        notifyverarbeitenweste = true
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Chekifenoughitems",
            function(enough)
                if enough then
                    TriggerServerEvent("SevenLife:Mine:Crafter:RemoveItems", "Eisen", 50, "behälter", 1)
                    SendNUIMessage(
                        {
                            type = "loadingverkauf"
                        }
                    )
                    Citizen.Wait(8500)
                    SendNUIMessage(
                        {
                            type = "removeloadingverkauf"
                        }
                    )
                    TriggerServerEvent("SevenLife:Mine:Crafter:GiveItemEnd", "normalefarbe")
                else
                    TriggerEvent("sevenlife:mine:notenoughitemse")
                end
            end,
            "normalefarbe",
            1,
            "pinkerkristall",
            10,
            "behälter",
            1
        )
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

RegisterNUICallback(
    "OrangeFarbe",
    function()
        AmWesteverarbeiten = false
        notifyverarbeitenweste = true
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Chekifenoughitems",
            function(enough)
                if enough then
                    TriggerServerEvent("SevenLife:Mine:Crafter:RemoveItems", "Eisen", 50, "behälter", 1)
                    SendNUIMessage(
                        {
                            type = "loadingverkauf"
                        }
                    )
                    Citizen.Wait(8500)
                    SendNUIMessage(
                        {
                            type = "removeloadingverkauf"
                        }
                    )
                    TriggerServerEvent("SevenLife:Mine:Crafter:GiveItemEnd", "normalefarbe")
                else
                    TriggerEvent("sevenlife:mine:notenoughitemse")
                end
            end,
            "normalefarbe",
            1,
            "kupfer",
            50,
            "behälter",
            1
        )
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

RegisterNUICallback(
    "Platinium",
    function()
        AmWesteverarbeiten = false
        notifyverarbeitenweste = true

        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Chekifenoughitems",
            function(enough)
                if enough then
                    TriggerServerEvent("SevenLife:Mine:Crafter:RemoveItems", "eisen", 50, "behälter", 1)
                    SendNUIMessage(
                        {
                            type = "loadingverkauf"
                        }
                    )
                    Citizen.Wait(8500)
                    SendNUIMessage(
                        {
                            type = "removeloadingverkauf"
                        }
                    )
                    TriggerServerEvent("SevenLife:Mine:Crafter:GiveItemEnd", "normalefarbe")
                else
                    TriggerEvent("sevenlife:mine:notenoughitemse")
                end
            end,
            "normalefarbe",
            1,
            "platin",
            30,
            "behälter",
            1
        )
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

-- Notify

RegisterNetEvent("sevenlife:mine:notenoughitemse")
AddEventHandler(
    "sevenlife:mine:notenoughitemse",
    function()
        TriggerEvent("SevenLife:TimetCustom:Notify", "Craften", "Dir fehlen Items die du fürs Craften brauchst", 2000)

        AmWesteverarbeiten = false
        notifyverarbeitenweste = true
    end
)
function Removenormalhud()
    Citizen.CreateThread(
        function()
            while AmWesteverarbeiten do
                Citizen.Wait(1)
                DisplayRadar(false)
                TriggerEvent("sevenlife:removeallhud")
            end
        end
    )
end

RegisterNUICallback(
    "kleidungstasche",
    function()
        inmenu = false
        AmWesteverarbeiten = false
        notifyverarbeitenweste = true
        TriggerServerEvent("sevenlife:removeitemstasche")
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)

RegisterNetEvent("sevenlife:nextsteptasche")
AddEventHandler(
    "sevenlife:nextsteptasche",
    function()
        local opennav = true
        while opennav do
            TriggerEvent("sevenlife:removeverarbeiter")
            TriggerEvent("sevenlife:openfirstloadingbar")
            Citizen.Wait(20000)
            TriggerEvent("sevenlife:removefirstloadingbar")
            TriggerServerEvent("sevenlife:givetasche")
            opennav = false
            AmWesteverarbeiten = false
            notifyverarbeitenweste = true
        end
    end
)

RegisterNetEvent("SevenLife:Tasche:Anziehen")
AddEventHandler(
    "SevenLife:Tasche:Anziehen",
    function()
        ESX.TriggerServerCallback(
            "esx_skin:getPlayerSkin",
            function(skin, jobSkin)
                local clothesSkin = {
                    ["bags_1"] = 45,
                    ["bags_2"] = 0
                }
                TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                TriggerEvent(
                    "skinchanger:getSkin",
                    function(skin)
                        TriggerServerEvent("esx_skin:save", skin)
                    end
                )
            end
        )
    end
)

RegisterNetEvent("SevenLife:SaveWeste:SetData")
AddEventHandler(
    "SevenLife:SaveWeste:SetData",
    function(data)
        print(data.Health .. ":" .. data.Armour)
        local playerPed = GetPlayerPed(-1)

        SetEntityHealth(playerPed, tonumber(data.Health))
        AddArmourToPed(playerPed, tonumber(data.Armour))
        SetPedArmour(playerPed, tonumber(data.Armour))
    end
)
