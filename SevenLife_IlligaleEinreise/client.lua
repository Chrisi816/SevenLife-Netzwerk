-- Variables
local firsttime
local openmenu = false
local inmarker3 = false
local notifys3 = true
local time3 = 100
local inmarker4 = false
local notifys4 = true
local takeit = false
local time4 = 100
local second = false
local time = 200
local timebetweenchecking = 200
local AllowSevenNotify = true
local inarea = false
local poscam =
    vector3(SevenConfig.NPCLocation.x + 1.15, SevenConfig.NPCLocation.y + 1.15, SevenConfig.NPCLocation.z + 1.5)
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
            local distance =
                GetDistanceBetweenCoords(
                coordofped,
                SevenConfig.NPCLocation.x,
                SevenConfig.NPCLocation.y,
                SevenConfig.NPCLocation.z,
                true
            )
            if distance < 20 then
                time = 110
                inarea = true
                if distance < 2 then
                    if AllowSevenNotify then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um mit Johannes zu reden",
                            "System-Nachricht",
                            true
                        )
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
                        if second and not takeit and not firsttime then
                            OpenMenu = true
                            ESX.TriggerServerCallback(
                                "SevenLife:CheckIFPlayerIsIllegal",
                                function(illegal)
                                    if illegal then
                                        takeit = true
                                        enableCam(ped)
                                        SetNuiFocus(true, true)
                                        AllowSevenNotify = false
                                        TriggerEvent("sevenliferp:closenotify", false)
                                        SendNUIMessage(
                                            {
                                                type = "OpenMenuJosie"
                                            }
                                        )
                                    else
                                        AllowSevenNotify = false
                                        TriggerEvent("sevenliferp:closenotify", false)
                                        TriggerEvent(
                                            "sevenliferp:startnui",
                                            "Mach dich ab du Legaler Schnösel",
                                            "System-Nachricht",
                                            true
                                        )
                                        Citizen.Wait(3000)
                                        TriggerEvent("sevenliferp:closenotify", false)
                                        AllowSevenNotify = true
                                        OpenMenu = false
                                    end
                                end
                            )
                        else
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Wegweiser", "Schau dir die Zettel an.", 2000)
                        end
                    end
                end
            else
                timebetweenchecking = 200
            end
        end
    end
)

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

-- NPC Function
local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)

            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                SevenConfig.NPCLocation.x,
                SevenConfig.NPCLocation.y,
                SevenConfig.NPCLocation.z,
                SevenConfig.NPCLocation.heading,
                true
            )

            Citizen.Wait(500)

            if distance < 30 then
                pedarea = true
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped1 =
                        CreatePed(
                        4,
                        ped,
                        SevenConfig.NPCLocation.x,
                        SevenConfig.NPCLocation.y,
                        SevenConfig.NPCLocation.z,
                        SevenConfig.NPCLocation.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped1, true)
                    FreezeEntityPosition(ped1, true)
                    SetBlockingOfNonTemporaryEvents(ped1, true)
                    TaskPlayAnim(ped1, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
                end
            end

            if pedloaded and not pedarea then
                DeleteEntity(ped1)
                SetModelAsNoLongerNeeded(ped)
                pedloaded = false
            end
        end
    end
)

function enableCam(player)
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

function disableCam()
    local player = GetPlayerPed(-1)
    RenderScriptCams(false, true, 1500, 1, 0)
    DestroyCam(cam, false)
    FreezeEntityPosition(player, false)

    FreezeEntityPosition(GetPlayerPed(-1), false)
end

RegisterNUICallback(
    "annehmen",
    function()
        OpenMenu = false
        disableCam()

        AllowSevenNotify = true
        SetNuiFocus(false, false)
        TriggerServerEvent("SevenLife:Illegal:GiveCard")
        TriggerServerEvent("SevenLife:HotelStarter:MakeOkFirst")
    end
)

RegisterNUICallback(
    "ablehnen",
    function()
        OpenMenu = false
        disableCam()
        SetNuiFocus(false, false)
        AllowSevenNotify = true
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(15000)
        ESX.TriggerServerCallback(
            "SevenLife:IllegaleEinreise:FirstTime",
            function(have)
                if have then
                    firsttime = true
                else
                    firsttime = false
                end
            end
        )
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            local coords = GetEntityCoords(Ped)
            local distance =
                GetDistanceBetweenCoords(coords, SevenConfig.Letter.x, SevenConfig.Letter.y, SevenConfig.Letter.z, true)
            Citizen.Wait(time3)
            if not firsttime then
                time3 = 15
                if distance < 3.5 then
                    time3 = 1
                    inmarker3 = true
                    notifys3 = true
                    if notifys3 then
                        DrawText3Ds(
                            SevenConfig.Letter.x,
                            SevenConfig.Letter.y,
                            SevenConfig.Letter.z,
                            "Drücke E um den Zettel aufzuheben"
                        )
                    end
                else
                    if distance >= 3.5 and distance <= 4.5 then
                        inmarker3 = false
                        notifys3 = false
                    end
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
            if not firsttime then
                if inmarker3 then
                    if IsControlJustPressed(0, 38) then
                        FreezeEntityPosition(Ped, true)
                        TaskStartScenarioInPlace(Ped, "PROP_HUMAN_BUM_SHOPPING_CART", 0, true)
                        inmarker3 = false
                        notifys3 = false
                        Citizen.Wait(1000)
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenInfoEntführung"
                            }
                        )
                    end
                else
                    Citizen.Wait(100)
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            local coords = GetEntityCoords(Ped)
            local distance =
                GetDistanceBetweenCoords(
                coords,
                SevenConfig.Zettelaufheben.x,
                SevenConfig.Zettelaufheben.y,
                SevenConfig.Zettelaufheben.z,
                true
            )
            Citizen.Wait(time4)
            if second then
                time4 = 15
                if distance < 3.5 then
                    time4 = 1
                    inmarker4 = true
                    notifys4 = true
                    if notifys4 then
                        DrawText3Ds(
                            SevenConfig.Zettelaufheben.x,
                            SevenConfig.Zettelaufheben.y,
                            SevenConfig.Zettelaufheben.z,
                            "Drücke E um den Zettel aufzuheben"
                        )
                    end
                else
                    if distance >= 3.5 and distance <= 4.5 then
                        inmarker4 = false
                        notifys4 = false
                    end
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
            if second then
                if inmarker4 then
                    if IsControlJustPressed(0, 38) then
                        FreezeEntityPosition(Ped, true)
                        TaskStartScenarioInPlace(Ped, "PROP_HUMAN_BUM_SHOPPING_CART", 0, true)
                        inmarker4 = false
                        notifys4 = false
                        Citizen.Wait(1000)
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenInfo"
                            }
                        )
                    end
                else
                    Citizen.Wait(100)
                end
            end
        end
    end
)
RegisterNUICallback(
    "removepaper",
    function()
        TriggerServerEvent("SevenLife:HotelStarter:MakeOkFirst")
        second = true
        openmenu = false
        notifys3 = false
        SetNuiFocus(false, false)
        local Ped = GetPlayerPed(-1)
        ClearPedTasks(Ped)
        FreezeEntityPosition(Ped, false)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Wegweiser", "Lauf den gang weiter entlang", 2000)
    end
)
RegisterNUICallback(
    "removepaper1",
    function()
        TriggerServerEvent("SevenLife:HotelStarter:MakeOkFirst")

        openmenu = false
        notifys4 = false
        SetNuiFocus(false, false)
        local Ped = GetPlayerPed(-1)
        ClearPedTasks(Ped)
        FreezeEntityPosition(Ped, false)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Wegweiser", "Lauf den gang weiter entlang", 2000)
    end
)
function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
local currentGear = {
    mask = 0,
    tank = 0,
    oxygen = 0,
    enabled = false
}

RegisterNetEvent("SevenLife:DivingSuit:Make")
AddEventHandler(
    "SevenLife:DivingSuit:Make",
    function()
        local ped = GetPlayerPed(-1)
        local maskModel = "p_d_scuba_mask_s"
        local tankModel = "p_s_scuba_tank_s"
        RequestModel(tankModel)
        while not HasModelLoaded(tankModel) do
            Wait(0)
        end
        currentGear.tank = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
        local bone1 = GetPedBoneIndex(ped, 24818)
        AttachEntityToEntity(currentGear.tank, ped, bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)

        RequestModel(maskModel)
        while not HasModelLoaded(maskModel) do
            Wait(0)
        end
        currentGear.mask = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
        local bone2 = GetPedBoneIndex(ped, 12844)
        AttachEntityToEntity(currentGear.mask, ped, bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
        SetEnableScuba(ped, true)
        SetPedMaxTimeUnderwater(ped, 2000.00)
        currentGear.enabled = true
        TriggerEvent("SevenLife:TimetCustom:Notify", "Wegweiser", "Schwimme zu dem Marker auf deiner Map", 2000)
        MakeBlip()
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
function MakeBlip()
    blip1 = AddBlipForCoord(SevenConfig.HelpCar.x, SevenConfig.HelpCar.y)

    SetBlipSprite(blip1, 774)
    SetBlipDisplay(blip1, 4)
    SetBlipScale(blip1, 1.0)
    SetBlipColour(blip1, 61)
    SetBlipRoute(blip1, true)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Illigale Einreise Helfer")
    EndTextCommandSetBlipName(blip1)
end
