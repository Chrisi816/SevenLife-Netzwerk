local listpoker = {}

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Poker:CheckIfPlayerCanSeasonSeatDown",
    function(source, cb, Id, cId)
        if listpoker[Id] == nil then
            listpoker[Id] = {
                ChairsUsed = {},
                PlayerBets = {},
                Active = false,
                Cards = {},
                UsedCards = {},
                PlayersFolded = {},
                PairPlusBets = {},
                Stage = 0,
                TimeLeft = nil
            }
        end

        if listpoker[Id].ChairsUsed[cId] == nil then
            listpoker[Id].ChairsUsed[cId] = source
            PlayerChipsUpdate(source)
            cb(true)
        else
            cb(false)
        end
    end
)

function PlayerChipsUpdate(Src)
    TriggerClientEvent("SevenLife:Casino:UpdateChips", Src, GetPlayerChips(Src))
end

function GetPlayerChips(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    return xPlayer.getInventoryItem("casino_chips").count
end
RegisterServerEvent("SevenLife:Casino:StanUp")
AddEventHandler(
    "SevenLife:Casino:StanUp",
    function(tableId, chairId)
        if listpoker[tableId] ~= nil and listpoker[tableId].ChairsUsed[chairId] ~= nil then
            listpoker[tableId].ChairsUsed[chairId] = nil
        end
    end
)
RegisterServerEvent("SevenLife:Casino:MakeBet")
AddEventHandler(
    "SevenLife:Casino:MakeBet",
    function(tableId, chairData, betAmount)
        local source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            if listpoker[tableId] ~= nil then
                if listpoker[tableId].PlayerBets[source] == nil then
                    if GetPlayerChips(source) < betAmount then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            source,
                            "Casino",
                            "Du hast zu wenige Chips",
                            2000
                        )
                        return
                    end

                    if listpoker[tableId].Active == false then
                        listpoker[tableId].TimeLeft = 15
                        listpoker[tableId].Active = true
                        TriggerClientEvent(
                            "SevenLife:Casino:UpdateStatus",
                            -1,
                            tableId,
                            listpoker[tableId].Active,
                            listpoker[tableId].TimeLeft
                        )
                    end

                    if listpoker[tableId].TimeLeft ~= nil and listpoker[tableId].TimeLeft > 0 then
                        listpoker[tableId].PlayerBets[source] = betAmount
                        TriggerClientEvent("SevenLife:Casino:AnimPlayerBet", xPlayer.source, betAmount)
                        xPlayer.removeInventoryItem("casino_chip", betAmount)

                        if listpoker[tableId].Cards["dealer"] == nil then
                            listpoker[tableId].Cards["dealer"] = {
                                Hand = Generate(tableId)
                            }
                        end

                        if listpoker[tableId].Cards[source] == nil then
                            listpoker[tableId].Cards[source] = {
                                Hand = Generate(tableId),
                                chairData = chairData
                            }
                        end

                        TriggerClientEvent("SevenLife:Casino:UpdateCards", -1, tableId, listpoker[tableId].Cards)
                    end
                else
                    TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Casino", "Du hast schon gebettet", 2000)
                end
            end
        end
    end
)
function Generate(tableId)
    local handTable = {}

    if listpoker[tableId] ~= nil then
        for i = 1, 3, 1 do
            local randomCard = math.random(1, #Config.Cards)

            while listpoker[tableId].UsedCards[randomCard] ~= nil do
                randomCard = math.random(1, #Config.Cards)
            end

            listpoker[tableId].UsedCards[randomCard] = true
            handTable[i] = randomCard
        end

        return handTable
    end
end
RegisterServerEvent("SevenLife:Casino:PlusPlayer")
AddEventHandler(
    "SevenLife:Casino:PlusPlayer",
    function(tableId, betAmount)
        local source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            if listpoker[tableId] ~= nil then
                if listpoker[tableId].PairPlusBets[source] == nil then
                    if GetPlayerChips(source) < betAmount then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            source,
                            "Casino",
                            "Du hast zu wenige Chips",
                            2000
                        )
                        return
                    end

                    local currentAnteBetAmount = GetPlayerBetAmount(source, tableId)
                    if GetPlayerChips(source) < (currentAnteBetAmount + betAmount) then
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            source,
                            "Casino",
                            "Du hast zu wenige Chips",
                            2000
                        )
                        return
                    end

                    if listpoker[tableId].TimeLeft ~= nil and listpoker[tableId].TimeLeft > 0 then
                        listpoker[tableId].PairPlusBets[source] = betAmount
                        TriggerClientEvent("SevenLife:Casino:PlusPlayer", xPlayer.source, betAmount)
                        xPlayer.removeInventoryItem("casino_chip", betAmount)
                    end
                else
                    TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Casino", "Du hast schon gebettet", 2000)
                end
            end
        end
    end
)
RegisterServerEvent("SevenLife:Casino:Playing")
AddEventHandler(
    "SevenLife:Casino:Playing",
    function(tableId, bettedAmount)
        local source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            if listpoker[tableId] ~= nil then
                if GetPlayerChips(source) >= bettedAmount then
                    TriggerClientEvent("SevenLife:Casino:PlayCards", -1, source, tableId)
                    xPlayer.removeInventoryItem("casino_chip", bettedAmount)
                else
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        source,
                        "Casino",
                        "Nicht genug chips um zu spielen",
                        2000
                    )
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)

            for tableId, _ in pairs(listpoker) do
                if listpoker[tableId].Active then
                    if listpoker[tableId].TimeLeft > 0 then
                        listpoker[tableId].TimeLeft = listpoker[tableId].TimeLeft - 1
                        TriggerClientEvent(
                            "SevenLife:Casino:UpdateStatus",
                            -1,
                            tableId,
                            listpoker[tableId].Active,
                            listpoker[tableId].TimeLeft
                        )

                        if listpoker[tableId].TimeLeft < 1 then
                            if listpoker[tableId].Stage == 0 then
                                Citizen.CreateThread(
                                    function()
                                        TriggerClientEvent("SevenLife:Casino:Seassion:1", -1, tableId)

                                        Citizen.Wait(9000)

                                        TriggerClientEvent("SevenLife:Casino:Seassion:2", -1, tableId)

                                        local activePlayers = GetTablesAtPlayerCount(tableId)

                                        Citizen.Wait(4000 * activePlayers)

                                        TriggerClientEvent("SevenLife:Casino:Seassion:3", -1, tableId)

                                        Citizen.Wait(8000)

                                        TriggerClientEvent("SevenLife:Casino:Seassion:4", -1, tableId)

                                        Citizen.Wait((5 * 1000) + 5000)

                                        TriggerClientEvent("SevenLife:Casino:Seassion:5", -1, tableId)

                                        local activePlayers = GetTablesAtPlayerCount(tableId)
                                        Citizen.Wait(2000 + (5000 * activePlayers))

                                        TriggerClientEvent("SevenLife:Casino:Seassion:6", -1, tableId)
                                        Citizen.Wait(10000)
                                        CheckWinners(tableId)
                                        Citizen.Wait(1500)

                                        TriggerClientEvent("SevenLife:Casino:Seassion:7", -1, tableId)

                                        Citizen.Wait(8000 + (4000 * activePlayers))

                                        TriggerClientEvent("SevenLife:Casino:ResetCasinoTable", -1, tableId)
                                        listpoker[tableId].PlayerBets = {}
                                        listpoker[tableId].Active = false
                                        listpoker[tableId].Cards = {}
                                        listpoker[tableId].UsedCards = {}
                                        listpoker[tableId].Stage = 0
                                        listpoker[tableId].TimeLeft = nil
                                        listpoker[tableId].PlayersFolded = {}
                                        listpoker[tableId].PairPlusBets = {}
                                    end
                                )
                            end
                        end
                    end
                end
            end
        end
    end
)

function GetTablesAtPlayerCount(tableId)
    local playersCount = 0
    if listpoker[tableId] ~= nil then
        for targetSrc, _ in pairs(listpoker[tableId].Cards) do
            if GetPlayerName(targetSrc) ~= nil then
                playersCount = playersCount + 1
            end
        end
    end

    return playersCount
end
RegisterServerEvent("SevenLife:Casino:FoldCards")
AddEventHandler(
    "SevenLife:Casino:FoldCards",
    function(tableId)
        local source = source
        if listpoker[tableId] ~= nil then
            listpoker[tableId].PlayersFolded[source] = true
            TriggerClientEvent("SevenLife:Casino:FolderCards", -1, source, tableId)
        end
    end
)

function CheckWinners(tableId)
    if listpoker[tableId] ~= nil then
        local dealerHand = 0
        local dealerHand_second = 0
        local dealerHand_third = 0

        local dH = listpoker[tableId].Cards["dealer"]
        if dH then
            dealerHand = GetHand(dH.Hand)
            dealerHand_second = GetHand(dH.Hand, true, false)
            dealerHand_third = GetHand(dH.Hand, false, true)
        end

        for targetSrc, data in pairs(listpoker[tableId].Cards) do
            if targetSrc ~= "dealer" and GetPlayerName(targetSrc) ~= nil then
                if listpoker[tableId].PlayersFolded[targetSrc] == nil then
                    local playerHand = GetHand(data.Hand)
                    local playerHand_second = GetHand(data.Hand, true, false)
                    local playerHand_third = GetHand(data.Hand, false, true)

                    if DealerPlay(dealerHand) then
                        if playerHand > dealerHand then
                            PlayerWon(targetSrc, tableId, playerHand)
                        elseif playerHand < dealerHand then
                            PlayerLost(targetSrc, tableId, playerHand)
                        elseif playerHand == dealerHand then
                            if playerHand_second == dealerHand_second then
                                if playerHand_third > dealerHand_third then
                                    PlayerWon(targetSrc, tableId, playerHand)
                                elseif playerHand_third == dealerHand_third then
                                    PlayerDraw(targetSrc, tableId, playerHand)
                                else
                                    PlayerLost(targetSrc, tableId, playerHand)
                                end
                            elseif playerHand_second > dealerHand_second then
                                PlayerWon(targetSrc, tableId, playerHand)
                            else
                                PlayerLost(targetSrc, tableId, playerHand)
                            end
                        end
                    else
                        PlayerDraw(targetSrc, tableId, playerHand)
                    end
                end
            end
        end
    end
end

function PlayerDraw(targetSrc, tableId, handValue)
    local betAmount = GetPlayerBetAmount(targetSrc, tableId)
    if betAmount > 0 then
        local plusChips = math.floor(betAmount * 2)

        local xPlayer = ESX.GetPlayerFromId(targetSrc)

        if xPlayer then
            local AnteMultiplier = GetAnteMultiplier(handValue)
            if AnteMultiplier > 0 then
                plusChips = math.floor(plusChips + ((betAmount / 2) * AnteMultiplier))
                TriggerClientEvent("SevenLife:TimetCustom:Notify", targetSrc, "Casino", "Draw", 2000)
            else
                TriggerClientEvent("SevenLife:TimetCustom:Notify", targetSrc, "Casino", "Draw", 2000)
            end
        end

        xPlayer.addInventoryItem("casino_chips", plusChips)
        TriggerClientEvent("SevenLife:Casino:Draw", targetSrc, tableId)
    end
end

function GetPlayerBetAmount(targetSrc, tableId)
    if listpoker[tableId] ~= nil then
        if listpoker[tableId].PlayerBets ~= nil and listpoker[tableId].PlayerBets[targetSrc] ~= nil then
            return listpoker[tableId].PlayerBets[targetSrc]
        end
    end

    return 0
end
function GetAnteMultiplier(handValue)
    if handValue > 500 then
        return 5
    elseif handValue > 400 then
        return 4
    elseif handValue > 300 then
        return 1
    end

    return 0
end
function PlayerWon(targetSrc, tableId, handValue)
    local betAmount = GetPlayerBetAmount(targetSrc, tableId)
    if betAmount > 0 then
        local xPlayer = ESX.GetPlayerFromId(targetSrc)
        if xPlayer then
            local plusChips = math.floor((betAmount * 2) * 2)

            local AnteMultiplier = GetAnteMultiplier(handValue)
            if AnteMultiplier > 0 then
                plusChips = math.floor(plusChips + (AnteMultiplier * betAmount))
                TriggerClientEvent("SevenLife:TimetCustom:Notify", targetSrc, "Casino", "Du hast gewonnen", 2000)
            else
                TriggerClientEvent("SevenLife:TimetCustom:Notify", targetSrc, "Casino", "Du hast gewonnen", 2000)
            end
            xPlayer.addInventoryItem("casino_chips", plusChips)

            TriggerClientEvent("SevenLife:Casino:Gewonnen", targetSrc, tableId)
        end
    end
end
function PlayerLost(targetSrc, tableId, handValue)
    local betAmount = GetPlayerBetAmount(targetSrc, tableId)
    if betAmount > 0 then
        local xPlayer = ESX.GetPlayerFromId(targetSrc)
        if xPlayer then
            TriggerClientEvent("SevenLife:TimetCustom:Notify", targetSrc, "Casino", "Du hast verloren", 2000)
        end
        TriggerClientEvent("SevenLife:Casino:Loose", targetSrc, tableId)
    end
end
function DealerPlay(handValue)
    if handValue >= 12 then
        return true
    else
        return false
    end
end
function GetPairMultiplier(handValue)
    if handValue > 500 then
        return 40
    elseif handValue > 400 then
        return 30
    elseif handValue > 300 then
        return 6
    elseif handValue > 200 then
        return 4
    elseif handValue > 100 then
        return 1
    end

    return 0
end
function GetHand(handTable, bool_1, bool_2)
    if type(handTable) == "table" then
        local c1, c2, c3 = GetCardValue(handTable[1]), GetCardValue(handTable[2]), GetCardValue(handTable[3])

        local handValue = 0

        if (c1 ~= c2 and c1 ~= c3) and c2 ~= c3 then
            local Flush = false

            handValue = c1 + c2 + c3

            if handValue == 19 then
                if
                    (c1 == 14 or c1 == 2 or c1 == 3) and (c2 == 14 or c2 == 2 or c2 == 3) and
                        (c3 == 14 or c3 == 2 or c3 == 3)
                 then
                    Flush = true
                end
            elseif handValue == 9 then
                if
                    (c1 == 2 or c1 == 3 or c1 == 4) and (c2 == 2 or c2 == 3 or c2 == 4) and
                        (c3 == 2 or c3 == 3 or c3 == 4)
                 then
                    Flush = true
                end
            elseif handValue == 12 then
                if
                    (c1 == 3 or c1 == 4 or c1 == 5) and (c2 == 3 or c2 == 4 or c2 == 5) and
                        (c3 == 3 or c3 == 4 or c3 == 5)
                 then
                    Flush = true
                end
            elseif handValue == 15 then
                if
                    (c1 == 4 or c1 == 5 or c1 == 6) and (c2 == 4 or c2 == 5 or c2 == 6) and
                        (c3 == 4 or c3 == 5 or c3 == 6)
                 then
                    Flush = true
                end
            elseif handValue == 18 then
                if
                    (c1 == 5 or c1 == 6 or c1 == 7) and (c2 == 5 or c2 == 6 or c2 == 7) and
                        (c3 == 5 or c3 == 6 or c3 == 7)
                 then
                    Flush = true
                end
            elseif handValue == 21 then
                if
                    (c1 == 6 or c1 == 7 or c1 == 8) and (c2 == 6 or c2 == 7 or c2 == 8) and
                        (c3 == 6 or c3 == 7 or c3 == 8)
                 then
                    Flush = true
                end
            elseif handValue == 24 then
                if
                    (c1 == 7 or c1 == 8 or c1 == 9) and (c2 == 7 or c2 == 8 or c2 == 9) and
                        (c3 == 7 or c3 == 8 or c3 == 9)
                 then
                    Flush = true
                end
            elseif handValue == 27 then
                if
                    (c1 == 8 or c1 == 9 or c1 == 10) and (c2 == 8 or c2 == 9 or c2 == 10) and
                        (c3 == 8 or c3 == 9 or c3 == 10)
                 then
                    Flush = true
                end
            elseif handValue == 30 then
                if
                    (c1 == 9 or c1 == 10 or c1 == 11) and (c2 == 9 or c2 == 10 or c2 == 11) and
                        (c3 == 9 or c3 == 10 or c3 == 11)
                 then
                    Flush = true
                end
            elseif handValue == 33 then
                if
                    (c1 == 10 or c1 == 11 or c1 == 12) and (c2 == 10 or c2 == 11 or c2 == 12) and
                        (c3 == 10 or c3 == 11 or c3 == 12)
                 then
                    Flush = true
                end
            elseif handValue == 36 then
                if
                    (c1 == 11 or c1 == 12 or c1 == 13) and (c2 == 11 or c2 == 12 or c3 == 13) and
                        (c3 == 11 or c3 == 12 or c3 == 13)
                 then
                    --something true
                    Flush = true
                end
            elseif handValue == 39 then
                if
                    (c1 == 12 or c1 == 13 or c1 == 14) and (c2 == 12 or c2 == 13 or c2 == 14) and
                        (c3 == 12 or c3 == 13 or c3 == 14)
                 then
                    --something true
                    Flush = true
                end
            end

            if Flush then
                if handValue == 19 then
                    handValue = 6
                end

                if
                    GetCardType(handTable[1]) == GetCardType(handTable[2]) and
                        GetCardType(handTable[1]) == GetCardType(handTable[3])
                 then
                    return handValue + 500
                end

                return handValue + 300
            end
        end

        handValue = 0

        -- SECOND CHECK
        if (c1 == c2) and c1 ~= c3 then -- pairs
            if not bool_1 and not bool_2 then
                return (c1 + c2) + 100
            else
                return c3
            end
        elseif (c2 == c3) and c2 ~= c1 then -- pairs
            if not bool_1 and not bool_2 then
                return (c2 + c3) + 100
            else
                return c1
            end
        elseif (c3 == c1) and c3 ~= c2 then -- pairs
            if not bool_1 and not bool_2 then
                return (c1 + c3) + 100
            else
                return c2
            end
        elseif c1 == c2 and c1 == c3 then -- 3 of a kind
            return c1 + c2 + c3 + 400
        elseif
            GetCardType(handTable[1]) == GetCardType(handTable[2]) and
                GetCardType(handTable[1]) == GetCardType(handTable[3])
         then
            handValue = 200
        end

        -- third check if it runs here

        if c1 > c2 and c1 > c3 then
            if bool_1 then
                if c2 > c3 then
                    return handValue + c2
                else
                    return handValue + c3
                end
            elseif bool_2 then
                if c2 > c3 then
                    return handValue + c3
                else
                    return handValue + c2
                end
            end

            return handValue + c1
        elseif c2 > c1 and c2 > c3 then
            if bool_1 then
                if c1 > c3 then
                    return handValue + c1
                else
                    return handValue + c3
                end
            elseif bool_2 then
                if c1 > c3 then
                    return handValue + c3
                else
                    return handValue + c1
                end
            end

            return handValue + c2
        elseif c3 > c1 and c3 > c2 then
            if bool_1 then
                if c1 > c2 then
                    return handValue + c1
                else
                    return handValue + c2
                end
            elseif bool_2 then
                if c1 > c2 then
                    return handValue + c2
                else
                    return handValue + c1
                end
            end

            return handValue + c3
        end

        return handValue
    else
        return 0
    end
end
function GetCardValue(cardArrayId)
    local vals = {
        -- 2
        [2] = 2,
        [15] = 2,
        [28] = 2,
        [41] = 2,
        -- 3
        [3] = 3,
        [16] = 3,
        [29] = 3,
        [42] = 3,
        -- 4
        [4] = 4,
        [17] = 4,
        [30] = 4,
        [43] = 4,
        -- 5
        [5] = 5,
        [18] = 5,
        [31] = 5,
        [44] = 5,
        -- 6
        [6] = 6,
        [19] = 6,
        [32] = 6,
        [45] = 6,
        -- 7
        [7] = 7,
        [20] = 7,
        [33] = 7,
        [46] = 7,
        -- 8
        [8] = 8,
        [21] = 8,
        [34] = 8,
        [47] = 8,
        -- 9
        [9] = 9,
        [22] = 9,
        [35] = 9,
        [48] = 9,
        -- 10
        [10] = 10,
        [23] = 10,
        [36] = 10,
        [49] = 10,
        -- JACK
        [11] = 11,
        [24] = 11,
        [37] = 11,
        [50] = 11,
        -- QUEEN
        [12] = 12,
        [25] = 12,
        [38] = 12,
        [51] = 12,
        -- KING
        [13] = 13,
        [26] = 13,
        [39] = 13,
        [52] = 13,
        -- ACE
        [1] = 14,
        [14] = 14,
        [27] = 14,
        [40] = 14
    }

    if vals[cardArrayId] then
        return vals[cardArrayId]
    else
        return 0
    end
end
function GetCardType(cardArrayId)
    if cardArrayId >= 1 and cardArrayId <= 13 then -- CLUBS
        return 0
    elseif cardArrayId >= 14 and cardArrayId <= 26 then -- DIAMOND
        return 1
    elseif cardArrayId >= 26 and cardArrayId <= 39 then -- HEARTS
        return 2
    elseif cardArrayId >= 39 and cardArrayId <= 52 then -- SPADES
        return 3
    end
end
