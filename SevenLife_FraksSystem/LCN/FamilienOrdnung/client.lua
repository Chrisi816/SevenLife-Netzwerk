local notifys = true
local inmarker = false
local inmenu = false
local area = false
local activemission = "none"
local timemain = 100
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timemain)
            if inlcnjob then
                local ped = GetPlayerPed(-1)
                local coord = GetEntityCoords(ped)

                local distance =
                    GetDistanceBetweenCoords(
                    coord,
                    Config.LCN.DeineFamilie.x,
                    Config.LCN.DeineFamilie.y,
                    Config.LCN.DeineFamilie.z,
                    true
                )
                if distance < 15 then
                    area = true
                    timemain = 15
                    if distance < 1.2 then
                        inmarker = true
                        if notifys then
                            TriggerEvent(
                                "sevenliferp:startnui",
                                "Drücke <span1 color = white>E</span1> um Fraktion Informationen zu überprüfen",
                                "System - Nachricht",
                                true
                            )
                        end
                    else
                        if distance >= 1.2 and distance <= 2.2 then
                            inmarker = false
                            TriggerEvent("sevenliferp:closenotify", false)
                        end
                    end
                else
                    area = false
                end
            else
                Citizen.Wait(3000)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(10)
        while true do
            Citizen.Wait(5)
            if inlcnjob then
                if inmarker then
                    if IsControlJustPressed(0, 38) then
                        if inmenu == false then
                            inmenu = true
                            TriggerEvent("sevenliferp:closenotify", false)
                            notifys = false
                            SetNuiFocus(true, true)
                            ESX.TriggerServerCallback(
                                "SevenLife:FrakSystem:GetInfoAboutFamilie",
                                function(result, onlinepersonen)
                                    local nochweiviel
                                    for k, v in pairs(Config.levels) do
                                        if tonumber(result[1].level) == v.level then
                                            nochweiviel = tonumber(v.xp) - tonumber(result[1].xp)
                                        end
                                    end
                                    SendNUIMessage(
                                        {
                                            type = "OpenFrakMenu",
                                            level = result[1].level,
                                            xp = result[1].xp,
                                            leader = result[1].anfuehrer,
                                            mitglieder = result[1].mitglieder,
                                            reichtum = result[1].reichtum,
                                            nochwieviel = nochweiviel,
                                            namederfamilie = "La Cosa Nostra",
                                            descderfamilie = "Als Amerikanische Cosa Nostra Bzw. La Cosa Nostra oder Italienisch-Amerikanische Mafia wird der Nordamerikanische Ableger der originären sizilianischen Cosa Nostra Bzw. Mafia bezeichnet. Entstanden um 1900. Werden dem begriff heute diverse organisierte banden Italoamerikanischer Verbrecher zugeordnet.",
                                            colorpallete = "LCN",
                                            onlinepersonen = onlinepersonen
                                        }
                                    )
                                end,
                                "LCN"
                            )
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(3000)
            end
        end
    end
)
RegisterNUICallback(
    "CloseFamilienMenu",
    function()
        notifys = true
        inmenu = false
        inmenu = false
    end
)
RegisterNUICallback(
    "GetInfosAboutMitglieder",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:Frak:GetInfosAboutMitglider",
            function(result, onlinepersonen, insgesamtplayer)
                SendNUIMessage(
                    {
                        type = "InsertMembers",
                        result = result,
                        onlinepersonen = onlinepersonen,
                        insgesamtplayer = insgesamtplayer
                    }
                )
            end,
            "LCN"
        )
    end
)
local time = 2000
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(time)
            if inlcnjob then
                if area and not inmenu then
                    time = 1
                    DrawMarker(
                        1,
                        Config.LCN.DeineFamilie.x,
                        Config.LCN.DeineFamilie.y,
                        Config.LCN.DeineFamilie.z - 1,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0.8,
                        0.8,
                        0.8,
                        236,
                        80,
                        80,
                        155,
                        false,
                        false,
                        2,
                        false,
                        0,
                        0,
                        0,
                        0
                    )
                else
                    time = 2000
                end
            else
                Citizen.Wait(3000)
            end
        end
    end
)
RegisterNUICallback(
    "CheckWhoIsPlace",
    function()
        ESX.TriggerServerCallback(
            "SevenLife:FraksSystem:CheckIfFraktionen",
            function(result)
                local tables = {}
                local endtable = {}
                for k, v in pairs(result) do
                    local endresult = tonumber(v.krimminellepunkte) + tonumber(v.gebiete)

                    tables[k] = {}
                    tables[k].frak = v.frak
                    tables[k].level = v.level
                    tables[k].krimmipunkte = v.krimminellepunkte
                    tables[k].gebiete = v.gebiete
                    tables[k].points = endresult
                end
                table.sort(
                    tables,
                    function(p1, p2)
                        return p1.points > p2.points
                    end
                )
                SendNUIMessage(
                    {
                        type = "UpdateRanking",
                        list = tables
                    }
                )
            end
        )
    end
)
