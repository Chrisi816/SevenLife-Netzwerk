local TimeDefault = 0

RegisterNetEvent("SevenLife:ShopRobbery:AcceptShop")
AddEventHandler(
    "SevenLife:ShopRobbery:AcceptShop",
    function()
        Shop = Randomize(Config.Randomize)
        Citizen.Wait(100)
        StartShopRobbery()
        TriggerEvent(
            "SevenLife:TimetCustom:Notify",
            "Wegweiser",
            "Fahre zum Markierten Punkt um den Laden auszurauben !",
            2000
        )
    end
)
function StartShopRobbery()
    SpawnPedForShot()

    TriggerServerEvent(
        "SevenLife:ShopRobbery:MakeBlips",
        Config.Shops[Shop.name].ShopPos.x,
        Config.Shops[Shop.name].ShopPos.y,
        Config.Shops[Shop.name].ShopPos.z
    )
    Citizen.Wait(500)
    ShopBlip =
        AddBlipForCoord(
        Config.Shops[Shop.name].ShopPos.x,
        Config.Shops[Shop.name].ShopPos.y,
        Config.Shops[Shop.name].ShopPos.z
    )
    SetBlipSprite(ShopBlip, 156)
    SetBlipDisplay(ShopBlip, 4)
    SetBlipScale(ShopBlip, 1.0)
    SetBlipColour(ShopBlip, 0)
    SetBlipAsShortRange(ShopBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Raub")
    EndTextCommandSetBlipName(ShopBlip)
    SetBlipRoute(ShopBlip, true)
    SetBlipRouteColour(ShopBlip, 59)

    Citizen.CreateThread(
        function()
            while true do
                local sleep = 500
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                if
                    (GetDistanceBetweenCoords(
                        coords,
                        Config.Shops[Shop.name].PedPos.x,
                        Config.Shops[Shop.name].PedPos.y,
                        Config.Shops[Shop.name].PedPos.z,
                        true
                    ) < 6.5)
                 then
                    sleep = 5
                    FreezeEntityPosition(NPCShop, false)
                    if IsPlayerFreeAiming(PlayerId()) then
                        local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
                        if IsPedFleeing(targetPed) and targetPed == NPCShop then
                            SetBlockingOfNonTemporaryEvents(NPCShop, true)
                            startAnim(NPCShop, "anim@mp_player_intuppersurrender", "enter")
                            local displaying = true
                            TaskGoToCoordAnyMeans(
                                NPCShop,
                                Config.Shops[Shop.name].PedWalks.x,
                                Config.Shops[Shop.name].PedWalks.y,
                                Config.Shops[Shop.name].PedWalks.z,
                                1.5
                            )

                            TriggerServerEvent("SevenLife:ShopRobbery:AlarmPD", GetEntityCoords(GetPlayerPed(-1)))

                            atlocation = false
                            Citizen.CreateThread(
                                function()
                                    Citizen.Wait(10000)
                                    if atlocation then
                                        SetEntityCoords(
                                            NPCShop,
                                            Config.Shops[Shop.name].PedWalks.x,
                                            Config.Shops[Shop.name].PedWalks.y,
                                            Config.Shops[Shop.name].PedWalks.z - 1
                                        )
                                        SetEntityHeading(NPCShop, Config.Shops[Shop.name].PedWalks.h)
                                    end
                                end
                            )
                            while true do
                                local coords2 = GetEntityCoords(NPCShop)
                                if
                                    (GetDistanceBetweenCoords(
                                        coords2,
                                        Config.Shops[Shop.name].PedWalks.x,
                                        Config.Shops[Shop.name].PedWalks.y,
                                        Config.Shops[Shop.name].PedWalks.z,
                                        true
                                    ) < 1.5)
                                 then
                                    atlocation = true
                                    SetEntityCoords(
                                        NPCShop,
                                        Config.Shops[Shop.name].PedWalks.x,
                                        Config.Shops[Shop.name].PedWalks.y,
                                        Config.Shops[Shop.name].PedWalks.z - 1
                                    )
                                    SetEntityHeading(NPCShop, Config.Shops[Shop.name].PedWalks.h)
                                    break
                                end
                                Citizen.Wait(5)
                            end

                            ClearPedTasks(NPCShop)
                            FreezeEntityPosition(NPCShop, true)
                            startAnim(NPCShop, "amb@prop_human_bum_bin@idle_a", "idle_a")

                            TimeDefault = Config.Shops[Shop.name].Time

                            Citizen.CreateThread(
                                function()
                                    Config.Shops[Shop.name].Time = Config.Shops[Shop.name].Time + 1
                                    while true do
                                        Config.Shops[Shop.name].Time = Config.Shops[Shop.name].Time - 1
                                        Citizen.Wait(1000)
                                        if Config.Shops[Shop.name].Time <= 0 then
                                            ClearPedTasks(NPCShop)
                                            local coordsPED = GetEntityCoords(NPCShop)
                                            startAnim(NPCShop, "anim@heists@box_carry@", "idle")
                                            pack =
                                                CreateObject(
                                                GetHashKey("prop_cash_case_02"),
                                                coordsPED.x,
                                                coordsPED.y,
                                                coordsPED.z,
                                                true,
                                                true,
                                                true
                                            )
                                            AttachEntityToEntity(
                                                pack,
                                                NPCShop,
                                                GetPedBoneIndex(NPCShop, 57005),
                                                0.20,
                                                0.05,
                                                -0.25,
                                                260.0,
                                                60.0,
                                                0,
                                                true,
                                                true,
                                                false,
                                                true,
                                                1,
                                                true
                                            )
                                            break
                                        end
                                    end
                                end
                            )

                            while true do
                                local ped = PlayerPedId()
                                local coords = GetEntityCoords(ped)
                                if Config.Shops[Shop.name].Time > 0 then
                                else
                                    if
                                        (GetDistanceBetweenCoords(
                                            coords,
                                            Config.Shops[Shop.name].PedWalks.x,
                                            Config.Shops[Shop.name].PedWalks.y,
                                            Config.Shops[Shop.name].PedWalks.z,
                                            true
                                        ) < 1.5)
                                     then
                                        if IsControlJustReleased(0, 38) and not IsPedInAnyVehicle(ped, false) then
                                            FreezeEntityPosition(NPCShop, false)
                                            TaskTurnPedToFaceEntity(NPCShop, PlayerPedId(), 0.2)
                                            startAnim(ped, "anim@gangops@facility@servers@bodysearch@", "player_search")

                                            Citizen.Wait(6500)
                                            ClearPedTasks(NPCShop)
                                            TaskPlayAnim(
                                                NPCShop,
                                                "anim@heists@box_carry@",
                                                "exit",
                                                3.0,
                                                1.0,
                                                -1,
                                                49,
                                                0,
                                                0,
                                                0,
                                                0
                                            )
                                            DeleteEntity(pack)
                                            ESX.TriggerServerCallback(
                                                "SevenLife:ShopRobbery:GiveMoney",
                                                function(money)
                                                    TriggerEvent(
                                                        "SevenLife:TimetCustom:Notify",
                                                        "Wegweiser",
                                                        "Du hast" .. moneysaving .. "$ bekommen !",
                                                        2000
                                                    )
                                                end,
                                                moneysaving
                                            )
                                            break
                                        end
                                    end
                                end
                                Citizen.Wait(5)
                            end
                            Citizen.Wait(5000)
                            RemoveBlip(ShopBlip)
                            DeletePed(NPCShop)
                            started = false
                            RemoveBlip(BlipSperZone)
                            ispedallowedtowalk = false
                            Config.Shops[Shop.name].Time = TimeDefault
                            ClearAllBlipRoutes()
                            break
                        end
                    end
                end
                Citizen.Wait(sleep)
            end
        end
    )
end

function Randomize(tb)
    local keys = {}
    for k in pairs(tb) do
        table.insert(keys, k)
    end
    return tb[keys[math.random(#keys)]]
end

function startAnim(ped, dictionary, anim)
    Citizen.CreateThread(
        function()
            RequestAnimDict(dictionary)
            while not HasAnimDictLoaded(dictionary) do
                Citizen.Wait(0)
            end
            TaskPlayAnim(ped, dictionary, anim, 8.0, -8.0, -1, 50, 0, false, false, false)
        end
    )
end
function SpawnPedForShot()
    local ped_hash = GetHashKey(Config.Shops[Shop.name].Type)
    RequestModel(ped_hash)
    while not HasModelLoaded(ped_hash) do
        Citizen.Wait(1)
    end
    NPCShop =
        CreatePed(
        1,
        ped_hash,
        Config.Shops[Shop.name].PedPos.x,
        Config.Shops[Shop.name].PedPos.y,
        Config.Shops[Shop.name].PedPos.z - 1,
        Config.Shops[Shop.name].PedPos.h,
        false,
        true
    )
    SetPedDiesWhenInjured(NPCShop, false)
    SetPedCanPlayAmbientAnims(NPCShop, true)
    SetPedCanRagdollFromPlayerImpact(NPCShop, false)
    SetEntityInvincible(NPCShop, true)
    FreezeEntityPosition(NPCShop, true)
end
function BlipMaking(x, y, z)
    BlipSperZone = AddBlipForCoord(x, y, z)
    SetBlipSprite(BlipSperZone, 161)
    SetBlipColour(BlipSperZone, 53)
    SetBlipDisplay(BlipSperZone, 4)
    SetBlipScale(BlipSperZone, 1.5)
    SetBlipAsShortRange(BlipSperZone, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Sperrzone")
    EndTextCommandSetBlipName(BlipSperZone)
end
RegisterNetEvent("SevenLife:ShopRobbery:MakeBlip")
AddEventHandler(
    "SevenLife:ShopRobbery:MakeBlip",
    function(x, y, z)
        BlipMaking(x, y, z)
    end
)
