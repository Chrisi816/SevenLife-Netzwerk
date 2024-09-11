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
local skins
local inmarker = false
local outarea = false
local mistime = 100
local plano
local maske = 0
local inmenu = false
local activenotify = true
local maske2 = 0
local isOnCreator = false
local inmarkerkleidung = false
local outofarea = false
local inmenukleidung = false
local irradaractive = true

-- Mask Shop
CreateThread(
    function()
        for k, v in ipairs(Config.MaskShops) do
            local blip = AddBlipForCoord(v)
            SetBlipSprite(blip, 362)
            SetBlipColour(blip, 48)
            SetBlipDisplay(blip, 4)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Masken Shop")
            EndTextCommandSetBlipName(blip)
        end
    end
)
-- Kleidungsladen
CreateThread(
    function()
        for k, v in ipairs(Config.Shops) do
            local blip = AddBlipForCoord(v)
            SetBlipSprite(blip, 73)
            SetBlipColour(blip, 48)
            SetBlipDisplay(blip, 4)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Kleidungsladen")
            EndTextCommandSetBlipName(blip)
        end
    end
)
-- InPound
Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            for k, v in ipairs(Config.MaskShops) do
                local distance = GetDistanceBetweenCoords(coords, v, true)

                if not IsPedInAnyVehicle(player, true) then
                    if distance < 20 then
                        outarea = true
                        if distance < 1.5 then
                            inmarker = true
                            if activenotify then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um Masken Menu zu öffnen",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 1.6 and distance <= 6 then
                                inmarker = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        outarea = false
                    end
                else
                    inmarker = false
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(mistime)
            if outarea then
                for k, v in ipairs(Config.MaskShops) do
                    mistime = 1
                    DrawMarker(
                        Config.MarkerType,
                        v,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        Config.MarkerSize,
                        Config.MarkerColor.r,
                        Config.MarkerColor.g,
                        Config.MarkerColor.b,
                        100,
                        false,
                        true,
                        2,
                        false,
                        nil,
                        nil,
                        false
                    )
                end
            else
                mistime = 1000
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustPressed(0, 38) then
                    if not inmenu then
                        activenotify = false

                        TriggerEvent("sevenliferp:closenotify", false)
                        local ped = GetPlayerPed(-1)
                        local retval = GetNumberOfPedDrawableVariations(ped, 9)
                        local retval1 = GetNumberOfPedTextureVariations(ped, 9, 0)

                        local retval2 = GetNumberOfPedDrawableVariations(ped, 10)

                        local retval3 = retval + retval2

                        camcoord = GetOffsetFromEntityInWorldCoords(ped, 0.0, 3.0, 0.0)
                        facecoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.8, 0.6)
                        clothescoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.5, 0.1)
                        h = GetEntityHeading(PlayerPedId())
                        heading = GetEntityHeading(PlayerPedId())
                        isOnCreator = true
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenMaskenMenu",
                                mAccessory = retval3,
                                colorid = retval1
                            }
                        )
                        GetSkin()
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
function GetSkin()
    TriggerEvent(
        "skinchanger:getSkin",
        function(skin)
            skins = skin
        end
    )
end
function ChangedValue(value1, value2)
    if value1 ~= value2 then
        return true
    else
        return false
    end
end

RegisterNUICallback(
    "MakeArticle",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(maske, data.endvalue1) then
            maske = tonumber(data.endvalue1)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedComponentVariation(player, 1, maske, maske2, 2)
            local retval1 = GetNumberOfPedTextureVariations(player, 9, maske)
            SendNUIMessage(
                {
                    type = "ColorId",
                    colorid = retval1
                }
            )
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["mask_1"] = maske,
                        ["mask_2"] = maske2
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)

RegisterNUICallback(
    "MakeArticle2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(maske2, data.endvalue2) then
            maske2 = tonumber(data.endvalue2)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedComponentVariation(player, 1, maske, maske2, 2)
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["mask_1"] = maske,
                        ["mask_2"] = maske2
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)

RegisterNUICallback(
    "rotation",
    function(data)
        h = GetEntityHeading(PlayerPedId())
        local numbers = tonumber(data.value)
        SetCamRot(camara, 0.0, 0.0, h + numbers)
    end
)

function Resetskin()
    TriggerEvent("skinchanger:loadSkin", skins)
end

RegisterNUICallback(
    "CloseMenu",
    function()
        isOnCreator = false
        inmenu = false
        activenotify = true
        irradaractive = true
        inmenukleidung = false
        SetNuiFocus(false, false)
        Resetskin()
        Citizen.Wait(50)
        activenotify = true
        SetCamActive(camara, false)
        RenderScriptCams(false, true, 500, true, true)
        camara = nil
        Citizen.Wait(500)
        DisplayRadar(true)
    end
)

RegisterNUICallback(
    "BuyProdukt",
    function()
        isOnCreator = false
        inmenu = false
        activenotify = true
        SetNuiFocus(false, false)
        Citizen.Wait(50)
        SetCamActive(camara, false)
        RenderScriptCams(false, true, 500, true, true)
        camara = nil
        ESX.TriggerServerCallback(
            "SevenLife:MaskeMenu:CheckIfEnoughMoney",
            function(enoughmoney)
                if enoughmoney then
                    ESX.TriggerServerCallback(
                        "esx_skin:getPlayerSkin",
                        function(skin)
                            TriggerServerEvent("esx_skin:save", skin)
                        end
                    )
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Masken", "Maske Erfolgreich gekauft", 2000)
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Masken", "Du besitzt zu wenig Geld", 2000)
                    Resetskin()
                end
            end,
            200
        )
    end
)
function EnableCam()
    local ped = PlayerPedId()

    -- Camara
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(camara, false)
    if (not DoesCamExist(camara)) then
        camara = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(camara, true)
        RenderScriptCams(true, false, 0, true, true)
        SetCamCoord(camara, camcoord)

        SetCamRot(camara, 0.0, 0.0, h - 180.0)
    end

    if heading ~= GetEntityHeading(ped) then
        SetEntityHeading(ped, heading)
    end

    headingToCam = GetEntityHeading(PlayerPedId()) + 90
end

-- Normaler Kleidungsladen
Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(150)
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            for k, v in ipairs(Config.Shops) do
                local distance = GetDistanceBetweenCoords(coords, v, true)

                if not IsPedInAnyVehicle(player, true) then
                    if distance < 20 then
                        outofarea = true
                        if distance < 1.5 then
                            inmarkerkleidung = true
                            if activenotify then
                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke E um den Kleidungsladen zu öffnen",
                                    "System - Nachricht",
                                    true
                                )
                            end
                        else
                            if distance >= 1.6 and distance <= 6 then
                                inmarkerkleidung = false
                                TriggerEvent("sevenliferp:closenotify", false)
                            end
                        end
                    else
                        outofarea = false
                    end
                else
                    inmarkerkleidung = false
                end
            end
        end
    end
)
local misoftime = 1000
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(misoftime)
            if outofarea then
                for k, v in ipairs(Config.Shops) do
                    misoftime = 1
                    DrawMarker(
                        Config.MarkerType,
                        v,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        Config.MarkerSize,
                        Config.MarkerColor.r,
                        Config.MarkerColor.g,
                        Config.MarkerColor.b,
                        100,
                        false,
                        true,
                        2,
                        false,
                        nil,
                        nil,
                        false
                    )
                end
            else
                misoftime = 1000
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inmarkerkleidung then
                if IsControlJustPressed(0, 38) then
                    if not inmenukleidung then
                        activenotify = false
                        irradaractive = false
                        TriggerEvent("sevenliferp:closenotify", false)
                        local ped = GetPlayerPed(-1)
                        local retvalhut = GetNumberOfPedDrawableVariations(ped, 0)
                        local retvaltorso = GetNumberOfPedDrawableVariations(ped, 11)
                        local retvalshirt = GetNumberOfPedDrawableVariations(ped, 8)
                        local retvalhose = GetNumberOfPedDrawableVariations(ped, 4)
                        local retvalschuhe = GetNumberOfPedDrawableVariations(ped, 6)
                        local retvalarme = GetNumberOfPedDrawableVariations(ped, 5)
                        Removenormalhud()

                        camcoord = GetOffsetFromEntityInWorldCoords(ped, 0.0, 3.0, 0.0)
                        facecoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.8, 0.6)
                        clothescoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.5, 0.1)
                        h = GetEntityHeading(PlayerPedId())
                        heading = GetEntityHeading(PlayerPedId())
                        isOnCreator = true
                        EnableCam()
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenKleidungsladenMenu",
                                idhut = retvalhut,
                                idtorso = retvaltorso,
                                idshirt = retvalshirt,
                                idhose = retvalhose,
                                idschuhe = retvalschuhe,
                                idarme = retvalarme
                            }
                        )
                        GetSkin()
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)

-- Hut
local hut = 0
local hut2 = 1
RegisterNUICallback(
    "MakeArticleHut1",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hut, data.endvalue1) then
            hut = tonumber(data.endvalue1)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedPropIndex(GetPlayerPed(-1), 0, hut, hut2, 0)
            local retval1 = GetNumberOfPedPropTextureVariations(player, 1, "hat_1")
            SendNUIMessage(
                {
                    type = "ColorId",
                    colorid = retval1
                }
            )
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["helmet_1"] = hut,
                        ["helmet_2"] = hut2
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)

RegisterNUICallback(
    "MakeArticleHut2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hut2, data.endvalue2) then
            hut2 = tonumber(data.endvalue2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedPropIndex(GetPlayerPed(-1), 0, hut, hut2, 0)
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["helmet_1"] = hut,
                        ["helmet_2"] = hut2
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)

-- Torso
local torso = 0
local torso2 = 1
RegisterNUICallback(
    "MakeArticleTorso1",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(torso, data.endvalue1) then
            torso = tonumber(data.endvalue1)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 11, torso, torso2, 2)
            local retval1 = GetNumberOfPedTextureVariations(player, 11, torso)
            SendNUIMessage(
                {
                    type = "ColorId",
                    colorid = retval1
                }
            )
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["torso_1"] = torso,
                        ["torso_2"] = torso2
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)

RegisterNUICallback(
    "MakeArticleTorso2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(torso2, data.endvalue2) then
            torso2 = tonumber(data.endvalue2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 11, torso, torso2, 2)
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["torso_1"] = torso,
                        ["torso_2"] = torso2
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)
-- Shirt
local shirt = 0
local shirt2 = 1
RegisterNUICallback(
    "MakeArticleShirt1",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(shirt, data.endvalue1) then
            shirt = tonumber(data.endvalue1)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 8, shirt, shirt2, 2)
            local retval1 = GetNumberOfPedTextureVariations(player, 8, shirt)
            SendNUIMessage(
                {
                    type = "ColorId",
                    colorid = retval1
                }
            )
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["tshirt_1"] = shirt,
                        ["tshirt_2"] = shirt2
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)

RegisterNUICallback(
    "MakeArticleShirt2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(shirt2, data.endvalue2) then
            shirt2 = tonumber(data.endvalue2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 8, shirt, shirt2, 2)
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["tshirt_1"] = shirt,
                        ["tshirt_2"] = shirt2
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)
-- Hose
local hose = 0
local hose2 = 1
RegisterNUICallback(
    "MakeArticleHose1",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hose, data.endvalue1) then
            hose = tonumber(data.endvalue1)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 4, hose, hose2, 2)
            local retval1 = GetNumberOfPedTextureVariations(player, 4, hose)
            SendNUIMessage(
                {
                    type = "ColorId",
                    colorid = retval1
                }
            )
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["pants_1"] = hose,
                        ["pants_2"] = hose2
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)

RegisterNUICallback(
    "MakeArticleHose2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hose2, data.endvalue2) then
            hose2 = tonumber(data.endvalue2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 4, hose, hose2, 2)
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["pants_1"] = hose,
                        ["pants_2"] = hose2
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)
-- Schuhe
local schuhe = 0
local schuhe2 = 1
RegisterNUICallback(
    "MakeArticleSchuhe1",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(schuhe, data.endvalue1) then
            schuhe = tonumber(data.endvalue1)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 6, schuhe, schuhe2, 2)
            local retval1 = GetNumberOfPedTextureVariations(player, 6, schuhe)
            SendNUIMessage(
                {
                    type = "ColorId",
                    colorid = retval1
                }
            )
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["shoes_1"] = schuhe,
                        ["shoes_2"] = schuhe2
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)

RegisterNUICallback(
    "MakeArticleSchuhe2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(schuhe2, data.endvalue2) then
            schuhe2 = tonumber(data.endvalue2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 6, schuhe, schuhe2, 2)
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["shoes_1"] = schuhe,
                        ["shoes_2"] = schuhe2
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)

RegisterNUICallback(
    "PayForOutfit",
    function(data)
        local preis = data.preis
        irradaractive = true
        isOnCreator = false
        inmenu = false
        activenotify = true
        inmenukleidung = false
        SetNuiFocus(false, false)
        Citizen.Wait(50)
        SetCamActive(camara, false)

        RenderScriptCams(false, true, 500, true, true)
        camara = nil
        ESX.TriggerServerCallback(
            "SevenLife:MaskeMenu:CheckIfEnoughMoney",
            function(enoughmoney)
                if enoughmoney then
                    TriggerEvent(
                        "skinchanger:getSkin",
                        function(skin)
                            for k, v in pairs(skin) do
                                print(k .. " - " .. v)
                            end
                            TriggerServerEvent("esx_skin:save", skin)
                        end
                    )

                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Kleidungsladen",
                        "Klamotten Erfolgreich gekauft",
                        2000
                    )

                    Citizen.Wait(500)
                    DisplayRadar(true)
                else
                    TriggerEvent("SevenLife:TimetCustom:Notify", "Kleidungsladen", "Du besitzt zu wenig Geld", 2000)
                    TriggerEvent("skinchanger:loadSkin", skins)
                end
            end,
            preis
        )
    end
)

function Removenormalhud()
    Citizen.CreateThread(
        function()
            while not irradaractive do
                Citizen.Wait(1)
                DisplayRadar(false)
                TriggerEvent("sevenlife:removeallhud")
            end
        end
    )
end

RegisterNUICallback(
    "SaveOutfitandPay",
    function(data)
        local ped = GetPlayerPed(-1)
        irradaractive = true
        local model = GetEntityModel(ped)
        Citizen.Wait(200)

        Citizen.Wait(500)
        DisplayRadar(true)
        TriggerEvent(
            "skinchanger:getSkin",
            function(skin)
                TriggerServerEvent("SevenLife:Kleidungsladen:SaveOutfit", data.input, model, skin)
            end
        )
    end
)

RegisterNUICallback(
    "Error",
    function()
        irradaractive = true
        TriggerEvent("SevenLife:TimetCustom:Notify", "Kleidungsladen", "Es ist ein fehler Unterlaufen", 2000)
        Resetskin()

        Citizen.Wait(500)

        DisplayRadar(true)
    end
)

RegisterNetEvent("SevenLife:Klamotten:Erfolgreichgespeichert")
AddEventHandler(
    "SevenLife:Klamotten:Erfolgreichgespeichert",
    function()
        TriggerEvent("SevenLife:TimetCustom:Notify", "Kleidungsladen", "Outfit erfolgreich gespeichert", 2000)
    end
)

RegisterNUICallback(
    "GetOutfits",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Kleidungsladen:GetOutfits",
            function(result)
                SendNUIMessage(
                    {
                        type = "MakeOutfits",
                        result = result
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "DeleteOutfit",
    function(data)
        TriggerServerEvent("SevenLife:Kleidungsladen:DeleteOutfit", data.name, data.model, data.skin, data.outfitId)
        irradaractive = true
        Citizen.Wait(500)
        DisplayRadar(true)
    end
)

local skinData = {}
local data
RegisterNUICallback(
    "ShowOutfit",
    function(datas)
        local ped = GetPlayerPed(-1)

        data = datas.skin
        if typeof(data) ~= "table" then
            data = json.decode(data)
        end

        TriggerEvent("skinchanger:loadSkin", data)

        ESX.TriggerServerCallback(
            "esx_skin:getPlayerSkin",
            function(skin)
                TriggerServerEvent("esx_skin:save", skin)
            end
        )
    end
)

function typeof(var)
    local _type = type(var)
    if (_type ~= "table" and _type ~= "userdata") then
        return _type
    end
    local _meta = getmetatable(var)
    if (_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME
    else
        return _type
    end
end
RegisterNUICallback(
    "rotationleft",
    function(data)
        TriggerEvent("SevenLife:Char:SetCam")
        cam = "kopf"
        local ped = PlayerPedId()
        local pedPos = GetEntityCoords(ped)
        local camPos = GetCamCoord(camara)
        local headings = headingToCam
        headings = headings + 2.5
        headingToCam = headings
        local cx, cy = GetPositionByRelativeHeading(ped, headings, 2)
        SetCamCoord(camara, cx, cy, camPos.z)
        PointCamAtCoord(camara, pedPos.x, pedPos.y, camPos.z)
    end
)
RegisterNUICallback(
    "rotationright",
    function(data)
        TriggerEvent("SevenLife:Char:SetCam")
        cam = "kopf"
        local ped = PlayerPedId()
        local pedPos = GetEntityCoords(ped)
        local camPos = GetCamCoord(camara)
        local headings = headingToCam
        headings = headings - 2.5
        headingToCam = headings
        local cx, cy = GetPositionByRelativeHeading(ped, headings, 2)
        SetCamCoord(camara, cx, cy, camPos.z)
        PointCamAtCoord(camara, pedPos.x, pedPos.y, camPos.z)
    end
)
function GetPositionByRelativeHeading(ped, head, dist)
    local pedPos = GetEntityCoords(ped)

    local finPosx = pedPos.x + math.cos(head * (math.pi / 180)) * dist
    local finPosy = pedPos.y + math.sin(head * (math.pi / 180)) * dist

    return finPosx, finPosy
end
local arme = 0
RegisterNUICallback(
    "MakeArticleArme1",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(arme, data.endvalue1) then
            arme = tonumber(data.endvalue1)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")

            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    local clothesSkin = {
                        ["arms"] = arme
                    }
                    TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
                end
            )
        end
    end
)
