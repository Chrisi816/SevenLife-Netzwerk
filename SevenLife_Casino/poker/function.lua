function textures()
    local blackjackTable =
        GetClosestObjectOfType(1129.406, 262.3578, -52.041, 1.0, GetHashKey("vw_prop_casino_blckjack_01b"), 0, 0, 0)
    SetObjectTextureVariant(blackjackTable, 3)
    local rouletteTable =
        GetClosestObjectOfType(
        1132.7875976563,
        262.42929077148,
        -51.035781860352,
        1.0,
        GetHashKey("vw_prop_casino_roulette_01b"),
        0,
        0,
        0
    )
    SetObjectTextureVariant(rouletteTable, 3)
    local rouletteTable2 =
        GetClosestObjectOfType(
        1130.5859375,
        266.35610961914,
        -51.035778045654,
        1.0,
        GetHashKey("vw_prop_casino_roulette_01b"),
        0,
        0,
        0
    )
    SetObjectTextureVariant(rouletteTable2, 3)
    local threeCardPoker =
        GetClosestObjectOfType(
        1132.9125976563,
        265.86212158203,
        -51.035766601563,
        1.0,
        GetHashKey("vw_prop_casino_3cardpoker_01b"),
        0,
        0,
        0
    )
    SetObjectTextureVariant(threeCardPoker, 3)

    local blackjackTable =
        GetClosestObjectOfType(
        1145.3294677734,
        248.06758117676,
        -51.035781860352,
        1.0,
        GetHashKey("vw_prop_casino_blckjack_01b"),
        0,
        0,
        0
    )
    SetObjectTextureVariant(blackjackTable, 3)
    local rouletteTable =
        GetClosestObjectOfType(
        1147.9478759766,
        247.95536804199,
        -51.035766601563,
        1.0,
        GetHashKey("vw_prop_casino_roulette_01b"),
        0,
        0,
        0
    )
    SetObjectTextureVariant(rouletteTable, 3)
    local rouletteTable2 =
        GetClosestObjectOfType(
        1144.6773681641,
        250.74932861328,
        -51.035762786865,
        1.0,
        GetHashKey("vw_prop_casino_roulette_01b"),
        0,
        0,
        0
    )
    SetObjectTextureVariant(rouletteTable2, 3)
    local threeCardPoker =
        GetClosestObjectOfType(
        1147.9067382813,
        250.86437988281,
        -51.035781860352,
        1.0,
        GetHashKey("vw_prop_casino_3cardpoker_01b"),
        0,
        0,
        0
    )
    SetObjectTextureVariant(threeCardPoker, 3)
end

function setBlackjackDealerPedVoiceGroup(randomNumber, dealerPed)
    if randomNumber == 0 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_M_Y_Casino_01_WHITE_01"))
    elseif randomNumber == 1 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_M_Y_Casino_01_ASIAN_01"))
    elseif randomNumber == 2 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_M_Y_Casino_01_ASIAN_02"))
    elseif randomNumber == 3 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_M_Y_Casino_01_ASIAN_01"))
    elseif randomNumber == 4 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_M_Y_Casino_01_WHITE_01"))
    elseif randomNumber == 5 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_M_Y_Casino_01_WHITE_02"))
    elseif randomNumber == 6 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_M_Y_Casino_01_WHITE_01"))
    elseif randomNumber == 7 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_F_Y_Casino_01_ASIAN_01"))
    elseif randomNumber == 8 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_F_Y_Casino_01_ASIAN_02"))
    elseif randomNumber == 9 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_F_Y_Casino_01_ASIAN_01"))
    elseif randomNumber == 10 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_F_Y_Casino_01_ASIAN_02"))
    elseif randomNumber == 11 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_F_Y_Casino_01_LATINA_01"))
    elseif randomNumber == 12 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_F_Y_Casino_01_LATINA_02"))
    elseif randomNumber == 13 then
        SetPedVoiceGroup(dealerPed, GetHashKey("S_F_Y_Casino_01_LATINA_01"))
    end
end

function SetBlackjackDealerClothes(randomNumber, dealerPed)
    if randomNumber == 0 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 1 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 2, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 2 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 3 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 4 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 4, 2, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 5 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 6 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 4, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 1, 0, 0)
    elseif randomNumber == 7 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 1, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 8 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 1, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 1, 1, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 9 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 2, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 10 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 2, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 2, 1, 0)
        SetPedComponentVariation(dealerPed, 3, 3, 3, 0)
        SetPedComponentVariation(dealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 11 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 0, 1, 0)
        SetPedComponentVariation(dealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
        SetPedPropIndex(dealerPed, 1, 0, 0, false)
    elseif randomNumber == 12 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 3, 1, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 3, 1, 0)
        SetPedComponentVariation(dealerPed, 3, 1, 1, 0)
        SetPedComponentVariation(dealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
    elseif randomNumber == 13 then
        SetPedDefaultComponentVariation(dealerPed)
        SetPedComponentVariation(dealerPed, 0, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 2, 4, 0, 0)
        SetPedComponentVariation(dealerPed, 3, 2, 1, 0)
        SetPedComponentVariation(dealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 7, 1, 0, 0)
        SetPedComponentVariation(dealerPed, 8, 2, 0, 0)
        SetPedComponentVariation(dealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(dealerPed, 11, 0, 0, 0)
        SetPedPropIndex(dealerPed, 1, 0, 0, false)
    end
end
