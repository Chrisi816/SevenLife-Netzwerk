Config = {
    Gravity = {
        CONST_HIT_NORMAL = vector3(0.0, 0.0, -10.0),
        CONST_HIT_BACKSPIN = vector3(0.0, 0.0, -12.0),
        CONST_HIT_TOPSPIN = vector3(0.0, 0.0, -8.0)
    },
    Drag = 0.25,
    RollingResistance = 0.5,
    GroundBounceEnergyLoss = 0.7,
    BallRadius = 0.05,
    StopHorizontalBounceTreshold = 1.0,
    BallElasticity = 1.2
}

Blips = {
    vector3(-773.0, 153.465, 66.52),
    vector3(-2916.41, 29.48, 10.62),
    vector3(-2900.401, 24.87408, 10.62),
    vector3(-2884.37, 20.2657, 10.62),
    vector3(-2868.337, 15.64847, 10.65),
    vector3(-1371.99, -101.718, 49.71),
    vector3(-1346.18, -98.78546, 49.71),
    vector3(-1309.6, -98.73545, 46.87),
    vector3(-1294.423, -140.2078, 44.77),
    vector3(-1273.467, -113.849, 44.77)
}

TennisCourts = {
    desanta = {
        z = 66.5,
        ballPos = nil,
        ballVelocity = nil,
        spin = CONST_HIT_NORMAL,
        predictedCollisionCoords = nil,
        collisionSuspendedUntil = 0,
        isCollisionActive = false,
        courtCenter = vector3(-773.0, 153.465, 66.52),
        courtHeading = 0.0,
        courtWidth = 7.98,
        courtLength = 11.89
    },
    pbluff_1_green = {
        z = 10.64,
        ballPos = nil,
        ballVelocity = nil,
        spin = CONST_HIT_NORMAL,
        predictedCollisionCoords = nil,
        collisionSuspendedUntil = 0,
        isCollisionActive = false,
        courtCenter = vector3(-2916.41, 29.48, 10.62),
        courtHeading = -16.05,
        courtWidth = 7.98,
        courtLength = 11.89
    },
    pbluff_2_blue = {
        z = 10.64,
        ballPos = nil,
        ballVelocity = nil,
        spin = CONST_HIT_NORMAL,
        predictedCollisionCoords = nil,
        collisionSuspendedUntil = 0,
        isCollisionActive = false,
        courtCenter = vector3(-2900.401, 24.87408, 10.62),
        courtHeading = -16.05,
        courtWidth = 7.98,
        courtLength = 11.89
    },
    pbluff_3_blue = {
        z = 10.64,
        ballPos = nil,
        ballVelocity = nil,
        spin = CONST_HIT_NORMAL,
        predictedCollisionCoords = nil,
        collisionSuspendedUntil = 0,
        isCollisionActive = false,
        courtCenter = vector3(-2884.37, 20.2657, 10.62),
        courtHeading = -16.05,
        courtWidth = 7.98,
        courtLength = 11.89
    },
    pbluff_4_red = {
        z = 10.64,
        ballPos = nil,
        ballVelocity = nil,
        spin = CONST_HIT_NORMAL,
        predictedCollisionCoords = nil,
        collisionSuspendedUntil = 0,
        isCollisionActive = false,
        courtCenter = vector3(-2868.337, 15.64847, 10.65),
        courtHeading = -16.05,
        courtWidth = 7.98,
        courtLength = 11.89
    },
    rockf_b_1 = {
        z = 49.71,
        ballPos = nil,
        ballVelocity = nil,
        spin = CONST_HIT_NORMAL,
        predictedCollisionCoords = nil,
        collisionSuspendedUntil = 0,
        isCollisionActive = false,
        courtCenter = vector3(-1371.99, -101.718, 49.71),
        courtHeading = 6.4529713058844,
        courtWidth = 7.98,
        courtLength = 11.89
    },
    rockf_b_2 = {
        z = 49.71,
        ballPos = nil,
        ballVelocity = nil,
        spin = CONST_HIT_NORMAL,
        predictedCollisionCoords = nil,
        collisionSuspendedUntil = 0,
        isCollisionActive = false,
        courtCenter = vector3(-1346.18, -98.78546, 49.71),
        courtHeading = 6.4529713058844,
        courtWidth = 7.98,
        courtLength = 11.89
    },
    rockf_b_3 = {
        z = 46.87,
        ballPos = nil,
        ballVelocity = nil,
        spin = CONST_HIT_NORMAL,
        predictedCollisionCoords = nil,
        collisionSuspendedUntil = 0,
        isCollisionActive = false,
        courtCenter = vector3(-1309.6, -98.73545, 46.87),
        courtHeading = 3.0,
        courtWidth = 8.83,
        courtLength = 12.64
    },
    rockf_b_4 = {
        z = 44.77,
        ballPos = nil,
        ballVelocity = nil,
        spin = CONST_HIT_NORMAL,
        predictedCollisionCoords = nil,
        collisionSuspendedUntil = 0,
        isCollisionActive = false,
        courtCenter = vector3(-1294.423, -140.2078, 44.77),
        courtHeading = -38.544858914241,
        courtWidth = 8.83,
        courtLength = 12.64
    },
    rockf_b_5 = {
        z = 44.77,
        ballPos = nil,
        ballVelocity = nil,
        spin = CONST_HIT_NORMAL,
        predictedCollisionCoords = nil,
        collisionSuspendedUntil = 0,
        isCollisionActive = false,
        courtCenter = vector3(-1273.467, -113.849, 44.77),
        courtHeading = -38.544858914241,
        courtWidth = 8.83,
        courtLength = 12.64
    }
}
