local text =
    [[
         _____                           _       _   __       _____   _____  
        / ____|                         | |     (_) / _|     |  __ \ |  __ \ 
       | (___    ___ __   __ ___  _ __  | |      _ | |_  ___ | |__) || |__) |
        \___ \  / _ \\ \ / // _ \| '_ \ | |     | ||  _|/ _ \|  _  / |  ___/ 
        ____) ||  __/ \ V /|  __/| | | || |____ | || | |  __/| | \ \ |  |     
       |_____/  \___|  \_/  \___||_| |_||______||_||_|  \___||_|  \_\|_|     
                                                                      
                        Scripts Protected with Noxans. 
                For Instructions visit www.Noxans.de/instructions
                     ##### Protection Date 22-12-2021 #####
]]

AddEventHandler(
    "onClientResourceStart",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        Citizen.Wait(2000)
        print(text)
    end
)

Citizen.CreateThread(
    function()
        local reason, killer, deathhash, weapon
        local send
        while true do
            Citizen.Wait(1)
            if IsEntityDead(GetPlayerPed(PlayerId())) then
                Citizen.Wait(1)
                local killers = GetPedSourceOfDeath(GetPlayerPed(PlayerId()))
                local player = GetPlayerPed(PlayerId())
                local nameofplayer = GetPlayerName(player)
                local name = GetPlayerName(killers)
                deathhash = GetPedCauseOfDeath(GetPlayerPed(PlayerId()))
                if IsEntityAPed(killers) and IsPedAPlayer(killers) then
                    killer = NetworkGetPlayerIndexFromPed(killers)
                    send = true
                else
                    if
                        IsEntityAVehicle(killers) and IsEntityAPed(GetPedInVehicleSeat(killers, -1)) and
                            IsPedAPlayer(GetPedInVehicleSeat(killers, -1))
                     then
                        killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(killers, -1))
                        send = true
                    end
                end
            end
            if send then
                TriggerServerEvent("sevenlife:playerdied", nameofplayer, deathhash, killer)
                send = false
            end
            Citizen.Wait(30000)
        end
    end
)
