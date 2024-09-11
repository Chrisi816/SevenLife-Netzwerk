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

local registered = false
local group, statuse
local currentidentifier

local activchat = true
local noClippingEntity

local previousVelocity = vector3(0, 0, 0)
-- Lerp
function Lerp(a, b, t)
    return a + (b - a) * t
end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        ESX.PlayerData = xPlayer
        ESX.TriggerServerCallback(
            "SevenLife:Admin:CheckPerms",
            function(result)
                if result[1] ~= nil then
                    if result[1].group == "admin" and result[1].statuse ~= "Spieler" then
                        registered = true
                        group = result[1].group
                        statuse = result[1].statuse
                        TriggerEvent("SevenLife:Admin:StartCheckButton")
                    end
                end
            end
        )
        ESX.TriggerServerCallback(
            "SevenLife:Admin:GetOptionen",
            function(result)
                activchat = result
            end
        )
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(job)
        ESX.PlayerData.job = job
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)

            if IsControlJustPressed(0, 301) then
                SetNuiFocus(true, true)
                ESX.TriggerServerCallback(
                    "SevenLife:Admin:GetInformationen",
                    function(activeusers, adminse, warns, hour, day, Bans, admins, ticketsactiv)
                        SendNUIMessage(
                            {
                                type = "OpenMenu",
                                activeusers = activeusers,
                                adminse = adminse,
                                warns = warns,
                                hour = hour,
                                day = day,
                                Bans = Bans,
                                admins = admins,
                                ticketsactiv = ticketsactiv
                            }
                        )
                    end
                )
            end
        end
    end
)
RegisterNUICallback(
    "GetMainTicket",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Admin:GetTicketDetails",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenTickets",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
    end
)
RegisterNUICallback(
    "ShowDetails",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Admin:GetTicketDetailsDetails",
            function(resulstiem, ticketdetails)
                SendNUIMessage(
                    {
                        type = "DisplayTicketDetail",
                        tickets = resulstiem,
                        ticketdetails = ticketdetails
                    }
                )
            end,
            data.id
        )
    end
)
RegisterNUICallback(
    "MakeNachricht",
    function(data)
        TriggerServerEvent("SevenLife:Admin:MakeNachricht", data.inputting, data.id)
    end
)

RegisterNetEvent("SevenLife:Admin:UpdateTicketChat")
AddEventHandler(
    "SevenLife:Admin:UpdateTicketChat",
    function(res)
        SendNUIMessage(
            {
                type = "UpdateChat",
                result = res
            }
        )
    end
)
RegisterNUICallback(
    "DeleteTicket",
    function(data)
        TriggerServerEvent("SevenLife:Admin:DelTicket", data.id, data.identifier)
    end
)
RegisterNetEvent("SevenLife:Admin:UpdateAdminList")
AddEventHandler(
    "SevenLife:Admin:UpdateAdminList",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Admin:GetTicketDetails",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateTicket",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "tpspielerzumir",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        TriggerServerEvent("SevenLife:Admin:TPSpielerzumir", coords, data.identifier)
    end
)
RegisterNetEvent("SevenLife:Admin:TPPlayer")
AddEventHandler(
    "SevenLife:Admin:TPPlayer",
    function(coords)
        local ped = GetPlayerPed(-1)
        RequestCollisionAtCoord(coords)
        FreezeEntityPosition(ped, true)

        SetEntityCoords(ped, coords, false, false, false, false)
        while not HasCollisionLoadedAroundEntity(ped) do
            Citizen.Wait(0)
        end
        FreezeEntityPosition(ped, false)
        Citizen.Wait(100)
        TriggerEvent("sevenliferp:closenotify", false)
    end
)
RegisterNUICallback(
    "tpzumspieler",
    function(data)
        TriggerServerEvent("SevenLife:Admin:tpzumspieler", data.identifier)
    end
)
RegisterNetEvent("SevenLife:Admin:TPPlayers")
AddEventHandler(
    "SevenLife:Admin:TPPlayers",
    function(coords)
        local ped = GetPlayerPed(-1)
        RequestCollisionAtCoord(coords)
        FreezeEntityPosition(ped, true)

        SetEntityCoords(ped, coords, false, false, false, false)
        while not HasCollisionLoadedAroundEntity(ped) do
            Citizen.Wait(0)
        end
        FreezeEntityPosition(ped, false)
        Citizen.Wait(100)
        TriggerEvent("sevenliferp:closenotify", false)
    end
)
RegisterNetEvent("SevenLife:Admin:GetCoords")
AddEventHandler(
    "SevenLife:Admin:GetCoords",
    function(identifier, source)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        TriggerServerEvent("SevenLife:Admin:Tpzumspieleradmin", coords, identifier, source)
    end
)

RegisterNUICallback(
    "GetPlayerOptions",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Admin:GetPlayers",
            function(result)
                SendNUIMessage(
                    {
                        type = "InsertPlayers",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "GetDetailInfoAboutPlayer",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Admin:GetInfosAboutPlayer",
            function(playtime, steamid, license, discord, xbl, liveid, notizen, warns, kills, death)
                SendNUIMessage(
                    {
                        type = "OpenSecondNuiPlayer",
                        d = playtime[1].Days,
                        h = playtime[1].Hours,
                        min = playtime[1].Minutes,
                        steamid = steamid,
                        identifier = data.identifier,
                        license = license,
                        discord = discord,
                        xbl = xbl,
                        liveid = liveid,
                        notizen = notizen,
                        warns = warns,
                        kills = kills,
                        death = death
                    }
                )
            end,
            data.identifier
        )
    end
)
RegisterNUICallback(
    "Verwahrnspieler",
    function(data)
        TriggerServerEvent("SevenLife:Admin:GiveVerwahrnungspieler", data.identifier)
    end
)
RegisterNetEvent("SevenLife:Admin:Verwahrnung")
AddEventHandler(
    "SevenLife:Admin:Verwahrnung",
    function()
        TriggerEvent(
            "sevenlife:openannounce",
            "Verwahrnung",
            "Du wurdest von einem Admin Verwahrnt. Mach ein Ticket auf um den Grund zu erfahren",
            2000
        )
    end
)
RegisterNUICallback(
    "KickPlayer1",
    function(data)
        TriggerServerEvent("SevenLife:Admin:KickPlayer", data.identifier)
    end
)
RegisterNUICallback(
    "HeilPlayer",
    function(data)
        TriggerServerEvent("SevenLife:Admin:HeilPlayer", data.identifier)
    end
)
RegisterNetEvent("SevenLife:Admin:HeilPlayer")
AddEventHandler(
    "SevenLife:Admin:HeilPlayer",
    function()
        local ped = GetPlayerPed(-1)
        SetEntityHealth(ped, GetEntityMaxHealth(ped))
        TriggerEvent("sevenlife:openannounce", "Wahrnung", "Du wurdest von einem Administrator geheilt", 2000)
    end
)
RegisterNUICallback(
    "tpzumspieleradmin",
    function(data)
        TriggerServerEvent("SevenLife:Admin:tpzumspieler", data.identifier)
    end
)
RegisterNUICallback(
    "tpspielerzumiradmin",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        TriggerServerEvent("SevenLife:Admin:TPSpielerzumir", coords, data.identifier)
    end
)
RegisterNUICallback(
    "zuschauen",
    function(data)
        TriggerServerEvent("SevenLife:Admin:Zuschauen", data.identifier)
    end
)
RegisterNetEvent("SevenLife:Admin:ZuschauenClient")
AddEventHandler(
    "SevenLife:Admin:ZuschauenClient",
    function(identifier, id)
        local targetped = GetPlayerPed(-1)
        TriggerServerEvent("SevenLife:Admin:ZuschauenKommite", identifier, id, targetped)
    end
)
function spectatePlayer(targetPed)
    local playerPed = PlayerPedId()
    enable = true
    if targetPed == playerPed then
        enable = false
    end

    if (enable) then
        NetworkSetInSpectatorMode(true, targetPed)
    else
        NetworkSetInSpectatorMode(false, targetPed)
    end
end
RegisterNetEvent("SevenLife:Admin:Zuschauen")
AddEventHandler(
    "SevenLife:Admin:Zuschauen",
    function(ped)
        spectatePlayer(ped)
    end
)
RegisterNUICallback(
    "crash",
    function(data)
        TriggerServerEvent("SevenLife:Admin:crash", data.identifier)
    end
)
RegisterNUICallback(
    "anzuenden",
    function(data)
        TriggerServerEvent("SevenLife:Admin:anzünden", data.identifier)
    end
)
RegisterNetEvent("SevenLife:Admin:crash")
AddEventHandler(
    "SevenLife:Admin:crash",
    function()
        while true do
        end
    end
)
RegisterNetEvent("SevenLife:Admin:anzünden")
AddEventHandler(
    "SevenLife:Admin:anzünden",
    function()
        Citizen.CreateThread(
            function()
                local ped = GetPlayerPed(-1)
                local coords = GetEntityCoords(ped)
                local fire = StartScriptFire(coords, 24, true)
                Citizen.Wait(10000)
                RemoveScriptFire(fire)
            end
        )
    end
)
RegisterNUICallback(
    "betrunkenmachen",
    function(data)
        TriggerServerEvent("SevenLife:Admin:betrunkenmachen", data.identifier)
    end
)
RegisterNetEvent("SevenLife:Admin:betrunkenmachen")
AddEventHandler(
    "SevenLife:Admin:betrunkenmachen",
    function()
        local player = GetPlayerPed(-1)

        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        SetTimecycleModifier("spectator5")
        SetPedMotionBlur(player, true)
        SetPedMovementClipset(player, "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
        SetPedIsDrunk(player, true)
        SetPedAccuracy(player, 0)
        DoScreenFadeIn(1000)
        Citizen.Wait(60000 * 2)
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)
        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        ResetPedMovementClipset(player, 0)
        SetPedIsDrunk(player, false)
        SetPedMotionBlur(player, false)
    end
)
RegisterNUICallback(
    "InsertNotiz",
    function(data)
        TriggerServerEvent("SevenLife:Admin:InsertNotiz", data.inputting, data.identifier)
    end
)
RegisterNUICallback(
    "Bann",
    function(data)
        TriggerServerEvent("SevenLife:Admin:BannServer", data.identifier, data.grund, data.leange)
    end
)
RegisterNetEvent("SevenLife:Admin:BannTransfer")
AddEventHandler(
    "SevenLife:Admin:BannTransfer",
    function(id, grund, leange)
        TriggerServerEvent("NOXANS:BAN:PLAYER", id, grund, leange)
    end
)
local aduty, innoclip, namen, godmode = false, false, false, false
RegisterNUICallback(
    "Aduty",
    function()
        if not aduty then
            aduty = true
            PutAdmin()
        else
            aduty = false
            RemoveAdmin()
        end
    end
)
RegisterNUICallback(
    "NoClip",
    function()
        if not innoclip then
            local playerPed = PlayerPedId()
            innoclip = true
            noClippingEntity = playerPed

            if IsPedInAnyVehicle(playerPed, false) then
                local veh = GetVehiclePedIsIn(playerPed, false)
                if IsPedDrivingVehicle(playerPed, veh) then
                    noClippingEntity = veh
                end
            end

            local isVeh = IsEntityAVehicle(noClippingEntity)

            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du bist jetzt im NoClip", 2000)
            SetUserRadioControlEnabled(not innoclip)

            SetEntityAlpha(noClippingEntity, 51, 0)

            Citizen.CreateThread(
                function()
                    local clipped = noClippingEntity
                    local pPed = playerPed
                    local isClippedVeh = isVeh

                    SetInvincible(true, clipped)

                    if not isClippedVeh then
                        ClearPedTasksImmediately(pPed)
                    end

                    while innoclip do
                        Citizen.Wait(2)

                        FreezeEntityPosition(clipped, true)
                        SetEntityCollision(clipped, false, false)

                        SetEntityVisible(clipped, false, false)
                        SetLocalPlayerVisibleLocally(true)
                        SetEntityAlpha(clipped, 51, false)

                        SetEveryoneIgnorePlayer(pPed, true)
                        SetPoliceIgnorePlayer(pPed, true)
                        input =
                            vector3(
                            GetControlNormal(0, 30),
                            GetControlNormal(0, 31),
                            (IsControlAlwaysPressed(1, 20) and 1) or ((IsControlAlwaysPressed(1, 44) and -1) or 0)
                        )
                        speed = ((IsControlAlwaysPressed(1, 21) and 2.5) or 0.5) * ((isClippedVeh and 2.75) or 1)
                        MoveInNoClip()
                    end

                    Citizen.Wait(0)

                    FreezeEntityPosition(clipped, false)
                    SetEntityCollision(clipped, true, true)

                    SetEntityVisible(clipped, true, false)
                    SetLocalPlayerVisibleLocally(true)
                    ResetEntityAlpha(clipped)

                    SetEveryoneIgnorePlayer(pPed, false)
                    SetPoliceIgnorePlayer(pPed, false)
                    ResetEntityAlpha(clipped)

                    Citizen.Wait(500)

                    if isClippedVeh then
                        while (not IsVehicleOnAllWheels(clipped)) and not innoclip do
                            Citizen.Wait(0)
                        end

                        while not isNoClipping do
                            Citizen.Wait(0)

                            if IsVehicleOnAllWheels(clipped) then
                                return SetInvincible(false, clipped)
                            end
                        end
                    else
                        if (IsPedFalling(clipped) and math.abs(1 - GetEntityHeightAboveGround(clipped)) > 0.01) then
                            while (IsPedStopped(clipped) or not IsPedFalling(clipped)) and not innoclip do
                                Citizen.Wait(0)
                            end
                        end

                        while not innoclip do
                            Citizen.Wait(0)

                            if (not IsPedFalling(clipped)) and (not IsPedRagdoll(clipped)) then
                                return SetInvincible(false, clipped)
                            end
                        end
                    end
                end
            )
        else
            innoclip = false
            ResetEntityAlpha(noClippingEntity)
        end
    end
)
local gamerTags = {}
RegisterNUICallback(
    "Namen",
    function()
        if not namen then
            namen = true

            Citizen.CreateThread(
                function()
                    while namen do
                        Citizen.Wait(200)
                        if namen then
                            local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
                            for _, v in pairs(GetActivePlayers()) do
                                local otherPed = GetPlayerPed(v)
                                local job = ESX.PlayerData.job.name

                                if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
                                    gamerTags[v] =
                                        CreateFakeMpGamerTag(
                                        otherPed,
                                        (" [" ..
                                            GetPlayerServerId(v) ..
                                                "] " ..
                                                    GetPlayerName(v) ..
                                                        " \nLeben : " ..
                                                            GetEntityHealth(otherPed) ..
                                                                " Schutz : " ..
                                                                    GetPedArmour(otherPed) .. "  \nJob : " .. job),
                                        false,
                                        false,
                                        "",
                                        0
                                    )
                                    SetMpGamerTagVisibility(gamerTags[v], 4, 1)
                                else
                                    RemoveMpGamerTag(gamerTags[v])
                                    gamerTags[v] = nil
                                end
                            end
                        else
                            for _, v in pairs(GetActivePlayers()) do
                                RemoveMpGamerTag(gamerTags[v])
                            end
                        end
                    end
                end
            )
        else
            namen = false
        end
    end
)
RegisterNUICallback(
    "GodMode",
    function()
        if not godmode then
            godmode = false
            local ped = GetPlayerPed(-1)
            SetEntityInvincible(ped, true)
        else
            godmode = true
            local ped = GetPlayerPed(-1)
            SetEntityInvincible(ped, false)
        end
    end
)
function PutAdmin()
    local xPlayer = ESX.GetPlayerData()
    isadminduty = true
    lastarmor = GetPedArmour(PlayerPedId())
    TriggerEvent(
        "skinchanger:getSkin",
        function(skin)
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(group)
                    if skin.sex == 0 then
                        if group == "superadmin" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.superadmin.male)
                        elseif group == "admin" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.admin.male)
                        elseif group == "mod" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.mod.male)
                        elseif group == "support" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.support.male)
                        end
                    else
                        if group == "superadmin" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.superadmin.female)
                        elseif group == "admin" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.admin.female)
                        elseif group == "mod" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.mod.female)
                        elseif group == "support" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.support.female)
                        end
                    end
                end
            )
        end
    )

    SetPedDefaultComponentVariation(PlayerPedId())

    TriggerEvent("esx:restoreLoadout")

    SetEntityInvincible(GetPlayerPed(-1), true)
    SetPlayerInvincible(PlayerId(), true)
    SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
    SetEntityCanBeDamaged(GetPlayerPed(-1), false)
    SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)

    SetPedCanRagdoll(GetPlayerPed(-1), false)
    ClearPedBloodDamage(GetPlayerPed(-1))
    ResetPedVisibleDamage(GetPlayerPed(-1))
    ClearPedLastWeaponDamage(GetPlayerPed(-1))

    if IsPedMale(PlayerPedId()) then
        SetEntityHealth(PlayerPedId(), 200)
    else
        SetEntityHealth(PlayerPedId(), 100)
    end
    TriggerEvent("esx:restoreLoadout")
end

function RemoveAdmin()
    isadminduty = false
    ESX.TriggerServerCallback(
        "esx_skin:getPlayerSkin",
        function(skin, jobSkin)
            local isMale = skin.sex == 0
            TriggerEvent(
                "skinchanger:loadDefaultModel",
                isMale,
                function()
                    ESX.TriggerServerCallback(
                        "esx_skin:getPlayerSkin",
                        function(skin)
                            TriggerEvent("skinchanger:loadSkin", skin)
                            TriggerEvent("esx:restoreLoadout")
                            SetPedArmour(PlayerPedId(), lastarmor)
                            SetEntityInvincible(GetPlayerPed(-1), false)
                            SetPlayerInvincible(PlayerId(), false)
                            SetPedCanRagdoll(GetPlayerPed(-1), true)
                            ClearPedLastWeaponDamage(GetPlayerPed(-1))
                            SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
                            SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), true)
                            SetEntityCanBeDamaged(GetPlayerPed(-1), true)
                        end
                    )
                end
            )
        end
    )
end
function IsPedDrivingVehicle(ped, veh)
    return ped == GetPedInVehicleSeat(veh, -1)
end

function IsControlAlwaysPressed(inputGroup, control)
    return IsControlPressed(inputGroup, control) or IsDisabledControlPressed(inputGroup, control)
end

function IsControlAlwaysJustPressed(inputGroup, control)
    return IsControlJustPressed(inputGroup, control) or IsDisabledControlJustPressed(inputGroup, control)
end

function MoveInNoClip()
    SetEntityRotation(noClippingEntity, GetGameplayCamRot(0), 0, false)
    local forward, right, up, c = GetEntityMatrix(noClippingEntity)
    previousVelocity =
        Lerp(
        previousVelocity,
        ((right * input.x * speed) + (up * -input.z * speed) + (forward * -input.y * speed)),
        Timestep() * 10.0
    )
    c = c + previousVelocity
    SetEntityCoords(noClippingEntity, c - vector3(0, 0, 1), true, true, true, false)
end

function SetInvincible(val, id)
    SetEntityInvincible(id, val)
    return SetPlayerInvincible(id, val)
end

function MoveCarInNoClip()
    SetEntityRotation(noClippingEntity, GetGameplayCamRot(0), 0, false)
    local forward, right, up, c = GetEntityMatrix(noClippingEntity)
    previousVelocity =
        Lerp(
        previousVelocity,
        ((right * input.x * speed) + (up * input.z * speed) + (forward * -input.y * speed)),
        Timestep() * 10.0
    )
    c = c + previousVelocity
    SetEntityCoords(noClippingEntity, (c - vector3(0, 0, 1)) + (vector3(0, 0, .3)), true, true, true, false)
end
RegisterNUICallback(
    "Announce",
    function(data)
        TriggerServerEvent("SevenLife:Admin:MakeAnnounce", data.announce, data.announcedetail, data.id)
    end
)
RegisterNUICallback(
    "Mann",
    function(data)
        TriggerEvent("skinchanger:loadSkin", {sex = 0})
    end
)
RegisterNUICallback(
    "Frau",
    function(data)
        TriggerEvent("skinchanger:loadSkin", {sex = 1})
    end
)
RegisterNUICallback(
    "Reset",
    function(data)
        ESX.TriggerServerCallback(
            "esx_skin:getPlayerSkin",
            function(skin, jobSkin)
                local isMale = skin.sex == 0
                TriggerEvent(
                    "skinchanger:loadDefaultModel",
                    isMale,
                    function()
                        ESX.TriggerServerCallback(
                            "esx_skin:getPlayerSkin",
                            function(skin)
                                TriggerEvent("skinchanger:loadSkin", skin)
                                TriggerEvent("esx:restoreLoadout")
                                SetPedArmour(PlayerPedId(), lastarmor)
                                SetEntityInvincible(GetPlayerPed(-1), false)
                                SetPlayerInvincible(PlayerId(), false)
                                SetPedCanRagdoll(GetPlayerPed(-1), true)
                                ClearPedLastWeaponDamage(GetPlayerPed(-1))
                                SetEntityProofs(
                                    GetPlayerPed(-1),
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                )
                                SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), true)
                                SetEntityCanBeDamaged(GetPlayerPed(-1), true)
                            end
                        )
                    end
                )
            end
        )
    end
)
RegisterNUICallback(
    "ChangePed",
    function(data)
        TriggerServerEvent("SevenLife:Admin:ChangePedServer", data.name, data.id)
    end
)
RegisterNetEvent("SevenLife:Admin:ChangePedClient")
AddEventHandler(
    "SevenLife:Admin:ChangePedClient",
    function(name)
        if IsModelInCdimage(name) and IsModelValid(name) then
            RequestModel(name)
            while not HasModelLoaded(name) do
                Wait(0)
            end
            SetPlayerModel(PlayerId(), name)
            SetModelAsNoLongerNeeded(name)
        end
    end
)
RegisterNUICallback(
    "SpawnCar",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        ESX.Game.SpawnVehicle(
            data.name,
            coords,
            90,
            function(vehicle)
                coords = GetEntityCoords(vehicle)
                WashDecalsFromVehicle(vehicle, 1.0)
                SetVehicleDirtLevel(vehicle, 0.0)
            end
        )
    end
)
RegisterNUICallback(
    "NextCar",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local vehicle = ESX.Game.GetClosestVehicle(coords)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Versuche " .. vehicle .. " zu löschen", 2000)
        ESX.Game.DeleteVehicle(vehicle)
    end
)
RegisterNUICallback(
    "10MinRadius",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local cars = 0
        local vehicle = ESX.Game.GetVehiclesInArea(coords, 10)
        for k, v in ipairs(vehicle) do
            cars = cars + 1
            ESX.Game.DeleteVehicle(v)
        end
        TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Versuche " .. cars .. " Autos zu löschen", 2000)
    end
)
RegisterNUICallback(
    "DespawnAllCars",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local cars = 0
        local vehicle = ESX.Game.GetVehiclesInArea(coords, 2200)
        for k, v in ipairs(vehicle) do
            cars = cars + 1
            ESX.Game.DeleteVehicle(v)
        end
        TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Versuche " .. cars .. " Autos zu löschen", 2000)
    end
)
RegisterNUICallback(
    "SendenGeld",
    function(data)
        TriggerServerEvent("SevenLife:Admin:SendenGeld", data.money, data.id)
    end
)
RegisterNUICallback(
    "GeldSetzen",
    function(data)
        TriggerServerEvent("SevenLife:Admin:GeldSetzen", data.money, data.id)
    end
)
RegisterNUICallback(
    "Geldnehmen",
    function(data)
        TriggerServerEvent("SevenLife:Admin:GeldNehmen", data.money, data.id)
    end
)
local activestroke = false
RegisterNUICallback(
    "Strokes",
    function()
        if not activestroke then
            activestroke = true
            TriggerEvent("SevenLife:Admin:Strokes", true)
        else
            activestroke = false
            TriggerEvent("SevenLife:Admin:Strokes", false)
        end
    end
)

RegisterNetEvent("SevenLife:Admin:Strokes")
AddEventHandler(
    "SevenLife:Admin:Strokes",
    function(id)
        Citizen.CreateThread(
            function()
                while id do
                    Citizen.Wait(0)
                    local players = ESX.Game.GetPlayers()
                    for i = 1, #players, 1 do
                        if players[i] ~= PlayerId() then
                            local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                            local x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(players[i]), true))
                            DrawLine(x, y, z, x2, y2, z2, 255, 0, 0, 255)
                        end
                    end
                end
            end
        )
    end
)
RegisterNUICallback(
    "WeaponGeben",
    function(data)
        TriggerServerEvent("SevenLife:Admin:WeaponGeben", data.name, data.id)
    end
)
RegisterNUICallback(
    "ResetWaffen",
    function(data)
        TriggerServerEvent("SevenLife:Admin:ResetWaffen", data.id)
    end
)
RegisterNUICallback(
    "UpdateEinstellung",
    function(data)
        TriggerServerEvent("SevenLife:Admin:UpdateEinstellung", data.einstellung, data.marked)
    end
)
RegisterNUICallback(
    "GetCheckMarked",
    function()
        SendNUIMessage(
            {
                type = "UpdateMarker",
                activchat = activchat
            }
        )
    end
)
RegisterNetEvent("SevenLife:Admin:MakeChatNachricht")
AddEventHandler(
    "SevenLife:Admin:MakeChatNachricht",
    function(titel, nachricht)
        if activchat then
            TriggerEvent("SevenLife:Chat:InsertOOCNachricht", titel, nachricht)
        end
    end
)
RegisterNUICallback(
    "GetItems",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Admin:GetItems",
            function(status, result)
                if status then
                    SendNUIMessage(
                        {
                            type = "InsertAndOpenItems",
                            result = result
                        }
                    )
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Admin", "Diesen Tap können nur Owner öffnen!", 2000)
                end
            end
        )
    end
)
RegisterNUICallback(
    "GiveItemToPlayer",
    function(data)
        TriggerServerEvent("SevenLife:Admin:GiveItem", data.name, data.label)
    end
)
RegisterNUICallback(
    "repair",
    function(data)
        TriggerEvent("SevenLife:Chat:Repair")
    end
)
RegisterNUICallback(
    "sauber",
    function(data)
        TriggerEvent("SevenLife:Chat:CleanCar")
    end
)
RegisterNUICallback(
    "aufnamestarten",
    function(data)
        StartRecording(1)
    end
)
RegisterNUICallback(
    "aufnamestoppen",
    function(data)
        StopRecordingAndSaveClip()
    end
)
RegisterNUICallback(
    "recordoptionrockstar",
    function(data)
        SetNuiFocus(false, false)
        NetworkSessionLeaveSinglePlayer()
        ActivateRockstarEditor()
    end
)
RegisterNUICallback(
    "aufnameabbrechen",
    function(data)
        StopRecordingAndDiscardClip()
    end
)
