Config = {}

Config.FuelDecor = "_FUEL_LEVEL"

Config.Tankstellen = {
    {x = 49.4187, y = 2778.793, z = 58.043, tanknumber = 1},
    {x = 263.894, y = 2606.463, z = 44.983, tanknumber = 2},
    {x = 1039.958, y = 2671.134, z = 39.550, tanknumber = 3},
    {x = 1207.260, y = 2660.175, z = 37.899, tanknumber = 4},
    {x = 2539.685, y = 2594.192, z = 37.944, tanknumber = 5},
    {x = 2679.858, y = 3263.946, z = 55.043, tanknumber = 6},
    {x = 2005.055, y = 3773.887, z = 32.043, tanknumber = 7},
    {x = 1687.156, y = 4929.392, z = 42.043, tanknumber = 8},
    {x = 1701.314, y = 6416.028, z = 32.043, tanknumber = 9},
    {x = 179.857, y = 6602.839, z = 31.043, tanknumber = 10},
    {x = -94.4619, y = 6419.594, z = 31.043, tanknumber = 11},
    {x = -2554.996, y = 2334.40, z = 33.043, tanknumber = 12},
    {x = -1800.375, y = 803.661, z = 138.043, tanknumber = 13},
    {x = -1437.622, y = -276.747, z = 46.043, tanknumber = 14},
    {x = -2096.243, y = -320.286, z = 13.043, tanknumber = 15},
    {x = -724.619, y = -935.1631, z = 19.043, tanknumber = 16},
    {x = -526.019, y = -1211.003, z = 19.043, tanknumber = 17},
    {x = -70.2148, y = -1761.792, z = 18.043, tanknumber = 18},
    {x = 265.648, y = -1261.309, z = 29.043, tanknumber = 19},
    {x = 819.653, y = -1028.846, z = 29.043, tanknumber = 21},
    {x = 1208.951, y = -1402.567, z = 26.043, tanknumber = 22},
    {x = 1181.381, y = -330.847, z = 69.316, tanknumber = 23},
    {x = 620.843, y = 269.100, z = 103.316, tanknumber = 24},
    {x = 2581.321, y = 362.039, z = 108.316, tanknumber = 25},
    {x = 176.631, y = -1562.025, z = 29.316, tanknumber = 26},
    {x = -319.292, y = -1471.715, z = 30.316, tanknumber = 27},
    {x = 1784.324, y = 3330.55, z = 41.316, tanknumber = 28},
    {
        x = -1303.39,
        y = -3378.14,
        z = 13.94,
        tanknumber = 29
    },
    {
        x = -719.16,
        y = -1365.37,
        z = 1.6,
        tanknumber = 30
    }
}

Config.Flieger = {
    x = -1303.39,
    y = -3378.14,
    z = 13.94,
    heading = 42.25
}

Config.Boot = {
    x = -719.16,
    y = -1365.37,
    z = 1.6,
    headin = 118.45
}

Config.andereTanken = {
    Boot = {
        x = -719.16,
        y = -1365.37,
        z = 1.6,
        headin = 118.45
    },
    Flieger = {
        x = -1303.39,
        y = -3378.14,
        z = 13.94,
        heading = 42.25
    }
}

Config.Classes = {
    [0] = 1.0, -- Compacts
    [1] = 1.0, -- Sedans
    [2] = 1.0, -- SUVs
    [3] = 1.0, -- Coupes
    [4] = 1.0, -- Muscle
    [5] = 1.0, -- Sports Classics
    [6] = 1.0, -- Sports
    [7] = 1.0, -- Super
    [8] = 1.0, -- Motorcycles
    [9] = 1.0, -- Off-road
    [10] = 1.0, -- Industrial
    [11] = 1.0, -- Utility
    [12] = 1.0, -- Vans
    [13] = 0.0, -- Cycles
    [14] = 1.0, -- Boats
    [15] = 1.0, -- Helicopters
    [16] = 1.0, -- Planes
    [17] = 1.0, -- Service
    [18] = 1.0, -- Emergency
    [19] = 1.0, -- Military
    [20] = 1.0, -- Commercial
    [21] = 1.0 -- Trains
}

Config.FuelUsage = {
    [1.0] = 1.4,
    [0.9] = 1.2,
    [0.8] = 1.0,
    [0.7] = 0.9,
    [0.6] = 0.8,
    [0.5] = 0.7,
    [0.4] = 0.5,
    [0.3] = 0.4,
    [0.2] = 0.2,
    [0.1] = 0.1,
    [0.0] = 0.0
}
Config.DisableKeys = {0, 22, 23, 24, 29, 30, 31, 37, 44, 56, 82, 140, 166, 167, 168, 170, 288, 289, 311, 323}
Config.PumpModels = {
    [-2007231801] = true,
    [1339433404] = true,
    [1694452750] = true,
    [1933174915] = true,
    [-462817101] = true,
    [-469694731] = true,
    [-164877493] = true
}
Config.TankeKauf = {
    x = -885.87,
    y = -1233.22,
    z = 4.66,
    heading = 344.98
}
Config.Tankstellens = {
    Tanke1 = {
        Pos = {x = 49.4187, y = 2778.793, z = 58.043, tanknumber = "1"}
    },
    Tanke2 = {
        Pos = {x = 263.894, y = 2606.463, z = 44.983, tanknumber = "2"}
    },
    Tanke3 = {
        Pos = {x = 1039.958, y = 2671.134, z = 39.550, tanknumber = "3"}
    },
    Tanke4 = {
        Pos = {x = 1207.260, y = 2660.175, z = 37.899, tanknumber = "4"}
    },
    Tanke5 = {
        Pos = {x = 2539.685, y = 2594.192, z = 37.944, tanknumber = "5"}
    },
    Tanke6 = {
        Pos = {x = 2679.858, y = 3263.946, z = 55.043, tanknumber = "6"}
    },
    Tanke7 = {
        Pos = {x = 2005.055, y = 3773.887, z = 32.043, tanknumber = "7"}
    },
    Tanke8 = {
        Pos = {x = 1687.156, y = 4929.392, z = 42.043, tanknumber = "8"}
    },
    Tanke9 = {
        Pos = {x = 1701.314, y = 6416.028, z = 32.043, tanknumber = "9"}
    },
    Tanke10 = {
        Pos = {x = 179.857, y = 6602.839, z = 31.043, tanknumber = "10"}
    },
    Tanke11 = {
        Pos = {x = -94.4619, y = 6419.594, z = 31.043, tanknumber = "11"}
    },
    Tanke12 = {
        Pos = {x = -2554.996, y = 2334.40, z = 33.043, tanknumber = "12"}
    },
    Tanke13 = {
        Pos = {x = -1800.375, y = 803.661, z = 138.043, tanknumber = "13"}
    },
    Tanke14 = {
        Pos = {x = -1437.622, y = -276.747, z = 46.043, tanknumber = "14"}
    },
    Tanke15 = {
        Pos = {x = -2096.243, y = -320.286, z = 13.043, tanknumber = "15"}
    },
    Tanke16 = {
        Pos = {x = -724.619, y = -935.1631, z = 19.043, tanknumber = "16"}
    },
    Tanke17 = {
        Pos = {x = -526.019, y = -1211.003, z = 19.043, tanknumber = "17"}
    },
    Tanke18 = {
        Pos = {x = -70.2148, y = -1761.792, z = 18.043, tanknumber = "18"}
    },
    Tanke19 = {
        Pos = {x = 265.648, y = -1261.309, z = 29.043, tanknumber = "19"}
    },
    Tanke20 = {
        Pos = {x = 819.653, y = -1028.846, z = 29.043, tanknumber = "21"}
    },
    Tanke21 = {
        Pos = {x = 1208.951, y = -1402.567, z = 26.043, tanknumber = "22"}
    },
    Tanke22 = {
        Pos = {x = 1181.381, y = -330.847, z = 69.316, tanknumber = "23"}
    },
    Tanke23 = {
        Pos = {x = 620.843, y = 269.100, z = 103.316, tanknumber = "24"}
    },
    Tanke24 = {
        Pos = {x = 2581.321, y = 362.039, z = 108.316, tanknumber = "25"}
    },
    Tanke25 = {
        Pos = {x = 176.631, y = -1562.025, z = 29.316, tanknumber = "26"}
    },
    Tanke26 = {
        Pos = {x = -319.292, y = -1471.715, z = 30.316, tanknumber = "27"}
    },
    Tanke27 = {
        Pos = {x = 1784.324, y = 3330.55, z = 41.316, tanknumber = "28"}
    }
}
