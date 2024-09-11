local timer = 500
local price = 10
Citizen.CreateThread(
    function()
        while true do
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)

            local closestTank = GetClosestObjectOfType(pedCoords, 5.0, -742198632, false)

            if DoesEntityExist(closestTank) then
                timer = 5

                local markerCoords = GetOffsetFromEntityInWorldCoords(closestTank, 0.0, -0.2, 1.0)
                local distanceCheck = GetDistanceBetweenCoords(pedCoords, markerCoords, true)

                if distanceCheck <= 1.0 then
                    local displayText = "~INPUT_PICKUP~ um ein Wasser für " .. price .. "$ zu kaufen?"

                    ESX.ShowHelpNotification(displayText)

                    if IsControlJustPressed(0, 38) then
                        ESX.TriggerServerCallback(
                            "SevenLife:Medic:CheckIfEnoughMoney",
                            function(valid)
                                if valid then
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Information",
                                        "Du hast dir ein Wasser gekauft!",
                                        2000
                                    )
                                    Drink()
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Information",
                                        "Du hast zu wenig Geld!",
                                        2000
                                    )
                                end
                            end,
                            price
                        )
                    end
                end
            end

            Citizen.Wait(timer)
        end
    end
)
function Drink()
    local timeStarted = GetGameTimer()
    RequestModel(GetHashKey("prop_ld_flow_bottle"))
    while not HasModelLoaded(GetHashKey("prop_ld_flow_bottle")) do
        Citizen.Wait(0)
    end

    local drinkEntity =
        CreateObject(GetHashKey("prop_ld_flow_bottle"), GetEntityCoords(PlayerPedId()), true, true, true)

    AttachEntityToEntity(
        drinkEntity,
        PlayerPedId(),
        GetPedBoneIndex(PlayerPedId(), 18905),
        0.12,
        0.028,
        0.018,
        -95.0,
        20.0,
        -40.0,
        true,
        true,
        false,
        true,
        1,
        true
    )

    while not HasAnimDictLoaded("mp_player_intdrink") do
        Citizen.Wait(0)
        RequestAnimDict("mp_player_intdrink")
    end

    Citizen.CreateThread(
        function()
            while GetGameTimer() - timeStarted < 4000 do
                Citizen.Wait(100)

                if not IsEntityPlayingAnim(PlayerPedId(), "mp_player_intdrink", "loop_bottle", 3) then
                    TaskPlayAnim(PlayerPedId(), "mp_player_intdrink", "loop_bottle", 1.0, -1.0, 2000, 49, 0, 0, 0, 0)
                end

                TriggerEvent("esx_status:add", "thirst", 1000)
            end

            DeleteEntity(drinkEntity)
        end
    )

    RemoveAnimDict("mp_player_intdrink")
    SetModelAsNoLongerNeeded(GetHashKey("prop_ld_flow_bottle"))
end
