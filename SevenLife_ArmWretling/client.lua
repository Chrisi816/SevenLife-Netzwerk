Citizen.CreateThread(
  function()
    for k, v in pairs(Config.Props) do
      local blip = AddBlipForCoord(v.x, v.y, v.z)
      SetBlipSprite(blip, 311)
      SetBlipDisplay(blip, 9)
      SetBlipScale(blip, 0.7)
      SetBlipColour(blip, 40)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(name)
      EndTextCommandSetBlipName(blip)
    end
  end
)

local place = 0
local started = false
local inmenu = false
local grade = 0.5
local notifys = true

-- Spawn Table

Citizen.CreateThread(
  function()
    while true do
      Citizen.Wait(5000)
      for i, v in pairs(Config.Props) do
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y, v.z) < 50 then
          thisTable = GetClosestObjectOfType(v.x, v.y, v.z, 1.5, GetHashKey(v.model), 0, 0, 0)
          if DoesEntityExist(thisTable) then
            SetEntityHeading(thisTable)
            PlaceObjectOnGroundProperly(thisTable)
          else
            thisTable = CreateObject(GetHashKey(v.model), v.x, v.y, v.z, false, false, false)
            SetEntityHeading(thisTable)
            PlaceObjectOnGroundProperly(thisTable)
          end
        elseif
          GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y, v.z) >= 50 and
            GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y, v.z) <= 100
         then
          thisTable = GetClosestObjectOfType(v.x, v.y, v.z, 1.5, GetHashKey(v.model), 0, 0, 0)
          if DoesEntityExist(thisTable) then
            DeleteEntity(thisTable)
          end
        end
      end
    end
  end
)

-- Check if Near
Citizen.CreateThread(
  function()
    while true do
      local player = GetPlayerPed(-1)
      Citizen.Wait(150)
      for k, v in pairs(Config.Props) do
        local coords = GetEntityCoords(player)
        local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
        if distance < 2 then
          inmarker = true
          if notifys then
            TriggerEvent("sevenliferp:startnui", "Drücke E um Arm drücken zu spielen", "System - Nachricht", true)
          end
        else
          if distance >= 2.1 and distance <= 5 then
            inmarker = false
            TriggerEvent("sevenliferp:closenotify", false)
          end
        end
      end
    end
  end
)

-- Control

Citizen.CreateThread(
  function()
    Citizen.Wait(3000)
    while true do
      Citizen.Wait(5)
      if inmarker then
        if IsControlJustPressed(0, 38) then
          if inmenu == false then
            inmenu = true
            for i, v in pairs(Config.Props) do
              local table = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, GetHashKey(v.model), 0, 0, 0)
              if DoesEntityExist(table) then
                local position = GetEntityCoords(PlayerPedId())
                TriggerServerEvent("SevenLife:Wrestling:Check", position)
                notifys = false
                print("hey")
                TriggerEvent("sevenliferp:closenotify", false)
                SendNUIMessage {
                  type = "OpenDialogueMenu"
                }
                break
              end
            end
          end
        end
      end
    end
  end
)

-- Anim
function PlayAnim(ped, dict, name, flag)
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
    Citizen.Wait(0)
  end
  TaskPlayAnim(ped, dict, name, 1.5, 1.5, -1, flag, 0.0, false, false, false)
end

RegisterNetEvent("SevenLife:ArmWrestling:MakeGrade")
AddEventHandler(
  "SevenLife:ArmWrestling:MakeGrade",
  function(gradeUpValue)
    grade = gradeUpValue
  end
)

-- Start Game

RegisterNetEvent("SevenLife:Wrestling:StartGame")
AddEventHandler(
  "SevenLife:Wrestling:StartGame",
  function()
    started = true
    if place == 1 then
      DisableControl()
      Timer()

      while grade >= 0.10 and grade <= 0.90 do
        Citizen.Wait(3)
        PlayFacialAnim(PlayerPedId(), "electrocuted_1", "facials@gen_male@base")
        SetEntityAnimSpeed(PlayerPedId(), "mini@arm_wrestling", "sweep_a", 0.0)
        SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_a", grade)
        if IsControlPressed(0, 38) then
          TriggerServerEvent("SevenLife:Wrestling:UpdateGrade", 0.015)
          SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_a", grade)

          while IsControlPressed(0, 38) do
            Citizen.Wait(0)

            SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_a", grade)
          end
        end
      end

      if grade >= 0.90 then
        PlayAnim(PlayerPedId(), "mini@arm_wrestling", "win_a_ped_a", 2)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Arm Wrestling", "Du hast gewonnen", 2000)
      elseif grade <= 0.10 then
        PlayAnim(PlayerPedId(), "mini@arm_wrestling", "win_a_ped_b", 2)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Arm Wrestling", "Du hast leider verloren", 2000)
      end
      Citizen.Wait(4000)
      TriggerServerEvent("SevenLife:ArmWrestling:SaveAll", GetEntityCoords(PlayerPedId()))
      return
    elseif place == 2 then
      DisableControl()
      Timer()

      while grade >= 0.10 and grade <= 0.90 do
        Citizen.Wait(3)
        PlayFacialAnim(PlayerPedId(), "electrocuted_1", "facials@gen_male@base")

        SetEntityAnimSpeed(PlayerPedId(), "mini@arm_wrestling", "sweep_b", 0.0)
        SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_b", grade)
        if IsControlPressed(0, 38) then
          TriggerServerEvent("SevenLife:Wrestling:UpdateGrade", -0.015)

          SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_b", grade)
          while IsControlPressed(0, 38) do
            Citizen.Wait(0)

            SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_b", grade)
          end
        end
      end

      if grade <= 0.10 then
        PlayAnim(PlayerPedId(), "mini@arm_wrestling", "win_a_ped_a", 2)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Arm Wrestling", "Du hast gewonnen", 2000)
      elseif grade >= 0.90 then
        PlayAnim(PlayerPedId(), "mini@arm_wrestling", "win_a_ped_b", 2)
        TriggerEvent("SevenLife:TimetCustom:Notify", "Arm Wrestling", "Du hast leider verloren", 2000)
      end
      Citizen.Wait(4000)
      TriggerServerEvent("SevenLife:ArmWrestling:SaveAll", GetEntityCoords(PlayerPedId()))
      return
    end
  end
)

-- Time function
function Timer()
  PlaySoundFrontend(-1, "Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
  local T = GetGameTimer()
  while GetGameTimer() - T < 1000 do
    Citizen.Wait(0)
  end
  PlaySoundFrontend(-1, "Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
  local T = GetGameTimer()
  while GetGameTimer() - T < 1000 do
    Citizen.Wait(0)
  end
  PlaySoundFrontend(-1, "Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
  local T = GetGameTimer()
  while GetGameTimer() - T < 1000 do
    Citizen.Wait(0)
  end
  PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 0)

  local T = GetGameTimer()
  while GetGameTimer() - T < 1000 do
    Citizen.Wait(0)
  end
end

function DisableControl()
  Citizen.CreateThread(
    function()
      while started do
        Citizen.Wait(1)
        DisableControlAction(2, 71, true)
        DisableControlAction(2, 72, true)
        DisableControlAction(2, 63, true)
        DisableControlAction(2, 64, true)
        DisableControlAction(2, 75, true)
        DisableControlAction(2, 32, true)
        DisableControlAction(2, 33, true)
        DisableControlAction(2, 34, true)
        DisableControlAction(2, 35, true)
        DisableControlAction(2, 37, true)
        DisableControlAction(2, 23, true)
        DisableControlAction(2, 246, true)
      end
    end
  )
end

RegisterNetEvent("SevenLife:ArmWrestling:CheckPlace")
AddEventHandler(
  "SevenLife:ArmWrestling:CheckPlace",
  function(args)
    local table = 0
    if args == "place1" then
      place = 1
      DisableControl()
      for i, modelConfig in pairs(Config.Props) do
        table = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, GetHashKey(modelConfig.model), 0, 0, 0)
        if DoesEntityExist(table) then
          break
        end
      end
      SetEntityNoCollisionEntity(PlayerPedId(), table, false)
      SetEntityHeading(PlayerPedId(), GetEntityHeading(table))
      Citizen.Wait(100)
      SetEntityCoords(
        PlayerPedId(),
        GetOffsetFromEntityInWorldCoords(table, -0.20, 0.0, 0.0).x,
        GetOffsetFromEntityInWorldCoords(table, 0.0, -0.65, 0.0).y,
        GetEntityCoords(PlayerPedId()).z - 1
      )
      FreezeEntityPosition(PlayerPedId(), true)

      PlayAnim(PlayerPedId(), "mini@arm_wrestling", "nuetral_idle_a", 1)

      TriggerEvent(
        "SevenLife:TimetCustom:Notify",
        "Arm Wrestling",
        "Warte bis ein neuer Spieler deine Session beitretet",
        2000
      )
      while not started do
        Citizen.Wait(3)

        if
          IsControlPressed(2, 73) or IsPedRagdoll(PlayerPedId()) or IsControlPressed(2, 200) or IsControlPressed(2, 214)
         then
          SetEntityNoCollisionEntity(PlayerPedId(), table, true)
          SendNUIMessage(
            {
              type = "RemoveDialogueMenu"
            }
          )
          TriggerServerEvent("SevenLife:ArmWrestling:SaveAll", GetEntityCoords(PlayerPedId()))
          return
        end
      end
    elseif args == "place2" then
      DisableControl()
      place = 2
      for i, modelConfig in pairs(Config.Props) do
        table = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, GetHashKey(modelConfig.model), 0, 0, 0)
        if DoesEntityExist(table) then
          break
        end
      end

      SetEntityNoCollisionEntity(PlayerPedId(), table, false)

      SetEntityHeading(PlayerPedId(), GetEntityHeading(table) - 180)
      Citizen.Wait(100)
      SetEntityCoords(
        PlayerPedId(),
        GetOffsetFromEntityInWorldCoords(table, 0.0, 0.0, 0.0).x,
        GetOffsetFromEntityInWorldCoords(table, 0.0, 0.50, 0.0).y,
        GetEntityCoords(PlayerPedId()).z - 1
      )
      TriggerEvent(
        "SevenLife:TimetCustom:Notify",
        "Arm Wrestling",
        "Warte bis ein neuer Spieler deine Session beitretet",
        2000
      )
      FreezeEntityPosition(PlayerPedId(), true)

      PlayAnim(PlayerPedId(), "mini@arm_wrestling", "nuetral_idle_b", 1)

      while not started do
        Citizen.Wait(3)

        if
          IsControlPressed(2, 73) or IsPedRagdoll(PlayerPedId()) or IsControlPressed(2, 200) or IsControlPressed(2, 214)
         then
          SetEntityNoCollisionEntity(PlayerPedId(), table, true)
          SendNUIMessage(
            {
              type = "RemoveDialogueMenu"
            }
          )
          TriggerServerEvent("SevenLife:ArmWrestling:SaveAll", GetEntityCoords(PlayerPedId()))
          return
        end
      end
    elseif args == "noplace" then
      TriggerEvent("SevenLife:TimetCustom:Notify", "Arm Wrestling", "Momentan ist der tisch voll", 2000)
    end
  end
)

RegisterNetEvent("SevenLife:Wrestling:Save")
AddEventHandler(
  "SevenLife:Wrestling:Save",
  function()
    for i, modelConfig in pairs(Config.Props) do
      local tableId =
        GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, GetHashKey(modelConfig.model), 0, 0, 0)
      if DoesEntityExist(tableId) then
        SetEntityNoCollisionEntity(PlayerPedId(), tableId, true)
        break
      end
    end
    notifys = true
    ClearPedTasks(PlayerPedId())
    place = 0
    started = false
    grade = 0.5
    inmenu = false
    SendNUIMessage(
      {
        type = "RemoveDialogueMenu"
      }
    )
    inmarker = true
    FreezeEntityPosition(PlayerPedId(), false)
  end
)
