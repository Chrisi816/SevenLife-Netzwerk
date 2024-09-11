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

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        PlayerData = ESX.GetPlayerData()

        if PlayerData.job.name == "police" then
            IsPlayerInPD = true
        else
            IsPlayerInPD = false
        end
        if IsPlayerInPD then
            BlipEinknassten()
        end
        BlipGefeangnisWorkOut()
        BlipGefeangnisBasketball()
        BlipGefeangnis(Config.GefeangnisBlip.x, Config.GefeangnisBlip.y, Config.GefeangnisBlip.z)
    end
)

RegisterNUICallback(
    "escape",
    function()
        isOnCreator = false
        inmenu = false
        time = 200
        timebetweenchecking = 200
        AllowSevenNotify = true
        inarea = false
        inmarker = false
        activenotify = true
        irradaractive = true
        inmenukleidung = false
        inmenu3 = false
        list2 = {}
        notifys3 = true
        ingaragerange3 = false
        inmenu2 = false
        AllowSevenNotify2 = true
        inarea2 = false
        inmarker2 = false
        ingaragerange4 = false
        notifys4 = true
        inmenu4 = false
        inmenu5 = false
        AllowSevenNotify5 = true
        inarea5 = false
        inmarker5 = false
        SetNuiFocus(false, false)
        notifys8 = true
        inmarker8 = false
        inmenu8 = false
        notifys9 = true
        inmarker9 = false
        inmenu9 = false
        notifys11 = true
        inmarker11 = false
        inmenu11 = false
        Citizen.Wait(50)
        activenotify = true

        SetCamActive(camara, false)
        RenderScriptCams(false, true, 500, true, true)
        camara = nil
        Citizen.Wait(500)
        DisplayRadar(true)
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(2000)
            if GetClockHours() == 10 and GetClockMinutes() == 00 then
                TriggerServerEvent("SevenLife:Police:Server:TransferPayCheck", PlayerData.job.grade)
            end
        end
    end
)

RegisterNetEvent("SevenLife:PD:TabletAusfuehren")
AddEventHandler(
    "SevenLife:PD:TabletAusfuehren",
    function(data)
        SetNuiFocus(true, true)
        local time = GetTime()

        SendNUIMessage(
            {
                type = "OpenIpad",
                time = time,
                datum = data
            }
        )
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

RegisterNUICallback(
    "GetPlayerDataSearch",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:PD:GetPlayers",
            function(result)
                Citizen.Wait(5000)
                SendNUIMessage(
                    {
                        type = "OpenPlayerSearch",
                        result = result
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "InsertPlayer",
    function(data)
        TriggerServerEvent(
            "SevenLife:PD:InsertPlayerIntoDatenBank",
            data.url,
            data.vorname,
            data.nachname,
            data.nummer,
            data.desc
        )
    end
)

RegisterNetEvent("SevenLife:PD:CloseMenuFehler")
AddEventHandler(
    "SevenLife:PD:CloseMenuFehler",
    function()
        TriggerEvent(
            "SevenLife:TimetCustom:Notify",
            "Tablet",
            "Spieler Existiert Nicht. Name oder Vorname sind Falsch",
            3000
        )
        SendNUIMessage(
            {
                type = "CloseTablet"
            }
        )
    end
)

RegisterNetEvent("SevenLife:PD:UpdatePlayers")
AddEventHandler(
    "SevenLife:PD:UpdatePlayers",
    function(results)
        SendNUIMessage(
            {
                type = "UpdatePlayers",
                result = results
            }
        )
    end
)

RegisterNUICallback(
    "GetAkten",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:PD:GetAkten",
            function(result, results, results3)
                SendNUIMessage(
                    {
                        type = "OpenInformationPerson",
                        akten = result,
                        name = results,
                        info = results3
                    }
                )
            end,
            data.vorname .. " " .. data.nachname,
            data.vorname,
            data.nachname
        )
    end
)

RegisterNUICallback(
    "GetPlayerEdit",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:PD:GetEditPerson",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenEditMenu",
                        item = result
                    }
                )
            end,
            data.vorname,
            data.nachname
        )
    end
)

RegisterNUICallback(
    "EditPlayer",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:PD:EditPerson",
            function(updatet, result, result2)
                if updatet then
                    SendNUIMessage(
                        {
                            type = "OpenEditMenu2",
                            item = result,
                            info = result2
                        }
                    )
                end
            end,
            data.vorname,
            data.nachname,
            data.number,
            data.desc,
            data.url
        )
    end
)

RegisterNUICallback(
    "GivePlayerAkte",
    function(data)
        if not data.checkvalue then
            ESX.TriggerServerCallback(
                "SevenLife:PD:AddAkte",
                function(result)
                    if result then
                        SendNUIMessage(
                            {
                                type = "UpdateAkten",
                                info = result
                            }
                        )
                    end
                end,
                data.name,
                data.titel,
                data.detail,
                data.geldstrafe,
                data.haftstrafe
            )
        else
            TriggerServerEvent("SevenLife:PD:AddFahndung", data.name, data.titel)
        end
    end
)

RegisterNUICallback(
    "GetAktenDetails",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:PD:GetAktenDateils",
            function(results)
                SendNUIMessage(
                    {
                        type = "InsertAktenDetails",
                        result = results
                    }
                )
            end,
            data.name,
            data.id
        )
    end
)

RegisterNUICallback(
    "GetCarsAll",
    function()
        TriggerServerEvent("SevenLife:PD:GetAllCars")
    end
)

RegisterNetEvent("SevenLife:PD:AddCarsEinzel")
AddEventHandler(
    "SevenLife:PD:AddCarsEinzel",
    function(name, plate, versichert)
        SendNUIMessage(
            {
                type = "ShowAllCars",
                name = name,
                plate = plate,
                versichert = versichert
            }
        )
    end
)

RegisterNUICallback(
    "GetLizenzenOfPlayer",
    function()
        TriggerServerEvent("SevenLife:PD:InsertLizenzen")
    end
)

RegisterNetEvent("SevenLife:PD:InsertLizenzenIntoJS")
AddEventHandler(
    "SevenLife:PD:InsertLizenzenIntoJS",
    function(name, driver, id)
        SendNUIMessage(
            {
                type = "InsertIDLizenzen",
                name = name,
                driver = driver,
                id = id
            }
        )
    end
)

RegisterNUICallback(
    "GetDetailsAboutLizenzen",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:PD:GetDetailsLizenzen",
            function(gunlicense, driver, fly, boot, lkw, motor, jagd)
                SendNUIMessage(
                    {
                        type = "OpenLizenzenDetails",
                        gunlicense = gunlicense,
                        driver = driver,
                        fly = fly,
                        boot = boot,
                        lkw = lkw,
                        motor = motor,
                        jagd = jagd,
                        name = data.name
                    }
                )
            end,
            data.id
        )
    end
)

RegisterNUICallback(
    "GetUserWohnorte",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:PD:GetWohnorteUser",
            function(result)
                SendNUIMessage(
                    {
                        type = "InserWohnortData",
                        result = result
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "GetFahndungenPD",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:PD:GetFahndungenData",
            function(result)
                SendNUIMessage(
                    {
                        type = "OpenFandungenTaps",
                        result = result
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "DeleteFahndung",
    function(data)
        TriggerServerEvent("SevenLife:PD:DeleteFahndung", data.id)
    end
)

RegisterNetEvent("SevenLife:PD:UpdateAll")
AddEventHandler(
    "SevenLife:PD:UpdateAll",
    function()
        SendNUIMessage(
            {
                type = "UpdateAkten",
                info = result
            }
        )
    end
)

RegisterNUICallback(
    "GetActivPlayersPD",
    function(data)
        ESX.TriggerServerCallback(
            "SevenLife:PD:GetActivPlayersPD",
            function(result)
                SendNUIMessage(
                    {
                        type = "InsertPlayersPD",
                        players = result
                    }
                )
            end
        )
    end
)

RegisterNUICallback(
    "GetStreife",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:PD:GetStreifen",
            function(result)
                SendNUIMessage(
                    {
                        type = "InsterPlayersOfficial",
                        players = result
                    }
                )
            end
        )
    end
)
RegisterNUICallback(
    "InsertNewStreife",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:PD:InsertStreifen",
            function(result)
                SendNUIMessage(
                    {
                        type = "UpdateAllPoliceSee",
                        players = result
                    }
                )
            end
        )
    end
)
-- Delete
RegisterNUICallback(
    "erstestreifeclose",
    function()
        TriggerServerEvent("SevenLife:PD:CloseStreife", 1)
    end
)
RegisterNUICallback(
    "zweitestreifeclose",
    function()
        TriggerServerEvent("SevenLife:PD:CloseStreife", 2)
    end
)
RegisterNUICallback(
    "drittestreifeclose",
    function()
        TriggerServerEvent("SevenLife:PD:CloseStreife", 3)
    end
)
RegisterNUICallback(
    "viertestreifeclose",
    function()
        TriggerServerEvent("SevenLife:PD:CloseStreife", 4)
    end
)
RegisterNUICallback(
    "fuenftestreifeclose",
    function()
        TriggerServerEvent("SevenLife:PD:CloseStreife", 5)
    end
)

RegisterNUICallback(
    "sechstestreifeclose",
    function()
        TriggerServerEvent("SevenLife:PD:CloseStreife", 6)
    end
)
RegisterNUICallback(
    "siebtestreifeclose",
    function()
        TriggerServerEvent("SevenLife:PD:CloseStreife", 7)
    end
)

RegisterNUICallback(
    "achtestreifeclose",
    function()
        TriggerServerEvent("SevenLife:PD:CloseStreife", 8)
    end
)
RegisterNUICallback(
    "neuntestreifeclose",
    function()
        TriggerServerEvent("SevenLife:PD:CloseStreife", 9)
    end
)
RegisterNUICallback(
    "zehntestreifeclose",
    function()
        TriggerServerEvent("SevenLife:PD:CloseStreife", 10)
    end
)
RegisterNUICallback(
    "elftestreifeclose",
    function()
        TriggerServerEvent("SevenLife:PD:CloseStreife", 11)
    end
)
RegisterNetEvent("SevenLife:PD:UpdateStreife")
AddEventHandler(
    "SevenLife:PD:UpdateStreife",
    function(result)
        SendNUIMessage(
            {
                type = "UpdateAllPoliceSee",
                players = result
            }
        )
    end
)

-- Get In

RegisterNUICallback(
    "erstestreifeopen",
    function()
        TriggerServerEvent("SevenLife:PD:InsertStreifePlayer", 1)
    end
)
RegisterNUICallback(
    "zweitestreifeopen",
    function()
        TriggerServerEvent("SevenLife:PD:InsertStreifePlayer", 2)
    end
)
RegisterNUICallback(
    "drittestreifeopen",
    function()
        TriggerServerEvent("SevenLife:PD:InsertStreifePlayer", 3)
    end
)
RegisterNUICallback(
    "viertestreifeopen",
    function()
        TriggerServerEvent("SevenLife:PD:InsertStreifePlayer", 4)
    end
)
RegisterNUICallback(
    "fuenftestreifeopen",
    function()
        TriggerServerEvent("SevenLife:PD:InsertStreifePlayer", 5)
    end
)

RegisterNUICallback(
    "sechstestreifeopen",
    function()
        TriggerServerEvent("SevenLife:PD:InsertStreifePlayer", 6)
    end
)
RegisterNUICallback(
    "siebtestreifeopen",
    function()
        TriggerServerEvent("SevenLife:PD:InsertStreifePlayer", 7)
    end
)

RegisterNUICallback(
    "achtestreifeopen",
    function()
        TriggerServerEvent("SevenLife:PD:InsertStreifePlayer", 8)
    end
)
RegisterNUICallback(
    "neuntestreifeopen",
    function()
        TriggerServerEvent("SevenLife:PD:InsertStreifePlayer", 9)
    end
)
RegisterNUICallback(
    "zehntestreifeopen",
    function()
        TriggerServerEvent("SevenLife:PD:InsertStreifePlayer", 10)
    end
)
RegisterNUICallback(
    "elftezehntestreifeopen",
    function()
        TriggerServerEvent("SevenLife:PD:InsertStreifePlayer", 11)
    end
)
