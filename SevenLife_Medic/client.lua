ESX = nil
indienst = false
medic = false
heandegewaschen = false

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(newJob)
        ESX.PlayerData["job"] = newJob
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(1000)

        while true do
            Citizen.Wait(3000)

            if ESX.PlayerData["job"] == "Medic" then
                medic = true
            else
                medic = false
            end
        end
    end
)

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

Citizen.CreateThread(
    function()
        MakeBlipForHospital()
    end
)

function MakeBlipForHospital()
    local blip = AddBlipForCoord(Config.Hospital.Zentrum.x, Config.Hospital.Zentrum.y, Config.Hospital.Zentrum.z)
    SetBlipSprite(blip, 61)
    SetBlipColour(blip, 2)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Krankenhaus")
    EndTextCommandSetBlipName(blip)
end
function GetClosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords - playerCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
    if closestDistance ~= -1 and closestDistance <= radius then
        return closestPlayer
    else
        return nil
    end
end

local carryactive = false
local targetid = -1
local types = ""
RegisterNetEvent("SevenLife:Medic:carrymmedic")
AddEventHandler(
    "SevenLife:Medic:carrymmedic",
    function()
        if carryactive then
            local closestPlayer = GetClosestPlayer(3)
            if closestPlayer then
                local targetSrc = GetPlayerServerId(closestPlayer)
                if targetSrc ~= -1 then
                    carryactive = true
                    targetid = targetSrc
                    TriggerServerEvent("SevenLife:Medic:Sync", targetSrc)
                    ensureAnimDict(carry.personCarrying.animDict)
                    types = "carrying"
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Information",
                        "Es gibt hier keinen um zu carryn",
                        2000
                    )
                end
            else
                TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Es gibt hier keinen um zu carryn", 2000)
            end
        else
            carryactive = false
            ClearPedSecondaryTask(PlayerPedId())
            DetachEntity(PlayerPedId(), true, false)
            TriggerServerEvent("SevenLife:Medic:Stop", targetid)
            targetid = 0
        end
    end
)
RegisterNetEvent("SevenLife:Medic:putinvehicle")
AddEventHandler(
    "SevenLife:Medic:putinvehicle",
    function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        TriggerServerEvent("SevenLife:Medic:PutIntoVehicle", GetPlayerServerId(closestPlayer))
    end
)
RegisterNetEvent("SevenLife:Medic:PutIntoVehicleClient")
AddEventHandler(
    "SevenLife:Medic:PutIntoVehicleClient",
    function()
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        if IsAnyVehicleNearPoint(coords, 5.0) then
            local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

            if DoesEntityExist(vehicle) then
                local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

                for i = maxSeats - 1, 0, -1 do
                    if IsVehicleSeatFree(vehicle, i) then
                        freeSeat = i
                        break
                    end
                end

                if freeSeat then
                    TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
                end
            end
        end
    end
)
local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end
    return animDict
end
RegisterNetEvent("SevenLife:Medic:SyncTarget")
AddEventHandler(
    "SevenLife:Medic:SyncTarget",
    function(targetSrc)
        local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
        carryactive = true
        ensureAnimDict(carry.personCarried.animDict)
        AttachEntityToEntity(
            PlayerPedId(),
            targetPed,
            0,
            0.27,
            0.15,
            0.63,
            0.5,
            0.5,
            180,
            false,
            false,
            false,
            false,
            2,
            false
        )
        types = "beingcarried"
    end
)
RegisterNetEvent("SevenLife:Medic:Cl_Stops")
AddEventHandler(
    "SevenLife:Medic:Cl_Stops",
    function()
        carryactive = false
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(PlayerPedId(), true, false)
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            if carryactive then
                if types == "beingcarried" then
                    if not IsEntityPlayingAnim(PlayerPedId(), "nm", "firemans_carry", 3) then
                        TaskPlayAnim(
                            PlayerPedId(),
                            "nm",
                            "firemans_carry",
                            8.0,
                            -8.0,
                            100000,
                            33,
                            0,
                            false,
                            false,
                            false
                        )
                    end
                elseif types == "carrying" then
                    if not IsEntityPlayingAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
                        TaskPlayAnim(
                            PlayerPedId(),
                            "missfinale_c2mcs_1",
                            "fin_c2_mcs_1_camman",
                            8.0,
                            -8.0,
                            100000,
                            49,
                            0,
                            false,
                            false,
                            false
                        )
                    end
                end
            else
                Citizen.Wait(500)
            end
        end
    end
)
RegisterNetEvent("SevenLife:Medic:medikamente")
AddEventHandler(
    "SevenLife:Medic:medikamente",
    function()
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        ESX.TriggerServerCallback(
            "SevenLife:Medic:GetItem",
            function(quantity)
                if quantity > 0 then
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Information",
                        "Pillen verabreicht. Person hat jetzt 5 min mehr zeit!",
                        2000
                    )

                    TriggerServerEvent("SevenLife:Medic:RemoveItem", "medikamente")
                    TriggerServerEvent("SevenLife:Medic:GiveMedikamente", GetPlayerServerId(closestPlayer))
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Du hast keine Medikamente", 2000)
                end
            end,
            "medikamente"
        )
    end
)
RegisterNetEvent("SevenLife:Medic:GiveMedikamenteClient")
AddEventHandler(
    "SevenLife:Medic:GiveMedikamenteClient",
    function()
        SetEntityHealth(PlayerPedId(), 100)
        ClearPedBloodDamage(PlayerPedId())
    end
)
RegisterNetEvent("SevenLife:Medic:rechnung")
AddEventHandler(
    "SevenLife:Medic:rechnung",
    function()
        Citizen.Wait(200)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "OpenRechnung"
            }
        )
    end
)
RegisterNUICallback(
    "Fehler",
    function()
        SetNuiFocus(false, false)
        TriggerEvent(
            "SevenLife:TimetCustom:Notify",
            "Mechaniker",
            "Fehler bei Rechnung austellen => Inputt muss eine Nummer sein",
            2000
        )
    end
)
RegisterNUICallback(
    "MakeRechnung",
    function(data)
        SetNuiFocus(false, false)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local player = ESX.Game.GetClosestPlayer(coords)
        TriggerServerEvent("SevenLife:Medic:MakeBill", GetPlayerServerId(player), data.titel, data.grund, data.hohe)
    end
)
