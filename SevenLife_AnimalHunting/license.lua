ESX = nil
local ingaragerange = false
local notifys = true
local pedarea = false
local ped = GetHashKey("a_m_y_business_03")
local inmenu = false
local pedloaded = false
-- Core
Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(10)
        end

        AddLicenseBlipOnMap(
            SevenConfig.LicensesLocaiton.x,
            SevenConfig.LicensesLocaiton.y,
            SevenConfig.LicensesLocaiton.z
        )
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
                SevenConfig.LicensesLocaiton.x,
                SevenConfig.LicensesLocaiton.y,
                SevenConfig.LicensesLocaiton.z,
                true
            )

            if inmenu == false then
                if distance < 1.5 then
                    ingaragerange = true
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke E um den Jagd Shop zu öffnen",
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
                        SetNuiFocus(true, true)
                        inmenu = true
                        notifys = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        SendNUIMessage(
                            {
                                type = "OpenJagdShop"
                            }
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
                GetDistanceBetweenCoords(
                PlayerCoord,
                SevenConfig.LicensesLocaiton.x,
                SevenConfig.LicensesLocaiton.y,
                SevenConfig.LicensesLocaiton.z,
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
                        SevenConfig.LicensesLocaiton.x,
                        SevenConfig.LicensesLocaiton.y,
                        SevenConfig.LicensesLocaiton.z,
                        SevenConfig.LicensesLocaiton.heading,
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

function AddLicenseBlipOnMap(coordsx, coordsy, coordsz)
    local blips = vector3(coordsx, coordsy, coordsz)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 480)
    SetBlipColour(blip1, 48)
    SetBlipDisplay(blip1, 4)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Jagd Laden")
    EndTextCommandSetBlipName(blip1)
end

RegisterNUICallback(
    "escape",
    function()
        inmenu = false
        SetNuiFocus(false, false)
        notifys = true
    end
)

RegisterNUICallback(
    "kaufmesser",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:AnimalHunt:CheckEnoughMoney",
            function(enoughmoney)
                if enoughmoney then
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Tier", "Messer erfolgreich gekauft", 2000)
                    TriggerServerEvent("SevenLife:AnimalHunting:GiveMesser")
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Tier",
                        "Du hast zu wenig Geld um dieses Messer zu kaufen",
                        2000
                    )
                end
            end,
            1000
        )
    end
)

RegisterNUICallback(
    "lizenzen",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:AnimalHunt:CheckEnoughMoney",
            function(enoughmoney)
                if enoughmoney then
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Tier", "Du hast die Lizenz erfolgreich gekauft", 2000)
                    TriggerServerEvent("SevenLife:AnimalHunting:GiveLizenz")
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Tier",
                        "Du hast zu wenig Geld um eine Lizenz zu erwerben",
                        2000
                    )
                end
            end,
            1000
        )
    end
)
