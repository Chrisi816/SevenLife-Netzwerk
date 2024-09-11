-- ESX

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
            Citizen.Wait(1000)
        end
    end
)

-- Variables
local NumberCharset = {}
for i = 48, 57 do
    table.insert(NumberCharset, string.char(i))
end
local notifys = true
local inmarker = false
local inmarkers = false
local area = false
local inmenu = false
local timemain = 100
local timemains = 100
local area = false
local bank
-- Blips
Citizen.CreateThread(
    function()
        BlipMainBank()
        ShowBankBlips()
    end
)

function BlipMainBank()
    local blip = AddBlipForCoord(Config.MainBank.x, Config.MainBank.y, Config.MainBank.z)
    SetBlipSprite(blip, 293)
    SetBlipDisplay(blip, 3)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 52)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Staatsbank")
    EndTextCommandSetBlipName(blip)
end

function ShowBankBlips()
    for _, Atmblips in pairs(Config.AtmLocations) do
        Atmblips.blip = AddBlipForCoord(Atmblips.x, Atmblips.y, Atmblips.z)
        SetBlipSprite(Atmblips.blip, Config.sprite)
        SetBlipDisplay(Atmblips.blip, Config.displayid)
        SetBlipScale(Atmblips.blip, Config.scale)
        SetBlipColour(Atmblips.blip, Config.Blipcolour)
        SetBlipAsShortRange(Atmblips.blip, Config.short)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("ATM")
        EndTextCommandSetBlipName(Atmblips.blip)
    end
end

-- Core

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)

            for k, v in pairs(Config.AtmLocations) do
                local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                if distance < 15 then
                    timemain = 15
                    if distance < 2 then
                        inmarker = true
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um dein Bank Konto zu begutachten",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 2.1 and distance <= 3 then
                            inmarker = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    timemain = 100
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(6)
            if inmarker then
                bank = 1
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        inmenu = true
                        ESX.TriggerServerCallback(
                            "SevenLife:Bank:CheckIfPlayerHaveBankAccount",
                            function(bankaccount)
                                if bankaccount then
                                    TriggerServerEvent("SevenLife:Bank:OpenNormalBankInfo")
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Bank",
                                        "Du besitzt kein aktives Bankkonto",
                                        2500
                                    )
                                end
                            end
                        )
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

-- Open Normal Banking

RegisterNetEvent("SevenLife:Bank:OpenNormalBankEnd")
AddEventHandler(
    "SevenLife:Bank:OpenNormalBankEnd",
    function(bankmoney, iban, firstname, bankcard)
        local bankcard = tonumber(bankcard)
        playAnim("mp_common", "givetake1_a", 2500)
        Citizen.Wait(2500)
        SetNuiFocus(true, true)
        TriggerScreenblurFadeIn(3000)
        if bank == 1 then
            SendNUIMessage(
                {
                    type = "OpenNormalBank",
                    bankmoney = bankmoney,
                    iban = iban,
                    firstname = firstname,
                    bankcard = bankcard
                }
            )
        else
            SendNUIMessage(
                {
                    type = "OpenMainBank",
                    bankmoney = bankmoney,
                    iban = iban,
                    firstname = firstname,
                    bankcard = bankcard
                }
            )
        end
    end
)
function playAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end

RegisterNUICallback(
    "CloseBank",
    function()
        notifys = true
        inmenu = false
        inmarker = true
        SetNuiFocus(false, false)
        TriggerScreenblurFadeOut(3000)
    end
)

RegisterNUICallback(
    "transaktion",
    function(data)
        notifys = true
        inmenu = false
        inmarker = true
        SetNuiFocus(false, false)
        TriggerScreenblurFadeOut(3000)
        if data.type == "einzahlen" then
            TriggerServerEvent("SevenLife:Bank:nehmgeld", data.geld)
        elseif data.type == "auszahlen" then
            TriggerServerEvent("SevenLife:Bank:gibgeld", data.geld)
        elseif data.type == "überweisen" then
            ESX.TriggerServerCallback(
                "SevenLife:Bank:CheckIfPlayerHaveEnoughMoney",
                function(enoughmoney)
                    if enoughmoney then
                        ESX.TriggerServerCallback(
                            "SevenLife:Bank:CheckifIbanExist",
                            function(ibanexist)
                                if ibanexist then
                                    TriggerServerEvent("SevenLife:PhoneBank:Transferdata", data.Money, data.IbanID)
                                else
                                    TriggerEvent("SevenLife:TimetCustom:Notify", "Bank", "Iban nicht gefunden", 2500)
                                end
                            end,
                            data.IbanID
                        )
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Bank", "Du besitzt zu wenig Geld", 2500)
                    end
                end,
                data.Money
            )
        elseif data.type == "einzahlennormal" then
            TriggerServerEvent("SevenLife:Bank:nehmgeldnormal", data.geld)
        elseif data.type == "auszahlennormal" then
            TriggerServerEvent("SevenLife:Bank:gibgeldnormal", data.geld)
        end
    end
)

-- Main Bank

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemains)
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)

            for k, v in pairs(Config.MainBankLocations) do
                local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                if distance < 20 then
                    timemains = 5
                    if distance < 15 then
                        DrawMarker(20, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 234, 0, 122, 200, 1, 1, 0, 0)
                        timemains = 1
                        if distance < 1.0 then
                            inmarkers = true
                            if notifys then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um dein Bank Konto zu begutachten",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 1.1 and distance <= 2.5 then
                                inmarkers = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        timemains = 5
                    end
                else
                    timemains = 100
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(6)
            if inmarkers then
                bank = 2
                if IsControlJustPressed(0, 38) then
                    if inmenu == false then
                        TriggerEvent("sevenliferp:closenotify", false)
                        notifys = false
                        inmenu = true
                        ESX.TriggerServerCallback(
                            "SevenLife:Bank:CheckIfPlayerHaveBankAccount",
                            function(bankaccount)
                                if bankaccount then
                                    TriggerServerEvent("SevenLife:Bank:OpenNormalBankInfo")
                                    bank = 2
                                else
                                    SetNuiFocus(true, true)
                                    TriggerScreenblurFadeIn(3000)
                                    SendNUIMessage(
                                        {
                                            type = "OpenAnmeldeBild"
                                        }
                                    )
                                end
                            end
                        )
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

RegisterNUICallback(
    "Kontoereffnet",
    function()
        notifys = true
        inmenu = false
        inmarker = true
        local Iban = MakeIban()
        SetNuiFocus(false, false)
        TriggerScreenblurFadeOut(3000)

        TriggerServerEvent("SevenLife:Bank:GiveIBAN", Iban)
        TriggerEvent(
            "SevenLife:Handy:Message",
            "../src/appsymbols/bankAmerica.png",
            "Nachricht - Bank",
            "Konto erfolgreich eröffnet"
        )
    end
)
function MakeIban()
    local MakeIban
    local doBreak = false

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())

        MakeIban = string.upper(GetRandomNumber(4) .. "-" .. GetRandomNumber(4))

        ESX.TriggerServerCallback(
            "SevenLife:Bank:IsIbanTaken",
            function(IsIbanTaken)
                if not IsIbanTaken then
                    doBreak = true
                end
            end,
            MakeIban
        )

        if doBreak then
            break
        end
    end

    return MakeIban
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

RegisterNUICallback(
    "kartekauf",
    function(data)
        notifys = true
        inmenu = false
        inmarker = true
        SetNuiFocus(false, false)
        TriggerScreenblurFadeOut(3000)
        ESX.TriggerServerCallback(
            "SevenLife:Bank:CheckIfPlayerHaveCard",
            function(bankcard)
                if data.type == bankcard then
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Bank", "Karte schon in Besitz", 2500)
                else
                    TriggerServerEvent("SevenLife:Bank:GiveCard", data.type, data.preis)
                end
            end
        )
    end
)

RegisterNUICallback(
    "GetTransaktionsData",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Bank:GetTransaktionsdata",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenTransaktionsmenu",
                        result = result
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "AccountCryptoAnmelde",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Bank:CheckIfAccountExists",
            function(exist)
                if exist then
                    ESX.TriggerServerCallback(
                        "SevenLife:Bank:CheckInfos",
                        function(infos)
                            ESX.TriggerServerCallback(
                                "SevenLife:Bank:CheckInfos2",
                                function(infos1)
                                    Citizen.Wait(100)
                                    SendNUIMessage(
                                        {
                                            type = "OpenBankCryptoDeashBoard",
                                            name = infos[1].benutzername,
                                            btc = infos[1].btc,
                                            eth = infos[1].eth,
                                            key = infos[1].key,
                                            btcwert = infos1[1].btcwert,
                                            ethwert = infos1[1].ethwert
                                        }
                                    )
                                end
                            )
                        end
                    )
                else
                    notifys = true
                    inmenu = false
                    inmarker = true
                    SetNuiFocus(false, false)
                    TriggerScreenblurFadeOut(3000)
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Crypto", "Account nicht vorhanden", 2500)
                end
            end,
            data.benutzer,
            data.passwort
        )
    end
)

RegisterNUICallback(
    "GetDataCrypto",
    function(data)
        if data.typ == 1 then
            SendNUIMessage(
                {
                    type = "KaufBTCCrypto",
                    btcwert = data.btcwert
                }
            )
        elseif data.typ == 2 then
            SendNUIMessage(
                {
                    type = "VerkaufBTCCrypto",
                    btcwert1 = data.btcwert1
                }
            )
        elseif data.typ == 3 then
            SendNUIMessage(
                {
                    type = "KaufETHCrypto",
                    ethwert = data.ethwert
                }
            )
        elseif data.typ == 4 then
            SendNUIMessage(
                {
                    type = "VerkaufETHCrypto",
                    ethwert1 = data.ethwert1
                }
            )
        end
    end
)

RegisterNUICallback(
    "TransferCrypto",
    function(data)
        notifys = true
        inmenu = false
        inmarker = true
        SetNuiFocus(false, false)
        TriggerScreenblurFadeOut(3000)
        if data.typ == 1 then
            ESX.TriggerServerCallback(
                "SevenLife:Bank:CheckIfPlayerHaveEnoughCoins",
                function(enoughcoins)
                    local endcash = data.coinsverkaufen * data.btcwert1
                    if enoughcoins then
                        TriggerServerEvent("SevenLife:Bank:SellCoins", "btc", data.coinsverkaufen, endcash)
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Bank", "Du besitzt zu wenige Coins", 2500)
                    end
                end,
                "btc",
                data.coinsverkaufen
            )
        elseif data.typ == 2 then
            local endcash = data.coinskaufen * data.btcwert
            ESX.TriggerServerCallback(
                "SevenLife:Bank:CheckIfPlayerHaveEnoughCash",
                function(enoughmoney)
                    if enoughmoney then
                        TriggerServerEvent("SevenLife:Bank:BuyCoins", "btc", data.coinskaufen, endcash)
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Bank", "Du bseitzt zu wenig Geld", 2500)
                    end
                end,
                endcash
            )
        elseif data.typ == 3 then
            ESX.TriggerServerCallback(
                "SevenLife:Bank:CheckIfPlayerHaveEnoughCoins",
                function(enoughcoins)
                    local endcash = data.coinsverkaufen1 * data.ethwert1
                    if enoughcoins then
                        TriggerServerEvent("SevenLife:Bank:SellCoins", "eth", data.coinsverkaufen1, endcash)
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Bank", "Du besitzt zu wenige Coins", 2500)
                    end
                end,
                "eth",
                data.coinsverkaufen1
            )
        elseif data.typ == 4 then
            local endcash = data.coinskaufen1 * data.ethwert
            ESX.TriggerServerCallback(
                "SevenLife:Bank:CheckIfPlayerHaveEnoughCash",
                function(enoughmoney)
                    if enoughmoney then
                        TriggerServerEvent("SevenLife:Bank:BuyCoins", "eth", data.coinskaufen1, endcash)
                    else
                        TriggerEvent("SevenLife:TimetCustom:Notify", "Bank", "Du bseitzt zu wenig Geld", 2500)
                    end
                end,
                endcash
            )
        end
    end
)
