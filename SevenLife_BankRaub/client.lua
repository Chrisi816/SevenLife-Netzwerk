local SecondRaub, EndRaub

local AtivRaubHardone, PlaySound = false, false
ESX = nil
local RouletteWords = {
    "7LIFE4EV",
    "ABSOLUTE",
    "CHRISIDE",
    "DOCTRINE",
    "IMPERIUS",
    "DELIRIUM",
    "PATRIZIA"
}

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
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1300)
            TriggerEvent(
                "skinchanger:getSkin",
                function(skin)
                    bag = skin["bags_1"]
                end
            )
        end
    end
)

function PlantBomb(x, y, z, h)
    Citizen.CreateThread(
        function()
            RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
            RequestModel("hei_p_m_bag_var22_arm_s")
            RequestModel("prop_bomb_01")
            while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and
                not HasModelLoaded("hei_p_m_bag_var22_arm_s") and
                not HasModelLoaded("prop_bomb_01") do
                Citizen.Wait(50)
            end
            local ped = PlayerPedId()
            SetEntityHeading(ped, h)
            Citizen.Wait(100)
            local rot = vec3(GetEntityRotation(ped))
            local bagscene =
                NetworkCreateSynchronisedScene(x + 0.5, y + 0.5, z, rot, 2, false, false, 1065353216, 0, 1.3)
            local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), x, y, z, true, true, false)

            NetworkAddPedToSynchronisedScene(
                ped,
                bagscene,
                "anim@heists@ornate_bank@thermal_charge",
                "thermal_charge",
                1.5,
                -4.0,
                1,
                16,
                1148846080,
                0
            )
            NetworkAddEntityToSynchronisedScene(
                bag,
                bagscene,
                "anim@heists@ornate_bank@thermal_charge",
                "bag_thermal_charge",
                4.0,
                -8.0,
                1
            )
            SetPedComponentVariation(ped, 5, 0, 0, 0)
            NetworkStartSynchronisedScene(bagscene)
            Citizen.Wait(1500)
            local x, y, z = table.unpack(GetEntityCoords(ped))
            local bomba = CreateObject(GetHashKey("prop_bomb_01"), x, y, z + 0.2, true, true, true)

            AttachEntityToEntity(
                bomba,
                ped,
                GetPedBoneIndex(ped, 28422),
                0,
                0,
                0,
                0,
                0,
                200.0,
                true,
                true,
                false,
                true,
                1,
                true
            )
            Citizen.Wait(3000)
            DeleteObject(bag)
            SetPedComponentVariation(ped, 5, 45, 0, 0)
            DetachEntity(bomba, 1, 1)
            FreezeEntityPosition(bomba, true)
            TriggerServerEvent("SevenLife:BankRob:DeleteBomba", bomba)
            NetworkStopSynchronisedScene(bagscene)
        end
    )
end

-- Start
local mistime = 1000
local ingarageparkrange = false
local outarea = false

Citizen.CreateThread(
    function()
        Citizen.Wait(3000)
        while true do
            Citizen.Wait(200)
            if not AtivRaubHardone then
                local player = GetPlayerPed(-1)
                local coords = GetEntityCoords(player)
                local distance =
                    GetDistanceBetweenCoords(
                    coords,
                    SevenConfig.FirstDoorOpen.x,
                    SevenConfig.FirstDoorOpen.y,
                    SevenConfig.FirstDoorOpen.z,
                    true
                )

                if distance < 40 then
                    outarea = true
                    if distance < 1.1 then
                        ingarageparkrange = true

                        TriggerEvent(
                            "sevenliferp:startnui",
                            "Drücke <span1 color = white>E</span1> um den Raub zu beginnen",
                            "System - Nachricht",
                            true
                        )
                    else
                        if distance >= 1.1 and distance <= 3.5 then
                            ingarageparkrange = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    outarea = false
                end
            else
                Citizen.Wait(5000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(mistime)
            if not AtivRaubHardone then
                if outarea then
                    mistime = 1
                    DrawMarker(
                        SevenConfig.MarkerType,
                        SevenConfig.FirstDoorOpen.x,
                        SevenConfig.FirstDoorOpen.y,
                        SevenConfig.FirstDoorOpen.z - 1,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        vector3(1.0, 1.0, 1.0),
                        SevenConfig.MarkerColor.r,
                        SevenConfig.MarkerColor.g,
                        SevenConfig.MarkerColor.b,
                        100,
                        false,
                        true,
                        2,
                        false,
                        nil,
                        nil,
                        false
                    )
                else
                    mistime = 1000
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
            if not AtivRaubHardone then
                if ingarageparkrange then
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent("sevenliferp:closenotify", false)
                        if bag == 40 or bag == 41 or bag == 44 or bag == 45 then
                            ESX.TriggerServerCallback(
                                "SevenLife:BankRaub:CheckIfPlayerHaveItem",
                                function(have)
                                    if have then
                                        ESX.TriggerServerCallback(
                                            "SevenLife:BankRaub:CheckIfRaubIsOnGoing",
                                            function(have)
                                                if have then
                                                    TriggerEvent(
                                                        "SevenLife:TimetCustom:Notify",
                                                        "Bankraub",
                                                        "Raub ist schon im Gange",
                                                        2000
                                                    )
                                                else
                                                    TriggerEvent("SevenLife:BankRaub:GetMoneyFromKasse")
                                                    TriggerEvent("sevenliferp:closenotify", false)
                                                    AtivRaubHardone = true
                                                    PlantBomb(
                                                        SevenConfig.FirstDoorOpen.x,
                                                        SevenConfig.FirstDoorOpen.y,
                                                        SevenConfig.FirstDoorOpen.z,
                                                        SevenConfig.FirstDoorOpen.heading
                                                    )
                                                    TriggerServerEvent(
                                                        "SevenLife:BankRob:SyncPlaceOfBomb",
                                                        SevenConfig.FirstDoorOpen.x,
                                                        SevenConfig.FirstDoorOpen.y,
                                                        SevenConfig.FirstDoorOpen.z,
                                                        SevenConfig.FirstDoorOpen.heading,
                                                        1
                                                    )
                                                    TriggerEvent("SevenLife:BankRaub:StartSecondDoor")
                                                    SecondRaub = true
                                                end
                                            end
                                        )
                                    else
                                        TriggerEvent(
                                            "SevenLife:TimetCustom:Notify",
                                            "Bankraub",
                                            "Du brauchst mehr c4 um den Raub zu starten",
                                            2000
                                        )
                                    end
                                end,
                                "bigc4",
                                2
                            )
                        else
                            TriggerEvent(
                                "SevenLife:TimetCustom:Notify",
                                "Bankraub",
                                "Du brauchst eine Tasche um den Raub zu starten",
                                2000
                            )
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(2000)
            end
        end
    end
)

RegisterNetEvent("SevenLife:BankRaub:StartSecondDoor")
AddEventHandler(
    "SevenLife:BankRaub:StartSecondDoor",
    function()
        ingarageparkrange = false
        outarea = false
        Citizen.CreateThread(
            function()
                Citizen.Wait(3000)
                while SecondRaub do
                    Citizen.Wait(200)
                    if SecondRaub then
                        local player = GetPlayerPed(-1)
                        local coords = GetEntityCoords(player)
                        local distance =
                            GetDistanceBetweenCoords(
                            coords,
                            SevenConfig.SecondDoorOpen.x,
                            SevenConfig.SecondDoorOpen.y,
                            SevenConfig.SecondDoorOpen.z,
                            true
                        )

                        if distance < 40 then
                            outarea = true
                            if distance < 1.1 then
                                ingarageparkrange = true

                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um den Raub fortzuseten",
                                    "System - Nachricht",
                                    true
                                )
                            else
                                if distance >= 1.1 and distance <= 4 then
                                    ingarageparkrange = false
                                    TriggerEvent("sevenliferp:closenotify", false)
                                end
                            end
                        else
                            outarea = false
                        end
                    else
                        Citizen.Wait(5000)
                    end
                end
            end
        )

        Citizen.CreateThread(
            function()
                while SecondRaub do
                    Citizen.Wait(mistime)
                    if SecondRaub then
                        if outarea then
                            mistime = 1
                            DrawMarker(
                                SevenConfig.MarkerType,
                                SevenConfig.SecondDoorOpen.x,
                                SevenConfig.SecondDoorOpen.y,
                                SevenConfig.SecondDoorOpen.z - 1,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                vector3(1.0, 1.0, 1.0),
                                SevenConfig.MarkerColor.r,
                                SevenConfig.MarkerColor.g,
                                SevenConfig.MarkerColor.b,
                                100,
                                false,
                                true,
                                2,
                                false,
                                nil,
                                nil,
                                false
                            )
                        else
                            mistime = 1000
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
                while SecondRaub do
                    Citizen.Wait(5)
                    if SecondRaub then
                        if ingarageparkrange then
                            if IsControlJustPressed(0, 38) then
                                TriggerEvent("sevenliferp:closenotify", false)
                                if bag == 40 or bag == 41 or bag == 44 or bag == 45 then
                                    ESX.TriggerServerCallback(
                                        "SevenLife:BankRaub:CheckIfPlayerHaveItem",
                                        function(have)
                                            if have then
                                                TriggerEvent("sevenliferp:closenotify", false)
                                                AtivRaubHardone = true
                                                PlantBomb(
                                                    SevenConfig.SecondDoorOpen.x,
                                                    SevenConfig.SecondDoorOpen.y,
                                                    SevenConfig.SecondDoorOpen.z,
                                                    SevenConfig.SecondDoorOpen.heading
                                                )
                                                TriggerServerEvent(
                                                    "SevenLife:BankRob:SyncPlaceOfBomb2",
                                                    SevenConfig.SecondDoorOpen.x,
                                                    SevenConfig.SecondDoorOpen.y,
                                                    SevenConfig.SecondDoorOpen.z,
                                                    SevenConfig.SecondDoorOpen.heading,
                                                    4
                                                )
                                                SecondRaub = false
                                                TriggerEvent("SevenLife:BankRaub:EndlessStart")
                                            else
                                                TriggerEvent(
                                                    "SevenLife:TimetCustom:Notify",
                                                    "Bankraub",
                                                    "Du brauchst mehr c4 um den Raub zu starten",
                                                    2000
                                                )
                                            end
                                        end,
                                        "bigc4",
                                        2
                                    )
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Bankraub",
                                        "Du brauchst eine Tasche um den Raub zu starten",
                                        2000
                                    )
                                end
                            end
                        else
                            Citizen.Wait(1000)
                        end
                    else
                        Citizen.Wait(2000)
                    end
                end
            end
        )
    end
)

RegisterNetEvent("SevenLife:BankRob:SyncPlayerBomb")
AddEventHandler(
    "SevenLife:BankRob:SyncPlayerBomb",
    function(x, y, z, h, id)
        TriggerServerEvent("SevenLife:BankRaub:MakeAlarm", 1)
        AddExplosion(x, y, z, 2, 1.0, true, false, 1.0, true)
        AddExplosion(x, y, z, 2, 1.0, true, false, 1.0, true)
        DeleteObject(bomba)
        TriggerServerEvent("SevenLife:BankRob:DeleteBomba", bomba)
        TriggerEvent("SevenLife:Doorlock:OpenDoor", id)
    end
)

RegisterNetEvent("SevenLife:BankRob:ApplyBomba")
AddEventHandler(
    "SevenLife:BankRob:ApplyBomba",
    function(x, y, z, h)
        AtivRaubHardone = true
        local ped = GetPlayerPed(-1)
        bomba = CreateObject(GetHashKey("prop_bomb_01"), x, y, z + 0.2, true, true, true)

        AttachEntityToEntity(
            bomba,
            ped,
            GetPedBoneIndex(ped, 28422),
            0,
            0,
            0,
            0,
            0,
            200.0,
            true,
            true,
            false,
            true,
            1,
            true
        )
        Citizen.Wait(3000)
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        DetachEntity(bomba, 1, 1)
        FreezeEntityPosition(bomba, true)
    end
)

RegisterNetEvent("SevenLife:BankRob:DeleteBombaSync")
AddEventHandler(
    "SevenLife:BankRob:DeleteBombaSync",
    function(bomba)
        DeleteObject(bomba)
    end
)

local notifys = true
local inmarker = false
local inmenu = true
local timemains = 100
local terminate = false
local OutCome = 0
RegisterNetEvent("SevenLife:BankRaub:GiveArchive")
AddEventHandler(
    "SevenLife:BankRaub:GiveArchive",
    function()
        TriggerEvent("SevenLife:BankRaub:GetMoneyFromKasse")
        terminate = true
        Citizen.CreateThread(
            function()
                while terminate do
                    Citizen.Wait(timemains)
                    local ped = GetPlayerPed(-1)
                    local coords = GetEntityCoords(ped)

                    for k, v in pairs(SevenConfig.GetAllArchive) do
                        if v.used == false then
                            local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                            if distance < 40 then
                                timemains = 5
                                if distance < 15 then
                                    DrawMarker(
                                        20,
                                        v.x,
                                        v.y,
                                        v.z,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0.6,
                                        0.6,
                                        0.6,
                                        234,
                                        0,
                                        122,
                                        200,
                                        1,
                                        1,
                                        0,
                                        0
                                    )
                                    timemains = 1
                                    if distance < 1 then
                                        inmarker = true
                                        IDshelf = v.id
                                        if notifys then
                                            TriggerEvent(
                                                "sevenliferp:startnui",
                                                "Drücke <span1 color = white>E</span1> um den Schrank zu plündern",
                                                "System - Nachricht",
                                                true
                                            )
                                        end
                                    else
                                        if distance >= 1.1 and distance <= 2 then
                                            inmarker = false
                                            TriggerEvent("sevenliferp:closenotify", false)
                                        end
                                    end
                                end
                            else
                                inmarker = false
                                timemains = 100
                            end
                        end
                    end
                end
            end
        )

        Citizen.CreateThread(
            function()
                Citizen.Wait(10)
                while terminate do
                    Citizen.Wait(5)

                    if inmarker then
                        if IsControlJustPressed(0, 38) then
                            if inmenu then
                                for k, v in ipairs(SevenConfig.GetAllArchive) do
                                    if v.id == IDshelf then
                                        TriggerEvent("sevenliferp:closenotify", false)
                                        notifys = false
                                        inmenu = true

                                        RequestAnimDict("mp_arresting")
                                        while (not HasAnimDictLoaded("mp_arresting")) do
                                            Citizen.Wait(0)
                                        end
                                        SetEntityHeading(GetPlayerPed(-1), v.h)
                                        TaskPlayAnim(
                                            GetPlayerPed(-1),
                                            "mp_arresting",
                                            "a_uncuff",
                                            8.0,
                                            -8.0,
                                            10000,
                                            1,
                                            0,
                                            false,
                                            false,
                                            false
                                        )

                                        Citizen.Wait(10000)
                                        ClearPedTasks(GetPlayerPed(-1))
                                        v.used = true
                                        notifys = true
                                        inmarker = false
                                        TriggerServerEvent("SevenLife:BankRaub:GiveItem")
                                        TriggerEvent("sevenliferp:closenotify", false)
                                        OutCome = OutCome + 1
                                        if OutCome == 5 then
                                            terminate = false
                                            for k, v in ipairs(SevenConfig.GetAllArchive) do
                                                SevenConfig.GetAllArchive[k].used = false
                                            end
                                            inmenu = false
                                            Citizen.Wait(1000)
                                            TriggerEvent("sevenliferp:closenotify", false)
                                        end
                                    end
                                end
                            end
                        end
                    else
                        Citizen.Wait(1000)
                    end
                end
            end
        )
    end
)

RegisterNetEvent("SevenLife:BankRaub:EndlessStart")
AddEventHandler(
    "SevenLife:BankRaub:EndlessStart",
    function()
        EndRaub = true
        ingarageparkrange = false
        outarea = false
        Citizen.CreateThread(
            function()
                Citizen.Wait(3000)
                while EndRaub do
                    Citizen.Wait(200)
                    if EndRaub then
                        local player = GetPlayerPed(-1)
                        local coords = GetEntityCoords(player)
                        local distance =
                            GetDistanceBetweenCoords(
                            coords,
                            SevenConfig.DritteDoorOpen.x,
                            SevenConfig.DritteDoorOpen.y,
                            SevenConfig.DritteDoorOpen.z,
                            true
                        )

                        if distance < 40 then
                            outarea = true
                            if distance < 1.1 then
                                ingarageparkrange = true

                                TriggerEvent(
                                    "sevenliferp:startnui",
                                    "Drücke <span1 color = white>E</span1> um den Raub fortzuseten",
                                    "System - Nachricht",
                                    true
                                )
                            else
                                if distance >= 1.1 and distance <= 4 then
                                    ingarageparkrange = false
                                    TriggerEvent("sevenliferp:closenotify", false)
                                end
                            end
                        else
                            outarea = false
                        end
                    else
                        Citizen.Wait(5000)
                    end
                end
            end
        )

        Citizen.CreateThread(
            function()
                while EndRaub do
                    Citizen.Wait(mistime)
                    if EndRaub then
                        if outarea then
                            mistime = 1
                            DrawMarker(
                                SevenConfig.MarkerType,
                                SevenConfig.DritteDoorOpen.x,
                                SevenConfig.DritteDoorOpen.y,
                                SevenConfig.DritteDoorOpen.z - 1,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                vector3(1.0, 1.0, 1.0),
                                SevenConfig.MarkerColor.r,
                                SevenConfig.MarkerColor.g,
                                SevenConfig.MarkerColor.b,
                                100,
                                false,
                                true,
                                2,
                                false,
                                nil,
                                nil,
                                false
                            )
                        else
                            mistime = 1000
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
                while EndRaub do
                    Citizen.Wait(5)
                    if EndRaub then
                        if ingarageparkrange then
                            if IsControlJustPressed(0, 38) then
                                TriggerEvent("sevenliferp:closenotify", false)
                                if bag == 40 or bag == 41 or bag == 44 or bag == 45 then
                                    ESX.TriggerServerCallback(
                                        "SevenLife:BankRaub:CheckIfPlayerHaveItem",
                                        function(have)
                                            if have then
                                                TriggerEvent("sevenliferp:closenotify", false)
                                                EndRaub = false
                                                Hack()
                                                scaleform = Initialize("HACKING_PC")
                                                UsingComputer = true
                                            else
                                                TriggerEvent(
                                                    "SevenLife:TimetCustom:Notify",
                                                    "Bankraub",
                                                    "Du brauchst ein Laptop um zu hacken",
                                                    2000
                                                )
                                            end
                                        end,
                                        "laptop",
                                        1
                                    )
                                else
                                    TriggerEvent(
                                        "SevenLife:TimetCustom:Notify",
                                        "Bankraub",
                                        "Du brauchst eine Tasche um den Raub zu starten",
                                        2000
                                    )
                                end
                            end
                        else
                            Citizen.Wait(1000)
                        end
                    else
                        Citizen.Wait(2000)
                    end
                end
            end
        )
    end
)

Citizen.CreateThread(
    function()
        function Initialize(scaleform)
            local scaleform = RequestScaleformMovieInteractive(scaleform)
            while not HasScaleformMovieLoaded(scaleform) do
                Citizen.Wait(0)
            end

            local CAT = "hack"
            local CurrentSlot = 0
            while HasAdditionalTextLoaded(CurrentSlot) and not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
                Citizen.Wait(0)
                CurrentSlot = CurrentSlot + 1
            end

            if not HasThisAdditionalTextLoaded(CAT, CurrentSlot) then
                ClearAdditionalText(CurrentSlot, true)
                RequestAdditionalText(CAT, CurrentSlot)
                while not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
                    Citizen.Wait(0)
                end
            end
            PushScaleformMovieFunction(scaleform, "SET_LABELS")
            ScaleformLabel("H_ICON_1")
            ScaleformLabel("H_ICON_2")
            ScaleformLabel("H_ICON_3")
            ScaleformLabel("H_ICON_4")
            ScaleformLabel("H_ICON_5")
            ScaleformLabel("H_ICON_6")
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_BACKGROUND")
            PushScaleformMovieFunctionParameterInt(1)
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
            PushScaleformMovieFunctionParameterFloat(1.0)
            PushScaleformMovieFunctionParameterFloat(4.0)
            PushScaleformMovieFunctionParameterString("My Computer")
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
            PushScaleformMovieFunctionParameterFloat(6.0)
            PushScaleformMovieFunctionParameterFloat(6.0)
            PushScaleformMovieFunctionParameterString("Power Off")
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_LIVES")
            PushScaleformMovieFunctionParameterInt(lives)
            PushScaleformMovieFunctionParameterInt(5)
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(0)
            PushScaleformMovieFunctionParameterInt(math.random(150, 255))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(1)
            PushScaleformMovieFunctionParameterInt(math.random(160, 255))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(2)
            PushScaleformMovieFunctionParameterInt(math.random(170, 255))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(3)
            PushScaleformMovieFunctionParameterInt(math.random(190, 255))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(4)
            PushScaleformMovieFunctionParameterInt(math.random(200, 255))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(5)
            PushScaleformMovieFunctionParameterInt(math.random(210, 255))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(6)
            PushScaleformMovieFunctionParameterInt(math.random(220, 255))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(7)
            PushScaleformMovieFunctionParameterInt(255)
            PopScaleformMovieFunctionVoid()
            return scaleform
        end
        scaleform = Initialize("HACKING_PC")
        while true do
            Citizen.Wait(2)
            if UsingComputer then
                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
                PushScaleformMovieFunction(scaleform, "SET_CURSOR")
                PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 239))
                PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 240))
                PopScaleformMovieFunctionVoid()

                if IsDisabledControlJustPressed(0, 24) and not SorF then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
                    ClickReturn = PopScaleformMovieFunction()
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 176) and Hacking then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
                    ClickReturn = PopScaleformMovieFunction()
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 25) and not Hacking and not SorF then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_BACK")
                    PopScaleformMovieFunctionVoid()
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 172) and Hacking then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                    PushScaleformMovieFunctionParameterInt(8)
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 173) and Hacking then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                    PushScaleformMovieFunctionParameterInt(9)
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 174) and Hacking then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                    PushScaleformMovieFunctionParameterInt(10)
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 175) and Hacking then
                    PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                    PushScaleformMovieFunctionParameterInt(11)
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                end
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(2)
            if HasScaleformMovieLoaded(scaleform) and UsingComputer then
                disableinput = true
                TriggerEvent("SevenLife:BankRaub:DisableInput")
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)

                if IsScaleformMovieMethodReturnValueReady(ClickReturn) then
                    program = GetScaleformMovieFunctionReturnInt(ClickReturn)
                    if program == 82 and not Hacking then
                        lives = 5
                        PushScaleformMovieFunction(scaleform, "SET_LIVES")
                        PushScaleformMovieFunctionParameterInt(lives)
                        PushScaleformMovieFunctionParameterInt(5)
                        PopScaleformMovieFunctionVoid()

                        PushScaleformMovieFunction(scaleform, "OPEN_APP")
                        PushScaleformMovieFunctionParameterFloat(0.0)
                        PopScaleformMovieFunctionVoid()
                        Hacking = true
                    elseif program == 83 and not Hacking and Ipfinished then
                        PushScaleformMovieFunction(scaleform, "SET_LIVES")
                        PushScaleformMovieFunctionParameterInt(lives)
                        PushScaleformMovieFunctionParameterInt(5)
                        PopScaleformMovieFunctionVoid()

                        PushScaleformMovieFunction(scaleform, "OPEN_APP")
                        PushScaleformMovieFunctionParameterFloat(1.0)
                        PopScaleformMovieFunctionVoid()

                        PushScaleformMovieFunction(scaleform, "SET_ROULETTE_WORD")
                        PushScaleformMovieFunctionParameterString(RouletteWords[math.random(#RouletteWords)])
                        PopScaleformMovieFunctionVoid()

                        Hacking = true
                    elseif Hacking and program == 87 then
                        lives = lives - 1
                        PushScaleformMovieFunction(scaleform, "SET_LIVES")
                        PushScaleformMovieFunctionParameterInt(lives)
                        PushScaleformMovieFunctionParameterInt(5)
                        PopScaleformMovieFunctionVoid()
                        PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                    elseif Hacking and program == 84 then
                        PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                        PushScaleformMovieFunction(scaleform, "SET_IP_OUTCOME")
                        PushScaleformMovieFunctionParameterBool(true)
                        ScaleformLabel(0x18EBB648)
                        PopScaleformMovieFunctionVoid()
                        PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                        PopScaleformMovieFunctionVoid()
                        Hacking = false
                        Ipfinished = true
                    elseif Hacking and program == 85 then
                        PlaySoundFrontend(-1, "HACKING_FAILURE", "", false)
                        PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                        PopScaleformMovieFunctionVoid()
                        Hacking = false
                        SorF = false
                    elseif Hacking and program == 86 then
                        SorF = true
                        PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                        PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                        PushScaleformMovieFunctionParameterBool(true)
                        ScaleformLabel("WINBRUTE")
                        PopScaleformMovieFunctionVoid()
                        Wait(0)
                        PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                        PopScaleformMovieFunctionVoid()
                        Hacking = false
                        SorF = false
                        SetScaleformMovieAsNoLongerNeeded(scaleform)
                        DisableControlAction(0, 24, false)
                        DisableControlAction(0, 25, false)
                        FreezeEntityPosition(PlayerPedId(), false)

                        UsingComputer = false
                        Ipfinished = false

                        TriggerServerEvent("SevenLife:BankRaub:OpenVault", 1)
                        TriggerServerEvent("SevenLife:BankRuab:StartGas")
                        disableinput = false
                        hackfinish = true

                        stage1break = true
                    elseif program == 6 then
                        TriggerServerEvent("utk:upVar_s", "hacking_s", false)
                        UsingComputer = false
                        hackfinish = true
                        disableinput = false
                        SetScaleformMovieAsNoLongerNeeded(scaleform)
                        DisableControlAction(0, 24, false)
                        DisableControlAction(0, 25, false)
                        FreezeEntityPosition(PlayerPedId(), false)
                    end

                    if Hacking then
                        PushScaleformMovieFunction(scaleform, "SHOW_LIVES")
                        PushScaleformMovieFunctionParameterBool(true)
                        PopScaleformMovieFunctionVoid()
                        if lives <= 0 then
                            SorF = true
                            PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
                            PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                            PushScaleformMovieFunctionParameterBool(false)
                            ScaleformLabel("LOSEBRUTE")
                            PopScaleformMovieFunctionVoid()
                            Wait(1000)
                            PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                            PopScaleformMovieFunctionVoid()
                            TriggerServerEvent("utk:upVar_s", "hacking_s", false)
                            disableinput = false
                            Hacking = false
                            SorF = false
                        end
                    end
                end
            else
                Wait(250)
            end
        end
    end
)

function Hack()
    hackfinish = false
    local loc = {
        SevenConfig.DritteDoorOpen.x,
        SevenConfig.DritteDoorOpen.y,
        SevenConfig.DritteDoorOpen.z,
        SevenConfig.DritteDoorOpen.h
    }

    loc.x = 253.34
    loc.y = 228.25
    loc.z = 101.39
    loc.h = 63.60

    local animDict = "anim@heists@ornate_bank@hack"

    RequestAnimDict(animDict)
    RequestModel("hei_prop_hst_laptop")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestModel("hei_prop_heist_card_hack_02")
    while not HasAnimDictLoaded(animDict) or not HasModelLoaded("hei_prop_hst_laptop") or
        not HasModelLoaded("hei_p_m_bag_var22_arm_s") or
        not HasModelLoaded("hei_prop_heist_card_hack_02") do
        Citizen.Wait(100)
    end
    local ped = PlayerPedId()
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))

    SetEntityHeading(ped, loc.h)
    local animPos = GetAnimInitialOffsetPosition(animDict, "hack_enter", loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, "hack_loop", loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, "hack_exit", loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)

    FreezeEntityPosition(ped, true)
    local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), targetPosition, 1, 1, 0)
    local laptop = CreateObject(GetHashKey("hei_prop_hst_laptop"), targetPosition, 1, 1, 0)
    local card = CreateObject(GetHashKey("hei_prop_heist_card_hack_02"), targetPosition, 1, 1, 0)

    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "hack_enter_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_enter_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, netScene, animDict, "hack_enter_card", 4.0, -8.0, 1)

    local netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "hack_loop_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, "hack_loop_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, netScene2, animDict, "hack_loop_card", 4.0, -8.0, 1)

    local netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "hack_exit_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, "hack_exit_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, netScene3, animDict, "hack_exit_card", 4.0, -8.0, 1)

    SetPedComponentVariation(ped, 5, 0, 0, 0)
    Citizen.Wait(200)
    NetworkStartSynchronisedScene(netScene)
    Citizen.Wait(6300)
    NetworkStartSynchronisedScene(netScene2)
    Citizen.Wait(2000)
    Brute()

    while not hackfinish do
        Citizen.Wait(1)
    end
    Citizen.Wait(1500)
    NetworkStartSynchronisedScene(netScene3)
    Citizen.Wait(4600)
    NetworkStopSynchronisedScene(netScene3)
    DeleteObject(bag)
    DeleteObject(laptop)
    DeleteObject(card)
    FreezeEntityPosition(ped, false)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
end

function Brute()
    scaleform = Initialize("HACKING_PC")
    UsingComputer = true
end
function ScaleformLabel(label)
    BeginTextCommandScaleformString(label)
    EndTextCommandScaleformString()
end
RegisterNetEvent("SevenLife:BankRaub:DisableInput")
AddEventHandler(
    "SevenLife:BankRaub:DisableInput",
    function()
        Citizen.CreateThread(
            function()
                while true do
                    local enabled = false

                    Citizen.Wait(1)
                    if disableinput then
                        enabled = true
                        DisableControl()
                    end
                    if not enabled then
                        Citizen.Wait(1000)
                    end
                end
            end
        )
    end
)
function DisableControl()
    DisableControlAction(0, 73, false)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 31, true)
    DisableControlAction(0, 30, true)
    DisableControlAction(0, 45, true)
    DisableControlAction(0, 22, true)
    DisableControlAction(0, 44, true)
    DisableControlAction(0, 37, true)
    DisableControlAction(0, 23, true)
    DisableControlAction(0, 288, true)
    DisableControlAction(0, 289, true)
    DisableControlAction(0, 170, true)
    DisableControlAction(0, 167, true)
    DisableControlAction(0, 73, true)
    DisableControlAction(2, 199, true)
    DisableControlAction(0, 47, true)
    DisableControlAction(0, 264, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 143, true)
end
RegisterNetEvent("SevenLife:BankRaubC:OpenVault")
AddEventHandler(
    "SevenLife:BankRaubC:OpenVault",
    function(methode)
        TriggerEvent("SevenLife:BankRaub:OpenVaultValid", methode)
        TriggerEvent("SevenLife:Vault:Sound")
    end
)
vault = {x = 253.92, y = 224.56, z = 101.88, type = "v_ilev_bk_vaultdoor"}
RegisterNetEvent("SevenLife:BankRaub:OpenVaultValid")
AddEventHandler(
    "SevenLife:BankRaub:OpenVaultValid",
    function(method)
        local obj =
            GetClosestObjectOfType(
            vault.x,
            vault.y,
            vault.z,
            2.0,
            GetHashKey("v_ilev_bk_vaultdoor"),
            false,
            false,
            false
        )

        local count = 0
        if method == 1 then
            repeat
                local rotation = GetEntityHeading(obj) - 0.05

                SetEntityHeading(obj, rotation)
                count = count + 1
                Citizen.Wait(10)
            until count == 1100
        else
            repeat
                local rotation = GetEntityHeading(obj) + 0.05

                SetEntityHeading(obj, rotation)
                count = count + 1
                Citizen.Wait(10)
            until count == 1100
        end
        FreezeEntityPosition(obj, true)
    end
)
RegisterNetEvent("SevenLife:Vault:Sound")
AddEventHandler(
    "SevenLife:Vault:Sound",
    function()
        local coords = GetEntityCoords(PlayerPedId())
        local count = 0

        if GetDistanceBetweenCoords(coords, vault.x, vault.y, vault.z, true) <= 10 then
            repeat
                PlaySoundFrontend(-1, "OPENING", "MP_PROPERTIES_ELEVATOR_DOORS", 1)
                Citizen.Wait(900)
                count = count + 1
            until count == 17
        end
    end
)

Ausgeklungen, start = false, true, false

local notifys1 = true
local inmarker1 = false
local inmenu1 = false
local timemains1 = 100
local terminate1 = false
local OutCome1 = 0
local activealready = false
RegisterNetEvent("SevenLife:BankRaub:GetMoneyFromKasse")
AddEventHandler(
    "SevenLife:BankRaub:GetMoneyFromKasse",
    function()
        if not activealready then
            activealready = true
            TriggerServerEvent("SevenLife:BankRaub:GetMoneyFromKasseS")
            terminate1 = true
            Citizen.CreateThread(
                function()
                    while terminate1 do
                        Citizen.Wait(timemains1)
                        local ped = GetPlayerPed(-1)
                        local coords = GetEntityCoords(ped)

                        for k, v in pairs(SevenConfig.Kassen) do
                            if v.used == false then
                                local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                                if distance < 40 then
                                    timemains1 = 5
                                    if distance < 15 then
                                        DrawMarker(
                                            20,
                                            v.x,
                                            v.y,
                                            v.z,
                                            0,
                                            0,
                                            0,
                                            0,
                                            0,
                                            0,
                                            0.6,
                                            0.6,
                                            0.6,
                                            234,
                                            0,
                                            122,
                                            200,
                                            1,
                                            1,
                                            0,
                                            0
                                        )
                                        timemains1 = 1
                                        if distance < 1 then
                                            inmarker1 = true
                                            IDKasse = v.id
                                            if notifys1 then
                                                TriggerEvent(
                                                    "sevenliferp:startnui",
                                                    "Drücke <span1 color = white>E</span1> um die Kasse zu plündern",
                                                    "System - Nachricht",
                                                    true
                                                )
                                            end
                                        else
                                            if distance >= 1.1 and distance <= 2 then
                                                inmarker1 = false
                                                TriggerEvent("sevenliferp:closenotify", false)
                                            end
                                        end
                                    end
                                else
                                    inmarker1 = false
                                    timemains1 = 100
                                end
                            end
                        end
                    end
                end
            )

            Citizen.CreateThread(
                function()
                    Citizen.Wait(10)
                    while terminate1 do
                        Citizen.Wait(5)
                        local Ped = GetPlayerPed(-1)
                        if inmarker1 then
                            if IsControlJustPressed(0, 38) then
                                if not inmenu1 then
                                    for k, v in ipairs(SevenConfig.Kassen) do
                                        if v.id == IDKasse then
                                            TriggerEvent("sevenliferp:closenotify", false)
                                            notifys1 = false
                                            inmenu1 = true
                                            local animDict = "anim@heists@ornate_bank@grab_cash"
                                            local animName = "grab"
                                            LoadAnim(animDict)

                                            SetEntityHeading(Ped, v.h)

                                            TaskPlayAnim(Ped, animDict, animName, 1.0, -1.0, -1, 2, 0, 0, 0, 0)

                                            Citizen.Wait(7500)
                                            ClearPedTasks(Ped)
                                            TriggerEvent(
                                                "SevenLife:TimetCustom:Notify",
                                                "Bankraub",
                                                "Kasse erfolgreich ausgeraubt",
                                                2000
                                            )
                                            TriggerServerEvent("SevenLife:BankRaub:GiveCash")

                                            inmenu1 = false
                                            v.used = true
                                            notifys1 = true
                                            inmarker1 = false

                                            TriggerEvent("sevenliferp:closenotify", false)
                                            OutCome1 = OutCome1 + 1
                                            if OutCome1 == 2 then
                                                for k, v in ipairs(SevenConfig.Kassen) do
                                                    SevenConfig.Kassen[k].used = false
                                                end
                                                inmenu1 = false

                                                terminate1 = false
                                                Citizen.Wait(1000)
                                                TriggerEvent("sevenliferp:closenotify", false)
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            Citizen.Wait(1000)
                        end
                    end
                end
            )
        end
    end
)
RegisterNetEvent("SevenLife:BankRaub:GetMoneyFromKasseC")
AddEventHandler(
    "SevenLife:BankRaub:GetMoneyFromKasseC",
    function()
        activealready = true
    end
)
function InsertIntoList(models, parameteres)
    Ausgeraubt[models] = parameteres
end

function LoadAnim(animDict)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
end
RegisterNetEvent("SevenLife:BankRaub:Ausgeklungen")
AddEventHandler(
    "SevenLife:BankRaub:Ausgeklungen",
    function()
        Ausgeklungen = true
        Ausgeraubt = {}
    end
)
RegisterNetEvent("SevenLife:BankRaub:MakeGas")
AddEventHandler(
    "SevenLife:BankRaub:MakeGas",
    function()
        TriggerEvent("SevenLife:BankRaub:StartDrill")
        starttimer = true
        vaulttime = 500

        repeat
            Citizen.Wait(1000)
            vaulttime = vaulttime - 1
        until vaulttime == 0

        if vaulttime == 0 then
            begingas = true
        end

        Citizen.CreateThread(
            function()
                RequestNamedPtfxAsset("core")
                while not HasNamedPtfxAssetLoaded("core") do
                    Citizen.Wait(10)
                end
                while true do
                    Citizen.Wait(1)
                    if begingas then
                        SetPtfxAssetNextCall("core")
                        Gas =
                            StartNetworkedParticleFxNonLoopedAtCoord(
                            "veh_respray_smoke",
                            262.78,
                            213.22,
                            101.68,
                            0.0,
                            0.0,
                            0.0,
                            0.80,
                            false,
                            false,
                            false,
                            false
                        )
                        SetPtfxAssetNextCall("core")
                        Gas2 =
                            StartNetworkedParticleFxNonLoopedAtCoord(
                            "veh_respray_smoke",
                            257.71,
                            216.64,
                            101.68,
                            0.0,
                            0.0,
                            0.0,
                            1.50,
                            false,
                            false,
                            false,
                            false
                        )
                        SetPtfxAssetNextCall("core")
                        Gas3 =
                            StartNetworkedParticleFxNonLoopedAtCoord(
                            "veh_respray_smoke",
                            252.71,
                            218.22,
                            101.68,
                            0.0,
                            0.0,
                            0.0,
                            1.50,
                            false,
                            false,
                            false,
                            false
                        )
                        Citizen.Wait(5000)
                        StopParticleFxLooped(Gas, 0)
                        StopParticleFxLooped(Gas2, 0)
                        StopParticleFxLooped(Gas3, 0)
                        Citizen.Wait(60 * 60000)
                        TriggerEvent("SevenLife:BankRaub:ResetEveryThing")
                    end
                end
            end
        )
        Citizen.Wait(5000)
        starttimer = false
        Citizen.Wait(30000)
        begingas = false
    end
)
local safe_drilling = false
RegisterNetEvent("SevenLife:BankRaub:StartDrill")
AddEventHandler(
    "SevenLife:BankRaub:StartDrill",
    function()
        local ped = GetPlayerPed(-1)
        Citizen.CreateThread(
            function()
                while true do
                    Citizen.Wait(3)
                    local sleep = true
                    local coords = GetEntityCoords(ped)
                    for k, v in pairs(SevenConfig.DoorsDrill) do
                        local distance =
                            GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.pos[1], v.pos[2], v.pos[3], false)
                        if distance < 5.0 then
                            sleep = false
                            if distance < 1.0 then
                                if not v.robbed then
                                    if not v.failed then
                                        if not safe_drilling then
                                            DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], "[E] Bohre den Safe Auf")
                                            if IsControlJustPressed(0, 38) then
                                                ESX.TriggerServerCallback(
                                                    "SevenLife:BankRaub:CheckIfPlayerHaveItem",
                                                    function(has_drill)
                                                        if has_drill then
                                                            DrillClosestSafe(k, v)
                                                        else
                                                            TriggerEvent(
                                                                "SevenLife:TimetCustom:Notify",
                                                                "Bankraub",
                                                                "Du brauchst einen Bohrer",
                                                                2000
                                                            )
                                                        end
                                                    end,
                                                    "bohrer",
                                                    1
                                                )
                                            end
                                        end
                                    else
                                        DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], "Safe zerstört")
                                    end
                                    if IsControlJustPressed(2, 178) then
                                        TriggerEvent("Drilling:Stop")
                                    end
                                else
                                    DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], "Safe ist schon Auf")
                                end
                            end
                        end
                    end
                    if sleep then
                        Citizen.Wait(1000)
                    end
                end
            end
        )
    end
)

function DrillClosestSafe(id, val, ped)
    local anim = {dict = "anim@heists@fleeca_bank@drilling", lib = "drill_straight_idle"}
    local closestPlayer, dist = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and dist <= 1.0 then
        if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), anim.dict, anim.lib, 3) then
            return ShowNotifyESX(Lang["safe_drilled_by_ply"])
        end
    end
    safe_drilling = true
    FreezeEntityPosition(ped, true)
    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    Citizen.Wait(250)
    LoadAnim(anim.dict)
    local drill_prop = GetHashKey("hei_prop_heist_drill")
    local boneIndex = GetPedBoneIndex(ped, 28422)
    LoadModel(drill_prop)
    SetEntityCoords(ped, val.anim_pos[1], val.anim_pos[2], val.anim_pos[3] - 0.95)
    SetEntityHeading(ped, val.anim_pos[4])
    TaskPlayAnimAdvanced(
        ped,
        anim.dict,
        anim.lib,
        val.anim_pos[1],
        val.anim_pos[2],
        val.anim_pos[3],
        0.0,
        0.0,
        val.anim_pos[4],
        1.0,
        -1.0,
        -1,
        2,
        0,
        0,
        0
    )
    local drill_obj = CreateObject(drill_prop, 1.0, 1.0, 1.0, 1, 1, 0)
    AttachEntityToEntity(drill_obj, ped, boneIndex, 0.0, 0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
    SetEntityAsMissionEntity(drill_obj, true, true)
    RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
    RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
    RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
    local drill_sound = GetSoundId()
    Citizen.Wait(100)
    PlaySoundFromEntity(drill_sound, "Drill", drill_obj, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
    Citizen.Wait(100)
    local particle_dict = "scr_fbi5a"
    local particle_lib = "scr_bio_grille_cutting"
    RequestNamedPtfxAsset(particle_dict)
    while not HasNamedPtfxAssetLoaded(particle_dict) do
        Citizen.Wait(0)
    end
    SetPtfxAssetNextCall(particle_dict)
    local effect = StartParticleFxLoopedOnEntity(particle_lib, drill_obj, 0.0, -0.6, 0.0, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
    ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 1.0)
    Citizen.Wait(100)
    FreezeEntityPosition(ped, true)
    TriggerEvent(
        "Drilling:Start",
        function(success)
            if success == true then
                SevenConfig.DoorsDrill[id].robbed = true
                TriggerServerEvent("SevenLife:BankRaub:GiveReward")
                safe_drilling = false
            elseif success == false then
                SevenConfig.DoorsDrill[id].failed = true
                TriggerEvent("SevenLife:TimetCustom:Notify", "Bankraub", "Du hast diesen Safe zerstört", 2000)
                safe_drilling = false
            end
            FreezeEntityPosition(ped, false)
            ClearPedTasksImmediately(ped)
            StopSound(drill_sound)
            ReleaseSoundId(drill_sound)
            DeleteObject(drill_obj)
            DeleteEntity(drill_obj)
            FreezeEntityPosition(ped, false)
            StopParticleFxLooped(effect, 0)
            StopGameplayCamShaking(true)
        end
    )
end
function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 500
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 80)
end
function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end
end

RegisterNetEvent("SevenLife:BankRaub:ResetEveryThing")
AddEventHandler(
    "SevenLife:BankRaub:ResetEveryThing",
    function()
        TriggerServerEvent("SevenLife:BankRaub:MakeAlarm", 2)
        SecondRaub, EndRaub, AtivRaubHardone = false, false, false
        mistime = 1000
        ingarageparkrange = false
        outarea = false
        notifys = true
        inmarker = false
        inmenu = true
        timemains = 100
        terminate = false
        OutCome = 0
        notifys1 = true
        inmarker1 = false
        inmenu1 = false
        timemains1 = 100
        terminate1 = false
        OutCome1 = 0
        activealready = false
        safe_drilling = false
        TriggerServerEvent("SevenLife:BankRaub:ResetEveryThingS")
    end
)
RegisterNetEvent("SevenLife:BankRaub:ResetEveryThingC")
AddEventHandler(
    "SevenLife:BankRaub:ResetEveryThingC",
    function()
        SecondRaub, EndRaub, AtivRaubHardone = false, false, false
        mistime = 1000
        ingarageparkrange = false
        outarea = false
        notifys = true
        inmarker = false
        inmenu = true
        timemains = 100
        terminate = false
        OutCome = 0
        notifys1 = true
        inmarker1 = false
        inmenu1 = false
        timemains1 = 100
        terminate1 = false
        OutCome1 = 0
        activealready = false
        safe_drilling = false
        starttimer = false

        begingas = false
    end
)
RegisterNetEvent("SevenLife:BankRaub:MakeAlarmC")
AddEventHandler(
    "SevenLife:BankRaub:MakeAlarmC",
    function(status)
        if status == 1 then
            print("tex")
            PlaySound = true
        elseif status == 2 then
            PlaySound = false
            SendNUIMessage({type = "StopSound"})
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            if PlaySound then
                local Coords = GetEntityCoords(GetPlayerPed(-1))
                local eCoords = vector3(257.10, 220.30, 106.28)
                local distIs = GetDistanceBetweenCoords(Coords, eCoords)
                if (distIs <= 50) then
                    SendNUIMessage(
                        {
                            type = "PlaySound"
                        }
                    )
                    Citizen.Wait(28000)
                else
                    SendNUIMessage(
                        {
                            type = "StopSound"
                        }
                    )
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
)
