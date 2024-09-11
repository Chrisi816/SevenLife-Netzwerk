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
            Citizen.Wait(1000)
        end
        Showsblips()
    end
)
function Showsblips()
    local blips = AddBlipForCoord(Config.Position.x, Config.Position.y)
    SetBlipSprite(blips, 107)
    SetBlipDisplay(blips, 4)
    SetBlipScale(blips, 1.0)
    SetBlipColour(blips, 48)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Herausforderungen")
    EndTextCommandSetBlipName(blips)
    SetBlipAsShortRange(blips, true)
end
local random = math.random(1, 7)
local random1 = math.random(1, 6)
local random2 = math.random(1, 5)
local aufgabe1 = Config.Farmen[random]
local aufgabe2 = Config.Spendabel[random1]
local aufgabe3 = Config.Events[random2]

local pedloaded = false
local pedarea = false
local ped = GetHashKey("a_m_m_farmer_01")
Citizen.CreateThread(
    function()
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoord = GetEntityCoords(PlayerPed)
            Citizen.Wait(500)

            local distance =
                GetDistanceBetweenCoords(PlayerCoord, Config.Position.x, Config.Position.y, Config.Position.z, true)

            if distance < 30 then
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
                        Config.Position.x,
                        Config.Position.y,
                        Config.Position.z,
                        Config.Position.heading,
                        false,
                        true
                    )
                    SetEntityInvincible(ped1, true)
                    FreezeEntityPosition(ped1, true)
                    SetBlockingOfNonTemporaryEvents(ped1, true)
                    TaskPlayAnim(ped1, "missfbi_s4mop", "guard_idle_a", 8.0, 1, -1, 49, 0, false, false, false)
                    pedloaded = true
                end
            else
                if distance >= 30.1 and distance <= 50 then
                    pedarea = false
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

local notifys = true
local inmarker = false
local inmenu = false
local timemain = 100

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            local ped = GetPlayerPed(-1)
            local coord = GetEntityCoords(ped)

            local distance =
                GetDistanceBetweenCoords(coord, Config.Position.x, Config.Position.y, Config.Position.z, true)
            if distance < 15 then
                area = true
                timemain = 15
                if distance < 2 then
                    inmarker = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um mit dem Auftragsgeber zu sprechen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 2.1 and distance <= 3 then
                        inmarker = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                area = false
            end
        end
    end
)
Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        SetNuiFocus(true, true)
                        openmenu = true
                        ESX.TriggerServerCallback(
                            "SevenLife:SeasonPass:GetData",
                            function(result1, result2, result3)
                                SendNUIMessage(
                                    {
                                        type = "OpenMissionen",
                                        aufgabe1name = aufgabe1.name,
                                        aufgabe1detail = aufgabe1.desc,
                                        aufgabe2name = aufgabe2.name,
                                        aufgabe2detail = aufgabe2.desc,
                                        aufgabe3name = aufgabe3.name,
                                        aufgabe3detail = aufgabe3.desc,
                                        fertig1 = result1,
                                        fertig2 = result2,
                                        fertig3 = result3
                                    }
                                )
                            end,
                            random,
                            random1,
                            random2
                        )
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
RegisterNUICallback(
    "GetEarnings",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:SeasonPass:GetData2",
            function(result1)
                if result1 then
                    TriggerServerEvent("SevenLife:Phone:GiveCoins", 150)
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "MainMenu",
                        "Du musst noch alle Aufgaben erfüllen bevor du deine Belohnung abholen kannst!",
                        3000
                    )
                end
            end
        )
    end
)
RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
        inmenu = false
        notifys = true
    end
)
