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
        CreateBlipse(Config.Place.x, Config.Place.y, Config.Place.z, "Informations Punkt", 407, 48)
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance = GetDistanceBetweenCoords(coords, Config.Place.x, Config.Place.y, Config.Place.z, true)

            if inmenu == false then
                if distance < 6.5 then
                    ingaragerange = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um die Informations Tafel zu öffnen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 6.6 and distance <= 8.5 then
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
                            "SevenLife:BlackBoard:GetActiveLetters",
                            function(result)
                                inmenu = true
                                notifys = false
                                SetNuiFocus(true, true)
                                TriggerEvent("sevenliferp:closenotify", false)
                                SendNUIMessage(
                                    {
                                        type = "OpenTafel",
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
function CreateBlipse(x, y, z, name, sprite, colour)
    local blip = AddBlipForCoord(vector3(x, y, z))
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 5)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end
RegisterNUICallback(
    "Escape",
    function()
        SetNuiFocus(false, false)
        ingaragerange = false
        notifys = true
        inmenu = false
    end
)
RegisterNUICallback(
    "OpenEditor",
    function()
        SendNUIMessage(
            {
                type = "OpenAuswahlMenu"
            }
        )
    end
)
local dataid
RegisterNUICallback(
    "OpenEditorBoard",
    function(data)
        dataid = data.id
        if data.id == 1 then
            SendNUIMessage(
                {
                    type = "OpenNormalMenu"
                }
            )
        else
            SendNUIMessage(
                {
                    type = "OpenImgMenu"
                }
            )
        end
    end
)
RegisterNUICallback(
    "Finish",
    function(data)
        SetNuiFocus(false, false)
        ingaragerange = false
        notifys = true
        inmenu = false
        TriggerServerEvent("SevenLife:BlackBoard:Finisch", dataid, data.beschreibung, data.titel)
    end
)
RegisterNUICallback(
    "Finish2",
    function(data)
        SetNuiFocus(false, false)
        ingaragerange = false
        notifys = true
        inmenu = false
        TriggerServerEvent("SevenLife:BlackBoard:Finisch2", dataid, data.src)
    end
)
