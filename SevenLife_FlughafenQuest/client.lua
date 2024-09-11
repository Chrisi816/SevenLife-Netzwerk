local npc = vector3(-1039.7523193359, -2732.2373046875, 19.169288635254)
local car = vector3(-1042.34, -2723.06, 19.17)
local carheading = 238.63
local npcheading = 216.67
local activmission
-- Variables
local time = 200
local timebetweenchecking = 200
local AllowSevenNotify = true
local inarea = false
local OpenMenu = false
local inmarker = false
-- ESX

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
            Citizen.Wait(10)
        end
    end
)

-- Local Start
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time)
            local ped = GetPlayerPed(-1)
            local coordofped = GetEntityCoords(ped)
            local distance = GetDistanceBetweenCoords(coordofped, npc.x, npc.y, npc.z, true)
            if distance < 20 then
                time = 110
                inarea = true
                if distance < 2 then
                    if AllowSevenNotify then
                        TriggerEvent("sevenliferp:startnui", "Drücke E um mit Josie zu reden", "System-Nachricht", true)
                    end
                    inmarker = true
                else
                    if distance >= 2.1 and distance <= 3 then
                        TriggerEvent("sevenliferp:closenotify", false)
                        inmarker = false
                    end
                end
            else
                inarea = false
                time = 200
            end
        end
    end
)
local notactive = false
-- KeyCheck
Citizen.CreateThread(
    function()
        while true do
            local ped = GetPlayerPed(-1)
            Citizen.Wait(timebetweenchecking)
            if inarea then
                timebetweenchecking = 5
                if inmarker and not OpenMenu then
                    if IsControlJustPressed(0, 38) then
                        OpenMenu = true
                        if not notactive then
                            notactive = true
                            EnableCam(ped)
                            SetNuiFocus(true, true)
                            AllowSevenNotify = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            SendNUIMessage(
                                {
                                    type = "OpenMenuJosie"
                                }
                            )
                        end
                    end
                end
            else
                timebetweenchecking = 200
            end
        end
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

-- Delete NPC
AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        DeletePed(ped1)
    end
)

RegisterNUICallback(
    "annehmen",
    function()
        OpenMenu = false
        DisableCam()
        notactive = false
        AllowSevenNotify = true
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:AnfangsQuest:CheckIfPlayerHaveAccount",
            function(result)
                if result then
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Anfangs - Quest",
                        "Du hast die Anfangs - Quest schon gestartet. Solltest du diese noch nicht absolviert haben und sie nicht sehen. Gehe unter f3 in die Einstellungen und schalte dort die Option: AnfängerQuest NUI auf true",
                        2000
                    )
                else
                    SendNUIMessage(
                        {
                            type = "OpenNoobQuests",
                            meilenstein = Config.MissionDesc.mission1.Name,
                            Desctext = Config.MissionDesc.mission1.Desc,
                            ZahlIndex = "1/0"
                        }
                    )
                end
            end
        )
    end
)
RegisterNUICallback(
    "closes",
    function()
        notactive = false
        OpenMenu = false
        DisableCam()
        SetNuiFocus(false, false)
        AllowSevenNotify = true
    end
)

local pedarea = false
local ped = GetHashKey("a_f_m_prolhost_01")
local pedloaded = false
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance = GetDistanceBetweenCoords(PlayerCoord, npc.x, npc.y, npc.z, true)

            Citizen.Wait(500)
            pedarea = false
            if distance < 40 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped1 = CreatePed(4, ped, npc.x, npc.y, npc.z, npcheading, false, true)
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
RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        PlayerData = xPlayer
        Citizen.CreateThread(
            function()
                ESX.TriggerServerCallback(
                    "SevenLife:Quest:GetAll",
                    function(result, missionid)
                        if result then
                            local missionid = tonumber(missionid)

                            if missionid == 1 then
                                activmission = 1
                                SendNUIMessage(
                                    {
                                        type = "OpenNoobQuests",
                                        meilenstein = Config.MissionDesc.mission1.Name,
                                        Desctext = Config.MissionDesc.mission1.Desc,
                                        ZahlIndex = "1 / 0"
                                    }
                                )
                            elseif missionid == 2 then
                                activmission = 2
                                SendNUIMessage(
                                    {
                                        type = "OpenNoobQuests",
                                        meilenstein = Config.MissionDesc.mission2.Name,
                                        Desctext = Config.MissionDesc.mission2.Desc,
                                        ZahlIndex = "1 / 0"
                                    }
                                )
                            elseif missionid == 3 then
                                activmission = 3
                                SendNUIMessage(
                                    {
                                        type = "OpenNoobQuests",
                                        meilenstein = Config.MissionDesc.mission3.Name,
                                        Desctext = Config.MissionDesc.mission3.Desc,
                                        ZahlIndex = "1 / 0"
                                    }
                                )
                            elseif missionid == 4 then
                                activmission = 4
                                SendNUIMessage(
                                    {
                                        type = "OpenNoobQuests",
                                        meilenstein = Config.MissionDesc.mission4.Name,
                                        Desctext = Config.MissionDesc.mission4.Desc,
                                        ZahlIndex = "1 / 0"
                                    }
                                )
                            elseif missionid == 5 then
                                activmission = 5
                                SendNUIMessage(
                                    {
                                        type = "OpenNoobQuests",
                                        meilenstein = Config.MissionDesc.mission5.Name,
                                        Desctext = Config.MissionDesc.mission5.Desc,
                                        ZahlIndex = "1 / 0"
                                    }
                                )
                            elseif missionid == 6 then
                                activmission = 6
                                SendNUIMessage(
                                    {
                                        type = "OpenNoobQuests",
                                        meilenstein = Config.MissionDesc.mission6.Name,
                                        Desctext = Config.MissionDesc.mission6.Desc,
                                        ZahlIndex = "200 / 0"
                                    }
                                )
                            end
                        end
                    end
                )
            end
        )
    end
)

RegisterNetEvent("SevenLife:Quest:UpdateIfPossible")
AddEventHandler(
    "SevenLife:Quest:UpdateIfPossible",
    function(id)
        if activmission == id then
            ESX.TriggerServerCallback(
                "SevenLife:Quest:GetAll",
                function(result, missionid)
                    if result then
                        local nextquest = id + 1
                        TriggerServerEvent("SevenLife:Quest:Override", nextquest)

                        if nextquest == 1 then
                            activmission = 1
                            SendNUIMessage(
                                {
                                    type = "OpenNoobQuests",
                                    meilenstein = Config.MissionDesc.mission1.Name,
                                    Desctext = Config.MissionDesc.mission1.Desc,
                                    ZahlIndex = "1 / 0"
                                }
                            )
                        elseif nextquest == 2 then
                            activmission = 2
                            SendNUIMessage(
                                {
                                    type = "OpenNoobQuests",
                                    meilenstein = Config.MissionDesc.mission2.Name,
                                    Desctext = Config.MissionDesc.mission2.Desc,
                                    ZahlIndex = "1 / 0"
                                }
                            )
                        elseif nextquest == 3 then
                            activmission = 3
                            SendNUIMessage(
                                {
                                    type = "OpenNoobQuests",
                                    meilenstein = Config.MissionDesc.mission3.Name,
                                    Desctext = Config.MissionDesc.mission3.Desc,
                                    ZahlIndex = "1 / 0"
                                }
                            )
                        elseif nextquest == 4 then
                            activmission = 4
                            SendNUIMessage(
                                {
                                    type = "OpenNoobQuests",
                                    meilenstein = Config.MissionDesc.mission4.Name,
                                    Desctext = Config.MissionDesc.mission4.Desc,
                                    ZahlIndex = "1 / 0"
                                }
                            )
                        elseif nextquest == 5 then
                            activmission = 5
                            SendNUIMessage(
                                {
                                    type = "OpenNoobQuests",
                                    meilenstein = Config.MissionDesc.mission5.Name,
                                    Desctext = Config.MissionDesc.mission5.Desc,
                                    ZahlIndex = "1 / 0"
                                }
                            )
                        elseif nextquest == 6 then
                            activmission = 6
                            SendNUIMessage(
                                {
                                    type = "OpenNoobQuests",
                                    meilenstein = Config.MissionDesc.mission6.Name,
                                    Desctext = Config.MissionDesc.mission6.Desc,
                                    ZahlIndex = "10 / 0"
                                }
                            )
                        end
                    end
                end
            )
        end
    end
)
RegisterNetEvent("SevenLife:FlughafenQuest:ActivateCam")
AddEventHandler(
    "SevenLife:FlughafenQuest:ActivateCam",
    function()
        while not pedloaded do
            Citizen.Wait(1)
        end
        local ped = GetPlayerPed(-1)
        EnableCam(ped)
        Wait(5000)
        DisableCam()
    end
)
