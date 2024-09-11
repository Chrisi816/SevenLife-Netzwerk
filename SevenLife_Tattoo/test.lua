function openMenu()
    local elements = {}

    for _, k in pairs(tattoosCategories) do
        table.insert(elements, {label = k.name, value = k.value})
    end

    if (DoesCamExist(cam)) then
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
    end

    ESX.UI.Menu.Open(
        "default",
        GetCurrentResourceName(),
        "Tattoos_menu",
        {
            title = "Tattos",
            align = "top-left",
            elements = elements
        },
        function(data, menu)
            local currentLabel = data.current.label
            local currentValue = data.current.value
            if (data.current.value ~= nil) then
                elements = {}

                table.insert(elements, {label = Config.TextGoBackIntoMenu, value = nil})
                for i, k in pairs(tattoosList[data.current.value]) do
                    table.insert(
                        elements,
                        {
                            label = "Tattoo n°" .. i .. "	(" .. k.price .. Config.MoneySymbol .. ")",
                            value = i,
                            price = k.price
                        }
                    )
                end

                ESX.UI.Menu.Open(
                    "default",
                    GetCurrentResourceName(),
                    "Tattoos_Categories_menu",
                    {
                        title = "Tattos | " .. currentLabel,
                        align = "top-left",
                        elements = elements
                    },
                    function(data2, menu2)
                        local price = data2.current.price
                        if (data2.current.value ~= nil) then
                            TriggerServerEvent(
                                "tattoos:save",
                                currentTattoos,
                                price,
                                {collection = currentValue, texture = data2.current.value}
                            )
                        else
                            openMenu()
                            RenderScriptCams(false, false, 0, 1, 0)
                            DestroyCam(cam, false)
                            cleanPlayer()
                        end
                    end,
                    function(data2, menu2)
                        menu.close()
                        RenderScriptCams(false, false, 0, 1, 0)
                        DestroyCam(cam, false)
                        setPedSkin()
                    end,
                    function(data2, menu2)
                        if (data2.current.value ~= nil) then
                            drawTattoo(data2.current.value, currentValue)
                        end
                    end,
                    function()
                    end
                )
            end
        end,
        function(data, menu)
            menu.close()
            setPedSkin()
        end
    )
end

function drawTattoo(current, collection)
    SetEntityHeading(GetPlayerPed(-1), 297.7296)

    ClearPedDecorations(GetPlayerPed(-1))
    for _, k in pairs(currentTattoos) do
        ApplyPedOverlay(
            GetPlayerPed(-1),
            GetHashKey(k.collection),
            GetHashKey(tattoosList[k.collection][k.texture].nameHash)
        )
    end

    if (GetEntityModel(GetPlayerPed(-1)) == -1667301416) then -- GIRL SKIN
        SetPedComponentVariation(GetPlayerPed(-1), 8, 34, 0, 2)
        SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)
        SetPedComponentVariation(GetPlayerPed(-1), 11, 101, 1, 2)
        SetPedComponentVariation(GetPlayerPed(-1), 4, 16, 0, 2)
    else -- BOY SKIN
        SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2)
        SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)
        SetPedComponentVariation(GetPlayerPed(-1), 11, 91, 0, 2)
        SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 0, 2)
    end

    ApplyPedOverlay(GetPlayerPed(-1), GetHashKey(collection), GetHashKey(tattoosList[collection][current].nameHash))

    if (not DoesCamExist(cam)) then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

        SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
        SetCamRot(cam, 0.0, 0.0, 0.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)

        SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))

    SetCamCoord(
        cam,
        x + tattoosList[collection][current].addedX,
        y + tattoosList[collection][current].addedY,
        z + tattoosList[collection][current].addedZ
    )
    SetCamRot(cam, 0.0, 0.0, tattoosList[collection][current].rotZ)
end

function cleanPlayer()
    ClearPedDecorations(GetPlayerPed(-1))
    for _, k in pairs(currentTattoos) do
        ApplyPedOverlay(
            GetPlayerPed(-1),
            GetHashKey(k.collection),
            GetHashKey(tattoosList[k.collection][k.texture].nameHash)
        )
    end
end

function Info(text, loop)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, loop, 1, 0)
end
