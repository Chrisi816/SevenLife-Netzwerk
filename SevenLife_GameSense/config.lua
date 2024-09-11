Config = {
    deformationMultiplier = -1, -- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch. Visual damage does not sync well to other players.
    deformationExponent = 0.4, -- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
    collisionDamageExponent = 0.6, -- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
    damageFactorEngine = 10.0, -- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
    damageFactorBody = 10.0, -- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
    damageFactorPetrolTank = 64.0, -- Sane values are 1 to 200. Higher values means more damage to vehicle. A good starting point is 64
    engineDamageExponent = 0.6, -- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
    weaponsDamageMultiplier = 10.0, -- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
    degradingHealthSpeedFactor = 10, -- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
    cascadingFailureSpeedFactor = 8.0, -- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8
    degradingFailureThreshold = 800.0, -- Below this value, slow health degradation will set in
    cascadingFailureThreshold = 360.0, -- Below this value, health cascading failure will set in
    engineSafeGuard = 100.0, -- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.
    torqueMultiplierEnabled = true, -- Decrease engine torque as engine gets more and more damaged
    compatibilityMode = false, -- prevents other scripts from modifying the fuel tank health to avoid random engine failure with BVA 2.01 (Downside is it disabled explosion prevention)
    randomTireBurstInterval = 0
}
Config.masspeed = 100.0
Config.lightspeed = 50
Config.DiscordURL =
    "https://discord.com/api/webhooks/959538682459729981/vNsLCFdbqiSBF6kUutFOZ8dHxmmMFPiLAdOEaw3Xn4viwpUgpqccJbrUHIsfOorL5YMK"

Config.classDamageMultiplier = {
    [0] = 1.0, --	0: Compacts
    1.0, --	1: Sedans
    1.0, --	2: SUVs
    1.0, --	3: Coupes
    1.0, --	4: Muscle
    1.0, --	5: Sports Classics
    1.0, --	6: Sports
    1.0, --	7: Super
    0.25, --	8: Motorcycles
    0.7, --	9: Off-road
    0.25, --	10: Industrial
    1.0, --	11: Utility
    1.0, --	12: Vans
    1.0, --	13: Cycles
    0.5, --	14: Boats
    1.0, --	15: Helicopters
    1.0, --	16: Planes
    1.0, --	17: Service
    0.75, --	18: Emergency
    0.75, --	19: Military
    1.0, --	20: Commercial
    1.0 --	21: Trains
}
Config.Weapons = {
    "WEAPON_PISTOL",
    "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_PISTOL50",
    "WEAPON_SNSPISTOL",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_PISTOL_MK2",
    "WEAPON_SNSPISTOL_MK2",
    "WEAPON_FLAREGUN",
    "WEAPON_STUNGUN",
    "WEAPON_REVOLVER",
    "WEAPON_ASSAULTRIFLE"
}

Config.configweapon = {
    back_bone = 24816,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatable_weapon_hashes = {
        ["w_me_bat"] = -1786099057,
        ["prop_ld_jerrycan_01"] = 883325847,
        ["w_ar_carbinerifle"] = -2084633992,
        ["w_ar_assaultrifle"] = -1074790547,
        ["w_ar_specialcarbine"] = -1063057011,
        ["w_ar_bullpuprifle"] = 2132975508,
        ["w_ar_advancedrifle"] = -1357824103,
        ["w_sb_microsmg"] = 324215364,
        ["w_sb_assaultsmg"] = -270015777,
        ["w_sb_smg"] = 736523883,
        ["w_sb_gusenberg"] = 1627465347,
        ["w_sr_sniperrifle"] = 100416529,
        ["w_sg_assaultshotgun"] = -494615257,
        ["w_sg_bullpupshotgun"] = -1654528753,
        ["w_sg_pumpshotgun"] = 487013001,
        ["w_ar_musket"] = -1466123874,
        ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
        ["w_lr_firework"] = 2138347493
    }
}
