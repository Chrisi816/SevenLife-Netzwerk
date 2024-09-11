Config = {}

Config.PlaceWheel = {
    x = 977.95373535156,
    y = 48.739551544189,
    z = 74.681114196777
}

Config.Car = "ninef"

Config.VehiclePoss = {
    x = 963.04010009766,
    y = 47.611171722412,
    z = 75.581703186035,
    h = 177.64233398438
}

Config.ChipsPrice = 10 -- Price of Chips

Config.WaitorChips = {
    x = 978.42059326172,
    y = 39.083129882813,
    z = 73.882034301758,
    h = 55.41
}

Config.VideoType = "CASINO_DIA_PL"
Config.DrawDistance = 100.0
Config.MarkerSize = vector3(1.1, 1.1, 1.1)
Config.MarkerColor = {r = 143, g = 0, b = 71}
Config.MarkerType = 1

Config.Prices = {
    [1] = {type = "car", name = "car", count = 1, sound = "car", probability = {a = 0, b = 1}},
    [2] = {type = "money", name = "money", count = 15000, sound = "cash", probability = {a = 1, b = 5}},
    [3] = {type = "item", name = "casino_chips", count = 25000, sound = "chips", probability = {a = 10, b = 20}},
    [4] = {type = "money", name = "money", count = 40000, sound = "cash", probability = {a = 20, b = 40}},
    [5] = {type = "money", name = "money", count = 10000, sound = "cash", probability = {a = 40, b = 60}},
    [6] = {type = "item", name = "casino_chips", count = 20000, sound = "chips", probability = {a = 120, b = 170}},
    [7] = {type = "money", name = "money", count = 7500, sound = "cash", probability = {a = 170, b = 250}},
    [8] = {type = "item", name = "casino_chips", count = 15000, sound = "chips", probability = {a = 300, b = 340}},
    [9] = {type = "money", name = "money", count = 30000, sound = "cash", probability = {a = 340, b = 380}},
    [10] = {type = "money", name = "money", count = 5000, sound = "cash", probability = {a = 380, b = 540}},
    [11] = {type = "item", name = "casino_chips", count = 10000, sound = "chips", probability = {a = 610, b = 640}},
    [12] = {type = "money", name = "money", count = 20000, sound = "cash", probability = {a = 640, b = 700}},
    [13] = {type = "money", name = "money", count = 2500, sound = "cash", probability = {a = 700, b = 810}},
    [14] = {type = "money", name = "money", count = 50000, sound = "cash", probability = {a = 990, b = 1000}}
}

Config.blackjackTables = {
    [0] = {
        dealerPos = vector3(1014.8011474609, 47.287307739258, 72.281364440918),
        dealerHeading = 282.87,
        tablePos = vector3(1015.2540283203, 47.330978393555, 72.376998901367),
        tableHeading = -134.69,
        distance = 1000.0,
        prop = "vw_prop_casino_blckjack_01"
    },
    [1] = {
        dealerPos = vector3(1151.28, 267.33, -51.840),
        dealerHeading = 222.2,
        tablePos = vector3(1151.84, 266.747, -52.8409),
        tableHeading = 45.31,
        distance = 1000.0,
        prop = "vw_prop_casino_blckjack_01"
    },
    [2] = {
        dealerPos = vector3(1128.862, 261.795, -51.0357),
        dealerHeading = 315.0,
        tablePos = vector3(1129.406, 262.3578, -52.041),
        tableHeading = 135.31,
        distance = 1000.0,
        prop = "vw_prop_casino_blckjack_01b"
    },
    [3] = {
        dealerPos = vector3(1143.859, 246.783, -51.035),
        dealerHeading = 313.0,
        tablePos = vector3(1144.429, 247.3352, -52.041),
        tableHeading = 135.31,
        distance = 1000.0,
        prop = "vw_prop_casino_blckjack_01b"
    }
}

Config.maleCasinoDealer = GetHashKey("S_M_Y_Casino_01")
Config.femaleCasinoDealer = GetHashKey("S_F_Y_Casino_01")

Config.BarKeeper = {
    [0] = {
        coords = {
            x = 966.88653564453,
            y = 33.217346191406,
            z = 74.87,
            h = 7.21
        }
    },
    [1] = {
        coords = {
            x = 965.390625,
            y = 30.872236251831,
            z = 74.87,
            h = 84.34
        }
    },
    [2] = {
        coords = {
            x = 968.73394775391,
            y = 30.345470428467,
            z = 74.87,
            h = 245.17
        }
    }
}

Config.BarKeeperBuying = {
    [0] = {
        coords = {
            x = 963.92602539063,
            y = 29.901748657227,
            z = 74.876853942871
        }
    },
    [1] = {
        coords = {
            x = 969.64001464844,
            y = 28.7552318573,
            z = 74.876853942871
        }
    },
    [2] = {
        coords = {
            x = 966.42578125,
            y = 34.903686523438,
            z = 74.87
        }
    }
}

Config.RulettTables = {
    [0] = {
        position = vector3(1032.156, 60.0199, 71.4761),
        rot = 13.30,
        minBet = 5,
        maxBet = 100000000
    },
    [1] = {
        position = vector3(1031.199, 64.15562, 71.4761),
        rot = 193.30,
        minBet = 100,
        maxBet = 500000000
    },
    [2] = {
        position = vector3(1016.779, 69.56867, 72.27611),
        rot = 282.994,
        minBet = 5,
        maxBet = 1000000000
    },
    [3] = {
        position = vector3(1010.806, 68.18768, 72.27604),
        rot = 103.30,
        minBet = 250,
        maxBet = 10000000000
    }
}

Config.PokerTable = {
    [0] = {
        position = vector3(1023.62, 62.40461, 71.4761),
        rot = 192.99,
        minBet = 5,
        maxBet = 100000000
    },
    [1] = {
        position = vector3(1024.571, 58.28297, 71.4761),
        rot = 12.994029998779,
        minBet = 100,
        maxBet = 500000000
    },
    [2] = {
        position = vector3(1021.549, 48.89864, 72.27611),
        rot = 282.99420166016,
        minBet = 5,
        maxBet = 1000000000
    }
}
Config.Tables = {
    "h4_prop_casino_3cardpoker_01a",
    "h4_prop_casino_3cardpoker_01b",
    "h4_prop_casino_3cardpoker_01c",
    "h4_prop_casino_3cardpoker_01e",
    "vw_prop_casino_3cardpoker_01b",
    "vw_prop_casino_3cardpoker_01"
}
Config.PokerChairs = {
    ["Chair_Base_01"] = 1,
    ["Chair_Base_02"] = 2,
    ["Chair_Base_03"] = 3,
    ["Chair_Base_04"] = 4
}
Config.PlayerWaitingTime = 5
Config.Cards = {
    [1] = "vw_prop_vw_club_char_a_a",
    [2] = "vw_prop_vw_club_char_02a",
    [3] = "vw_prop_vw_club_char_03a",
    [4] = "vw_prop_vw_club_char_04a",
    [5] = "vw_prop_vw_club_char_05a",
    [6] = "vw_prop_vw_club_char_06a",
    [7] = "vw_prop_vw_club_char_07a",
    [8] = "vw_prop_vw_club_char_08a",
    [9] = "vw_prop_vw_club_char_09a",
    [10] = "vw_prop_vw_club_char_10a",
    [11] = "vw_prop_vw_club_char_j_a",
    [12] = "vw_prop_vw_club_char_q_a",
    [13] = "vw_prop_vw_club_char_k_a",
    [14] = "vw_prop_vw_dia_char_a_a",
    [15] = "vw_prop_vw_dia_char_02a",
    [16] = "vw_prop_vw_dia_char_03a",
    [17] = "vw_prop_vw_dia_char_04a",
    [18] = "vw_prop_vw_dia_char_05a",
    [19] = "vw_prop_vw_dia_char_06a",
    [20] = "vw_prop_vw_dia_char_07a",
    [21] = "vw_prop_vw_dia_char_08a",
    [22] = "vw_prop_vw_dia_char_09a",
    [23] = "vw_prop_vw_dia_char_10a",
    [24] = "vw_prop_vw_dia_char_j_a",
    [25] = "vw_prop_vw_dia_char_q_a",
    [26] = "vw_prop_vw_dia_char_k_a",
    [27] = "vw_prop_vw_hrt_char_a_a",
    [28] = "vw_prop_vw_hrt_char_02a",
    [29] = "vw_prop_vw_hrt_char_03a",
    [30] = "vw_prop_vw_hrt_char_04a",
    [31] = "vw_prop_vw_hrt_char_05a",
    [32] = "vw_prop_vw_hrt_char_06a",
    [33] = "vw_prop_vw_hrt_char_07a",
    [34] = "vw_prop_vw_hrt_char_08a",
    [35] = "vw_prop_vw_hrt_char_09a",
    [36] = "vw_prop_vw_hrt_char_10a",
    [37] = "vw_prop_vw_hrt_char_j_a",
    [38] = "vw_prop_vw_hrt_char_q_a",
    [39] = "vw_prop_vw_hrt_char_k_a",
    [40] = "vw_prop_vw_spd_char_a_a",
    [41] = "vw_prop_vw_spd_char_02a",
    [42] = "vw_prop_vw_spd_char_03a",
    [43] = "vw_prop_vw_spd_char_04a",
    [44] = "vw_prop_vw_spd_char_05a",
    [45] = "vw_prop_vw_spd_char_06a",
    [46] = "vw_prop_vw_spd_char_07a",
    [47] = "vw_prop_vw_spd_char_08a",
    [48] = "vw_prop_vw_spd_char_09a",
    [49] = "vw_prop_vw_spd_char_10a",
    [50] = "vw_prop_vw_spd_char_j_a",
    [51] = "vw_prop_vw_spd_char_q_a",
    [52] = "vw_prop_vw_spd_char_k_a"
}

Config.CasinoSlots = {
    ["vw_prop_casino_slot_01a"] = {
        bet = 500,
        prop1 = "vw_prop_casino_slot_01a_reels",
        prop2 = "vw_prop_casino_slot_01b_reels"
    },
    ["vw_prop_casino_slot_02a"] = {
        bet = 1000,
        prop1 = "vw_prop_casino_slot_02a_reels",
        prop2 = "vw_prop_casino_slot_02b_reels"
    },
    ["vw_prop_casino_slot_03a"] = {
        -- Shoot First
        bet = 2000,
        prop1 = "vw_prop_casino_slot_03a_reels",
        prop2 = "vw_prop_casino_slot_03b_reels"
    },
    ["vw_prop_casino_slot_04a"] = {
        -- Fame or Shame
        bet = 500,
        prop1 = "vw_prop_casino_slot_04a_reels",
        prop2 = "vw_prop_casino_slot_04b_reels"
    },
    ["vw_prop_casino_slot_05a"] = {
        -- Fortune And Glory
        bet = 1000,
        prop1 = "vw_prop_casino_slot_05a_reels",
        prop2 = "vw_prop_casino_slot_05b_reels"
    },
    ["vw_prop_casino_slot_06a"] = {
        -- Have A Stab
        bet = 1000,
        prop1 = "vw_prop_casino_slot_06a_reels",
        prop2 = "vw_prop_casino_slot_06b_reels"
    },
    ["vw_prop_casino_slot_07a"] = {
        -- Diamonds
        bet = 2000,
        prop1 = "vw_prop_casino_slot_07a_reels",
        prop2 = "vw_prop_casino_slot_07b_reels"
    },
    ["vw_prop_casino_slot_08a"] = {
        bet = 1000,
        prop1 = "vw_prop_casino_slot_08a_reels",
        prop2 = "vw_prop_casino_slot_08b_reels"
    }
}
Config.Wins = {
    [1] = "2",
    [2] = "3",
    [3] = "6",
    [4] = "2",
    [5] = "4",
    [6] = "1",
    [7] = "6",
    [8] = "5",
    [9] = "2",
    [10] = "1",
    [11] = "3",
    [12] = "6",
    [13] = "7",
    [14] = "1",
    [15] = "4",
    [16] = "5"
}

Config.Mult = {
    ["1"] = 2,
    ["2"] = 2,
    ["3"] = 2.5,
    ["4"] = 3,
    ["5"] = 4,
    ["6"] = 5,
    ["7"] = 5.5
}
Config.OffsetNum = 30

Config.ChairIds = {
    ["Chair_Base_01"] = 1,
    ["Chair_Base_02"] = 2,
    ["Chair_Base_03"] = 3,
    ["Chair_Base_04"] = 4
}
Config.RouletteStart = 40
Config.TestTicker = nil
RULETT_NUMBERS = {}
RULETT_NUMBERS.Pirosak = {
    ["1"] = true,
    ["3"] = true,
    ["5"] = true,
    ["7"] = true,
    ["9"] = true,
    ["12"] = true,
    ["14"] = true,
    ["16"] = true,
    ["18"] = true,
    ["19"] = true,
    ["21"] = true,
    ["23"] = true,
    ["25"] = true,
    ["27"] = true,
    ["30"] = true,
    ["32"] = true,
    ["34"] = true,
    ["36"] = true
}
RULETT_NUMBERS.Feketek = {
    ["2"] = true,
    ["4"] = true,
    ["6"] = true,
    ["8"] = true,
    ["10"] = true,
    ["11"] = true,
    ["13"] = true,
    ["15"] = true,
    ["17"] = true,
    ["20"] = true,
    ["22"] = true,
    ["24"] = true,
    ["26"] = true,
    ["28"] = true,
    ["29"] = true,
    ["31"] = true,
    ["33"] = true,
    ["35"] = true
}
RULETT_NUMBERS.Parosak = {
    ["2"] = true,
    ["4"] = true,
    ["6"] = true,
    ["8"] = true,
    ["10"] = true,
    ["12"] = true,
    ["14"] = true,
    ["16"] = true,
    ["18"] = true,
    ["20"] = true,
    ["22"] = true,
    ["24"] = true,
    ["26"] = true,
    ["28"] = true,
    ["30"] = true,
    ["32"] = true,
    ["34"] = true,
    ["36"] = true
}
RULETT_NUMBERS.Paratlanok = {
    ["1"] = true,
    ["3"] = true,
    ["5"] = true,
    ["7"] = true,
    ["9"] = true,
    ["11"] = true,
    ["13"] = true,
    ["15"] = true,
    ["17"] = true,
    ["19"] = true,
    ["21"] = true,
    ["23"] = true,
    ["25"] = true,
    ["27"] = true,
    ["29"] = true,
    ["31"] = true,
    ["33"] = true,
    ["35"] = true
}
RULETT_NUMBERS.to18 = {
    ["1"] = true,
    ["2"] = true,
    ["3"] = true,
    ["4"] = true,
    ["5"] = true,
    ["6"] = true,
    ["7"] = true,
    ["8"] = true,
    ["9"] = true,
    ["10"] = true,
    ["11"] = true,
    ["12"] = true,
    ["13"] = true,
    ["14"] = true,
    ["15"] = true,
    ["16"] = true,
    ["17"] = true,
    ["18"] = true
}
RULETT_NUMBERS.to36 = {
    ["19"] = true,
    ["20"] = true,
    ["21"] = true,
    ["22"] = true,
    ["23"] = true,
    ["24"] = true,
    ["25"] = true,
    ["26"] = true,
    ["27"] = true,
    ["28"] = true,
    ["29"] = true,
    ["30"] = true,
    ["31"] = true,
    ["32"] = true,
    ["33"] = true,
    ["34"] = true,
    ["35"] = true,
    ["36"] = true
}
RULETT_NUMBERS.st12 = {
    ["1"] = true,
    ["2"] = true,
    ["3"] = true,
    ["4"] = true,
    ["5"] = true,
    ["6"] = true,
    ["7"] = true,
    ["8"] = true,
    ["9"] = true,
    ["10"] = true,
    ["11"] = true,
    ["12"] = true
}
RULETT_NUMBERS.sn12 = {
    ["13"] = true,
    ["14"] = true,
    ["15"] = true,
    ["16"] = true,
    ["17"] = true,
    ["18"] = true,
    ["19"] = true,
    ["20"] = true,
    ["21"] = true,
    ["22"] = true,
    ["23"] = true,
    ["24"] = true
}
RULETT_NUMBERS.rd12 = {
    ["25"] = true,
    ["26"] = true,
    ["27"] = true,
    ["28"] = true,
    ["29"] = true,
    ["30"] = true,
    ["31"] = true,
    ["32"] = true,
    ["33"] = true,
    ["34"] = true,
    ["35"] = true,
    ["36"] = true
}
RULETT_NUMBERS.ket_to_1 = {
    ["1"] = true,
    ["4"] = true,
    ["7"] = true,
    ["10"] = true,
    ["13"] = true,
    ["16"] = true,
    ["19"] = true,
    ["22"] = true,
    ["25"] = true,
    ["28"] = true,
    ["31"] = true,
    ["34"] = true
}
RULETT_NUMBERS.ket_to_2 = {
    ["2"] = true,
    ["5"] = true,
    ["8"] = true,
    ["11"] = true,
    ["14"] = true,
    ["17"] = true,
    ["20"] = true,
    ["23"] = true,
    ["26"] = true,
    ["29"] = true,
    ["32"] = true,
    ["35"] = true
}
RULETT_NUMBERS.ket_to_3 = {
    ["3"] = true,
    ["6"] = true,
    ["9"] = true,
    ["12"] = true,
    ["15"] = true,
    ["18"] = true,
    ["21"] = true,
    ["24"] = true,
    ["27"] = true,
    ["30"] = true,
    ["33"] = true,
    ["36"] = true
}
Config.TablesRoul = {
    "ch_prop_casino_roulette_01a",
    "ch_prop_casino_roulette_01b",
    "vw_prop_casino_roulette_01",
    "vw_prop_casino_roulette_01b"
}
