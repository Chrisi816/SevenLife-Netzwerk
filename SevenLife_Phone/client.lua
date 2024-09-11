local flugmodus
local gps
local push
local kontakte
local wifi
local wallpaper
local gresse
local linksrechts
local obenunten
local phone = false
local PlayerData = {}
ESX = nil
Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end
    end
)
RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(job)
        PlayerData.job = job
    end
)
local activehandy
local wait = 5000
Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        local player = GetPlayerPed(-1)
        while true do
            Citizen.Wait(1)
            if activehandy ~= true then
                if IsControlJustPressed(0, 288) then
                    ESX.TriggerServerCallback(
                        "SevenLife:Phone:CheckIfPlayerHaveHandyItem",
                        function(phone, haveapps)
                            if phone then
                                phone = true
                                activehandy = true
                                AnimPhone("text")
                                SetNuiFocus(true, true)

                                local time = GetTime()
                                SendNUIMessage(
                                    {
                                        type = "openhandy",
                                        time = time,
                                        result = haveapps
                                    }
                                )
                            else
                                TriggerEvent("SevenLife:TimetCustom:Notify", "Handy", "Du besitzt kein Handy", 2000)
                            end
                        end
                    )
                end
            end
        end
    end
)

function GetTime()
    local hour = GetClockHours()
    local minute = GetClockMinutes()

    local objekt = {}

    if minute <= 9 then
        minute = "0" .. minute
    end

    objekt.hour = hour
    objekt.minute = minute

    return objekt
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(wait)
            if activehandy then
                local time = GetTime()
                wait = 3000
                SendNUIMessage {
                    type = "UpdateTime",
                    time = time
                }
            end
        end
    end
)

RegisterNUICallback(
    "ClosePhone",
    function()
        AnimPhone("out")
        local player = GetPlayerPed(-1)
        activehandy = false
        SetNuiFocus(false, false)
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10000)
        TriggerServerEvent("SevenLife:Phone:GetEinstellungen")
    end
)

RegisterNetEvent("SevenLife:PhoneLogDaten")
AddEventHandler(
    "SevenLife:PhoneLogDaten",
    function(results, numberse)
        local infos = {}
        for key, value in pairs(results) do
            table.insert(infos, results[key])
        end
        flugmodus = results.flugmodus
        gps = results.gps
        kontakte = results.onlykontakte
        wifi = results.wlan
        wallpaper = results.wallpaper
        gresse = results.gresse
        linksrechts = results.linksrechts
        obenunten = results.oben
        push = results.push
        SendNUIMessage(
            {
                type = "update",
                result = results,
                nummer = numberse
            }
        )
    end
)

RegisterNUICallback(
    "flugmodus",
    function(data)
        flugmodus = data.flugmodus
        TriggerServerEvent("SevenLife:Phone:SafeEinstellungsdata", flugmodus, "flugmodus")
    end
)

RegisterNUICallback(
    "gps",
    function(data)
        gps = data.gps
        TriggerServerEvent("SevenLife:Phone:SafeEinstellungsdata", gps, "gps")
    end
)
RegisterNetEvent("SevenLife:Phone:SafeEinstellungenUpdate")
AddEventHandler(
    "SevenLife:Phone:SafeEinstellungenUpdate",
    function(item)
        push = item
        SendNUIMessage(
            {
                type = "updatepush",
                result = push
            }
        )
    end
)
RegisterNUICallback(
    "pushnachricht",
    function(data)
        push = data.push

        TriggerServerEvent("SevenLife:Phone:SafeEinstellungsdata", push, "push")
    end
)
RegisterNUICallback(
    "kontakte",
    function(data)
        kontakte = data.kontakte
        TriggerServerEvent("SevenLife:Phone:SafeEinstellungsdata", kontakte, "kontakte")
    end
)

RegisterNUICallback(
    "wifi",
    function(data)
        wifi = data.wifi
        TriggerServerEvent("SevenLife:Phone:SafeEinstellungsdata", wifi, "wifi")
    end
)

RegisterNUICallback(
    "wallpaper",
    function(data)
        wallpaper = data.wallpaper
        SendNUIMessage(
            {
                type = "Messageincoming",
                pictureurl = "../src/appsymbols/Einstellungen.png",
                titel = "Nachricht - Einste...",
                beschreibung = "Hintergrund erfolgreich verändert"
            }
        )
        TriggerServerEvent("SevenLife:Phone:SafeEinstellungsdata", wallpaper, "wallpaper")
    end
)
RegisterNUICallback(
    "linksrechts",
    function(data)
        linksrechts = data.linksrechts
        SendNUIMessage(
            {
                type = "Messageincoming",
                pictureurl = "../src/appsymbols/Einstellungen.png",
                titel = "Nachricht - Einste...",
                beschreibung = "Einstellung verändert"
            }
        )
        TriggerServerEvent("SevenLife:Phone:SafeEinstellungsdata", linksrechts, "linksrechts")
    end
)
RegisterNUICallback(
    "obenunten",
    function(data)
        SendNUIMessage(
            {
                type = "Messageincoming",
                pictureurl = "../src/appsymbols/Einstellungen.png",
                titel = "Nachricht - Einste...",
                beschreibung = "Einstellung verändert"
            }
        )
        obenunten = data.obenunten
        TriggerServerEvent("SevenLife:Phone:SafeEinstellungsdata", obenunten, "obenunten")
    end
)
RegisterNUICallback(
    "gresse",
    function(data)
        SendNUIMessage(
            {
                type = "Messageincoming",
                pictureurl = "../src/appsymbols/Einstellungen.png",
                titel = "Nachricht - Einste...",
                beschreibung = "Einstellung verändert"
            }
        )
        gresse = data.gresse
        TriggerServerEvent("SevenLife:Phone:SafeEinstellungsdata", gresse, "gresse")
    end
)

RegisterNetEvent("SevenLife:Phone:GenerateNumber")
AddEventHandler(
    "SevenLife:Phone:GenerateNumber",
    function()
        local random = GetRandomNumber(6)
        newnumber = 02305 .. "-" .. random
        cleannumber = 02305 .. random
        ESX.TriggerServerCallback(
            "sevenlife:nummer",
            function(nummer)
                if not nummer then
                    TriggerServerEvent("SevenLife:Phone:GiveNumber", newnumber, cleannumber)
                else
                    TriggerEvent("SevenLife:Phone:GenerateNumber")
                end
            end,
            newnumber
        )
    end
)
local NumberCharset = {}
local Charset = {}
for i = 48, 57 do
    table.insert(NumberCharset, string.char(i))
end

for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

function GetRandomNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ""
    end
end

RegisterNetEvent("SevenLife:Phone:SetDataToPhone")
AddEventHandler(
    "SevenLife:Phone:SetDataToPhone",
    function(nummer)
        SendNUIMessage(
            {
                type = "updatenummer",
                nummer = nummer
            }
        )
    end
)
RegisterNUICallback(
    "lifeinvaderaccountcreate",
    function(data)
        TriggerServerEvent("SevenLife:LifeInvader:CreateAccount", data.icon, data.benutzer, data.passwort)
    end
)

RegisterNUICallback(
    "getlifeinvaderwerbung",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Lifeinvader:Werbung",
            function(result)
                SendNUIMessage(
                    {
                        type = "lifeinvaderwerbung",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "haveplayeranlifeinvaderaccount",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Lifeinvader:HaveAccount",
            function(haveanaccount)
                if haveanaccount == false then
                    SendNUIMessage({type = "OpenRegister"})
                end
            end
        )
    end
)

RegisterNUICallback(
    "sendnachricht",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Lifeinvader:GetNameOfPerson",
            function(name)
                if data.status == 1 then
                    benutzername = name
                else
                    benutzername = "Anonym"
                end
                TriggerServerEvent(
                    "SevenLife:Lifeinvader:SendNachricht",
                    data.inachrichtcon,
                    data.titel,
                    benutzername,
                    data.statuses
                )
            end
        )
    end
)
RegisterNUICallback(
    "AccountCryptoAnmelde",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Crypto:CheckIfAccountExists",
            function(exist)
                if exist then
                    ESX.TriggerServerCallback(
                        "SevenLife:Crypto:CheckInfos",
                        function(infos)
                            Citizen.Wait(1500)
                            SendNUIMessage(
                                {
                                    type = "opendashboard",
                                    name = infos[1].benutzername,
                                    btc = infos[1].btc,
                                    eth = infos[1].eth,
                                    key = infos[1].key
                                }
                            )
                        end
                    )
                else
                    Citizen.Wait(1500)
                    SendNUIMessage(
                        {
                            type = "DontAccount"
                        }
                    )
                end
            end,
            data.benutzer,
            data.passwort
        )
    end
)
local NumberCharset = {}
local Charset = {}
for i = 48, 57 do
    table.insert(NumberCharset, string.char(i))
end

for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end
RegisterNUICallback(
    "CryptonicCreateAccount",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Crypto:CheckIfAccountExists",
            function(exist)
                if exist then
                    SendNUIMessage(
                        {
                            type = "duhastschonnenacc"
                        }
                    )
                else
                    local id = Key()
                    Citizen.Wait(3000)
                    TriggerServerEvent("SevenLife:Crypto:RegisterAccount", data.benutzer, data.passwort, id)
                end
            end,
            data.benutzer,
            data.passwort
        )
    end
)
function Key()
    local MakeID
    local doBreaks = false

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())

        MakeID = string.upper(GetRandomVhehicleIDLetter(10) .. GetRandomVehicleIDNumber(10))

        ESX.TriggerServerCallback(
            "SevenLife:IsKeyTaken",
            function(isidtaken)
                if not isidtaken then
                    doBreaks = true
                end
            end,
            MakeID
        )

        if doBreaks then
            break
        end
    end

    return MakeID
end

function GetRandomVehicleIDNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomVehicleIDNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ""
    end
end

function GetRandomVhehicleIDLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomVhehicleIDLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ""
    end
end

RegisterNetEvent("SevenLife:Crypto:OpenLogin")
AddEventHandler(
    "SevenLife:Crypto:OpenLogin",
    function()
        SendNUIMessage(
            {
                type = "openlogin"
            }
        )
    end
)
RegisterNUICallback(
    "transferbtc",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Crypto:CeckWallet",
            function(exists)
                local wallet = data.wallet
                if exists then
                    ESX.TriggerServerCallback(
                        "SevenLife:Crypto:CheckIfPlayerHaveAmmount",
                        function(haveammount)
                            local amount = data.cash
                            if haveammount then
                                TriggerServerEvent("SevenLife:Crypto:TransferCrypto", "btc", wallet, amount)
                            else
                                SendNUIMessage(
                                    {
                                        type = "zuwenigcash"
                                    }
                                )
                            end
                        end,
                        data.cash,
                        "btc"
                    )
                else
                    SendNUIMessage(
                        {
                            type = "walletdidintexists"
                        }
                    )
                end
            end,
            data.wallet
        )
    end
)
RegisterNUICallback(
    "transfereth",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Crypto:CeckWallet",
            function(exists)
                local wallet = data.wallet
                if exists then
                    ESX.TriggerServerCallback(
                        "SevenLife:Crypto:CheckIfPlayerHaveAmmount",
                        function(haveammount)
                            local amount = data.cash
                            if haveammount then
                                TriggerServerEvent("SevenLife:Crypto:TransferCrypto", "eth", wallet, amount)
                            else
                                SendNUIMessage(
                                    {
                                        type == "zuwenigcash"
                                    }
                                )
                            end
                        end,
                        data.cash,
                        "eth"
                    )
                else
                    SendNUIMessage(
                        {
                            type = "walletdidintexists"
                        }
                    )
                end
            end,
            data.wallet
        )
    end
)
RegisterNUICallback(
    "transferseven",
    function(data)
        SendNUIMessage(
            {
                type == "zuwenigcash"
            }
        )
    end
)

RegisterNetEvent("SevenLife:Cryptos:Erfolgreichertransfer")
AddEventHandler(
    "SevenLife:Cryptos:Erfolgreichertransfer",
    function(nachricht)
        SendNUIMessage(
            {
                type = "erfolgtransfer",
                nachricht = nachricht
            }
        )
    end
)
RegisterNUICallback(
    "GetPhoneBankData",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:BankPhone:CheckIfPlayerHaveBank",
            function(data)
                if data == false then
                    SendNUIMessage(
                        {
                            type = "Messageincoming",
                            pictureurl = "../src/appsymbols/bankAmerica.png",
                            titel = "Nachricht - Bank",
                            beschreibung = "Du besitzt kein Bankkonto"
                        }
                    )
                else
                    SendNUIMessage(
                        {
                            type = "openbankapp",
                            cash = data
                        }
                    )
                end
            end
        )
    end
)

RegisterNUICallback(
    "transfer",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:BankPhone:CheckIfPlayerHaveEnoughMoney",
            function(enoughmoney)
                if enoughmoney then
                    ESX.TriggerServerCallback(
                        "SevenLife:BankPhone:CheckifIbanExist",
                        function(ibanexist)
                            if ibanexist then
                                TriggerServerEvent("SevenLife:PhoneBank:Transferdata", data.anzahl, data.iban)
                            else
                                SendNUIMessage(
                                    {
                                        type = "Messageincoming",
                                        pictureurl = "../src/appsymbols/bankAmerica.png",
                                        titel = "Nachricht - Bank",
                                        beschreibung = "Angegebene Iban nicht gefunden"
                                    }
                                )
                            end
                        end,
                        data.iban
                    )
                else
                    SendNUIMessage(
                        {
                            type = "Messageincoming",
                            pictureurl = "../src/appsymbols/bankAmerica.png",
                            titel = "Nachricht - Bank",
                            beschreibung = "Sie besitzen zu wenig Geld"
                        }
                    )
                end
            end,
            data.anzahl
        )
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10000)
        while true do
            Citizen.Wait(10000)
            TriggerServerEvent("SevenLife:CheckIfMoneyTransfer")
        end
    end
)
RegisterNetEvent("SevenLife:Handy:Message")
AddEventHandler(
    "SevenLife:Handy:Message",
    function(img, nachricht, beschreibung)
        SendNUIMessage(
            {
                type = "Messageincoming",
                pictureurl = img,
                titel = nachricht,
                beschreibung = beschreibung
            }
        )
    end
)

RegisterNUICallback(
    "GetBilldata",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:BillApp:GetBillData",
            function(data)
                SendNUIMessage(
                    {
                        type = "OpenBill",
                        data = data
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "PayBillID",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:BillApp:CheckBillCash",
            function(enoghmoney)
            end,
            data.id
        )
    end
)

RegisterNUICallback(
    "SevenLife:Handy:Update",
    function(data)
        SendNUIMessage(
            {
                type = "UpdateBill",
                data = data
            }
        )
    end
)
RegisterNUICallback(
    "MakeAnfruf",
    function()
    end
)

RegisterNUICallback(
    "MakeSevenDrop",
    function(data)
        local number = data.number
        ESX.TriggerServerCallback(
            "SevenLife:Phone:DropName",
            function(name)
                local number = number:gsub("%-", "")
                local ped = GetPlayerPed(-1)
                local coords = GetEntityCoords(ped)
                local player = ESX.Game.GetClosestPlayer(coords)
                TriggerServerEvent("SevenLife:Handy:MakeDrop", GetPlayerServerId(player), data.number, name)
            end,
            data.number
        )
    end
)

RegisterNetEvent("SevenLife:OpenEinspeicherMenu:Oppesite")
AddEventHandler(
    "SevenLife:OpenEinspeicherMenu:Oppesite",
    function(nummer, name)
        SendNUIMessage(
            {
                type = "OpenDropMenu",
                nummer = nummer,
                name = name
            }
        )
    end
)

RegisterNUICallback(
    "GarageMakeRoute",
    function(data)
        for k, v in pairs(Config.garages) do
            if tonumber(v.garage) == tonumber(data.garage) then
                local blips = vector2(v.x, v.y)
                local blip = AddBlipForCoord(blips.x, blips.y)

                SetBlipSprite(blip, 390)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipColour(blip, 83)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Garage: " .. v.garage)
                EndTextCommandSetBlipName(blip)
                SetBlipRoute(blip, true)

                SendNUIMessage(
                    {
                        type = "Messageincoming",
                        pictureurl = "../src/appsymbols/garage.png",
                        titel = "Nachricht - Garage",
                        beschreibung = "Wegpunkt erfolgreich gesetzt"
                    }
                )

                Citizen.Wait(7000)
                ClearAllBlipRoutes()
                RemoveBlip(blip)
            end
        end
    end
)

RegisterNUICallback(
    "GetCarsAndLocation",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetVehicles",
            function(results)
                for _, v in pairs(results) do
                    local hash = v.vehicle.model
                    local vehname = GetDisplayNameFromVehicleModel(hash)
                    local labelname = GetLabelText(vehname)
                    local garage = v.garage
                    addGarage(garage, v.fuel, labelname)
                end
            end
        )
    end
)

function addGarage(garage, fuel, labelname)
    SendNUIMessage(
        {
            type = "MakeGarage",
            garage = garage,
            fuel = fuel,
            labelname = labelname
        }
    )
end

RegisterNUICallback(
    "MakeContakt",
    function(data)
        TriggerServerEvent("SevenLife:Phone:MakeContakt", data.name, data.nummer, data.bio, data.url)
    end
)

RegisterNUICallback(
    "GetAppDataShopping",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:AppData",
            function(result, downloaded, downloadedapps)
                if downloaded then
                    SendNUIMessage(
                        {
                            type = "OpenAppStore",
                            result = result,
                            apps = Config.Apps,
                            resultapp = downloadedapps
                        }
                    )
                else
                    SendNUIMessage(
                        {
                            type = "FirstTimeOpenAppStore",
                            result = result,
                            apps = Config.Apps
                        }
                    )
                end
            end
        )
    end
)
RegisterNUICallback(
    "DownLoadApp",
    function(data)
        TriggerServerEvent("SevenLife:Phone:InsertDownLoadApp", data.name)
    end
)
RegisterNUICallback(
    "DeleteApp",
    function(data)
        TriggerServerEvent("SevenLife:Phone:DeleteApp", data.name)
    end
)

RegisterNUICallback(
    "GetActivDispatches",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetActicDispatches",
            function(ready, result)
                if ready then
                    SendNUIMessage(
                        {
                            type = "OpenDispatchApp",
                            result = result
                        }
                    )
                end
            end
        )
    end
)

RegisterNUICallback(
    "SendDispatch",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        TriggerServerEvent("SevenLife:Phone:InsertDispatchDB", data.frak, data.titel, data.desc, coords)

        if data.frak == "LSPD" then
        elseif data.frak == "LSMC" then
        elseif data.frak == "Mechanic" then
        end
    end
)
RegisterNUICallback(
    "GetNotizen",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetNotizen",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenNotizenApp",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "DeletNotizen",
    function(data)
        TriggerServerEvent("SevenLife:Phone:DeleteNotiz", data.id)
    end
)
RegisterNUICallback(
    "NewNotiz",
    function()
        TriggerServerEvent("SevenLife:Phone:AddNotiz")
    end
)
RegisterNetEvent("SevenLife:Phone:UpdateNotiz")
AddEventHandler(
    "SevenLife:Phone:UpdateNotiz",
    function(result)
        SendNUIMessage(
            {
                type = "UpdateNotiz",
                result = result
            }
        )
    end
)
RegisterNUICallback(
    "SaveList",
    function(data)
        TriggerServerEvent("SevenLife:Phone:SaveList", data.id, data.beschreibung, data.titel)
    end
)

-- Local anim and Prop
local phoneModel = "prop_amb_phone"
local phoneProp, lastDict, lastAnim, currentStatus = 0, nil, nil, "out"

local ANIMATION = {
    ["cellphone@"] = {
        ["out"] = {
            ["text"] = "cellphone_text_in",
            ["call"] = "cellphone_call_listen_base"
        },
        ["text"] = {
            ["out"] = "cellphone_text_out",
            ["text"] = "cellphone_text_in",
            ["call"] = "cellphone_text_to_call"
        },
        ["call"] = {
            ["out"] = "cellphone_call_out",
            ["text"] = "cellphone_call_to_text",
            ["call"] = "cellphone_text_to_call"
        }
    },
    ["anim@cellphone@in_car@ps"] = {
        ["out"] = {
            ["text"] = "cellphone_text_in",
            ["call"] = "cellphone_call_in"
        },
        ["text"] = {
            ["out"] = "cellphone_text_out",
            ["text"] = "cellphone_text_in",
            ["call"] = "cellphone_text_to_call"
        },
        ["call"] = {
            ["out"] = "cellphone_horizontal_exit",
            ["text"] = "cellphone_call_to_text",
            ["call"] = "cellphone_text_to_call"
        }
    }
}

function AnimPhone(status)
    local ped = PlayerPedId()

    GiveWeaponToPed(ped, 0xA2719263, 0, 0, 1)

    local dict = "cellphone@"
    if IsPedInAnyVehicle(ped, false) then
        dict = "anim@cellphone@in_car@ps"
    end

    loadAnim(dict)

    local anim = ANIMATION[dict][currentStatus][status]

    TaskPlayAnim(ped, dict, anim, 3.0, -1, -1, 50, 0, false, false, false)

    if status ~= "out" and currentStatus == "out" then
        Citizen.Wait(380)
        newPhoneProp(ped)
    end

    lastDict = dict
    lastAnim = anim
    currentStatus = status
    if status == "out" then
        Citizen.Wait(180)
        deletePhone()
        StopAnimTask(ped, lastDict, lastAnim, 1.0)
    end
end

function loadAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(1)
    end
end

function newPhoneProp(ped)
    deletePhone()
    RequestModel(phoneModel)
    while not HasModelLoaded(phoneModel) do
        Citizen.Wait(500)
    end
    phoneProp = CreateObject(GetHashKey(phoneModel), 1.0, 1.0, 1.0, 1, 1, 0)

    local bone = GetPedBoneIndex(ped, 28422)
    AttachEntityToEntity(phoneProp, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
end

function deletePhone()
    if phoneProp ~= 0 then
        Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(phoneProp))
        phoneProp = 0
    end
end

function FrontCamera(activate)
    return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end
RegisterNUICallback(
    "MakeLight",
    function()
        local ped = GetPlayerPed(-1)
        local state = IsFlashLightOn(ped)

        local coords = GetEntityCoords(ped)
        while true do
            Citizen.Wait(1)
            DrawSpotLight(coords.x, coords.y, coords.z + 1, 0, 0, 0, 221, 221, 221, 70.0, 50.0, 4.3, 25.0, 28.6)
        end
    end
)

RegisterNUICallback(
    "UmdrehenPhoto",
    function()
        frontCam = not frontCam
        FrontCamera(frontCam)
    end
)
RegisterNUICallback(
    "TakePhoto",
    function()
        SetNuiFocus(false, false)
        CreateMobilePhone(1)
        CellCamActivate(true, true)
        takePhoto = true
        while takePhoto do
            if IsControlJustPressed(1, 27) then
                frontCam = not frontCam
                FrontCamera(frontCam)
            elseif IsControlJustPressed(1, 177) then
                DestroyMobilePhone()
                CellCamActivate(false, false)
                OpenHandy()
                takePhoto = false
                break
            elseif IsControlJustPressed(1, 176) then
                exports["screenshot-basic"]:requestScreenshotUpload(
                    "https://discord.com/api/webhooks/1067531327127158825/2P5Iyig-fEJ-gkbEmCXhjLvU9Um6wOndiT5sBRgchtY0RPfdR7oVHvXcLaBH76Wwv4PF",
                    "files[]",
                    function(data)
                        local image = json.decode(data)
                        DestroyMobilePhone()
                        CellCamActivate(false, false)
                        TriggerServerEvent("SevenLife:Phone:AddToGalerry", image.attachments[1].proxy_url)
                        Citizen.Wait(400)
                        print(image.attachments[1].proxy_url)
                        SendNUIMessage(
                            {
                                type = "MakePhoto",
                                url = image.attachments[1].proxy_url
                            }
                        )
                        OpenHandy()
                    end
                )

                takePhoto = false
            end
            HideHudComponentThisFrame(7)
            HideHudComponentThisFrame(8)
            HideHudComponentThisFrame(9)
            HideHudComponentThisFrame(6)
            HideHudComponentThisFrame(19)
            HideHudAndRadarThisFrame()
            EnableAllControlActions(0)
            Citizen.Wait(1)
        end
    end
)

function OpenHandy()
    ESX.TriggerServerCallback(
        "SevenLife:Phone:CheckIfPlayerHaveHandyItem",
        function(phone, haveapps)
            if phone then
                phone = true
                activehandy = true
                AnimPhone("text")
                SetNuiFocus(true, true)

                local time = GetTime()
                SendNUIMessage(
                    {
                        type = "openhandy",
                        time = time,
                        result = haveapps
                    }
                )
            else
                TriggerEvent("SevenLife:TimetCustom:Notify", "Handy", "Du besitzt kein Handy", 2000)
            end
        end
    )
end
RegisterNUICallback(
    "GalerieOpen",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetPhotos",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenGalerie",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "MakeItBigger",
    function(data)
        SendNUIMessage(
            {
                type = "OpenDetail",
                datum = data.datum,
                src = data.src
            }
        )
    end
)
RegisterNUICallback(
    "DeleteIMG",
    function(data)
        TriggerServerEvent("SevenLife:Phone:DeleteIMG", data.src)
    end
)
RegisterNetEvent("SevenLife:IMG:Update")
AddEventHandler(
    "SevenLife:IMG:Update",
    function()
        Citizen.Wait(300)
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetPhotos",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenGalerie",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "SevenDropIMG",
    function(data)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer(coords)

        TriggerServerEvent("SevenLife:Phone:SevenDropIMG", GetPlayerServerId(closestPlayer), data.src)
    end
)
RegisterNetEvent("SevenLife:Phone:SevenDropIMG:Target")
AddEventHandler(
    "SevenLife:Phone:SevenDropIMG:Target",
    function(src)
        SendNUIMessage(
            {
                type = "OpenSevenDropIMG",
                src = src
            }
        )
    end
)
RegisterNUICallback(
    "InsertIMG",
    function(data)
        TriggerServerEvent("SevenLife:Phone:InsertIMG", data.src)
    end
)
RegisterNUICallback(
    "GetKontakte",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetKontakte",
            function(result)
                SendNUIMessage(
                    {
                        type = "InsertKontakte",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "InsertKontakt",
    function(data)
        TriggerServerEvent("SevenLife:Phone:InsertNummer", data.nummer, data.name)
    end
)
RegisterNUICallback(
    "GetKontakteForAdd",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetKontakteOnPhone",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateKontaktList",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "InsertNewChat",
    function(data)
        TriggerServerEvent("SevenLife:Phone:MakeNewChat", data.id)
    end
)
RegisterNetEvent("SevenLife:Phone:OpenMessageSite")
AddEventHandler(
    "SevenLife:Phone:OpenMessageSite",
    function(chatmessagesinfo, chatinfo)
        local src
        if chatinfo[1].profilbild ~= nil and not isempty(chatinfo[1].profilbild) then
            src = chatinfo[1].profilbild
        else
            src = "../src/tools/13547334191038217.png"
        end
        SendNUIMessage(
            {
                type = "OpenMessagingSiteFirst",
                id = chatmessagesinfo[1].idchat,
                nummer = chatinfo[1].telefonnummer,
                profilbild = chatinfo[1].profilbild,
                firstnachricht = chatmessagesinfo[1].firstnachricht,
                nachricht = chatmessagesinfo[1].message,
                result = chatmessagesinfo,
                identifier = chatmessagesinfo[1].identifier,
                name = chatinfo[1].name,
                src = src
            }
        )
    end
)
RegisterNUICallback(
    "InsertNewNachricht",
    function(data)
        TriggerServerEvent("SevenLife:Phone:InsertNewNachricht", data.id, data.chat)
    end
)
RegisterNetEvent("SevenLife:Phone:UpdateMessageSite")
AddEventHandler(
    "SevenLife:Phone:UpdateMessageSite",
    function(chatmessagesinfo, chatinfo, identifier)
        SendNUIMessage(
            {
                type = "UpdateMessageFirst",
                id = chatinfo[1].idchat,
                nummer = chatinfo[1].telefonnummer,
                profilbild = chatinfo[1].profilbild,
                firstnachricht = chatinfo[1].firstnachricht,
                nachricht = chatmessagesinfo[1].nachricht,
                result = chatmessagesinfo,
                identifier = identifier
            }
        )
    end
)
RegisterNUICallback(
    "GetChats",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetChats",
            function(result)
                SendNUIMessage(
                    {
                        type = "InsertChatsLike",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "OpenChat",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetChatsID",
            function(chatmessagesinfo, chatinfo, identifier)
                local src

                if chatinfo[1].profilbild ~= nil and not isempty(chatinfo[1].profilbild) then
                    src = chatinfo[1].profilbild
                else
                    src = "../src/tools/13547334191038217.png"
                end

                SendNUIMessage(
                    {
                        type = "OpenChatsMaking",
                        result = chatmessagesinfo,
                        name = chatinfo[1].name,
                        src = src,
                        identifier = identifier,
                        id = chatinfo[1].idchat
                    }
                )
            end,
            data.id
        )
    end
)

function isempty(s)
    return s == nil or s == "" or s == " "
end
RegisterNetEvent("SevenLife:Phone:UpdateMessageList")
AddEventHandler(
    "SevenLife:Phone:UpdateMessageList",
    function(chatinfo, chatmessagesinfo, identifier)
        SendNUIMessage(
            {
                type = "UpdateMessageFirst",
                id = chatinfo[1].idchat,
                nummer = chatinfo[1].telefonnummer,
                profilbild = chatinfo[1].profilbild,
                firstnachricht = chatinfo[1].firstnachricht,
                nachricht = chatmessagesinfo[1].nachricht,
                result = chatmessagesinfo,
                identifier = identifier
            }
        )
    end
)
RegisterNUICallback(
    "InsertImages",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetPhotos",
            function(result)
                SendNUIMessage(
                    {
                        type = "InsertSendList",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "SendImage",
    function(data)
        TriggerServerEvent("SevenLife:Phone:SendImage", data.id, data.url)
    end
)
RegisterNetEvent("SevenLife:Phone:UpdateKontaktList")
AddEventHandler(
    "SevenLife:Phone:UpdateKontaktList",
    function(result)
        SendNUIMessage(
            {
                type = "UpdateChatLike",
                result = result
            }
        )
    end
)
RegisterNUICallback(
    "GetDataForStory",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetDataStorys",
            function(result, name)
                SendNUIMessage(
                    {
                        type = "UpdateStorys",
                        result = result,
                        name = name
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "SendImageIntoStory",
    function(data)
        TriggerServerEvent("SevenLife:Phone:InsertNewStory", data.id, data.url)
    end
)
RegisterNUICallback(
    "GetPhotosForApp",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetPhotos",
            function(result)
                SendNUIMessage(
                    {
                        type = "InsertSendList2",
                        result = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "OpenStatus",
    function(data)
        SendNUIMessage(
            {
                type = "OpenStory",
                src = data.src
            }
        )
        local storydur = 10
        local activestory = true
        local dur = 0
        Citizen.CreateThread(
            function()
                while activestory do
                    Citizen.Wait(500)
                    dur = dur + 0.5
                    if dur == storydur then
                        SendNUIMessage(
                            {
                                type = "RemoveStory"
                            }
                        )
                        activestory = false
                    else
                        SendNUIMessage(
                            {
                                type = "UpdateBar"
                            }
                        )
                    end
                end
            end
        )
    end
)
local incall = false
RegisterNUICallback(
    "StartCall",
    function(data)
        SendNUIMessage(
            {
                type = "OpenAnsichtSelber",
                serverId = GetPlayerServerId(PlayerId())
            }
        )
        local frontCam = true
        incall = true
        Called = true
        CreateMobilePhone(4)
        CellCamActivate(true, true)
        Citizen.InvokeNative(0x2491A93618B7D838, true)
        Citizen.CreateThread(
            function()
                while Called do
                    Citizen.Wait(5)

                    if IsControlJustPressed(1, 27) then
                        frontCam = not frontCam
                        Citizen.InvokeNative(0x2491A93618B7D838, false)
                    end
                end
            end
        )
        TriggerServerEvent("SevenLife:Phone:CallSomebody", data.nummer)
    end
)
RegisterNUICallback(
    "startCallId",
    function(data)
        TriggerServerEvent("nakres_videocall:sendCall", data.id)
    end
)
RegisterNetEvent("nakres_videocall:sendCall")
AddEventHandler(
    "nakres_videocall:sendCall",
    function(id)
        SendNUIMessage(
            {
                type = "answer",
                serverId = id
            }
        )
    end
)

RegisterNUICallback(
    "sendData",
    function(data)
        TriggerServerEvent("SevenLife:Phone::sendData", data)
    end
)

RegisterNetEvent("nakres_videocall:sendData")
AddEventHandler(
    "nakres_videocall:sendData",
    function(data)
        SendNUIMessage(
            {
                data = data,
                type = "sendData"
            }
        )
    end
)
RegisterNUICallback(
    "StopCall",
    function()
        Called = false
        DestroyMobilePhone()
        CellCamActivate(false, false)
        OpenHandy()
    end
)
RegisterNUICallback(
    "JoinFunk",
    function(data)
        local getPlayerRadioChannel = exports["saltychat"]:GetRadioChannel(true)
        if tonumber(data.radioid) ~= tonumber(getPlayerRadioChannel) then
            if tonumber(data.radioid) <= Config.RestrictedChannels then
                if
                    (PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or
                        PlayerData.job.name == "mechaniker")
                 then
                    exports["saltychat"]:SetRadioChannel(data.radioid, true)

                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Phone",
                        "Du bist diesem Funk beigetreten!" .. data.radioid .. " MHz",
                        3000
                    )
                    TriggerServerEvent("SevenLife:Phone:SaveFunk", data.radioid)
                elseif
                    not (PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or
                        PlayerData.job.name == "mechaniker")
                 then
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Phone",
                        "Du kannst in diesem Funk kanal nicht beitreten da er Verschlüsselt ist!",
                        3000
                    )
                end
            end
            if tonumber(data.radioid) > Config.RestrictedChannels then
                exports["saltychat"]:SetRadioChannel(data.radioid, true)

                TriggerEvent(
                    "SevenLife:TimetCustom:Notify",
                    "Phone",
                    "Du bist diesem Funk beigetreten!" .. data.radioid .. " MHz",
                    3000
                )
                TriggerServerEvent("SevenLife:Phone:SaveFunk", data.radioid)
            end
        else
            TriggerEvent("SevenLife:TimetCustom:Notify", "Phone", "Du bist bereits in diesem Funk!", 3000)
        end
    end
)
RegisterNetEvent("SevenLife:Phone:UpdateFunkChannels")
AddEventHandler(
    "SevenLife:Phone:UpdateFunkChannels",
    function(result)
        SendNUIMessage(
            {
                type = "UpdateChannel",
                result = result
            }
        )
    end
)
RegisterNUICallback(
    "GetDataForRadio",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetHistoryFunk",
            function(funk)
                SendNUIMessage(
                    {
                        type = "OpenAppFunk",
                        funk = funk
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "GetIfPlayerIsInBusiness",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:CheckIfInBusiness",
            function(result, results, yourselfadmin)
                if result then
                    SendNUIMessage(
                        {
                            type = "OpenBusinessMenuMain",
                            id = results[1].id,
                            code = results[1].code,
                            yourselfadmin = yourselfadmin,
                            infos = results
                        }
                    )
                else
                    SendNUIMessage(
                        {
                            type = "OpenBusinessNoBusiness"
                        }
                    )
                end
            end
        )
    end
)
RegisterNUICallback(
    "RemovePlayerFromBusiness",
    function(data)
        TriggerServerEvent("SevenLife:Phone:DeletePlayerFromBusiness", data.id)
    end
)
RegisterNUICallback(
    "InsertPlayerIntoBusiness",
    function(data)
        TriggerServerEvent("SevenLife:Phone:InsertPlayerIntoBusiness", data.id)
    end
)
RegisterNUICallback(
    "AskForUpdate",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:CheckIfInBusiness",
            function(result, results, yourselfadmin)
                if result then
                    SendNUIMessage(
                        {
                            type = "OpenBusinessMenuMainUpdate",
                            id = results[1].id,
                            code = results[1].code,
                            yourselfadmin = yourselfadmin,
                            infos = results
                        }
                    )
                else
                    SendNUIMessage(
                        {
                            type = "OpenBusinessNoBusiness"
                        }
                    )
                end
            end
        )
    end
)
RegisterNUICallback(
    "AskForUpdateChat",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetNachrichten",
            function(result, identifier)
                SendNUIMessage(
                    {
                        type = "InsertChatVerlauf",
                        chat = result,
                        identifier = identifier
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "InsertNewNachrichtBusiness",
    function(data)
        TriggerServerEvent("SevenLife:Phone:InsertNewNachrichtBusiness", data.id, data.chat)
    end
)
RegisterNetEvent("SevenLife:Phone:OpenPageBusiness")
AddEventHandler(
    "SevenLife:Phone:OpenPageBusiness",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:CheckIfInBusiness",
            function(result, results, yourselfadmin)
                if result then
                    SendNUIMessage(
                        {
                            type = "OpenBusinessMenuMain",
                            id = results[1].id,
                            code = results[1].code,
                            yourselfadmin = yourselfadmin,
                            infos = results
                        }
                    )
                else
                    SendNUIMessage(
                        {
                            type = "OpenBusinessNoBusiness"
                        }
                    )
                end
            end
        )
    end
)
RegisterNetEvent("SevenLife:Phone:InsertUpdatetNachricht")
AddEventHandler(
    "SevenLife:Phone:InsertUpdatetNachricht",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Phone:GetNachrichten",
            function(result, identifier)
                SendNUIMessage(
                    {
                        type = "InsertChatVerlauf",
                        chat = result,
                        identifier = identifier
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "TransferData",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Phone:CheckIfWalletExist",
            function(exist)
                if exist then
                    ESX.TriggerServerCallback(
                        "SevenLife:Phone:CheckIfLocalPlayerHaveEnoughWallet",
                        function(enough)
                            if enough then
                                TriggerServerEvent("SevenLife:Phone:MakeTransfer", data.wallet, data.amount, data.types)
                            else
                                TriggerEvent(
                                    "SevenLife:TimetCustom:Notify",
                                    "Phone",
                                    "Du hast nicht genug von dieser Crypto Währung um diese zu transferieren",
                                    3000
                                )
                            end
                        end,
                        data.types,
                        data.amount
                    )
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Phone", "Diese Wallet existiert nicht!", 3000)
                end
            end,
            data.wallet
        )
    end
)
