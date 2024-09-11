Config = {}
SevenLife = {}
-- Blip Locations
Config.bliplocation = {
    x = -211.58,
    y = -1324.22,
    z = 100.00
}

-- Garage Locations
Config.garaglocations = {
    x = -177.87,
    y = -1282.26,
    z = 30.4,
    heading = 185.85
}
-- Laggerraum
Config.Laggerraum = {
    x = -226.78,
    y = -1332.38,
    z = 29.90,
    heading = 327.33
}
-- Mixer
Config.FarbenMixer = {
    x = -227.92,
    y = -1326.32,
    z = 30.9
}
-- SpawnCard
Config.CarSpawn = {
    x = -180.35,
    y = -1293.25,
    z = 31.3,
    heading = 183.64
}
-- Farbe ändern
Config.Farbeeandern = {
    x = -198.15,
    y = -1324.27,
    z = 30.2
}
-- Arbeitskleidung
Config.Arbeitskleidung = {
    x = -206.7,
    y = -1339.27,
    z = 33.89,
    heading = 89.8
}

Config.RepairKit = {
    x = 1167.92,
    y = -2975.97,
    z = 4.01
}

Config.PlateLetters = 3
Config.PlateNumbers = 3
Config.IDLetter = 10
Config.IDNumber = 10

Config.InDel = {
    x = -179.75038146973,
    y = -1327.6439208984,
    z = 30.248504638672
}

Config.DeleteVehicle = {
    x = -191.27824401855,
    y = -1290.6413574219,
    z = 30.295957565308
}

Config.MakeWerstatt = {
    x = -222.44,
    y = -1324.28,
    z = 29.9
}

Config.DrawDistance = 100.0
Config.MarkerSize = vector3(2.5, 2.5, 2.1)
Config.MarkerSize2 = vector3(8.5, 8.5, 2.1)
Config.MarkerColor = {r = 143, g = 0, b = 71}
Config.MarkerType = 1

Config.Kleidung = {
    male = {
        ["tshirt_1"] = 0,
        ["tshirt_2"] = 0,
        ["torso_1"] = 251,
        ["torso_2"] = 0,
        ["arms"] = 41,
        ["pants_1"] = 98,
        ["pants_2"] = 0,
        ["shoes_1"] = 14,
        ["shoes_2"] = 0,
        ["bproof_1"] = 0,
        ["bproof_2"] = 0,
        ["mask_1"] = 0,
        ["mask_2"] = 0
    },
    female = {
        ["tshirt_1"] = 65,
        ["tshirt_2"] = 0,
        ["torso_1"] = 85,
        ["torso_2"] = 0,
        ["arms"] = 0,
        ["pants_1"] = 100,
        ["pants_2"] = 0,
        ["shoes_1"] = 25,
        ["shoes_2"] = 0,
        ["bproof_1"] = 6,
        ["bproof_2"] = 2,
        ["mask_1"] = 0,
        ["mask_2"] = 0
    }
}

lsc = {
    frontbumper = {
        title = "Frontstange",
        name = "frontbumper",
        buttons = {}
    },
    rearbumper = {
        title = "H. Stoßstange",
        name = "rearbumper",
        buttons = {}
    },
    exhaust = {
        title = "Auspuff",
        name = "exhaust",
        buttons = {}
    },
    fenders = {
        title = "Kotflügel",
        name = "fenders",
        buttons = {}
    },
    grille = {
        title = "Gitter",
        name = "grille",
        buttons = {}
    },
    hood = {
        title = "Haube",
        name = "hood",
        buttons = {}
    },
    rollcage = {
        title = "Überrollkäfig",
        name = "rollcage",
        buttons = {}
    },
    roof = {
        title = "Dach",
        name = "roof",
        buttons = {}
    },
    skirts = {
        title = "Skirts",
        name = "skirts",
        buttons = {}
    },
    spoiler = {
        title = "Spoiler",
        name = "spoiler",
        buttons = {}
    },
    chassis = {
        title = "Chassis",
        name = "chassis",
        buttons = {}
    },
    windows = {
        title = "Fenster",
        name = "windows",
        buttons = {
            {name = "None", tint = false, costs = 10, description = "", centre = 0, font = 0, scale = 0.4},
            {name = "Pure Black", tint = 1, costs = 50, description = "", centre = 0, font = 0, scale = 0.4},
            {name = "Darksmoke", tint = 2, costs = 45, description = "", centre = 0, font = 0, scale = 0.4},
            {name = "Lightsmoke", tint = 3, costs = 35, description = "", centre = 0, font = 0, scale = 0.4},
            {name = "Limo", tint = 4, costs = 60, description = "", centre = 0, font = 0, scale = 0.4},
            {name = "Green", tint = 5, costs = 30, description = "", centre = 0, font = 0, scale = 0.4}
        }
    },
    wheelaccessories = {
        title = "Rad Zubehör",
        name = "wheelaccessories",
        buttons = {
            {
                name = "White Tire Smoke",
                color = {254, 254, 254},
                costs = 25,
                description = ""
            },
            {
                name = "Black Tire Smoke",
                color = {1, 1, 1},
                costs = 25,
                description = ""
            },
            {
                name = "Blue Tire Smoke",
                color = {0, 150, 255},
                costs = 30,
                description = ""
            },
            {
                name = "Yellow Tire Smoke",
                color = {255, 255, 50},
                costs = 30,
                description = ""
            },
            {
                name = "Orange Tire Smoke",
                color = {255, 153, 51},
                costs = 30,
                description = ""
            },
            {
                name = "Red Tire Smoke",
                color = {255, 10, 10},
                costs = 30,
                description = ""
            },
            {
                name = "Green Tire Smoke",
                color = {10, 255, 10},
                costs = 30,
                description = ""
            },
            {
                name = "Purple Tire Smoke",
                color = {153, 10, 153},
                costs = 30,
                description = ""
            },
            {
                name = "Pink Tire Smoke",
                color = {255, 102, 178},
                costs = 30,
                description = ""
            },
            {
                name = "Gray Tire Smoke",
                color = {128, 128, 128},
                costs = 30,
                description = ""
            }
        }
    },
    suspension = {
        title = "Federung",
        name = "suspensions",
        buttons = {
            {
                name = "Stock Federung",
                mod = -1,
                modtype = 15,
                costs = 30,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Lowered Federung",
                mod = false,
                modtype = 15,
                costs = 125,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Street Federung",
                mod = 1,
                modtype = 15,
                costs = 145,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Sport Federung",
                mod = 2,
                modtype = 15,
                costs = 160,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Competition Federung",
                mod = 3,
                modtype = 15,
                costs = 180,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        }
    },
    transmission = {
        title = "Getriebe",
        name = "transmission",
        buttons = {
            {
                name = "Stock Getriebe",
                mod = -1,
                modtype = 13,
                costs = 50,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Street Getriebe",
                mod = false,
                modtype = 13,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Sports Getriebe",
                mod = 1,
                modtype = 13,
                costs = 180,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Race Getriebe",
                mod = 2,
                modtype = 13,
                costs = 210,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        }
    },
    turbo = {
        title = "Turbo",
        name = "turbo",
        buttons = {
            {
                name = "None",
                mod = false,
                modtype = 18,
                costs = 300,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Turbo Tuning",
                mod = true,
                modtype = 18,
                costs = 1100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        }
    },
    sport = {
        title = "Sport Räder",
        name = "sport",
        buttons = {
            {
                name = "Stock",
                wtype = false,
                modtype = 23,
                mod = -1,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Inferno",
                wtype = false,
                modtype = 23,
                mod = false,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Deepfive",
                wtype = false,
                modtype = 23,
                mod = 1,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Lozspeed",
                wtype = false,
                modtype = 23,
                mod = 2,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Diamondcut",
                wtype = false,
                modtype = 23,
                mod = 3,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Chrono",
                wtype = false,
                modtype = 23,
                mod = 4,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Feroccirr",
                wtype = false,
                modtype = 23,
                mod = 5,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Fiftynine",
                wtype = false,
                modtype = 23,
                mod = 6,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Mercie",
                wtype = false,
                modtype = 23,
                mod = 7,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Syntheticz",
                wtype = false,
                modtype = 23,
                mod = 8,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Organictyped",
                wtype = false,
                modtype = 23,
                mod = 9,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Endov1",
                wtype = false,
                modtype = 23,
                mod = 10,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Duper7",
                wtype = false,
                modtype = 23,
                mod = 11,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Uzer",
                wtype = false,
                modtype = 23,
                mod = 12,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Groundride",
                wtype = false,
                modtype = 23,
                mod = 13,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Spacer",
                wtype = false,
                modtype = 23,
                mod = 14,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Venum",
                wtype = false,
                modtype = 23,
                mod = 15,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Cosmo",
                wtype = false,
                modtype = 23,
                mod = 16,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Dashvip",
                wtype = false,
                modtype = 23,
                mod = 17,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Icekid",
                wtype = false,
                modtype = 23,
                mod = 18,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Ruffeld",
                wtype = false,
                modtype = 23,
                mod = 19,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Wangenmaster",
                wtype = false,
                modtype = 23,
                mod = 20,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Superfive",
                wtype = false,
                modtype = 23,
                mod = 21,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Endov2",
                wtype = false,
                modtype = 23,
                mod = 22,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Slitsix",
                wtype = false,
                modtype = 23,
                mod = 23,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        }
    },
    suv = {
        title = "SUV Räder",
        name = "suv",
        buttons = {
            {
                name = "Stock",
                wtype = 3,
                modtype = 23,
                mod = -1,
                costs = 20,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Vip",
                wtype = 3,
                modtype = 23,
                mod = false,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Benefactor",
                wtype = 3,
                modtype = 23,
                mod = 1,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Cosmo",
                wtype = 3,
                modtype = 23,
                mod = 2,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Bippu",
                wtype = 3,
                modtype = 23,
                mod = 3,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Royalsix",
                wtype = 3,
                modtype = 23,
                mod = 4,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Fagorme",
                wtype = 3,
                modtype = 23,
                mod = 5,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Deluxe",
                wtype = 3,
                modtype = 23,
                mod = 6,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Icedout",
                wtype = 3,
                modtype = 23,
                mod = 7,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Cognscenti",
                wtype = 3,
                modtype = 23,
                mod = 8,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Lozspeedten",
                wtype = 3,
                modtype = 23,
                mod = 9,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Supernova",
                wtype = 3,
                modtype = 23,
                mod = 10,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Obeyrs",
                wtype = 3,
                modtype = 23,
                mod = 11,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Lozspeedballer",
                wtype = 3,
                modtype = 23,
                mod = 12,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Extra vaganzo",
                wtype = 3,
                modtype = 23,
                mod = 13,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Splitsix",
                wtype = 3,
                modtype = 23,
                mod = 14,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Empowered",
                wtype = 3,
                modtype = 23,
                mod = 15,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Sunrise",
                wtype = 3,
                modtype = 23,
                mod = 16,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Dashvip",
                wtype = 3,
                modtype = 23,
                mod = 17,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Cutter",
                wtype = 3,
                modtype = 23,
                mod = 18,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        },
        offroad = {
            title = "Offroad Räder",
            name = "offroad",
            buttons = {
                {
                    name = "Stock",
                    wtype = 4,
                    modtype = 23,
                    mod = -1,
                    costs = 30,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Raider",
                    wtype = 4,
                    modtype = 23,
                    mod = false,
                    costs = 80,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Mudslinger",
                    modtype = 23,
                    mod = 1,
                    costs = 80,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Nevis",
                    wtype = 4,
                    modtype = 23,
                    mod = 2,
                    costs = 80,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Cairngorm",
                    wtype = 4,
                    modtype = 23,
                    mod = 3,
                    costs = 80,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Amazon",
                    wtype = 4,
                    modtype = 23,
                    mod = 4,
                    costs = 80,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Challenger",
                    wtype = 4,
                    modtype = 23,
                    mod = 5,
                    costs = 80,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Dunebasher",
                    wtype = 4,
                    modtype = 23,
                    mod = 6,
                    costs = 80,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Fivestar",
                    wtype = 4,
                    modtype = 23,
                    mod = 7,
                    costs = 80,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Rockcrawler",
                    wtype = 4,
                    modtype = 23,
                    mod = 8,
                    costs = 80,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Milspecsteelie",
                    wtype = 4,
                    modtype = 23,
                    mod = 9,
                    costs = 80,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                }
            }
        },
        tuner = {
            title = "Tuning Räder",
            name = "tuner",
            buttons = {
                {
                    name = "Stock",
                    wtype = 5,
                    modtype = 23,
                    mod = -1,
                    costs = 35,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Cosmo",
                    wtype = 5,
                    modtype = 23,
                    mod = false,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Supermesh",
                    wtype = 5,
                    modtype = 23,
                    mod = 1,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Outsider",
                    wtype = 5,
                    modtype = 23,
                    mod = 2,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Rollas",
                    wtype = 5,
                    modtype = 23,
                    mod = 3,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Driffmeister",
                    wtype = 5,
                    modtype = 23,
                    mod = 4,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Slicer",
                    wtype = 5,
                    modtype = 23,
                    mod = 5,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Elquatro",
                    wtype = 5,
                    modtype = 23,
                    mod = 6,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Dubbed",
                    wtype = 5,
                    modtype = 23,
                    mod = 7,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Fivestar",
                    wtype = 5,
                    modtype = 23,
                    mod = 8,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Slideways",
                    wtype = 5,
                    modtype = 23,
                    mod = 9,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Apex",
                    wtype = 5,
                    modtype = 23,
                    mod = 10,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Stancedeg",
                    wtype = 5,
                    modtype = 23,
                    mod = 11,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Countersteer",
                    wtype = 5,
                    modtype = 23,
                    mod = 12,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Endov1",
                    wtype = 5,
                    modtype = 23,
                    mod = 13,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Endov2dish",
                    wtype = 5,
                    modtype = 23,
                    mod = 14,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Guppez",
                    wtype = 5,
                    modtype = 23,
                    mod = 15,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Chokadori",
                    wtype = 5,
                    modtype = 23,
                    mod = 16,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Chicane",
                    wtype = 5,
                    modtype = 23,
                    mod = 17,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Saisoku",
                    wtype = 5,
                    modtype = 23,
                    mod = 18,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Dishedeight",
                    wtype = 5,
                    modtype = 23,
                    mod = 19,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Fujiwara",
                    wtype = 5,
                    modtype = 23,
                    mod = 20,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Zokusha",
                    wtype = 5,
                    modtype = 23,
                    mod = 21,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Battlevill",
                    wtype = 5,
                    modtype = 23,
                    mod = 22,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Rallymaster",
                    wtype = 5,
                    modtype = 23,
                    mod = 23,
                    costs = 110,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                }
            }
        },
        highend = {
            title = "High End Räder",
            name = "highend",
            buttons = {
                {
                    name = "Stock",
                    wtype = 7,
                    modtype = 23,
                    mod = -1,
                    costs = 50,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Shadow",
                    wtype = 7,
                    modtype = 23,
                    mod = false,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Hyper",
                    wtype = 7,
                    modtype = 23,
                    mod = 1,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Blade",
                    wtype = 7,
                    modtype = 23,
                    mod = 2,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Diamond",
                    wtype = 7,
                    modtype = 23,
                    mod = 3,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Supagee",
                    wtype = 7,
                    modtype = 23,
                    mod = 4,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Chromaticz",
                    wtype = 7,
                    modtype = 23,
                    mod = 5,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Merciechlip",
                    wtype = 7,
                    modtype = 23,
                    mod = 6,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Obeyrs",
                    wtype = 7,
                    modtype = 23,
                    mod = 7,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Gtchrome",
                    wtype = 7,
                    modtype = 23,
                    mod = 8,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Cheetahr",
                    wtype = 7,
                    modtype = 23,
                    mod = 9,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Solar",
                    wtype = 7,
                    modtype = 23,
                    mod = 10,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Splitten",
                    wtype = 7,
                    modtype = 23,
                    mod = 11,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Dashvip",
                    wtype = 7,
                    modtype = 23,
                    mod = 12,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Lozspeedten",
                    wtype = 7,
                    modtype = 23,
                    mod = 13,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Carboninferno",
                    wtype = 7,
                    modtype = 23,
                    mod = 14,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Carbonshadow",
                    wtype = 7,
                    modtype = 23,
                    mod = 15,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Carbonz",
                    wtype = 7,
                    modtype = 23,
                    mod = 16,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Carbonsolar",
                    wtype = 7,
                    modtype = 23,
                    mod = 17,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Carboncheetahr",
                    wtype = 7,
                    modtype = 23,
                    mod = 18,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                },
                {
                    name = "Carbonsracer",
                    wtype = 7,
                    modtype = 23,
                    mod = 19,
                    costs = 130,
                    description = "",
                    centre = 0,
                    font = 0,
                    scale = 0.4
                }
            }
        }
    },
    lowrider = {
        title = "Low Räder",
        name = "lowrider",
        buttons = {
            {
                name = "Stock",
                wtype = 2,
                modtype = 23,
                mod = -1,
                costs = 30,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Flare",
                wtype = 2,
                modtype = 23,
                mod = false,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Wired",
                wtype = 2,
                modtype = 23,
                mod = 1,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Triplegolds",
                wtype = 2,
                modtype = 23,
                mod = 2,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Bigworm",
                wtype = 2,
                modtype = 23,
                mod = 3,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Sevenfives",
                wtype = 2,
                modtype = 23,
                mod = 4,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Splitsix",
                wtype = 2,
                modtype = 23,
                mod = 5,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Freshmesh",
                wtype = 2,
                modtype = 23,
                mod = 6,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Leadsled",
                wtype = 2,
                modtype = 23,
                mod = 7,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Turbine",
                wtype = 2,
                modtype = 23,
                mod = 8,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Superfin",
                wtype = 2,
                modtype = 23,
                mod = 9,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Classicrod",
                wtype = 2,
                modtype = 23,
                mod = 10,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Dollar",
                wtype = 2,
                modtype = 23,
                mod = 11,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Dukes",
                wtype = 2,
                modtype = 23,
                mod = 12,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Lowfive",
                wtype = 2,
                modtype = 23,
                mod = 13,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Gooch",
                wtype = 2,
                modtype = 23,
                mod = 14,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        }
    },
    muscle = {
        title = "Muscle Räder",
        name = "muscle",
        buttons = {
            {
                name = "Stock",
                wtype = 1,
                modtype = 23,
                mod = -1,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Classicfive",
                wtype = 1,
                modtype = 23,
                mod = false,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Dukes",
                wtype = 1,
                modtype = 23,
                mod = 1,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Musclefreak",
                wtype = 1,
                modtype = 23,
                mod = 2,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Kracka",
                wtype = 1,
                modtype = 23,
                mod = 3,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Azrea",
                wtype = 1,
                modtype = 23,
                mod = 4,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Mecha",
                wtype = 1,
                modtype = 23,
                mod = 5,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Blacktop",
                wtype = 1,
                modtype = 23,
                mod = 6,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Dragspl",
                wtype = 1,
                modtype = 23,
                mod = 7,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Revolver",
                wtype = 1,
                modtype = 23,
                mod = 8,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Classicrod",
                wtype = 1,
                modtype = 23,
                mod = 9,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Spooner",
                wtype = 1,
                modtype = 23,
                mod = 10,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Fivestar",
                wtype = 1,
                modtype = 23,
                mod = 11,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Oldschool",
                wtype = 1,
                modtype = 23,
                mod = 12,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Eljefe",
                wtype = 1,
                modtype = 23,
                mod = 13,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Dodman",
                wtype = 1,
                modtype = 23,
                mod = 14,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Sixgun",
                wtype = 1,
                modtype = 23,
                mod = 15,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Mercenary",
                wtype = 1,
                modtype = 23,
                mod = 16,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        }
    },
    frontwheel = {
        title = "Vorder Rad",
        name = "frontwheel",
        buttons = {
            {
                name = "Stock",
                wtype = 6,
                modtype = 23,
                mod = -1,
                costs = 15,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Speedway",
                wtype = 6,
                modtype = 23,
                mod = false,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Streetspecial",
                wtype = 6,
                modtype = 23,
                mod = 1,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Racer",
                wtype = 6,
                modtype = 23,
                mod = 2,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Trackstar",
                wtype = 6,
                modtype = 23,
                mod = 3,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Overlord",
                wtype = 6,
                modtype = 23,
                mod = 4,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Trident",
                wtype = 6,
                modtype = 23,
                mod = 5,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Triplethreat",
                wtype = 6,
                modtype = 23,
                mod = 6,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Stilleto",
                wtype = 6,
                modtype = 23,
                mod = 7,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Wires",
                wtype = 6,
                modtype = 23,
                mod = 8,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Bobber",
                wtype = 6,
                modtype = 23,
                mod = 9,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Solidus",
                wtype = 6,
                modtype = 23,
                mod = 10,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Iceshield",
                wtype = 6,
                modtype = 23,
                mod = 11,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Loops",
                wtype = 6,
                modtype = 23,
                mod = 12,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        }
    },
    backwheel = {
        title = "Hinter Rad",
        name = "backwheel",
        buttons = {
            {
                name = "Stock",
                wtype = 6,
                modtype = 24,
                mod = -1,
                costs = 15,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Speedway",
                wtype = 6,
                modtype = 24,
                mod = false,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Streetspecial",
                wtype = 6,
                modtype = 24,
                mod = 1,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Racer",
                wtype = 6,
                modtype = 24,
                mod = 2,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Trackstar",
                wtype = 6,
                modtype = 24,
                mod = 3,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Overlord",
                wtype = 6,
                modtype = 24,
                mod = 4,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Trident",
                wtype = 6,
                modtype = 24,
                mod = 5,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Triplethreat",
                wtype = 6,
                modtype = 24,
                mod = 6,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Stilleto",
                wtype = 6,
                modtype = 24,
                mod = 7,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Wires",
                wtype = 6,
                modtype = 24,
                mod = 8,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Bobber",
                wtype = 6,
                modtype = 24,
                mod = 9,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Solidus",
                wtype = 6,
                modtype = 24,
                mod = 10,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Iceshield",
                wtype = 6,
                modtype = 24,
                mod = 11,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Loops",
                wtype = 6,
                modtype = 24,
                mod = 12,
                costs = 40,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        }
    },
    headlights = {
        title = "Scheinwerfer",
        name = "headlights",
        buttons = {
            {
                name = "Stock Lights",
                mod = false,
                modtype = 22,
                costs = 20,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Xenon Lights",
                mod = true,
                modtype = 22,
                costs = 50,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        }
    },
    brakes = {
        title = "Bremsen",
        name = "brakes",
        buttons = {
            {
                name = "Stock Brakes",
                modtype = 12,
                mod = -1,
                costs = 30,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Street Brakes",
                modtype = 12,
                mod = false,
                costs = 110,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Sport Brakes",
                modtype = 12,
                mod = 1,
                costs = 150,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Race Brakes",
                modtype = 12,
                mod = 2,
                costs = 190,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        }
    },
    engine = {
        title = "Motor",
        name = "engine",
        buttons = {
            {
                name = "EMS Upgrade, Level 1",
                modtype = 11,
                mod = -1,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "EMS Upgrade, Level 2",
                modtype = 11,
                mod = false,
                costs = 210,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "EMS Upgrade, Level 3",
                modtype = 11,
                mod = 1,
                costs = 540,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "EMS Upgrade, Level 4",
                modtype = 11,
                mod = 2,
                costs = 1350,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        }
    },
    horn = {
        title = "Hupen",
        name = "horn",
        buttons = {
            {
                name = "Stock Horn",
                modtype = 14,
                mod = -1,
                costs = 15,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Truck Horn",
                modtype = 14,
                mod = false,
                costs = 50,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Police Horn",
                modtype = 14,
                mod = 1,
                costs = 120,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Clown Horn",
                modtype = 14,
                mod = 2,
                costs = 60,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Musical Horn 1",
                modtype = 14,
                mod = 3,
                costs = 65,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Musical Horn 2",
                modtype = 14,
                mod = 4,
                costs = 65,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Musical Horn 3",
                modtype = 14,
                mod = 5,
                costs = 65,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Musical Horn 4",
                modtype = 14,
                mod = 6,
                costs = 65,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Musical Horn 5",
                modtype = 14,
                mod = 7,
                costs = 65,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Sadtrombone Horn",
                modtype = 14,
                mod = 8,
                costs = 70,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Calssical Horn 1",
                modtype = 14,
                mod = 9,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Calssical Horn 2",
                modtype = 14,
                mod = 10,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Calssical Horn 3",
                modtype = 14,
                mod = 11,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Calssical Horn 4",
                modtype = 14,
                mod = 12,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Calssical Horn 5",
                modtype = 14,
                mod = 13,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Calssical Horn 6",
                modtype = 14,
                mod = 14,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Calssical Horn 7",
                modtype = 14,
                mod = 15,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Scaledo Horn",
                modtype = 14,
                mod = 16,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Scalere Horn",
                modtype = 14,
                mod = 17,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Scalemi Horn",
                modtype = 14,
                mod = 18,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Scalefa Horn",
                modtype = 14,
                mod = 19,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Scalesol Horn",
                modtype = 14,
                mod = 20,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Scalela Horn",
                modtype = 14,
                mod = 21,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Scaleti Horn",
                modtype = 14,
                mod = 22,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Scaledo Horn High",
                modtype = 14,
                mod = 23,
                costs = 75,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Jazz Horn 1",
                modtype = 14,
                mod = 25,
                costs = 80,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Jazz Horn 2",
                modtype = 14,
                mod = 26,
                costs = 80,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Jazz Horn 3",
                modtype = 14,
                mod = 27,
                costs = 80,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Jazzloop Horn",
                modtype = 14,
                mod = 28,
                costs = 80,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Starspangban Horn 1",
                modtype = 14,
                mod = 29,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Starspangban Horn 2",
                modtype = 14,
                mod = 30,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Starspangban Horn 3",
                modtype = 14,
                mod = 31,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Starspangban Horn 4",
                modtype = 14,
                mod = 32,
                costs = 90,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Classicalloop Horn 1",
                modtype = 14,
                mod = 33,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Classical Horn 8",
                modtype = 14,
                mod = 34,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            },
            {
                name = "Classicalloop Horn 2",
                modtype = 14,
                mod = 35,
                costs = 100,
                description = "",
                centre = 0,
                font = 0,
                scale = 0.4
            }
        }
    }
}
