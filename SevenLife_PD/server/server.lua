-- Var
ESX = nil
local CopsInService = {}
local namesofcops = {}
local StreifeListe = {}
local index
local rang1, rang2, rang3, rang4, rang5, rang6
local ActiveSperrZone = false
local streifen = 0

-- ESX

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

rang1 = 10
rang2 = 10
rang3 = 10
rang4 = 10
rang5 = 10
rang6 = 10

function PoliceBlip()
    SetTimeout(
        10000,
        function()
            TriggerClientEvent("SevenLife:Police:GetDataSource", -1)
            PoliceBlip()
        end
    )
end

PoliceBlip()

RegisterServerEvent("SevenLife:Police:Server:MakeBlipFromCops")
AddEventHandler(
    "SevenLife:Police:Server:MakeBlipFromCops",
    function()
        TriggerClientEvent("SevenLife:Police:MakeCopsBlips", source)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Police:Server:CheckIfGPSItem",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local item = xPlayer.getInventoryItem("gps").count
        if item >= 1 then
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:Police:Server:MakeGlobalBlip")
AddEventHandler(
    "SevenLife:Police:Server:MakeGlobalBlip",
    function(coords, types)
        if (CopsInService[source]) then
            CopsInService[source] = nil

            for i, c in pairs(CopsInService) do
                TriggerClientEvent("SevenLife:Police:MakeGlobalBlip", i, coords, types)
            end
        end
    end
)

RegisterServerEvent("SevenLife:Police:Server:MakeSpeerZone")
AddEventHandler(
    "SevenLife:Police:Server:MakeSpeerZone",
    function(coords, text)
        if not ActiveSperrZone then
            ActiveSperrZone = true
            TriggerClientEvent("SevenLife:Police:SperrZoneBlip", -1, coords)

            TriggerClientEvent("SevenLife:TimetCustom:PoliceNotify", -1, text)
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Sperrzone",
                "Momentan ist eine andere Soerrzone vorhanden",
                2000
            )
        end
    end
)
RegisterServerEvent("SevenLife:Police:Server:MakeNachricht")
AddEventHandler(
    "SevenLife:Police:Server:MakeNachricht",
    function(text)
        TriggerClientEvent("SevenLife:TimetCustom:PoliceNotify", -1, text)
    end
)
RegisterServerEvent("SevenLife:Police:Server:RemoveSperrZone")
AddEventHandler(
    "SevenLife:Police:Server:RemoveSperrZone",
    function()
        if ActiveSperrZone then
            ActiveSperrZone = false
            TriggerClientEvent("SevenLife:Police:RemoveSperrzone", -1)
        else
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                source,
                "Sperrzone",
                "Es gibt momentan keine Aktive Sperrzonne",
                2000
            )
        end
    end
)

RegisterServerEvent("SevenLife:Police:Server:TakePoliceService")
AddEventHandler(
    "SevenLife:Police:Server:TakePoliceService",
    function()
        if (not CopsInService[source]) then
            CopsInService[source] = GetPlayerID(source)

            local identifier = ESX.GetPlayerFromId(source).identifier
            local _source = source
            MySQL.Async.fetchAll(
                "SELECT ingamename, name FROM pd_eingestellte WHERE nummer = @nummer ",
                {
                    ["@nummer"] = identifier
                },
                function(result)
                    if namesofcops[1] ~= nil then
                        for i = 1, #namesofcops, 1 do
                            index = #namesofcops + 1
                            InsertIntoPlayer(#namesofcops + 1, result[1].ingamename, result[1].name)
                        end
                    else
                        InsertIntoPlayer(1, result[1].ingamename, result[1].name)
                    end
                    if StreifeListe[1] ~= nil then
                        for i = 1, #StreifeListe, 1 do
                            index = #StreifeListe + 1
                            InsertIntoStreife(#StreifeListe + 1, result[1].ingamename, result[1].name, "eingeteilt")
                        end
                    else
                        InsertIntoStreife(1, result[1].ingamename, result[1].name, "eingeteilt")
                    end
                end
            )

            for i, c in pairs(CopsInService) do
                TriggerClientEvent("SevenLife:Police:CopsInService", i, CopsInService)
            end
        end
    end
)

RegisterServerEvent("SevenLife:Police:Server:LeavePoliceService")
AddEventHandler(
    "SevenLife:Police:Server:LeavePoliceService",
    function()
        if (CopsInService[source]) then
            CopsInService[source] = nil
            table.remove(namesofcops, index)
            for i, c in pairs(CopsInService) do
                TriggerClientEvent("SevenLife:Police:CopsInService", i, CopsInService)
            end
        end
    end
)

function GetPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = GetIdentifier(identifiers)

    return player
end

function GetIdentifier(id)
    for _, v in ipairs(id) do
        return v
    end
end
ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Police:CheckIfEnoughMoney",
    function(source, cb, money)
        local money1 = tonumber(money)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getMoney() >= money1 then
            xPlayer.removeMoney(money1)
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("SevenLife:Police:SaveOutfit")
AddEventHandler(
    "SevenLife:Police:SaveOutfit",
    function(outfitName, model, skinData)
        local src = source
        local Player = ESX.GetPlayerFromId(src)
        local identifiers = ESX.GetPlayerFromId(source).identifier

        if model ~= nil and skinData ~= nil then
            local outfitId = "outfit-" .. math.random(1, 10) .. "-" .. math.random(1111, 9999)
            MySQL.Async.execute(
                "INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (@citizenid, @outfitname, @model, @skin, @outfitId)",
                {
                    ["@citizenid"] = identifiers,
                    ["@outfitname"] = outfitName,
                    ["@model"] = model,
                    ["@skin"] = json.encode(skinData),
                    ["@outfitId"] = outfitId
                },
                function()
                    TriggerClientEvent("SevenLife:Klamotten:Erfolgreichgespeichert", src)
                end
            )
        end
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Police:GetOutfits",
    function(source, cb)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM player_outfits WHERE citizenid = @citizenid ",
            {
                ["@citizenid"] = identifiers
            },
            function(result)
                cb(result)
            end
        )
    end
)
RegisterServerEvent("SevenLife:Kleidungsladen:DeleteOutfit")
AddEventHandler(
    "SevenLife:Kleidungsladen:DeleteOutfit",
    function(name, model, skin, outfitId)
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.execute(
            "DELETE FROM player_outfits WHERE outfitId = @outfitId AND citizenid  = @citizenid",
            {
                ["@outfitId"] = outfitId,
                ["@citizenid"] = identifiers
            },
            function()
            end
        )
    end
)

RegisterServerEvent("SevenLife:Police:Server:TransferPayCheck")
AddEventHandler(
    "SevenLife:Police:Server:TransferPayCheck",
    function(name)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.execute(
            "SELECT salary FROM job_grades WHERE outfitId = @outfitId AND name = @name",
            {
                ["@name"] = name
            },
            function(result)
                xPlayer.addAccountMoney("bank", result[1].salary)
                TriggerClientEvent(
                    "SevenLife:TimetCustom:NotifyAlarm",
                    _source,
                    "PayCheck",
                    "Du hast für deinen Dienst " .. result[1].salary .. "$ erhalten"
                )
            end
        )
    end
)

RegisterServerEvent("SevenLife:Police:Server:SetSalary")
AddEventHandler(
    "SevenLife:Police:Server:SetSalary",
    function()
        MySQL.Async.execute(
            "UPDATE job_grades SET salary = @salary WHERE name = @name",
            {
                ["@salary"] = lohn,
                ["@name"] = types
            },
            function()
                TriggerClientEvent("sevenlife:displaynachrichtse", _source, "Erfolgreich Lohn geändert")
            end
        )
        local xPlayer = ESX.GetPlayerFromId(source)
    end
)

RegisterServerEvent("SevenLife:PD:GiveWeapon")
AddEventHandler(
    "SevenLife:PD:GiveWeapon",
    function(weapon)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addWeapon(weapon, 30)
    end
)

RegisterServerEvent("SevenLife:PD:GiveItem")
AddEventHandler(
    "SevenLife:PD:GiveItem",
    function(item)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem(item, 1)
    end
)

ESX.RegisterUsableItem(
    "pdwmunition",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        TriggerClientEvent("SevenLife:Weapon:AddMuniPDW", source)
    end
)

RegisterServerEvent("SevenLife:Police:AddCard")
AddEventHandler(
    "SevenLife:Police:AddCard",
    function(vehicleProps, id, types)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.execute(
            "INSERT INTO owned_vehicles (owner, plate, vehicle, type, job, vehicleid) VALUES (@owner, @plate, @vehicle, @type, @job,@vehicleid)",
            {
                ["@owner"] = identifiers,
                ["@plate"] = vehicleProps.plate,
                ["@vehicle"] = json.encode(vehicleProps),
                ["@type"] = types,
                ["@job"] = "Police",
                ["@vehicleid"] = id
            },
            function()
                TriggerClientEvent("sevenlife:displaynachrichtse", _source, "Du hast das Auto erfolgreich gekauft")
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:Police:GetGarageCars",
    function(source, cb)
        local ownedCars = {}
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE owner = @owner AND `stored` = 1 AND job = @job AND type = @type",
            {
                ["@owner"] = identifiers,
                ["@job"] = "Police",
                ["@type"] = "car"
            },
            function(results)
                if results[1] ~= nil then
                    for _, v in pairs(results) do
                        if v.type == "car" then
                            local vehicle = json.decode(v.vehicle)
                            table.insert(
                                ownedCars,
                                {vehicle = vehicle, stored = v.stored, plate = v.plate, fuel = v.fuel}
                            )
                        end
                    end
                    cb(ownedCars)
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:Police:GetGarageHeli",
    function(source, cb)
        local ownedCars = {}
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles WHERE owner = @owner AND `stored` = 1 AND job = @job AND type = @type",
            {
                ["@owner"] = identifiers,
                ["@job"] = "Police",
                ["@type"] = "heli"
            },
            function(results)
                if results[1] ~= nil then
                    for _, v in pairs(results) do
                        if v.type == "car" then
                            local vehicle = json.decode(v.vehicle)
                            table.insert(
                                ownedCars,
                                {vehicle = vehicle, stored = v.stored, plate = v.plate, fuel = v.fuel}
                            )
                        end
                    end
                    cb(ownedCars)
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:PD:PauseTrackSpotLight")
AddEventHandler(
    "SevenLife:PD:PauseTrackSpotLight",
    function(PauseSpotLight)
        local _source = source
        TriggerClientEvent("heli:pause.Tspotlight", -1, _source, PauseSpotLight)
    end
)

RegisterServerEvent("SevenLife:PD:SpotLight")
AddEventHandler(
    "SevenLife:PD:SpotLight",
    function(target_netID, target_plate, targetposx, targetposy, targetposz)
        local _source = source
        TriggerClientEvent(
            "SevenLife:PD:HeliSpotlight",
            -1,
            _source,
            target_netID,
            target_plate,
            targetposx,
            targetposy,
            targetposz
        )
    end
)
RegisterServerEvent("SevenLife:PD:ToogelSpotLight")
AddEventHandler(
    "SevenLife:PD:ToogelSpotLight",
    function()
        local _source = source
        TriggerClientEvent("SevenLife:PD:ToogelSpotLight", -1, _source)
    end
)
RegisterServerEvent("SevenLife:PD:MakeSpotlightForward")
AddEventHandler(
    "SevenLife:PD:MakeSpotlightForward",
    function(state)
        local serverID = source
        TriggerClientEvent("SevenLife:PD:MakeSpotlightForward", -1, serverID, state)
    end
)
RegisterServerEvent("SevenLife:SpotLight:ManuellToggel")
AddEventHandler(
    "SevenLife:SpotLight:ManuellToggel",
    function()
        local serverID = source
        TriggerClientEvent("SevenLife:PD:SpotToggel", -1, serverID)
    end
)

RegisterServerEvent("SevenLife:SpotLight:Manuell")
AddEventHandler(
    "SevenLife:SpotLight:Manuell",
    function()
        local serverID = source
        TriggerClientEvent("SevenLife:SpotLight:Change", -1, serverID)
    end
)
RegisterServerEvent("SevenLife:Light:up")
AddEventHandler(
    "SevenLife:Light:up",
    function()
        local serverID = source
        TriggerClientEvent("SevenLife:Light:up", -1, serverID)
    end
)

RegisterServerEvent("SevenLife:Light:down")
AddEventHandler(
    "SevenLife:Light:down",
    function()
        local serverID = source
        TriggerClientEvent("SevenLife:Light:down", -1, serverID)
    end
)

RegisterServerEvent("SevenLife:Radius:up")
AddEventHandler(
    "SevenLife:Radius:up",
    function()
        local serverID = source
        TriggerClientEvent("SevenLife:Radius:up", -1, serverID)
    end
)

RegisterServerEvent("SevenLife:Radius:Down")
AddEventHandler(
    "SevenLife:Radius:Down",
    function()
        local serverID = source
        TriggerClientEvent("SevenLife:Radius:down", -1, serverID)
    end
)
ESX.RegisterUsableItem(
    "tablet",
    function(source)
        local _source = source
        local date = os.date("%B %d %A")
        TriggerClientEvent("SevenLife:PD:TabletAusfuehren", _source, date)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:PD:GetPlayers",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM pd_player ",
            {},
            function(results)
                cb(results)
            end
        )
    end
)

RegisterServerEvent("SevenLife:PD:InsertPlayerIntoDatenBank")
AddEventHandler(
    "SevenLife:PD:InsertPlayerIntoDatenBank",
    function(url, vorname, nachname, nummer, desc)
        local _source = source
        local identifiers = ESX.GetPlayerFromId(source).identifier
        MySQL.Async.fetchAll(
            "SELECT firstname,lastname FROM users WHERE firstname = @firstname AND lastname = @lastname",
            {
                ["@firstname"] = vorname,
                ["@lastname"] = nachname
            },
            function(results)
                if results[1].firstname == vorname and results[1].lastname == nachname then
                    MySQL.Async.execute(
                        "INSERT INTO pd_player (identifier,vorname,nachname,number,description,url) VALUES (@identifier,@vorname, @nachname,@number,@description,@url)",
                        {
                            ["@identifier"] = identifiers,
                            ["@vorname"] = vorname,
                            ["@nachname"] = nachname,
                            ["@number"] = nummer,
                            ["@descriptionm"] = desc,
                            ["@url"] = url
                        },
                        function()
                            MySQL.Async.fetchAll(
                                "SELECT * FROM pd_player ",
                                {},
                                function(results)
                                    TriggerClientEvent("SevenLife:PD:UpdatePlayers", _source, results)
                                end
                            )
                        end
                    )
                else
                    TriggerClientEvent("SevenLife:PD:CloseMenuFehler", _source)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:PD:GetAkten",
    function(source, cb, name, vorname, nachame)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM pd_akten WHERE name = @name",
            {
                ["@name"] = name
            },
            function(results)
                MySQL.Async.fetchAll(
                    "SELECT firstname, lastname, dateofbirth FROM users WHERE name = @name",
                    {
                        ["@name"] = name
                    },
                    function(results1)
                        MySQL.Async.fetchAll(
                            "SELECT * FROM pd_player WHERE vorname = @vorname AND nachname = @nachname",
                            {
                                ["@vorname"] = vorname,
                                ["@nachname"] = nachame
                            },
                            function(results2)
                                cb(results, results1, results2)
                            end
                        )
                    end
                )
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:PD:GetEditPerson",
    function(source, cb, vorname, nachname)
        local _source = source
        MySQL.Async.fetchAll(
            "SELECT * FROM pd_player WHERE vorname = @vorname AND nachname = @nachname",
            {
                ["@vorname"] = vorname,
                ["@nachname"] = nachname
            },
            function(results)
                cb(results)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:PD:EditPerson",
    function(source, cb, vorname, nachname, number, desc, url)
        local _source = source
        MySQL.Async.execute(
            "UPDATE pd_player SET number = @number, description = @description, url = @url WHERE vorname = @vorname AND nachname = @nachname",
            {
                ["@vorname"] = vorname,
                ["@nachname"] = nachname,
                ["@number"] = number,
                ["@description"] = desc,
                ["@url"] = url
            },
            function()
                MySQL.Async.fetchAll(
                    "SELECT firstname, lastname, dateofbirth, phone_number FROM users WHERE name = @name",
                    {
                        ["@name"] = vorname .. " " .. nachname
                    },
                    function(results1)
                        MySQL.Async.fetchAll(
                            "SELECT * FROM pd_player WHERE vorname = @vorname AND nachname = @nachname",
                            {
                                ["@vorname"] = vorname,
                                ["@nachname"] = nachname
                            },
                            function(results2)
                                cb(true, results1, results2)
                            end
                        )
                    end
                )
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:PD:AddAkte",
    function(source, cb, name, titel, detail, geldstrafe, haftstrafe)
        local xPlayer = ESX.GetPlayerFromId(source)
        local id = xPlayer.identifier
        local date = os.date("%B %d %A")
        MySQL.Async.fetchAll(
            "SELECT name FROM users WHERE identifier = @identifier ",
            {
                ["@identifier"] = id
            },
            function(results2)
                MySQL.Async.execute(
                    "INSERT INTO pd_akten (name,titel, description, strafe, haftstrafe, datum,officer) VALUES ( @name, @titel, @description, @strafe, @haftstrafe, @datum, @officer)",
                    {
                        ["@name"] = name,
                        ["@titel"] = titel,
                        ["@description"] = detail,
                        ["@strafe"] = geldstrafe,
                        ["@haftstrafe"] = haftstrafe,
                        ["@datum"] = date,
                        ["@officer"] = results2[1].name
                    },
                    function()
                        cb(true)
                    end
                )
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:PD:GetAktenDateils",
    function(source, cb, name, id)
        MySQL.Async.fetchAll(
            "SELECT * FROM pd_akten WHERE name = @name AND id = @id ",
            {
                ["@name"] = name,
                ["@id"] = id
            },
            function(result)
                cb(result)
            end
        )
    end
)

RegisterServerEvent("SevenLife:PD:GetAllCars")
AddEventHandler(
    "SevenLife:PD:GetAllCars",
    function()
        local _source = source
        local results = {}
        MySQL.Async.fetchAll(
            "SELECT * FROM owned_vehicles ",
            {},
            function(result)
                for k, v in ipairs(result) do
                    if v.owner == "Mechaniker" or v.owner == "Police" then
                        v.name = v.owner
                        TriggerClientEvent("SevenLife:PD:AddCarsEinzel", _source, v.name, v.plate, v.versichert)
                    else
                        MySQL.Async.fetchAll(
                            "SELECT name FROM users WHERE identifier = @identifier",
                            {
                                ["@identifier"] = v.owner
                            },
                            function(result1)
                                v.name = result1[1].name

                                TriggerClientEvent("SevenLife:PD:AddCarsEinzel", _source, v.name, v.plate, v.versichert)
                            end
                        )
                    end
                end
            end
        )
    end
)
RegisterServerEvent("SevenLife:PD:InsertLizenzen")
AddEventHandler(
    "SevenLife:PD:InsertLizenzen",
    function()
        local _source = source
        local results = {}
        MySQL.Async.fetchAll(
            "SELECT * FROM seven_licenses ",
            {},
            function(result)
                for k, v in ipairs(result) do
                    MySQL.Async.fetchAll(
                        "SELECT name FROM users WHERE identifier = @identifier",
                        {
                            ["@identifier"] = v.identifier
                        },
                        function(result1)
                            v.name = result1[1].name
                            TriggerClientEvent(
                                "SevenLife:PD:InsertLizenzenIntoJS",
                                _source,
                                v.name,
                                v.driverID,
                                v.identifier
                            )
                        end
                    )
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:PD:GetDetailsLizenzen",
    function(source, cb, id)
        MySQL.Async.fetchAll(
            "SELECT * FROM seven_licenses WHERE identifier = @identifier",
            {
                ["@identifier"] = id
            },
            function(result1)
                cb(
                    result1[1].gunlicense,
                    result1[1].driverlicense,
                    result1[1].flylicense,
                    result1[1].bootlicense,
                    result1[1].lkwlicense,
                    result1[1].motorlicense,
                    result1[1].jadglicense
                )
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:PD:GetWohnorteUser",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local id = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT name, wohnort FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = id
            },
            function(result1)
                cb(result1)
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:PD:GetFahndungenData",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local id = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT id, name, titel FROM pd_fahndungen ",
            {},
            function(result1)
                cb(result1)
            end
        )
    end
)
RegisterServerEvent("SevenLife:PD:DeleteFahndung")
AddEventHandler(
    "SevenLife:PD:DeleteFahndung",
    function(name)
        MySQL.Async.execute(
            "DELETE FROM pd_fahndungen WHERE id = @id ",
            {
                ["@id"] = name
            },
            function()
            end
        )
    end
)

RegisterServerEvent("SevenLife:PD:AddFahndung")
AddEventHandler(
    "SevenLife:PD:AddFahndung",
    function(name, titel)
        local _source = source
        MySQL.Async.execute(
            "INSERT INTO pd_fahndungen (name,titel) VALUES (@name, @titel)",
            {
                ["@name"] = name,
                ["@titel"] = titel
            },
            function()
                TriggerClientEvent("SevenLife:PD:UpdateAll", _source)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "SevenLife:PD:Details",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM pd_eingestellte  ",
            {},
            function(result)
                cb(result)
            end
        )
    end
)

RegisterServerEvent("SevenLife:PD:SetLohn")
AddEventHandler(
    "SevenLife:PD:SetLohn",
    function(types, lohn)
        MySQL.Async.execute(
            "UPDATE job_grades SET salary = @salary WHERE name = @name",
            {
                ["@salary"] = lohn,
                ["@name"] = types
            },
            function()
            end
        )
    end
)

RegisterServerEvent("SevenLife:PD:Server:MakeAction")
AddEventHandler(
    "SevenLife:PD:Server:MakeAction",
    function(target)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.job.name == "police" then
            TriggerClientEvent("SevenLife:PD:HandCuff", target)
        end
    end
)
RegisterServerEvent("SevenLife:PD:Server:Tragen")
AddEventHandler(
    "SevenLife:PD:Server:Tragen",
    function(target)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.job.name == "police" then
            TriggerClientEvent("SevenLife:PD:Server:Tragen", target)
        end
    end
)
RegisterServerEvent("SevenLife:PD:GetVehicle")
AddEventHandler(
    "SevenLife:PD:GetVehicle",
    function(target)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.job.name == "police" then
            TriggerClientEvent("SevenLife:PD:GetVehicle", target)
        end
    end
)
RegisterServerEvent("SevenLife:PD:PutPlayerInJail")
AddEventHandler(
    "SevenLife:PD:PutPlayerInJail",
    function(id, haftzeit)
        print(id)
        print(source)
        if id ~= source and id ~= 0 then
            local xTarget = ESX.GetPlayerFromId(id)
            local xTargetid = xTarget.identifier
            local _source = source
            MySQL.Async.fetchAll(
                "SELECT identifier, haftzeit FROM pd_haftzeit ",
                {},
                function(result1)
                    if result1[1].identifier ~= xTargetid then
                        TriggerClientEvent("SevenLife:PD:ArrestPlayer", id, haftzeit)
                    else
                        TriggerClientEvent(
                            "SevenLife:TimetCustom:Notify",
                            "PD",
                            _source,
                            "Diese Person hat schon eine Haftzeit in höhe von " .. result1[1].haftzeit,
                            2000
                        )
                    end
                end
            )
        end
    end
)
ESX.RegisterServerCallback(
    "SevenLife:PD:CheckIfPlayerWasInJail",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local xPlayerid = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT haftzeit, besucher FROM pd_haftzeit WHERE identifier = @identifier",
            {
                ["@identifier"] = xPlayerid
            },
            function(result1)
                if result1[1] ~= nil then
                    cb(true, result1[1].haftzeit, result1[1].besucher)
                else
                    cb(false)
                end
            end
        )
    end
)

RegisterServerEvent("SevenLife:PD:InsertXP")
AddEventHandler(
    "SevenLife:PD:InsertXP",
    function()
        local xplayer = ESX.GetPlayerFromId(source)
        if xplayer ~= nil then
            MySQL.Async.fetchAll(
                "SELECT xp, level, skillpoints FROM skillsystem_level WHERE id = @id",
                {
                    ["@id"] = xplayer.identifier
                },
                function(result)
                    for k, v in pairs(Config.levels) do
                        if result[1].level == v.level then
                            local endproduct = result[1].xp + 0.1
                            if endproduct >= v.xp then
                                local endlevel = result[1].level + 1
                                MySQL.Async.execute(
                                    "UPDATE skillsystem_level SET xp = @xp , level = @level, skillpoints = @skillpoints WHERE id = @id",
                                    {
                                        ["@id"] = xplayer.identifier,
                                        ["@xp"] = 0,
                                        ["@level"] = endlevel,
                                        ["@skillpoints"] = result[1].skillpoints + 1
                                    },
                                    function()
                                        TriggerClientEvent("SevenLife:SkillTree:MakeLevelUpShowing", source, endlevel)
                                    end
                                )
                            else
                                MySQL.Async.execute(
                                    "UPDATE skillsystem_level SET xp = @xp WHERE id = @id",
                                    {
                                        ["@id"] = xplayer.identifier,
                                        ["@xp"] = endproduct
                                    },
                                    function()
                                    end
                                )
                            end
                        end
                    end
                end
            )
        end
    end
)
RegisterServerEvent("SevenLife:Gefeangnis:PayToPlayer")
AddEventHandler(
    "SevenLife:Gefeangnis:PayToPlayer",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney("money", 2)
    end
)
RegisterServerEvent("SevenLife:Gefeangnis:GiveItem")
AddEventHandler(
    "SevenLife:Gefeangnis:GiveItem",
    function(name, preis)
        local xPlayer = ESX.GetPlayerFromId(source)
        local money = xPlayer.getMoney()
        local _source = source
        if money >= tonumber(preis) then
            xPlayer.removeAccountMoney("money", tonumber(preis))
            xPlayer.addInventoryItem(name, 1)
        else
            TriggerClientEvent("SevenLife:TimetCustom:Notify", _source, "Gefängnis", "Du hast zu wenig Geld", 2000)
        end
    end
)
RegisterServerEvent("SevenLife:Gefeandnigs:DeletePlayer")
AddEventHandler(
    "SevenLife:Gefeandnigs:DeletePlayer",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local id = xPlayer.identifier
        MySQL.Async.execute(
            "DELETE FROM pd_haftzeit WHERE identifier = @identifier ",
            {
                ["@identifier"] = id
            },
            function()
                TriggerClientEvent(
                    "SevenLife:TimetCustom:Notify",
                    _source,
                    "Gefängnis",
                    "Du bist wurdest Erfolgreich aus dem Knast entlassen",
                    2000
                )
            end
        )
    end
)
RegisterServerEvent("SevenLife:PD:InsertBesucher")
AddEventHandler(
    "SevenLife:PD:InsertBesucher",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local id = xPlayer.identifier
        MySQL.Async.execute(
            "INSERT INTO pd_haftzeit (identifier,haftzeit, besucher) VALUES (@identifier, @haftzeit,@besucher)",
            {
                ["@identifier"] = id,
                ["@haftzeit"] = 100,
                ["@besucher"] = "true"
            },
            function()
            end
        )
    end
)
RegisterServerEvent("SevenLife:Gefeangnis:KickOutOfGefeangnis")
AddEventHandler(
    "SevenLife:Gefeangnis:KickOutOfGefeangnis",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        local id = xPlayer.identifier
        MySQL.Async.execute(
            "DELETE FROM pd_haftzeit WHERE identifier = @identifier ",
            {
                ["@identifier"] = id
            },
            function()
            end
        )
    end
)
ESX.RegisterServerCallback(
    "SevenLife:PD:GetActivPlayersPD",
    function(source, cb)
        cb(namesofcops)
    end
)
function InsertIntoPlayer(index, ingamename, name)
    namesofcops[index] = {
        ["ingamename"] = ingamename,
        ["job"] = name
    }
end

function InsertIntoStreife(index, ingamename, name, streife)
    StreifeListe[index] = {
        ["ingamename"] = ingamename,
        ["job"] = name,
        ["streife"] = streife
    }
end

ESX.RegisterServerCallback(
    "SevenLife:PD:GetStreifen",
    function(source, cb)
        cb(StreifeListe)
    end
)

ESX.RegisterServerCallback(
    "SevenLife:PD:InsertStreifen",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        local id = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT ingamename, name FROM pd_eingestellte WHERE nummer = @nummer ",
            {
                ["@nummer"] = id
            },
            function(result)
                for k, v in ipairs(StreifeListe) do
                    if v.ingamename == result[1].ingamename then
                        streifen = streifen + 1
                        v.streife = streifen
                        if streifen == 11 then
                            streifen = 1
                            v.streife = 1
                        end
                        cb(StreifeListe)
                    end
                end
            end
        )
    end
)
RegisterNetEvent("SevenLife:PD:CloseStreife")
AddEventHandler(
    "SevenLife:PD:CloseStreife",
    function(nummer)
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        local id = xPlayer.identifier

        for k, v in ipairs(StreifeListe) do
            if tonumber(v.streife) == tonumber(nummer) then
                v.streife = "eingeteilt"
            end
        end
        Citizen.Wait(100)
        TriggerClientEvent("SevenLife:PD:UpdateStreife", -1, StreifeListe)
    end
)

RegisterNetEvent("SevenLife:PD:InsertStreifePlayer")
AddEventHandler(
    "SevenLife:PD:InsertStreifePlayer",
    function(nummer)
        local xPlayer = ESX.GetPlayerFromId(source)
        local _source = source
        local id = xPlayer.identifier
        MySQL.Async.fetchAll(
            "SELECT ingamename, name FROM pd_eingestellte WHERE nummer = @nummer ",
            {
                ["@nummer"] = id
            },
            function(result)
                for k, v in ipairs(StreifeListe) do
                    if v.ingamename == result[1].ingamename then
                        v.streife = nummer
                    end
                end
            end
        )
        Citizen.Wait(100)
        TriggerClientEvent("SevenLife:PD:UpdateStreife", -1, StreifeListe)
    end
)

RegisterServerEvent("SevenLife:PD:MakeWarning")
AddEventHandler(
    "SevenLife:PD:MakeWarning",
    function(which, coords)
        if which == "Staatsbank" then
            TriggerClientEvent("SevenLife:PD:Warning1", -1)
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                -1,
                "Staats Bank",
                "Die StaatsBank wird gerade ausgeraubt. Bitte nähere dich nicht dem Tatort. Speerzone: 100m",
                3000
            )
        elseif which == "ATM" then
            TriggerClientEvent(
                "SevenLife:TimetCustom:Notify",
                -1,
                "ATM - Raub",
                "Ein ATM wird ausgeraubt. Nähere dich nicht dem Tatort! Speerzone: 100m",
                3000
            )
            TriggerClientEvent("SevenLife:PD:Warning2", -1, coords)
        end
    end
)
RegisterServerEvent("SevenLife:PD:MakeNotify")
AddEventHandler(
    "SevenLife:PD:MakeNotify",
    function()
        TriggerClientEvent(
            "SevenLife:TimetCustom:PoliceNotify",
            -1,
            "Das PD warnt vor einem ankommenden Transport Konvoi. Näherungen werden mit schüssen bestraft!"
        )
    end
)
