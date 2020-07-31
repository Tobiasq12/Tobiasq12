local GotTrain = false

local models = {
    "freight", "freightcar", "freightgrain", "freightcont1", "freightcont2",
    "tankercar",

    "metrotrain", "s_m_m_lsmetro_01" ,

    "6f01",
    -- "6f02", "6f03",
    "6f04", --"6f05",

    -- "df4b1",
    -- "df4b2",

    "e701", "e707",
    "ice301", "ice303",

    "go_tankercar",
    "e401", "e402",

    "lcsubway",
    "metrocab",
    -- "metrocar",
}

local TRAIN_SPAWNS = {
    -- {name = "PTPS Tanker Train", perms = {""}, location = {x = 2617.8984375, y = 1707.5870361328, z = 27.597440719604}, spawner = {train = 3, x = 2611.0749511719, y = 1766.9490966797, z = 26.37712097168} },
    {name = "LS Cargo Train 1", perms = {""}, location = {x = 677.14953613281, y = -895.89562988281, z = 23.462062835693}, spawner = {train = 1, x = 666.98468017578, y = -894.25457763672, z = 22.377431869507} },
    {name = "LS Cargo Train 2", perms = {""}, location = {x = 677.22564697266, y = -886.04205322266, z = 23.462043762207}, spawner = {train = 10, x = 672.77630615234, y = -886.46014404297, z = 22.561025619507} },
    {name = "GS Grain Train", perms = {""}, location = {x = 2873.7795410156, y = 4868.2573242188, z = 62.395622253418}, spawner = {train = 4, x = 2867.0922851563, y = 4893.3720703125, z = 63.378673553467} },
    {name = "MJ Cargo Train", perms = {""}, location = {x = -341.57598876953, y = 3744.947265625, z = 69.970855712891}, spawner = {train = 17, x = -337.26611328125, y = 3756.5151367188, z = 70.42813873291} },

    {name = "TM Passenger Long Boi (Level 10)", perms = {""}, location = {x = 2534.5405273438, y = -183.10217285156, z = 87.172782897949}, spawner = {train = 39, x = 2534.7648925781, y = -184.93153381348, z = 93.409767150879} },
    {name = "LS Passenger Long Boi (Level 10)", perms = {""}, location = {x = 665.88830566406, y = -703.22497558594, z = 37.343109130859}, spawner = {train = 43, x = 926.28533935547, y = -494.29217529297, z = 30.667287826538} },
    {name = "LS Passenger Train Long (Level 10)", perms = {""}, location = {x = 793.67242431641, y = -1908.7456054688, z = 21.784048080444}, spawner = {train = 40, x = 803.51043701172, y = -1908.5551757813, z = 20.564588546753} },
    {name = "LS Passenger Train (Level 10)", perms = {""}, location = {x = 211.93998718262, y = -2441.4865722656, z = 8.4497776031494}, spawner = {train = 42, x = 311.2541809082, y = -2612.9780273438, z = 8.6949901580811} },
    {name = "LS Passenger E7 EMU (Level 60)", perms = {""}, location = {x = 211.31231689453, y = -2424.5163574219, z = 8.5115089416504}, spawner = {train = 25, x = 311.2541809082, y = -2612.9780273438, z = 8.6949901580811} },
    {name = "LS Passenger ICE3M (Level 30)", perms = {""}, location = {x = 211.90394592285, y = -2433.5122070313, z = 8.4796075820923}, spawner = {train = 27, x = 311.2541809082, y = -2612.9780273438, z = 8.6949901580811} },
    {name = "PB Passenger Train (Level 10)", perms = {""}, location = {x = -323.34335327148, y = 5962.9868164063, z = 41.883724212646}, spawner = {train = 42, x = -361.04824829102, y = 5911.4516601563, z = 45.679042816162} },
    -- {name = "PB TGV (Level 20)", perms = {""}, location = {x = -315.04263305664, y = 5972.6552734375, z = 40.778701782227}, spawner = {train = 27, x = -361.04824829102, y = 5911.4516601563, z = 45.679042816162} },

    {name = "GS Passenger Train (Level 10)", perms = {""}, location = {x = 2999.7514648438, y = 4097.2358398438, z = 57.107582092285}, spawner = {train = 40, x = 3006.3293457031, y = 4097.3481445313, z = 57.612167358398} },
    -- {name = "TEST 25", perms = {""}, location = {x = 2996.7514648438, y = 4087.2358398438, z = 57.107582092285}, spawner = {train = 25, x = 3006.3293457031, y = 4097.3481445313, z = 57.612167358398} },
    -- {name = "TEST 26", perms = {""}, location = {x = 2993.7514648438, y = 4087.2358398438, z = 57.107582092285}, spawner = {train = 26, x = 3006.3293457031, y = 4097.3481445313, z = 57.612167358398} },

    -- {name = "Globe Oil Tanker Train", perms = {""}, location = {x = 2617.8984375, y = 1707.5870361328, z = 27.597440719604}, spawner = {train = 26, x = 2611.0749511719, y = 1766.9490966797, z = 26.37712097168} },
    {name = "CollinsCo Speedy BOI", perms = {""}, location = {x = 211.7430267334, y = -2459.2495117188, z = 8.3267555236816}, spawner = {train = 46, x = 211.7430267334, y = -2459.2495117188, z = 8.3267555236816} },
    -- {name = "TGV 27", perms = {""}, location = {x = 1287.8082275391, y = 6417.193359375, z = 26.299634933472}, spawner = {train = 27, x = 1271.0749511719, y = 6429.5927734375, z = 31.852146148682} },
    -- {name = "TGV 28 (Level 20)", perms = {""}, location = {x = 1295.1345214844, y = 6415.7954101563, z = 26.497575759888}, spawner = {train = 28, x = 1271.0749511719, y = 6429.5927734375, z = 31.852146148682} },
    -- {name = "TGV 29", perms = {""}, location = {x = 1290.7263183594, y = 6410.3115234375, z = 26.601089477539}, spawner = {train = 29, x = 1271.0749511719, y = 6429.5927734375, z = 31.852146148682} },

    {name = "LS Metro Tram", perms = {""}, location = {x = 563.8271484375, y = -1984.6627197266, z = 17.775186538696}, spawner = {train = 24, x = 562.055969, y = -1978.789307, z = 16.775246} },
    {name = "LS Metro Tram NL", perms = {""}, location = {x = 563.8271484375, y = -1984.6627197266, z = 17.775186538696}, spawner = {train = 72, x = 562.055969, y = -1978.789307, z = 16.775246} },
    {name = "LS Metro Tram", perms = {""}, location = {x = -1105.1005859375, y = -2744.1628417969, z = -7.4101328849792}, spawner = {train = 24, x = -1099.512207, y = -2746.507568, z = -9.923965} },
    {name = "LS Metro Tram NL", perms = {""}, location = {x = -1105.1005859375, y = -2744.1628417969, z = -7.4101328849792}, spawner = {train = 72, x = -1099.512207, y = -2746.507568, z = -9.923965} },
    {name = "LS Metro Passenger Train (Level 10)", perms = {""}, location = {x = -401.71618652344, y = -681.5390625, z = 11.616627693176}, spawner = {train = 42, x = -412.29736328125, y = -669.05096435547, z = 10.895616531372} },
}

local PREVIOUS_TRAIN = nil

local function LoadModel(model)
    tempmodel = GetHashKey(model)
    RequestModel(tempmodel)
    local _timeout = 0
    local _boundary = 2000
    while not HasModelLoaded(tempmodel) do
        Citizen.Wait(0)
        _timeout = _timeout + 1
        if _timeout >= _boundary then
            break
        end
    end
end

function LoadTrainModels()
    DeleteAllTrains()

    for k, v in pairs(models) do
        LoadModel(v)
    end
end

Citizen.CreateThread(function()
    LoadTrainModels()
end)

-- ------------------------------------------ --
local localPed = GetPlayerPed(PlayerId())


local TrainVars = {}
local TrainList = {}
TrainVars.inTrain = false
TrainVars.isPassenger = false
TrainVars.TrainVeh = 0
TrainVars.Speed = 0
TrainVars.EnterExitDelay = 0
TrainVars.EnterExitDelayMax = 3000

TrainVars.TrainSpeeds = {}
TrainVars.TrainSpeeds.FTrain = {}
TrainVars.TrainSpeeds.FTrain.MaxSpeed = 40
TrainVars.TrainSpeeds.FTrain.Accel = 0.03

TrainVars.TrainSpeeds.JTrain = {}
TrainVars.TrainSpeeds.JTrain.MaxSpeed = 60
TrainVars.TrainSpeeds.JTrain.Accel = 0.06

TrainVars.TrainSpeeds.DF4BTrain = {}
TrainVars.TrainSpeeds.DF4BTrain.MaxSpeed = 40
TrainVars.TrainSpeeds.DF4BTrain.Accel = 0.04

TrainVars.TrainSpeeds.Trolley = {}
TrainVars.TrainSpeeds.Trolley.MaxSpeed = 25
TrainVars.TrainSpeeds.Trolley.Accel = 0.1

-- RegisterCommand("_debug_train", function(source, args, raw)
--     local pos = GetEntityCoords(PlayerPedId())
--     local _newTrain = spawnTrain(tonumber(args[1]), pos.x, pos.y, pos.z)
-- end)

function spawnTrain(id, x, y, z, cb)
    local pos = vector3(x, y, z)
    local _newTrain = createNewTrain(id, pos.x, pos.y, pos.z)
    Wait(60)
    TrainVars.Speed = 0
    TrainVars.TrainVeh = _newTrain
    TrainVars.inTrain = true
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), _newTrain, -1)
    SetVehicleDirtLevel(_newTrain, 0.0)
    local model = GetEntityModel(_newTrain)
    if model ~= `lcsubway` and model ~= `metrocab` and model ~= `metrotrain` then
        OverrideVehHorn(_newTrain, true, -443787204) -- arena wars horn
    end
    if model == `freight` then
        -- Choose a random color from a set
        -- Primary and secondary cannot be from same set!
        local colors = {
            {15,16,17,18,19,20}, -- black & silver
            {43,44,45}, -- red
            {56,57}, -- green
            {75,76,77,78,79,80,81}, -- blue
            {108,109,110}, -- brown
            {121,122,131,132}, -- white
            {138,123,124}, -- orange
        }
        local _primaryList = table.remove(colors, math.random(#colors))
        local primary = _primaryList[math.random(#_primaryList)]
        local _secondaryList = table.remove(colors, math.random(#colors))
        local secondary = _secondaryList[math.random(#_secondaryList)]

        -- Set train color
        SetVehicleColours(_newTrain, primary, secondary)

        -- Set every wagons color
        local wagonidx = 1
        local wagon = GetTrainCarriage(_newTrain, wagonidx)
        while DoesEntityExist(wagon) do
            SetVehicleColours(wagon, primary, secondary)
            wagonidx = wagonidx + 1
            wagon = GetTrainCarriage(_newTrain, wagonidx)
        end
    end
    return _newTrain
end

function findNearestTrain()
    for n, train in ipairs(TrainList) do
        if(not IsEntityDead(train)) then
            if IsThisModelATrain(GetEntityModel(train)) then
                local pedPosition = GetEntityCoords(LocalPed())
                local trainPosition = GetEntityCoords(train)
                local thedist = #(pedPosition - trainPosition)
                if (thedist <= 40) then
                    return train
                end
            else
                TrainList[n] = nil
            end
        end
    end
    return 0
end

function getTrainSpeeds()
    local mod = GetEntityModel(TrainVars.TrainVeh)
    local ret = {}
    ret.MaxSpeed = 10
    ret.Accel = 1

    -- print("trainmod: " .. mod)
    -- print("tgv01 hash: " .. `tgv01`)

    -- Is there a better way to do this? (GetEntityModel(TrainVars.TrainVeh))
    if (mod == 1030400667) then
        ret.MaxSpeed = TrainVars.TrainSpeeds.FTrain.MaxSpeed -- Heavy, but fast.
        ret.Accel = TrainVars.TrainSpeeds.FTrain.Accel
    elseif (mod == 868868440) then
        ret.MaxSpeed = TrainVars.TrainSpeeds.Trolley.MaxSpeed -- Light weight, carrys people around not to fast
        ret.Accel = TrainVars.TrainSpeeds.Trolley.Accel
    elseif (mod == 1377039676) then
        ret.MaxSpeed = TrainVars.TrainSpeeds.JTrain.MaxSpeed -- Light weight, carrys people around not to fast
        ret.Accel = TrainVars.TrainSpeeds.JTrain.Accel
    elseif (mod == `df4b1`) then -- df4b1
        ret.MaxSpeed = TrainVars.TrainSpeeds.DF4BTrain.MaxSpeed -- Light weight, carrys people around not to fast
        ret.Accel = TrainVars.TrainSpeeds.DF4BTrain.Accel
    elseif (mod == `df4b2`) then -- df4b2
        ret.MaxSpeed = TrainVars.TrainSpeeds.DF4BTrain.MaxSpeed -- Light weight, carrys people around not to fast
        ret.Accel = TrainVars.TrainSpeeds.DF4BTrain.Accel
    elseif (mod == 2158407904) then -- go_tankercar
        ret.MaxSpeed = 80
        ret.Accel = 2.0
    elseif (mod == `tgv01`) then -- tgv01
        ret.MaxSpeed = 70 -- Light weight, carrys people around not to fast
        ret.Accel = 0.12
    elseif (mod == `e701`) then -- tgv01
        ret.MaxSpeed = 70 -- Light weight, carrys people around not to fast
        ret.Accel = 0.12
    elseif (mod == `ice301`) then -- tgv01
        ret.MaxSpeed = 65 -- Light weight, carrys people around not to fast
        ret.Accel = 0.09
    elseif (mod == `e401`) then -- E401
        ret.MaxSpeed = 80 -- FAST BOI
        ret.Accel = 0.15
    elseif (mod == `lcsubway`) then -- LCSUBWAY
        ret.MaxSpeed = 20 -- FAST BOI
        ret.Accel = 0.2
    elseif (mod == `metrocab`) then -- NL Tram
        ret.MaxSpeed = 25
        ret.Accel = 0.1
    else
        ret.MaxSpeed = 10
        ret.Accel = 1.0
    end

    return ret
end

RegisterNetEvent("conductor:setSpeed")
function SetSpeed(speed)
    TrainVars.Speed = 0
end
AddEventHandler("conductor:setSpeed", SetSpeed)

RegisterNetEvent("conductor:setLimit")
function SetLimit(speed)
    TrainVars.TrainSpeeds.FTrain.MaxSpeed = 0
end
AddEventHandler("conductor:setLimit", SetSpeed)

RegisterNetEvent("UpdateTrainList")
function UpdateTrainList(Trains, Del)
    if (Del == true) then
        for _, k in ipairs(TrainList) do
            DeleteMissionTrain(k)
        end

        TrainVars.inTrain = false
        TrainVars.TrainVeh = 0
        TrainVars.Speed = 0
        TrainVars.EnterExitDelay = 0
        return
    end
    TrainList = Trains
end
AddEventHandler("UpdateTrainList", UpdateTrainList)

function createNewTrain(type, x, y, z)
    if PREVIOUS_TRAIN then
        RemoveTrain()
    end
    local train = CreateMissionTrain(type, x, y, z, true)
    SetTrainSpeed(train, 0)
    SetTrainCruiseSpeed(train, 0)
    TriggerServerEvent("AddToTrainList", train)
    PREVIOUS_TRAIN = train
    return train
end

function RemoveTrain()
    TrainVars.inTrain = false
    TrainVars.TrainVeh = 0
    TrainVars.Speed = 0
    TrainVars.EnterExitDelay = 0
    DeleteMissionTrain(PREVIOUS_TRAIN)
    PREVIOUS_TRAIN = nil
end

function DeleteTrains()
    TriggerServerEvent("DeleteTrains")
end

function CoolDown()
    SetTimeout(300000, function() GotTrain = false end)
end

function LocalPed()
    return GetPlayerPed(-1)
end

function DrawText3D(text, x, y, z, s)
    exports['omni_common']:DrawText3D(text, x, y, z, s)
end

function derailTrain()
    -- public virtual async Task Derail()
    if not TrainVars.inTrain then
        return false, "Not in a train"
    end
    local carriages = {}
    local _n = 0
    local found = true
    while found do
        local carriage = GetTrainCarriage(TrainVars.TrainVeh, _n)
        if DoesEntityExist(carriage) then
            table.insert(carriages, carriage)
        else
            found = false
        end
        _n = _n + 1
    end
    TrainVars.inTrain = false
    TrainVars.TrainVeh = 0
    TrainVars.Speed = 0
    for _, carriage in next, carriages do
        local peds = {}
        for seat = -1, GetVehicleMaxNumberOfPassengers(carriage), 1 do
            if not IsVehicleSeatFree(carriage, seat) then
                peds[seat] = GetPedInVehicleSeat(carriage, seat)
            end
        end
        local rotation = GetEntityRotation(carriage, 1)
        local position = GetEntityCoords(carriage, true)
        local heading = GetEntityHeading(carriage)
        local velocity = GetEntityVelocity(carriage)
        local model = GetEntityModel(carriage)

        DeleteVehicle(carriage)

        carriage = CreateVehicle(model, position.x, position.y, position.z + 0.0, heading, true, 0)
        SetEntityRotation(carriage, rotation.x + math.random(-5.0, 5.0), rotation.y + math.random(-5.0, 5.0), rotation.z + math.random(-5.0, 5.0), 1, 0)
        SetEntityVelocity(carriage, velocity.x * 1.1, velocity.y * 1.1, velocity.z * 1.1 + 2.0)
        SetEntityDynamic(carriage, true)
        for seat, ped in next, peds do
            SetPedIntoVehicle(ped, carriage, seat)
        end
        SetEntityAsNoLongerNeeded(carriage)
        SetTimeout(120 * 1000, function()
            if DoesEntityExist(carriage) then
                DeleteEntity(carriage)
            end
        end)
    end
    return true, "Train derailed"
end

Citizen.CreateThread(function()
    local factor_max = 0.0
    local previous_heading = 0.0
    while true do
        Wait(1)

        if (TrainVars.EnterExitDelay == 0) then
            TrainVars.EnterExitDelay = GetGameTimer()
        end

        if (TrainVars.inTrain and not TrainVars.isPassenger) then
            SetTrainSpeed(TrainVars.TrainVeh, TrainVars.Speed)
        end

        -- Speed Up/Forwards (W)
        if (IsControlPressed(0, 71) and TrainVars.inTrain and TrainVars.Speed < getTrainSpeeds().MaxSpeed and not TrainVars.isPassenger) then
            TrainVars.Speed = TrainVars.Speed + getTrainSpeeds().Accel
            SetTrainSpeed(TrainVars.TrainVeh, TrainVars.Speed)
        end

        -- Slow down/Reverse (S)
        if (IsControlPressed(0, 72) and TrainVars.inTrain and TrainVars.Speed > - (getTrainSpeeds().MaxSpeed / 4) and not TrainVars.isPassenger) then
            TrainVars.Speed = TrainVars.Speed - (getTrainSpeeds().Accel * 1.5)
            SetTrainSpeed(TrainVars.TrainVeh, TrainVars.Speed)
        end

        -- HORN
        if (IsControlJustPressed(0, 86) and TrainVars.inTrain and not TrainVars.isPassenger) then

        end
        if (IsControlJustReleased(0, 86) and TrainVars.inTrain and not TrainVars.isPassenger) then

        end

        -- Slow break (Spacebar)
        local speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), true)) * 2.236936
        if speed <= 25.0 and (
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `freight`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `6f01`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `e701`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `ice301`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `tgv01`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `df4b1`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `df4b2`)
        ) then
            if (IsControlJustPressed(0, 76) and TrainVars.inTrain and TrainVars.Speed ~= 0 and not TrainVars.isPassenger) then
                --Citizen.Trace("break:" .. GetEntityCoords(TrainVars.TrainVeh))
                TrainVars.Speed = 0
                SetTrainSpeed(TrainVars.TrainVeh, TrainVars.Speed)
            end
        end

        local speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), true)) * 2.236936
        if speed <= 5.0 and (
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `metrocab`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `metrotrain`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `lcsubway`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `6f01`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `e701`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `ice301`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `tgv01`) or
            IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `e401`)
        ) then
            if (IsControlPressed(0, 76) and TrainVars.inTrain and TrainVars.Speed ~= 0 and not TrainVars.isPassenger) then
                --Citizen.Trace("break:" .. GetEntityCoords(TrainVars.TrainVeh))
                TrainVars.Speed = 0
                SetTrainSpeed(TrainVars.TrainVeh, TrainVars.Speed)
            end
        end
        local heading = GetEntityHeading(TrainVars.TrainVeh)
        local factor = math.abs(heading - previous_heading) * TrainVars.Speed
        factor_max = math.max(factor, factor_max)
        previous_heading = heading
        if TrainVars.Speed > 28.0 and factor > 48.0 and factor < 200.0 then
            -- derailTrain()
        end
        -- exports['omni_common']:DrawScreenText(0.5, 0.5, 1.0, "factor: " .. factor, 255, 255, 255, 255)
        -- exports['omni_common']:DrawScreenText(0.5, 0.6, 1.0, "max: " .. factor_max, 255, 255, 255, 255)
        -- if speed > 85.0 then
        --     derailTrain()
        -- end
        --[[
            if (IsControlPressed(0,22) and TrainVars.inTrain and TrainVars.Speed ~= 0)then
                --Citizen.Trace("break:" .. GetEntityCoords(TrainVars.TrainVeh))
                TrainVars.Speed = 30
                SetTrainSpeed(TrainVars.TrainVeh, TrainVars.Speed)
            end]]

        --AntiBreak for blah

        -- Enter/Exit (F)X
        if(IsControlPressed(0, 75) and(GetGameTimer() - TrainVars.EnterExitDelay) > TrainVars.EnterExitDelayMax) then
            TrainVars.EnterExitDelay = 0

            if(TrainVars.inTrain) then
                if (TrainVars.TrainVeh ~= 0) then
                    local pedPosition = GetEntityCoords(LocalPed())
                    SetEntityCoords(LocalPed(), pedPosition.x, pedPosition.y - 0.5, pedPosition.z + 2.3, false, false, false, false)
                end
                TrainVars.inTrain = false
                TrainVars.isPassenger = false
                TrainVars.TrainVeh = 0
                RemoveTrain()
            else
                local _train = findNearestTrain()
                if (TrainVars.TrainVeh == 0 and _train ~= 0) then
                    if not IsVehicleSeatFree(_train, -1) then
                        if not IsVehicleSeatFree(_train, 0) then
                            -- Train is full
                        else
                            SetPedIntoVehicle(LocalPed(), _train, 0)
                            TrainVars.inTrain = true
                            TrainVars.isPassenger = true
                            TrainVars.TrainVeh = _train
                        end
                    else
                        SetPedIntoVehicle(LocalPed(), _train, -1)
                        TrainVars.inTrain = true
                        TrainVars.isPassenger = false
                        TrainVars.TrainVeh = _train
                    end
                end
            end
        end

        local playerPed = LocalPed()
        local playerPos = GetEntityCoords(playerPed)

        -- Speed Limiting in the city
        local function __lerp(a,b,t)
        	return a + (b - a) * t
        end
        local __cityspeed = 24.0
        if (playerPos.y < -1201.88916015625 and TrainVars.inTrain and TrainVars.Speed > __cityspeed and not IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `metrotrain`) and not IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `metrocab`)) then
            TrainVars.Speed = __lerp(TrainVars.Speed, __cityspeed, 0.05)
        end
        if (playerPos.y < -1201.88916015625 and TrainVars.inTrain and TrainVars.Speed < -__cityspeed and not IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `metrotrain`) and not IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), `metrocab`)) then
            TrainVars.Speed = __lerp(TrainVars.Speed, -__cityspeed, 0.05)
        end

        -- for train_no, train_spawner in next, TRAIN_SPAWNS do
        --     if not train_spawner.cooldown then train_spawner.cooldown = 0 end
        --     if train_spawner.cooldown > 0 then train_spawner.cooldown = train_spawner.cooldown - 1 end
        --
        --     local dist = Vdist(playerPos.x, playerPos.y, playerPos.z, train_spawner.location.x, train_spawner.location.y, train_spawner.location.z)
        --     if not IsPedInAnyVehicle(playerPed, false) then
        --         if dist < 150.0 then
        --             DrawMarker(0, train_spawner.location.x, train_spawner.location.y, train_spawner.location.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 139, 69, 19, 255, true, false)
        --         end
        --         if dist < 3.0 then
        --             if train_spawner.cooldown <= 0 then
        --                 DrawText3D("Press ~y~E ~w~to spawn a~n~~y~" .. train_spawner.name, train_spawner.location.x, train_spawner.location.y, train_spawner.location.z + 1.0)
        --                 if IsControlJustPressed(0, 38) then
        --                     train_spawner.cooldown = 2000
        --                     TrainVars.EnterExitDelay = 0
        --
        --                     TrainVars.Speed = 0
        --                     local _newTrain = createNewTrain(train_spawner.spawner.train, train_spawner.spawner.x, train_spawner.spawner.y, train_spawner.spawner.z)
        --
        --                     Wait(60)
        --                     --TrainVars.Speed = 0
        --                     GotTrain = true
        --                     TrainVars.TrainVeh = _newTrain
        --                     TrainVars.inTrain = true
        --                     TaskWarpPedIntoVehicle(GetPlayerPed(-1), _newTrain, - 1)
        --                     CoolDown()
        --
        --                 end
        --             else
        --                 DrawText3D("~r~Please wait before spawning this again~n~~y~" .. train_spawner.name, train_spawner.location.x, train_spawner.location.y, train_spawner.location.z + 1.0)
        --             end
        --         end
        --     end
        -- end
    end
end)

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- local traindata = {
--     {name = "Freight: Tiny Flatbed", train = 0, id = "FREIGHT_FLAT_TINY", cars = 2, engines = 1, types = {"flatbed"}},
--     {name = "Freight: Medium Flatbed", train = 1, id = "FREIGHT_FLAT_MEDIUM", cars = 8, engines = 1, types = {"flatbed"}},
--     {name = "Freight: Short Mixed", train = 2, id = "FREIGHT_MIXED_SHORT", cars = 5, engines = 1, types = {"flatbed", "tanker", "container"}},
--     {name = "Freight: Medium Mixed", train = 3, id = "FREIGHT_MIXED_MEDIUM", cars = 8, engines = 1, types = {"flatbed", "tanker"}},
--     {name = "Freight: Long Grain", train = 4, id = "FREIGHT_GRAIN_LONG", cars = 9, engines = 1, types = {"grain", "flatbed"}},
--     {name = "Freight: Short Grain", train = 5, id = "FREIGHT_GRAIN_SHORT", cars = 6, engines = 1, types = {"grain", "flatbed"}},
--     {name = "Freight: Tiny Mixed", train = 6, id = "FREIGHT_MIXED_TINY", cars = 4, engines = 1, types = {"container", "flatbed", "tanker"}},
--     {name = "Freight: Medium Container", train = 7, id = "FREIGHT_CONTAINER_MEDIUM", cars = 8, engines = 1, types = {"flatbed", "container"}},
--     {name = "Freight: Short Container", train = 8, id = "FREIGHT_CONTAINER_SHORT", cars = 7, engines = 1, types = {"flatbed", "container", "tanker"}},
--     {name = "Freight: Short Grain", train = 9, id = "FREIGHT_GRAIN_SHORT", cars = 6, engines = 1, types = {"flatbed", "grain"}},
--     {name = "Freight: Medium Container", train = 10, id = "FREIGHT_CONTAINER_MEDIUM", cars = 8, engines = 1, types = {"container", "flatbed"}},
--     {name = "Freight: Short Container", train = 11, id = "FREIGHT_CONTAINER_SHORT", cars = 7, engines = 1, types = {"container", "flatbed"}},
--     {name = "Freight: Short Grain", train = 12, id = "FREIGHT_GRAIN_SHORT", cars = 6, engines = 1, types = {"flatbed", "grain"}},
--     {name = "Freight: Medium Tanker", train = 13, id = "FREIGHT_TANKER_MEDIUM", cars = 8, engines = 1, types = {"tanker", "flatbed"}},
--     {name = "Freight: Medium Container", train = 14, id = "FREIGHT_CONTAINER_MEDIUM", cars = 8, engines = 1, types = {}},
--     {name = "Freight: Medium Mixed", train = 15, id = "FREIGHT_MIXED_MEDIUM", cars = 8, engines = 1, types = {"flatbed", "container", "grain"}},
--     {name = "Freight: Short Tanker", train = 16, id = "FREIGHT_TANKER_SHORT", cars = 7, engines = 1, types = {"flatbed", "tanker"}},
--     {name = "Freight: Supersize Container", train = 17, id = "FREIGHT_CONTAINER_SUPERSIZE", cars = 40, engines = 1, types = {"container"}},
--     {name = "Freight: Engine", train = 18, id = "FREIGHT_ENGINE", cars = 0, engines = 1, types = {}},
--     {name = "Freight: Tiny Tanker", train = 19, id = "FREIGHT_TANKER_TINY", cars = 2, engines = 1, types = {"tanker"}},
--     {name = "Freight: Tiny Container", train = 20, id = "FREIGHT_CONTAINER_TINY", cars = 3, engines = 1, types = {"container"}},
--     {name = "Metro: Single", train = 21, id = "METRO_SINGLE", cars = 1, engines = 0, types = {"passenger"}},
--     {name = "Freight: Long Flatbed", train = 22, id = "FREIGHT_FLAT_LONG", cars = 12, engines = 1, types = {"flatbed"}},
--     {name = "Freight: Long Container", train = 23, id = "FREIGHT_CONTAINER_LONG", cars = 13, engines = 1, types = {"container", "flatbed"}},
--     {name = "Metro: Dual", train = 24, id = "METRO_DUAL", cars = 2, engines = 0, types = {"passenger"}},
--     {name = "Passenger: Shinkansen E7 EMU (Short)", train = 25, id = "PASSENGER_E7_SHORT", cars = 6, engines = 0, types = {"passenger"}},
--     {name = "Freight: Dongfeng 4 Tanker", train = 26, id = "FREIGHT_DF4_TANKER", cars = 12, engines = 1, types = {"tanker"}},
--     {name = "Passenger: InterCity Express 3M EMU", train = 27, id = "PASSENGER_ICE", cars = 6, engines = 0, types = {"passenger"}},
--     {name = "Freight: Tiny Mixed", train = 28, id = "FREIGHT_MIXED_TINY", cars = 4, engines = 1, types = {"tanker", "container", "flatbed"}},
--     {name = "Freight: Medium Container", train = 29, id = "FREIGHT_CONTAINER_MEDIUM", cars = 8, engines = 1, types = {"flatbed", "container"}},
--     {name = "Freight: Short Mixed", train = 30, id = "FREIGHT_MIXED_SHORT", cars = 7, engines = 1, types = {"container", "flatbed", "tanker"}},
--     {name = "Freight: Short Grain", train = 31, id = "FREIGHT_GRAIN_SHORT", cars = 6, engines = 1, types = {"flatbed", "grain"}},
--     {name = "Freight: Medium Container", train = 32, id = "FREIGHT_CONTAINER_MEDIUM", cars = 8, engines = 1, types = {"container", "flatbed"}},
--     {name = "Freight: Short Container", train = 33, id = "FREIGHT_CONTAINER_SHORT", cars = 7, engines = 1, types = {"container", "flatbed"}},
--     {name = "Freight: Short Grain", train = 34, id = "FREIGHT_GRAIN_SHORT", cars = 6, engines = 1, types = {"flatbed", "grain"}},
--     {name = "Freight: Medium Tanker", train = 35, id = "FREIGHT_TANKER_MEDIUM", cars = 8, engines = 1, types = {"flatbed", "tanker"}},
--     {name = "Freight: Medium Container", train = 36, id = "FREIGHT_CONTAINER_MEDIUM", cars = 8, engines = 1, types = {"flatbed", "container"}},
--     {name = "Freight: Medium Mixed", train = 37, id = "FREIGHT_MIXED_MEDIUM", cars = 8, engines = 1, types = {"grain", "flatbed", "container"}},
--     {name = "Freight: Short Tanker", train = 38, id = "FREIGHT_TANKER_SHORT", cars = 7, engines = 1, types = {"tanker", "flatbed"}},
--     {name = "Passenger: China Railways H6 EMU (Medium)", train = 39, id = "PASSENGER_6F_MEDIUM", cars = 8, engines = 0, types = {"passenger"}},
--     {name = "Passenger: China Railways H6 EMU (Short)", train = 40, id = "PASSENGER_6F_SHORT", cars = 5, engines = 0, types = {"passenger"}},
--     {name = "Passenger: China Railways H6 EMU (Tiny)", train = 41, id = "PASSENGER_6F_TINY", cars = 4, engines = 0, types = {"passenger"}},
--     {name = "Passenger: China Railways H6 EMU (Tiny)", train = 42, id = "PASSENGER_6F_TINY", cars = 3, engines = 0, types = {"passenger"}},
--     {name = "Passenger: China Railways H6 EMU (Short)", train = 43, id = "PASSENGER_6F_SHORT", cars = 7, engines = , types = {"passenger"}},
--     {name = "Freight: Long Flatbed", train = 44, id = "FREIGHT_FLAT_LONG", cars = 12, engines = 1, types = {"flatbed"}},
--     {name = "Freight: Long Container", train = 45, id = "FREIGHT_CONTAINER_LONG", cars = 13, engines = 1, types = {"flatbed", "container"}},
--     {name = "Passenger: Shinkansen E4 EMU (Long)", train = 46, id = "PASSENGER_E4_LONG", cars = 10, engines = 0, types = {"passenger"}},
--     {name = "Metro: Dual", train = 47, id = "METRO_DUAL", cars = 4, engines = 0, types = {"passenger"}},
--     {name = "Metro: Triple", train = 48, id = "METRO_TRIPLE", cars = 6, engines = 0, types = {"passenger"}},
--     {name = "Metro: Quadruple", train = 49, id = "METRO_QUAD", cars = 8, engines = 0, types = {"passenger"}},
-- }
