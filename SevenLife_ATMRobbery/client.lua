local Decor = "ATM"
local alarmed = false

Citizen.CreateThread(
    function()
        DecorRegister(Decor, 2)

        while true do
            Citizen.Wait(2000)
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local atm =
                GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 15.0, "prop_atm_01", false, false, false)
            if DoesEntityExist(atm) then
                local atmHealth = GetEntityHealth(atm)

                if atmHealth == 0 then
                    local broken = GetBrokenATM(atm)
                    if not broken then
                        SetBrokenATM(atm, true)
                        MakeMoney(atm)
                        SetEntityHealth(atm, 1000)
                        Citizen.Wait(3000)
                        alarmed = false
                    end
                end
                if atmHealth < 400 and not alarmed then
                    NetworkRegisterEntityAsNetworked(atm)
                    local netid = NetworkGetNetworkIdFromEntity(atm)

                    TriggerServerEvent("SevenLife:Raub:AlarmCops", netid)
                    alarmed = true
                end
            end
        end
    end
)

function SetBrokenATM(atm, status)
    DecorSetBool(atm, Decor, status)
end

function MakeMoney(atm)
    local count = 0
    local netid = NetworkGetNetworkIdFromEntity(atm)

    while not NetworkDoesNetworkIdExist(netid) do
        Citizen.Wait(10)
        netid = NetworkGetNetworkIdFromEntity(atm)
        count = count + 1
        if count == 100 then
            return
        end
    end

    TriggerServerEvent("SevenLife:Rob:RobbingAtm", netid)

    local heading = GetEntityHeading(atm)
    GetPart("scr_xs_celebration")
    local pfx =
        StartParticleFxLoopedOnEntity(
        "scr_xs_money_rain",
        atm,
        -0.1,
        -0.3,
        0.75,
        -90.0,
        heading - 180.0,
        heading,
        1.0,
        false,
        false,
        false
    )
    Citizen.Wait(15000)
    StopParticleFxLooped(pfx, 0)
end
function GetPart(ptfx)
    while not HasNamedPtfxAssetLoaded(ptfx) do
        RequestNamedPtfxAsset(ptfx)
        Wait(10)
    end
    UseParticleFxAssetNextCall(ptfx)
end

function GetBrokenATM(atm)
    if not DecorExistOn(atm, Decor) then
        return false
    end
    return DecorGetBool(atm, Decor)
end
