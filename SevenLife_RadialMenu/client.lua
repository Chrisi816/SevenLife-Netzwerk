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
            Citizen.Wait(0)
            while ESX.GetPlayerData().job == nil do
                Citizen.Wait(10)
            end

            PlayerData = ESX.GetPlayerData()
        end
    end
)

-- Variables
local startedmenu = false
local inmenu = false

local activemenu
-- Main Core
Citizen.CreateThread(
    function()
        while true do
            local ped = GetPlayerPed(-1)
            Citizen.Wait(7)
            if inmenu == false then
                if IsControlJustPressed(0, 47) then
                    if IsPedInAnyVehicle(ped, true) then
                        inmenu = true
                        SetCursorLocation(0.5, 0.5)
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenMenuAuto"
                            }
                        )
                        PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
                    else
                        inmenu = true
                        if PlayerData.job.name == "police" then
                            activemenu = "police"
                        end
                        if PlayerData.job.name == "ambulance" then
                            activemenu = "medic"
                        end
                        SetCursorLocation(0.5, 0.5)
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenMenu",
                                activepolicemenu = activemenu
                            }
                        )
                        PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
                    end
                end
            else
                Citizen.Wait(100)
            end
        end
    end
)

RegisterNUICallback(
    "CloseMenu",
    function()
        if startedmenu == false then
            SetNuiFocus(false, false)
        end

        inmenu = false
        PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    end
)

RegisterNUICallback(
    "Car",
    function()
        Citizen.CreateThread(
            function()
                local player = GetPlayerPed(-1)
                local coords = GetEntityCoords(player)
                local alreadylocked = false
                cars = ESX.Game.GetVehiclesInArea(coords, 20)
                local carstring = {}
                local cardist = {}
                notowned = 0
                if #cars == 0 then
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Fahrzeug",
                        "In der Nähe ist kein Auto vorhanden",
                        2000
                    )
                else
                    for j = 1, #cars, 1 do
                        local coordscar = GetEntityCoords(cars[j])
                        local distance = Vdist(coordscar.x, coordscar.y, coordscar.z, coords.x, coords.y, coords.z)
                        table.insert(cardist, {cars[j], distance})
                    end
                    for k = 1, #cardist, 1 do
                        local z = -1
                        local car
                        local distance = 999
                        for l = 1, #cardist, 1 do
                            if cardist[l][2] < distance then
                                distance = cardist[l][2]
                                car = cardist[l][1]
                                z = l
                            end
                        end
                        if z ~= -1 then
                            table.remove(cardist, z)
                            table.insert(carstring, car)
                        end
                    end
                    for i = 1, #carstring, 1 do
                        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(carstring[i]))
                        ESX.TriggerServerCallback(
                            "SevenLife:CarLock:isVehicleOwner",
                            function(owner)
                                if owner and alreadylocked ~= true then
                                    local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(carstring[i]))
                                    vehicleLabel = GetLabelText(vehicleLabel)
                                    local lock = GetVehicleDoorLockStatus(carstring[i])
                                    if lock == 1 or lock == 0 then
                                        SetVehicleDoorShut(carstring[i], 0, false)
                                        SetVehicleDoorShut(carstring[i], 1, false)
                                        SetVehicleDoorShut(carstring[i], 2, false)
                                        SetVehicleDoorShut(carstring[i], 3, false)
                                        SetVehicleDoorsLocked(carstring[i], 2)
                                        PlayVehicleDoorCloseSound(carstring[i], 1)
                                        Citizen.CreateThread(
                                            function()
                                                TriggerEvent(
                                                    "SevenLife:TimetCustom:Notify",
                                                    "Fahrzeug",
                                                    "Du hast dein " .. vehicleLabel .. " verschlossen",
                                                    1000
                                                )
                                            end
                                        )
                                        if not IsPedInAnyVehicle(PlayerPedId(), true) then
                                            TaskPlayAnim(
                                                PlayerPedId(),
                                                dict,
                                                "fob_click_fp",
                                                8.0,
                                                8.0,
                                                -1,
                                                48,
                                                1,
                                                false,
                                                false,
                                                false
                                            )
                                        end
                                        SetVehicleLights(carstring[i], 2)
                                        Citizen.Wait(150)
                                        SetVehicleLights(carstring[i], 0)
                                        Citizen.Wait(150)
                                        SetVehicleLights(carstring[i], 2)
                                        Citizen.Wait(150)
                                        SetVehicleLights(carstring[i], 0)
                                        alreadylocked = true
                                    elseif lock == 2 then
                                        SetVehicleDoorsLocked(carstring[i], 1)
                                        PlayVehicleDoorOpenSound(carstring[i], 0)
                                        Citizen.CreateThread(
                                            function()
                                                TriggerEvent(
                                                    "SevenLife:TimetCustom:Notify",
                                                    "Fahrzeug",
                                                    "Du hast dein " .. vehicleLabel .. " aufgeschlossen",
                                                    1000
                                                )
                                            end
                                        )

                                        if not IsPedInAnyVehicle(PlayerPedId(), true) then
                                            TaskPlayAnim(
                                                PlayerPedId(),
                                                dict,
                                                "fob_click_fp",
                                                8.0,
                                                8.0,
                                                -1,
                                                48,
                                                1,
                                                false,
                                                false,
                                                false
                                            )
                                        end
                                        SetVehicleLights(carstring[i], 2)
                                        Citizen.Wait(150)
                                        SetVehicleLights(carstring[i], 0)
                                        Citizen.Wait(150)
                                        SetVehicleLights(carstring[i], 2)
                                        Citizen.Wait(150)
                                        SetVehicleLights(carstring[i], 0)
                                        alreadylocked = true
                                    end
                                else
                                    notowned = notowned + 1
                                end
                                if notowned == #carstring then
                                    Citizen.CreateThread(
                                        function()
                                            TriggerEvent(
                                                "SevenLife:TimetCustom:Notify",
                                                "Fahrzeug",
                                                "In der Nähe ist kein Auto vorhanden",
                                                2000
                                            )
                                        end
                                    )
                                end
                            end,
                            plate
                        )
                    end
                end
            end
        )
    end
)
local out = false
RegisterNUICallback(
    "CarMotor",
    function()
        if IsPedInAnyVehicle(ped, false) then
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                local state = not GetIsVehicleEngineRunning(vehicle)
                local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                if state then
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Fahrzeug",
                        "Du hast dein Fahrzeug Namens " .. vehicleLabel .. " angschaltet",
                        1500
                    )
                    out = false
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Fahrzeug",
                        "Du hast dein Fahrzeug Namens " .. vehicleLabel .. " ausgeschaltet",
                        1500
                    )
                    out = true
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(300)
            ped = GetPlayerPed(-1)
            vehicle = GetVehiclePedIsIn(ped, false)
            if inperso then
                Citizen.Wait(6000)
                SendNUIMessage({type = "removeperso"})
                inperso = false
            end
            if inlizenzen then
                Citizen.Wait(6000)
                SendNUIMessage({type = "removelizenzen"})
                inlizenzen = false
            end
            if persogive then
                Citizen.Wait(6000)
                SendNUIMessage({type = "removeperso"})
                persogive = false
            end

            if out then
                SetVehicleEngineOn(vehicle, false, true, false)
                SetVehicleJetEngineOn(vehicle, false)
            else
                SetVehicleEngineOn(vehicle, true, true, false)
                SetVehicleJetEngineOn(vehicle, true)
                if IsPedInAnyHeli(ped) then
                    SetHeliBladesFullSpeed(vehicle)
                end
            end
        end
    end
)

RegisterNUICallback(
    "Heanderhochanim",
    function()
        if DoesEntityExist(ped) and not IsEntityDead(ped) then
            if IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3) then
                ClearPedSecondaryTask(ped)
            else
                loadAnimDict("random@mugging3")
                TaskPlayAnim(ped, "random@mugging3", "handsup_standing_base", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                RemoveAnimDict("random@mugging3")
            end
        end
    end
)
RegisterNUICallback(
    "arrestanim",
    function()
        if DoesEntityExist(ped) and not IsEntityDead(ped) then
            if IsEntityPlayingAnim(ped, "random@arrests", "generic_radio_chatter", 3) then
                ClearPedSecondaryTask(ped)
            else
                loadAnimDict("random@arrests")
                TaskPlayAnim(ped, "random@arrests", "generic_radio_chatter", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                RemoveAnimDict("random@arrests")
            end
        end
    end
)
local crouched = false
RegisterNUICallback(
    "duckenanim",
    function()
        if DoesEntityExist(ped) and not IsEntityDead(ped) then
            RequestAnimSet("move_ped_crouched")

            while (not HasAnimSetLoaded("move_ped_crouched")) do
                Citizen.Wait(100)
            end

            if (crouched == true) then
                ResetPedMovementClipset(ped, 0)
                crouched = false
            elseif (crouched == false) then
                SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
                crouched = true
            end
        end
    end
)
function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(500)
    end
end
RegisterNUICallback(
    "lizenzzeigen",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:RadialMenu:CheckIfPlayerHaveItem",
            function(valid)
                if valid then
                    local ped = GetPlayerPed(-1)
                    local coords = GetEntityCoords(ped)
                    local player, distance = ESX.Game.GetClosestPlayer(coords)
                    if distance ~= -1 and distance <= 3.0 then
                        TriggerServerEvent("SevenLife:RadialMenu:ShowLizenz", GetPlayerServerId(player))
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Personalien", "Keine Spieler in der Nähe", 1500)
                    end
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Personalien", "Du besitzt kein Lizenz Buch", 1500)
                end
            end,
            "lizenzbuch"
        )
    end
)

local opendoor = false
local opentrunk = false
local opentusk = false
RegisterNUICallback(
    "tueropen",
    function()
        local vehicle = GetVehiclePedIsUsing(PlayerPedId())
        if opendoor == false then
            opendoor = true
            SetVehicleDoorOpen(vehicle, 0, false, false)
            SetVehicleDoorOpen(vehicle, 1, false, false)
            SetVehicleDoorOpen(vehicle, 2, false, false)
            SetVehicleDoorOpen(vehicle, 3, false, false)
        else
            if opendoor then
                opendoor = false
                SetVehicleDoorShut(vehicle, 0, false, false)
                SetVehicleDoorShut(vehicle, 1, false, false)
                SetVehicleDoorShut(vehicle, 2, false, false)
                SetVehicleDoorShut(vehicle, 3, false, false)
            end
        end
    end
)
RegisterNUICallback(
    "kofferopen",
    function()
        local vehicle = GetVehiclePedIsUsing(PlayerPedId())
        if opentrunk == false then
            opentrunk = true
            SetVehicleDoorOpen(vehicle, 5, false, false)
        else
            if opentrunk then
                opentrunk = false
                SetVehicleDoorShut(vehicle, 5, false, false)
            end
        end
    end
)

RegisterNUICallback(
    "motoropen",
    function()
        local vehicle = GetVehiclePedIsUsing(PlayerPedId())
        if opentusk == false then
            opentusk = true
            SetVehicleDoorOpen(vehicle, 4, false, false)
        else
            if opentusk then
                opentusk = false
                SetVehicleDoorShut(vehicle, 4, false, false)
            end
        end
    end
)
RegisterNUICallback(
    "vordersitz",
    function()
        local vehicle = GetVehiclePedIsUsing(PlayerPedId())
        local player = GetPedInVehicleSeat(vehicle, 2)
        if player ~= 0 then
            TaskLeaveVehicle(player, vehicle, 0)
        else
            TriggerEvent(
                "SevenLife:TimetCustom:Notify",
                "Auto",
                "Auf diesem Sitz gibt es keine Person, welche rausgeworfen werden können",
                1500
            )
        end
    end
)
RegisterNUICallback(
    "hintenlinks",
    function()
        local vehicle = GetVehiclePedIsUsing(PlayerPedId())
        local player = GetPedInVehicleSeat(vehicle, 3)
        if player ~= 0 then
            TaskLeaveVehicle(player, vehicle, 0)
        else
            TriggerEvent(
                "SevenLife:TimetCustom:Notify",
                "Auto",
                "Auf diesem Sitz gibt es keine Person, welche rausgeworfen werden können",
                1500
            )
        end
    end
)

RegisterNUICallback(
    "hintenrechts",
    function()
        local vehicle = GetVehiclePedIsUsing(PlayerPedId())
        local player = GetPedInVehicleSeat(vehicle, 4)
        if player ~= 0 then
            TaskLeaveVehicle(player, vehicle, 0)
        else
            TriggerEvent(
                "SevenLife:TimetCustom:Notify",
                "Auto",
                "Auf diesem Sitz gibt es keine Person, welche rausgeworfen werden können",
                1500
            )
        end
    end
)

RegisterNUICallback(
    "seeperso",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:RadialMenu:CheckIfPlayerHaveItem",
            function(valid)
                if valid then
                    ESX.TriggerServerCallback(
                        "SevenLife:RadialMenu:GetPersoData",
                        function(data)
                            inperso = true
                            SendNUIMessage(
                                {
                                    type = "OpenPerso",
                                    name = data[1].name,
                                    birth = data[1].dateofbirth,
                                    erstellen = data[1].datumerstellen
                                }
                            )
                        end
                    )
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Personalien", "Du besitzt keine Personalien", 1500)
                end
            end,
            "IDcard"
        )
    end
)

RegisterNUICallback(
    "giveperso",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:RadialMenu:CheckIfPlayerHaveItem",
            function(valid)
                if valid then
                    ESX.TriggerServerCallback(
                        "SevenLife:RadialMenu:GetPersoData",
                        function(data)
                            local player, distance = ESX.Game.GetClosestPlayer()

                            if distance ~= -1 and distance <= 3.0 then
                                TriggerServerEvent(
                                    "SevenLife:RadialMenu:OpenPerso",
                                    data,
                                    GetPlayerServerId(PlayerId()),
                                    GetPlayerServerId(player)
                                )
                            else
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Personalien",
                                    "Keine Spieler in der Nähe",
                                    1500
                                )
                            end
                        end
                    )
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Personalien", "Du besitzt keine Personalien", 1500)
                end
            end,
            "IDcard"
        )
    end
)

local persogive = false
RegisterNetEvent("SevenLife:RadialMenu:OpenPersoTarget")
AddEventHandler(
    "SevenLife:RadialMenu:OpenPersoTarget",
    function(data)
        persogive = true
        SendNUIMessage(
            {
                type = "OpenPerso",
                name = data[1].name,
                birth = data[1].dateofbirth,
                erstellen = data[1].datumerstellen
            }
        )
    end
)

RegisterNUICallback(
    "lizenzsehen",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:RadialMenu:CheckIfPlayerHaveItem",
            function(valid)
                if valid then
                    ESX.TriggerServerCallback(
                        "SevenLife:RadialMenu:GetPersoData",
                        function(data)
                            ESX.TriggerServerCallback(
                                "SevenLife:RadialMenu:GetPersoDataLizenzen",
                                function(datas)
                                    inlizenzen = true
                                    SendNUIMessage(
                                        {
                                            type = "OpenLizenzen",
                                            name = data[1].lastname,
                                            birth = data[1].dateofbirth,
                                            results = {
                                                driverlicense = datas[1].driverlicense,
                                                bootlicense = datas[1].bootlicense,
                                                lkwlicense = datas[1].lkwlicense,
                                                motorlicense = datas[1].motorlicense,
                                                gunlicense = datas[1].gunlicense
                                            }
                                        }
                                    )
                                end
                            )
                        end
                    )
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Personalien", "Du besitzt kein Lizenz Buch!", 1500)
                end
            end,
            "lizenzbuch"
        )
    end
)

local animalspawned = false
RegisterNUICallback(
    "GetHaustierData",
    function()
        if not animalspawned then
            ESX.TriggerServerCallback(
                "SevenLife:RadialMenu:GetPlayerPed",
                function(result)
                    if result[1] ~= nil then
                        Citizen.Wait(500)
                        startedmenu = true
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "getpedmenu",
                                results = result
                            }
                        )
                    else
                        SetNuiFocus(false, false)
                        inmenu = false
                        SendNUIMessage(
                            {
                                type = "removepetlicense"
                            }
                        )
                    end
                end
            )
        else
            inmenu = false
            SendNUIMessage(
                {
                    type = "removepetlicense"
                }
            )
            TriggerEvent(
                "SevenLife:TimetCustom:Notify",
                "Haustiere",
                "Du musst noch etwas warten um ein neues Tier zu spawnen",
                1500
            )
        end
    end
)
local ped1
local model
local objCoords
local come = 0
local isAttached, getball, inanimation, balle = false, false, false, false
RegisterNUICallback(
    "spawnpet",
    function(data)
        SetNuiFocus(false, false)
        startedmenu = false
        animalspawned = true
        local types = tonumber(data.types)

        if types == 1 then -- Rotweiler
            model = "A_C_Chop_02"
            come = 1
            makepet()
        elseif types == 2 then -- Pudel
            model = "A_C_Poodle"
            come = 1
            makepet()
        elseif types == 3 then -- Mops
            model = "A_C_Pug"
            come = 1
            makepet()
        elseif types == 4 then -- G.Retriever
            model = "A_C_Retriever"
            come = 1
            makepet()
        elseif types == 5 then -- Bolognerser
            model = "A_C_MtLion"
            come = 1
            makepet()
        elseif types == 6 then -- G.hirte
            model = "A_C_shepherd"
            come = 1
            makepet()
        elseif types == 7 then -- Husky
            model = "A_C_Husky"
            come = 1
            makepet()
        end
        Citizen.CreateThread(
            function()
                Citizen.Wait(10 * 60000)
                animalspawned = false
            end
        )
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(5000)
        DoRequestModel("A_C_Chop_02") -- chien
        DoRequestModel("A_C_Poodle") -- chien
        DoRequestModel("A_C_Pug") -- husky
        DoRequestModel("A_C_Retriever") -- caniche
        DoRequestModel("A_C_MtLion") -- carlin
        DoRequestModel("A_C_shepherd") -- retriever
        DoRequestModel("A_C_Husky") -- berger
    end
)

function makepet()
    Citizen.CreateThread(
        function()
            local playerPed = PlayerPedId()
            local LastPedPosition = GetEntityCoords(playerPed)
            local GroupHandle = GetPlayerGroup(PlayerId())

            DoRequestAnimSet("rcmnigel1c")

            TaskPlayAnim(playerPed, "rcmnigel1c", "hailing_whistle_waive_a", 8.0, -8, -1, 120, 0, false, false, false)

            Citizen.SetTimeout(
                5000,
                function()
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(1)
                    end
                    ped1 =
                        CreatePed(28, model, LastPedPosition.x + 1, LastPedPosition.y + 1, LastPedPosition.z - 1, 1, 1)

                    SetPedAsGroupLeader(playerPed, GroupHandle)
                    SetPedAsGroupMember(ped1, GroupHandle)
                    SetPedNeverLeavesGroup(ped1, true)
                    SetPedCanBeTargetted(ped1, false)
                    SetEntityAsMissionEntity(ped1, true, true)
                    print(ped1)
                    Citizen.Wait(5)
                    attached()
                    Citizen.Wait(5)
                    detached()
                end
            )
        end
    )
end

function attached()
    local GroupHandle = GetPlayerGroup(PlayerId())
    SetGroupSeparationRange(GroupHandle, 1.9)
    SetPedNeverLeavesGroup(ped, false)
    FreezeEntityPosition(ped, true)
end

function detached()
    local GroupHandle = GetPlayerGroup(PlayerId())
    SetGroupSeparationRange(GroupHandle, 999999.9)
    SetPedNeverLeavesGroup(ped, true)
    SetPedAsGroupMember(ped, GroupHandle)
    FreezeEntityPosition(ped, false)
end

function DoRequestModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(1)
    end
end

function DoRequestAnimSet(anim)
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(1)
    end
end

RegisterNUICallback(
    "DespawnHaustier",
    function()
        inmenu = false
        if animalspawned then
            animalspawned = false
            local GroupHandle = GetPlayerGroup(PlayerId())
            local coords = GetEntityCoords(PlayerPedId())
            TriggerEvent("SevenLife:TimetCustom:Notify", "Haustiere", "Dein Haustier kehr wieder heim", 1500)

            SetGroupSeparationRange(GroupHandle, 1.9)
            SetPedNeverLeavesGroup(ped1, false)
            TaskGoToCoordAnyMeans(ped1, coords.x + 40, coords.y, coords.z, 5.0, 0, 0, 786603, 0xbf800000)

            Citizen.Wait(5000)
            DeleteEntity(ped1)
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Haustiere", "Du hast noch kein Haustier gespawnt", 1500)
        end
    end
)

RegisterNUICallback(
    "GetBall",
    function()
        inmenu = false
        local pedCoords = GetEntityCoords(ped)
        object = GetClosestObjectOfType(pedCoords, 190.0, GetHashKey("w_am_baseball"))

        if DoesEntityExist(object) then
            balle = true
            objCoords = GetEntityCoords(object)
            TaskGoToCoordAnyMeans(ped, objCoords, 5.0, 0, 0, 786603, 0xbf800000)
            local GroupHandle = GetPlayerGroup(PlayerId())
            SetGroupSeparationRange(GroupHandle, 1.9)
            SetPedNeverLeavesGroup(ped, false)
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Haustiere", "In der nähe liegt kein Ball", 1500)
        end
    end
)

local inanimation = false
RegisterNUICallback(
    "hinlegen",
    function()
        if animalspawned then
            if not inanimation then
                inanimation = true
                DoRequestAnimSet("creatures@rottweiler@amb@sleep_in_kennel@")
                TaskPlayAnim(
                    ped1,
                    "creatures@rottweiler@amb@sleep_in_kennel@",
                    "sleep_in_kennel",
                    8.0,
                    -8,
                    -1,
                    1,
                    0,
                    false,
                    false,
                    false
                )
            else
                inanimation = false
                ClearPedTasks(ped1)
            end
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Haustiere", "Du hast noch kein Haustier gespawnt", 1500)
        end
    end
)
RegisterNUICallback(
    "attech",
    function()
        if animalspawned then
            if not IsPedSittingInAnyVehicle(ped) then
                if isAttached == false then
                    attachedPED()
                    isAttached = true
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Haustiere", "Haustier verfolgt dich nicht mehr", 1500)
                else
                    detachedPED()
                    isAttached = false
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Haustiere", "Haustier verfolgt dich wieder", 1500)
                end
            else
                TriggerEvent(
                    "SevenLife:TimetCustom:Notify",
                    "Haustiere",
                    "Du musst aus dem Auto raus um diese Aktion zu vollführen",
                    1500
                )
            end
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Haustiere", "Du hast noch kein Haustier gespawnt", 1500)
        end
    end
)

function attachedPED()
    local GroupHandle = GetPlayerGroup(PlayerId())
    SetGroupSeparationRange(GroupHandle, 1.9)
    SetPedNeverLeavesGroup(ped1, false)
    FreezeEntityPosition(ped1, true)
    DoRequestAnimSet("creatures@rottweiler@amb@world_dog_sitting@base")
    TaskPlayAnim(
        ped1,
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "base",
        8.0,
        -8,
        -1,
        1,
        0,
        false,
        false,
        false
    )
end

function detachedPED()
    local GroupHandle = GetPlayerGroup(PlayerId())
    SetGroupSeparationRange(GroupHandle, 999999.9)
    SetPedNeverLeavesGroup(ped1, true)
    SetPedAsGroupMember(ped1, GroupHandle)
    FreezeEntityPosition(ped1, false)
    ClearPedTasks(ped1)
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(150)

            if balle then
                local coords1 = GetEntityCoords(PlayerPedId())
                local coords2 = GetEntityCoords(ped1)
                local distance = GetDistanceBetweenCoords(objCoords, coords2, true)

                if distance < 0.5 then
                    local boneIndex = GetPedBoneIndex(ped1, 17188)
                    AttachEntityToEntity(
                        object,
                        ped1,
                        boneIndex,
                        0.120,
                        0.010,
                        0.010,
                        5.0,
                        150.0,
                        0.0,
                        true,
                        true,
                        false,
                        true,
                        1,
                        true
                    )
                    TaskGoToCoordAnyMeans(ped1, coords1, 5.0, 0, 0, 786603, 0xbf800000)
                    balle = false
                    getball = true
                end
            end

            if getball then
                local coords1 = GetEntityCoords(PlayerPedId())
                local coords2 = GetEntityCoords(ped1)
                local distance2 = GetDistanceBetweenCoords(coords1, coords2, true)

                if distance2 < 1.5 then
                    DetachEntity(object, false, false)
                    Citizen.Wait(50)
                    SetEntityAsMissionEntity(object)
                    DeleteEntity(object)
                    GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BALL"), 1, false, true)
                    local GroupHandle = GetPlayerGroup(PlayerId())
                    SetGroupSeparationRange(GroupHandle, 999999.9)
                    SetPedNeverLeavesGroup(ped1, true)
                    SetPedAsGroupMember(ped1, GroupHandle)
                    getball = false
                end
            end
        end
    end
)
RegisterNUICallback(
    "handschellen",
    function()
        TriggerEvent("SevenLife:PD:HandCuffAction")
    end
)
RegisterNUICallback(
    "tragen",
    function()
        TriggerEvent("SevenLife:PD:tragen")
    end
)
RegisterNUICallback(
    "autotragen",
    function()
        TriggerEvent("SevenLife:PD:autotragen")
    end
)
RegisterNUICallback(
    "putingefeangnis",
    function()
        print("hey")
        TriggerEvent("SevenLife:PD:SetPlayerIntoPrison")
    end
)
RegisterNUICallback(
    "schluesselverleih",
    function()
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local player = GetPedInVehicleSeat(vehicle, 0)
        local plate = GetVehicleNumberPlateText(vehicle)

        if player ~= nil and player ~= 0 then
            ESX.TriggerServerCallback(
                "SevenLife:Auto:CheckIfPlayerHaveSeatItem",
                function(havitem)
                    if havitem then
                        TriggerServerEvent(
                            "SevenLife:Auto:AddSchlüssel",
                            GetPlayerFromIndex(player),
                            ESX.Math.Trim(plate)
                        )
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Auto", "Du brauchst ein paar Schlüssel", 1500)
                    end
                end
            )
        else
            TriggerEvent(
                "SevenLife:TimetCustom:Notify",
                "Auto",
                "Du hast keinen Beifahrer welcher einen Schlüssel empfangen könnte",
                1500
            )
        end
    end
)
RegisterNetEvent("SevenLife:RadialMenu:OpenOtherSide")
AddEventHandler(
    "SevenLife:RadialMenu:OpenOtherSide",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:RadialMenu:GetPersoData",
            function(data)
                ESX.TriggerServerCallback(
                    "SevenLife:RadialMenu:GetPersoDataLizenzen",
                    function(datas)
                        inlizenzen = true
                        SendNUIMessage(
                            {
                                type = "OpenLizenzen",
                                name = data[1].lastname,
                                birth = data[1].dateofbirth,
                                results = {
                                    driverlicense = datas[1].driverlicense,
                                    bootlicense = datas[1].bootlicense,
                                    lkwlicense = datas[1].lkwlicense,
                                    motorlicense = datas[1].motorlicense,
                                    gunlicense = datas[1].gunlicense
                                }
                            }
                        )
                    end
                )
            end
        )
    end
)
RegisterNUICallback(
    "GetAnim",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Anims:GetAnims",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenAnim",
                        result = result
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "DurchsuchePerson",
    function()
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local player, distance = ESX.Game.GetClosestPlayer(coords)
        if player == -1 or distance > 2.0 then
            TriggerEvent("SevenLife:TimetCustom:Notify", "Durchsuchen", "Kein Spieler vorhanden!", 1500)
            SetNuiFocus(false, false)
            inmenu = false
        else
            if CheckIsPedDead() then
                SetNuiFocus(false, false)
                inmenu = false
                TriggerEvent("SevenLife:TimetCustom:Notify", "Durchsuchen", "Der Spieler ist tot!", 1500)
            else
                local searchPlayerPed = GetPlayerPed(player)
                if
                    IsEntityPlayingAnim(searchPlayerPed, "random@mugging3", "handsup_standing_base", 3) or
                        IsEntityDead(searchPlayerPed) or
                        GetEntityHealth(searchPlayerPed) <= 0
                 then
                    TriggerServerEvent("SevenLife:Inventory:OpenInvDurchsuchen", GetPlayerServerId(player))
                else
                    SetNuiFocus(false, false)
                    inmenu = false
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Durchsuchen", "Etwas ist schief gelaufen!", 1500)
                end
            end
        end
    end
)
function CheckIsPedDead()
    local target, distance = ESX.Game.GetClosestPlayer()
    local searchPlayerPed = GetPlayerPed(target)
    if IsPedDeadOrDying(searchPlayerPed) then
        return true
    end
    return false
end

RegisterNUICallback(
    "wiederbeleben",
    function()
        TriggerEvent("SevenLife:DeathScreen:Wiederbeleben")
    end
)
RegisterNUICallback(
    "pillen",
    function()
        TriggerEvent("SevenLife:DeathScreen:pillen")
    end
)
RegisterNUICallback(
    "carrymmedic",
    function()
        TriggerEvent("SevenLife:Medic:carrymmedic")
    end
)
RegisterNUICallback(
    "putinvehicle",
    function()
        TriggerEvent("SevenLife:Medic:putinvehicle")
    end
)
RegisterNUICallback(
    "rechnungmedic",
    function()
        TriggerEvent("SevenLife:Medic:rechnung")
    end
)
RegisterNUICallback(
    "medikamente",
    function()
        TriggerEvent("SevenLife:Medic:medikamente")
    end
)
