local started = false
currentBetInput = 0
local chairdata = nil
local SharedPokers, networkedChips, pedtable = {}, {}, {}
local Actives = false
local OwnedChips = nil
local Inmarker, playedHudSound, InChairNeer, playerBetted, activePokerTable, playerPairPlus, TimeLefts =
    false,
    false,
    false,
    nil,
    nil,
    nil,
    nil
local clientTimer, watchingCards = nil, false
local ID1, chaircoords1, chairrotation1
function StartChairs(index, data)
    local list = {}
    list.cards = {}
    list.playersFolded = {}
    list.data = data
    list.index = index

    list.UpdateState = function(Active, TimeLeft)
        list.Active = Active
        Actives = Active

        list.TimeLeft = TimeLeft
        TimeLefts = TimeLeft
    end
    list.playCards = function(mainSrc)
        if GetPlayerServerId(PlayerId()) == mainSrc then
            watchingCards = false

            StopGameplayCamShaking(true)

            Citizen.CreateThread(
                function()
                    local scene =
                        NetworkCreateSynchronisedScene(
                        chairdata.Coords,
                        chairdata.Rotation,
                        2,
                        true,
                        false,
                        1.0,
                        0.0,
                        1.0
                    )
                    NetworkAddPedToSynchronisedScene(
                        PlayerPedId(),
                        scene,
                        "anim_casino_b@amb@casino@games@threecardpoker@player",
                        "cards_play",
                        2.0,
                        -2.0,
                        13,
                        16,
                        1000.0,
                        0
                    )
                    NetworkStartSynchronisedScene(scene)

                    while not HasAnimEventFired(PlayerPedId(), -1424880317) do
                        Citizen.Wait(1)
                    end

                    local nextScene =
                        NetworkCreateSynchronisedScene(
                        chairdata.Coords,
                        chairdata.Rotation,
                        2,
                        true,
                        false,
                        1.0,
                        0.0,
                        1.0
                    )
                    NetworkAddPedToSynchronisedScene(
                        PlayerPedId(),
                        nextScene,
                        "anim_casino_b@amb@casino@games@threecardpoker@player",
                        "cards_bet",
                        2.0,
                        -2.0,
                        13,
                        16,
                        1000.0,
                        0
                    )
                    NetworkStartSynchronisedScene(nextScene)

                    Citizen.Wait(500)

                    local offsetAlign = nil
                    if chairdata.Id == 4 then
                        offsetAlign = vector3(0.689125, 0.171575, 0.954)
                    elseif chairdata.Id == 3 then
                        offsetAlign = vector3(0.2869, -0.211925, 0.954)
                    elseif chairdata.Id == 2 then
                        offsetAlign = vector3(-0.30935, -0.205675, 0.954)
                    elseif chairdata.Id == 1 then
                        offsetAlign = vector3(-0.69795, 0.211525, 0.954)
                    end

                    local offset = GetObjectOffsetFromCoords(list.data.position, list.data.rot, offsetAlign)
                    local chipModel = GetChipModelByAmount(playerBetted)
                    RequestModel(chipModel)
                    while not HasModelLoaded(chipModel) do
                        Citizen.Wait(1)
                    end

                    local chipObj = CreateObjectNoOffset(chipModel, offset, true, false, true)
                    SetEntityCoordsNoOffset(chipObj, offset, false, false, true)
                    SetEntityHeading(chipObj, GetEntityHeading(PlayerPedId()))
                    table.insert(networkedChips, chipObj)

                    while not HasAnimEventFired(PlayerPedId(), -1424880317) do
                        Citizen.Wait(1)
                    end

                    list.IdlePed()
                end
            )
        end

        if list.cards[mainSrc] ~= nil and list.ServerCards[mainSrc] ~= nil then
            local chairData = list.ServerCards[mainSrc].chairData
            local cardsScene = CreateSynchronizedScene(chairData.Coords, chairData.Rotation, 2)
            PlaySynchronizedEntityAnim(
                list.cards[mainSrc][1],
                cardsScene,
                "cards_play_card_a",
                "anim_casino_b@amb@casino@games@threecardpoker@player",
                1000.0,
                0,
                0,
                1000.0
            )
            PlaySynchronizedEntityAnim(
                list.cards[mainSrc][2],
                cardsScene,
                "cards_play_card_b",
                "anim_casino_b@amb@casino@games@threecardpoker@player",
                1000.0,
                0,
                0,
                1000.0
            )
            PlaySynchronizedEntityAnim(
                list.cards[mainSrc][3],
                cardsScene,
                "cards_play_card_c",
                "anim_casino_b@amb@casino@games@threecardpoker@player",
                1000.0,
                0,
                0,
                1000.0
            )
        end
    end
    list.PlayerBetAnim = function(amount)
        playerBetted = amount
        local player = PlayerPedId()
        RequestAnimDict("anim_casino_b@amb@casino@games@threecardpoker@player")
        while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@threecardpoker@player") do
            Citizen.Wait(1)
        end

        local offsetAlign = nil
        if chairdata.Id == 4 then
            offsetAlign = vector3(0.59535, 0.200875, 0.95)
        elseif chairdata.Id == 3 then
            offsetAlign = vector3(0.247825, -0.123625, 0.95)
        elseif chairdata.Id == 2 then
            offsetAlign = vector3(-0.2804, -0.109775, 0.95)
        elseif chairdata.Id == 1 then
            offsetAlign = vector3(-0.606975, 0.249675, 0.95)
        end

        local animName = "bet_ante"
        if amount >= 10000 then
            animName = "bet_ante_large"
        end

        local scene =
            NetworkCreateSynchronisedScene(chairdata.Coords, chairdata.Rotation, 2, false, true, 1.0, 0.0, 1.0)
        NetworkAddPedToSynchronisedScene(
            player,
            scene,
            "anim_casino_b@amb@casino@games@threecardpoker@player",
            animName,
            2.0,
            -2.0,
            13,
            16,
            1000.0,
            0
        )
        NetworkStartSynchronisedScene(scene)

        while not HasAnimEventFired(player, -1424880317) do
            Citizen.Wait(1)
        end

        local offset = GetObjectOffsetFromCoords(list.data.position, list.data.rot, offsetAlign)
        local chipModel = GetChipModelByAmount(amount)
        RequestModel(chipModel)
        while not HasModelLoaded(chipModel) do
            Citizen.Wait(1)
        end

        local chipObj = CreateObjectNoOffset(chipModel, offset, true, false, true)
        SetEntityCoordsNoOffset(chipObj, offset, false, false, true)
        SetEntityHeading(chipObj, GetEntityHeading(player))
        table.insert(networkedChips, chipObj)

        list.RandomIdleAnim(player)
    end
    list.RandomIdleAnim = function(player)
        local selectedIdleAnim = nil

        if GetEntityModel(player) == GetHashKey("mp_f_freemode_01") then
            selectedIdleAnim = "female_idle_cardgames_var_01"
        else
            selectedIdleAnim = "idle_cardgames_var_01"
        end

        if selectedIdleAnim ~= nil then
            local playerIdleScene =
                NetworkCreateSynchronisedScene(chairdata.Coords, chairdata.Rotation, 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(
                player,
                playerIdleScene,
                "anim_casino_b@amb@casino@games@shared@player@",
                selectedIdleAnim,
                2.0,
                -2.0,
                13,
                16,
                1000.0,
                0
            )
            NetworkStartSynchronisedScene(playerIdleScene)

            while not HasAnimEventFired(player, -1424880317) do
                Citizen.Wait(1)
            end

            local playerIdleScene2 =
                NetworkCreateSynchronisedScene(chairdata.Coords, chairdata.Rotation, 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(
                player,
                playerIdleScene2,
                "anim_casino_b@amb@casino@games@shared@player@",
                "idle_cardgames",
                2.0,
                -2.0,
                13,
                16,
                1000.0,
                0
            )
            NetworkStartSynchronisedScene(playerIdleScene2)
        end
    end
    list.playerPairPlusAnim = function(amount)
        playerPairPlus = amount
        local player = PlayerPedId()
        RequestAnimDict("anim_casino_b@amb@casino@games@threecardpoker@player")
        while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@threecardpoker@player") do
            Citizen.Wait(1)
        end

        local offsetAlign = nil
        if chairdata.Id == 4 then
            offsetAlign = vector3(0.51655, 0.2268, 0.95)
        elseif chairdata.Id == 3 then
            offsetAlign = vector3(0.2163, -0.04745, 0.95)
        elseif chairdata.Id == 2 then
            offsetAlign = vector3(-0.2552, -0.031225, 0.95)
        elseif chairdata.Id == 1 then
            offsetAlign = vector3(-0.529875, 0.281425, 0.95)
        end

        local animName = "bet_plus"
        if amount >= 10000 then
            animName = "bet_plus_large"
        end

        local scene =
            NetworkCreateSynchronisedScene(chairdata.Coords, chairdata.Rotation, 2, true, false, 1.0, 0.0, 1.0)
        NetworkAddPedToSynchronisedScene(
            player,
            scene,
            "anim_casino_b@amb@casino@games@threecardpoker@player",
            animName,
            2.0,
            -2.0,
            13,
            16,
            1000.0,
            0
        )
        NetworkStartSynchronisedScene(scene)

        while not HasAnimEventFired(player, -1424880317) do
            Citizen.Wait(1)
        end

        local offset = GetObjectOffsetFromCoords(list.data.position, list.data.rot, offsetAlign)
        local chipModel = GetChipModelByAmount(amount)
        RequestModel(chipModel)
        while not HasModelLoaded(chipModel) do
            Citizen.Wait(1)
        end

        local chipObj = CreateObjectNoOffset(chipModel, offset, true, false, true)
        SetEntityCoordsNoOffset(chipObj, offset, false, false, true)
        SetEntityHeading(chipObj, GetEntityHeading(player))
        table.insert(networkedChips, chipObj)

        list.RandomIdleAnim()
    end
    list.CreateCards = function(cardName)
        local cardModel = GetHashKey(cardName)
        RequestModel(cardModel)
        while not HasModelLoaded(cardModel) do
            Citizen.Wait(1)
        end

        return CreateObject(cardModel, list.data.position + vector3(0.0, 0.0, -0.1), false, true, true)
    end
    list.FirstSeasion = function()
        SpeakPlayer(list.ped, "MINIGAME_DEALER_CLOSED_BETS")

        RequestAnimDict("anim_casino_b@amb@casino@games@threecardpoker@dealer")
        while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@threecardpoker@dealer") do
            Citizen.Wait(1)
        end

        local firstScene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

        TaskSynchronizedScene(
            list.ped,
            firstScene,
            "anim_casino_b@amb@casino@games@threecardpoker@dealer",
            "female_deck_pick_up",
            2.0,
            -2.0,
            13,
            16,
            1000.0,
            0
        )

        while GetSynchronizedScenePhase(firstScene) < 0.99 do
            if HasAnimEventFired(list.ped, 1691374422) then
                if not IsEntityAttachedToAnyPed(list.set) then
                    FreezeEntityPosition(list.set, false)
                    AttachEntityToEntity(
                        list.set,
                        list.ped,
                        GetPedBoneIndex(list.ped, 60309),
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        false,
                        false,
                        false,
                        true,
                        2,
                        true
                    )
                end
            end

            Citizen.Wait(1)
        end

        if list.ServerCards["dealer"] ~= nil then
            list.cards["dealer"] = {}

            if not DoesEntityExist(list.cards["dealer"][1]) then
                list.cards["dealer"][1] = list.CreateCards(Config.Cards[list.ServerCards["dealer"].Hand[1]])
            end
            if not DoesEntityExist(list.cards["dealer"][2]) then
                list.cards["dealer"][2] = list.CreateCards(Config.Cards[list.ServerCards["dealer"].Hand[2]])
            end
            if not DoesEntityExist(list.cards["dealer"][3]) then
                list.cards["dealer"][3] = list.CreateCards(Config.Cards[list.ServerCards["dealer"].Hand[3]])
            end
        end

        local secondScene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

        TaskSynchronizedScene(
            list.ped,
            secondScene,
            "anim_casino_b@amb@casino@games@threecardpoker@dealer",
            "female_deck_shuffle",
            2.0,
            -2.0,
            13,
            16,
            1000.0,
            0
        )

        PlaySynchronizedEntityAnim(
            list.cards["dealer"][1],
            secondScene,
            "deck_shuffle_card_a",
            "anim_casino_b@amb@casino@games@threecardpoker@dealer",
            1000.0,
            0,
            0,
            1000.0
        )
        PlaySynchronizedEntityAnim(
            list.cards["dealer"][2],
            secondScene,
            "deck_shuffle_card_b",
            "anim_casino_b@amb@casino@games@threecardpoker@dealer",
            1000.0,
            0,
            0,
            1000.0
        )
        PlaySynchronizedEntityAnim(
            list.cards["dealer"][3],
            secondScene,
            "deck_shuffle_card_c",
            "anim_casino_b@amb@casino@games@threecardpoker@dealer",
            1000.0,
            0,
            0,
            1000.0
        )

        while GetSynchronizedScenePhase(secondScene) < 0.99 do
            Citizen.Wait(1)
        end

        SetEntityVisible(list.cards["dealer"][1], false, false)
        SetEntityVisible(list.cards["dealer"][2], false, false)
        SetEntityVisible(list.cards["dealer"][3], false, false)

        local thirdScene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

        TaskSynchronizedScene(
            list.ped,
            thirdScene,
            "anim_casino_b@amb@casino@games@threecardpoker@dealer",
            "female_deck_idle",
            2.0,
            -2.0,
            13,
            16,
            1000.0,
            0
        )

        while GetSynchronizedScenePhase(thirdScene) < 0.99 do
            Citizen.Wait(1)
        end
    end
    list.GiveToPlayers = function()
        StartAudioScene("DLC_VW_Casino_Cards_Focus_Hand")
        StartAudioScene("DLC_VW_Casino_Table_Games")

        for targetSrc, data in pairs(list.ServerCards) do
            if targetSrc ~= "dealer" then
                list.cards[targetSrc] = {}
                list.cards[targetSrc][1] = list.CreateCards(Config.Cards[data.Hand[1]])
                list.cards[targetSrc][2] = list.CreateCards(Config.Cards[data.Hand[2]])
                list.cards[targetSrc][3] = list.CreateCards(Config.Cards[data.Hand[3]])

                RequestAnimDict("anim_casino_b@amb@casino@games@threecardpoker@dealer")
                while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@threecardpoker@dealer") do
                    Citizen.Wait(1)
                end

                local playerAnimId = nil

                if data.chairData.Id == 4 then
                    playerAnimId = "p01"
                elseif data.chairData.Id == 3 then
                    playerAnimId = "p02"
                elseif data.chairData.Id == 2 then
                    playerAnimId = "p03"
                elseif data.chairData.Id == 1 then
                    playerAnimId = "p04"
                end

                if playerAnimId ~= nil then
                    local dealScene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

                    SetEntityVisible(list.cards[targetSrc][1], false, false)
                    SetEntityVisible(list.cards[targetSrc][2], false, false)
                    SetEntityVisible(list.cards[targetSrc][3], false, false)

                    TaskSynchronizedScene(
                        list.ped,
                        dealScene,
                        "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                        string.format("female_deck_deal_%s", playerAnimId),
                        2.0,
                        -2.0,
                        13,
                        16,
                        1000.0,
                        0
                    )

                    PlaySynchronizedEntityAnim(
                        list.cards[targetSrc][1],
                        dealScene,
                        string.format("deck_deal_%s_card_a", playerAnimId),
                        "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                        1000.0,
                        0,
                        0,
                        1000.0
                    )
                    PlaySynchronizedEntityAnim(
                        list.cards[targetSrc][2],
                        dealScene,
                        string.format("deck_deal_%s_card_b", playerAnimId),
                        "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                        1000.0,
                        0,
                        0,
                        1000.0
                    )
                    PlaySynchronizedEntityAnim(
                        list.cards[targetSrc][3],
                        dealScene,
                        string.format("deck_deal_%s_card_c", playerAnimId),
                        "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                        1000.0,
                        0,
                        0,
                        1000.0
                    )

                    while GetSynchronizedScenePhase(dealScene) < 0.05 do
                        Citizen.Wait(1)
                    end

                    SetEntityVisible(list.cards[targetSrc][1], true, false)
                    SetEntityVisible(list.cards[targetSrc][2], true, false)
                    SetEntityVisible(list.cards[targetSrc][3], true, false)

                    while GetSynchronizedScenePhase(dealScene) < 0.99 do
                        Citizen.Wait(1)
                    end
                end
            end
        end
    end
    list.DealToItSelf = function()
        local dealSelfScene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

        TaskSynchronizedScene(
            list.ped,
            dealSelfScene,
            "anim_casino_b@amb@casino@games@threecardpoker@dealer",
            "female_deck_deal_self",
            2.0,
            -2.0,
            13,
            16,
            1000.0,
            0
        )

        PlaySynchronizedEntityAnim(
            list.cards["dealer"][1],
            dealSelfScene,
            "deck_deal_self_card_a",
            "anim_casino_b@amb@casino@games@threecardpoker@dealer",
            1000.0,
            0,
            0,
            1000.0
        )
        PlaySynchronizedEntityAnim(
            list.cards["dealer"][2],
            dealSelfScene,
            "deck_deal_self_card_b",
            "anim_casino_b@amb@casino@games@threecardpoker@dealer",
            1000.0,
            0,
            0,
            1000.0
        )
        PlaySynchronizedEntityAnim(
            list.cards["dealer"][3],
            dealSelfScene,
            "deck_deal_self_card_c",
            "anim_casino_b@amb@casino@games@threecardpoker@dealer",
            1000.0,
            0,
            0,
            1000.0
        )

        while GetSynchronizedScenePhase(dealSelfScene) < 0.05 do
            Citizen.Wait(1)
        end

        SetEntityVisible(list.cards["dealer"][1], true, false)
        SetEntityVisible(list.cards["dealer"][2], true, false)
        SetEntityVisible(list.cards["dealer"][3], true, false)

        while GetSynchronizedScenePhase(dealSelfScene) < 0.99 do
            Citizen.Wait(1)
        end
    end
    list.DeckPutting = function()
        local scene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

        TaskSynchronizedScene(
            list.ped,
            scene,
            "anim_casino_b@amb@casino@games@threecardpoker@dealer",
            "female_deck_put_down",
            2.0,
            -2.0,
            13,
            16,
            1000.0,
            0
        )

        while GetSynchronizedScenePhase(scene) < 0.99 do
            Citizen.Wait(1)
        end

        if IsEntityAttachedToAnyPed(list.set) then
            DetachEntity(list.set, true, true)
            FreezeEntityPosition(list.set, true)
        end

        list.IdlePed()
    end
    list.IdlePed = function()
        local scene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

        TaskSynchronizedScene(
            list.ped,
            scene,
            "anim_casino_b@amb@casino@games@shared@dealer@",
            "female_idle",
            1000.0,
            -2.0,
            -1.0,
            33,
            1000.0,
            0
        )
    end
    list.SelfCardRelease = function()
        Citizen.CreateThread(
            function()
                if list.index == activePokerTable then
                    local offset = GetObjectOffsetFromCoords(list.data.position, list.data.rot, 0.0, -0.04, 1.35)

                    mainCamera =
                        CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", offset, -78.0, 0.0, list.data.rot, 80.0, true, 2)
                    SetCamActive(mainCamera, true)
                    RenderScriptCams(true, 900, 900, true, false)
                    ShakeCam(mainCamera, "HAND_SHAKE", 0.25)

                    Citizen.Wait(2500)

                    Citizen.Wait(7500)

                    if DoesCamExist(mainCamera) then
                        DestroyCam(mainCamera, false)
                    end
                    RenderScriptCams(false, 900, 900, true, false)
                end
            end
        )
        if list.ServerCards["dealer"] ~= nil then
            local revealScene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

            TaskSynchronizedScene(
                list.ped,
                revealScene,
                "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                "female_reveal_self",
                2.0,
                -2.0,
                13,
                16,
                1000.0,
                0
            )

            PlaySynchronizedEntityAnim(
                list.cards["dealer"][1],
                revealScene,
                "reveal_self_card_a",
                "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                1000.0,
                0,
                0,
                1000.0
            )
            PlaySynchronizedEntityAnim(
                list.cards["dealer"][2],
                revealScene,
                "reveal_self_card_b",
                "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                1000.0,
                0,
                0,
                1000.0
            )
            PlaySynchronizedEntityAnim(
                list.cards["dealer"][3],
                revealScene,
                "reveal_self_card_c",
                "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                1000.0,
                0,
                0,
                1000.0
            )
        end
    end
    list.updateCards = function(Cards)
        list.ServerCards = Cards
    end
    list.DefaultSet = function()
        Citizen.CreateThread(
            function()
                local cardModel = GetHashKey("vw_prop_casino_cards_01")
                RequestModel(cardModel)
                while not HasModelLoaded(cardModel) do
                    Citizen.Wait(1)
                end

                RequestAnimDict("anim_casino_b@amb@casino@games@threecardpoker@dealer")
                while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@threecardpoker@dealer") do
                    Citizen.Wait(1)
                end

                local offset =
                    GetAnimInitialOffsetPosition(
                    "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                    "deck_pick_up_deck",
                    list.data.position,
                    0.0,
                    0.0,
                    list.data.rot,
                    0.01,
                    2
                )
                list.set = CreateObject(cardModel, offset, false, false, true)
                SetEntityCoordsNoOffset(list.set, offset, false, false, true)
                SetEntityRotation(list.set, 0.0, 0.0, list.data.rot, 2, true)
                FreezeEntityPosition(list.set, true)
            end
        )
    end
    list.WatchingCards = function()
        SpeakPlayer(list.ped, "MINIGAME_DEALER_COMMENT_SLOW")

        if list.index == activePokerTable and playerBetted ~= nil then
            clientTimer = Config.PlayerWaitingTime
            Citizen.CreateThread(
                function()
                    while clientTimer ~= nil do
                        Citizen.Wait(1000)
                        if clientTimer ~= nil then
                            clientTimer = clientTimer - 1
                            if watchingCards then
                                SendNUIMessage(
                                    {
                                        type = "UpdateSecondHilfe",
                                        time = string.format("00:%s", clientTimer)
                                    }
                                )
                            end
                            if clientTimer < 1 then
                                clientTimer = nil

                                TriggerServerEvent("SevenLife:Casino:FoldCards", list.index)
                            end
                        end
                    end
                end
            )
        end

        RequestAnimDict("anim_casino_b@amb@casino@games@threecardpoker@player")
        while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@threecardpoker@player") do
            Citizen.Wait(1)
        end

        for targetSrc, data in pairs(list.ServerCards) do
            if targetSrc ~= "dealer" then
                if GetPlayerServerId(PlayerId()) == targetSrc and list.index == activePokerTable then
                    local scene =
                        NetworkCreateSynchronisedScene(
                        data.chairData.Coords,
                        data.chairData.Rotation,
                        2,
                        true,
                        false,
                        1.0,
                        0.0,
                        1.0
                    )
                    NetworkAddPedToSynchronisedScene(
                        PlayerPedId(),
                        scene,
                        "anim_casino_b@amb@casino@games@threecardpoker@player",
                        "cards_pickup",
                        2.0,
                        -2.0,
                        13,
                        16,
                        1000.0,
                        0
                    )
                    NetworkStartSynchronisedScene(scene)
                    Citizen.CreateThread(
                        function()
                            Citizen.Wait(1500)
                            watchingCards = true
                            ShakeGameplayCam("HAND_SHAKE", 0.15)
                            SendNUIMessage(
                                {
                                    type = "OpenSecondHilfe"
                                }
                            )
                        end
                    )
                end

                local cardsScene = CreateSynchronizedScene(data.chairData.Coords, data.chairData.Rotation, 2)

                PlaySynchronizedEntityAnim(
                    list.cards[targetSrc][1],
                    cardsScene,
                    "cards_pickup_card_a",
                    "anim_casino_b@amb@casino@games@threecardpoker@player",
                    1000.0,
                    0,
                    0,
                    1000.0
                )
                PlaySynchronizedEntityAnim(
                    list.cards[targetSrc][2],
                    cardsScene,
                    "cards_pickup_card_b",
                    "anim_casino_b@amb@casino@games@threecardpoker@player",
                    1000.0,
                    0,
                    0,
                    1000.0
                )
                PlaySynchronizedEntityAnim(
                    list.cards[targetSrc][3],
                    cardsScene,
                    "cards_pickup_card_c",
                    "anim_casino_b@amb@casino@games@threecardpoker@player",
                    1000.0,
                    0,
                    0,
                    1000.0
                )
            end
        end
    end
    list.ClearPokerTable = function()
        SpeakPlayer(list.ped, "MINIGAME_DEALER_ANOTHER_GO")

        local firstScene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

        TaskSynchronizedScene(
            list.pedped,
            firstScene,
            "anim_casino_b@amb@casino@games@threecardpoker@dealer",
            "female_deck_pick_up",
            2.0,
            -2.0,
            13,
            16,
            1000.0,
            0
        )

        while GetSynchronizedScenePhase(firstScene) < 0.99 do
            if HasAnimEventFired(list.ped, 1691374422) then
                if not IsEntityAttachedToAnyPed(list.set) then
                    FreezeEntityPosition(list.set, false)
                    AttachEntityToEntity(
                        list.set,
                        list.ped,
                        GetPedBoneIndex(list.ped, 60309),
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        false,
                        false,
                        false,
                        true,
                        2,
                        true
                    )
                end
            end

            Citizen.Wait(1)
        end

        for targetSrc, data in pairs(list.ServerCards) do
            if targetSrc ~= "dealer" then
                local playerAnimId = nil

                if data.chairData.Id == 4 then
                    playerAnimId = "p01"
                elseif data.chairData.Id == 3 then
                    playerAnimId = "p02"
                elseif data.chairData.Id == 2 then
                    playerAnimId = "p03"
                elseif data.chairData.Id == 1 then
                    playerAnimId = "p04"
                end

                local collectScene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

                TaskSynchronizedScene(
                    list.ped,
                    collectScene,
                    "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                    string.format("female_cards_collect_%s", playerAnimId),
                    2.0,
                    -2.0,
                    13,
                    16,
                    1000.0,
                    0
                )

                PlaySynchronizedEntityAnim(
                    list.cards[targetSrc][1],
                    collectScene,
                    string.format("cards_collect_%s_card_a", playerAnimId),
                    "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                    1000.0,
                    0,
                    0,
                    1000.0
                )
                PlaySynchronizedEntityAnim(
                    list.cards[targetSrc][2],
                    collectScene,
                    string.format("cards_collect_%s_card_b", playerAnimId),
                    "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                    1000.0,
                    0,
                    0,
                    1000.0
                )
                PlaySynchronizedEntityAnim(
                    list.cards[targetSrc][3],
                    collectScene,
                    string.format("cards_collect_%s_card_c", playerAnimId),
                    "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                    1000.0,
                    0,
                    0,
                    1000.0
                )
                while GetSynchronizedScenePhase(collectScene) < 0.99 do
                    Citizen.Wait(1)
                end

                DeleteObject(list.cards[targetSrc][1])
                DeleteObject(list.cards[targetSrc][2])
                DeleteObject(list.cards[targetSrc][3])
            end
        end

        if list.ServerCards["dealer"] then
            local collectScene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

            TaskSynchronizedScene(
                list.ped,
                collectScene,
                "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                "female_cards_collect_self",
                2.0,
                -2.0,
                13,
                16,
                1000.0,
                0
            )

            PlaySynchronizedEntityAnim(
                list.cards["dealer"][1],
                collectScene,
                "cards_collect_self_card_a",
                "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                1000.0,
                0,
                0,
                1000.0
            )
            PlaySynchronizedEntityAnim(
                list.cards["dealer"][2],
                collectScene,
                "cards_collect_self_card_b",
                "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                1000.0,
                0,
                0,
                1000.0
            )
            PlaySynchronizedEntityAnim(
                list.cards["dealer"][3],
                collectScene,
                "cards_collect_self_card_c",
                "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                1000.0,
                0,
                0,
                1000.0
            )
            SetBit(0)
            while GetSynchronizedScenePhase(collectScene) < 0.99 do
                Citizen.Wait(1)
            end

            DeleteObject(list.cards["dealer"][1])
            DeleteObject(list.cards["dealer"][2])
            DeleteObject(list.cards["dealer"][3])
        end

        list.DeckPutting()
    end
    list.RevealAllCards = function()
        for targetSrc, data in pairs(list.ServerCards) do
            if targetSrc ~= "dealer" then
                local playerAnimId = nil

                if data.chairData.Id == 4 then
                    playerAnimId = "p01"
                elseif data.chairData.Id == 3 then
                    playerAnimId = "p02"
                elseif data.chairData.Id == 2 then
                    playerAnimId = "p03"
                elseif data.chairData.Id == 1 then
                    playerAnimId = "p04"
                end

                local mainAnimFormat = nil
                local entityAnimFormatA = nil
                local entityAnimFormatB = nil
                local entityAnimFormatC = nil

                if list.playersFolded[targetSrc] then
                    mainAnimFormat = string.format("female_reveal_folded_%s", playerAnimId)

                    entityAnimFormatA = string.format("reveal_folded_%s_card_a", playerAnimId)
                    entityAnimFormatB = string.format("reveal_folded_%s_card_b", playerAnimId)
                    entityAnimFormatC = string.format("reveal_folded_%s_card_c", playerAnimId)
                else
                    mainAnimFormat = string.format("female_reveal_played_%s", playerAnimId)

                    entityAnimFormatA = string.format("reveal_played_%s_card_a", playerAnimId)
                    entityAnimFormatB = string.format("reveal_played_%s_card_b", playerAnimId)
                    entityAnimFormatC = string.format("reveal_played_%s_card_c", playerAnimId)
                end

                if mainAnimFormat ~= nil then
                    if activePokerTable == list.index then
                        local offset =
                            GetAnimInitialOffsetPosition(
                            "anim_casino_b@amb@casino@games@threecardpoker@player",
                            "cards_play_card_b",
                            data.chairData.Coords,
                            data.chairData.Rotation,
                            0.0,
                            2
                        )

                        if DoesCamExist(mainCamera) then
                            DestroyCam(mainCamera, false)
                        end

                        mainCamera =
                            CreateCamWithParams(
                            "DEFAULT_SCRIPTED_CAMERA",
                            offset + vector3(0.0, 0.0, 0.45),
                            -85.0,
                            0.0,
                            data.chairData.Rotation.z - 90.0,
                            80.0,
                            true,
                            2
                        )
                        SetCamActive(mainCamera, true)
                        RenderScriptCams(true, 900, 900, true, false)
                        ShakeCam(mainCamera, "HAND_SHAKE", 0.25)
                    end

                    SetEntityVisible(list.cards[targetSrc][1], false, false)
                    SetEntityVisible(list.cards[targetSrc][2], false, false)
                    SetEntityVisible(list.cards[targetSrc][3], false, false)

                    local revealScene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)
                    TaskSynchronizedScene(
                        list.ped,
                        revealScene,
                        "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                        mainAnimFormat,
                        2.0,
                        -2.0,
                        13,
                        16,
                        1000.0,
                        0
                    )
                    PlaySynchronizedEntityAnim(
                        list.cards[targetSrc][1],
                        revealScene,
                        entityAnimFormatA,
                        "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                        1000.0,
                        0,
                        0,
                        1000.0
                    )
                    PlaySynchronizedEntityAnim(
                        list.cards[targetSrc][2],
                        revealScene,
                        entityAnimFormatB,
                        "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                        1000.0,
                        0,
                        0,
                        1000.0
                    )
                    PlaySynchronizedEntityAnim(
                        list.cards[targetSrc][3],
                        revealScene,
                        entityAnimFormatC,
                        "anim_casino_b@amb@casino@games@threecardpoker@dealer",
                        1000.0,
                        0,
                        0,
                        1000.0
                    )

                    while GetSynchronizedScenePhase(revealScene) < 0.025 do
                        Citizen.Wait(1)
                    end

                    SetEntityVisible(list.cards[targetSrc][1], true, false)
                    SetEntityVisible(list.cards[targetSrc][2], true, false)
                    SetEntityVisible(list.cards[targetSrc][3], true, false)

                    while GetSynchronizedScenePhase(revealScene) < 0.99 do
                        Citizen.Wait(1)
                    end

                    local ggScene = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

                    TaskSynchronizedScene(
                        list.ped,
                        ggScene,
                        "anim_casino_b@amb@casino@games@shared@dealer@",
                        string.format("female_acknowledge_%s", playerAnimId),
                        2.0,
                        -2.0,
                        13,
                        16,
                        1000.0,
                        0
                    )
                end
            end
        end
    end
    list.ResetDefault = function()
        if #networkedChips > 0 then
            for i = 1, #networkedChips, 1 do
                if NetworkGetEntityOwner(networkedChips[i]) == PlayerId() then
                    DeleteObject(networkedChips[i])
                end
            end
        end

        Citizen.Wait(200)

        for k, v in pairs(list.cards) do
            for i = 1, #v, 1 do
                DeleteObject(v[i])
            end
        end

        list.cards = {}

        if list.index == activePokerTable then
            playerBetted = nil
            playerPairPlus = nil
            watchingCards = false
            StopGameplayCamShaking(true)
            playerDecidedChoice = false
            clientTimer = nil

            networkedChips = {}
            currentBetInput = 0
        end

        list.ServerCards = {}
        list.Active = false
        list.TimeLeft = nil
        list.playersPlaying = {}
        list.playersFolded = {}

        list.IdlePed()
    end
    list.foldCards = function(mainSrc)
        list.playersFolded[mainSrc] = true

        if GetPlayerServerId(PlayerId()) == mainSrc then
            local scene =
                NetworkCreateSynchronisedScene(chairdata.Coords, chairdata.Rotation, 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(
                PlayerPedId(),
                scene,
                "anim_casino_b@amb@casino@games@threecardpoker@player",
                "cards_fold",
                2.0,
                -2.0,
                13,
                16,
                1000.0,
                0
            )
            NetworkStartSynchronisedScene(scene)

            watchingCards = false

            StopGameplayCamShaking(true)
        end

        if list.cards[mainSrc] ~= nil then
            local chairData = list.ServerCards[mainSrc].chairData
            local cardsScene = CreateSynchronizedScene(chairData.chairCoords, chairData.chairRotation, 2)
            PlaySynchronizedEntityAnim(
                list.cards[mainSrc][1],
                cardsScene,
                "cards_fold_card_a",
                "anim_casino_b@amb@casino@games@threecardpoker@player",
                1000.0,
                0,
                0,
                1000.0
            )
            PlaySynchronizedEntityAnim(
                list.cards[mainSrc][2],
                cardsScene,
                "cards_fold_card_b",
                "anim_casino_b@amb@casino@games@threecardpoker@player",
                1000.0,
                0,
                0,
                1000.0
            )
            PlaySynchronizedEntityAnim(
                list.cards[mainSrc][3],
                cardsScene,
                "cards_fold_card_c",
                "anim_casino_b@amb@casino@games@threecardpoker@player",
                1000.0,
                0,
                0,
                1000.0
            )
        end
    end
    list.playerWin = function()
        local reaction = nil
        if GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
            reaction = "female_reaction_great_var_01"
        else
            reaction = "reaction_great_var_01"
        end

        if reaction then
            local reactionScene =
                NetworkCreateSynchronisedScene(chairdata.Coords, chairdata.Rotation, 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(
                PlayerPedId(),
                reactionScene,
                "anim_casino_b@amb@casino@games@shared@player@",
                reaction,
                2.0,
                -2.0,
                13,
                16,
                2.0,
                0
            )
            NetworkStartSynchronisedScene(reactionScene)
        end

        local pedReaction = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

        local pedr =
            ({
            "female_dealer_reaction_bad_var01",
            "female_dealer_reaction_bad_var02",
            "female_dealer_reaction_bad_var03"
        })[math.random(1, 3)]
        TaskSynchronizedScene(list.ped, pedReaction, Config.DealerAnimDictShared, pedr, 2.0, -2.0, 13, 16, 1000.0, 0)
    end
    list.playerLost = function()
        local reaction = nil
        if GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
            reaction = "female_reaction_terrible_var_01"
        else
            reaction = "reaction_terrible_var_01"
        end

        if reaction then
            local reactionScene =
                NetworkCreateSynchronisedScene(chairdata.Coords, chairdata.Rotation, 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(
                PlayerPedId(),
                reactionScene,
                "anim_casino_b@amb@casino@games@shared@player@",
                reaction,
                2.0,
                -2.0,
                13,
                16,
                2.0,
                0
            )
            NetworkStartSynchronisedScene(reactionScene)
        end

        local pedReaction = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

        local pedr =
            ({
            "female_dealer_reaction_good_var01",
            "female_dealer_reaction_good_var02",
            "female_dealer_reaction_good_var03"
        })[math.random(1, 3)]
        TaskSynchronizedScene(
            list.ped,
            pedReaction,
            "anim_casino_b@amb@casino@games@shared@dealer@",
            pedr,
            2.0,
            -2.0,
            13,
            16,
            1000.0,
            0
        )
    end
    list.Draw = function()
        local pedReaction = CreateSynchronizedScene(list.data.position, 0.0, 0.0, list.data.rot, 2)

        local pedr = "female_dealer_reaction_impartial_var01"

        TaskSynchronizedScene(
            list.ped,
            pedReaction,
            "anim_casino_b@amb@casino@games@shared@dealer@",
            pedr,
            2.0,
            -2.0,
            13,
            16,
            1000.0,
            0
        )
    end
    list.Ped = function()
        Citizen.CreateThread(
            function()
               
                local femaleCasinoDealer = GetHashKey("S_F_Y_Casino_01")

                dealerModel = femaleCasinoDealer

                RequestModel(dealerModel)
                while not HasModelLoaded(dealerModel) do
                    Citizen.Wait(1)
                end

                list.ped = CreatePed(26, dealerModel, list.data.position, list.data.rot, false, true)
                SetModelAsNoLongerNeeded(dealerModel)
                SetEntityCanBeDamaged(list.ped, false)
                SetPedAsEnemy(list.ped, false)
                SetBlockingOfNonTemporaryEvents(list.ped, true)
                SetPedResetFlag(list.ped, 249, 1)
                SetPedConfigFlag(list.ped, 185, true)
                SetPedConfigFlag(list.ped, 108, true)
                SetPedCanEvasiveDive(list.ped, 0)
                SetPedCanRagdollFromPlayerImpact(list.ped, 0)
                SetPedConfigFlag(list.ped, 208, true)
                SetPedCanRagdoll(list.ped, false)

                setBlackjackDealerPedVoiceGroup(list.ped, 1)
                SetBlackjackDealerClothes(list.ped, 1)

                SetEntityCoordsNoOffset(list.ped, list.data.position + vector3(0.0, 0.0, 1.0), false, false, true)
                SetEntityHeading(list.ped, list.data.rot)

                RequestAnimDict("anim_casino_b@amb@casino@games@shared@dealer@")
                while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@shared@dealer@") do
                    Citizen.Wait(1)
                end
                list.IdlePed()
            end
        )
    end
    list.SitDown = function(Id, Coords, Rotation)
        local player = PlayerPedId()
        StartAudioScene("DLC_VW_Casino_Table_Games")
        -- Common death question
        if not IsEntityDead(player) then
            -- Check if Seat is nil
            ESX.TriggerServerCallback(
                "SevenLife:Poker:CheckIfPlayerCanSeasonSeatDown",
                function(CanSit)
                    print(1)
                    if CanSit then
                        -- Insert Chair Data
                        chairdata = {
                            Id = Id,
                            Coords = Coords,
                            Rotation = Rotation
                        }
                        -- TODO Activate NUI

                        -- Activates the Greeting From the Ped
                        if GetEntityModel(player) == GetHashKey("mp_m_freemode_01") then
                            SpeakPlayer(player, "MINIGAME_DEALER_GREET")
                        else
                            SpeakPlayer(player, "MINIGAME_DEALER_GREET_FEMALE")
                        end

                        -- Anims

                        RequestAnimDict("anim_casino_b@amb@casino@games@shared@player@")
                        while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@shared@player@") do
                            Citizen.Wait(1)
                        end

                        SetPlayerControl(player, 0, 0)

                        local sitScene = NetworkCreateSynchronisedScene(Coords, Rotation, 2, true, false, 1.0, 0.0, 1.0)

                        local sitAnim = "sit_enter_right_side"
                        NetworkAddPedToSynchronisedScene(
                            player,
                            sitScene,
                            "anim_casino_b@amb@casino@games@shared@player@",
                            sitAnim,
                            2.0,
                            -2.0,
                            13,
                            16,
                            2.0,
                            0
                        )
                        NetworkStartSynchronisedScene(sitScene)

                        Citizen.Wait(4000)
                        mainScene = NetworkCreateSynchronisedScene(Coords, Rotation, 2, true, false, 1.0, 0.0, 1.0)
                        NetworkAddPedToSynchronisedScene(
                            player,
                            mainScene,
                            "anim_casino_b@amb@casino@games@shared@player@",
                            "idle_cardgames",
                            2.0,
                            -2.0,
                            13,
                            16,
                            1000.0,
                            0
                        )
                        NetworkStartSynchronisedScene(mainScene)

                        list.Enable(true)
                        SetPlayerControl(player, 1, 0)

                        Citizen.Wait(500)
                    else
                        TriggerEvent(
                            "SevenLife:TimetCustom:Notify",
                            "Casino",
                            "Auf diesem Stuhl sitzt schon jemand",
                            2000
                        )
                    end
                end,
                list.index,
                Id
            )
        end
    end
    list.Enable = function(state)
        started = true
        local ms = 5000
        local player = PlayerPedId()
        if state then
            DisplayRadar(false)
            activePokerTable = list.index
            SendNUIMessage(
                {
                    type = "OpenInfoPoker",
                    coins = 0
                }
            )

            for k, v in pairs(Config.PokerTable) do
                if k == list.index then
                    list.data.position = v.position
                    list.data.rot = v.rot
                end
            end
            ped = pedtable[list.index]
            TriggerEvent("SevenLife:TimetCustom:Notify", "Casino", "Warten auf weitere Spieler", 2000)
            Citizen.CreateThread(
                function()
                    while activePokerTable do
                        DisableAllControlActions(0)
                        Citizen.Wait(1)
                        EnableControlAction(0, 0, true)
                        EnableControlAction(0, 1, true)
                        EnableControlAction(0, 2, true)

                        if playerBetted then
                            if watchingCards then
                                if IsDisabledControlJustPressed(0, 38) then
                                    clientTimer = nil
                                    watchingCards = false
                                    SendNUIMessage(
                                        {
                                            type = "HideSecondHilfe"
                                        }
                                    )
                                    StopGameplayCamShaking(true)
                                    TriggerServerEvent("SevenLife:Casino:Playing", list.index, playerBetted)
                                end

                                if IsDisabledControlJustPressed(0, 177) then
                                    clientTimer = nil
                                    watchingCards = false
                                    SendNUIMessage(
                                        {
                                            type = "HideSecondHilfe"
                                        }
                                    )
                                    StopGameplayCamShaking(true)
                                    TriggerServerEvent("SevenLife:Casino:FoldCards", list.index)
                                end
                            end
                        end

                        if playerBetted == nil then
                            if IsDisabledControlJustPressed(0, 177) then
                                list.Enable(false)
                                SendNUIMessage(
                                    {
                                        type = "HideSecondHilfe"
                                    }
                                )
                                PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", false)
                            end
                        end

                        if playerBetted == nil or playerPairPlus == nil then
                            if TimeLefts == nil or TimeLefts > 0 then
                                if IsDisabledControlJustPressed(0, 22) then
                                    SetNuiFocus(true, true)
                                    SendNUIMessage(
                                        {
                                            type = "GetBetInputt"
                                        }
                                    )
                                end

                                if IsDisabledControlJustPressed(0, 176) then
                                    if currentBetInput > 0 then
                                        if playerBetted == nil then
                                            TriggerServerEvent(
                                                "SevenLife:Casino:MakeBet",
                                                list.index,
                                                chairdata,
                                                currentBetInput
                                            )
                                        else
                                            if playerPairPlus == nil then
                                                TriggerServerEvent(
                                                    "SevenLife:Casino:PlusPlayer",
                                                    list.index,
                                                    currentBetInput
                                                )
                                            end
                                        end
                                    else
                                        TriggerEvent(
                                            "SevenLife:TimetCustom:Notify",
                                            "Casino",
                                            "Du hast keine Chips gebettet",
                                            2000
                                        )
                                    end
                                end

                                if IsDisabledControlJustPressed(0, 172) then -- up
                                    local increase = UpdateAmount(currentBetInput)
                                    currentBetInput = currentBetInput + increase

                                    PlaySoundFrontend(-1, "DLC_VW_BET_UP", "dlc_vw_table_games_frontend_sounds", true)
                                    SendNUIMessage(
                                        {
                                            type = "OpenInfoPoker",
                                            coins = currentBetInput
                                        }
                                    )
                                elseif IsDisabledControlJustPressed(0, 173) then -- down
                                    if currentBetInput > 0 then
                                        local increase = UpdateAmount(currentBetInput)
                                        currentBetInput = currentBetInput - increase
                                        PlaySoundFrontend(
                                            -1,
                                            "DLC_VW_BET_DOWN",
                                            "dlc_vw_table_games_frontend_sounds",
                                            true
                                        )
                                        if currentBetInput < 0 then
                                            currentBetInput = 0
                                            PlaySoundFrontend(
                                                -1,
                                                "DLC_VW_ERROR_MAX",
                                                "dlc_vw_table_games_frontend_sounds",
                                                true
                                            )
                                        end
                                        SendNUIMessage(
                                            {
                                                type = "OpenInfoPoker",
                                                coins = currentBetInput
                                            }
                                        )
                                    else
                                        PlaySoundFrontend(
                                            -1,
                                            "DLC_VW_ERROR_MAX",
                                            "dlc_vw_table_games_frontend_sounds",
                                            true
                                        )
                                    end
                                end
                            end
                        end
                    end
                end
            )
        else
            SendNUIMessage(
                {
                    type = "RemoveInfoPoker"
                }
            )
            SpeakPlayer(player, "MINIGAME_DEALER_LEAVE_NEUTRAL_GAME")
            started = false
            local sitExitScene =
                NetworkCreateSynchronisedScene(chairdata.Coords, chairdata.Rotation, 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(
                player,
                sitExitScene,
                "anim_casino_b@amb@casino@games@shared@player@",
                "sit_exit_left",
                2.0,
                -2.0,
                13,
                16,
                2.0,
                0
            )
            NetworkStartSynchronisedScene(sitExitScene)

            Citizen.Wait(4000)
            TriggerServerEvent("SevenLife:Casino:StanUp", list.index, chairdata.Id)

            NetworkStopSynchronisedScene(mainScene)
            NetworkStopSynchronisedScene(sitExitScene)
            DisplayRadar(true)

            activePokerTable = nil
            chairdata = nil
        end
    end

    list.Ped()
    list.DefaultSet()
    SharedPokers[index] = list
end

Citizen.CreateThread(
    function()
        while not Inmarker do
            Citizen.Wait(500)
        end

        RequestAnimDict("anim_casino_b@amb@casino@games@shared@dealer@")
        RequestAnimDict("anim_casino_b@amb@casino@games@threecardpoker@dealer")
        RequestAnimDict("anim_casino_b@amb@casino@games@shared@player@")
        RequestAnimDict("anim_casino_b@amb@casino@games@threecardpoker@player")

        for index, data in pairs(Config.PokerTable) do
            StartChairs(index, data)
        end
    end
)

RegisterNetEvent("SevenLife:Casino:PlusPlayer")
AddEventHandler(
    "SevenLife:Casino:PlusPlayer",
    function(amount)
        if SharedPokers[activePokerTable] ~= nil then
            SharedPokers[activePokerTable].playerPairPlusAnim(amount)
        end
    end
)
RegisterNetEvent("SevenLife:Casino:UpdateStatus")
AddEventHandler(
    "SevenLife:Casino:UpdateStatus",
    function(tableId, Active, TimeLeft)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].UpdateState(Active, TimeLeft)
        end
    end
)
RegisterNetEvent("SevenLife:Casino:AnimPlayerBet")
AddEventHandler(
    "SevenLife:Casino:AnimPlayerBet",
    function(amount)
        if SharedPokers[activePokerTable] ~= nil then
            SharedPokers[activePokerTable].PlayerBetAnim(amount)
        end
    end
)
RegisterNetEvent("SevenLife:Casino:UpdateCards")
AddEventHandler(
    "SevenLife:Casino:UpdateCards",
    function(tableId, Cards)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].updateCards(Cards)
        end
    end
)

-- Check if near

Citizen.CreateThread(
    function()
        while true do
            local player = PlayerPedId()
            local playerpos = GetEntityCoords(player)

            if
                GetDistanceBetweenCoords(playerpos, Config.PlaceWheel.x, Config.PlaceWheel.y, Config.PlaceWheel.z, true) <
                    100.0
             then
                Inmarker = true
            else
                Inmarker = false
            end

            Citizen.Wait(1000)
        end
    end
)
function Marker(position)
    DrawMarker(
        20,
        position,
        0.0,
        0.0,
        0.0,
        180.0,
        0.0,
        0.0,
        0.3,
        0.3,
        0.3,
        234,
        0,
        122,
        200,
        true,
        true,
        2,
        true,
        nil,
        nil,
        false
    )
end

-- Core for Moving
local letSleep = true
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if chairdata == nil then
                if Inmarker then
                    local player = PlayerPedId()
                    local playerpos = GetEntityCoords(player)

                    for k, v in pairs(SharedPokers) do
                        local distance = GetDistanceBetweenCoords(playerpos, v.data.position, true)
                        if distance <= 3.0 then
                            for i = 1, #Config.Tables, 1 do
                                local tableObj =
                                    GetClosestObjectOfType(playerpos, 3.0, GetHashKey(Config.Tables[i]), false)
                                if DoesEntityExist(tableObj) then
                                    letSleep = false
                                    for Bone, ID in pairs(Config.PokerChairs) do
                                        local chaircoords =
                                            GetWorldPositionOfEntityBone(
                                            tableObj,
                                            GetEntityBoneIndexByName(tableObj, Bone)
                                        )
                                        if chaircoords then
                                            local distance2 = GetDistanceBetweenCoords(playerpos, chaircoords, true)
                                            if distance2 < 1.5 then
                                                local chairrotation =
                                                    GetWorldRotationOfEntityBone(
                                                    tableObj,
                                                    GetEntityBoneIndexByName(tableObj, Bone)
                                                )
                                                Marker(chaircoords + vector3(0.0, 0.0, 1.0))
                                                if not playedHudSound then
                                                    PlaySoundFrontend(
                                                        -1,
                                                        "DLC_VW_RULES",
                                                        "dlc_vw_table_games_frontend_sounds",
                                                        1
                                                    )
                                                    playedHudSound = true
                                                end
                                                ID1 = ID
                                                chaircoords1 = chaircoords
                                                chairrotation1 = chairrotation
                                                if not started then
                                                    if IsControlJustPressed(0, 38) then
                                                        v.SitDown(ID1, chaircoords1, chairrotation1)
                                                    end
                                                end

                                                InChairNeer = true
                                            else
                                                InChairNeer = false
                                                playedHudSound = false
                                            end
                                            break
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end

                    if letSleep then
                        Citizen.Wait(5000)
                    end
                else
                    Citizen.Wait(4000)
                end
            end
        end
    end
)

function SpeakPlayer(ped, text)
    Citizen.CreateThread(
        function()
            PlayPedAmbientSpeechNative(ped, text, "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", 1)
        end
    )
end

Citizen.CreateThread(
    function()
        while true do
            if Actives then
                Citizen.Wait(1000)
                if TimeLefts > 0 then
                    SendNUIMessage(
                        {
                            type = "UpdateNUI",
                            time = string.format("00:%s", TimeLefts)
                        }
                    )
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
function UpdateAmount(currentAmount)
    if currentAmount < 500 then
        return 50
    elseif currentAmount >= 500 and currentAmount < 2000 then
        return 100
    elseif currentAmount >= 2000 and currentAmount < 5000 then
        return 200
    elseif currentAmount >= 5000 and currentAmount < 10000 then
        return 500
    elseif currentAmount >= 10000 then
        return 1000
    else
        return 50
    end
end
AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        DeletePed(list.ped)
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if InChairNeer then
            else
                Citizen.Wait(400)
            end
        end
    end
)
RegisterNetEvent("SevenLife:Casino:UpdateChips")
AddEventHandler(
    "SevenLife:Casino:UpdateChips",
    function(chips)
        OwnedChips = chips
    end
)
RegisterNUICallback(
    "SetBetPoker",
    function(data)
        SetNuiFocus(false, false)
        local inputt = data.inputt
        if tonumber(inputt) then
            inputt = tonumber(inputt)
            if inputt > 0 then
                currentBetInput = inputt
                PlaySoundFrontend(-1, "DLC_VW_BET_HIGHLIGHT", "dlc_vw_table_games_frontend_sounds", true)
                SendNUIMessage(
                    {
                        type = "OpenInfoPoker",
                        coins = currentBetInput
                    }
                )
            end
        end
    end
)

function GetChipModelByAmount(amount)
    if amount <= 10 then
        return GetHashKey("vw_prop_chip_10dollar_x1")
    elseif amount > 10 and amount < 50 then
        return GetHashKey("vw_prop_chip_10dollar_st")
    elseif amount >= 50 and amount < 100 then
        return GetHashKey("vw_prop_chip_50dollar_x1")
    elseif amount >= 100 and amount < 200 then
        return GetHashKey("vw_prop_chip_100dollar_x1")
    elseif amount >= 200 and amount < 500 then
        return GetHashKey("vw_prop_chip_100dollar_st")
    elseif amount == 500 then
        return GetHashKey("vw_prop_chip_500dollar_x1")
    elseif amount > 500 and amount < 1000 then
        return GetHashKey("vw_prop_chip_500dollar_st")
    elseif amount == 1000 then
        return GetHashKey("vw_prop_chip_1kdollar_x1")
    elseif amount > 1000 and amount < 5000 then
        return GetHashKey("vw_prop_chip_1kdollar_st")
    elseif amount == 5000 then
        return GetHashKey("vw_prop_plaq_5kdollar_x1")
    elseif amount > 5000 and amount < 10000 then
        return GetHashKey("vw_prop_plaq_5kdollar_st")
    elseif amount == 10000 then
        return GetHashKey("vw_prop_plaq_10kdollar_x1")
    elseif amount > 10000 then
        return GetHashKey("vw_prop_plaq_10kdollar_st")
    end
end
-- Stages
RegisterNetEvent("SevenLife:Casino:Seassion:1")
AddEventHandler(
    "SevenLife:Casino:Seassion:1",
    function(tableId)
        SendNUIMessage(
            {
                type = "RemoveInfoPoker"
            }
        )
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].FirstSeasion()
        end
    end
)
RegisterNetEvent("SevenLife:Casino:Seassion:2")
AddEventHandler(
    "SevenLife:Casino:Seassion:2",
    function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].GiveToPlayers()
        end
    end
)
RegisterNetEvent("SevenLife:Casino:Seassion:3")
AddEventHandler(
    "SevenLife:Casino:Seassion:3",
    function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].DealToItSelf()
            SharedPokers[tableId].DeckPutting()
            SharedPokers[tableId].IdlePed()
        end
    end
)

RegisterNetEvent("SevenLife:Casino:Seassion:4")
AddEventHandler(
    "SevenLife:Casino:Seassion:4",
    function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].WatchingCards()
        end
    end
)

RegisterNetEvent("SevenLife:Casino:Seassion:5")
AddEventHandler(
    "SevenLife:Casino:Seassion:5",
    function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].RevealAllCards()
        end
    end
)
RegisterNetEvent("SevenLife:Casino:Seassion:6")
AddEventHandler(
    "SevenLife:Casino:Seassion:6",
    function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].SelfCardRelease()
        end
    end
)
RegisterNetEvent("SevenLife:Casino:Seassion:7")
AddEventHandler(
    "SevenLife:Casino:Seassion:7",
    function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].ClearPokerTable()
        end
    end
)
RegisterNetEvent("SevenLife:Casino:ResetCasinoTable")
AddEventHandler(
    "SevenLife:Casino:ResetCasinoTable",
    function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].ResetDefault()
        end
    end
)
RegisterNetEvent("SevenLife:Casino:FolderCards")
AddEventHandler(
    "SevenLife:Casino:FolderCards",
    function(mainSrc, tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].foldCards(mainSrc)
        end
    end
)
RegisterNetEvent("SevenLife:Casino:Draw")
AddEventHandler(
    "SevenLife:Casino:Draw",
    function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].Draw()
        end
    end
)
RegisterNetEvent("SevenLife:Casino:Gewonnen")
AddEventHandler(
    "SevenLife:Casino:Gewonnen",
    function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].playerWin()
        end
    end
)
RegisterNetEvent("SevenLife:Casino:Loose")
AddEventHandler(
    "SevenLife:Casino:Loose",
    function(tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].playerLost()
        end
    end
)
RegisterNetEvent("SevenLife:Casino:PlayCards")
AddEventHandler(
    "SevenLife:Casino:PlayCards",
    function(mainSrc, tableId)
        if SharedPokers[tableId] ~= nil then
            SharedPokers[tableId].playCards(mainSrc)
        end
    end
)
