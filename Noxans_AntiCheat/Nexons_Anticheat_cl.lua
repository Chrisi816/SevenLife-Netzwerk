text =
    [[
    _  __                                    ___         __    _   _____   __              __ 
   / |/ / ___  __ __ ___ _  ___   ___       / _ |  ___  / /_  (_) / ___/  / /  ___  ___ _ / /_
  /    / / _ \ \ \ // _ `/ / _ \ (_-<      / __ | / _ \/ __/ / / / /__   / _ \/ -_)/ _ `// __/
 /_/|_/  \___//_\_\ \_,_/ /_//_//___/ ____/_/ |_|/_//_/\__/ /_/  \___/  /_//_/\__/ \_,_/ \__/ 
                                  /___/                                                    
      
                                 VERSION: 1.0.1
                                Powered by Noxans 
    
]]
local activate = false
local tracking = 0
local DAMAGE = {}
-- Blacklistet Weapons
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
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        PlayerData = ESX.GetPlayerData()
    end
)
local firstSpawnAC = true

AddEventHandler(
    "playerSpawned",
    function()
        if firstSpawnAC then
            firstSpawnAC = false
        end
        nbcmds = #GetRegisteredCommands()
        nbres = GetNumResources()
    end
)
Citizen.CreateThread(
    function()
        local ressource = GetNumResources()
        local nBlips = 0
        while true do
            Citizen.Wait(2000)
            if Config.AntiWeapons.inhand then
                for _, Weapon in ipairs(Config.Blacklistetweaponslist) do
                    if HasPedGotWeapon(GetPlayerPed(-1), GetHashKey(Weapon), false) == 1 then
                        if Config.banplayer then
                        else
                            TriggerServerEvent("nexons:kickplayer", Config.kickmessage.Blacklistetweapon.inhand, Weapon)
                            RemoveAllPedWeapons(GetPlayerPed(-1), false)
                        end
                    end
                end
            end
            if ForceSocialClubUpdate == nil then
                if Config.banplayer then
                else
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Licensen Clear")
                end
            end
            if ShutdownAndLaunchSinglePlayerGame == nil then
                if Config.banplayer then
                else
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Licensen Clear")
                end
            end
            if ActivateRockstarEditor == nil then
                if Config.banplayer then
                else
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Licensen Clear")
                end
            end
            if Config.AntiBlips then
                nBlips = GetNumberOfActiveBlips()

                if nBlips == #GetActivePlayers() then
                    TriggerServerEvent("Noxans:Message:KickUniversal", "AntiBlip")
                end
            end
            if Config.ResourceCount then
                if ressource ~= GetNumResources() then
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Zu viele Resourcen")
                end
            end
            if not firstSpawnAC then
                if Config.AntiInjection then
                    for k, v in ipairs(GetRegisteredCommands()) do
                        for k2, v2 in ipairs(Config.BlacklistedCommands) do
                            if v.name == v2 then
                                if Config.banplayer then
                                else
                                    TriggerServerEvent("Noxans:Message:KickUniversal", "BlackListet Command")
                                end
                            end
                        end
                    end

                    getcomands = #GetRegisteredCommands()

                    if nbcmds ~= nil then
                        if tonumber(getcomands) ~= tonumber(nbcmds) then
                            if Config.banplayer then
                            else
                                TriggerServerEvent("Noxans:Message:KickUniversal", "Blacklistet Command2")
                            end
                        end
                    end
                end
            end

            for fe, fg in ipairs(Config.ModelChange) do
                if IsPedModel(PlayerPedId(), fg) then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Model Change")
                    end
                end
            end
            if
                IsPedSittingInAnyVehicle(PlayerPedId()) and GetVehiclePedIsUsing(PlayerPedId()) == oldVehicle and
                    GetEntityModel((GetVehiclePedIsUsing(PlayerPedId()))) ~= oldVehicleModel and
                    oldVehicleModel ~= nil and
                    oldVehicleModel ~= 0
             then
                DeleteVehicle((GetVehiclePedIsUsing(PlayerPedId())))

                if Config.banplayer then
                else
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Model Change")
                end

                return
            end

            oldVehicleModel, oldVehicle =
                GetEntityModel((GetVehiclePedIsUsing(PlayerPedId()))),
                GetVehiclePedIsUsing(PlayerPedId())

            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
            SetPedConfigFlag(ped, 43, true)
            if weapon ~= 0 and weapon ~= "WEAPON_UNARMED" then
                local lockOn = GetLockonDistanceOfCurrentPedWeapon(ped)
                if lockOn > 500.0 then
                    local player = PlayerId()
                    SetPlayerLockon(player, false)
                    SetPlayerLockonRangeOverride(player, -1.0)
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        TriggerServerEvent("Noxans:CheckIfPlayerHaveToHighPing")
    end
)

if Config.AntiBombDamage then
    SetEntityProofs(GetPlayerPed(-1), false, true, true, false, false, false, false, false)
end

--Blacklistet Car
if Config.anticar then
    Citizen.CreateThread(
        function()
            while true do
                Citizen.Wait(1000)
                local ped = GetPlayerPed(-1)
                if IsPedInAnyVehicle(ped, true) then
                    i = GetVehiclePedIsIn(ped, false)
                end
                if ped and i then
                    if GetPedInVehicleSeat(i, -1) == ped then
                        checkingifcarisblacklistet(GetVehiclePedIsIn(ped, false))
                    end
                end
            end
        end
    )
end

function checkingifcarisblacklistet(car)
    if car then
        Model = GetEntityModel(car)
        Name = GetDisplayNameFromVehicleModel(Model)
    end
    if isitblacklistet(Model) then
        if Config.banplayer then
        else
            TriggerServerEvent("noxans:hallofshamecar", Config.kickmessage.blacklistetcar, Name)
            TriggerServerEvent("nexons:kickplayercar", Config.kickmessage.blacklistetcar, Name)
        end
        DeleteVehicle(car)
    end
end

function isitblacklistet(model)
    for _, blacklistetcarlist in pairs(Config.blacklistetcarlist) do
        if model == GetHashKey(blacklistetcarlist) then
            return true
        end
    end
    return false
end

--Super Jump
if Config.superjump then
    Citizen.CreateThread(
        function()
            while true do
                Citizen.Wait(1000)
                ped = GetPlayerPed(-1)
                if IsPedJumping(ped) then
                    local coords = GetEntityCoords(ped)
                    while IsPedJumping(ped) do
                        Wait(0)
                    end
                    local seccoord = GetEntityCoords(ped)
                    local jump = GetDistanceBetweenCoords(coords, seccoord, false)
                    if jump > 6.5 then
                        if Config.banplayer then
                        else
                            TriggerServerEvent("nexons:antijump", Config.kickmessage.antijump, jump)
                        end
                    end
                end
            end
        end
    )
end

-- Check if Player run

if Config.checkingplayerrun then
    Citizen.CreateThread(
        function()
            while true do
                Citizen.Wait(1000)
                speed = 8.5
                speedcar = 110
                ped = GetPlayerPed(-1)
                getspeed = GetEntitySpeed(ped)
                if (not IsPedInAnyVehicle(ped, false)) then
                    if IsPedRunning(ped) then
                        if getspeed > speed then
                            if not IsPedFalling(ped) then
                                if Config.banplayer then
                                else
                                    TriggerServerEvent("nexons:antifastrun", Config.kickmessage.fastrun, getspeed)
                                end
                            end
                        end
                    end
                end

                if IsPedInAnyVehicle(ped, false) then
                    if getspeed > speedcar then
                        if Config.banplayer then
                        else
                            local getspeed = math.floor(getspeed * 3.6)
                            TriggerServerEvent("noxans:hallofshame", Config.kickmessage.fastcar, getspeed)
                            TriggerServerEvent("nexons:antifastrun", Config.kickmessage.fastcar, getspeed)
                        end
                    end
                end
            end
        end
    )
end

if Config.forbiddenkeys then
    Citizen.CreateThread(
        function()
            while true do
                Citizen.Wait(4)
                for k, v in pairs(Config.Blacklistetkeys) do
                    if IsControlJustPressed(0, v) then
                        if Config.banplayer then
                        else
                            TriggerServerEvent("Noxans:Message:KickUniversal", "Blacklistet Key benutzt")
                            TriggerServerEvent("Noxans:AntiCheat:MakeScreenShot")
                        end
                    end
                end
                if (IsDisabledControlPressed(0, 47) and IsDisabledControlPressed(0, 21)) then
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Blacklistet Key benutzt")
                elseif (IsDisabledControlPressed(0, 117)) then
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Blacklistet Key benutzt")
                elseif (IsDisabledControlPressed(0, 121)) then
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Blacklistet Key benutzt")
                elseif (IsDisabledControlPressed(0, 37) and IsDisabledControlPressed(0, 44)) then
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Blacklistet Key benutzt")
                elseif (IsDisabledControlPressed(0, 214)) then
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Blacklistet Key benutzt")
                end
            end
        end
    )
end

-- Anti VDM

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            SetWeaponDamageModifier(-1553120962, 0.0)
        end
    end
)

-- Checking for Godmode

if Config.antigodmode then
    Citizen.CreateThread(
        function()
            while true do
                Citizen.Wait(20000)
                local noxansped = GetPlayerPed(-1)
                local noxansid = PlayerId()
                local noxanshealth = GetEntityHealth(noxansped)
                SetEntityHealth(noxansped, noxanshealth - 3)
                local noxanswait = math.random(10, 300)
                Citizen.Wait(noxanswait)
                if not IsPlayerDead(noxansid) then
                    if
                        PlayerPedId() == noxansped and GetEntityHealth(noxansped) == noxanshealth and
                            GetEntityHealth(noxansped) ~= 0
                     then
                        if Config.banplayer then
                        else
                            TriggerServerEvent("noxans:kickplayergodmode", Config.kickmessage.godmodes)
                        end
                    else
                        if GetEntityHealth(noxansped) == noxanshealth - 3 then
                            SetEntityHealth(noxansped, GetEntityHealth(noxansped) + 3)
                        end
                    end
                end
                if GetPlayerInvincible(PlayerId()) then
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Why? Godmode Aktiv")
                    SetPlayerInvincible(PlayerId(), false)
                end
                if GetEntityHealth(noxanshealth) > 200 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("noxans:kickplayergodmode", Config.kickmessage.godmodes)
                    end
                end
                if GetPedArmour(noxansped) < 200 then
                    Wait(100)
                    if GetPedArmour(noxansped) == 200 then
                        if Config.banplayer then
                        else
                            TriggerServerEvent("noxans:kickplayergodmode", Config.kickmessage.godmodes)
                        end
                    end
                end
            end
        end
    )
end

-- Anti Teleport and Super Jump

RegisterNetEvent("Noxans:AntiCheat:StartAntiCheat")
AddEventHandler(
    "Noxans:AntiCheat:StartAntiCheat",
    function()
        Citizen.CreateThread(
            function()
                while true do
                    Citizen.Wait(10)
                    local ped = PlayerPedId()
                    local health = GetEntityHealth(ped)
                    while IsPlayerSwitchInProgress() or IsPedFalling(ped) do
                        Citizen.Wait(3000)
                    end
                    if DoesEntityExist(ped) then
                        if not IsPedInAnyVehicle(ped, false) then
                            local pos = GetEntityCoords(ped)
                            Citizen.Wait(3000)
                            local newpos = GetEntityCoords(ped)
                            local distance = GetDistanceBetweenCoords(pos, newpos, false)
                            if
                                distance >= 150 and not IsEntityDead(ped) and not IsPedInParachuteFreeFall(ped) and
                                    not IsPedJumpingOutOfVehicle(ped)
                             then
                                if Config.banplayer then
                                else
                                    TriggerServerEvent(
                                        "Noxans:Message:KickUniversal",
                                        "Du hast versucht dich auf dem Server zu teleportieren"
                                    )
                                end
                            end
                        end

                        if health > 200 then
                            if Config.banplayer then
                            else
                                TriggerServerEvent("Noxans:Message:KickUniversal", "Du hast zu viel Leben")
                            end
                        end
                    end
                    if IsAimCamActive() then
                        local _isaiming, _entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                        if _isaiming and _entity then
                            if
                                IsEntityAPed(_entity) and not IsEntityDead(_entity) and not IsPedStill(_entity) and
                                    not IsPedStopped(_entity) and
                                    not IsPedInAnyVehicle(_entity, false)
                             then
                                local _entitycoords = GetEntityCoords(_entity)
                                local retval, screenx, screeny =
                                    GetScreenCoordFromWorldCoord(_entitycoords.x, _entitycoords.y, _entitycoords.z)
                                if screenx == lastcoordsx or screeny == lastcoordsy then
                                    if Config.banplayer then
                                    else
                                        TriggerServerEvent("Noxans:Message:KickUniversal", "Aim Bot ? Ya Kalb")
                                    end
                                end
                                lastcoordsx = screenx
                                lastcoordsy = screeny
                            end
                        end
                    end
                end
            end
        )
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5000)
            if not IsPlayerSwitchInProgress() then
                for theveh in EnumerateVehicles() do
                    if GetEntityHealth(theveh) == 0 then
                        SetEntityAsMissionEntity(theveh, false, false)
                        DeleteEntity(theveh)
                    end
                end
                local I = GetSelectedPedWeapon(O)
                if (I ~= GetHashKey("weapon_unarmed")) and (I ~= 966099553) and (I ~= 0) then
                    TriggerServerEvent("Noxans:Veryfi:Weapon", I)
                end

                local AllPlayers = GetActivePlayers()
                local ped = PlayerPedId()
                if GetPlayerWeaponDamageModifier(PlayerId()) > 1 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Damage Modifier")
                    end
                elseif
                    1 < GetPlayerWeaponDefenseModifier(PlayerId()) and GetPlayerWeaponDefenseModifier(PlayerId()) ~= 0
                 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Waffen Defence")
                    end
                elseif
                    1 < GetPlayerWeaponDefenseModifier_2(PlayerId()) and GetPlayerWeaponDefenseModifier(PlayerId()) ~= 0
                 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Waffen Defence")
                    end
                elseif
                    1 < GetPlayerVehicleDamageModifier(PlayerId()) and GetPlayerVehicleDamageModifier(PlayerId()) ~= 0
                 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Vehicle Damage")
                    end
                elseif
                    1 < GetPlayerVehicleDefenseModifier(PlayerId()) and GetPlayerVehicleDefenseModifier(PlayerId()) ~= 0
                 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Vehicle Defense")
                    end
                elseif
                    1 < GetPlayerMeleeWeaponDefenseModifier(PlayerId()) and
                        GetPlayerVehicleDefenseModifier(PlayerId()) ~= 0
                 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Schlag Modifier")
                    end
                end
                local Weapon = GetSelectedPedWeapon(ped)
                if Weapon ~= nil then
                    WeaponDamages = Config.WeaponDamagesTable
                    if WeaponDamages[Weapon] and math.floor(GetWeaponDamage((Weapon))) > WeaponDamages[Weapon] then
                        if Config.banplayer then
                        else
                            TriggerServerEvent("Noxans:Message:KickUniversal", "Waffen Damage Modifier")
                        end
                    end
                end

                if activate then
                    newcoords = GetEntityCoords(ped)
                    if oldcoords ~= nil then
                        if
                            GetDistanceBetweenCoords(newcoords, oldcoords, true) > 500 and
                                IsPedStill((ped)) == IsPedStill((ped)) and
                                GetEntitySpeed((ped)) == GetEntitySpeed((ped)) and
                                ped == ped
                         then
                            if Config.banplayer then
                            else
                                TriggerServerEvent("Noxans:Message:KickUniversal", "No Clip")
                            end
                        end
                    end

                    oldcoords = newcoords
                end

                if IsPedInAnyVehicle(ped, false) then
                    veh = GetVehiclePedIsIn(ped, false)
                    plate = GetVehicleNumberPlateText(veh)
                    vehhash = GetHashKey(veh)
                end

                if NetworkIsInSpectatorMode() then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Du hast versucht jemanden zu zugucken")
                    end
                end

                for i = 1, #AllPlayers do
                    local IdPed = GetPlayerPed(AllPlayers[i])
                    if IdPed ~= ped then
                        if DoesBlipExist(IdPed) then
                            tracking = tracking + 1
                        end
                    end
                end
                if tracking >= 30 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Du hast Spieler Blips eingeschaltet")
                    end
                end
                local anzahl = 0
                for i = 1, #AllPlayers do
                    if i ~= PlayerId() then
                        if DoesBlipExist(GetBlipFromEntity(GetPlayerPed(i))) then
                            anzahl = anzahl + 1
                        end
                    end
                    if anzahl > 0 then
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Du hast Spieler Blips eingeschaltet")
                    end
                end
                if veh ~= nil then
                    if plate ~= nil then
                        local RPED = PlayerPedId()
                        if IsPedInAnyVehicle(RPED, false) then
                            local firstveh = GetVehiclePedIsIn(ped, false)
                            local later = GetVehicleNumberPlateText(firstveh)
                            local HashAuto = GetHashKey(firstveh)
                            if later ~= plate and HashAuto == vehhash then
                                if Config.banplayer then
                                else
                                    TriggerServerEvent("Noxans:Message:KickUniversal", "Du hast zu viel Leben")
                                end
                            else
                                Citizen.Wait(1000)
                            end
                        else
                            Citizen.Wait(1000)
                        end
                    else
                        Citizen.Wait(1000)
                    end
                else
                    Wait(0)
                end
                if
                    GetEntitySpeed(PlayerPedId()) > 7 and not IsPedInAnyVehicle(PlayerPedId(), true) and
                        not IsPedFalling(PlayerPedId()) and
                        not IsPedInParachuteFreeFall(PlayerPedId()) and
                        not IsPedJumpingOutOfVehicle(PlayerPedId()) and
                        not IsPedRagdoll(PlayerPedId())
                 then
                    local staminalevel = GetPlayerSprintStaminaRemaining(PlayerId())
                    if tonumber(staminalevel) == tonumber(0.0) then
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Zu viel Ausdauer")
                    end
                end
                if
                    not CanPedRagdoll(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), true) and
                        not IsEntityDead(PlayerPedId()) and
                        not IsPedJumpingOutOfVehicle(PlayerPedId()) and
                        not IsPedJacking(PlayerPedId()) and
                        IsPedRagdoll(PlayerPedId())
                 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent(
                            "Noxans:Message:KickUniversal",
                            "Du hast versucht Ragdoll mit einem Cheat Menu ausgeführt"
                        )
                    end
                end

                if GetUsingnightvision(true) and not IsPedInAnyHeli(PlayerPedId()) then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Du hattest Night Vision an")
                    end
                end

                if GetUsingseethrough(true) and not IsPedInAnyHeli(PlayerPedId()) then
                    if Config.banplayer then
                    else
                        TriggerServerEvent(
                            "Noxans:Message:KickUniversal",
                            "Du hast versucht das Thermal Visier zu starten"
                        )
                    end
                end
                Citizen.Wait(2000)

                local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()) - GetFinalRenderedCamCoord())
                if (x > 50) or (y > 50) or (z > 50) or (x < -50) or (y < -50) or (z < -50) then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Du hattest eine Free Cam aktiv")
                    end
                end
                if IsPlayerCamControlDisabled() ~= false then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Du hatst eine Menyoo gestartet")
                    end
                end
                local aimassiststatus = GetLocalPlayerAimState()
                if aimassiststatus ~= 3 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Du hattest einen Aim Assist an")
                    end
                end
                local weapon = GetSelectedPedWeapon(PlayerPedId())
                local damages = math.floor(GetWeaponDamage(weapon))
                local table = DAMAGE[weapon]
                if table and damages > table.DAMAGE then
                    if Config.banplayer then
                    else
                        TriggerServerEvent(
                            "Noxans:Message:KickUniversal",
                            "Du hattest einen Aim Assist an" ..
                                table.name ..
                                    " Damage zu" .. damages .. " (Normale Waffen Damage ist " .. table.DAMAGE .. ")"
                        )
                    end
                end

                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    local VEH = GetVehiclePedIsIn(PlayerPedId(), false)
                    if DoesEntityExist(VEH) then
                        local c1r, c1g, c1b = GetVehicleCustomPrimaryColour(VEH)
                        Citizen.Wait(1000)
                        local c2r, c2g, c2b = GetVehicleCustomPrimaryColour(VEH)
                        Citizen.Wait(2000)
                        local c3r, c3g, c3b = GetVehicleCustomPrimaryColour(VEH)
                        if c1r ~= nil then
                            if c1r ~= c2r and c2r ~= c3r and c1g ~= c2g and c3g ~= c2g and c1b ~= c2b and c3b ~= c2b then
                                if Config.banplayer then
                                else
                                    TriggerServerEvent("Noxans:Message:KickUniversal", "Rainbow?")
                                end
                            end
                        end
                    end
                else
                    Citizen.Wait(0)
                end

                local entityalpha = GetEntityAlpha(PlayerPedId())
                if
                    not IsEntityVisible(PlayerPedId()) or not IsEntityVisibleToScript(PlayerPedId()) or
                        entityalpha <= 150
                 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Wieso bist du unsichtbar")
                    end
                end

                local weapon = GetSelectedPedWeapon(PlayerPedId())
                local weapon_damage = GetWeaponDamageType(weapon)
                N_0x4757f00bc6323cfe(GetHashKey("WEAPON_EXPLOSION"), 0.0)
                if weapon_damage == 4 or weapon_damage == 5 or weapon_damage == 6 or weapon_damage == 13 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Versucht Explosives zu benutzen")
                    end
                end

                local Tiny = GetPedConfigFlag(ped, 223, true)
                if Tiny then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Wieso bist du so klein")
                    end
                end

                local model = GetEntityModel(ped)
                local min, max = GetModelDimensions(model)

                if min.y < -0.29 or max.z > 0.98 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Silent Aim Detected")
                    end
                end
            end
        end
    end
)

AddEventHandler(
    "gameEventTriggered",
    function(name, args)
        local PlayerID = PlayerId()
        local owner = GetPlayerServerId(NetworkGetEntityOwner(args[2]))
        local owner1 = NetworkGetEntityOwner(args[1])
        while IsPlayerSwitchInProgress() do
            Citizen.Wait(5000)
        end
        if owner == GetPlayerServerId(PlayerID) or args[2] == -1 then
            if IsEntityAPed(args[1]) then
                if not IsEntityOnScreen(args[1]) then
                    local _entitycoords = GetEntityCoords(args[1])
                    local _distance = GetDistanceBetweenCoords(_entitycoords, GetEntityCoords(PlayerPedId()))
                    if Config.banplayer then
                    else
                        TriggerServerEvent(
                            "Noxans:Message:KickUniversal",
                            "Spieler abgeschossen ohne Sicht Kontakt" .. _distance
                        )
                    end
                end
                if isarmed and lastentityplayeraimedat ~= args[1] and IsPedAPlayer(args[1]) and PlayerID ~= owner1 then
                    if Config.banplayer then
                    else
                        TriggerServerEvent("Noxans:Message:KickUniversal", "Aim Bot im Server ejected")
                    end
                    Citizen.Wait(3000)
                end
            end
        end

        if name == "CEventNetworkEntityDamage" then
            if
                args[1] == PlayerPedId() and args[2] == -1 and args[3] == 0 and args[4] == 0 and args[5] == 0 and
                    args[6] == 1 and
                    args[7] == GetHashKey("WEAPON_FALL") and
                    args[8] == 0 and
                    args[9] == 0 and
                    args[10] == 0 and
                    args[11] == 0 and
                    args[12] == 0 and
                    args[13] == 0
             then
                if Config.banplayer then
                else
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Anti Selbstmord")
                end
            end
        end

        if name == "CEventNetworkPlayerCollectedPickup" then
            if Config.banplayer then
            else
                TriggerServerEvent("Noxans:Message:KickUniversal", "Resource gestoppt" .. json.encode(args))
            end
        end
    end
)

RegisterNUICallback(
    GetCurrentResourceName(),
    function()
        if Config.banplayer then
        else
            TriggerServerEvent("Noxans:Message:KickUniversal", "Dev tools geöffnet")
        end
    end
)

if Config.AntiResourceStart then
    AddEventHandler(
        "onClientResourceStart",
        function(resourceName)
            if not firstSpawnAC then
                TriggerServerEvent("Noxans:Message:KickUniversal", "Resource gestartet")
            end
            print(text)
        end
    )
end

if Config.AntiResourceNeuStart then
    AddEventHandler(
        "onClientResourceStart",
        function(resourceName)
            local Length = string.len(resourceName)
            local Subbing = string.sub(resourceName, 1, 1)

            if Length >= 18 and Subbing == "_" then
                TriggerServerEvent("Noxans:Message:KickUniversal", "Resource neugestartet")
            end
        end
    )
end

if Config.AntiResourceStop then
    AddEventHandler(
        "onClientResourceStop",
        function(resourceName)
            if not firstSpawnAC then
                TriggerServerEvent("Noxans:Message:KickUniversal", "Resource gestoppt")
            end
            if resourceName == "Noxans_AntiCheat" then
                if Config.banplayer then
                else
                    TriggerServerEvent("Noxans:Message:KickUniversal", "Resource gestoppt")
                end
            end

            TriggerServerEvent("noxans:stopresource")
        end
    )
end

if Config.AntiTriggerEvents then
    for k, event in pairs(Config.BlackListedEvents) do
        RegisterNetEvent(event)
        AddEventHandler(
            event,
            function()
                CancelEvent()
                TriggerServerEvent("Noxans:Message:KickUniversal", "Why? Blacklistet Event getriggert")
            end
        )
    end
end
local objst = 0
EnumerateVehicles = function()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(
        function()
            local iter, id = initFunc()
            if not id or id == 0 then
                disposeFunc(iter)
                return
            end

            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)

            local next = true
            repeat
                coroutine.yield(id)
                next, id = moveFunc(iter)
            until not next

            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end
    )
end

local oldbank = 0
local newbank
local oldmoney = 0
local newmoney
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(60000)
            ESX.TriggerServerCallback(
                "SevenLife:Noxans:Bank",
                function(money, bank)
                    if money ~= nil then
                        oldmoney = money
                    end
                    if bank ~= nil then
                        oldbank = bank
                    end

                    if money > (oldmoney + 10001) then
                        if Config.banplayer then
                        else
                            TriggerServerEvent("Noxans:Message:KickUniversal", "Geld verdacht")
                        end
                    else
                        oldmoney = money
                    end

                    if bank > (oldbank + 10001) then
                        if Config.banplayer then
                        else
                            TriggerServerEvent("Noxans:Message:KickUniversal", "Geld verdacht")
                        end
                    else
                        oldbank = bank
                    end

                    if money > 50000 or bank > 1000000 then
                        if Config.banplayer then
                        else
                            TriggerServerEvent("Noxans:Message:KickUniversal", "Geld verdacht")
                        end
                    end
                end
            )
        end
    end
)

RegisterNetEvent("Noxans:Activate")
AddEventHandler(
    "Noxans:Activate",
    function()
        activate = true
    end
)
