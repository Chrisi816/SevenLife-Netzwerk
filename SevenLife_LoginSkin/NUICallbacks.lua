local sex = nil
local skinproblemopacity = 0.1
local freckleopacity = 0.1
local cicatricesp = 0.1
local eyebrowopacity = 0.1
local eyebrow = 1
local wrinkleopacity = 0.1

function ChangedValue(value1, value2)
    if value1 ~= value2 then
        return true
    else
        return false
    end
end

RegisterNUICallback(
    "ChangeSEX",
    function(data)
        if ChangedValue(LastSex, data.gender) then
            LastSex = tonumber(data.gender)
            TriggerEvent("skinchanger:loadSkin", {sex = LastSex})
        end
    end
)

RegisterNUICallback(
    "ChangeMother",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(Mothernumber, data.mother) then
            Mothernumber = data.mother
            Mother = tonumber(Mothernumber)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadBlendData(player, Mother, Dad, 0, MothorColor, DadColor, 0, face_weight, skin_weight, 0.0, false)
        end
    end
)

RegisterNUICallback(
    "ChangeFather",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(LastDad, data.dad) then
            LastDad = data.dad
            Dad = tonumber(LastDad)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadBlendData(player, Mother, Dad, 0, MothorColor, DadColor, 0, face_weight, skin_weight, 0.0, false)
        end
    end
)

RegisterNUICallback(
    "ChangeMotherColor",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(LastMotherColor, data.MotherColor) then
            LastMotherColor = data.MotherColor
            MothorColor = tonumber(LastMotherColor)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadBlendData(player, Mother, Dad, 0, MothorColor, DadColor, 0, face_weight, skin_weight, 0.0, false)
        end
    end
)

RegisterNUICallback(
    "ChangeFaterColor",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(LastDadColor, data.FaterColor) then
            LastDadColor = data.FaterColor
            DadColor = tonumber(LastDadColor)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadBlendData(player, Mother, Dad, 0, MothorColor, DadColor, 0, face_weight, skin_weight, 0.0, false)
        end
    end
)

RegisterNUICallback(
    "NaseWidth",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(nosewidth, data.NaseWidth) then
            nosewidth = tonumber(data.NaseWidth)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedFaceFeature(player, 0, (nosewidth / 10) + 0.0)
        end
    end
)
RegisterNUICallback(
    "NasePeakHeight",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(noseh, data.NasePeakHeight) then
            noseh = tonumber(data.NasePeakHeight)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedFaceFeature(player, 1, (noseh / 10) + 0.0)
        end
    end
)
RegisterNUICallback(
    "NasePeakHeightlength",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(nosepeakl, data.nosepeakl) then
            nosepeakl = tonumber(data.nosepeakl)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedFaceFeature(player, 2, (nosepeakl / 10) + 0.0) -- Nose Peak Length
        end
    end
)
RegisterNUICallback(
    "NasePeakBoneHeight",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(noseboneh, data.noseboneh) then
            noseboneh = tonumber(data.noseboneh)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedFaceFeature(player, 3, (noseboneh / 10) + 0.0)
        end
    end
)
RegisterNUICallback(
    "NosePeakLowering",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(nosepeakh, data.nosepeakh) then
            nosepeakh = tonumber(data.nosepeakh)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedFaceFeature(player, 4, (nosepeakh / 10) + 0.0) -- Nose Peak Lowering
        end
    end
)
RegisterNUICallback(
    "NoseBoneTwist",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(nosetwist, data.nosetwist) then
            nosetwist = tonumber(data.nosetwist)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedFaceFeature(player, 5, (nosetwist / 10) + 0.0) -- Nose Bone Twist
        end
    end
)
RegisterNUICallback(
    "Eyebrowheight",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(eyesbrowh, data.eyesbrowh) then
            eyesbrowh = tonumber(data.eyesbrowh)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedFaceFeature(player, 6, (eyesbrowh / 10) + 0.0) -- Eyebrow height
        end
    end
)
RegisterNUICallback(
    "Eyebrowdept",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(eyesbrowd, data.eyesbrowd) then
            eyesbrowd = tonumber(data.eyesbrowd)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedFaceFeature(player, 7, (eyesbrowd / 10) + 0.0) -- Eyebrow depth
        end
    end
)

RegisterNUICallback(
    "CheekbonesHeight",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(cheekboneh, data.cheekboneh) then
            cheekboneh = tonumber(data.cheekboneh)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedFaceFeature(player, 8, (cheekboneh / 10) + 0.0) --
        end
    end
)
RegisterNUICallback(
    "CheekbonesWidth",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(cheekbonew, data.cheekbonew) then
            cheekbonew = tonumber(data.cheekbonew)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedFaceFeature(player, 9, (cheekbonew / 10) + 0.0) --
        end
    end
)
RegisterNUICallback(
    "ProblemHaut",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(skinproblem, data.skinproblem) then
            skinproblem = tonumber(data.skinproblem)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadOverlay(player, 6, skinproblem, skinproblemopacity * 0.1)
        end
    end
)
RegisterNUICallback(
    "ProblemHautVar",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(skinproblemopacity, data.skinproblemopacity) then
            skinproblemopacity = tonumber(data.skinproblemopacity)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadOverlay(player, 6, skinproblem, skinproblemopacity * 0.1)
        end
    end
)
RegisterNUICallback(
    "SommerSprossen",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(freckle, data.freckle) then
            freckle = tonumber(data.freckle)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadOverlay(player, 9, freckle, freckleopacity * 0.1)
        end
    end
)
RegisterNUICallback(
    "SommerSprossenVar",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(freckleopacity, data.freckleopacity) then
            freckleopacity = tonumber(data.freckleopacity)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadOverlay(player, 9, freckle, freckleopacity * 0.1)
        end
    end
)
RegisterNUICallback(
    "Wunden",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(cicatrices, data.cicatrices) then
            cicatrices = tonumber(data.cicatrices)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadOverlay(player, 7, cicatrices, cicatricesp * 0.1)
        end
    end
)
RegisterNUICallback(
    "WundenVar",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(cicatricesp, data.cicatricesp) then
            cicatricesp = tonumber(data.cicatricesp)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadOverlay(player, 7, cicatrices, cicatricesp * 0.1)
        end
    end
)
RegisterNUICallback(
    "Falten",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(wrinkle, data.wrinkle) then
            wrinkle = tonumber(data.wrinkle)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadOverlay(player, 3, wrinkle, wrinkleopacity * 0.1)
        end
    end
)
RegisterNUICallback(
    "FaltenVar",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(wrinkleopacity, data.wrinkleopacity) then
            wrinkleopacity = tonumber(data.wrinkleopacity)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadOverlay(player, 3, wrinkle, wrinkleopacity * 0.1)
        end
    end
)
RegisterNUICallback(
    "AugenFarbe",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(eyecolor, data.eyecolor) then
            eyecolor = tonumber(data.eyecolor)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedEyeColor(player, eyecolor) -- EyeColor
        end
    end
)
RegisterNUICallback(
    "AugenBrauen",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(eyebrow, data.eyebrow) or ChangedValue(eyebrowcolor, data.eyebrowcolor) then
            eyebrow = tonumber(data.eyebrow)
            eyebrowcolor = tonumber(data.eyebrowcolor)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHeadOverlay(player, 2, eyebrow, eyebrowopacity * 0.1)
            SetPedHeadOverlayColor(player, 2, 1, eyebrowcolor, eyebrowcolor) -- Eyebrows Color
        end
    end
)
RegisterNUICallback(
    "AugenBrauenDichte",
    function(data)
        local player = GetPlayerPed(-1)

        if ChangedValue(eyebrowopacity, data.eyebrowopacity) then
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            eyebrowopacity = tonumber(data.eyebrowopacity)
            SetPedHeadOverlay(player, 2, eyebrow, eyebrowopacity * 0.1)
        end
    end
)
local hair = 0
local hair2 = 0
RegisterNUICallback(
    "Haare1",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hair, data.Haar1) then
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            hair = tonumber(data.Haar1)
            SetPedComponentVariation(player, 2, hair, hair2, 2)
        end
    end
)
RegisterNUICallback(
    "Haare2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hair, data.Haar1) then
            hair2 = tonumber(data.Haar1)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedComponentVariation(player, 2, hair, hair2, 2)
        end
    end
)
local haircolor = 0
local haircolor2 = 0
RegisterNUICallback(
    "Haare-farbe",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hair, data.haarfarbe1) then
            haircolor = tonumber(data.haarfarbe1)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHairColor(player, haircolor, haircolor2)
        end
    end
)
RegisterNUICallback(
    "Haare2-farbe",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hair, data.haarfarbe2) then
            haircolor2 = tonumber(data.haarfarbe2)
            TriggerEvent("SevenLife:Char:SetCam", "kopf")
            SetPedHairColor(player, haircolor, haircolor2)
        end
    end
)
-- T-Shirt
local tshirt = 0
local tshirt2 = 0
RegisterNUICallback(
    "T-Shirt",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(tshirt, data.shirt) then
            tshirt = tonumber(data.shirt)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 8, tshirt, tshirt2, 2)
        end
    end
)
RegisterNUICallback(
    "T-Shirt2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(tshirt2, data.shirt2) then
            tshirt2 = tonumber(data.shirt2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 8, tshirt, tshirt2, 2)
        end
    end
)
-- Torso
local Torso = 0
local Torso2 = 0
RegisterNUICallback(
    "Troso",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(Torso, data.Troso) then
            Torso = tonumber(data.Troso)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 11, Torso, Torso2, 2)
        end
    end
)
RegisterNUICallback(
    "Troso2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(Torso2, data.Troso2) then
            Torso2 = tonumber(data.Troso2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 11, Torso, Torso2, 2)
        end
    end
)
-- Arme
local Arme = 0
local Arme2 = 0
RegisterNUICallback(
    "Arme",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(Arme, data.Arme) then
            Arme = tonumber(data.Arme)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 3, Arme, Arme2, 2)
        end
    end
)
RegisterNUICallback(
    "Arme2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(Arme2, data.Arme2) then
            Arme2 = tonumber(data.Arme2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 3, Arme, Arme2, 2)
        end
    end
)
-- Pants
local Pants = 0
local Pants2 = 0
RegisterNUICallback(
    "Pants",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(Pants, data.Pants) then
            Pants = tonumber(data.Pants)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 4, Pants, Pants2, 2)
        end
    end
)
RegisterNUICallback(
    "Pants2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(Pants2, data.Pants2) then
            Pants2 = tonumber(data.Pants2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 4, Pants, Pants2, 2)
        end
    end
)
-- Shoes
local Shoes = 0
local Shoes2 = 0
RegisterNUICallback(
    "Shoes",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(Shoes, data.Shoes) then
            Shoes = tonumber(data.Shoes)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 6, Shoes, Shoes2, 2)
        end
    end
)
RegisterNUICallback(
    "Shoes2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(Shoes2, data.Shoes2) then
            Shoes2 = tonumber(data.Shoes2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 6, Shoes, Shoes2, 2)
        end
    end
)

local juwell = 0
local juwell2 = 0
RegisterNUICallback(
    "juwell",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(juwell, data.juwell) then
            juwell = tonumber(data.juwell)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 7, juwell, juwell2, 2)
        end
    end
)
local brille = 0
local brille2 = 0
RegisterNUICallback(
    "brille",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(brille, data.brille) then
            brille = tonumber(data.brille)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedPropIndex(player, 1, brille, brille2, true)
        end
    end
)
RegisterNUICallback(
    "brille2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(brille2, data.brille2) then
            brille2 = tonumber(data.brille2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedPropIndex(player, 1, brille, brille2, true)
        end
    end
)

local ohringe = 0
local ohringe2 = 0
RegisterNUICallback(
    "ohringe",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(brille, data.ohringe) then
            ohringe = tonumber(data.ohringe)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedPropIndex(player, 2, ohringe, ohringe2, true)
        end
    end
)
RegisterNUICallback(
    "ohringe2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(ohringe2, data.ohringe2) then
            ohringe2 = tonumber(data.ohringe2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedPropIndex(player, 2, ohringe, ohringe2, true)
        end
    end
)

local uhr = 0
local uhr2 = 0
RegisterNUICallback(
    "uhr",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(uhr, data.uhr) then
            uhr = tonumber(data.uhr)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedPropIndex(player, 6, uhr, uhr2, true)
        end
    end
)
RegisterNUICallback(
    "uhr2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(uhr2, data.uhr2) then
            uhr2 = tonumber(data.uhr2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedPropIndex(player, 2, uhr, uhr2, true)
        end
    end
)

local armband = 0
local armband2 = 0
RegisterNUICallback(
    "armband",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(armband, data.armband) then
            armband = tonumber(data.armband)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedPropIndex(player, 7, armband, armband2, true)
        end
    end
)
RegisterNUICallback(
    "armband2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(armband2, data.armband2) then
            armband2 = tonumber(data.armband2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedPropIndex(player, 7, armband, armband2, true)
        end
    end
)

local hut = 0
local hut2 = 0
RegisterNUICallback(
    "hut",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hut, data.hut) then
            hut = tonumber(data.hut)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedPropIndex(player, 0, hut, hut2, true)
        end
    end
)
RegisterNUICallback(
    "hut2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(hut2, data.hut2) then
            hut2 = tonumber(data.hut2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedPropIndex(player, 0, hut, hut2, true)
        end
    end
)

local maske = 0
local maske2 = 0
RegisterNUICallback(
    "maske",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(maske, data.maske) then
            maske = tonumber(data.maske)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 1, maske, maske2, 2)
        end
    end
)
RegisterNUICallback(
    "maske2",
    function(data)
        local player = GetPlayerPed(-1)
        if ChangedValue(maske2, data.maske2) then
            maske2 = tonumber(data.maske2)
            TriggerEvent("SevenLife:Char:SetCam", "ropa")
            SetPedComponentVariation(player, 1, maske, maske2, 2)
        end
    end
)

RegisterNUICallback(
    "ReiseBeginnen",
    function()
        local player = GetPlayerPed(-1)
        local skin = {}
        skin["dad"] = Dad
        skin["mom"] = Mother
        skin["sex"] = LastSex
        skin["face_md_weight"] = DadColor
        skin["skin_md_weight"] = MothorColor
        skin["eyebrows_5"] = eyesbrowh
        skin["eyebrows_6"] = eyesbrowd
        skin["nose_1"] = nosewidth
        skin["nose_2"] = noseh
        skin["nose_3"] = nosepeakl
        skin["nose_4"] = noseboneh
        skin["nose_5"] = nosepeakh
        skin["nose_6"] = nosetwist
        skin["cheeks_1"] = cheekboneh
        skin["cheeks_2"] = cheekbonew
        skin["eye_color"] = eyecolor
        skin["complexion_1"] = skinproblem
        skin["complexion_2"] = skinproblemopacity
        skin["moles_1"] = freckle
        skin["moles_2"] = freckleopacity
        skin["sun_1"] = cicatrices
        skin["sun_2"] = cicatricesp
        skin["age_1"] = wrinkle
        skin["age_2"] = wrinkleopacity
        skin["hair_1"] = hair
        skin["hair_2"] = hair2
        skin["hair_color_1"] = haircolor
        skin["hair_color_2"] = haircolor2
        skin["eyebrows_1"] = eyebrow
        skin["eyebrows_2"] = eyebrowopacity
        skin["eyebrows_3"] = eyebrowcolor
        skin["eyebrows_4"] = eyebrowcolor

        skin["arms"] = GetPedDrawableVariation(player, 3)
        skin["arms_2"] = GetPedTextureVariation(player, 3)
        skin["pants_1"] = GetPedDrawableVariation(player, 4)
        skin["pants_2"] = GetPedTextureVariation(player, 4)
        skin["shoes_1"] = GetPedDrawableVariation(player, 6)
        skin["shoes_2"] = GetPedTextureVariation(player, 6)
        skin["chain_1"] = GetPedDrawableVariation(player, 7)
        skin["chain_2"] = GetPedTextureVariation(player, 7)
        skin["tshirt_1"] = GetPedDrawableVariation(player, 8)
        skin["tshirt_2"] = GetPedTextureVariation(player, 8)
        skin["torso_1"] = GetPedDrawableVariation(player, 11)
        skin["torso_2"] = GetPedTextureVariation(player, 11)
        skin["helmet_1"] = GetPedPropIndex(player, 0)
        skin["helmet_2"] = GetPedPropTextureIndex(player, 0)
        skin["glasses_1"] = GetPedPropIndex(player, 1)
        skin["glasses_2"] = GetPedPropTextureIndex(player, 1)
        skin["ears_1"] = GetPedPropIndex(player, 2)
        skin["ears_2"] = GetPedPropTextureIndex(player, 2)
        skin["watches_1"] = GetPedPropIndex(player, 6)
        skin["watches_2"] = GetPedPropTextureIndex(player, 6)
        TriggerServerEvent("esx_skin:save", skin)

        FreezeEntityPosition(player, false)
        SetEntityInvincible(player, false)
        SetEntityVisible(PlayerPedId(), true)
        SetBlockingOfNonTemporaryEvents(player, false)
        -- TaskGoStraightToCoord(
        --    player,
        --    Config.HiddenCoords.x,
        --    Config.HiddenCoords.y,
        --    Config.HiddenCoords.z,
        --    1.0,
        --    -1,
        --    72.84,
        --    786603,
        --    1.0
        --)

        TaskGoStraightToCoord(player, -1449.79, -555.47, 72.84, 1.0, -1, 72.84, 786603, 1.0)
        Wait(2000)

        SendNUIMessage(
            {
                type = "OpenLegalorillegal"
            }
        )
    end
)
