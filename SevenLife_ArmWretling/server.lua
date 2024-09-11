local sessions = {}

Citizen.CreateThread(
    function()
        local template = {place1 = 0, place2 = 0, started = false, grade = 0.5}
        for i, _ in pairs(Config.Props) do
            table.insert(sessions, template)
        end
    end
)

RegisterServerEvent("SevenLife:Wrestling:Check")
AddEventHandler(
    "SevenLife:Wrestling:Check",
    function(position)
        local a, b, c = table.unpack(position)
        for i, props in pairs(Config.Props) do
            local x = a - props.x
            local y = b - props.y
            local z = c - props.z
            print(1)
            if #vec3(x, y, z) < 1.5 then
                if sessions[i].place1 == 0 and not sessions[i].started then
                    sessions[i].place1 = source
                    TriggerClientEvent("SevenLife:ArmWrestling:CheckPlace", source, "place1")
                elseif sessions[i].place2 == 0 and sessions[i].place1 ~= 0 then
                    sessions[i].place2 = source
                    TriggerClientEvent("SevenLife:ArmWrestling:CheckPlace", source, "place2")
                else
                    TriggerClientEvent("SevenLife:ArmWrestling:CheckPlace", source, "noplace")
                    return
                end

                if sessions[i].place1 ~= 0 and sessions[i].place2 ~= 0 and not sessions[i].started then
                    TriggerClientEvent("SevenLife:Wrestling:StartGame", sessions[i].place1)
                    TriggerClientEvent("SevenLife:Wrestling:StartGame", sessions[i].place2)
                    break
                end
            end
        end
    end
)

RegisterServerEvent("SevenLife:ArmWrestling:SaveAll")
AddEventHandler(
    "SevenLife:ArmWrestling:SaveAll",
    function(pos)
        local a, b, c = table.unpack(pos)

        for i, props in pairs(Config.Props) do
            local x = a - props.x
            local y = b - props.y
            local z = c - props.z
            local _source = source
            if #vec3(x, y, z) < 1.5 then
                if sessions[i].place1 == source or sessions[i].place2 == source then
                    local k = i
                    if sessions[i].place1 ~= 0 then
                        TriggerClientEvent("SevenLife:Wrestling:Save", sessions[k].place1)
                    end
                    if sessions[i].place2 ~= 0 then
                        TriggerClientEvent("SevenLife:Wrestling:Save", sessions[i].place2)
                    end
                    Citizen.Wait(100)
                    sessions[i].started = false
                    sessions[i].place1 = 0
                    sessions[i].place2 = 0
                    sessions[i].grade = 0.5
                    break
                end
            end
        end
    end
)
RegisterServerEvent("SevenLife:Wrestling:UpdateGrade")
AddEventHandler(
    "SevenLife:Wrestling:UpdateGrade",
    function(gradeUpValue)
        for i, props in pairs(sessions) do
            if props.place1 == source or props.place2 == source then
                props.grade = props.grade + gradeUpValue
                if props.grade <= 0.10 then
                    props.grade = -999
                elseif props.grade >= 0.90 then
                    props.grade = 999
                end

                TriggerClientEvent("SevenLife:ArmWrestling:MakeGrade", props.place1, props.grade)
                TriggerClientEvent("SevenLife:ArmWrestling:MakeGrade", props.place2, props.grade)
                break
            end
        end
    end
)
