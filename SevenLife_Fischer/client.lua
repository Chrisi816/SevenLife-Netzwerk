ESX = nil
local times = 100
local active = false
local inmarkers = false
local notifyss = true

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
        Citizen.Wait(1000)
        MakeBlipForFischer()
        for k, v in pairs(Config.FischerSpots) do
            MakeBliping(v.x, v.y, v.z)
        end
    end
)

-- Blips function

function MakeBlipForFischer()
    local blip = AddBlipForCoord(Config.HauptQuartier.x, Config.HauptQuartier.y, Config.HauptQuartier.z)
    SetBlipSprite(blip, 371)
    SetBlipColour(blip, 30)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Fischer Depot")
    EndTextCommandSetBlipName(blip)
end

function MakeBliping(x, y, z)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 317)
    SetBlipColour(blip, 63)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Fischer Spot")
    EndTextCommandSetBlipName(blip)
end

local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_m_prolhost_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.HauptQuartier.x,
                Config.HauptQuartier.y,
                Config.HauptQuartier.z,
                true
            )

            Citizen.Wait(1000)
            pedarea = false
            if distance < 20 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped2 =
                        CreatePed(
                        4,
                        ped,
                        Config.HauptQuartier.x,
                        Config.HauptQuartier.y,
                        Config.HauptQuartier.z,
                        Config.HauptQuartier.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped2, true)
                    FreezeEntityPosition(ped2, true)
                    SetBlockingOfNonTemporaryEvents(ped2, true)
                    pedloaded = true
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped2)
                SetModelAsNoLongerNeeded(ped)
                pedloaded = false
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            Coords = GetEntityCoords(Ped)
            Citizen.Wait(times)
            local distance =
                GetDistanceBetweenCoords(
                Coords,
                Config.HauptQuartier.x,
                Config.HauptQuartier.y,
                Config.HauptQuartier.z,
                true
            )
            if distance < 10 then
                times = 15
                inareas = true
                if distance < 1.6 then
                    times = 5
                    inmarkers = true
                    if notifyss then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um mit dem Fischer Chef zu sprechen!",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.7 and distance <= 8 then
                        inmarkers = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                if distance >= 8 and distance <= 12 then
                    times = 100
                    inareas = false
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

            if inmarkers then
                if IsControlJustPressed(0, 38) then
                    notifyss = false
                    TriggerEvent("sevenliferp:closenotify", false)
                    SetNuiFocus(true, true)

                    ESX.TriggerServerCallback(
                        "SevenLife:Fischer:CheckJob",
                        function(next)
                            if next then
                                active = true
                                RemoveRadar()

                                EnableCam(GetPlayerPed(-1))
                                SendNUIMessage(
                                    {
                                        type = "OpenMainMenuFischer"
                                    }
                                )
                            else
                                SendNUIMessage(
                                    {
                                        type = "OpenWarnung"
                                    }
                                )
                            end
                        end,
                        args
                    )
                end
            else
                Citizen.Wait(100)
            end
        end
    end
)
RegisterNUICallback(
    "ClosePostal",
    function()
        DisableCam()
        notifyss = true
        active = false
        inmarkers = false
        SetNuiFocus(false, false)
        Citizen.Wait(1000)
        DisplayRadar(true)
    end
)
RegisterNUICallback(
    "GivePedJob",
    function()
        TriggerServerEvent("SevenLife:Fischer:GiveJobToPlayer")
        Citizen.Wait(50)
        EnableCam(GetPlayerPed(-1))
        RemoveRadar()
        TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Du bist jetzt Fischer!", 2000)
        SendNUIMessage(
            {
                type = "OpenMainMenuFischer"
            }
        )
    end
)
function EnableCam(player)
    local rx = GetEntityRotation(ped2)
    camrot = rx + vector3(0.0, 0.0, 181)
    local px, py, pz = table.unpack(GetEntityCoords(ped2, true))
    local x, y, z = px + GetEntityForwardX(ped2) * 1.2, py + GetEntityForwardY(ped2) * 1.2, pz + 0.52
    local coords = vector3(x, y, z)
    RenderScriptCams(false, true, 500, 1, 0)
    DestroyCam(cam, false)
    if (not DoesCamExist(cam)) then
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, camrot, GetGameplayCamFov())
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 1500, true, true)
    end
    FreezeEntityPosition(player, true)
end

function DisableCam()
    local player = GetPlayerPed(-1)
    RenderScriptCams(false, true, 1500, 1, 0)
    DestroyCam(cam, false)
    FreezeEntityPosition(player, false)

    FreezeEntityPosition(GetPlayerPed(-1), false)
end

function RemoveRadar()
    Citizen.CreateThread(
        function()
            while active do
                Citizen.Wait(1)
                DisplayRadar(false)
                TriggerEvent("sevenlife:removeallhud")
            end
        end
    )
end

RegisterNUICallback(
    "LetsStartJob",
    function(data)
        local random = math.random(1, 6)
        local coords = Config.Spots[random]
        MarkASpt(coords.x, coords.y, coords.z)
    end
)

function MarkASpt(x, y, z)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 371)
    SetBlipColour(blip, 30)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Fischer Spot")
    EndTextCommandSetBlipName(blip)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 30)
end
local isplayerfisching = false
local minigame
local games = 0
RegisterNetEvent("SevenLife:Fischer:StartFisching")
AddEventHandler(
    "SevenLife:Fischer:StartFisching",
    function()
        playerPed = GetPlayerPed(-1)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        if IsPedInAnyVehicle(playerPed) then
            TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Du kannst in einem Auto nicht fischen!", 2000)
        else
            if IsEntityInWater(PlayerPedId()) then
                if not IsPedSwimming(PlayerPedId()) then
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Fischen gestartet!", 2000)
                    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_STAND_FISHING", 0, true)
                    isplayerfisching = true
                    minigame = math.random(1, 8)
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Information",
                        "Drücke " .. minigame .. "! Um den Fisch zu fangen!",
                        2000
                    )
                    TriggerEvent("SevenLife:Fischer:ActivateTread")
                    fishing()
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Information",
                        "Du kannst beim Schwimmen nicht angeln!",
                        2000
                    )
                end
            else
                TriggerEvent(
                    "SevenLife:TimetCustom:Notify",
                    "Information",
                    "Du musst ins Wasser um Fische zu fangen",
                    2000
                )
            end
        end
    end
)
local input
local bait = "keins"
RegisterNetEvent("SevenLife:Fischer:ActivateTread")
AddEventHandler(
    "SevenLife:Fischer:ActivateTread",
    function()
        Citizen.CreateThread(
            function()
                while true do
                    Citizen.Wait(5)
                    if isplayerfisching and games <= 3 then
                        if IsControlJustPressed(0, 157) then
                            input = 1
                            if input == minigame then
                                games = games + 1
                                minigame = math.random(1, 8)
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Information",
                                    "Drücke " .. minigame .. "! Um den Fisch zu fangen!",
                                    2000
                                )
                            end
                        end
                        if IsControlJustPressed(0, 158) then
                            input = 2
                            if input == minigame then
                                games = games + 1
                                minigame = math.random(1, 8)
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Information",
                                    "Drücke " .. minigame .. "! Um den Fisch zu fangen!",
                                    2000
                                )
                            end
                        end
                        if IsControlJustPressed(0, 160) then
                            input = 3
                            if input == minigame then
                                games = games + 1
                                minigame = math.random(1, 8)
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Information",
                                    "Drücke " .. minigame .. "! Um den Fisch zu fangen!",
                                    2000
                                )
                            end
                        end
                        if IsControlJustPressed(0, 164) then
                            input = 4
                            if input == minigame then
                                games = games + 1
                                minigame = math.random(1, 8)
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Information",
                                    "Drücke " .. minigame .. "! Um den Fisch zu fangen!",
                                    2000
                                )
                            end
                        end
                        if IsControlJustPressed(0, 165) then
                            input = 5
                            if input == minigame then
                                games = games + 1
                                minigame = math.random(1, 8)
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Information",
                                    "Drücke " .. minigame .. "! Um den Fisch zu fangen!",
                                    2000
                                )
                            end
                        end
                        if IsControlJustPressed(0, 159) then
                            input = 6
                            if input == minigame then
                                games = games + 1
                                minigame = math.random(1, 8)
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Information",
                                    "Drücke " .. minigame .. "! Um den Fisch zu fangen!",
                                    2000
                                )
                            end
                        end
                        if IsControlJustPressed(0, 161) then
                            input = 7
                            if input == minigame then
                                games = games + 1
                                minigame = math.random(1, 8)
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Information",
                                    "Drücke " .. minigame .. "! Um den Fisch zu fangen!",
                                    2000
                                )
                            end
                        end
                        if IsControlJustPressed(0, 162) then
                            input = 8
                            if input == minigame then
                                games = games + 1
                                minigame = math.random(1, 8)
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Information",
                                    "Drücke " .. minigame .. "! Um den Fisch zu fangen!",
                                    2000
                                )
                            end
                        end
                    else
                        ClearPedTasks(GetPlayerPed(-1))
                        TriggerServerEvent("SevenLife:Fischer:FischGefangen", bait)
                        isplayerfisching = false
                        games = 0
                        break
                    end
                end
            end
        )
    end
)
RegisterNetEvent("SevenLife:Fischer:ChangeKoeder")
AddEventHandler(
    "SevenLife:Fischer:ChangeKoeder",
    function(koeder)
        bait = koeder
        TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Köder erfolgreich aufgetragen!", 2000)
    end
)
RegisterNetEvent("SevenLife:Fischer:StopFisching")
AddEventHandler(
    "SevenLife:Fischer:StopFisching",
    function()
        fishing = false
        ClearPedTasks(GetPlayerPed(-1))
    end
)
function fishing()
    RequestAnimDict("amb@world_human_stand_fishing@idle_a")
    while not HasAnimDictLoaded("amb@world_human_stand_fishing@idle_a") do
        Citizen.Wait(1)
    end
    rod = AttachEntityToPed("prop_fishing_rod_01", 60309, 0, 0, 0, 0, 0, 0)
    TaskPlayAnim(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_b", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
end
RegisterNetEvent("SevenLife:Fischer:FuerHolz")
AddEventHandler(
    "SevenLife:Fischer:FuerHolz",
    function()
        ESX.Game.SpawnObject(
            "prop_beach_fire",
            GetEntityCoords(GetPlayerPed(-1)),
            function(entity)
                SetEntityInvincible(entity, true)
            end
        )
    end
)
local activatethread = false
Citizen.CreateThread(
    function()
        while true do
            local retval =
                GetClosestObjectOfType(
                GetEntityCoords(GetPlayerPed(-1)),
                2.0,
                "prop_beach_fire",
                true,
                true,
                true,
                true
            )
            Citizen.Wait(100)
            if retval ~= nil then
                local Ped = PlayerPedId()
                local Coords = GetEntityCoords(Ped)
                local entitycoords = GetEntityCoords(retval)
                Citizen.Wait(200)
                local distance = GetDistanceBetweenCoords(Coords, entitycoords, true)
                if distance < 10 then
                    activatethread = true
                    times = 15
                    inareas = true
                    if distance < 1.6 then
                        times1 = 5
                        inmarkers1 = true
                        if notifyss1 then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um Fische anzubraten!",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 1.7 and distance <= 8 then
                            inmarkers = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    if distance >= 8 and distance <= 12 then
                        times = 100
                        activatethread = false
                        inareas1 = false
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
        while true do
            Citizen.Wait(5)
            if activatethread then
                if inmarkers then
                    if IsControlJustPressed(0, 38) then
                        notifyss = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        ESX.TriggerServerCallback(
                            "SevenLife:Fischer:GetIfEnoughFische",
                            function(barsch, karpfen, forelle, lachs)
                                if barsch then
                                    Animation()
                                    Citizen.Wait(5000)
                                    TriggerServerEvent("SevenLife:MakeFischBraten", "barsch")
                                elseif karpfen then
                                    Animation()
                                    Citizen.Wait(5000)
                                    TriggerServerEvent("SevenLife:MakeFischBraten", "karpfen")
                                elseif forelle then
                                    Animation()
                                    Citizen.Wait(5000)
                                    TriggerServerEvent("SevenLife:MakeFischBraten", "forelle")
                                elseif lachs then
                                    Animation()
                                    Citizen.Wait(5000)
                                    TriggerServerEvent("SevenLife:MakeFischBraten", "lachs")
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Information",
                                        "Du besitzt keinen Fisch",
                                        2000
                                    )
                                end
                            end
                        )
                    end
                else
                    Citizen.Wait(500)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

function Animation()
    Citizen.CreateThread(
        function()
            ensureAnimDict("amb@medic@standing@kneel@base")
            TaskPlayAnim(player, "amb@medic@standing@kneel@base", "base", 1.0, -1.0, -1, 1, 0, false, false, false)
            ensureAnimDict("anim@gangops@facility@servers@bodysearch@")
            TaskPlayAnim(
                player,
                "anim@gangops@facility@servers@bodysearch@",
                "player_search",
                1.0,
                -1.0,
                -1,
                1,
                0,
                false,
                false,
                false
            )
            TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Du startest das Backen des Fisches!", 2000)
            SecondProcessCamControls(ped)
            Citizen.Wait(5000)
            ClearPedTasksImmediately(player)
            TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Erfolgreichen Fisch gebacken!", 2000)
        end
    )
end
function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(100)
        end
    end
    return animDict
end
ESX.RegisterUsableItem(
    "bread",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("bread", 1)

        TriggerClientEvent("esx_status:add", source, "hunger", 200000)
        TriggerClientEvent("esx_basicneeds:onEat", source)
        xPlayer.showNotification(_U("used_bread"))
    end
)
