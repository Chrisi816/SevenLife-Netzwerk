local timess = 100
local inmarkerss = false
local notifysss = true
local pedloaded = false
local pedarea = false
local inmenu = false
local ped = GetHashKey("a_m_m_mexlabor_01")

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            Ped = PlayerPedId()
            Coords = GetEntityCoords(Ped)
            Citizen.Wait(timess)
            local distance =
                GetDistanceBetweenCoords(
                Coords,
                Config.Hospital.GoIntoDiens.x,
                Config.Hospital.GoIntoDiens.y,
                Config.Hospital.GoIntoDiens.z,
                true
            )
            if distance < 10 then
                timess = 25
                if distance < 1.2 then
                    timess = 5
                    inmarkerss = true
                    if notifysss then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um Dienst Aktionen zu finden",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.3 and distance <= 5 then
                        inmarkerss = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            else
                if distance >= 8 and distance <= 12 then
                    timess = 100
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(5)
            if inmarkerss then
                if IsControlJustPressed(0, 38) then
                    if not inmenu then
                        inmenu = true
                        notifysss = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        SetNuiFocus(true, true)

                        SendNUIMessage(
                            {
                                type = "OpenInteraktionsMenu"
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
                Config.Hospital.GoIntoDiens.x,
                Config.Hospital.GoIntoDiens.y,
                Config.Hospital.GoIntoDiens.z,
                true
            )

            Citizen.Wait(500)

            if distance < 50 then
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
                        Config.Hospital.GoIntoDiens.x,
                        Config.Hospital.GoIntoDiens.y,
                        Config.Hospital.GoIntoDiens.z,
                        Config.Hospital.GoIntoDiens.heading,
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
                if distance >= 50.1 and distance <= 100 then
                    pedarea = false
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
RegisterNUICallback(
    "CloseMenugoinside",
    function()
        SetNuiFocus(false, false)
        notifysss = true
        inmenu = false
    end
)
RegisterNUICallback(
    "ChangeStatus",
    function()
        SetNuiFocus(false, false)
        notifysss = true
        inmenu = false
        if indienst then
            TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Du bist jetzt ausserhalb des Dienstes!", 2000)
            indienst = false
        elseif not indienst then
            TriggerEvent("SevenLife:TimetCustom:Notify", "Information", "Du bist jetzt im Dienst!", 2000)
            indienst = true
        end
    end
)
