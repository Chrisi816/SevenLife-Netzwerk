-- just some words
notifyallowed = true
local bag = nil
storing = ""
activesound = true
activesmarker = true
soundplayer = GetSoundId()
activerob = false
deletenotify = false
ausgewealt = false
local injuweliermarker = false
lastrobbing = ""
animation = false
local vetrine = 0
local maske
local maske2
onlyone = true
local inmenujuwellier = false
notbreakingvitrine = true
local isOnCreator = false
-- Checks if player have Bags

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
        createblipforjuwellery()
        spawnsellernpcnormal()
    end
)

-- Juwellery Robbery
if Config.enablejuwellery then
    Citizen.CreateThread(
        function()
            while activerob == false do
                Citizen.Wait(1)
                local inmarker = vector3(Config.starterpunkt.x, Config.starterpunkt.y, Config.starterpunkt.z)
                local distancemarker =
                    GetDistanceBetweenCoords(
                    GetEntityCoords(GetPlayerPed(-1)),
                    vector3(inmarker.x, inmarker.y, inmarker.z)
                )
                if activerob == false then
                    drawanmarker()
                    if distancemarker < 1 then
                        if Config.isabagneeded then
                            if bag == 40 or bag == 41 or bag == 44 or bag == 45 then
                                if activesmarker then
                                    TriggerEvent(
                                        "sevenliferp:startnui",
                                        "Schieße um den Raub zu beginnen",
                                        "System-Nachricht",
                                        true
                                    )
                                end

                                if IsPedShooting(GetPlayerPed(-1)) then
                                    deletenpcbuisness()
                                    TriggerEvent("sevenlife:startrob")
                                    activesmarker = false
                                    activerob = true
                                end
                            else
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Du benötigst eine Umhänge - tasche",
                                    "System-Nachricht",
                                    true
                                )
                            end
                        end
                    else
                        if distancemarker >= 1.1 and distancemarker <= 1.5 then
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    if activerob then
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    )
end

-- Starts the Event
RegisterNetEvent("sevenlife:startrob")
AddEventHandler(
    "sevenlife:startrob",
    function()
        Citizen.CreateThread(
            function()
                while activerob do
                    Citizen.Wait(1)
                    local incomputermarker = vector3(Config.computer.x, Config.computer.y, Config.computer.z)
                    local distancecomputer =
                        GetDistanceBetweenCoords(
                        GetEntityCoords(GetPlayerPed(-1)),
                        vector3(incomputermarker.x, incomputermarker.y, incomputermarker.z)
                    )
                    local player = GetPlayerPed(-1)
                    if activesound then
                        PlaySoundFromCoord(
                            soundplayer,
                            "VEHICLES_HORNS_AMBULANCE_WARNING",
                            Config.sound.x,
                            Config.sound.y,
                            Config.sound.z
                        )
                    end
                    if distancecomputer < 1 then
                        if ausgewealt == false then
                            if deletenotify == false then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um mit dem Computer zu interagieren .",
                                    "System-Nachricht",
                                    true
                                )
                            end

                            if IsControlJustReleased(0, 38) then
                                TriggerEvent("sevenlife:showcomputermenuejewellery")
                                deletenotify = true
                                ausgewealt = true
                            end
                        end
                    else
                        if distancecomputer >= 2 and distancecomputer <= 3 then
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                    if onlyone then
                        if deletenotify == true then
                            TriggerEvent("sevenliferp:closenotify", false)
                            onlyone = false
                        end
                    end
                end
            end
        )
    end
)

-- If there are less then 4 Cops

RegisterNetEvent("sevenlife:cancelcopevent")
AddEventHandler(
    "sevenlife:cancelcopevent",
    function()
    end
)

-- BLips for the Juwellery

function createblipforjuwellery()
    if Config.enablejuwelleryblip then
        local blips = vector2(Config.juwelleryblip.x, Config.juwelleryblip.y)
        local blip = AddBlipForCoord(blips.x, blips.y)

        SetBlipSprite(blip, 617)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.2)
        SetBlipColour(blip, 67)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Juwelier")
        EndTextCommandSetBlipName(blip)
    end
end

-- Normal Juwellery Shop, to buy earings etc.

if Config.kleidungsshop then
    Citizen.CreateThread(
        function()
            while true do
                Citizen.Wait(150)
                if activerob == false then
                    local npc = vector3(Config.spawnnormalnpc.x, Config.spawnnormalnpc.y, Config.spawnnormalnpc.z)
                    local distance =
                        GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vector3(npc.x, npc.y, npc.z))

                    if distance < 2 then
                        injuweliermarker = true
                        if notifyallowed then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um mit dem Juwelier zu sprechen",
                                "System-Nachricht",
                                true
                            )
                        else
                            if notifyallowed == false then
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        if distance >= 2.1 and distance <= 4 then
                            injuweliermarker = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                end
            end
        end
    )
end
local Character = {}
Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if injuweliermarker then
                if IsControlJustPressed(0, 38) then
                    if not inmenujuwellier then
                        notifyallowed = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        local ped = GetPlayerPed(-1)
                        local ear1 = GetNumberOfPedPropDrawableVariations(ped, 1) - 1
                        local chain_1 = GetNumberOfPedDrawableVariations(ped, 7) - 1
                        local glasses_1 = GetNumberOfPedPropDrawableVariations(ped, 1) - 1
                        local decals_1 = GetNumberOfPedDrawableVariations(ped, 10) - 1
                        camcoord = GetOffsetFromEntityInWorldCoords(ped, 0.0, 3.0, 0.0)
                        facecoord = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.8, 0.6)
                        clothescoord = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.5, 0.1)
                        glasses = GetOffsetFromEntityGivenWorldCoords(entity, 0.6, 0.65, 0.6)
                        h = GetEntityHeading(ped)
                        heading = GetEntityHeading(ped)
                        isOnCreator = true
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "SendJuweliers",
                                ear1 = ear1,
                                chain_1 = chain_1,
                                glasses_1 = glasses_1,
                                decals_1 = decals_1
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

RegisterNUICallback(
    "CloseMenu",
    function()
        inmenujuwellier = true
        SetNuiFocus(false, false)
        notifyallowed = true
    end
)
-- Spawning an Buisness NPC

function spawnsellernpcnormal()
    local pednumber = tonumber(1)
    for i = 1, pednumber do
        local NpcSpawner = vector3(Config.spawnnormalnpc.x, Config.spawnnormalnpc.y, Config.spawnnormalnpc.z)
        local ped = GetHashKey("a_m_y_business_03")
        if not HasModelLoaded(ped) then
            RequestModel(ped)
            while not HasModelLoaded(ped) do
                Citizen.Wait(1)
            end
            ped1 =
                CreatePed(4, ped, NpcSpawner.x, NpcSpawner.y, NpcSpawner.z, Config.spawnnormalnpc.heading, false, true)
            SetEntityInvincible(ped1, true)
            FreezeEntityPosition(ped1, true)
            SetBlockingOfNonTemporaryEvents(ped1, true)
        end
    end
end

-- Delete the Buisness NPC

function deletenpcbuisness()
    DeletePed(ped1)
end

-- Draw Marker
function drawanmarker()
    DrawMarker(
        27,
        Config.starterpunkt.x,
        Config.starterpunkt.y,
        Config.starterpunkt.z,
        0,
        0,
        0,
        0,
        0,
        0,
        2.001,
        2.0001,
        0.5001,
        255,
        0,
        0,
        200,
        0,
        0,
        0,
        0
    )
end

-- Nui Callbacks
RegisterNUICallback(
    "buttonalarmaus",
    function()
        StopSound(soundplayer)
        activesound = false
    end
)

RegisterNUICallback(
    "buttonraus",
    function()
        TriggerEvent("sevenlife:removecomputermenuejewellery")
        ausgewealt = true
        TriggerEvent("sevenlife:openvetriene")
    end
)

RegisterNetEvent("sevenlife:openvetriene")
AddEventHandler(
    "sevenlife:openvetriene",
    function()
        while activerob do
            Citizen.Wait(1)
            for i, v in pairs(Config.vetrienen) do
                if
                    (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z, true) < 10.0) and
                        not v.isOpen and
                        Config.activemarkers
                 then
                    DrawMarker(20, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 234, 0, 122, 200, 1, 1, 0, 0)
                end
                if
                    (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z, true) < 0.5) and
                        not v.isOpen
                 then
                    if notbreakingvitrine then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um die Vitrine aufzubrechen",
                            "System-Nachricht",
                            true
                        )
                    else
                        if notbreakingvitrine == false then
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end

                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("sevenliferp:closenotify", false)
                        animation = true
                        SetEntityCoords(GetPlayerPed(-1), v.x, v.y, v.z - 0.85)
                        SetEntityHeading(GetPlayerPed(-1), v.heading)
                        v.isOpen = true
                        notbreakingvitrine = false
                        PlaySoundFromCoord(-1, "Glass_Smash", v.x, v.y, v.z, "", 0, 0, 0)
                        if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                            RequestNamedPtfxAsset("scr_jewelheist")
                        end
                        while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                            Citizen.Wait(0)
                        end
                        SetPtfxAssetNextCall("scr_jewelheist")
                        StartParticleFxLoopedAtCoord(
                            "scr_jewel_cab_smash",
                            v.x,
                            v.y,
                            v.z,
                            0.0,
                            0.0,
                            0.0,
                            1.0,
                            false,
                            false,
                            false,
                            false
                        )
                        loadAnimDict("missheist_jewel")
                        TaskPlayAnim(GetPlayerPed(-1), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                        Citizen.Wait(5000)
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                        TriggerServerEvent("sevenlife:getjewels")
                        PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        vetrine = vetrine + 1
                        animazione = false
                        notbreakingvitrine = true
                        if vetrine == Config.vetrienen then
                            for i, v in pairs(vetrine) do
                                v.isOpen = false
                                vetrine = 0
                            end
                            activerob = false
                            spawnsellernpcnormal()
                        end
                    end
                else
                    if
                        (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z, true) >= 0.5) and
                            (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z, true) <= 0.54)
                     then
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    end
)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        deletenpcbuisness()
        StopSound(soundplayer)
    end
)

Citizen.CreateThread(
    function()
        while activerob do
            Citizen.Wait(1)
            if animation == true then
                if not IsEntityPlayingAnim(PlayerPedId(), "missheist_jewel", "smash_case", 3) then
                    TaskPlayAnim(
                        PlayerPedId(),
                        "missheist_jewel",
                        "smash_case",
                        8.0,
                        8.0,
                        -1,
                        17,
                        1,
                        false,
                        false,
                        false
                    )
                end
            end
        end
    end
)

RegisterNUICallback(
    "GetPageOpen",
    function(data)
        local ped = GetPlayerPed(-1)
        if data.chrisi == 1 then
            local glasses_1 = GetNumberOfPedPropDrawableVariations(ped, 1) - 2
            local glasses_2 = GetNumberOfPedPropTextureVariations(ped, 1, "glasses_1")

            local glasses_1 = glasses_1 - 2
            SendNUIMessage(
                {
                    type = "SendJuweliersOpenGlasses",
                    glasses_1 = glasses_1,
                    glasses_2 = glasses_2
                }
            )
        elseif data.chrisi == 2 then
            local ear1 = GetNumberOfPedPropDrawableVariations(ped, 1) - 1
            local ears_2 = GetNumberOfPedPropTextureVariations(ped, 1, "ears_1")
            SendNUIMessage(
                {
                    type = "SendJuweliersOpenEars",
                    ear1 = ear1,
                    ear2 = ears_2
                }
            )
        elseif data.chrisi == 3 then
            local decals_1 = GetNumberOfPedDrawableVariations(ped, 10) - 1
            local decals_2 = GetNumberOfPedTextureVariations(ped, 10, "decals_1")
            SendNUIMessage(
                {
                    type = "SendJuweliersOpenDecals",
                    decals_1 = decals_1,
                    decals_2 = decals_2
                }
            )
        elseif data.chrisi == 4 then
            local chain_1 = GetNumberOfPedDrawableVariations(ped, 7) - 1
            local chain_2 = GetNumberOfPedTextureVariations(ped, 7, "chain_1")
            SendNUIMessage(
                {
                    type = "SendJuweliersOpenChain",
                    chain_1 = chain_1,
                    chain_2 = chain_2
                }
            )
        end
    end
)
function ChangedValue(value1, value2)
    if value1 ~= value2 then
        return true
    else
        return false
    end
end

RegisterNUICallback(
    "MakeArticle",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(maske, data.endvalue1) then
            maske = tonumber(data.endvalue1)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedPropIndex(player, 1, maske, maske2, true)
            local retval1 = GetNumberOfPedTextureVariations(player, 9, maske)
            SendNUIMessage(
                {
                    type = "ColorId",
                    colorid = retval1
                }
            )
        end
    end
)

RegisterNUICallback(
    "MakeArticle2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(maske2, data.endvalue2) then
            maske2 = tonumber(data.endvalue2)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedPropIndex(player, 1, maske, maske2, true)
        end
    end
)
RegisterNetEvent("SevenLife:Char:SetCam")
AddEventHandler(
    "SevenLife:Char:SetCam",
    function(cam)
        plano = cam
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            local ped = PlayerPedId()

            if isOnCreator == true then
                local x, y, z = table.unpack(camcoord)

                -- Camara
                RenderScriptCams(false, false, 0, 1, 0)
                DestroyCam(camara, false)
                if (not DoesCamExist(camara)) then
                    camara = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                    SetCamActive(camara, true)
                    RenderScriptCams(true, false, 0, true, true)
                    SetCamCoord(camara, camcoord)
                    SetCamRot(camara, 0.0, 0.0, h - 180.0)
                end

                if plano == "kopf" then
                    SetCamCoord(camara, facecoord)
                elseif plano == "ropa" then
                    SetCamCoord(camara, clothescoord)
                elseif plano == "tatuajes" then
                    SetCamCoord(camara, x, y + 1.5, z + 0.2)
                elseif plano == "glasses" then
                    SetCamCoord(camara, glasses)
                end

                if heading ~= GetEntityHeading(ped) then
                    SetEntityHeading(ped, heading)
                end
            end
        end
    end
)

RegisterNUICallback(
    "rotation",
    function(data)
        h = GetEntityHeading(PlayerPedId())
        local numbers = tonumber(data.value)
        SetCamRot(camara, 0.0, 0.0, h + numbers)
    end
)
