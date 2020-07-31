local AIRCRAFT_COUNTERMEASURE_OFFSET = {
    ["pyro"] = {0.2, 0.8, 0.0, 1.0},
    ["rogue"] = {0.2, 0.8, 0.0, 1.0},
    ["seabreeze"] = {0.2, 0.8, 0.0, 1.0},
    ["tula"] = {0.2, 0.8, 0.0, 1.0},
    ["mogul"] = {0.2, 0.8, 0.0, 1.0},
    ["starling"] = {0.2, 0.8, 0.0, 1.0},
    ["nokota"] = {0.2, 0.8, 0.0, 1.0},
    ["molotok"] = {0.2, 0.8, 0.0, 1.0},
    ["alphaz1"] = {0.2, 0.8, 0.0, 1.0},
    ["microlight"] = {0.2, 0.8, 0.0, 1.0},
    ["howard"] = {0.2, 0.8, 0.0, 1.0},
    ["bombushka"] = {0.2, 0.8, 0.0, 1.0},
    ["oppressor2"] = {0.2, 0.8, 0.0, 1.0},
    ["strikeforce"] = {0.2, 0.8, 0.0, 1.0},
    ["hunter"] = {0.4, 0.6, 0.35, 0.65},
    ["havok"] = {0.4, 0.6, 0.35, 0.65},
    ["akula"] = {0.4, 0.6, 0.35, 0.65},
    ["thruster"] = {0.4, 0.6, 0.35, 0.65},
    ["avenger"] = {0.4, 0.6, 0.3, 0.7},
    ["volatol"] = {0.4, 0.6, 0.3, 0.7},
}

local AIRCRAFT_COUNTERMEASURE_OFFSET_2 = {
    ["pyro"] = {1.0, 1.0, 1.4, 1.4},
    ["mogul"] = {1.0, 1.0, 1.4, 1.4},
    ["starling"] = {1.0, 1.0, 1.4, 1.4},
    ["nokota"] = {1.0, 1.0, 1.4, 1.4},
    ["molotok"] = {1.0, 1.0, 1.4, 1.4},
    ["howard"] = {1.0, 1.0, 1.4, 1.4},
    ["thruster"] = {1.0, 1.0, 1.4, 1.4},
    ["rogue"] = {1.5, 1.5, 1.8, 1.8},
    ["seabreeze"] = {1.0, 1.0, 1.0, 1.0},
    ["tula"] = {2.4, 2.4, 2.6, 2.6},
    ["alphaz1"] = {0.0, 0.0, 0.2, 0.2},
    ["havok"] = {0.0, 0.0, 0.2, 0.2},
    ["microlight"] = {2.0, 2.0, 2.0, 2.0},
    ["hunter"] = {2.0, 2.0, 2.0, 2.0},
    ["akula"] = {2.0, 2.0, 2.0, 2.0},
    ["bombushka"] = {3.0, 3.0, 3.0, 3.0},
    ["volatol"] = {3.0, 3.0, 3.0, 3.0},
    ["avenger"] = {4.5, 4.5, 4.5, 4.5},
}

local AIRCRAFT_COUNTERMEASURE_ROTATION_OFFSET = {
    ["pyro"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["rogue"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["seabreeze"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["tula"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["mogul"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["starling"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["nokota"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["molotok"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["alphaz1"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["microlight"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["howard"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["bombushka"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["hunter"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["havok"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["avenger"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["akula"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["thruster"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
    ["volatol"] = {vector3(-90.0, -10.0, 0.0), vector3(-90.0, 10.0, 0.0), vector3(-180.0, 45.0, 0.0), vector3(-180.0, -45.0, 0.0)},
}

local AIRCRAFT_COUNTERMEASURE_SCALE = {
    ["pyro"] = {10.0, 10.0, 10.0, 10.0},
    ["rogue"] = {10.0, 10.0, 10.0, 10.0},
    ["seabreeze"] = {10.0, 10.0, 10.0, 10.0},
    ["tula"] = {10.0, 10.0, 10.0, 10.0},
    ["mogul"] = {10.0, 10.0, 10.0, 10.0},
    ["starling"] = {10.0, 10.0, 10.0, 10.0},
    ["nokota"] = {10.0, 10.0, 10.0, 10.0},
    ["molotok"] = {10.0, 10.0, 10.0, 10.0},
    ["alphaz1"] = {10.0, 10.0, 10.0, 10.0},
    ["microlight"] = {10.0, 10.0, 10.0, 10.0},
    ["howard"] = {10.0, 10.0, 10.0, 10.0},
    ["hunter"] = {10.0, 10.0, 10.0, 10.0},
    ["akula"] = {10.0, 10.0, 10.0, 10.0},
    ["oppressor2"] = {10.0, 10.0, 10.0, 10.0},
    ["strikeforce"] = {10.0, 10.0, 10.0, 10.0},
    ["bombushka"] = {5.0, 5.0, 5.0, 5.0},
    ["havok"] = {7.5, 7.5, 7.5, 7.5},
    ["avenger"] = {5.0, 5.0, 5.0, 5.0},
    ["volatol"] = {5.0, 5.0, 5.0, 5.0},
    ["thruster"] = {4.0, 4.0, 4.0, 4.0},
}

function GetAircraftQuad(entity, model)
    local out2, out3, out4, out5
    local vec0, vec2, vec3, vec4, vec5
    local var1
    vec0, var1 = GetModelDimensions(model)
    vec2 = vector3(vec0.x, var1.y, vec0.z)
    vec3 = vector3(var1.x, var1.y, vec0.z)
    vec4 = vector3(vec0.x, vec0.y, vec0.z)
    vec5 = vector3(var1.x, vec0.y, vec0.z)

    out2 = GetOffsetFromEntityInWorldCoords(entity, vec2)
    out3 = GetOffsetFromEntityInWorldCoords(entity, vec3)
    out4 = GetOffsetFromEntityInWorldCoords(entity, vec4)
    out5 = GetOffsetFromEntityInWorldCoords(entity, vec5)
    return out2, out3, out4, out5
end

function DropCountermeasure(vehicle)
    if GetAircraftCountermeasureCount(vehicle) <= 0 then
        PlaySoundFrontend(-1, "chaff_empty", "DLC_SM_Countermeasures_Sounds", true)
        return false, "No countermeasures left"
    end
    local rotation = GetEntityRotation(vehicle, 2)
    local vec1, vec2, vec3, vec4 = GetAircraftQuad(vehicle, GetEntityModel(vehicle))
    SprayCountermeasuresAround(vehicle, 0, vec1, vec2, vec3, vec4, rotation)
    SprayCountermeasuresAround(vehicle, 1, vec1, vec2, vec3, vec4, rotation)
    SprayCountermeasuresAround(vehicle, 2, vec1, vec2, vec3, vec4, rotation)
    SprayCountermeasuresAround(vehicle, 3, vec1, vec2, vec3, vec4, rotation)
    PlaySoundFromEntity(-1, "chaff_released", vehicle, "DLC_SM_Countermeasures_Sounds", 1, 0)
    if NetworkHasControlOfEntity(vehicle) then
        --SetVehicleCanBeLockedOn(vehicle, 0, 1)
    end
    if NetworkHasControlOfEntity(vehicle) then
        SetAircraftCountermeasureCount(vehicle, GetAircraftCountermeasureCount(vehicle) - 1)
    end
    ShowHelpText("CHAFF_FIRE", -1)
    return true, "Dropped countermeasures"
end

RegisterCommand("countermeasure", function()
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    OpenBombBayDoors(veh)
    SetAircraftCountermeasureCount(veh, 5)
    local _, state = DropCountermeasure(veh)
    print("" .. state)
end)

function GetAircraftCountermeasureOffset(vehicle, countermeasureType)
    local model = GetEntityModel(vehicle)
    for aircraftModel, offsetData in next, AIRCRAFT_COUNTERMEASURE_OFFSET do
        if GetHashKey(aircraftModel) == model then
            return offsetData[countermeasureType + 1]
        end
    end
    return 0.0
end

function GetAircraftCountermeasureScale(vehicle, countermeasureType)
    local model = GetEntityModel(vehicle)
    for aircraftModel, offsetData in next, AIRCRAFT_COUNTERMEASURE_SCALE do
        if GetHashKey(aircraftModel) == model then
            return offsetData[countermeasureType + 1]
        end
    end
    return 0.0
end

function GetAircraftCountermeasureRotationOffset(vehicle, countermeasureType)
    local model = GetEntityModel(vehicle)
    for aircraftModel, offsetData in next, AIRCRAFT_COUNTERMEASURE_ROTATION_OFFSET do
        if GetHashKey(aircraftModel) == model then
            return offsetData[countermeasureType + 1]
        end
    end
    return vector3(0.0, 0.0, 0.0)
end

function GetAircraftCountermeasureOffset_2(vehicle, countermeasureType)
    local model = GetEntityModel(vehicle)
    for aircraftModel, offsetData in next, AIRCRAFT_COUNTERMEASURE_OFFSET_2 do
        if GetHashKey(aircraftModel) == model then
            return offsetData[countermeasureType + 1]
        end
    end
    return 0.0
end

function CalculateMagicNumberSet(vParam0, vParam1, fParam2, fParam3, fParam4)
    return vector3(
        CalculateMagicNumbers(vParam0.x, vParam1.x, fParam2, fParam3, fParam4),
        CalculateMagicNumbers(vParam0.y, vParam1.y, fParam2, fParam3, fParam4),
        CalculateMagicNumbers(vParam0.z, vParam1.z, fParam2, fParam3, fParam4)
    )
end

function CalculateMagicNumbers(fParam0, fParam1, fParam2, fParam3, fParam4)
    return ((((fParam1 - fParam0) / (fParam3 - fParam2)) * (fParam4 - fParam2)) + fParam0)
end

function SprayCountermeasuresAround(vehicle, countermeasureType, pos1, pos2, pos3, pos4, rotation)
    local vec0 = CalculateMagicNumberSet(pos1, pos2, 0.0, 1.0, GetAircraftCountermeasureOffset(vehicle, countermeasureType))
    local vec1 = CalculateMagicNumberSet(pos3, pos4, 0.0, 1.0, GetAircraftCountermeasureOffset(vehicle, countermeasureType))
    local vec2 = CalculateMagicNumberSet(vec0, vec1, 0.0, 1.0, GetAircraftCountermeasureOffset(vehicle, countermeasureType))
    vec2 = vector3(vec2.x, vec2.y, vec2.z + GetAircraftCountermeasureOffset_2(vehicle, countermeasureType))
    UseParticleFxAssetNextCall("scr_sm_counter")
    StartParticleFxNonLoopedAtCoord_2("scr_sm_counter_chaff", vec2, vector3(rotation.z, 0.0, rotation.x) + GetAircraftCountermeasureRotationOffset(vehicle, countermeasureType), GetAircraftCountermeasureScale(vehicle, countermeasureType), 0, 0, 0)
end

Citizen.CreateThread(function()
    while not HasNamedPtfxAssetLoaded("scr_sm_counter") do
        RequestNamedPtfxAsset("scr_sm_counter")
        Wait(100)
    end
    print("Countermeasure loaded")
end)
