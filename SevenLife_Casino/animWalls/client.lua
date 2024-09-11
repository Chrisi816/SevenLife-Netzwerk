local casinoCoords = vector3(973.22802734375, 47.327392578125, 74.47631072998)
local inCasino, videoWallRenderTarget, showBigWin = false, nil, false
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            local distance = GetDistanceBetweenCoords(coords, casinoCoords, true)

            if distance < 100.0 then
                if not inCasino then
                    InCasino = true
                    StartCasino()
                end
            else
                if inCasino then
                    InCasino = false
                    Citizen.Wait(5000)
                end
            end
        end
    end
)

function StartCasino()
    local interior = GetInteriorAtCoords(GetEntityCoords(GetPlayerPed(-1)))

    while not IsInteriorReady(interior) do
        Citizen.Wait(10)
    end

    RequestStreamedTextureDict("Prop_Screen_Vinewood")

    while not HasStreamedTextureDictLoaded("Prop_Screen_Vinewood") do
        Citizen.Wait(100)
    end

    RegisterNamedRendertarget("casinoscreen_01")

    LinkNamedRendertarget("vw_vwint01_video_overlay")

    videoWallRenderTarget = GetNamedRendertargetRenderId("casinoscreen_01")

    Citizen.CreateThread(
        function()
            local lastUpdatedTvChannel = 0

            while true do
                Citizen.Wait(1)

                if not inCasino then
                    ReleaseNamedRendertarget("casinoscreen_01")

                    videoWallRenderTarget = nil
                    showBigWin = false

                    break
                end

                if videoWallRenderTarget then
                    local currentTime = GetGameTimer()

                    if showBigWin then
                        TVChannelWin()

                        lastUpdatedTvChannel = GetGameTimer() - 33666
                        showBigWin = false
                    else
                        if (currentTime - lastUpdatedTvChannel) >= 42666 then
                            TVChannel()

                            lastUpdatedTvChannel = currentTime
                        end
                    end

                    SetTextRenderId(videoWallRenderTarget)
                    SetScriptGfxDrawOrder(4)
                    SetScriptGfxDrawBehindPausemenu(true)
                    DrawInteractiveSprite(
                        "Prop_Screen_Vinewood",
                        "BG_Wall_Colour_4x4",
                        0.25,
                        0.5,
                        0.5,
                        1.0,
                        0.0,
                        255,
                        255,
                        255,
                        255
                    )

                    DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
                    SetTextRenderId(GetDefaultScriptRendertargetRenderId())
                end
            end
        end
    )
end
function TVChannel()
    SetTvChannelPlaylist(0, Config.VideoType, true)
    SetTvAudioFrontend(true)
    SetTvVolume(-100.0)
    SetTvChannel(0)
end

function TVChannelWin()
    SetTvChannelPlaylist(0, "CASINO_WIN_PL", true)
    SetTvAudioFrontend(true)
    SetTvVolume(-100.0)
    SetTvChannel(-1)
    SetTvChannel(0)
end
