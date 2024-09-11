RegisterNetEvent("SevenLife:Drogen:JoinLaborMeth")
AddEventHandler(
    "SevenLife:Drogen:JoinLaborMeth",
    function()
        RequestModel("tr_prop_meth_table01a")
        RequestModel("bkr_prop_meth_phosphorus")
        RequestModel("bkr_prop_meth_pseudoephedrine")
        RequestModel("bkr_prop_coke_pallet_01a")
        RequestModel("v_ret_ml_tablec")
        RequestModel("prop_meth_setup_01")
        RequestModel("v_corp_conftable3")
        local obj =
            CreateObject(
            "tr_prop_meth_table01a",
            1011.8621826172,
            -3202.3654785156,
            -39.9931640625,
            false,
            false,
            false
        )
        local obj1 =
            CreateObject(
            "bkr_prop_meth_phosphorus",
            1004.5235595703,
            -3202.623046875,
            -39.773141174316,
            false,
            false,
            false
        )
        local obj2 =
            CreateObject(
            "bkr_prop_meth_phosphorus",
            1003.2129516602,
            -3202.6240234375,
            -39.773141174316,
            false,
            false,
            false
        )
        local obj3 =
            CreateObject(
            "bkr_prop_meth_pseudoephedrine",
            1012.0690917969,
            -3194.1843261719,
            -39.197261810303,
            false,
            false,
            false
        )
        local obj4 =
            CreateObject("bkr_prop_coke_pallet_01a", 1003.852355957, -3202.2517089844, -40.0, false, false, false)
        local obj5 = CreateObject("v_ret_ml_tablec", 1016.7018432617, -3193.9965820313, -40.0, false, false, false)
        local obj6 = CreateObject("prop_meth_setup_01", 1011.3963012695, -3196.8391113281, -39.19, false, false, false)
        local obj7 = CreateObject("v_corp_conftable3", 1011.4426269531, -3197.1450195313, -39.95, false, false, false)
        local obj8 = CreateObject("v_corp_conftable3", 1011.4047851563, -3198.2717285156, -39.95, false, false, false)
        SetEntityHeading(obj5, 177.38)
        SetEntityHeading(obj6, 186.07)
        FreezeEntityPosition(obj, true)
        FreezeEntityPosition(obj1, true)
        FreezeEntityPosition(obj2, true)
        FreezeEntityPosition(obj3, true)
        FreezeEntityPosition(obj4, true)
        FreezeEntityPosition(obj5, true)
        FreezeEntityPosition(obj6, true)
        FreezeEntityPosition(obj7, true)
        FreezeEntityPosition(obj8, true)
    end
)
