local activeSlotSeasions = {}

RegisterNetEvent("SevenLife:Casino:CheckIfWin")
AddEventHandler(
    "SevenLife:Casino:CheckIfWin",
    function(index, bet, data, dt)
        local _source = source
        if activeSlotSeasions[index] then
            if activeSlotSeasions[index].win then
                if
                    activeSlotSeasions[index].win.a == data.a and activeSlotSeasions[index].win.b == data.b and
                        activeSlotSeasions[index].win.c == data.c
                 then
                    HasPlayerWon(activeSlotSeasions[index].win, dt, _source, bet)
                end
            end
        end
    end
)

function HasPlayerWon(w, data, source, bet)
    local xPlayer = ESX.GetPlayerFromId(source)
    local a = Config.Wins[w.a]
    local b = Config.Wins[w.b]
    local c = Config.Wins[w.c]
    local total = 0
    if a == b and b == c and a == c then
        if Config.Mult[a] then
            total = bet * Config.Mult[a]
        end
    elseif a == "6" and b == "6" then
        total = bet * 2.5
    elseif a == "6" and c == "6" then
        total = bet * 2.5
    elseif b == "6" and c == "6" then
        total = bet * 2.5
    elseif a == "6" then
        total = bet * 2
    elseif b == "6" then
        total = bet * 2
    elseif c == "6" then
        total = bet * 2
    end
    if total > 0 then
        xPlayer.addInventoryItem("casino_chips", total)
    end
end
ESX.RegisterServerCallback(
    "SevenLife:Casino:IsPlaceUsed",
    function(source, cb, index)
        if activeSlotSeasions[index] ~= nil then
            if activeSlotSeasions[index].used then
                cb(true)
            else
                activeSlotSeasions[index].used = true
                cb(false)
            end
        else
            activeSlotSeasions[index] = {}
            activeSlotSeasions[index].used = true
            cb(false)
        end
    end
)
RegisterNetEvent("SevenLife:Casino:Start")
AddEventHandler(
    "SevenLife:Casino:Start",
    function(index, bet)
        local xPlayer = ESX.GetPlayerFromId(source)
        if activeSlotSeasions[index] then
            if CanPlay(bet, source) then
                local w = {a = math.random(1, 16), b = math.random(1, 16), c = math.random(1, 16)}
                local rnd1 = math.random(1, 100)
                local rnd2 = math.random(1, 100)
                local rnd3 = math.random(1, 100)
                if Config.Offset then
                    if rnd1 < Config.OffsetNum then
                        w.a = w.a + 0.5
                    end
                    if rnd2 < Config.OffsetNum then
                        w.b = w.b + 0.5
                    end
                    if rnd3 < Config.OffsetNum then
                        w.c = w.c + 0.5
                    end
                end
                TriggerClientEvent("SevenLife:Casino:StartIT", source, index, w)
                activeSlotSeasions[index].win = w
            else
                TriggerClientEvent("SevenLife:TimetCustom:Notify", source, "Casino", "Nicht genug Chips!", 2000)
            end
        end
    end
)

function CanPlay(bet, source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem("casino_chips").count

    if item >= bet then
        xPlayer.removeInventoryItem("casino_chips", bet)

        return true
    else
        return false
    end
end
RegisterServerEvent("SevenLife:Slots:NotUsable")
AddEventHandler(
    "SevenLife:Slots:NotUsable",
    function(index)
        if activeSlotSeasions[index] ~= nil then
            activeSlotSeasions[index].used = false
        end
    end
)
