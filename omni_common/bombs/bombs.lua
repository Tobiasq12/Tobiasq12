local AIRCRAFT_OFFSET_VALUES = {
    ["cuban800"] = 0.5,
    ["mogul"] = 0.45,
    ["rogue"] = 0.46,
    ["starling"] = 0.55,
    ["seabreeze"] = 0.5,
    ["tula"] = 0.6,
    ["bombushka"] = 0.43,
    ["hunter"] = 0.5,
    ["avenger"] = 0.36,
    ["akula"] = 0.4,
    ["volatol"] = 0.54,
    ["strikeforce"] = 0.7,
}

function DropBomb(vehicle, play_sounds)
    if not GetAircraftActuallyABomber(vehicle) then
        return false, "Vehicle incompatible with bomb bays"
    end
    if GetVehicleMod(vehicle, 9) < 0 then
        -- Vehicle doesn't have bombs installed
        return false, "No bombs installed"
    end
    if GetAircraftBombCount(vehicle) <= 0 then
        -- Vehicle doesn't have bombs left
        if play_sounds then
            PlaySoundFrontend(-1, "bombs_empty", "DLC_SM_Bomb_Bay_Bombs_Sounds", true)
        end
        return false, "No bombs left"
    end
    local quad0, quad1, quad2, quad3 = GetAircraftQuad(vehicle, GetEntityModel(vehicle))
    local vec4 = CalculateMagicNumberSet(quad0, quad1, 0.0, 1.0, 0.5)
    local vec5 = CalculateMagicNumberSet(quad2, quad3, 0.0, 1.0, 0.5)
    vec4 = vector3(vec4.x, vec4.y, vec4.z + 0.4)
    vec5 = vector3(vec5.x, vec5.y, vec5.z + 0.4)
    local vec6 = CalculateMagicNumberSet(vec4, vec5, 0.0, 1.0, GetAircraftOffsetValue(vehicle))
    vec4 = vector3(vec4.x, vec4.y, vec4.z - 0.2)
    vec5 = vector3(vec5.x, vec5.y, vec5.z - 0.2)
    local vec7 = CalculateMagicNumberSet(vec4, vec5, 0.0, 1.0, GetAircraftOffsetValue(vehicle) - 0.0001)
    local mod = GetVehicleMod(vehicle, 9)
    local bombModel = 0
    if mod == 0 then
        if IsVehicleModel(vehicle, `volatol`) then
            bombModel = 1794615063
        else
            bombModel = -1695500020
        end
    elseif mod == 1 then
        bombModel = 1794615063
    elseif mod == 2 then
        bombModel = 1430300958
    elseif mod == 3 then
        bombModel = 220773539
    end
    print("Bomb type " .. mod .. ": " .. bombModel)
    -- _SHOOT_SINGLE_AIRSTRIKE_BULLET_BETWEEN_COORDS
    Citizen.InvokeNative(0xBFE5756E7407064A, vec6, vec7, 0, 0, bombModel, PlayerPedId(), 1, 1, -1082130432, 0, 0, 0, 0, 1, 1, 0)
    if NetworkHasControlOfEntity(vehicle) then
        SetAircraftBombCount(vehicle, GetAircraftBombCount(vehicle) - 1)
    end
    PlaySoundFrontend(-1, "bomb_deployed", "DLC_SM_Bomb_Bay_Bombs_Sounds", true)
    return true, "Successfully dropped bomb"
end

RegisterCommand("bomb", function()
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    OpenBombBayDoors(veh)
    SetAircraftBombCount(veh, 1)
    local _, state = DropBomb(veh, true)
    print("" .. state)
end)

function GetAircraftOffsetValue(vehicle)
    local model = GetEntityModel(vehicle)
    for planeModel, planeOffset in next, AIRCRAFT_OFFSET_VALUES do
        if GetHashKey(planeModel) == model then
            return planeOffset
        end
    end
    return 0.0
end

function GetAircraftActuallyABomber(vehicle)
    local model = GetEntityModel(vehicle)
    for planeModel, planeOffset in next, AIRCRAFT_OFFSET_VALUES do
        if GetHashKey(planeModel) == model then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    local function req(md)
        RequestModel(md)
        while not HasModelLoaded(md) do
            Wait(100)
        end
        print("Model " .. md .. " loaded")
    end
    req(1794615063)
    req(-1695500020)
    req(1794615063)
    req(1430300958)
    req(220773539)
end)
