local Whisper = false
local Normal = true
local Shouting = false
local isTalking = false
local CurrentDistance = Config.NormalDistance
local active = false

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(7)

            if IsControlJustPressed(0, 182) then
                if Whisper then
                    CurrentDistance = Config.NormalDistance
                    Whisper = false
                    Normal = true
                    Shouting = false
                elseif Normal then
                    CurrentDistance = Config.ShoutingDistance
                    Whisper = false
                    Normal = false
                    Shouting = true
                elseif Shouting then
                    CurrentDistance = Config.WhisperDistance
                    Whisper = true
                    Normal = false
                    Shouting = false
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(7)
            if IsControlJustPressed(0, 182) then
                active = true
                Citizen.CreateThread(
                    function()
                        while active do
                            Citizen.Wait(1)
                            local pedCoords = GetEntityCoords(PlayerPedId())
                            DrawMarker(
                                1,
                                pedCoords.x,
                                pedCoords.y,
                                pedCoords.z - 1,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                25.0,
                                CurrentDistance * 2.5,
                                CurrentDistance * 2.5,
                                6.0,
                                221,
                                77,
                                119,
                                150,
                                false,
                                false,
                                2,
                                false,
                                nil,
                                nil,
                                false
                            )
                        end
                    end
                )

                Citizen.Wait(1500)
                active = false
            end
        end
    end
)

-- Check if player is speaking
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(50)

            if isTalking == false then
                if NetworkIsPlayerTalking(PlayerId()) then
                    isTalking = true
                end
            else
                if NetworkIsPlayerTalking(PlayerId()) == false then
                    isTalking = false
                end
            end
        end
    end
)
