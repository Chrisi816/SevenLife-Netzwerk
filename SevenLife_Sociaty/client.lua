RegisterNetEvent("SevenLife:Pay:MakeSociatyMessage")
AddEventHandler(
    "SevenLife:Pay:MakeSociatyMessage",
    function(wage, job)
        TriggerEvent("SevenLife:Notify:MakeMoneyNotify", wage, job)
    end
)
