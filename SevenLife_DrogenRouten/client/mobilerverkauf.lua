local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_m_mexlabor_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            Citizen.Wait(1000)

            for k, v in pairs(Config.GruppenLocation) do
                local distance = GetDistanceBetweenCoords(PlayerCoord, v.x, v.y, v.z, true)
                if not pedloaded then
                    if distance < 30 then
                        pedarea = true

                        RequestModel(ped)
                        while not HasModelLoaded(ped) do
                            Citizen.Wait(1)
                        end
                        ped1 = CreatePed(4, ped, v.x, v.y, v.z, v.heading, false, true)
                        SetEntityInvincible(ped1, true)
                        FreezeEntityPosition(ped1, true)
                        SetBlockingOfNonTemporaryEvents(ped1, true)
                        RequestAnimDict("amb@world_human_leaning@male@wall@back@smoking@idle_a")
                        while (not HasAnimDictLoaded("amb@world_human_leaning@male@wall@back@smoking@idle_a")) do
                            Citizen.Wait(10)
                        end
                        TaskPlayAnim(
                            ped1,
                            "amb@world_human_leaning@male@wall@back@smoking@idle_a",
                            "idle_a",
                            2.0,
                            -2.0,
                            -1,
                            49,
                            0,
                            true,
                            false,
                            true
                        )
                        pedloaded = true
                    else
                        if distance >= 30.1 and distance <= 50 then
                            pedarea = false
                        end
                    end
                end

                if pedloaded and not pedarea then
                    DeleteEntity(ped1)
                    SetModelAsNoLongerNeeded(ped)
                    pedloaded = false
                end
            end
        end
    end
)
--------------------------------------------------------------------------------------------------------------
--------------------------------------Get Locations and Actions-----------------------------------------------
--------------------------------------------------------------------------------------------------------------

local notifys = true
local inmarker = false
local inmenu = false

local timemain = 200
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            for k, v in pairs(Config.GruppenLocation) do
                local distance = GetDistanceBetweenCoords(coord, v.x, v.y, v.z, true)
                if distance < 15 then
                    timemain = 15
                    if distance < 2 then
                        inmarker = true
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um deine Drogen zu dealen",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 2.1 and distance <= 3 then
                            inmarker = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    if distance >= 15 and distance <= 50 then
                        timemain = 200
                    end
                end
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
                        openmenu = true
                        SetNuiFocus(true, true)
                        local ped = GetPlayerPed(-1)
                        EnableCam(ped)
                        SendNUIMessage(
                            {
                                type = "OpenInterMenu"
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
    "annehmen",
    function()
        DisableCam()
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Item:GetPackungenAll",
            function(count, count2, count3)
                TriggerEvent("sevenliferp:closenotify", false)
                if count >= 1 then
                    MakeRoute("koks_verpackt")
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Dealer",
                        "Ich habe dir eine Route markiert, fahre dort hin und bringe deine Päckchen weg!",
                        2000
                    )
                elseif count2 >= 1 then
                    MakeRoute("weed_verpackt")
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Dealer",
                        "Ich habe dir eine Route markiert, fahre dort hin und bringe deine Päckchen weg!",
                        2000
                    )
                elseif count3 >= 1 then
                    MakeRoute("meth_verpackt")
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Dealer",
                        "Ich habe dir eine Route markiert, fahre dort hin und bringe deine Päckchen weg!",
                        2000
                    )
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Dealer",
                        "Ich habe dir eine Route markiert, fahre dort hin und bringe deine Päckchen weg!",
                        2000
                    )
                end
            end,
            "koks_verpackt",
            "weed_verpackt",
            "meth_verpackt"
        )
    end
)
function MakeRoute(droge)
    local coords = GetCoords()
    -- Polizei Nachricht
    Createblip(coords.x, coords.y, coords.z)

    CreatePeds(coords.x, coords.y, coords.z, coords.heading)

    TriggerEvent("SevenLife:Drogen:CreateThread", coords.x, coords.y, coords.z, droge)
end

function GetCoords()
    local random = math.random(1, 10)
    for k, v in pairs(Config.EndLocations) do
        if k == random then
            return v
        end
    end
end

function Createblip(x, y, z)
    BlipsDrogen = AddBlipForCoord(x, y, z)

    SetBlipSprite(BlipsDrogen, 817)
    SetBlipDisplay(BlipsDrogen, 4)
    SetBlipScale(BlipsDrogen, 1.0)
    SetBlipColour(BlipsDrogen, 48)
    SetBlipAsShortRange(BlipsDrogen, true)
    SetBlipRoute(BlipsDrogen, true)
    SetBlipRouteColour(BlipsDrogen, 59)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Drogen abnehmer")
    EndTextCommandSetBlipName(BlipsDrogen)
end

function CreatePeds(x, y, z, heading)
    RequestModel(ped)
    while not HasModelLoaded(ped) do
        Citizen.Wait(1)
    end
    ped2 = CreatePed(4, ped, x, y, z, heading, false, true)
    SetEntityInvincible(ped2, true)
    FreezeEntityPosition(ped2, true)
    SetBlockingOfNonTemporaryEvents(ped2, true)
    RequestAnimDict("amb@world_human_leaning@male@wall@back@smoking@idle_a")
    while (not HasAnimDictLoaded("amb@world_human_leaning@male@wall@back@smoking@idle_a")) do
        Citizen.Wait(10)
    end
    TaskPlayAnim(
        ped2,
        "amb@world_human_leaning@male@wall@back@smoking@idle_a",
        "idle_a",
        2.0,
        -2.0,
        -1,
        49,
        0,
        true,
        false,
        true
    )
end
RegisterNetEvent("SevenLife:Drogen:CreateThread")
AddEventHandler(
    "SevenLife:Drogen:CreateThread",
    function(x, y, z, drogen)
        local notifys1 = true
        local inmarker1 = false
        local inmenu1 = false

        local timemain = 100
        Citizen.CreateThread(
            function()
                while true do
                    Citizen.Wait(timemain)
                    local ped = GetPlayerPed(-1)
                    local coord = GetEntityCoords(ped)

                    local distance = GetDistanceBetweenCoords(coord, x, y, z, true)
                    if distance < 15 then
                        timemain = 15
                        if distance < 2 then
                            inmarker1 = true
                            if notifys1 then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um deine Drogen zu verkaufen",
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
                                openmenu = true
                                SendNUIMessage(
                                    {
                                        type = "OpenBarDrogenSelling"
                                    }
                                )

                                Citizen.CreateThread(
                                    function()
                                        Citizen.Wait(21000)

                                        TriggerServerEvent("SevenLife:Valid:GiveGeld", drogen)
                                        inmenu = false
                                        notifys = true
                                        notifys = true
                                        inmarker = false
                                        inmenu = false
                                        inmenu1 = true
                                        TriggerEvent("sevenliferp:closenotify", false)
                                        notifys1 = false
                                        openmenu1 = true
                                        RemoveBlip(BlipsDrogen)
                                        ClearAllBlipRoutes()
                                        local random = math.random(1, 10)
                                        if random >= 8 then
                                            -- Polizei Nachricht
                                            TriggerEvent(
                                                "SevenLife:TimetCustom:Notify",
                                                "Dealer",
                                                "Du hast erfolgreich ein paar Packungen verkauft, laufe weg da der Entgegennehmer die Polizei gerufen hat!",
                                                2000
                                            )
                                        else
                                            TriggerEvent(
                                                "SevenLife:TimetCustom:Notify",
                                                "Dealer",
                                                "Du hast erfolgreich ein paar Packungen verkauft!",
                                                2000
                                            )
                                        end

                                        Citizen.Wait(60000 * 10)
                                        DeletePed(ped2)
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
    end
)
function EnableCam(player)
    local rx = GetEntityRotation(ped1)
    camrot = rx + vector3(0.0, 0.0, 181)
    local px, py, pz = table.unpack(GetEntityCoords(ped1, true))
    local x, y, z = px + GetEntityForwardX(ped1) * 1.2, py + GetEntityForwardY(ped1) * 1.2, pz + 0.52
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

RegisterNUICallback(
    "closes",
    function()
        notifys = true
        inmarker = false
        inmenu = false
        DisableCam()
        SetNuiFocus(false, false)
    end
)
