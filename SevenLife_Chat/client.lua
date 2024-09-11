-- Variables
ESX = nil
local isadminduty = false
local innoclip = false
local activnames = false
local IsPlayerInAnim = false
local hud = false
local noClippingEntity
local gamerTags = {}
local verlauf
local iscarry = false
local carryprocess = false
local types = ""
local carrypeople = nil
local previousVelocity = vector3(0, 0, 0)

-- Lerp
function Lerp(a, b, t)
    return a + (b - a) * t
end

-- Init ESX

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
        end
        Citizen.Wait(0)
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        PlayerData = ESX.GetPlayerData()
    end
)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        ESX.PlayerData = xPlayer
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(job)
        ESX.PlayerData.job = job
    end
)
RegisterNUICallback(
    "GetLast",
    function()
        SendNUIMessage(
            {
                type = "UpdateCode",
                resulting = verlauf
            }
        )
    end
)
RegisterNUICallback(
    "SendCommandToCLient",
    function(data)
        local message = data.input
        local str = data.input
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        verlauf = message
        if string.find(message, "/ooc") then
            local str, i = str:gsub("1", "", 1)
            str = (i > 0) and str or str:gsub("^.-%s", "", 1)

            local name = GetPlayerName(-1)

            SendNUIMessage(
                {
                    type = "AppendOOCNachricht",
                    titel = name,
                    message = str
                }
            )
            local player = ESX.Game.GetPlayersInArea(coords, 10)
            local playerid = {}
            for k, v in ipairs(player) do
                table.insert(playerid, GetPlayerServerId(v))
            end
            TriggerServerEvent("SevenLife:Chat:MakeOOCNachricht", name, str, playerid)
        end
        if string.find(message, "/dv") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
                        local cars = 0
                        local vehicle = ESX.Game.GetVehiclesInArea(coords, 10)
                        for k, v in ipairs(vehicle) do
                            cars = cars + 1
                            ESX.Game.DeleteVehicle(v)
                        end
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Chat",
                            "Versuche " .. cars .. " Autos zu löschen",
                            2000
                        )
                    end
                end
            )
        end
        if string.find(message, "/dvn") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
                        local vehicle = ESX.Game.GetClosestVehicle(coords)
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Chat",
                            "Versuche " .. vehicle .. " zu löschen",
                            2000
                        )
                        ESX.Game.DeleteVehicle(vehicle)
                    end
                end
            )
        end
        if string.find(message, "/car") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
                        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
                        local str, i = str:gsub("1", "", 1)
                        local veh = (i > 0) and str or str:gsub("^.-%s", "", 1)
                        if veh == nil then
                            veh = "adder"
                        end
                        vehiclehash = GetHashKey(veh)
                        RequestModel(vehiclehash)

                        Citizen.CreateThread(
                            function()
                                local waiting = 0
                                while not HasModelLoaded(vehiclehash) do
                                    waiting = waiting + 100
                                    Citizen.Wait(100)
                                    if waiting > 5000 then
                                        TriggerEvent(
                                            "SevenLife:TimetCustom:Notify",
                                            "Chat",
                                            "Model konnte nicht geladen werden",
                                            2000
                                        )
                                        break
                                    end
                                end
                                CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId()) + 90, 1, 0)
                                TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Auto erfolgreich gespawnt", 2000)
                            end
                        )
                    end
                end
            )
        end
        if string.find(message, "/aduty") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
                        if not isadminduty then
                            PutAdmin()
                        else
                            RemoveAdmin()
                        end
                    end
                end
            )
        end
        if string.find(message, "/dva") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
                        local cars = 0
                        local vehicle = ESX.Game.GetVehicles()
                        for k, v in ipairs(vehicle) do
                            cars = cars + 1
                            ESX.Game.DeleteVehicle(v)
                        end
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Chat",
                            "Versuche " .. cars .. " Autos zu löschen",
                            2000
                        )
                    end
                end
            )
        end
        if string.find(message, "/announce") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
                        local str, i = str:gsub("1", "", 1)
                        str = (i > 0) and str or str:gsub("^.-%s", "", 1)
                        local headline, downline = str:match("([^,]+),([^,]+)")

                        TriggerServerEvent("sevenlife:makeannounce", headline, downline)
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Announce released", 2000)
                    end
                end
            )
        end
        if string.find(message, "/tpm") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
                        local WaypointHandle = GetFirstBlipInfoId(8)

                        if DoesBlipExist(WaypointHandle) then
                            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                            for height = 1, 1000 do
                                SetPedCoordsKeepVehicle(ped, waypointCoords["x"], waypointCoords["y"], height + 0.0)

                                local foundGround, zPos =
                                    GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                                if foundGround then
                                    SetPedCoordsKeepVehicle(ped, waypointCoords["x"], waypointCoords["y"], height + 0.0)

                                    break
                                end

                                Citizen.Wait(5)
                            end

                            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Erfolgreich Teleportiert", 2000)
                        else
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du hast kein Waypoint", 2000)
                        end
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du hast die rechte dafür nicht", 2000)
                    end
                end
            )
        end
        if string.find(message, "/v") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
                        if not innoclip then
                            local playerPed = PlayerPedId()
                            innoclip = true
                            noClippingEntity = playerPed

                            if IsPedInAnyVehicle(playerPed, false) then
                                local veh = GetVehiclePedIsIn(playerPed, false)
                                if IsPedDrivingVehicle(playerPed, veh) then
                                    noClippingEntity = veh
                                end
                            end

                            local isVeh = IsEntityAVehicle(noClippingEntity)

                            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du bist jetzt im NoClip", 2000)
                            SetUserRadioControlEnabled(not innoclip)

                            SetEntityAlpha(noClippingEntity, 51, 0)

                            Citizen.CreateThread(
                                function()
                                    local clipped = noClippingEntity
                                    local pPed = playerPed
                                    local isClippedVeh = isVeh

                                    SetInvincible(true, clipped)

                                    if not isClippedVeh then
                                        ClearPedTasksImmediately(pPed)
                                    end

                                    while innoclip do
                                        Citizen.Wait(2)

                                        FreezeEntityPosition(clipped, true)
                                        SetEntityCollision(clipped, false, false)

                                        SetEntityVisible(clipped, false, false)
                                        SetLocalPlayerVisibleLocally(true)
                                        SetEntityAlpha(clipped, 51, false)

                                        SetEveryoneIgnorePlayer(pPed, true)
                                        SetPoliceIgnorePlayer(pPed, true)
                                        input =
                                            vector3(
                                            GetControlNormal(0, 30),
                                            GetControlNormal(0, 31),
                                            (IsControlAlwaysPressed(1, 20) and 1) or
                                                ((IsControlAlwaysPressed(1, 44) and -1) or 0)
                                        )
                                        speed =
                                            ((IsControlAlwaysPressed(1, 21) and 2.5) or 0.5) *
                                            ((isClippedVeh and 2.75) or 1)
                                        MoveInNoClip()
                                    end

                                    Citizen.Wait(0)

                                    FreezeEntityPosition(clipped, false)
                                    SetEntityCollision(clipped, true, true)

                                    SetEntityVisible(clipped, true, false)
                                    SetLocalPlayerVisibleLocally(true)
                                    ResetEntityAlpha(clipped)

                                    SetEveryoneIgnorePlayer(pPed, false)
                                    SetPoliceIgnorePlayer(pPed, false)
                                    ResetEntityAlpha(clipped)

                                    Citizen.Wait(500)

                                    if isClippedVeh then
                                        while (not IsVehicleOnAllWheels(clipped)) and not innoclip do
                                            Citizen.Wait(0)
                                        end

                                        while not isNoClipping do
                                            Citizen.Wait(0)

                                            if IsVehicleOnAllWheels(clipped) then
                                                return SetInvincible(false, clipped)
                                            end
                                        end
                                    else
                                        if
                                            (IsPedFalling(clipped) and
                                                math.abs(1 - GetEntityHeightAboveGround(clipped)) > 0.01)
                                         then
                                            while (IsPedStopped(clipped) or not IsPedFalling(clipped)) and not innoclip do
                                                Citizen.Wait(0)
                                            end
                                        end

                                        while not innoclip do
                                            Citizen.Wait(0)

                                            if (not IsPedFalling(clipped)) and (not IsPedRagdoll(clipped)) then
                                                return SetInvincible(false, clipped)
                                            end
                                        end
                                    end
                                end
                            )
                        else
                            ResetEntityAlpha(noClippingEntity)
                            innoclip = false
                        end
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du hast die rechte dafür nicht", 2000)
                    end
                end
            )
        end
        if string.find(message, "/names") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
                        if not activnames then
                            activnames = true
                            Citizen.CreateThread(
                                function()
                                    while activnames do
                                        Citizen.Wait(200)
                                        if activnames then
                                            local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
                                            for _, v in pairs(GetActivePlayers()) do
                                                local otherPed = GetPlayerPed(v)
                                                local job = ESX.PlayerData.job.name

                                                if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
                                                    gamerTags[v] =
                                                        CreateFakeMpGamerTag(
                                                        otherPed,
                                                        (" [" ..
                                                            GetPlayerServerId(v) ..
                                                                "] " ..
                                                                    GetPlayerName(v) ..
                                                                        " \nLeben : " ..
                                                                            GetEntityHealth(otherPed) ..
                                                                                " Schutz : " ..
                                                                                    GetPedArmour(otherPed) ..
                                                                                        "  \nJob : " .. job),
                                                        false,
                                                        false,
                                                        "",
                                                        0
                                                    )
                                                    SetMpGamerTagVisibility(gamerTags[v], 4, 1)
                                                else
                                                    RemoveMpGamerTag(gamerTags[v])
                                                    gamerTags[v] = nil
                                                end
                                            end
                                        else
                                            for _, v in pairs(GetActivePlayers()) do
                                                RemoveMpGamerTag(gamerTags[v])
                                            end
                                        end
                                    end
                                end
                            )
                        else
                            activnames = false
                        end
                    end
                end
            )
        end
        if string.find(message, "/giveitem") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" then
                        local words = {}
                        words[1], words[2] = str:match("(%w+)(.+)")

                        local id, item, count = words[2]:match("([^,]+),([^,]+),([^,]+)")

                        if id == nil then
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst eine id angeben", 2000)
                        else
                            if item == nil then
                                TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst ein Item angeben", 2000)
                            else
                                if count == nil then
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Chat",
                                        "Du musst eine Anzahl angeben",
                                        2000
                                    )
                                else
                                    TriggerServerEvent("SevenLife:Chat:GiveItem", id, item, count)
                                end
                            end
                        end
                    end
                end
            )
        end
        if string.find(message, "/setaccountmoney") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" then
                        local words = {}
                        words[1], words[2] = str:match("(%w+)(.+)")

                        local id, type, money = words[2]:match("([^,]+),([^,]+),([^,]+)")

                        if id == nil then
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst eine id angeben", 2000)
                        else
                            if type == nil then
                                TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst einen Typ angeben", 2000)
                            else
                                if money == nil then
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Chat",
                                        "Du musst eine Anzahl angeben",
                                        2000
                                    )
                                else
                                    TriggerServerEvent("SevenLife:Chat:SetAcccountmoney", id, type, money)
                                end
                            end
                        end
                    end
                end
            )
        end
        if string.find(message, "/addaccountmoney") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" then
                        local words = {}
                        words[1], words[2] = str:match("(%w+)(.+)")

                        local id, type, money = words[2]:match("([^,]+),([^,]+),([^,]+)")

                        if id == nil then
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst eine id angeben", 2000)
                        else
                            if type == nil then
                                TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst einen Typ angeben", 2000)
                            else
                                if money == nil then
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Chat",
                                        "Du musst eine Anzahl angeben",
                                        2000
                                    )
                                else
                                    TriggerServerEvent("SevenLife:Chat:addaccountmoney", id, type, money)
                                end
                            end
                        end
                    end
                end
            )
        end
        if string.find(message, "/removehud") then
            if not hud then
                hud = true
                TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Hud verschwunden", 2000)
                TriggerEvent("SevenLife:Start:removeHUD")
            else
                hud = false
                TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Hud erscheint", 2000)
                TriggerEvent("SevenLife:Start:OpenHud")
                TriggerEvent("SevenLife:OpenIt:Right")
            end
        end
        if string.find(message, "/id") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPlayerID",
                function(id, name, ids)
                    SendNUIMessage(
                        {
                            type = "ShowId",
                            titel = name,
                            message = id,
                            id = GetPlayerServerId(PlayerId())
                        }
                    )
                end
            )
        end
        if string.find(message, "/coords") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" then
                        ESX.TriggerServerCallback(
                            "SevenLife:Chat:GetPlayerID",
                            function(id, name)
                                local coords = GetEntityCoords(ped)
                                local heading = GetEntityHeading(ped)
                                local x, y, z = table.unpack(coords)
                                SendNUIMessage(
                                    {
                                        type = "ShowIds",
                                        titel = name,
                                        message = x .. " " .. y .. " " .. z .. " " .. heading
                                    }
                                )
                            end
                        )
                    end
                end
            )
        end
        if string.find(message, "/7m") then
            local str, i = str:gsub("1", "", 1)
            local emote = (i > 0) and str or str:gsub("^.-%s", "", 1)
            local player = GetPlayerPed(-1)
            if GetVehiclePedIsIn(player, false) ~= 0 then
                TriggerEvent(
                    "SevenLife:TimetCustom:Notify",
                    "Chat",
                    "Emotes können nicht im Auto abgespielt werden. Fehlercode #20",
                    2000
                )
                return
            end
            TriggerEvent("SevenLife:Chat:EmoteStartKeys")
            PlayEmote(emote, player)
        end
        if string.find(message, "/carry") then
            local Ped = PlayerPedId()
            if not iscarry then
                iscarry = true
                local coords = GetEntityCoords(Ped)
                local Target = ESX.Game.GetClosestPlayer(coords)
                if Target ~= nil then
                    local targetSrc = GetPlayerServerId(Target)
                    if targetSrc ~= -1 then
                        carryprocess = true
                        carrypeople = targetSrc
                        TriggerServerEvent("SevenLife:Chat:SyncPlayer", targetSrc)
                        LoadAnim("missfinale_c2mcs_1")
                        type = "carrying"
                    else
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Chat",
                            "Niemand ist in deiner Umgebung vorhanden. Fehlercode #19",
                            2000
                        )
                    end
                else
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Chat",
                        "Niemand ist in deiner Umgebung vorhanden. Fehlercode #19",
                        2000
                    )
                end
            else
                iscarry = false
                carryprocess = false
                ClearPedSecondaryTask(Ped)
                DetachEntity(Ped, true, false)
                TriggerServerEvent("SevenLife:Chat:StopPeopleCarry", carrypeople)
                carrypeople = nil
            end
        end
        if string.find(message, "/ban") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" then
                        local words = {}
                        words[1], words[2] = str:match("(%w+)(.+)")

                        local id, grund, dauer = words[2]:match("([^,]+),([^,]+),([^,]+)")

                        if id == nil or grund == nil or dauer == nil then
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Nicht genügend informationen", 2000)
                        else
                            print(id)
                            TriggerServerEvent("NOXANS:BAN:PLAYER", id, grund, dauer)
                        end
                    end
                end
            )
        end
        if string.find(message, "/wheater") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" then
                        local str, i = str:gsub("1", "", 1)
                        local wheaterid = (i > 0) and str or str:gsub("^.-%s", "", 1)
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Wetter geändert.", 2000)
                        if wheaterid == "1" then
                            ChangeWeather("BLIZZARD", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "BLIZZARD")
                        elseif wheaterid == "2" then
                            ChangeWeather("CLEAR", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "CLEAR")
                        elseif wheaterid == "3" then
                            ChangeWeather("CLEARING", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "CLEARING")
                        elseif wheaterid == "4" then
                            ChangeWeather("CLOUDS", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "CLOUDS")
                        elseif wheaterid == "5" then
                            ChangeWeather("EXTRASUNNY", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "EXTRASUNNY")
                        elseif wheaterid == "6" then
                            ChangeWeather("FOGGY", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "FOGGY")
                        elseif wheaterid == "7" then
                            ChangeWeather("HALLOWEEN", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "HALLOWEEN")
                        elseif wheaterid == "8" then
                            ChangeWeather("NEUTRAL", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "NEUTRAL")
                        elseif wheaterid == "9" then
                            ChangeWeather("OVERCAST", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "OVERCAST")
                        elseif wheaterid == "10" then
                            ChangeWeather("RAIN", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "RAIN")
                        elseif wheaterid == "11" then
                            ChangeWeather("SMOG", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "SMOG")
                        elseif wheaterid == "12" then
                            ChangeWeather("SNOW", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "SNOW")
                        elseif wheaterid == "13" then
                            ChangeWeather("SNOWLIGHT", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "SNOWLIGHT")
                        elseif wheaterid == "14" then
                            ChangeWeather("THUNDER", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "THUNDER")
                        elseif wheaterid == "15" then
                            ChangeWeather("XMAS ", true)
                            TriggerServerEvent("SevenLife:Chat:SyncWheather", "XMAS")
                        end
                    end
                end
            )
        end
        if string.find(message, "/time") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" then
                        local str, i = str:gsub("1", "", 1)
                        local hour = (i > 0) and str or str:gsub("^.-%s", "", 1)
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Uhrzeit geändert.", 2000)
                        NetworkOverrideClockTime(hour, 0, 0)
                        TriggerServerEvent("SevenLife:Chat:SyncTime", hour)
                    end
                end
            )
        end
        if string.find(message, "/giveWeapon") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" then
                        local words = {}
                        words[1], words[2] = str:match("(%w+)(.+)")

                        local id, type, ammo = words[2]:match("([^,]+),([^,]+),([^,]+)")

                        if id == nil then
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst eine id angeben", 2000)
                        else
                            if type == nil then
                                TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst einen Typ angeben", 2000)
                            else
                                if ammo == nil then
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Chat",
                                        "Du musst eine Anzahl angeben",
                                        2000
                                    )
                                else
                                    TriggerServerEvent("SevenLife:Chat:GiveWeapon", id, type, ammo)
                                end
                            end
                        end
                    end
                end
            )
        end
        if string.find(message, "/clearWeapons") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" then
                        local words = {}
                        words[1], words[2] = str:match("(%w+)(.+)")

                        local id = words[2]:match("([^,]+)")

                        if id == nil then
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst eine id angeben", 2000)
                        else
                            TriggerServerEvent("SevenLife:Chat:ClearWeapons", id)
                        end
                    end
                end
            )
        end
        if string.find(message, "/clearInventory") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" then
                        local words = {}
                        words[1], words[2] = str:match("(%w+)(.+)")

                        local id = words[2]:match("([^,]+)")

                        if id == nil then
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst eine id angeben", 2000)
                        else
                            TriggerServerEvent("SevenLife:Chat:ClearInventory", id)
                        end
                    end
                end
            )
        end
        if string.find(message, "/showInventory") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" then
                        local words = {}
                        words[1], words[2] = str:match("(%w+)(.+)")

                        local id = words[2]:match("([^,]+)")

                        if id == nil then
                            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst eine id angeben", 2000)
                        else
                            TriggerServerEvent("SevenLife:Chat:ShowInventory", id)
                        end
                    end
                end
            )
        end
        if string.find(message, "/pay") then
            local words = {}
            words[1], words[2] = str:match("(%w+)(.+)")

            local id, amount = words[2]:match("([^,]+),([^,]+)")

            if id == nil or amount == nil then
                TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Nicht genügend informationen", 2000)
            else
                TriggerServerEvent("SevenLife:Chat:TransferMoney", id, amount)
            end
        end
        if string.find(message, "/sperrzone") then
            if PlayerData.job.name == "police" then
                local words = {}

                words[1], words[2] = str:match("(%w+)(.+)")

                local txt = words[2]:match("([^,]+)")

                if txt == nil then
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst einen Grund nennen", 2000)
                else
                    local coords = GetEntityCoords(ped)
                    TriggerServerEvent("SevenLife:Police:Server:MakeSpeerZone", coords, txt)
                end
            end
        end
        if string.find(message, "/entfernesperrzone") then
            if PlayerData.job.name == "police" then
                TriggerServerEvent("SevenLife:Police:Server:RemoveSperrZone")
            end
        end
        if string.find(message, "/jail") then
            TriggerEvent("SevenLife:Police:GetCurrentJailTime")
        end
        if string.find(message, "/polizeinachricht") then
            if PlayerData.job.name == "police" then
                local words = {}

                words[1], words[2] = str:match("(%w+)(.+)")

                local txt = words[2]:match("([^,]+)")

                if txt == nil then
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst einen Grund nennen", 2000)
                else
                    TriggerServerEvent("SevenLife:Police:Server:MakeNachricht", txt)
                end
            end
        end
        if string.find(message, "/frakinvite") then
            if PlayerData.job.name == "lcn" then
                if PlayerData.job.grade == 12 then
                    local coords = GetEntityCoords(ped)
                    local player, dist = ESX.Game.GetClosestPlayer(coords)

                    if player == -1 or dist > 3.0 then
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Chat",
                            "Es gibt keinen Spieler in deiner nähe",
                            2000
                        )
                    else
                        ESX.TriggerServerCallback(
                            "SevenLife:FrakInvite:GetName",
                            function(result)
                                TriggerServerEvent(
                                    "SevenLife:FrakInvite:ShowPlayerInvite",
                                    GetPlayerFromServerId(player),
                                    "LCN",
                                    result
                                )
                            end
                        )
                    end
                end
            end
        end
        if string.find(message, "/clean") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" or playerRank == "supporter" then
                        TriggerEvent("SevenLife:Chat:CleanCar")
                    end
                end
            )
        end
        if string.find(message, "/repair") then
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(playerRank)
                    if playerRank == "admin" or playerRank == "superadmin" or playerRank == "supporter" then
                        TriggerEvent("SevenLife:Chat:Repair")
                    end
                end
            )
        end
    end
)
RegisterNetEvent("SevenLife:Chat:CleanCar")
AddEventHandler(
    "SevenLife:Chat:CleanCar",
    function()
        local playerPed = GetPlayerPed(-1)
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            SetVehicleDirtLevel(vehicle, 0)
            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du hast das Auto erfolgreich gereinigt!", 2000)
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst in einem Auto drinne sein!", 2000)
        end
    end
)
RegisterNetEvent("SevenLife:Chat:Repair")
AddEventHandler(
    "SevenLife:Chat:Repair",
    function()
        local playerPed = GetPlayerPed(-1)
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            SetVehicleEngineHealth(vehicle, 1000)
            SetVehicleEngineOn(vehicle, true, true)
            SetVehicleFixed(vehicle)
            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du hast das Auto erfolgreich Repariert!", 2000)
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Chat", "Du musst in einem Auto drinne sein!", 2000)
        end
    end
)
RegisterNetEvent("SevenLife:Chat:SyncTime")
AddEventHandler(
    "SevenLife:Chat:SyncTime",
    function(hour)
        local time = tonumber(hour)
        NetworkOverrideClockTime(time, 0, 0)
    end
)
function ChangeWeather(weather, instant, changespeed)
    if instant then
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(weather)
        SetWeatherTypeNow(weather)
        SetWeatherTypeNowPersist(weather)
    else
        ClearOverrideWeather()
        SetWeatherTypeOvertimePersist(weather, changespeed or 180.0)
    end
end
function IsPedDrivingVehicle(ped, veh)
    return ped == GetPedInVehicleSeat(veh, -1)
end

function IsControlAlwaysPressed(inputGroup, control)
    return IsControlPressed(inputGroup, control) or IsDisabledControlPressed(inputGroup, control)
end

function IsControlAlwaysJustPressed(inputGroup, control)
    return IsControlJustPressed(inputGroup, control) or IsDisabledControlJustPressed(inputGroup, control)
end

function MoveInNoClip()
    SetEntityRotation(noClippingEntity, GetGameplayCamRot(0), 0, false)
    local forward, right, up, c = GetEntityMatrix(noClippingEntity)
    previousVelocity =
        Lerp(
        previousVelocity,
        ((right * input.x * speed) + (up * -input.z * speed) + (forward * -input.y * speed)),
        Timestep() * 10.0
    )
    c = c + previousVelocity
    SetEntityCoords(noClippingEntity, c - vector3(0, 0, 1), true, true, true, false)
end

function SetInvincible(val, id)
    SetEntityInvincible(id, val)
    return SetPlayerInvincible(id, val)
end

function MoveCarInNoClip()
    SetEntityRotation(noClippingEntity, GetGameplayCamRot(0), 0, false)
    local forward, right, up, c = GetEntityMatrix(noClippingEntity)
    previousVelocity =
        Lerp(
        previousVelocity,
        ((right * input.x * speed) + (up * input.z * speed) + (forward * -input.y * speed)),
        Timestep() * 10.0
    )
    c = c + previousVelocity
    SetEntityCoords(noClippingEntity, (c - vector3(0, 0, 1)) + (vector3(0, 0, .3)), true, true, true, false)
end
RegisterNUICallback(
    "Fehler",
    function()
        TriggerEvent(
            "SevenLife:TimetCustom:Notify",
            "Chat",
            "Problem beim absenden der Nachricht. Bitte versuche es noch einmal",
            2000
        )
    end
)

local inmenu = false
Citizen.CreateThread(
    function()
        SetTextChatEnabled(false)
        SetNuiFocus(false)
        while true do
            Citizen.Wait(5)
            if inmenu == false then
                if IsControlJustPressed(0, 245) then
                    inmenu = true
                    SetCursorLocation(0.1, 0.2)
                    SetNuiFocus(true, true)
                    SendNUIMessage(
                        {
                            type = "OpenChat"
                        }
                    )
                end
            else
                Citizen.Wait(100)
            end
        end
    end
)
RegisterNUICallback(
    "RemoveChat",
    function()
        SetNuiFocus(false, false)
        inmenu = false
    end
)
function PutAdmin()
    local xPlayer = ESX.GetPlayerData()
    isadminduty = true
    lastarmor = GetPedArmour(PlayerPedId())
    TriggerEvent(
        "skinchanger:getSkin",
        function(skin)
            ESX.TriggerServerCallback(
                "SevenLife:Chat:GetPerms",
                function(group)
                    if skin.sex == 0 then
                        if group == "superadmin" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.superadmin.male)
                        elseif group == "admin" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.admin.male)
                        elseif group == "mod" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.mod.male)
                        elseif group == "support" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.support.male)
                        end
                    else
                        if group == "superadmin" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.superadmin.female)
                        elseif group == "admin" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.admin.female)
                        elseif group == "mod" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.mod.female)
                        elseif group == "support" then
                            TriggerEvent("skinchanger:loadClothes", skin, Config.Admin.support.female)
                        end
                    end
                end
            )
        end
    )

    SetPedDefaultComponentVariation(PlayerPedId())

    TriggerEvent("esx:restoreLoadout")

    SetEntityInvincible(GetPlayerPed(-1), true)
    SetPlayerInvincible(PlayerId(), true)
    SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
    SetEntityCanBeDamaged(GetPlayerPed(-1), false)
    SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)

    SetPedCanRagdoll(GetPlayerPed(-1), false)
    ClearPedBloodDamage(GetPlayerPed(-1))
    ResetPedVisibleDamage(GetPlayerPed(-1))
    ClearPedLastWeaponDamage(GetPlayerPed(-1))

    if IsPedMale(PlayerPedId()) then
        SetEntityHealth(PlayerPedId(), 200)
    else
        SetEntityHealth(PlayerPedId(), 100)
    end
    TriggerEvent("esx:restoreLoadout")
end

function RemoveAdmin()
    isadminduty = false
    ESX.TriggerServerCallback(
        "esx_skin:getPlayerSkin",
        function(skin, jobSkin)
            local isMale = skin.sex == 0
            TriggerEvent(
                "skinchanger:loadDefaultModel",
                isMale,
                function()
                    ESX.TriggerServerCallback(
                        "esx_skin:getPlayerSkin",
                        function(skin)
                            TriggerEvent("skinchanger:loadSkin", skin)
                            TriggerEvent("esx:restoreLoadout")
                            SetPedArmour(PlayerPedId(), lastarmor)
                            SetEntityInvincible(GetPlayerPed(-1), false)
                            SetPlayerInvincible(PlayerId(), false)
                            SetPedCanRagdoll(GetPlayerPed(-1), true)
                            ClearPedLastWeaponDamage(GetPlayerPed(-1))
                            SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
                            SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), true)
                            SetEntityCanBeDamaged(GetPlayerPed(-1), true)
                        end
                    )
                end
            )
        end
    )
end

AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if resourceName == GetCurrentResourceName() then
            FreezeEntityPosition(noClippingEntity, false)
            SetEntityCollision(noClippingEntity, true, true)

            SetEntityVisible(noClippingEntity, true, false)
            SetLocalPlayerVisibleLocally(true)
            ResetEntityAlpha(noClippingEntity)

            SetEveryoneIgnorePlayer(PlayerPedId(), false)
            SetPoliceIgnorePlayer(PlayerPedId(), false)
            ResetEntityAlpha(noClippingEntity)
            SetInvincible(false, noClippingEntity)
        end
    end
)

function DrawText3D(x, y, z, text, r, g, b, a)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, a)
        SetTextDropshadow(0, 0, 0, 0, 100)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

RegisterNetEvent("SevenLife:Chat:InsertOOCNachricht")
AddEventHandler(
    "SevenLife:Chat:InsertOOCNachricht",
    function(titel, nachricht)
        SendNUIMessage(
            {
                type = "AppendOOCNachricht",
                titel = titel,
                message = nachricht
            }
        )
    end
)

function PlayEmote(emote, player)
    if emotes[emote] and player and IsPlayerInAnim == false then
        TaskStartScenarioInPlace(player, emotes[emotes].anim, 0, true)
        IsPlayerInAnim = true
    else
        return
    end
end

RegisterNetEvent("SevenLife:Chat:EmoteStartKeys")
AddEventHandler(
    "SevenLife:Chat:EmoteStartKeys",
    function()
        Citizen.CreateThread(
            function()
                while true do
                    local player = GetPlayerPed(-1)
                    Citizen.Wait(2)
                    if IsPlayerInAnim then
                        if
                            IsControlPressed(1, 32) or IsControlPressed(1, 34) or IsControlPressed(1, 33) or
                                IsControlPressed(1, 35) or
                                IsControlPressed(1, 55)
                         then
                            ClearPedTasks(player)
                            IsPlayerInAnim = false
                        end
                    else
                        Citizen.Wait(1000)
                    end
                end
            end
        )
    end
)
RegisterNetEvent("SevenLife:Chat:StopCarry")
AddEventHandler(
    "SevenLife:Chat:StopCarry",
    function()
        iscarry = false
        carryprocess = false
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(PlayerPedId(), true, false)
    end
)
function LoadAnim(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end
    return animDict
end
RegisterNetEvent("SevenLife:Chat:Sync")
AddEventHandler(
    "SevenLife:Chat:Sync",
    function(target)
        local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
        TriggerEvent("SevenLife:Chat:StartLoop")
        LoadAnim("missfinale_c2mcs_1")
        AttachEntityToEntity(
            PlayerPedId(),
            targetPed,
            0,
            0.27,
            0.15,
            0.63,
            0.5,
            0.5,
            180,
            false,
            false,
            false,
            false,
            2,
            false
        )
        types = "beingcarried"
    end
)
RegisterNetEvent("SevenLife:Chat:StartLoop")
AddEventHandler(
    "SevenLife:Chat:StartLoop",
    function()
        Citizen.CreateThread(
            function()
                while true do
                    if carryprocess then
                        if types == "beingcarried" then
                            if not IsEntityPlayingAnim(PlayerPedId(), "nm", "firemans_carry", 3) then
                                TaskPlayAnim(
                                    PlayerPedId(),
                                    "nm",
                                    "firemans_carry",
                                    8.0,
                                    -8.0,
                                    100000,
                                    33,
                                    0,
                                    false,
                                    false,
                                    false
                                )
                            end
                        elseif types == "carrying" then
                            if not IsEntityPlayingAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
                                TaskPlayAnim(
                                    PlayerPedId(),
                                    "missfinale_c2mcs_1",
                                    "fin_c2_mcs_1_camman",
                                    8.0,
                                    -8.0,
                                    100000,
                                    49,
                                    0,
                                    false,
                                    false,
                                    false
                                )
                            end
                        end
                    end
                    Wait(0)
                end
            end
        )
    end
)

RegisterNetEvent("SevenLife:Chat:SyncWheather")
AddEventHandler(
    "SevenLife:Chat:SyncWheather",
    function(weather)
        ChangeWeather(weather, true)
    end
)
