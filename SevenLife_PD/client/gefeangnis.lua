--Var
local inhaft = false
local hafttime = 0 -- Min

-- Blips

function BlipGefeangnis(coordsx, coordsy, coordsz)
    local blips = vector3(coordsx, coordsy, coordsz)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 188)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 4)
    SetBlipScale(blip1, 1.4)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Gefängnis")
    EndTextCommandSetBlipName(blip1)
end

function BlipSperrzone(coordsx, coordsy, coordsz)
    local blips = vector3(coordsx, coordsy, coordsz)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 310)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 4)
    SetBlipScale(blip1, 1.2)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Sperrzone")
    EndTextCommandSetBlipName(blip1)
end

function BlipEinknassten()
    local blips = vector3(1690.63, 2591.05, 45.91)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 186)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 9)
    SetBlipScale(blip1, 1.1)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Einknasten")
    EndTextCommandSetBlipName(blip1)
end

RegisterNetEvent("SevenLife:PD:SetPlayerIntoPrison")
AddEventHandler(
    "SevenLife:PD:SetPlayerIntoPrison",
    function()
        SetNuiFocus(false, false)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(coords, 1690.63, 2591.05, 45.91, true)
        if distance < 3 then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer ~= nil then
                SetNuiFocus(true, true)
                SendNUIMessage(
                    {
                        type = "OpenMenuHowManyMinutes"
                    }
                )
            else
                TriggerEvent("SevenLife:TimetCustom:Notify", "Polizei", "Kein Spieler in der nähe", 3000)
            end
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "PD", "Du kannst die Person hier nicht einknassten", 2000)
        end
    end
)

RegisterNUICallback(
    "PutPlayerInJail",
    function(data)
        SetNuiFocus(false, false)
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        TriggerServerEvent("SevenLife:PD:PutPlayerInJail", GetPlayerServerId(closestPlayer), data.haftzeit)
    end
)

RegisterNetEvent("SevenLife:PD:ArrestPlayer")
AddEventHandler(
    "SevenLife:PD:ArrestPlayer",
    function(haftzeit)
        time = haftzeit * 60000
        inhaft = true
        local ped = GetPlayerPed(-1)
        SetEntityCoords(ped, Config.GoOutside.x, Config.GoOutside.y, Config.GoOutside.z, false, false, false, true)
        TriggerEvent("SevenLife:PD:StartCounter", haftzeit)
        TriggerEvent("SevenLife:PD:CheckIfAusbruch")
        TriggerEvent("SevenLife:TimetCustom:Notify", "PD", "Du hast noch eine Haftzeit von " .. haftzeit, 2000)
    end
)

RegisterNetEvent("SevenLife:PD:StartCounter")
AddEventHandler(
    "SevenLife:PD:StartCounter",
    function()
        BlipSperrzone(1712.56, 2612.06, 45.56)
        Citizen.CreateThread(
            function()
                if inhaft then
                    while time > 0 do
                        Citizen.Wait(60000)
                        time = time - 60000
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "PD",
                            "Du hast noch eine Haftzeit von " .. time,
                            2000
                        )
                        if time == 0 then
                            local ped = GetPlayerPed(-1)
                            SetEntityCoords(ped, Config.UnJail.x, Config.UnJail.y, Config.UnJail.z)
                            inhaft = false
                            time = 0
                            TriggerServerEvent("SevenLife:Gefeandnigs:DeletePlayer")
                        end
                    end
                end
            end
        )
    end
)

RegisterNetEvent("SevenLife:PD:CheckIfAusbruch")
AddEventHandler(
    "SevenLife:PD:CheckIfAusbruch",
    function()
        Citizen.CreateThread(
            function()
                while inhaft do
                    Citizen.Wai(5000)
                    local ped = GetPlayerPed(-1)
                    local coords = GetEntityCoords(ped)
                    local distance = GetDistanceBetweenCoords(coords, 1690.63, 2591.05, 45.91, false)
                    if distance > 300 then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Information",
                            "Erfolgreich ausgebrochen",
                            2000
                        )

                        TriggerEvent(
                            "SevenLife:Phone:InsertDispatchDB",
                            "LSPD",
                            "Gefängnis",
                            "Person ist aus dem Staatsgefängnis ausgebrochen, und versucht momentan zu flüchten!",
                            coords
                        )
                        -- TODO Notify For Police Officers
                        inhaft = false
                        TerminateThisThread()
                    end
                end
            end
        )
    end
)

-- Check By Spawning If Player is in Jail
RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        ESX.TriggerServerCallback(
            "SevenLife:PD:CheckIfPlayerWasInJail",
            function(wasplayerinjail, haftzeit, besucher)
                if wasplayerinjail then
                    if besucher == "true" then
                        TriggerServerEvent("SevenLife:Gefeangnis:KickOutOfGefeangnis")
                        SetEntityCoords(PlayerPedId(), Config.GoInside.x, Config.GoInside.y, Config.GoInside.z)
                        TriggerEvent("SevenLife:Inventory:AnableInventory")
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Gefeangnis",
                            "Nach deinem Besuch wurdest du wegen dem neu Joinen aus dem Gefägnis rausgeworfen",
                            2000
                        )
                    else
                        time = haftzeit * 60000
                        inhaft = true
                        TriggerEvent("SevenLife:PD:StartCounter", haftzeit)
                        TriggerEvent("SevenLife:PD:CheckIfAusbruch")
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "PD",
                            "Du hast noch eine Haftzeit von " .. haftzeit,
                            2000
                        )
                    end
                end
            end
        )
    end
)
RegisterNetEvent("SevenLife:Police:GetCurrentJailTime")
AddEventHandler(
    "SevenLife:Police:GetCurrentJailTime",
    function()
        if inhaft then
            ESX.TriggerServerCallback(
                "SevenLife:PD:CheckIfPlayerWasInJail",
                function(wasplayerinjail, haftzeit, besucher)
                    if wasplayerinjail then
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "PD",
                            "Du hast noch eine Haftzeit von " .. haftzeit,
                            2000
                        )
                    end
                end
            )
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "PD", "Du bist nicht im Gefängnis", 2000)
        end
    end
)
