local InAction = false
local coordx, coordy, coordz, coordheading
local inmarker = false
local timer = 400
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(timer)
            for i = 1, #Config.BedList do
                local bedID = Config.BedList[i]
                local distance =
                    GetDistanceBetweenCoords(
                    GetEntityCoords(PlayerPedId()),
                    bedID.objCoords.x,
                    bedID.objCoords.y,
                    bedID.objCoords.z,
                    true
                )
                if distance < 1.5 and InAction == false then
                    timer = 1
                    inmarker = true
                    local displayText = "~INPUT_PICKUP~ um sich hinzulegen!"
                    coordx = bedID.objCoords.x
                    coordy = bedID.objCoords.y
                    coordz = bedID.objCoords.z
                    coordheading = bedID.heading
                    ESX.ShowHelpNotification(displayText)
                else
                    if distance >= 1.6 and distance <= 2.6 then
                        timer = 400
                        inmarker = false
                    end
                end
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if inmarker then
                if IsControlJustReleased(0, 38) then
                    bedActive(coordx, coordy, coordz, coordheading)
                end
            end
        end
    end
)

function bedActive(x, y, z, heading)
    SetEntityCoords(GetPlayerPed(-1), x, y, z + 0.3)
    RequestAnimDict("anim@gangops@morgue@table@")
    while not HasAnimDictLoaded("anim@gangops@morgue@table@") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@morgue@table@", "ko_front", 8.0, -8.0, -1, 1, 0, false, false, false)
    SetEntityHeading(GetPlayerPed(-1), heading + 180.0)
    InAction = true
    Citizen.CreateThread(
        function()
            while true do
                Citizen.Wait(1)
                if InAction == true then
                    local displayText = "~INPUT_VEH_DUCK~ um aufzustehen!"
                    ESX.ShowHelpNotification(displayText)
                    if IsControlJustReleased(0, 73) then
                        InAction = false
                        break
                    end
                end
            end
        end
    )
end

RegisterNetEvent("SevenLife:Medic:LayDownOnBed")
AddEventHandler(
    "SevenLife:Medic:LayDownOnBed",
    function(x, y, z, heading)
        InAction = true
        for i = 1, #Config.BedList do
            local bedID = Config.BedList[i]
            RequestCollisionAtCoord(316.05166625977, -581.78210449219, 43.284034729004)
            FreezeEntityPosition(Ped, true)

            SetEntityCoords(Ped, 316.05166625977, -581.78210449219, 43.284034729004, false, false, false, false)
            while not HasCollisionLoadedAroundEntity(Ped) do
                Citizen.Wait(0)
            end
            FreezeEntityPosition(Ped, false)

            local players, nearbyplayer =
                ESX.Game.GetClosestPlayer(vector3(bedID.objCoords.x, bedID.objCoords.y, bedID.objCoords.z))
            if players == -1 or nearbyplayer > 3.0 then
                bedActive(bedID.objCoords.x, bedID.objCoords.y, bedID.objCoords.z, bedID.heading)
                Drunk()
                break
            end
        end
    end
)
function Drunk()
    Citizen.CreateThread(
        function()
            local player = GetPlayerPed(-1)
            DoScreenFadeOut(1000)
            Citizen.Wait(1000)
            SetTimecycleModifier("spectator5")
            SetPedMotionBlur(player, true)
            SetPedMovementClipset(player, "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
            SetPedIsDrunk(player, true)
            SetPedAccuracy(player, 0)
            DoScreenFadeIn(1000)
            Citizen.Wait(60000 * 2)
            DoScreenFadeOut(1000)
            Citizen.Wait(1000)
            DoScreenFadeIn(1000)
            ClearTimecycleModifier()
            ResetScenarioTypesEnabled()
            ResetPedMovementClipset(player, 0)
            SetPedIsDrunk(player, false)
            SetPedMotionBlur(player, false)
        end
    )
end
