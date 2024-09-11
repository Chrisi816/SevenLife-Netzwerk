ESX = nil

-- ESX
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent("SevenLife:Rob:RobbingAtm")
AddEventHandler(
    "SevenLife:Rob:RobbingAtm",
    function(netid)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local count = 0
        local atm = NetworkGetEntityFromNetworkId(netid)
        while not atm do
            Citizen.Wait(10)
            atm = NetworkGetEntityFromNetworkId(netid)
            count = count + 1
            if count == 100 then
                return
            end
        end

        local coords = GetEntityCoords(atm)
        TriggerClientEvent(
            "SevenLife:TimetCustom:Notify",
            _source,
            "ATM - Raub",
            "Du hast den ATM aufgebrochen!",
            "1500"
        )

        -- Call Cops

        for i = 1, 10 do
            local pedCoords = GetEntityCoords(GetPlayerPed(_source))
            if #(pedCoords - coords) < 3.5 then
                local amount = Config.Bills[math.random(1, #Config.Bills)]
                xPlayer.addAccountMoney("money", amount)
            end
            Citizen.Wait(1500)
        end
    end
)
RegisterServerEvent("SevenLife:Raub:AlarmCops")
AddEventHandler(
    "SevenLife:Raub:AlarmCops",
    function(netid)
        local atm = NetworkGetEntityFromNetworkId(netid)

        while not atm do
            Citizen.Wait(10)
            atm = NetworkGetEntityFromNetworkId(netid)
            count = count + 1
            if count == 100 then
                return
            end
        end
        local coords = GetEntityCoords(atm)
        print(coords)
        TriggerEvent("SevenLife:PD:MakeWarning", "ATM", coords)
    end
)
