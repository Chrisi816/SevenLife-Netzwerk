local RouletteSeasion = {}
RegisterServerEvent("SevenLife:Casino:SitDownRouletteCheck")
AddEventHandler(
    "SevenLife:Casino:SitDownRouletteCheck",
    function(Index, Data)
        local source = source
        local chairId = Data.chairId

        if RouletteSeasion[Index] ~= nil then
            if RouletteSeasion[Index].chairsUsed[chairId] ~= nil then
                TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Casino", "Jemand sitzt hier schon", 2000)
            else
                TriggerClientEvent("SevenLife:Casino:SitDownSeasion", source, Index, Data)
            end
        else
            TriggerClientEvent("SevenLife:Casino:SitDownSeasion", source, Index, Data)
        end
    end
)

RegisterNetEvent("SevenLife:Casino:StartGame")
AddEventHandler(
    "SevenLife:Casino:StartGame",
    function(Index, chairId)
        local source = source

        if RouletteSeasion[Index] == nil then
            RouletteSeasion[Index] = {
                statusz = false,
                ido = Config.RouletteStart,
                bets = {},
                chairsUsed = {}
            }
        end

        RouletteSeasion[Index].chairsUsed[chairId] = source
        TriggerClientEvent("SevenLife:Casino:OpenRoulette", source, Index)
    end
)

function GetChipsOfPlayer(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ItemCount = xPlayer.getInventoryItem("casino_chips").count

    return ItemCount
end
RegisterNetEvent("SevenLife:Casino:NotUsing")
AddEventHandler(
    "SevenLife:Casino:NotUsing",
    function(Index)
        local source = source
        if RouletteSeasion[Index] ~= nil then
            for chairId, src in pairs(RouletteSeasion[Index].chairsUsed) do
                if src == source then
                    RouletteSeasion[Index].chairsUsed[chairId] = nil
                end
            end
        end
    end
)
RegisterNetEvent("SevenLife:Casino:BetRoulette")
AddEventHandler(
    "SevenLife:Casino:BetRoulette",
    function(Index, Id, betAmount)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerClientEvent("SevenLife:TimetCustom:Notify", src, "Casino", "Seasion ist schon gestartet", 2000)
        xPlayer.removeInventoryItem("casino_chips", betAmount)
        local chipsAmount = GetChipsOfPlayer(src)
        if chipsAmount >= betAmount then
            TriggerClientEvent("SevenLife:TimetCustom:Notify", src, "Casino", "Wette gestartet", 2000)

            local exist = false
            for i = 1, #RouletteSeasion[Index].bets, 1 do
                local d = RouletteSeasion[Index].bets[i]
                if d.Id == Id and d.playerSrc == src then
                    exist = true
                    RouletteSeasion[Index].bets[i].betAmount = RouletteSeasion[Index].bets[i].betAmount + betAmount
                end
            end

            if not exist then
                table.insert(
                    RouletteSeasion[Index].bets,
                    {
                        Id = Id,
                        playerSrc = src,
                        betAmount = betAmount
                    }
                )
            end
            TriggerClientEvent("SevenLife:Casino:UpdateTable", -1, Index, RouletteSeasion[Index].bets)
        else
            TriggerClientEvent("SevenLife:TimetCustom:Notify", src, "Casino", "Nicht genug Chips", 2000)
        end
    end
)
function GetTableSeat(source)
    for rulettIndex, v in pairs(RouletteSeasion) do
        for chairId, src in pairs(v.chairsUsed) do
            if src == source then
                return chairId
            end
        end
    end
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)

            for rulettIndex, v in pairs(RouletteSeasion) do
                if v.statusz == false then
                    if v.ido > 0 then
                        RouletteSeasion[rulettIndex].ido = v.ido - 1
                        TriggerClientEvent("SevenLife:Casino:UpdateStatus", -1, rulettIndex, v.ido, v.statusz)
                    end

                    if v.ido < 1 then
                        local randomSpinNumber = math.random(1, 38)
                        if Config.TestTicker ~= nil then
                            randomSpinNumber = Config.TestTicker
                        end
                        local WinningBetIndex = Config.rouletteSzamok[randomSpinNumber]

                        RouletteSeasion[rulettIndex].statusz = true
                        RouletteSeasion[rulettIndex].WinningBetIndex = WinningBetIndex
                        TriggerClientEvent("SevenLife:Casino:UpdateStatus", -1, rulettIndex, v.ido, v.statusz)

                        Citizen.CreateThread(
                            function()
                                TriggerClientEvent("SevenLife:Casino:StartSpin", -1, rulettIndex, randomSpinNumber)
                                Citizen.Wait(15500)

                                if #v.bets > 0 then
                                    CheckWinners(v.bets, RouletteSeasion[rulettIndex].WinningBetIndex)
                                    RouletteSeasion[rulettIndex].statusz = false
                                    RouletteSeasion[rulettIndex].ido = Config.RouletteStart
                                    RouletteSeasion[rulettIndex].WinningBetIndex = nil
                                    RouletteSeasion[rulettIndex].bets = {}
                                    TriggerClientEvent(
                                        "SevenLife:Casino:UpdateTable",
                                        -1,
                                        rulettIndex,
                                        RouletteSeasion[rulettIndex].bets
                                    )
                                else
                                    if CountPlayers(rulettIndex) < 1 then
                                        RouletteSeasion[rulettIndex] = nil

                                        TriggerClientEvent("SevenLife:Casino:UpdateStatus", -1, rulettIndex, nil, nil)
                                    else
                                        RouletteSeasion[rulettIndex].statusz = false
                                        RouletteSeasion[rulettIndex].ido = Config.RouletteStart
                                        RouletteSeasion[rulettIndex].WinningBetIndex = nil
                                        RouletteSeasion[rulettIndex].bets = {}
                                        TriggerClientEvent(
                                            "SevenLife:Casino:UpdateTable",
                                            -1,
                                            rulettIndex,
                                            RouletteSeasion[rulettIndex].bets
                                        )
                                    end
                                end
                            end
                        )
                    end
                end
            end
        end
    end
)
function CountPlayers(Index)
    local count = 0

    if RouletteSeasion[Index] ~= nil then
        for chairId, _ in pairs(RouletteSeasion[Index].chairsUsed) do
            count = count + 1
        end

        return count
    else
        return count
    end
end
AddEventHandler(
    "playerDropped",
    function(reason)
        local source = source
        for rulettIndex, v in pairs(RouletteSeasion) do
            for chairId, src in pairs(v.chairsUsed) do
                if src == source then
                    RouletteSeasion[rulettIndex].chairsUsed[chairId] = nil
                end
            end
        end
    end
)

function CheckWinners(bets, WinningBetIndex)
    local playersWon = {}
    local playersLoss = {}

    for i = 1, #bets, 1 do
        local betData = bets[i]

        local targetSrc = betData.playerSrc
        local PLAYER_HANDLE = isPlayerExist(targetSrc)
        if PLAYER_HANDLE then
            betData.betId = tostring(betData.betId)
            if (WinningBetIndex == "00" and betData.betId == "37") or (WinningBetIndex == "0" and betData.betId == "38") then -- dbl zero, and zero
                giveWinningChips(targetSrc, betData.betAmount, 35)
                playersWon[targetSrc] = true
                if playersLoss[targetSrc] then
                    playersWon[targetSrc] = nil
                end
            elseif
                (betData.betId == "39" and RULETT_NUMBERS.Pirosak[WinningBetIndex]) or
                    (betData.betId == "40" and RULETT_NUMBERS.Feketek[WinningBetIndex]) or
                    (betData.betId == "41" and RULETT_NUMBERS.Parosak[WinningBetIndex]) or
                    (betData.betId == "42" and RULETT_NUMBERS.Paratlanok[WinningBetIndex]) or
                    (betData.betId == "43" and RULETT_NUMBERS.to18[WinningBetIndex]) or
                    (betData.betId == "44" and RULETT_NUMBERS.to36[WinningBetIndex])
             then
                giveWinningChips(targetSrc, betData.betAmount, 2)
                playersWon[targetSrc] = true
                if playersLoss[targetSrc] then
                    playersWon[targetSrc] = nil
                end
            elseif betData.betId <= "36" and WinningBetIndex == betData.betId then -- the numbers
                giveWinningChips(targetSrc, betData.betAmount, 35)
                playersWon[targetSrc] = true
                if playersLoss[targetSrc] then
                    playersWon[targetSrc] = nil
                end
            elseif
                (betData.betId == "45" and RULETT_NUMBERS.st12[WinningBetIndex]) or
                    (betData.betId == "46" and RULETT_NUMBERS.sn12[WinningBetIndex]) or
                    (betData.betId == "47" and RULETT_NUMBERS.rd12[WinningBetIndex]) or
                    (betData.betId == "48" and RULETT_NUMBERS.ket_to_1[WinningBetIndex]) or
                    (betData.betId == "49" and RULETT_NUMBERS.ket_to_2[WinningBetIndex]) or
                    (betData.betId == "50" and RULETT_NUMBERS.ket_to_3[WinningBetIndex])
             then
                giveWinningChips(targetSrc, betData.betAmount, 3)
                playersWon[targetSrc] = true

                if playersLoss[targetSrc] then
                    playersWon[targetSrc] = nil
                end
            else
                if playersWon[targetSrc] == nil then
                    playersLoss[targetSrc] = true
                else
                    playersLoss[targetSrc] = nil
                end
            end
        end
    end

    for targetSrc, _ in pairs(playersLoss) do
        local chairId = CountPlayers(targetSrc)
        if chairId ~= nil then
            TriggerClientEvent("SevenLife:Casino:PlayWinAnimation", targetSrc, chairId)
        end
    end

    for targetSrc, _ in pairs(playersWon) do
        local chairId = CountPlayers(targetSrc)
        if chairId ~= nil then
            TriggerClientEvent("client:rulett:playLossAnim", targetSrc, chairId)
        end
    end
end

function giveWinningChips(source, amount, szorzo)
    amount = math.floor(amount * szorzo)

    if amount > 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem("casino_chips", amount)
    end
end

function isPlayerExist(source)
    if GetPlayerName(source) ~= nil then
        return true
    else
        return false
    end
end
