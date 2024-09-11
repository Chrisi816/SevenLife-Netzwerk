ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:SeasonPass:GetData",
    function(source, cb, item1, item2, item3)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM battlepassmissionen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        if check[1] ~= nil then
            cb(check[1].progress1 == "fertig", check[1].progress2 == "fertig", check[1].progress3 == "fertig")
        else
            MySQL.Async.execute(
                "INSERT INTO battlepassmissionen (identifier,index1, index2, index3) VALUES (@identifier,@index1, @index2, @index3)",
                {
                    ["@identifier"] = identifier,
                    ["@index1"] = item1,
                    ["@index2"] = item2,
                    ["@index3"] = item3
                }
            )
            cb(false, false, false)
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:SeasonPass:GetData2",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM battlepassmissionen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        if check[1] ~= nil then
            if check[1].progress1 == "fertig" and check[1].progress2 == "fertig" and check[1].progress3 == "fertig" then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            local currenttime = os.date("*t", os.time())

            if tonumber(currenttime["hour"]) == tonumber(4) and tonumber(currenttime["min"]) == tonumber(0) then
                MySQL.Async.execute("DELETE * FROM battlepassmissionen", {})
            end

            Citizen.Wait(60000)
        end
    end
)
RegisterServerEvent("SevenLife:SeasonPass:MakeProgress")
AddEventHandler(
    "SevenLife:SeasonPass:MakeProgress",
    function(mission, fertig, source, addedvalue, endvalue)
        local identifier = ESX.GetPlayerFromId(source).identifier
        local check =
            MySQL.Sync.fetchAll(
            "SELECT * FROM battlepassmissionen WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )
        if tonumber(mission) == 1 then
            if fertig then
                MySQL.Async.execute(
                    "UPDATE battlepassmissionen SET progress1 = @progress1 WHERE identifier = @identifier",
                    {
                        ["@identifier"] = identifier,
                        ["@progress1"] = "fertig"
                    },
                    function()
                    end
                )
            else
                local endnumber = tonumber(check[1].progress1) + tonumber(addedvalue)
                if tonumber(endnumber) < tonumber(endvalue) then
                    MySQL.Async.execute(
                        "UPDATE battlepassmissionen SET progress1 = @progress1 WHERE identifier = @identifier",
                        {
                            ["@identifier"] = identifier,
                            ["@progress1"] = endnumber
                        },
                        function()
                        end
                    )
                elseif tonumber(endnumber) >= tonumber(endvalue) then
                    MySQL.Async.execute(
                        "UPDATE battlepassmissionen SET progress1 = @progress1 WHERE identifier = @identifier",
                        {
                            ["@identifier"] = identifier,
                            ["@progress1"] = "fertig"
                        },
                        function()
                        end
                    )
                end
            end
        elseif tonumber(mission) == 2 then
            if fertig then
                MySQL.Async.execute(
                    "UPDATE battlepassmissionen SET progress2 = @progress2 WHERE identifier = @identifier",
                    {
                        ["@identifier"] = identifier,
                        ["@progress2"] = "fertig"
                    },
                    function()
                    end
                )
            else
                local endnumber = tonumber(check[1].progress2) + tonumber(addedvalue)
                if tonumber(endnumber) < tonumber(endvalue) then
                    MySQL.Async.execute(
                        "UPDATE battlepassmissionen SET progress2 = @progress2 WHERE identifier = @identifier",
                        {
                            ["@identifier"] = identifier,
                            ["@progress2"] = endnumber
                        },
                        function()
                        end
                    )
                elseif tonumber(endnumber) >= tonumber(endvalue) then
                    MySQL.Async.execute(
                        "UPDATE battlepassmissionen SET progress2= @progress2 WHERE identifier = @identifier",
                        {
                            ["@identifier"] = identifier,
                            ["@progress2"] = "fertig"
                        },
                        function()
                        end
                    )
                end
            end
        elseif tonumber(mission) == 3 then
            if fertig then
                MySQL.Async.execute(
                    "UPDATE battlepassmissionen SET progress3 = @progress3 WHERE identifier = @identifier",
                    {
                        ["@identifier"] = identifier,
                        ["@progress3"] = "fertig"
                    },
                    function()
                    end
                )
            else
                local endnumber = tonumber(check[1].progress3) + tonumber(addedvalue)
                if tonumber(endnumber) < tonumber(endvalue) then
                    MySQL.Async.execute(
                        "UPDATE battlepassmissionen SET progress3 = @progress3 WHERE identifier = @identifier",
                        {
                            ["@identifier"] = identifier,
                            ["@progress3"] = endnumber
                        },
                        function()
                        end
                    )
                elseif tonumber(endnumber) >= tonumber(endvalue) then
                    MySQL.Async.execute(
                        "UPDATE battlepassmissionen SET progress3 = @progress3 WHERE identifier = @identifier",
                        {
                            ["@identifier"] = identifier,
                            ["@progress3"] = "fertig"
                        },
                        function()
                        end
                    )
                end
            end
        end
    end
)
