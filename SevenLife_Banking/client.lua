local isinmarker, isinatmmarker, menuisopen = false, false, false

if Config.blips then
    Citizen.CreateThread(
        function()
            showblips()
            BLipsMainBank()
        end
    )
end

function playAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end

function showblips()
    for _, Atmblips in pairs(Config.AtmLocations) do
        Atmblips.blip = AddBlipForCoord(Atmblips.x, Atmblips.y, Atmblips.z)
        SetBlipSprite(Atmblips.blip, Config.sprite)
        SetBlipDisplay(Atmblips.blip, Config.displayid)
        SetBlipScale(Atmblips.blip, Config.scale)
        SetBlipColour(Atmblips.blip, Config.Blipcolour)
        SetBlipAsShortRange(Atmblips.blip, Config.short)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("ATM")
        EndTextCommandSetBlipName(Atmblips.blip)
    end
end

function BLipsMainBank()
    local blip = AddBlipForCoord(Config.MainBank.x, Config.MainBank.y, Config.MainBank.z)
    SetBlipSprite(blip, 293)
    SetBlipDisplay(blip, 3)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 52)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Staatsbank")
    EndTextCommandSetBlipName(blip)
end

local globalsleep = true

Citizen.CreateThread(
    function()
        allownotifys = true
        sleep = true
        while true do
            local player = PlayerPedId()
            local coords = GetEntityCoords(player)

            Citizen.Wait(5)
            for i, v in pairs(Config.AtmLocations) do
                if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.5 then
                    isinatmmarker, sleep = true, false
                else
                    if
                        GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) >= 1.5 and
                            GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) <= 4
                     then
                        TriggerEvent("sevenliferp:closenotify", false)
                        isinatmmarker, sleep = false, true
                    end
                end
                distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
            end
            if isinatmmarker then
                if allownotifys then
                    TriggerEvent(
                        "sevenliferp:startnui",
                        "Drücke <span1 color = white>E</span1> um das Bankmenü zu öffnen",
                        "System - Nachricht",
                        true
                    )
                end
                sleep = false
                if IsControlJustReleased(0, 38) then
                    if isinatmmarker then
                        if distance then
                            allownotifys = false
                            TriggerEvent("sevenliferp:closenotify", false)
                            TriggerServerEvent("sevenlife:checkstatuszwei")
                            menuisopen = true
                        end
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        allowednotify = true
        while true do
            Citizen.Wait(1)
            local player = PlayerPedId()
            local coords = GetEntityCoords(player)
            for i, v in pairs(Config.mainbank) do
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z, true) < 10.0) then
                    DrawMarker(20, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 234, 0, 122, 200, 1, 1, 0, 0)
                end
                if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 0.5 then
                    isinatmmarkers, sleep = true, false
                else
                    if
                        GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) >= 0.5 and
                            GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) <= 1.5
                     then
                        TriggerEvent("sevenliferp:closenotify", false)
                        isinatmmarkers, sleep = false, true
                    end
                end
            end
            if isinatmmarkers then
                if allowednotify then
                    TriggerEvent(
                        "sevenliferp:startnui",
                        "Drücke <span1 color = white>E</span1> um das Bankmenü zu öffnen",
                        "System - Nachricht",
                        true
                    )
                else
                    if allowednotify == false then
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("sevenlife:checkstatus")
                    allowednotify = false
                end
            end
        end
    end
)
RegisterNUICallback(
    "ausslogen",
    function()
        allowednotify = true
        TriggerEvent("sevenlife:removemainbankmenu")
    end
)
RegisterNetEvent("sevenlife:transferdata")
AddEventHandler(
    "sevenlife:transferdata",
    function(cash, kredit)
        playAnim("mp_common", "givetake1_a", 2500)
        Citizen.Wait(2500)
        local playername = GetPlayerName(-1)
        TriggerEvent("sevenlife:openmainbankmenu", "yes", playername, cash, Config.Inflation, kredit)
    end
)
RegisterNUICallback(
    "boxensezehnauszahlen",
    function()
        TriggerServerEvent("sevenlife:gibgeld", 10)
        TriggerEvent("sevenlife:removemainbankmenu")
        allowednotify = true
    end
)
RegisterNUICallback(
    "boxensehundertauszahlen",
    function()
        TriggerServerEvent("sevenlife:gibgeld", 100)
        TriggerEvent("sevenlife:removemainbankmenu")
        allowednotify = true
    end
)
RegisterNUICallback(
    "boxensefuenfhundertauszahlen",
    function()
        TriggerServerEvent("sevenlife:gibgeld", 500)
        TriggerEvent("sevenlife:removemainbankmenu")
        allowednotify = true
    end
)
RegisterNUICallback(
    "boxensetausendauszahlen",
    function()
        TriggerServerEvent("sevenlife:gibgeld", 1000)
        TriggerEvent("sevenlife:removemainbankmenu")
        allowednotify = true
    end
)
-----------------------------------------------------------------------------------------------------
--                                     Auszahlen Benutzerdefiniert
-----------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "auszahlenbenutzerdefiniert",
    function(data)
        TriggerServerEvent("sevenlife:gibgeld", data.cashauszahlen)
        TriggerEvent("sevenlife:removemainbankmenu")
        allowednotify = true
    end
)
-----------------------------------------------------------------------------------------------------
--                                        Einzahlen Calls
-----------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "boxensezehneinzahlen",
    function()
        TriggerServerEvent("sevenlife:nehmgeld", 10)
        TriggerEvent("sevenlife:removemainbankmenu")
        allowednotify = true
    end
)
RegisterNUICallback(
    "boxensehunderteinzahlen",
    function()
        TriggerServerEvent("sevenlife:nehmgeld", 100)
        TriggerEvent("sevenlife:removemainbankmenu")
        allowednotify = true
    end
)
RegisterNUICallback(
    "boxensefünfhunderteinzahlen",
    function()
        TriggerServerEvent("sevenlife:nehmgeld", 500)
        TriggerEvent("sevenlife:removemainbankmenu")
        allowednotify = true
    end
)
RegisterNUICallback(
    "boxensetausendeinzahlen",
    function()
        TriggerServerEvent("sevenlife:nehmgeld", 1000)
        TriggerEvent("sevenlife:removemainbankmenu")
        allowednotify = true
    end
)
-----------------------------------------------------------------------------------------------------
--                                     Einzahlen Benutzerdefiniert
-----------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "einzahlenbenutzerdefiniert",
    function(data)
        TriggerServerEvent("sevenlife:nehmgeld", data.casheinzahlen)
        TriggerEvent("sevenlife:removemainbankmenu")
        allowednotify = true
    end
)
-----------------------------------------------------------------------------------------------------
--                                     Accept Callback
-----------------------------------------------------------------------------------------------------

RegisterNUICallback(
    "acceptit",
    function(data)
        TriggerServerEvent("sevenlife:accepteddata", data.vorname, data.nachname, data.geburtsort)
        TriggerServerEvent("sevenlife:registerIban")
    end
)

-----------------------------------------------------------------------------------------------------
--                                     Callbacks
-----------------------------------------------------------------------------------------------------
RegisterNUICallback(
    "auszahlennnormalebank",
    function(data)
        allownotifys = true
        TriggerServerEvent("sevenlife:gibgeld", data.cashauszahlen)
        TriggerEvent("sevenlife:closeall")
        playAnim("mp_common", "givetake1_a", 2500)
    end
)
RegisterNUICallback(
    "einzahlennnormalebank",
    function(data)
        allownotifys = true
        TriggerServerEvent("sevenlife:nehmgeld", data.casheinzahlen)
        TriggerEvent("sevenlife:closeall")
        playAnim("mp_common", "givetake1_a", 2500)
    end
)

RegisterNetEvent("sevenlife:showdontaccount")
AddEventHandler(
    "sevenlife:showdontaccount",
    function()
        local notify = true
        while notify do
            Citizen.Wait(1)
            TriggerEvent("sevenliferp:closenotify", false)
            Citizen.Wait(100)
            TriggerEvent("sevenliferp:startnui", "Du besitzt kein Bankkonto", "System - Nachricht", true)
            Citizen.Wait(3000)
            TriggerEvent("sevenliferp:closenotify", false)
            allownotifys = true
            notify = false
        end
    end
)
RegisterNUICallback(
    "ueberweisen",
    function(data)
        TriggerServerEvent("sevenlife:nehmgelds", data.casheinzahlen)
        TriggerEvent("sevenlife:removemainbankmenu")
        allowednotify = true
    end
)
