local dealerPeds = {}
Citizen.CreateThread(
    function()
        dealerAnimDict = "anim_casino_b@amb@casino@games@shared@dealer@"
        RequestAnimDict(dealerAnimDict)
        while not HasAnimDictLoaded(dealerAnimDict) do
            Wait(0)
        end
        textures()

        Citizen.Wait(500)

        for i = 0, #Config.BarKeeper, 1 do
            randomBlack = math.random(1, 13)
            if randomBlack < 7 then
                dealerModel = Config.maleCasinoDealer
            else
                dealerModel = Config.femaleCasinoDealer
            end
            RequestModel(dealerModel)
            while not HasModelLoaded(dealerModel) do
                RequestModel(dealerModel)
                Citizen.Wait(1)
            end
            dealerEntity =
                CreatePed(
                26,
                dealerModel,
                Config.BarKeeper[i].coords.x,
                Config.BarKeeper[i].coords.y,
                Config.BarKeeper[i].coords.z,
                Config.BarKeeper[i].coords.h,
                false,
                true
            )
            table.insert(dealerPeds, dealerEntity)
            SetModelAsNoLongerNeeded(dealerModel)
            SetEntityCanBeDamaged(dealerEntity, 0)
            SetPedAsEnemy(dealerEntity, 0)
            SetBlockingOfNonTemporaryEvents(dealerEntity, 1)
            SetPedResetFlag(dealerEntity, 249, 1)
            SetPedConfigFlag(dealerEntity, 185, true)
            SetPedConfigFlag(dealerEntity, 108, true)
            SetPedCanEvasiveDive(dealerEntity, 0)
            SetPedCanRagdollFromPlayerImpact(dealerEntity, 0)
            SetPedConfigFlag(dealerEntity, 208, true)
            setBlackjackDealerPedVoiceGroup(randomBlack, dealerEntity)
            SetBlackjackDealerClothes(randomBlack, dealerEntity)
            SetEntityCoordsNoOffset(
                dealerEntity,
                Config.BarKeeper[i].coords.x,
                Config.BarKeeper[i].coords.y,
                Config.BarKeeper[i].coords.z,
                0,
                0,
                1
            )
            SetEntityHeading(dealerEntity, Config.BarKeeper[i].coords.h)
            if dealerModel == Config.maleCasinoDealer then
                TaskPlayAnim(dealerEntity, dealerAnimDict, "idle", 1000.0, -2.0, -1, 2, 1148846080, 0)
            else
                TaskPlayAnim(dealerEntity, dealerAnimDict, "female_idle", 1000.0, -2.0, -1, 2, 1148846080, 0)
            end
            PlayFacialAnim(dealerEntity, "idle_facial", dealerAnimDict)
            RemoveAnimDict(dealerAnimDict)
        end
    end
)

local inmarker = false
local inmenu = false
local allowednotifys = true
Citizen.CreateThread(
    function()
        Citizen.Wait(20)

        while true do
            player = GetPlayerPed(-1)
            Citizen.Wait(200)
            for i = 0, #Config.BarKeeperBuying, 1 do
                local coords = GetEntityCoords(player)
                local distance =
                    GetDistanceBetweenCoords(
                    coords,
                    Config.BarKeeperBuying[i].coords.x,
                    Config.BarKeeperBuying[i].coords.y,
                    Config.BarKeeperBuying[i].coords.z,
                    true
                )
                if distance < 1.7 then
                    inmarker = true
                    if allowednotifys then
                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um die Cocktail bar zu begutachten",
                            "System - Nachricht",
                            true
                        )
                    end
                else
                    if distance >= 1.8 and distance <= 4.5 then
                        inmarker = false
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        while true do
            Citizen.Wait(1)
            if inmarker then
                if IsControlJustReleased(0, 38) then
                    if inmenu == false then
                        Citizen.Wait(100)
                        inmenu = true
                        TriggerEvent("sevenliferp:closenotify", false)
                        allowednotifys = false
                        SetNuiFocus(true, true)
                        SendNUIMessage(
                            {
                                type = "OpenShop"
                            }
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
    "close",
    function()
        inmenu = false
        allowednotifys = true
        SetNuiFocus(false, false)
    end
)
RegisterNUICallback(
    "BuyItems",
    function(data)
        TriggerServerEvent("SevenLife:Casino:Buy", data.Item, data.Count, data.preis)
    end
)
local score = 0
RegisterNetEvent("SevenLife:Casino:Vodka")
AddEventHandler(
    "SevenLife:Casino:Vodka",
    function()
        score = score + 2
        Drunk()
    end
)
RegisterNetEvent("SevenLife:Casino:Wein")
AddEventHandler(
    "SevenLife:Casino:Wein",
    function()
        score = score + 2
        Drunk()
    end
)
function Drunk()
    if score >= 3 then
        local player = GetPlayerPed(-1)

        Citizen.Wait(1000)

        Citizen.Wait(5000)
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        SetTimecycleModifier("spectator5")
        SetPedMotionBlur(player, true)
        SetPedMovementClipset(player, "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
        SetPedIsDrunk(player, true)
        SetPedAccuracy(player, 0)
        DoScreenFadeIn(1000)
        Citizen.Wait(60000 * score)
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)
        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        ResetPedMovementClipset(player, 0)
        SetPedIsDrunk(player, false)
        SetPedMotionBlur(player, false)
    end
end
