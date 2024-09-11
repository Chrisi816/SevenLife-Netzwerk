ESX = nil

local activeblip = {}
local update = false
local lastblip
local resultBlips
local ready = false
Citizen.CreateThread(
    function()
        while ESX == nil do
            Citizen.Wait(10)
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            ready = true
        end
    end
)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        while not ready do
            Citizen.Wait(1)
        end
        ESX.TriggerServerCallback(
            "SevenLife:Blips:GetShowedBlips",
            function(result)
                resultBlips = result
                ActivateThread = true
                if result[1] ~= nil then
                    for k, v in ipairs(result) do
                        if tonumber(v.blipid) == 1 then
                            active1 = true
                            local blip = AddBlipForCoord(SevenConfig.locations.sand.x, SevenConfig.locations.sand.y)
                            SetBlipSprite(blip, SevenConfig.locations.sand.sprite)
                            SetBlipDisplay(blip, 4)
                            SetBlipScale(blip, 1.0)
                            SetBlipColour(blip, SevenConfig.locations.sand.color)
                            SetBlipAsShortRange(blip, true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString(SevenConfig.locations.sand.name)
                            EndTextCommandSetBlipName(blip)
                            table.insert(activeblip, blip)
                        end

                        if tonumber(v.blipid) == 2 then
                            active2 = true
                            local blip =
                                AddBlipForCoord(
                                SevenConfig.locations.SandVerarbeiter.x,
                                SevenConfig.locations.SandVerarbeiter.y
                            )
                            SetBlipSprite(blip, SevenConfig.locations.SandVerarbeiter.sprite)
                            SetBlipDisplay(blip, 4)
                            SetBlipScale(blip, 1.0)
                            SetBlipColour(blip, SevenConfig.locations.SandVerarbeiter.color)
                            SetBlipAsShortRange(blip, true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString(SevenConfig.locations.SandVerarbeiter.name)
                            EndTextCommandSetBlipName(blip)
                            table.insert(activeblip, blip)
                        end
                        if tonumber(v.blipid) == 3 then
                            active3 = true
                            local blip = AddBlipForCoord(SevenConfig.locations.carrot.x, SevenConfig.locations.carrot.y)
                            SetBlipSprite(blip, SevenConfig.locations.carrot.sprite)
                            SetBlipDisplay(blip, 4)
                            SetBlipScale(blip, 1.0)
                            SetBlipColour(blip, SevenConfig.locations.carrot.color)
                            SetBlipAsShortRange(blip, true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString(SevenConfig.locations.carrot.name)
                            EndTextCommandSetBlipName(blip)
                            table.insert(activeblip, blip)
                        end
                        if tonumber(v.blipid) == 4 then
                            active4 = true
                            local blip = AddBlipForCoord(SevenConfig.locations.potato.x, SevenConfig.locations.potato.y)
                            SetBlipSprite(blip, SevenConfig.locations.potato.sprite)
                            SetBlipDisplay(blip, 4)
                            SetBlipScale(blip, 1.0)
                            SetBlipColour(blip, SevenConfig.locations.potato.color)
                            SetBlipAsShortRange(blip, true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString(SevenConfig.locations.potato.name)
                            EndTextCommandSetBlipName(blip)
                            table.insert(activeblip, blip)
                        end
                        if tonumber(v.blipid) == 5 then
                            active5 = true
                            local blip =
                                AddBlipForCoord(
                                SevenConfig.locations.verarbeiten.x,
                                SevenConfig.locations.verarbeiten.y
                            )
                            SetBlipSprite(blip, SevenConfig.locations.verarbeiten.sprite)
                            SetBlipDisplay(blip, 4)
                            SetBlipScale(blip, 1.0)
                            SetBlipColour(blip, SevenConfig.locations.verarbeiten.color)
                            SetBlipAsShortRange(blip, true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString(SevenConfig.locations.verarbeiten.name)
                            EndTextCommandSetBlipName(blip)
                            table.insert(activeblip, blip)
                        end
                    end

                    if not active1 then
                        local blip = AddBlipForCoord(SevenConfig.locations.sand.x, SevenConfig.locations.sand.y)
                        SetBlipSprite(blip, 465)
                        SetBlipDisplay(blip, 4)
                        SetBlipScale(blip, 1.0)
                        SetBlipColour(blip, 0)
                        SetBlipAsShortRange(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Nicht entdeckt")
                        EndTextCommandSetBlipName(blip)
                        table.insert(activeblip, blip)
                    end

                    if not active2 then
                        local blip =
                            AddBlipForCoord(
                            SevenConfig.locations.SandVerarbeiter.x,
                            SevenConfig.locations.SandVerarbeiter.y
                        )
                        SetBlipSprite(blip, 465)
                        SetBlipDisplay(blip, 4)
                        SetBlipScale(blip, 1.0)
                        SetBlipColour(blip, 0)
                        SetBlipAsShortRange(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Nicht entdeckt")
                        EndTextCommandSetBlipName(blip)
                        table.insert(activeblip, blip)
                    end

                    if not active3 then
                        local blip = AddBlipForCoord(SevenConfig.locations.carrot.x, SevenConfig.locations.carrot.y)
                        SetBlipSprite(blip, 465)
                        SetBlipDisplay(blip, 4)
                        SetBlipScale(blip, 1.0)
                        SetBlipColour(blip, 0)
                        SetBlipAsShortRange(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Nicht entdeckt")
                        EndTextCommandSetBlipName(blip)
                        table.insert(activeblip, blip)
                    end

                    if not active4 then
                        local blip = AddBlipForCoord(SevenConfig.locations.potato.x, SevenConfig.locations.potato.y)
                        SetBlipSprite(blip, 465)
                        SetBlipDisplay(blip, 4)
                        SetBlipScale(blip, 1.0)
                        SetBlipColour(blip, 0)
                        SetBlipAsShortRange(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Nicht entdeckt")
                        EndTextCommandSetBlipName(blip)
                        table.insert(activeblip, blip)
                    end

                    if not active5 then
                        local blip =
                            AddBlipForCoord(SevenConfig.locations.verarbeiten.x, SevenConfig.locations.verarbeiten.y)
                        SetBlipSprite(blip, 465)
                        SetBlipDisplay(blip, 4)
                        SetBlipScale(blip, 1.0)
                        SetBlipColour(blip, 0)
                        SetBlipAsShortRange(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Nicht entdeckt")
                        EndTextCommandSetBlipName(blip)
                        table.insert(activeblip, blip)
                    end
                else
                    for k, v in pairs(SevenConfig.locations) do
                        local blip = AddBlipForCoord(v.x, v.y)
                        SetBlipSprite(blip, 465)
                        SetBlipDisplay(blip, 4)
                        SetBlipScale(blip, 1.0)
                        SetBlipColour(blip, 0)
                        SetBlipAsShortRange(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Nicht entdeckt")
                        EndTextCommandSetBlipName(blip)
                        table.insert(activeblip, blip)
                    end
                end
            end
        )
    end
)

--------------------------------------------------------------------------------------------------------------
-------------------------------------------Locale Systems-----------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(
    function()
        Citizen.Wait(100)

        while true do
            local player = GetPlayerPed(-1)
            Citizen.Wait(10000)
            if ActivateThread then
                for k, v in pairs(SevenConfig.locations) do
                    local coords = GetEntityCoords(player)
                    local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
                    if resultBlips[1] ~= nil then
                        if distance < 150 then
                            ESX.TriggerServerCallback(
                                "SevenLife:Blips:IsBlipRegistret",
                                function(result)
                                    if result == false then
                                        if not update then
                                            update = true
                                            if not WasBlipLast(v.blip) then
                                                lastblip = v.blip
                                                TriggerServerEvent("SevenLife:Blips:NeuerOrtEntdeckt", v.blip)
                                            end
                                        end
                                    end
                                end,
                                tonumber(v.blip)
                            )
                        end
                    else
                        if distance < 150 then
                            if not update then
                                update = true
                                if not WasBlipLast(v.blip) then
                                    ESX.TriggerServerCallback(
                                        "SevenLife:Blips:IsBlipRegistret",
                                        function(result)
                                            if result == false then
                                                lastblip = v.blip
                                                TriggerServerEvent("SevenLife:Blips:NeuerOrtEntdeckt", v.blip)
                                            end
                                        end,
                                        tonumber(v.blip)
                                    )
                                end
                            end
                        end
                    end
                end
            end
        end
    end
)

RegisterNetEvent("SevenLife:Blips:UpdateBlips")
AddEventHandler(
    "SevenLife:Blips:UpdateBlips",
    function(result, blipid)
        active1, active2, active3, active4, active5 = false, false, false, false, false
        for i = 1, #activeblip do
            RemoveBlip(activeblip[i])
        end

        resultBlips = result

        for k, v in ipairs(result) do
            if tonumber(v.blipid) == 1 then
                active1 = true
                local blip = AddBlipForCoord(SevenConfig.locations.sand.x, SevenConfig.locations.sand.y)
                SetBlipSprite(blip, SevenConfig.locations.sand.sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipColour(blip, SevenConfig.locations.sand.color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(SevenConfig.locations.sand.name)
                EndTextCommandSetBlipName(blip)
                table.insert(activeblip, blip)
            end

            if tonumber(v.blipid) == 2 then
                active2 = true
                local blip =
                    AddBlipForCoord(SevenConfig.locations.SandVerarbeiter.x, SevenConfig.locations.SandVerarbeiter.y)
                SetBlipSprite(blip, SevenConfig.locations.SandVerarbeiter.sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipColour(blip, SevenConfig.locations.SandVerarbeiter.color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(SevenConfig.locations.SandVerarbeiter.name)
                EndTextCommandSetBlipName(blip)
                table.insert(activeblip, blip)
            end
            if tonumber(v.blipid) == 3 then
                active3 = true
                local blip = AddBlipForCoord(SevenConfig.locations.carrot.x, SevenConfig.locations.carrot.y)
                SetBlipSprite(blip, SevenConfig.locations.carrot.sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipColour(blip, SevenConfig.locations.carrot.color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(SevenConfig.locations.carrot.name)
                EndTextCommandSetBlipName(blip)
                table.insert(activeblip, blip)
            end
            if tonumber(v.blipid) == 4 then
                active4 = true
                local blip = AddBlipForCoord(SevenConfig.locations.potato.x, SevenConfig.locations.potato.y)
                SetBlipSprite(blip, SevenConfig.locations.potato.sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipColour(blip, SevenConfig.locations.potato.color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(SevenConfig.locations.potato.name)
                EndTextCommandSetBlipName(blip)
                table.insert(activeblip, blip)
            end
            if tonumber(v.blipid) == 5 then
                active5 = true
                local blip = AddBlipForCoord(SevenConfig.locations.verarbeiten.x, SevenConfig.locations.verarbeiten.y)
                SetBlipSprite(blip, SevenConfig.locations.verarbeiten.sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipColour(blip, SevenConfig.locations.verarbeiten.color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(SevenConfig.locations.verarbeiten.name)
                EndTextCommandSetBlipName(blip)
                table.insert(activeblip, blip)
            end
        end

        if not active1 then
            local blip = AddBlipForCoord(SevenConfig.locations.sand.x, SevenConfig.locations.sand.y)
            SetBlipSprite(blip, 465)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Nicht entdeckt")
            EndTextCommandSetBlipName(blip)
            table.insert(activeblip, blip)
        end

        if not active2 then
            local blip =
                AddBlipForCoord(SevenConfig.locations.SandVerarbeiter.x, SevenConfig.locations.SandVerarbeiter.y)
            SetBlipSprite(blip, 465)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Nicht entdeckt")
            EndTextCommandSetBlipName(blip)
            table.insert(activeblip, blip)
        end

        if not active3 then
            local blip = AddBlipForCoord(SevenConfig.locations.carrot.x, SevenConfig.locations.carrot.y)
            SetBlipSprite(blip, 465)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Nicht entdeckt")
            EndTextCommandSetBlipName(blip)
            table.insert(activeblip, blip)
        end

        if not active4 then
            local blip = AddBlipForCoord(SevenConfig.locations.potato.x, SevenConfig.locations.potato.y)
            SetBlipSprite(blip, 465)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Nicht entdeckt")
            EndTextCommandSetBlipName(blip)
            table.insert(activeblip, blip)
        end

        if not active5 then
            local blip = AddBlipForCoord(SevenConfig.locations.verarbeiten.x, SevenConfig.locations.verarbeiten.y)
            SetBlipSprite(blip, 465)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Nicht entdeckt")
            EndTextCommandSetBlipName(blip)
            table.insert(activeblip, blip)
        end
        nexts = false
        update = false
    end
)
function WasBlipLast(CurrentBlip)
    if CurrentBlip == lastblip then
        return true
    else
        return false
    end
end
