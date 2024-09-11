ESX = nil

local ingaragerange = false
local notifys = true
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
local inmenu = false
local pedloaded = false

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
        CreateBlipse(Config.Player.x, Config.Player.y, Config.Player.z, "Auktionshaus", 369, 61)
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance = GetDistanceBetweenCoords(coords, Config.Player.x, Config.Player.y, Config.Player.z, true)

            if inmenu == false then
                if distance < 1.5 then
                    ingaragerange = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um das Auktionshaus zu öffnen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.6 and distance <= 4 then
                        ingaragerange = false
                        TriggerEvent("sevenliferp:closenotify", false)
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
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if ingaragerange then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        ESX.TriggerServerCallback(
                            "SevenLife:Auktion:GetActiveAuktionen",
                            function(result)
                                inmenu = true
                                notifys = false
                                SetNuiFocus(true, true)
                                TriggerEvent("sevenliferp:closenotify", false)
                                SendNUIMessage(
                                    {
                                        type = "OpenAuktion",
                                        result = result
                                    }
                                )
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

Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance =
                GetDistanceBetweenCoords(PlayerCoord, Config.Player.x, Config.Player.y, Config.Player.z, true)

            Citizen.Wait(1000)
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
                        Config.Player.x,
                        Config.Player.y,
                        Config.Player.z,
                        Config.Player.heading,
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
                SetModelAsNoLongerNeeded(ped)
                pedloaded = false
            end
        end
    end
)
RegisterNUICallback(
    "Escape",
    function()
        SetNuiFocus(false, false)

        inmenu = false
        ingaragerange = false
        notifys = true
    end
)
function CreateBlipse(x, y, z, name, sprite, colour)
    local blip = AddBlipForCoord(vector3(x, y, z))
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end
RegisterNUICallback(
    "GetCars",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:AuktionsHaus:GetCars",
            function(result)
                for _, v in pairs(result) do
                    local hash = v.vehicle.model
                    local vehname = GetDisplayNameFromVehicleModel(hash)
                    local labelname = GetLabelText(vehname)
                    local plate = v.plate
                    local vehicleid = v.vehicleid
                    SendNUIMessage(
                        {
                            type = "UpdateCars",
                            model = labelname,
                            plate = plate,
                            vehicleid = vehicleid
                        }
                    )
                end
            end
        )
    end
)
RegisterNUICallback(
    "GetBoote",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:AuktionsHaus:GetBoote",
            function(result)
                for _, v in pairs(result) do
                    local hash = v.vehicle.model
                    local vehname = GetDisplayNameFromVehicleModel(hash)
                    local labelname = GetLabelText(vehname)
                    local plate = v.plate
                    SendNUIMessage(
                        {
                            type = "UpdateCars",
                            model = labelname,
                            plate = plate
                        }
                    )
                end
            end
        )
    end
)
RegisterNUICallback(
    "GetFlugzeuge",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:AuktionsHaus:GetFlugzeuge",
            function(result)
                for _, v in pairs(result) do
                    local hash = v.vehicle.model
                    local vehname = GetDisplayNameFromVehicleModel(hash)
                    local labelname = GetLabelText(vehname)
                    local plate = v.plate
                    SendNUIMessage(
                        {
                            type = "UpdateCars",
                            model = labelname,
                            plate = plate
                        }
                    )
                end
            end
        )
    end
)
RegisterNUICallback(
    "MakeAuktion",
    function(data)
        local labelcar
        if data.type == "cars" then
            ESX.TriggerServerCallback(
                "SevenLife:Auktion:GetPlateVeh",
                function(result)
                    local hash = result.model
                    local vehname = GetDisplayNameFromVehicleModel(hash)
                    labelcar = GetLabelText(vehname)
                end,
                data.plate
            )
        end
        Citizen.Wait(500)
        TriggerServerEvent(
            "SevenLife:Auktion:MakeAuktion",
            data.choice,
            data.zeit,
            data.preis,
            data.type,
            data.plate,
            data.count,
            labelcar,
            data.vehicleid,
            data.label
        )
    end
)
RegisterNUICallback(
    "GetItems",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Auktion:GetInventory",
            function(result)
                local itemse = {}
                for key, value in pairs(result) do
                    print(result[key])
                    if result[key].count <= 0 then
                        result[key] = nil
                    else
                        result[key].type = "item_standard"
                        table.insert(itemse, result[key])
                    end
                end
                SendNUIMessage(
                    {
                        type = "UpdateItems",
                        items = itemse
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "GetShops",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Auktion:GetShops",
            function(result)
                SendNUIMessage(
                    {
                        type = "MakeShops",
                        items = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "GetTanke",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Auktion:GetTanke",
            function(result)
                SendNUIMessage(
                    {
                        type = "MakeTankstellen",
                        items = result
                    }
                )
            end
        )
    end
)
RegisterNetEvent("SevenLife:Auktion:Update")
AddEventHandler(
    "SevenLife:Auktion:Update",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Auktion:GetActiveAuktionen",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateAktion",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "SofortKauf",
    function(data)
        TriggerServerEvent("SevenLife:Auktion:MakeBuyingValide", data.id, data.count, data.label, data.preis)
    end
)
RegisterNUICallback(
    "BieteMit",
    function(data)
        TriggerServerEvent("SevenLife:Auktion:MitBieten", data.id, data.count, data.label, data.preis)
    end
)
RegisterNetEvent("SevenLife:Auktion:UpdateAll")
AddEventHandler(
    "SevenLife:Auktion:UpdateAll",
    function()
    end
)
RegisterNUICallback(
    "GetAngebote",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Auktionen:GetAngebote",
            function(deineangebote, deinegebote)
                SendNUIMessage(
                    {
                        type = "UpdateGebote",
                        deineangebote = deineangebote,
                        deinegebote = deinegebote
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "SofortKauf2",
    function(data)
        TriggerServerEvent("SevenLife:Auktion:MakeBuyingValide2", data.id, data.count, data.label, data.preis)
    end
)
RegisterNetEvent("SevenLife:Auktion:UpdateSeeAll")
AddEventHandler(
    "SevenLife:Auktion:UpdateSeeAll",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Auktionen:GetAngebote",
            function(deineangebote, deinegebote)
                SendNUIMessage(
                    {
                        type = "UpdateGebote2",
                        deineangebote = deineangebote,
                        deinegebote = deinegebote
                    }
                )
            end
        )
    end
)
