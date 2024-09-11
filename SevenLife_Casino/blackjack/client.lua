local dealerPeds = {}
Citizen.CreateThread(
    function()
        dealerAnimDict = "anim_casino_b@amb@casino@games@shared@dealer@"
        RequestAnimDict(dealerAnimDict)
        while not HasAnimDictLoaded(dealerAnimDict) do
            Wait(0)
        end
        textures()

        Citizen.Wait(500)

        for i = 0, #Config.blackjackTables, 1 do
            randomBlack = math.random(1, 13)
            if randomBlack < 7 then
                dealerModel = Config.maleCasinoDealer
            else
                dealerModel = Config.femaleCasinoDealer
            end
            RequestModel(dealerModel)
            while not HasModelLoaded(dealerModel) do
                RequestModel(dealerModel)
                Citizen.Wait(1)
            end
            dealerEntity =
                CreatePed(
                26,
                dealerModel,
                Config.blackjackTables[i].dealerPos.x,
                Config.blackjackTables[i].dealerPos.y,
                Config.blackjackTables[i].dealerPos.z,
                Config.blackjackTables[i].dealerHeading,
                false,
                true
            )
            table.insert(dealerPeds, dealerEntity)
            SetModelAsNoLongerNeeded(dealerModel)
            SetEntityCanBeDamaged(dealerEntity, 0)
            SetPedAsEnemy(dealerEntity, 0)
            SetBlockingOfNonTemporaryEvents(dealerEntity, 1)
            SetPedResetFlag(dealerEntity, 249, 1)
            SetPedConfigFlag(dealerEntity, 185, true)
            SetPedConfigFlag(dealerEntity, 108, true)
            SetPedCanEvasiveDive(dealerEntity, 0)
            SetPedCanRagdollFromPlayerImpact(dealerEntity, 0)
            SetPedConfigFlag(dealerEntity, 208, true)
            setBlackjackDealerPedVoiceGroup(randomBlack, dealerEntity)
            SetBlackjackDealerClothes(randomBlack, dealerEntity)
            SetEntityCoordsNoOffset(
                dealerEntity,
                Config.blackjackTables[i].dealerPos.x,
                Config.blackjackTables[i].dealerPos.y,
                Config.blackjackTables[i].dealerPos.z,
                0,
                0,
                1
            )
            SetEntityHeading(dealerEntity, Config.blackjackTables[i].dealerHeading)
            if dealerModel == Config.maleCasinoDealer then
                TaskPlayAnim(dealerEntity, dealerAnimDict, "idle", 1000.0, -2.0, -1, 2, 1148846080, 0)
            else
                TaskPlayAnim(dealerEntity, dealerAnimDict, "female_idle", 1000.0, -2.0, -1, 2, 1148846080, 0)
            end
            PlayFacialAnim(dealerEntity, "idle_facial", dealerAnimDict)
            RemoveAnimDict(dealerAnimDict)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            if sittingAtBlackjackTable and canExitBlackjack then
                SetPedCapsule(PlayerPedId(), 0.2)
                if IsControlJustPressed(0, 202) and not waitingForSitDownState then --Leave seat [backspace]
                    shouldForceIdleCardGames = false
                    Wait(0)
                    blackjackAnimDictToLoad = "anim_casino_b@amb@casino@games@shared@player@"
                    RequestAnimDict(blackjackAnimDictToLoad)
                    while not HasAnimDictLoaded(blackjackAnimDictToLoad) do
                        Wait(0)
                    end
                    --FreezeEntityPosition(GetPlayerPed(-1),false)
                    --SetEntityCollision(GetPlayerPed(-1),true,true)
                    NetworkStopSynchronisedScene(Local_198f_255)
                    TaskPlayAnim(GetPlayerPed(-1), blackjackAnimDictToLoad, "sit_exit_left", 1.0, 1.0, 2500, 0)
                    --SetPlayerControl(PlayerId(),1,256,0)
                    sittingAtBlackjackTable = false
                    timeoutHowToBlackjack = true
                    blackjackInstructional = nil
                    --print("made blackjackInstructional nil cause its success")
                    bettingInstructional = nil
                    waitingForBetState = false
                    drawCurrentHand = false
                    drawTimerBar = false
                    TriggerServerEvent("Blackjack:leaveBlackjackTable")
                    closestDealerPed, closestDealerPedDistance = getClosestDealer()
                    PlayAmbientSpeech1(
                        closestDealerPed,
                        "MINIGAME_DEALER_LEAVE_NEUTRAL_GAME",
                        "SPEECH_PARAMS_FORCE_NORMAL_CLEAR",
                        1
                    )
                    SetTimeout(
                        5000,
                        function()
                            timeoutHowToBlackjack = false
                        end
                    )
                end
            end
            if waitingForStandOrHitState and sittingAtBlackjackTable and blackjackGameInProgress then
                if IsDisabledControlJustPressed(0, 22) then --hit
                    waitingForStandOrHitState = false
                    TriggerServerEvent("Blackjack:hitBlackjack", globalGameId, globalNextCardCount)
                    drawTimerBar = false
                    standOrHitThisRound = true
                    requestCard()
                end
                if IsControlJustPressed(0, 202) then --stand
                    waitingForStandOrHitState = false
                    TriggerServerEvent("Blackjack:standBlackjack", globalGameId, globalNextCardCount)
                    drawTimerBar = false
                    standOrHitThisRound = true
                    declineCard()
                end
            end
            Wait(0)
        end
    end
)
