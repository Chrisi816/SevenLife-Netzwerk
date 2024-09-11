local inmanagerange = false
local notifys = true
local inmenu = false
local pedloaded = false
local pedarea
local ped = GetHashKey("a_m_y_business_03")
-- Pharma Apotheke

Citizen.CreateThread(
    function()
        MakeBlips()
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)

            local distance =
                GetDistanceBetweenCoords(
                coords,
                Config.locations.makeancompany.regierung.x,
                Config.locations.makeancompany.regierung.y,
                Config.locations.makeancompany.regierung.z,
                true
            )

            if not IsPedInAnyVehicle(player, true) then
                if distance < 30 then
                    pedarea = true
                    if distance < 1.5 then
                        inmanagerange = true
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke E um die Regierungs Aktionen zu begutachten",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 1.6 and distance <= 6 then
                            inmanagerange = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    pedarea = false
                end
            else
                inmanagerange = false
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmanagerange then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        local name = GetPlayerName(-1)
                        TriggerEvent("sevenliferp:closenotify", false)
                        inmenu = true
                        notifys = false
                        SetNuiFocus(true, true)
                        TriggerEvent("sevenlife:openregierungsmenu", name)
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.locations.makeancompany.regierung.x,
                Config.locations.makeancompany.regierung.y,
                Config.locations.makeancompany.regierung.z,
                true
            )

            Citizen.Wait(1000)

            if distance < 40 then
                if not pedloaded then
                    RequestModel(ped)
                    while not HasModelLoaded(ped) do
                        Citizen.Wait(1)
                    end
                    ped1 =
                        CreatePed(
                        4,
                        ped,
                        Config.locations.makeancompany.regierung.x,
                        Config.locations.makeancompany.regierung.y,
                        Config.locations.makeancompany.regierung.z,
                        Config.locations.makeancompany.regierung.heading,
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

function MakeBlips()
    local blips =
        vector3(
        Config.locations.makeancompany.regierung.x,
        Config.locations.makeancompany.regierung.y,
        Config.locations.makeancompany.regierung.z
    )
    local blip = AddBlipForCoord(blips.x, blips.y, blips.z)
    SetBlipSprite(blip, 358)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Regierung")
    EndTextCommandSetBlipName(blip)
end

-- Checking for Name

tables = {}

RegisterNUICallback(
    "name",
    function(data)
        table.insert(tables, {unternehmen = data.unternehmen})
        TriggerServerEvent("sevenlife:neuesunternehmen", data.unternehmensname)
    end
)
RegisterNUICallback(
    "rause",
    function()
        inmenu = false
        TriggerEvent("sevenlife:closeregierungsmenu")
        notifys = true
        openshop = false
    end
)

RegisterNetEvent("SevenLife:Regierung:Close")
AddEventHandler(
    "SevenLife:Regierung:Close",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
        SendNUIMessage(
            {
                type = "removeregierungsmenu"
            }
        )
    end
)
AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        DeleteNpc()
    end
)

function DeleteNpc()
    DeleteEntity(ped9)
    DeleteEntity(ped1)
    DeleteEntity(ped10)
end

RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
        SendNUIMessage(
            {
                type = "removeregierungsmenu"
            }
        )
    end
)
