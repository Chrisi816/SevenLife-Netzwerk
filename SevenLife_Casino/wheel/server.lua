ESX = nil
isRoll = false
local Jobs = {}
local LastTime = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:Casino:GivePrice")
AddEventHandler(
    "SevenLife:Casino:GivePrice",
    function(source, price)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        isRoll = false
        if price.type == "car" then
            TriggerClientEvent("luckywheel:winCar", _source, Config.Car)
            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Casino", "Du hast ein Auto gewonnen", 2000)
        elseif price.type == "item" then
            xPlayer.addInventoryItem(price.name, price.count)
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                _source,
                "Casino",
                "Du hast ein " .. ESX.GetItemLabel(price.name) .. " gewonnen",
                2000
            )
        elseif price.type == "money" then
            xPlayer.addAccountMoney("bank", price.count)
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                _source,
                "Casino",
                "Du hast  " .. price.count .. "$ gewonnen",
                2000
            )
        end
        TriggerClientEvent("SevenLife:Casino:Finish", -1)
        TriggerClientEvent("SevenLife:Casino:ResetSettings", _source)
    end
)
RegisterServerEvent("SevenLife:Casino:StopRolling")
AddEventHandler(
    "SevenLife:Casino:StopRolling",
    function()
        isRoll = false
    end
)
RegisterServerEvent("SevenLife:Casino:StartWheel")
AddEventHandler(
    "SevenLife:Casino:StartWheel",
    function(xPlayer, source)
        local _source = source
        if not isRoll then
            if xPlayer ~= nil then
                MySQL.Sync.execute(
                    "UPDATE users SET wheel = @wheel WHERE identifier = @identifier",
                    {
                        ["@identifier"] = xPlayer.identifier,
                        ["@wheel"] = "1"
                    }
                )
                isRoll = true
                local rnd = math.random(1, 1000)
                local price
                local priceIndex = 0
                for k, v in pairs(Config.Prices) do
                    if (rnd > v.probability.a) and (rnd <= v.probability.b) then
                        price = v
                        priceIndex = k
                        break
                    end
                end

                TriggerClientEvent("SevenLife:Casino:SyncRoll", _source, priceIndex)
                TriggerClientEvent("SevenLife:Casino:StartWheel", -1, _source, priceIndex, price)
            end
        end
    end
)

RegisterServerEvent("SevenLife:Casino:GetWheel")
AddEventHandler(
    "SevenLife:Casino:GetWheel",
    function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        MySQL.Async.fetchScalar(
            "SELECT wheel FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = xPlayer.identifier
            },
            function(dwheel)
                if dwheel == "0" then
                    TriggerEvent("SevenLife:Casino:StartWheel", xPlayer, _source)
                else
                    TriggerClientEvent(
                        "SevenLife:TimetCustom:Notify",
                        _source,
                        "Casino",
                        "Du hast heute schon gespint",
                        2000
                    )
                    TriggerClientEvent("SevenLife:Casino:ResetSettings", _source)
                end
            end
        )
    end
)
function RunAt(h, m, cb)
    table.insert(
        Jobs,
        {
            h = h,
            m = m,
            cb = cb
        }
    )
end
function ResetSpins()
    MySQL.Sync.execute("UPDATE users SET wheel = 0")
end

function GetTime()
    local timestamp = os.time()
    local d = os.date("*t", timestamp).wday
    local h = tonumber(os.date("%H", timestamp))
    local m = tonumber(os.date("%M", timestamp))

    return {d = d, h = h, m = m}
end

function OnTime(d, h, m)
    for i = 1, #Jobs, 1 do
        if Jobs[i].h == h and Jobs[i].m == m then
            Jobs[i].cb(d, h, m)
        end
    end
end

function Tick()
    local time = GetTime()

    if time.h ~= LastTime.h or time.m ~= LastTime.m then
        OnTime(time.d, time.h, time.m)
        LastTime = time
    end

    SetTimeout(60000, Tick)
end

LastTime = GetTime()

Tick()

RunAt(13, 0, ResetSpins)
