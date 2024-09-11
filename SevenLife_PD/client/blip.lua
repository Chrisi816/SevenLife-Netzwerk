-- PD Blip
ESX = nil
PoliceBlips = {}
AllCopsService = {}
-- Core
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
        BlipPD(Config.blip.x, Config.blip.y, Config.blip.z)
    end
)

function BlipPD(coordsx, coordsy, coordsz)
    local blips = vector3(coordsx, coordsy, coordsz)
    local blip3 = AddBlipForCoord(blips)

    SetBlipSprite(blip3, 60)
    SetBlipColour(blip3, 63)
    SetBlipDisplay(blip3, 4)
    SetBlipAsShortRange(blip3, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Polizei")
    EndTextCommandSetBlipName(blip3)
end

RegisterNetEvent("SevenLife:Police:MakeCopsBlips")
AddEventHandler(
    "SevenLife:Police:MakeCopsBlips",
    function(name)
        table.insert(AllCopsService, name)

        ESX.TriggerServerCallback(
            "SevenLife:Police:Server:CheckIfGPSItem",
            function(HavePlayerGPS)
                if HavePlayerGPS then
                    MakeCopBlips()
                end
            end
        )
    end
)

function MakeCopBlips()
    for k, exist in pairs(PoliceBlips) do
        RemoveBlip(exist)
    end

    PoliceBlips = {}

    local idcops = {}

    for _, player in ipairs(GetActivePlayers()) do
        for i, c in pairs(AllCopsService) do
            if (i == GetPlayerServerId(player)) then
                idcops[player] = c

                break
            end
        end
    end

    for id, c in pairs(idcops) do
        local ped = GetPlayerPed(id)
        local coords = GetEntityCoords(ped)
        local blip = GetBlipFromEntity(ped)

        if not DoesBlipExist(blip) then
            blip = AddBlipForCoord(coords)
            SetBlipSprite(blip, 58)
            SetBlipColour(blip, 67)

            HideNumberOnBlip(blip)
            SetBlipNameToPlayerName(blip, id)
            SetBlipScale(blip, 0.85)
            SetBlipAlpha(blip, 255)

            table.insert(PoliceBlips, blip)
        else
            blipSprite = GetBlipSprite(blip)

            HideNumberOnBlip(blip)
            if blipSprite ~= 1 then
                SetBlipSprite(blip, 58)
            end

            SetBlipNameToPlayerName(blip, id)
            SetBlipScale(blip, 0.85)
            SetBlipAlpha(blip, 255)

            table.insert(PoliceBlips, blip)
        end
    end
end

RegisterNetEvent("SevenLife:Police:GetDataSource")
AddEventHandler(
    "SevenLife:Police:GetDataSource",
    function()
        if IsPlayerInPD and inoutservice then
            TriggerServerEvent("SevenLife:Police:Server:MakeBlipFromCops")
        end
    end
)

RegisterNetEvent("SevenLife:Police:MakeGlobalBlip")
AddEventHandler(
    "SevenLife:Police:MakeGlobalBlip",
    function(coords, types)
        local blip1 = AddBlipForCoord(coords)

        SetBlipSprite(blip1, 161)
        SetBlipColour(blip1, 53)
        SetBlipDisplay(blip1, 4)
        SetBlipAsShortRange(blip1, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Raub: " .. types)
        EndTextCommandSetBlipName(blip1)
    end
)

RegisterNetEvent("SevenLife:Police:SperrZoneBlip")
AddEventHandler(
    "SevenLife:Police:SperrZoneBlip",
    function(coords)
        BlipSperZone = AddBlipForCoord(coords)
        SetBlipSprite(BlipSperZone, 161)
        SetBlipColour(BlipSperZone, 53)
        SetBlipDisplay(BlipSperZone, 4)
        SetBlipScale(BlipSperZone, 1.5)
        SetBlipAsShortRange(BlipSperZone, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Sperrzone")
        EndTextCommandSetBlipName(BlipSperZone)
    end
)

RegisterNetEvent("SevenLife:Police:RemoveSperrzone")
AddEventHandler(
    "SevenLife:Police:RemoveSperrzone",
    function()
        RemoveBlip(BlipSperZone)
    end
)
RegisterNetEvent("SevenLife:PD:Warning1")
AddEventHandler(
    "SevenLife:PD:Warning1",
    function()
        blipRobbery = AddBlipForCoord(Config.StaatsBank.x, Config.StaatsBank.y, Config.StaatsBank.z)
        SetBlipSprite(blipRobbery, 161)
        SetBlipScale(blipRobbery, 2.0)
        SetBlipColour(blipRobbery, 3)
        PulseBlip(blipRobbery)
    end
)
RegisterNetEvent("SevenLife:PD:Warning2")
AddEventHandler(
    "SevenLife:PD:Warning2",
    function(coords)
        blipRobbery = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blipRobbery, 161)
        SetBlipScale(blipRobbery, 2.0)
        SetBlipColour(blipRobbery, 3)
        PulseBlip(blipRobbery)
    end
)
