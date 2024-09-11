ESX = nil
local identifiers

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

RegisterNUICallback(
    "Uebergeben",
    function(data)
        SetNuiFocus(false, false)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer(coords)
        TriggerServerEvent(
            "SevenLife:Vertrag:VertragÜbergeben",
            GetPlayerServerId(closestPlayer),
            data.unterschrift,
            data.beschreibung,
            data.titel
        )
    end
)
RegisterNetEvent("SevenLife:Vertrag:VertragGeben")
AddEventHandler(
    "SevenLife:Vertrag:VertragGeben",
    function(unterschrift, beschreibung, titel, identifier)
        identifiers = identifier
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "Übergeber",
                unterschrift = unterschrift,
                beschreibung = beschreibung,
                titel = titel
            }
        )
    end
)
RegisterNUICallback(
    "Finish",
    function(data)
        SetNuiFocus(false, false)
        TriggerServerEvent(
            "SevenLife:Vertrag:InsertIntoDb",
            data.unterschrift,
            data.beschreibung,
            data.titel,
            data.unterschrift2,
            identifiers
        )
    end
)
RegisterNetEvent("SevenLife:Vertrag:MakeVertrag")
AddEventHandler(
    "SevenLife:Vertrag:MakeVertrag",
    function()
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer(coords)
        if closestPlayer ~= nil then
            SetNuiFocus(true, true)

            SendNUIMessage(
                {
                    type = "OpenVertragsMenu"
                }
            )
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Vertrag", "Kein Spieler in der Nähe", 1500)
        end
    end
)
RegisterNUICallback(
    "escape",
    function()
        SetNuiFocus(false, false)
    end
)

-- Aktenkoffer
RegisterNetEvent("SevenLife:Vertrag:OpenVertragsTasche")
AddEventHandler(
    "SevenLife:Vertrag:OpenVertragsTasche",
    function(result)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "OpenAktenKoffer",
                result = result
            }
        )
    end
)
RegisterNUICallback(
    "OpenAkte",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:OpenAkteInformationen",
            function(result)
                SetNuiFocus(true, true)
                SendNUIMessage(
                    {
                        type = "OpenAkte",
                        titel = result[1].titel,
                        beschreibung = result[1].beschreibung,
                        unterschrift = result[1].unterschrift,
                        unterschrift2 = result[1].unterschrift2
                    }
                )
            end,
            data.id
        )
    end
)
RegisterNUICallback(
    "GiveAkte",
    function(data)
        SetNuiFocus(false, false)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer(coords)
        if closestPlayer ~= nil then
            TriggerServerEvent("SevenLife:Vertrag:GiveVertrag", GetPlayerServerId(closestPlayer), data.id)
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Vertrag", "Kein Spieler in der Nähe", 1500)
        end
    end
)
RegisterNetEvent("SevenLife:Vertrag:GiverVertagy")
AddEventHandler(
    "SevenLife:Vertrag:GiverVertagy",
    function(result)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "OpenAkte",
                titel = result[1].titel,
                beschreibung = result[1].beschreibung,
                unterschrift = result[1].unterschrift,
                unterschrift2 = result[1].unterschrift2
            }
        )
    end
)
