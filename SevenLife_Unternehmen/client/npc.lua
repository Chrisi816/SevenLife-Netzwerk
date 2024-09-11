pedloaded = false
local pedarea = false
local dealerModel = GetHashKey("a_m_y_hasjew_01")

Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            Citizen.Wait(1000)

            local distance = GetDistanceBetweenCoords(PlayerCoord, Config.NPC.x, Config.NPC.y, Config.NPC.z, true)
            if not pedloaded then
                if distance < 30 then
                    pedarea = true

                    RequestModel(dealerModel)
                    while not HasModelLoaded(dealerModel) do
                        Citizen.Wait(1)
                    end
                    ped1 =
                        CreatePed(
                        4,
                        dealerModel,
                        Config.NPC.x,
                        Config.NPC.y,
                        Config.NPC.z - 1,
                        Config.NPC.heading,
                        false,
                        true
                    )
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
                SetModelAsNoLongerNeeded(ped1)
                pedloaded = false
            end
        end
    end
)
local inmarker = false
local inmenu = false
local allowednotifys = true
Citizen.CreateThread(
    function()
        Citizen.Wait(20)

        while true do
            player = GetPlayerPed(-1)
            Citizen.Wait(200)

            local coords = GetEntityCoords(player)
            local distance = GetDistanceBetweenCoords(coords, Config.NPC.x, Config.NPC.y, Config.NPC.z, true)
            if distance < 2.5 then
                inmarker = true
                if allowednotifys then
                    TriggerEvent(
                        "sevenliferp:startnui",
                        "Drücke <span1 color = white>E</span1> um mit der Assistenten zu reden",
                        "System - Nachricht",
                        true
                    )
                end
            else
                if distance >= 2.5 and distance <= 4.5 then
                    inmarker = false
                    TriggerEvent("sevenliferp:closenotify", false)
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5000)
            local player = GetPlayerPed(-1)
            if IsPlayerDead(player) or IsEntityDead(player) then
                inmarker = false
                inmenu = false
                allowednotifys = true
            end
        end
    end
)
Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        while true do
            Citizen.Wait(1)
            if inmarker then
                if IsControlJustReleased(0, 38) then
                    if inmenu == false then
                        Citizen.Wait(100)
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        allowednotifys = false
                        SetNuiFocus(true, true)
                        local ped = GetPlayerPed(-1)
                        EnableCam(ped)
                        SendNUIMessage(
                            {
                                type = "OpenFirstMenu"
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
    "close",
    function()
        inmenu = false
        allowednotifys = true
        DisableCam()
        SetNuiFocus(false, false)
    end
)
RegisterNUICallback(
    "BuyItems",
    function(data)
        TriggerServerEvent("SevenLife:Unternehmen:Buy", data.Item, data.Count, data.preis)
    end
)
RegisterNUICallback(
    "Shops",
    function()
        SendNUIMessage(
            {
                type = "OpenShop"
            }
        )
    end
)
function EnableCam(player)
    local rx = GetEntityRotation(DealerEntity)
    camrot = rx + vector3(0.0, 0.0, 181)
    local px, py, pz = table.unpack(GetEntityCoords(DealerEntity, true))
    local x, y, z = px + GetEntityForwardX(DealerEntity) * 1.2, py + GetEntityForwardY(DealerEntity) * 1.2, pz + 0.52
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
