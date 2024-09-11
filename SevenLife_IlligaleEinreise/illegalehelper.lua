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

local time = 200
local timebetweenchecking = 200
local AllowSevenNotify = true
local inarea = false
local OpenMenu = false
local inmarker = false
local NumberCharset = {}
local Charset = {}

for i = 48, 57 do
    table.insert(NumberCharset, string.char(i))
end

for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end
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
                SevenConfig.HelpCar.x,
                SevenConfig.HelpCar.y,
                SevenConfig.HelpCar.z,
                true
            )
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
                                    type = "OpenMenuJosie1"
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
    "annehmen1",
    function()
        OpenMenu = false
        DisableCam()
        notactive = false
        AllowSevenNotify = true
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "SevenLife:Questing:CheckIfPlayerHaveAccount",
            function(result)
                if result then
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Illegale Einreise",
                        "Du hast schon dein Starterpacket angenommen",
                        2000
                    )
                else
                    SpawnCar()
                    DeleteObject(currentGear.tank)
                    DeleteObject(currentGear.mask)
                    ClearAllBlipRoutes()
                    RemoveBlip(blip1)
                    Citizen.Wait(1000)
                    inmarker = false
                    TriggerEvent("sevenliferp:closenotify", false)
                end
            end
        )
    end
)

function SpawnCar()
    ESX.Game.SpawnVehicle(
        "blazer",
        vector3(SevenConfig.SpawnCar.x, SevenConfig.SpawnCar.y, SevenConfig.SpawnCar.z),
        SevenConfig.SpawnCar.heading,
        function(vehicle)
            local id = MakeID()
            local plate = MakePlate()
            local props = ESX.Game.GetVehicleProperties(vehicle)
            SetVehicleCustomSecondaryColour(vehicle, 255, 255, 255)
            SetVehicleCustomPrimaryColour(vehicle, 255, 255, 255)
            local ped = GetPlayerPed(-1)
            SetVehicleNumberPlateText(vehicle, plate)
            SetPedIntoVehicle(ped, vehicle, -1)
            TriggerEvent("SevenLife:AutoHeander:MakeAutoOwned", props, id, "car")
            WashDecalsFromVehicle(vehicle, 1.0)
            SetVehicleDirtLevel(vehicle, 0.0)
        end
    )
end
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
            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                SevenConfig.HelpCar.x,
                SevenConfig.HelpCar.y,
                SevenConfig.HelpCar.z,
                true
            )

            Citizen.Wait(500)
            pedarea = false
            if distance < 40 then
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
                        SevenConfig.HelpCar.x,
                        SevenConfig.HelpCar.y,
                        SevenConfig.HelpCar.z,
                        SevenConfig.HelpCar.heading,
                        false,
                        true
                    )
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
function MakePlate()
    local MakePlate
    local doBreak = false

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())

        MakePlate = string.upper(GetRandomLetter(3) .. GetRandomNumber(3))

        ESX.TriggerServerCallback(
            "sevenlife:platetaken",
            function(isPlateTaken)
                if not isPlateTaken then
                    doBreak = true
                end
            end,
            MakePlate
        )

        if doBreak then
            break
        end
    end

    return MakePlate
end

function GetRandomNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ""
    end
end

function GetRandomLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ""
    end
end

function MakeID()
    local MakePlate
    local doBreak = false

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())

        MakePlate = string.upper(GetRandomLetter(10) .. GetRandomNumber(10))

        ESX.TriggerServerCallback(
            "sevenlife:isidTaken",
            function(isPlateTaken)
                if not isPlateTaken then
                    doBreak = true
                end
            end,
            MakePlate
        )

        if doBreak then
            break
        end
    end

    return MakePlate
end
