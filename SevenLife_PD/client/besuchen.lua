--------------------------------------------------------------------------------------------------------------
---------------------------------------------Npc Spawner------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
inbesuch = false
local pedloaded = false
local pedarea = false
local ped = GetHashKey("s_m_m_armoured_02")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance =
                GetDistanceBetweenCoords(PlayerCoord, Config.GoInside.x, Config.GoInside.y, Config.GoInside.z, true)

            Citizen.Wait(500)

            if distance < 50 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped6 =
                        CreatePed(
                        4,
                        ped,
                        Config.GoInside.x,
                        Config.GoInside.y,
                        Config.GoInside.z,
                        Config.GoInside.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped6, true)
                    FreezeEntityPosition(ped6, true)
                    SetBlockingOfNonTemporaryEvents(ped6, true)
                    TaskPlayAnim(ped6, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped6)
                SetModelAsNoLongerNeeded(ped6)
                pedloaded = false
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------

notifys9 = true
inmarker9 = false
inmenu9 = false

local timemain1 = 100
Citizen.CreateThread(
    function()
        BlipGefeangnisBesuchen()
        while true do
            Citizen.Wait(timemain1)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance =
                GetDistanceBetweenCoords(coord, Config.GoInside.x, Config.GoInside.y, Config.GoInside.z, true)
            if distance < 15 then
                timemain1 = 15
                if distance < 2 then
                    inmarker9 = true
                    if notifys9 then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um mit Johannes zu sprechen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.1 and distance <= 3 then
                        inmarker9 = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        BlipGefeangnisEssenGeben()
        BlipGefeangnisRausgehen()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmarker9 then
                if IsControlJustPressed(0, 38) then
                    if inmenu9 == false then
                        inmenu9 = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys9 = false
                        SetNuiFocus(true, false)
                        SendNUIMessage(
                            {
                                type = "OpenBesucherBild"
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
function BlipGefeangnisBesuchen()
    local blips = vector3(Config.GoInside.x, Config.GoInside.y, Config.GoInside.z)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 279)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 9)
    SetBlipScale(blip1, 0.9)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Insasen Besuchen")
    EndTextCommandSetBlipName(blip1)
end
function BlipGefeangnisRausgehen()
    local blips = vector3(Config.GoOutside.x, Config.GoOutside.y, Config.GoOutside.z)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 367)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 9)
    SetBlipScale(blip1, 0.9)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Verlassen")
    EndTextCommandSetBlipName(blip1)
end

RegisterNUICallback(
    "MakeActionBesuchen",
    function(data)
        SetNuiFocus(false, false)
        notifys9 = true
        inmarker9 = false
        inmenu9 = false
        local actions = tonumber(data.action)

        if actions == 1 then
            TriggerServerEvent("SevenLife:PD:InsertBesucher")
            SetEntityCoords(PlayerPedId(), 1729.09, 2563.57, 45.56)
            inbesuch = true
            TriggerEvent(
                "SevenLife:TimetCustom:Notify",
                "Gefängnis",
                "Du bist jetzt zum Besuch im Gefängnis. Dein Inventar wurde ausgeschaltet damit du keine Items weitergeben kannst",
                2000
            )
            Citizen.CreateThread(
                function()
                    while inbesuch do
                        Citizen.Wait(1)
                        DisableControlAction(2, 37, true)
                        DisablePlayerFiring(GetPlayerPed(-1), true)
                        DisableControlAction(0, 45, true)
                        DisableControlAction(0, 24, true)
                        DisableControlAction(0, 263, true)
                        DisableControlAction(0, 140, true)
                        DisableControlAction(0, 142, true)
                        SetPlayerInvincible(PlayerId(), true)
                    end
                end
            )
            TriggerEvent("SevenLife:Inventory:DisableInventory")
        elseif actions == 2 then
        end
    end
)
function MakeUniform()
    TriggerEvent(
        "skinchanger:getSkin",
        function(skin)
            if skin.sex == 0 then
                if Config.JobUniforms.male ~= nil then
                    TriggerEvent("skinchanger:loadClothes", skin, Config.JobUniforms.male)
                end
            else
                if Config.JobUniforms.female ~= nil then
                    TriggerEvent("skinchanger:loadClothes", skin, Config.JobUniforms.female)
                end
            end
        end
    )
end

--------------------------------------------------------------------------------------------------------------
---------------------------------------------Npc Spawner------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
local pedloaded = false
local pedarea = false
local ped = GetHashKey("s_m_m_armoured_02")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance =
                GetDistanceBetweenCoords(PlayerCoord, Config.GoOutside.x, Config.GoOutside.y, Config.GoOutside.z, true)

            Citizen.Wait(500)

            if distance < 50 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped7 =
                        CreatePed(
                        4,
                        ped,
                        Config.GoOutside.x,
                        Config.GoOutside.y,
                        Config.GoOutside.z,
                        Config.GoOutside.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped7, true)
                    FreezeEntityPosition(ped7, true)
                    SetBlockingOfNonTemporaryEvents(ped7, true)
                    TaskPlayAnim(ped7, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped7)
                SetModelAsNoLongerNeeded(ped7)
                pedloaded = false
            end
        end
    end
)

--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------

notifys10 = true
inmarker10 = false
inmenu10 = false

local timemain1 = 100
Citizen.CreateThread(
    function()
        BlipGefeangnisBesuchen()
        while true do
            Citizen.Wait(timemain1)
            if inbesuch then
                local ped = GetPlayerPed(-1)
                local coord = GetEntityCoords(ped)

                local distance =
                    GetDistanceBetweenCoords(coord, Config.GoOutside.x, Config.GoOutside.y, Config.GoOutside.z, true)
                if distance < 15 then
                    timemain1 = 15
                    if distance < 2 then
                        inmarker10 = true
                        if notifys10 then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um mit Johannes zu sprechen",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 2.1 and distance <= 3 then
                            inmarker10 = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                end
            else
                Citizen.Wait(10000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        BlipGefeangnisEssenGeben()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inbesuch then
                if inmarker10 then
                    if IsControlJustPressed(0, 38) then
                        if inmenu10 == false then
                            TriggerServerEvent("SevenLife:Gefeangnis:KickOutOfGefeangnis")
                            SetEntityCoords(PlayerPedId(), Config.GoInside.x, Config.GoInside.y, Config.GoInside.z)
                            TriggerEvent("SevenLife:Inventory:AnableInventory")
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Gefängnis",
                                "Erfolgreich aus dem Gefängnis rausgegangen",
                                2000
                            )
                            inbesuch = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(10000)
            end
        end
    end
)
