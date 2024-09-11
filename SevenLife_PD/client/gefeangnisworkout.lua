function BlipGefeangnisWorkOut()
    local blips = vector3(1643.78, 2529.02, 45.56)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 311)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 9)
    SetBlipScale(blip1, 0.9)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Trainieren")
    EndTextCommandSetBlipName(blip1)
end
function BlipGefeangnisBasketball()
    local blips = vector3(1680.97, 2512.94, 44.56)
    local blip1 = AddBlipForCoord(blips)

    SetBlipSprite(blip1, 486)
    SetBlipColour(blip1, 59)
    SetBlipDisplay(blip1, 9)
    SetBlipScale(blip1, 0.9)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Basketball")
    EndTextCommandSetBlipName(blip1)
end

local notifys = true
local isNearExersices = false
local isAtExersice = false
local isInTraining = false
local pause = false
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(250)

            local coords = GetEntityCoords(GetPlayerPed(-1), false)

            for k, v in pairs(Config.WorkOut) do
                local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z)
                if distance < 20.0 then
                    isNearExersices = true
                else
                    isNearExersices = false
                    Citizen.Wait(1000)
                end
                if distance < 1 then
                    isAtExersice = true
                    currentExersice = v
                    if notifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Waffenschrank zu öffnen",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.1 and distance <= 4 then
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(6)
            if isNearExersices then
                if isAtExersice then
                    if IsControlJustPressed(0, 38) then
                        if not pause then
                            if not isInTraining then
                                isNearExersices = false
                                isInTraining = true
                                notifys = false
                                TriggerEvent("sevenliferp:closenotify", false)

                                if currentExersice.type == "chins" then
                                    SetEntityCoords(
                                        PlayerPedId(),
                                        currentExersice.fixedChinPos.x,
                                        currentExersice.fixedChinPos.y,
                                        currentExersice.fixedChinPos.z - 1
                                    )
                                    SetEntityHeading(PlayerPedId(), currentExersice.fixedChinPos.rot)
                                end

                                TaskStartScenarioInPlace(PlayerPedId(), currentExersice.scenario, 0, true)
                                Citizen.Wait(60000)
                                local number = math.random(1, 20)
                                if number <= 10 then
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "PD",
                                        "Du hast Erfolgreich dein Workout abgeschlossen",
                                        2000
                                    )
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "PD",
                                        "Du hast Erfolgreich dein Workout abgeschlossen. + 0.1 SkillBaum XP",
                                        2000
                                    )
                                end
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "PD",
                                    "Du musst dich für 30Sec ausruhen",
                                    2000
                                )

                                ClearPedTasksImmediately(PlayerPedId())
                                isInTraining = false
                                notifys = true
                                pause = true
                                isNearExersices = true
                                Citizen.CreateThread(
                                    function()
                                        Citizen.Wait(30000)
                                        pause = false
                                        TriggerEvent(
                                            "SevenLife:TimetCustom:Notify",
                                            "PD",
                                            "Du kannst wieder Trainieren",
                                            2000
                                        )
                                        TerminateThisThread()
                                    end
                                )
                            end
                        else
                            TriggerEvent("SevenLife:TimetCustom:Notify", "PD", "Du musst dich etwas ausruhen", 2000)
                        end
                    end
                end
            else
                Citizen.Wait(300)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)

            if isNearExersices then
                for k, v in pairs(Config.WorkOut) do
                    DrawMarker(20, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 234, 0, 122, 200, 1, 1, 0, 0)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
