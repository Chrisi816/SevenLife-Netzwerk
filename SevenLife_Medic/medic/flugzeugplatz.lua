-- RegisterAll
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
            Citizen.Wait(0)
        end
    end
)
version = 1
local NumberCharset = {}
local Charset = {}
local ingaragerange = false
local notifys = true
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
local inmenu = false
local list = {}
lcn = false
local pedloaded = false
for i = 48, 57 do
    table.insert(NumberCharset, string.char(i))
end

for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

Carlist = {
    {
        name = "Buzzard",
        lable = "buzzard2",
        Costs = 20000
    },
    {
        name = "Seasparrow",
        lable = "seasparrow",
        Costs = 20000
    }
}

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(
                coords,
                Config.Hospital.FlugzeugNPC.x,
                Config.Hospital.FlugzeugNPC.y,
                Config.Hospital.FlugzeugNPC.z,
                true
            )

            if inmenu == false then
                if distance < 1.5 then
                    ingaragerange = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um die Garage anzusehen",
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
                        version = 2
                        for i, k in pairs(Carlist) do
                            table.insert(list, Carlist[i])
                        end
                        inmenu = true

                        notifys = false
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenGarageMedic",
                                list = list
                            }
                        )
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
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            local distance =
                GetDistanceBetweenCoords(
                PlayerCoord,
                Config.Hospital.FlugzeugNPC.x,
                Config.Hospital.FlugzeugNPC.y,
                Config.Hospital.FlugzeugNPC.z,
                true
            )

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
                        Config.Hospital.FlugzeugNPC.x,
                        Config.Hospital.FlugzeugNPC.y,
                        Config.Hospital.FlugzeugNPC.z,
                        Config.Hospital.FlugzeugNPC.heading,
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
    "CloseMenuFlugzeug",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        list = {}
        inmenudialog = false
        notifys = true
        ingaragerange = false
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance =
                GetDistanceBetweenCoords(
                coords,
                Config.Hospital.FlugzeugSpawner.x,
                Config.Hospital.FlugzeugSpawner.y,
                Config.Hospital.FlugzeugSpawner.z,
                true
            )

            if IsPedInAnyVehicle(player, true) then
                if distance < 40 then
                    outarea = true
                    if distance < 7 then
                        ingarageparkrange = true

                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um das Fahrzeug einzulagern",
                            "System - Nachricht",
                            true
                        )
                    else
                        if distance >= 7.1 and distance <= 10 then
                            ingarageparkrange = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    outarea = false
                end
            else
                ingarageparkrange = false
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(mistime)
            if outarea then
                mistime = 1
                DrawMarker(
                    1,
                    Config.Hospital.FlugzeugSpawner.x,
                    Config.Hospital.FlugzeugSpawner.y,
                    Config.Hospital.FlugzeugSpawner.z,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    vector3(3.0, 3.0, 1.1),
                    143,
                    0,
                    71,
                    100,
                    false,
                    true,
                    2,
                    false,
                    nil,
                    nil,
                    false
                )
            else
                mistime = 1000
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if ingarageparkrange then
                if IsControlJustPressed(0, 38) then
                    if indienst then
                        TriggerEvent("sevenliferp:closenotify", false)
                        local vehiclese = ESX.Game.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(-1)), 7.0)
                        for k, v in pairs(vehiclese) do
                            local fuel = exports["SevenLife_Fuel"]:GetFuelLevel(v)
                            TriggerServerEvent(
                                "sevenlife:savecartile",
                                GetVehicleNumberPlateText(v),
                                ESX.Game.GetVehicleProperties(v)
                            )
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Success", "Auto erfolgreich eingeparkt", 3000)
                            TriggerServerEvent("sevenlife:changemode", GetVehicleNumberPlateText(v), true)
                            ESX.Game.DeleteVehicle(v)
                        end
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Du bist nicht im Dienst", 2000)
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
