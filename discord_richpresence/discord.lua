Citizen.CreateThread(
    function()
        while true do
            local player = GetPlayerPed(-1)
            local Nachricht
            Citizen.Wait(5 * 1000)
            SetDiscordAppId(1151974523919421530)

            if IsPedInAnyVehicle(player, true) then
                Nachricht =
                    GetPlayerName(PlayerId()) ..
                    " fährt auf der " ..
                        GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(player))))
            else
                Nachricht =
                    GetPlayerName(PlayerId()) ..
                    " steht auf der " ..
                        GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(player))))
            end

            SetRichPresence(Nachricht)

            SetDiscordRichPresenceAsset("big")
            SetDiscordRichPresenceAssetText("SService by Chrisi/ShxtOn")

            SetDiscordRichPresenceAction(0, "Discord", "https://discord.gg/s-service")
            SetDiscordRichPresenceAction(1, "Soon...", "https://discord.gg/s-service")
        end
    end
)
