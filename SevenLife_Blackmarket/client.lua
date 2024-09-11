isnotifyallowedthere = true
onlyonxe = true
Citizen.CreateThread(
    function()
        spawnsellernpcnormal()
    end

)

Citizen.CreateThread(
    function()
        isnotifyallowedthere = true
        onlyonxe = true
  local sleeping = true
        while true do
            Citizen.Wait(5)
            local npc =
                vector3(Config.blackmarketspawnnpc.x, Config.blackmarketspawnnpc.y, Config.blackmarketspawnnpc.z)
            local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vector3(npc.x, npc.y, npc.z))
            if isnotifyallowedthere then
                if distance < 1.0 then
sleeping = false
                    if isnotifyallowedthere then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Schwarzmarkt zu besichtigen",
                            "System-Nachricht",
                            true
                        )
                    end
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent(
                            "sevenlife:showblackmarketnui",
                            Config.erstewaffe,
                            Config.zweitewaffe,
                            Config.drittewaffe
                        )
                        isnotifyallowedthere = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                else
                    if distance >= 1.1 and distance <= 1.5 then
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                if isnotifyallowedthere == false and onlyonxe then
                    TriggerEvent("sevenliferp:closenotify", false)
                end
            end
            if sleeping then
                Citizen.Wait(200)
            end
        end
    end
)

function spawnsellernpcnormal()
    local pednumber = tonumber(1)
    for i = 1, pednumber do
        local NpcSpawner =
            vector3(Config.blackmarketspawnnpc.x, Config.blackmarketspawnnpc.y, Config.blackmarketspawnnpc.z)
        local ped = GetHashKey("a_m_y_soucent_02")
        if not HasModelLoaded(ped) then
            RequestModel(ped)
            while not HasModelLoaded(ped) do
                Citizen.Wait(1)
            end
            ped7 =
                CreatePed(
                4,
                ped,
                NpcSpawner.x,
                NpcSpawner.y,
                NpcSpawner.z,
                Config.blackmarketspawnnpc.heading,
                false,
                true
            )
            SetEntityInvincible(ped7, true)
            FreezeEntityPosition(ped7, true)
            SetBlockingOfNonTemporaryEvents(ped7, true)
        end
    end
end

function deleting(ped)
    DeletePed(ped)
end

AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        deleting(ped7)
    end
)

--- NUI MESSAGES
RegisterNetEvent("sevenlife:showblackmarketnui")
AddEventHandler(
    "sevenlife:showblackmarketnui",
    function(waffe1preis, waffe2preis, waffe3preis)
        SendNUIMessage(
            {
                type = "openschwarzmarkt",
                waffe1preis = waffe1preis,
                waffe2preis = waffe2preis,
                waffe3preis = waffe3preis
            }
        )
        SetNuiFocus(true, true)
    end
)
RegisterNetEvent("sevenlife:removeblackmarketnui")
AddEventHandler(
    "sevenlife:removeblackmarketnui",
    function()
        SendNUIMessage(
            {
                type = "removeschwarzmarkt"
            }
        )
        SetNuiFocus(false, false)
    end
)

