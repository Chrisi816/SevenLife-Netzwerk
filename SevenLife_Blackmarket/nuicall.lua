local announce = true
weponfirst = false
weponsecond = false
weponthird = false
mission = true
itemsdontget = true
notifyallowed = true
RegisterNUICallback(
    "buttonerstewaffe",
    function()
        TriggerServerEvent("sevenlife:checkcash", 11000)
        TriggerEvent("sevenlife:removeblackmarketnui")
weponfirst = true
    end
)
RegisterNUICallback(
    "buttonzweitewaffe",
    function()
        TriggerServerEvent("sevenlife:checkcash",18000)
        TriggerEvent("sevenlife:removeblackmarketnui")
        weponsecond = true
    end
)

RegisterNUICallback(
    "buttondrittewaffe",
    function()
        TriggerServerEvent("sevenlife:checkcash", 29000)
        TriggerEvent("sevenlife:removeblackmarketnui")
        weponthird = true
    end
)

RegisterNetEvent("sevenlife:cashisnotenough")
AddEventHandler(
    "sevenlife:cashisnotenough",
    function(cashwhatisneeded)
 announce = true
        while announce do
            onlyonxe = false

            Citizen.Wait(100)
            TriggerEvent(
                "sevenliferp:startnui",
                "Du hast zu wenig geld du brauchst noch: " .. cashwhatisneeded .. "$",
                "System-Nachricht",
                true
            )

            Citizen.Wait(3000)
            TriggerEvent("sevenliferp:closenotify", false)
            onlyonxe = true
            announce = false
            isnotifyallowedthere = true
        end
    end
)

RegisterNetEvent("sevenlife:lieferung")
AddEventHandler(
    "sevenlife:lieferung",
    function()
        onlyonxe = false
        local random = math.random(1, 7)
        if random == 1 then
            TriggerEvent("sevenlife:marker", Config.lieferungpoints.point1)
        else
            if random == 2 then
                TriggerEvent("sevenlife:marker", Config.lieferungpoints.point2)
            else
                if random == 3 then
                    TriggerEvent("sevenlife:marker", Config.lieferungpoints.point3)
                else
                    if random == 4 then
                        TriggerEvent("sevenlife:marker", Config.lieferungpoints.point4)
                    else
                        if random == 5 then
                            TriggerEvent("sevenlife:marker", Config.lieferungpoints.point5)
                        else
                            if random == 6 then
                                TriggerEvent("sevenlife:marker", Config.lieferungpoints.point6)
                            else
                                if random == 7 then
                                    TriggerEvent("sevenlife:marker", Config.lieferungpoints.point7)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
)



function createobjectweapon(coords)
    local req = 1
    for i = 1, req, 1 do
        object = Config.spawnprop
        RequestModel(object)
        while not HasModelLoaded(object) do
            Citizen.Wait(500)
        end
        local coordx = coords.x
        local coordy = coords.y
        local coordz = coords.z
        createobject = CreateObjectNoOffset(object, coordx, coordy, coordz, 1, 0, 1)
        PlaceObjectOnGroundProperly(createobject)
        FreezeEntityPosition(createobject, true)
    end
end
function blips(coords)
    Blipb_1 = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipColour(Blipb_1, 40)
    SetBlipSprite(Blipb_1, 567)
    SetBlipScale(Blipb_1, 0.8)
    SetBlipDisplay(Blipb_1, 4)
    SetBlipRoute(Blipb_1, true)
    SetBlipRouteColour(Blipb_1, 83)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Waffen Lieferung")
    EndTextCommandSetBlipName(Blipb_1)
end
RegisterNetEvent("sevenlife:marker")
AddEventHandler(
    "sevenlife:marker",
    function(coords)
        createobjectweapon(coords)
        blips(coords)
        itemsdontget = true
        while itemsdontget do
            Citizen.Wait(5)
            local place = vector3(coords.x, coords.y, coords.z)
            local distance =
                GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vector3(place.x, place.y, place.z))
            if distance < 3 then
                if notifyallowed then
                    TriggerEvent(
                        "sevenliferp:startnui",
                        "Drücke <span1 color = white>E</span1> um die Lieferung zu öffnen",
                        "System-Nachricht",
                        true
                    )
                else
                    if notifyallowed == false then
                        TriggerEvent("sevenliferp:closenotify", false)
                    end
                end
                if IsControlJustReleased(0, 38) then
TriggerEvent("sevenliferp:closenotify", false)                   
 notifyallowed = false
                    local ped = GetPlayerPed(-1)
                    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_HAMMERING", 0, false)
                    Citizen.Wait(10000)
                    ClearPedTasks(ped)
                    deleteobject(createobject)
                    RemoveBlip(Blipb_1)
                    if weponfirst then
                        TriggerServerEvent("sevenlife:giveblackweapon", "1")
                        weponfirst = false
                    else
                        if weponsecond then
                            TriggerServerEvent("sevenlife:giveblackweapon", "2")
                            weponsecond = false
                        else
                            if weponthird then
                                TriggerServerEvent("sevenlife:giveblackweapon", "3")
                                weponthird = false
                            end
                        end
                    end
                    isnotifyallowedthere = true
                    itemsdontget = false
                    notifyallowed = true
                end
            else
                if distance >= 3.1 and distance <= 3.5 then
                    TriggerEvent("sevenliferp:closenotify", false)
                end
            end
        end
    end
)

function deleteobject(object)
    DeleteObject(object)
end