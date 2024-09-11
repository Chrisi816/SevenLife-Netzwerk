RegisterNetEvent("SevenLife:Tennis:MakeBallData")
AddEventHandler(
    "SevenLife:Tennis:MakeBallData",
    function(courtName, hitType, ballPos, newVelocity)
        TriggerClientEvent("SevenLife:Tennis:SetData", -1, source, courtName, hitType, ballPos, newVelocity)
    end
)

RegisterNetEvent("SevenLife:Tennis:GetPos")
AddEventHandler(
    "SevenLife:Tennis:GetPos",
    function(Name, position)
        local Source = source

        if not TennisCourts[Name].players then
            TennisCourts[Name].players = {}
        end

        if not TennisCourts[Name].players[position] then
            TennisCourts[Name].players[position] = Source
            TriggerClientEvent("SevenLife:Tennis:Position", Source, Name, position, true)
        end

        TriggerClientEvent("SevenLife:Tennis:SetDataInHand", -1, source, Name)
    end
)

RegisterServerEvent("SevenLife:Tennis:Clean")
AddEventHandler(
    "SevenLife:Tennis:Clean",
    function(Name)
        TennisCourts[Name].players = {}
    end
)
