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

local open = false
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if IsControlJustPressed(0, 166) then
                if not open then
                    TriggerScreenblurFadeIn(3000)
                    SetNuiFocus(true, true)
                    ESX.TriggerServerCallback(
                        "SevenLife:Animationen:GetMarked",
                        function(result)
                            SendNUIMessage(
                                {
                                    type = "openDanceNUI",
                                    result = result
                                }
                            )
                        end
                    )
                end
            end
        end
    end
)

RegisterNUICallback(
    "CloseMenu",
    function()
        SetNuiFocus(false, false)
        open = false
        TriggerScreenblurFadeOut(3000)
    end
)

local function checkSex()
    local pedModel = GetEntityModel(PlayerPedId())
    for i = 1, #cfg.malePeds do
        if pedModel == GetHashKey(cfg.malePeds[i]) then
            return "male"
        end
    end
    return "female"
end

local acticeanim = false
RegisterNUICallback(
    "beginAnimation",
    function(data, cb)
        local ped = GetPlayerPed(-1)
        if acticeanim then
            ClearPedTasks(ped)
        end
        if data.type == "dances" then
            PlayAnim(data.dancedict, data.danceanim)
        elseif data.type == "props" then
            PlayProp(
                data.prop,
                data.propBone,
                data.propPlacement,
                data.propTwo,
                data.propTwoBone,
                data.propTwoPlacement
            )
        end
    end
)
local anim
local dance
function PlayAnim(dance, anim)
    acticeanim = true
    LoadingDict(dance)
    dance = dance
    anim = anim
    TaskPlayAnim(PlayerPedId(), dance, anim, 1.5, 1.5, -1, 1, 0, false, false, false)
    RemoveAnimDict(dance)
end

function PlayProp(prop, propbone, propplace, proptwo, proptwobone, proptwoplace)
    Loadprop(prop)
    CreateProp(PlayerPedId(), prop, propbone, propplace)
    if proptwo ~= nil then
        Loadprop(prop)
        CreateProp(PlayerPedId(), proptwo, proptwobone, proptwoplace)
    end
end

function CreateProp(ped, prop, bone, placement)
    local coords = GetEntityCoords(ped)
    local newProp = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z + 0.2, true, true, true)
    if newProp then
        AttachEntityToEntity(
            newProp,
            ped,
            GetPedBoneIndex(ped, bone),
            placement[1] + 0.0,
            placement[2] + 0.0,
            placement[3] + 0.0,
            placement[4] + 0.0,
            placement[5] + 0.0,
            placement[6] + 0.0,
            true,
            true,
            false,
            true,
            1,
            true
        )
        insert(cfg.propsEntities, newProp)
        cfg.propActive = true
    end
    SetModelAsNoLongerNeeded(prop)
end

function Loadprop(prop)
    local timeout = false
    SetTimeout(
        5000,
        function()
            timeout = true
        end
    )

    local hashModel = GetHashKey(prop)
    repeat
        RequestModel(hashModel)
        Wait(50)
    until HasModelLoaded(hashModel) or timeout
end

function LoadingDict(dict)
    local timeout = false
    SetTimeout(
        5000,
        function()
            timeout = true
        end
    )

    repeat
        RequestAnimDict(dict)
        Wait(50)
    until HasAnimDictLoaded(dict) or timeout
end

RegisterNUICallback(
    "CloseAnim",
    function()
        local ped = GetPlayerPed(-1)
        ClearPedTasks(ped)
        StopAnimTask(ped, "dance", "anim", 1.0)
    end
)

RegisterNUICallback(
    "StoreAnimation",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:Animationen:GetCount",
            function(count)
                if count >= 3 then
                    TriggerEvent(
                        "SevenLife:TimetCustom:Notify",
                        "Animation",
                        "Du kannst nur Maximal 3 Favourite Animationen auswählen",
                        1500
                    )
                else
                    TriggerServerEvent(
                        "SevenLife:Animation:StoreAnim",
                        data.type,
                        data.title,
                        data.dancedict,
                        data.danceanim,
                        data.prop,
                        data.propBone,
                        data.propPlacement,
                        data.propTwo,
                        data.propTwoBone,
                        data.propTwoPlacement
                    )
                end
            end
        )
    end
)
RegisterNUICallback(
    "DeleteAnim",
    function(data)
        TriggerServerEvent("SevenLife:Animation:DeleteAnim", data.anim)
    end
)
RegisterNetEvent("SevenLife:Animation:UpdateList")
AddEventHandler(
    "SevenLife:Animation:UpdateList",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Animationen:GetMarked",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateDanceNui",
                        result = result
                    }
                )
            end
        )
    end
)
