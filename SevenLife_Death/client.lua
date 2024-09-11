ESX = nil
local IsDead = false

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

local deadplayer = false
local secondsRemaining = Config.BleedoutTimer
local time = 50
local respwntimer = false

AddEventHandler(
    "esx:onPlayerDeath",
    function(data)
        SendNUIMessage({type = "ActiveDead"})
        local ped = GetPlayerPed(-1)
        loadAnimDict("random@dealgonewrong")
        TaskPlayAnim(ped, "random@dealgonewrong", "idle_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        IsDead = true
        SetControlNormal(0, 177, 1.0)
        SetControlNormal(0, 200, 1.0)
        Citizen.Wait(10000)

        ClearPedTasks(ped)

        if IsDead then
            RespawnPlayer()
        end
    end
)

AddEventHandler(
    "playerSpawned",
    function(spawn)
        IsDead = false
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)
            if secondsRemaining > 0 and IsDead then
                secondsRemaining = secondsRemaining - 1
                SendNUIMessage(
                    {
                        type = "UpdateDeas",
                        second = secondsRemaining
                    }
                )
            end
        end
    end
)

function RespawnPlayer()
    SendNUIMessage({type = "RemoveDead"})
    TriggerServerEvent("SevenLife:Death:RemoveALL")

    DoScreenFadeOut(3000)
    Citizen.Wait(3000)
    DoScreenFadeIn(3000)

    SetEntityCoordsNoOffset(
        PlayerPedId(),
        Config.respawnpoint.x,
        Config.respawnpoint.y,
        Config.respawnpoint.z,
        false,
        false,
        false,
        true
    )
    NetworkResurrectLocalPlayer(Config.respawnpoint.x, Config.respawnpoint.y, Config.respawnpoint.z, 200, true, false)
    SetPlayerInvincible(PlayerPedId(), false)
    ClearPedBloodDamage(PlayerPedId())
    IsDead = false
    secondsRemaining = Config.BleedoutTimer

    TriggerEvent("SevenLife:Medic:LayDownOnBed")
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        Citizen.Wait(1)
    end
end

RegisterNetEvent("SevenLife:Admin:HealdAndMove")
AddEventHandler(
    "SevenLife:Admin:HealdAndMove",
    function()
        IsDead = false
        Citizen.Wait(100)
        secondsRemaining = Config.BleedoutTimer
        SendNUIMessage({type = "RemoveDead"})

        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)

        local coords = GetEntityCoords(GetPlayerPed(-1))
        SetEntityCoordsNoOffset(PlayerPedId(), coords, false, false, false, true)
        NetworkResurrectLocalPlayer(coords, 200, true, false)
        SetPlayerInvincible(PlayerPedId(), false)
        ClearPedBloodDamage(PlayerPedId())
        IsDead = false
        secondsRemaining = Config.BleedoutTimer
    end
)
RegisterNetEvent("SevenLife:DeathScreen:Wiederbeleben")
AddEventHandler(
    "SevenLife:DeathScreen:Wiederbeleben",
    function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        isBusy = true

        ESX.TriggerServerCallback(
            "SevenLife:Medic:GetItem",
            function(quantity)
                if quantity > 0 then
                    local closestPlayerPed = GetPlayerPed(closestPlayer)

                    if IsPedDeadOrDying(closestPlayerPed, 1) then
                        local playerPed = PlayerPedId()
                        local lib, anim = "mini@cpr@char_a@cpr_str", "cpr_pumpchest"
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Information",
                            "Du belebst diese Person wieder",
                            2000
                        )

                        for i = 1, 15 do
                            Citizen.Wait(900)

                            ESX.Streaming.RequestAnimDict(
                                lib,
                                function()
                                    TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
                                end
                            )
                        end

                        TriggerServerEvent("SevenLife:Medic:RemoveItem", "defibrillator")
                        TriggerServerEvent("SevenLife:Death:WiederBeleben", GetPlayerServerId(closestPlayer))
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Spieler ist nicht tod", 2000)
                    end
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Du hast keinen Defibrillator", 2000)
                end
                isBusy = false
            end,
            "defibrillator"
        )
    end
)
RegisterNetEvent("SevenLife:Death:WiederbelebenClient")
AddEventHandler(
    "SevenLife:Death:WiederbelebenClient",
    function()
        IsDead = false
        Citizen.Wait(100)
        secondsRemaining = Config.BleedoutTimer
        SendNUIMessage({type = "RemoveDead"})

        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)

        local coords = GetEntityCoords(GetPlayerPed(-1))
        SetEntityCoordsNoOffset(PlayerPedId(), coords, false, false, false, true)
        NetworkResurrectLocalPlayer(coords, 200, true, false)
        SetPlayerInvincible(PlayerPedId(), false)
        ClearPedBloodDamage(PlayerPedId())
        IsDead = false
        secondsRemaining = Config.BleedoutTimer
    end
)
RegisterNetEvent("SevenLife:DeathScreen:pillen")
AddEventHandler(
    "SevenLife:DeathScreen:pillen",
    function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        isBusy = true

        ESX.TriggerServerCallback(
            "SevenLife:Medic:GetItem",
            function(quantity)
                if quantity > 0 then
                    local closestPlayerPed = GetPlayerPed(closestPlayer)

                    if IsPedDeadOrDying(closestPlayerPed, 1) then
                        local playerPed = PlayerPedId()
                        local lib, anim = "mini@cpr@char_a@cpr_str", "cpr_pumpchest"
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Information",
                            "Pillen verabreicht. Person hat jetzt 5 min mehr zeit!",
                            2000
                        )

                        TriggerServerEvent("SevenLife:Medic:RemoveItem", "pillen")
                        TriggerServerEvent("SevenLife:Death:Pillen", GetPlayerServerId(closestPlayer))
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Spieler ist nicht tod", 2000)
                    end
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Du hast keine Pillen", 2000)
                end
                isBusy = false
            end,
            "pillen"
        )
    end
)
RegisterNetEvent("SevenLife:Death:PillenClient")
AddEventHandler(
    "SevenLife:Death:PillenClient",
    function()
        secondsRemaining = secondsRemaining + 300
    end
)
