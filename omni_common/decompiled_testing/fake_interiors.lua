--[[
    FAKE INTERIORS
    Based on decompiled scripts
    Written by glitchdetector
]]

local LOCAL_ENTITY = 0
local PREVIOUS_ITERATED_INTERIOR = -1
local CURRENT_ITERATED_INTERIOR = 0
local POSITION_ZERO = vector3(0.0, 0.0, 0.0)
local INTERIOR_POSITION = {
    [0] = vector3(1240.0, -2970.0, 12.2),
    [1] = vector3(40.0, -2720.0, 12.0),
    [2] = vector3(-2250.0, 300.0, 182.2),
    [3] = vector3(1700.0, 2580.0, 80.0),
    [4] = vector3(-2250.0, 3100.0, 80.0),
}
local INTERIOR_NAME = {
    [0] = "V_FakeBoatPO1SH2A",
    [1] = "V_FakeWarehousePO103",
    [2] = "V_FakeKortzCenter",
    [3] = "V_FakePrison",
    [4] = "V_FakeMilitaryBase",
}
local INTERIOR_RANGE = {
    [0] = 10000,
    [1] = 10000,
    [2] = 250000,
    [3] = 9000000,
    [4] = 22500000,
}
local INTERIOR_ROOM_COUNT = {
    [0] = 1,
    [1] = 4,
    [2] = 11,
    [3] = 1,
    [4] = 1,
}
local INTERIOR_ALWAYS_VISIBLE = {
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
}
local INTERIOR_ROOM_ANGLE = {
    [0] = {
        [0] = 28.125,
    },
    [1] = {
        [0] = 32.6875,
        [1] = 13.1875,
        [2] = 16.25,
        [3] = 21.75,
    },
    [2] = {
        [0] = 95.0,
        [1] = 78.75,
        [2] = 70.6875,
        [3] = 64.4375,
        [4] = 32.375,
        [5] = 19.0,
        [6] = 19.0,
        [7] = 19.78125,
        [8] = 32.0625,
        [9] = 35.8125,
        [10] = 30.5,
    },
    [3] = {
        [0] = 3000.0,
    },
    [4] = {
        [0] = 0.0,
    },
}
local INTERIOR_ROOM_POSITION = {
    [0] = {
        [0] = vector3(1240.537, -3057.289, 40.75164),
    },
    [1] = {
        [0] = vector3(34.27837, -2654.244, 20.9423),
        [1] = vector3(13.93163, -2654.561, 14.44239),
        [2] = vector3(55.59572, -2667.499, 10.82245),
        [3] = vector3(34.5866, -2746.387, 10.95006),
    },
    [2] = {
        [0] = vector3(-2169.17, 256.7264, 203.4081),
        [1] = vector3(-2216.394, 329.4761, 201.3617),
        [2] = vector3(-2345.353, 350.7880, 189.6522),
        [3] = vector3(-2288.097, 388.9909, 200.9045),
        [4] = vector3(-2310.263, 406.638, 200.9041),
        [5] = vector3(-2169.221, 260.5679, 202.4294),
        [6] = vector3(-2258.778, 166.9506, 202.8318),
        [7] = vector3(-2236.973, 285.5958, 203.0395),
        [8] = vector3(-2211.362, 303.6741, 214.9323),
        [9] = vector3(-2282.098, 383.0904, 201.0395),
        [10] = vector3(-2277.93, 356.4442, 201.1015),
    },
    [3] = {
        [0] = vector3(200.0, 2600.0, -5.0),
    },
    [4] = {
        [0] = vector3(5051.205, -5689.44, -37.62654),
    },
}
local INTERIOR_ROOM_POSITION2 = {
    [0] = {
        [0] = vector3(1240.535, -2880.354, -19.96489),
    },
    [1] = {
        [0] = vector3(34.15308, -2747.067, 1.137565),
        [1] = vector3(13.95777, -2700.626, 5.046232),
        [2] = vector3(55.61185, -2687.681, 5.005801),
        [3] = vector3(34.56926, -2759.479, -0.030933),
    },
    [2] = {
        [0] = vector3(-2317.38, 191.6319, 165.4037),
        [1] = vector3(-2357.995, 264.0297, 162.7988),
        [2] = vector3(-2261.433, 387.3963, 154.3522),
        [3] = vector3(-2326.399, 408.3378, 140.3182),
        [4] = vector3(-2304.617, 460.2127, 140.2147),
        [5] = vector3(-2150.825, 216.4168, 162.8012),
        [6] = vector3(-2172.765, 203.5957, 167.4135),
        [7] = vector3(-2191.036, 305.961, 159.625),
        [8] = vector3(-2227.613, 340.0587, 165.1357),
        [9] = vector3(-2244.41, 399.5764, 137.5101),
        [10] = vector3(-2243.261, 371.4072, 137.2722),
    },
    [3] = {
        [0] = vector3(3200.0, 2600.0, 3000.0),
    },
    [4] = {
        [0] = vector3(-5841.107, 5506.837, 1000.474),
    },
}

Citizen.CreateThread(function()
    -- while true do
    --     Wait(0)
    --     LOCAL_ENTITY = PlayerPedId()
    --     FakeInteriorsLoop()
    --     -- for i=0, 3 do
    --     --     SetRadarAsInteriorThisFrame(INTERIOR_NAME[i], INTERIOR_POSITION[i].x, INTERIOR_POSITION[i].y, 0.0, 0)
    --     -- end
    --     -- SetRadarAsExteriorThisFrame()
    -- end
end)

function FakeInteriorsLoop()
    local _pos
    local _fakeInteriorPos
    local _isInFakeInterior
    local _currentRoom
    FakeInteriorsIterateInteriorStep()
    if PREVIOUS_ITERATED_INTERIOR ~= -1 then
        _pos = GetEntityCoords(LOCAL_ENTITY, false)
        _fakeInteriorPos = FakeInteriorsGetFakeInteriorPosition(PREVIOUS_ITERATED_INTERIOR)
        if Vdist2(_fakeInteriorPos, _pos) < FakeInteriorsGetFakeInteriorRange(PREVIOUS_ITERATED_INTERIOR) then
            _isInFakeInterior = false
            _currentRoom = 0
            while _currentRoom < FakeInteriorsGetFakeInteriorRoomCount(PREVIOUS_ITERATED_INTERIOR) do
                if not _isInFakeInterior then
                    if FakeInteriorsInteriorAlwaysVisible(PREVIOUS_ITERATED_INTERIOR) then
                        _isInFakeInterior = true
                    else
                        if IsEntityInAngledArea(LOCAL_ENTITY, FakeInteriorsGetFakeInteriorRoomPosition2(PREVIOUS_ITERATED_INTERIOR, _currentRoom), FakeInteriorsGetFakeInteriorRoomPosition(PREVIOUS_ITERATED_INTERIOR, _currentRoom), FakeInteriorsGetFakeInteriorRoomAngle(PREVIOUS_ITERATED_INTERIOR, _currentRoom), 0, true, 0) then
                            _isInFakeInterior = true
                        end
                    end
                end
                _currentRoom = _currentRoom + 1
            end
            if _isInFakeInterior then
                SetRadarAsInteriorThisFrame(GetHashKey(FakeInteriorsGetFakeInteriorName(PREVIOUS_ITERATED_INTERIOR)), _fakeInteriorPos.x + 0.0, _fakeInteriorPos.y, 0.0, FakeInteriorsGetRadarZoomFromZ(PREVIOUS_ITERATED_INTERIOR))
                FakeInteriorsSetFakePosition(PREVIOUS_ITERATED_INTERIOR)
            end
        end
    end
end

function FakeInteriorsSetFakePosition(interior)
    local _pos
    if interior == 0 then
        SetRadarAsExteriorThisFrame()
    elseif interior == 1 then
    elseif interior == 2 then
        SetRadarAsExteriorThisFrame()
    elseif interior == 3 then
        SetRadarAsExteriorThisFrame()
    elseif interior == 4 then
        SetRadarAsExteriorThisFrame()
    end
end

function FakeInteriorsIterateInteriorStep()
    local _pos
    CURRENT_ITERATED_INTERIOR = CURRENT_ITERATED_INTERIOR + 1
    if CURRENT_ITERATED_INTERIOR > 4 then
        CURRENT_ITERATED_INTERIOR = 0
    end
    if CURRENT_ITERATED_INTERIOR ~= PREVIOUS_ITERATED_INTERIOR then
        if PREVIOUS_ITERATED_INTERIOR == -1 then
            PREVIOUS_ITERATED_INTERIOR = CURRENT_ITERATED_INTERIOR
        else
            if FakeInteriorsInteriorAlwaysVisible(CURRENT_ITERATED_INTERIOR) then
                PREVIOUS_ITERATED_INTERIOR = CURRENT_ITERATED_INTERIOR
            else
                _pos = GetEntityCoords(LOCAL_ENTITY, false)
                if Vdist2(FakeInteriorsGetFakeInteriorPosition(CURRENT_ITERATED_INTERIOR), _pos) < Vdist2(FakeInteriorsGetFakeInteriorPosition(PREVIOUS_ITERATED_INTERIOR), _pos) then
                    PREVIOUS_ITERATED_INTERIOR = CURRENT_ITERATED_INTERIOR
                end
            end
        end
    end
end

function FakeInteriorsGetFakeInteriorPosition(interior)
    if INTERIOR_POSITION[interior] then
        return INTERIOR_POSITION[interior]
    end
    return POSITION_ZERO
end
function FakeInteriorsInteriorAlwaysVisible(interior)
    if INTERIOR_ALWAYS_VISIBLE[interior] then
        return INTERIOR_ALWAYS_VISIBLE[interior]
    end
    return false
end
function FakeInteriorsGetFakeInteriorName(interior)
    if INTERIOR_NAME[interior] then
        return INTERIOR_NAME[interior]
    end
    return ""
end

function FakeInteriorsGetFakeInteriorRange(interior)
    if INTERIOR_RANGE[interior] then
        return INTERIOR_RANGE[interior]
    end
    return 0
end

function FakeInteriorsGetFakeInteriorRoomCount(interior)
    if INTERIOR_ROOM_COUNT[interior] then
        return INTERIOR_ROOM_COUNT[interior]
    end
    return 0
end

function FakeInteriorsGetFakeInteriorRoomAngle(interior, room)
    if INTERIOR_ROOM_ANGLE[interior] then
        if INTERIOR_ROOM_ANGLE[interior][room] then
            return INTERIOR_ROOM_ANGLE[interior][room]
        end
    end
    return 0.0
end
function FakeInteriorsGetFakeInteriorRoomPosition(interior, room)
    if INTERIOR_ROOM_POSITION[interior] then
        if INTERIOR_ROOM_POSITION[interior][room] then
            return INTERIOR_ROOM_POSITION[interior][room]
        end
    end
    return POSITION_ZERO
end
function FakeInteriorsGetFakeInteriorRoomPosition2(interior, room)
    if INTERIOR_ROOM_POSITION2[interior] then
        if INTERIOR_ROOM_POSITION2[interior][room] then
            return INTERIOR_ROOM_POSITION2[interior][room]
        end
    end
    return POSITION_ZERO
end

function FakeInteriorsGetRadarZoomFromZ(interior)
    local _pos
    if interior == 0 then
        return 0
    elseif interior == 1 then
        _pos = GetEntityCoords(LOCAL_ENTITY, false)
        if _pos.z < 9.7796 then
            return 0
        elseif _pos.z > 9.7796 and _pos.z < 16.0 then
            return 1
        else
            return 2
        end
    elseif interior == 2 then
        _pos = GetEntityCoords(LOCAL_ENTITY, false)
        if _pos.z < 178.9 then
            return 0
        elseif _pos.z > 178.9 and _pos.z < 188.7 then
            return 1
        else
            return 2
        end
    elseif interior == 3 then
        return 0
    elseif interior == 4 then
        return 0
    end
    return 0
end
