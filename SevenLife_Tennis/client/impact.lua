local CourtCenter = vector3(-773.0, 153.465, 66.52)
local CourtHeading = 0
local Width = 7.98
local Length = 11.89

function GetPointData(courtCenter, courtHeading, courtWidth, courtLength, point)
    local nOrigin =
        vector3(
        courtCenter.x + math.cos(math.rad(courtHeading + 90.0)) * courtLength,
        courtCenter.y + math.sin(math.rad(courtHeading + 90.0)) * courtLength,
        courtCenter.z
    )

    local nExtent =
        vector3(
        courtCenter.x + math.cos(math.rad(courtHeading - 90.0)) * courtLength,
        courtCenter.y + math.sin(math.rad(courtHeading - 90.0)) * courtLength,
        courtCenter.z
    )

    local aLeftSide =
        vector3(
        courtCenter.x + math.cos(math.rad(courtHeading)) * courtWidth / 2,
        courtCenter.y + math.sin(math.rad(courtHeading)) * courtWidth / 2,
        courtCenter.z
    )

    local aRightSide =
        vector3(
        courtCenter.x + math.cos(math.rad(courtHeading + 180.0)) * courtWidth / 2,
        courtCenter.y + math.sin(math.rad(courtHeading + 180.0)) * courtWidth / 2,
        courtCenter.z
    )

    local isInArea = IsPointInAngledArea(point, nOrigin, nExtent, courtWidth, true, false)

    local isLeftSide =
        ((nOrigin.x - nExtent.x) * (point.y - nExtent.y) - (nOrigin.y - nExtent.y) * (point.x - nExtent.x)) > 0
    local isASide =
        ((aLeftSide.x - aRightSide.x) * (point.y - aRightSide.y) -
        (aLeftSide.y - aRightSide.y) * (point.x - aRightSide.x)) >
        0

    return {
        isInArea = isInArea,
        isLeftSide = isLeftSide,
        isRightSide = not isLeftSide,
        isASide = isASide,
        isBSide = not isASide
    }
end

function DrawCourtDebug(origin, extent, width, leftSide, rightSide)
    local fieldVector = origin - extent
    local heading = GetHeadingFromVector_2d(fieldVector.x, fieldVector.y)

    local point1 =
        vector3(
        extent.x + math.cos(math.rad(heading + 180.0)) * width / 2,
        extent.y + math.sin(math.rad(heading + 180.0)) * width / 2,
        extent.z
    )

    local point2 =
        vector3(
        origin.x + math.cos(math.rad(heading + 180.0)) * width / 2,
        origin.y + math.sin(math.rad(heading + 180.0)) * width / 2,
        origin.z
    )

    local point3 =
        vector3(
        origin.x + math.cos(math.rad(heading + 0.0)) * width / 2,
        origin.y + math.sin(math.rad(heading + 0.0)) * width / 2,
        origin.z
    )

    local point4 =
        vector3(
        extent.x + math.cos(math.rad(heading + 0.0)) * width / 2,
        extent.y + math.sin(math.rad(heading + 0.0)) * width / 2,
        extent.z
    )

    DrawPoly(point2, point1, point4, 255, 0, 0, 100)
    DrawPoly(point4, point3, point2, 255, 0, 0, 100)

    local vectors = vector3(0.1, 0.1, 1.1)
    DrawBox(point1 - vectors, point1 + vectors, 255, 0, 0, 200)
    DrawBox(point2 - vectors, point2 + vectors, 255, 0, 0, 200)
    DrawBox(point3 - vectors, point3 + vectors, 255, 0, 0, 200)
    DrawBox(point4 - vectors, point4 + vectors, 255, 0, 0, 200)

    DrawBox(leftSide - vectors, leftSide + vectors, 0, 255, 0, 150)
    DrawBox(rightSide - vectors, rightSide + vectors, 0, 255, 0, 150)
end
