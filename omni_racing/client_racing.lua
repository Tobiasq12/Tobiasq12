--[[
EVENT STUFF
]]
local Racetracks = {
    -- {
    --     name = "Lighthouse Track",
    --     start = {x = 3610.5461425781, y = 5603.359375, z = 8.0922679901123, h = 264.34255981445},
    --     checkpoints = {
    --         {x = 3729.2475585938, y = 5620.5307617188, z = 7.3951272964478, h = 312.41851806641},
    --         {x = 3764.4377441406, y = 5743.8725585938, z = 7.3958897590637, h = 314.7991027832},
    --         {x = 3853.203125, y = 5824.2119140625, z = 7.4082040786743, h = 301.66125488281},
    --         {x = 3898.0251464844, y = 5702.7211914063, z = 7.3938961029053, h = 172.16484069824},
    --         {x = 3860.173828125, y = 5584.845703125, z = 7.4165425300598, h = 118.19581604004},
    --         {x = 3763.9614257813, y = 5573.41015625, z = 7.415463924408, h = 90.640098571777},
    --         {x = 3670.9440917969, y = 5542.8305664063, z = 7.4271636009216, h = 169.69396972656},
    --         {x = 3562.6901855469, y = 5522.22265625, z = 7.4032516479492, h = 77.730278015137},
    --         {x = 3472.4443359375, y = 5579.7290039063, z = 7.3891077041626, h = 346.85577392578},
    --     }
    -- },
    -- {
    --     name = "Lighthouse Drift Track",
    --     start = {x = 3625.7243652344, y = 5810.1416015625, z = 7.2677435874939, h = 261.13571166992},
    --     checkpoints = {
    --         {x = 3625.7243652344, y = 5810.1416015625, z = 7.2677435874939, h = 261.13571166992},
    --         {x = 3662.6840820313, y = 5882.7358398438, z = 7.260537147522, h = 68.884048461914},
    --         {x = 3635.0334472656, y = 5838.5473632813, z = 7.2502117156982, h = 112.31060791016},
    --         {x = 3607.8879394531, y = 5847.0971679688, z = 7.2514748573303, h = 335.66931152344},
    --         {x = 3648.771484375, y = 5908.5922851563, z = 7.2511706352234, h = 342.71478271484},
    --         {x = 3616.2937011719, y = 5948.0258789063, z = 7.2519159317017, h = 111.78216552734},
    --         {x = 3599.55859375, y = 5864.5229492188, z = 7.2496113777161, h = 132.05953979492},
    --         {x = 3543.203125, y = 5853.2587890625, z = 7.2489352226257, h = 21.92474937439},
    --         {x = 3538.1823730469, y = 5877.4208984375, z = 7.2513766288757, h = 273.5207824707},
    --         {x = 3574.5913085938, y = 5866.1352539063, z = 7.2483134269714, h = 297.462890625},
    --         {x = 3601.4028320313, y = 5902.5913085938, z = 7.2527604103088, h = 5.2773809432983},
    --         {x = 3586.9545898438, y = 5934.0336914063, z = 7.2516298294067, h = 112.07884979248},
    --         {x = 3570.763671875, y = 5889.4013671875, z = 7.2504267692566, h = 130.06512451172},
    --         {x = 3544.0163574219, y = 5905.7387695313, z = 7.2495908737183, h = 349.47634887695},
    --         {x = 3559.9213867188, y = 5989.3090820313, z = 16.481386184692, h = 44.539108276367},
    --         {x = 3494.8786621094, y = 5999.6909179688, z = 16.743934631348, h = 140.19291687012},
    --         {x = 3487.3840332031, y = 5854.3852539063, z = 7.2738485336304, h = 236.16352844238},
    --     }
    -- }
}

function MsToClock(milliseconds)
    local milliseconds = tonumber(milliseconds)

    if milliseconds <= 0 then
        return "00:00.000";
    else
        hours = string.format("%02.f", math.floor(milliseconds / 3600000));
        mins = string.format("%02.f", math.floor(milliseconds / 60000 - (hours * 60)));
        secs = string.format("%02.f", math.floor(milliseconds / 1000 - hours * 3600 - mins * 60));
        mills = string.format("%03.f", math.floor(milliseconds - hours * 3600000 - mins * 60000 - secs * 1000));
        if milliseconds > 3600000 then
            return hours..":"..mins..":"..secs.."."..mills
        else
            return mins..":"..secs.."."..mills
        end
    end
end

function GetTrackHash(track)
    local hashname = tostring(track.user_id) .. ":" .. tostring(track.distance) .. ":" .. tostring(track.start.x)
    return GetHashKey(hashname)
end

function CleanupTrackBlips()
    local _t = GetGameTimer()
    for _, track in next, Racetracks do
        if track.blip then
            RemoveBlip(track.blip)
            track.blip = nil
        end
    end
    local _diff = GetGameTimer() - _t
    print("CleanupTrackBlips " .. _diff .. " ms")
end

RegisterNetEvent("omni:race:removeTracks")
AddEventHandler("omni:race:removeTracks", function()
    CleanupTrackBlips()
    Racetracks = {}
end)
RegisterNetEvent("omni:race:requestTracks")
AddEventHandler("omni:race:requestTracks", function()
    TriggerServerEvent("omni:race:requestTracks")
end)

RegisterNetEvent("omni:race:receiveTracks")
AddEventHandler("omni:race:receiveTracks", function(tracks)
    local _t = GetGameTimer()
    CleanupTrackBlips()
    Racetracks = tracks
    for _, track in next, Racetracks do
        UpdateTrackData(track)
        Wait(0)
    end
    local _diff = GetGameTimer() - _t
    print("receiveTracks " .. _diff .. " ms")
end)

RegisterNetEvent("omni:race:receiveTrackData")
AddEventHandler("omni:race:receiveTrackData", function(tracks)
    Citizen.CreateThread(function()
        local _t = GetGameTimer()
        for _, trackData in next, tracks do
            for _, track in next, Racetracks do
                if trackData.hash == track.hash then
                    print("Track " .. trackData.name .. " shares hash with " .. track.name)
                    track.wr = trackData.wr
                    track.wr_holder = trackData.wr_holder
                    track.wr_veh = trackData.wr_veh
                    UpdateTrackData(track)
                    Wait(0)
                    break
                end
            end
            Wait(0)
        end
        local _diff = GetGameTimer() - _t
        print("receiveTrackData " .. _diff .. " ms")
    end)
end)

function UpdateTrackData(track)
    local pb = GetResourceKvpInt("RACE_PB_" .. track.hash) or 0
    track.pb = pb
    local pb_veh = GetResourceKvpString("RACE_PB_VEH_" .. track.hash) or "None"
    track.pb_veh = pb_veh
end

local RaceSettings = {
    cp = {
        r = 0,
        g = 0,
        b = 255,
        a = 150,
    },
    start = {
        r = 255,
        g = 0,
        b = 0,
        a = 150,
    },
    finish = {
        r = 255,
        g = 0,
        b = 0,
        a = 150,
    }
}

local RaceInfo = {}

function ResetRaceInfo()
    RaceInfo = {
        name = "",
        active = false,
        startTime = 0,
        track = nil,
        total = 0,
        maxSpeed = 0,
    }
end
ResetRaceInfo()

function GetPosition()
    return "1st"
end

function BlipScale(n)
    return math.max(1.0 - (n - 1) * 0.25, 0.25)
end

function StartRace(track)
    CleanupTrackBlips()
    RaceInfo.name = track.name
    RaceInfo.track = track
    RaceInfo.active = true
    RaceInfo.startTime = GetGameTimer()
    RaceInfo.lastCpTime = GetGameTimer()
    RaceInfo.checkpoints = {}
    track.cooldown = 200
    RaceInfo.total = #track.checkpoints
    RaceInfo.cp_size = track.cp_size or 8.0
    RaceInfo.cp_type = track.cp_type or 0
    for _, cp in next, track.checkpoints do
        table.insert(RaceInfo.checkpoints, {x = cp.x, y = cp.y, z = cp.z - 1.5})
    end
    PlaySoundFrontend(-1, "GO", "HUD_MINI_GAME_SOUNDSET", 0)
    MakeCheckpoint(RaceInfo.checkpoints[1], RaceInfo.checkpoints[2])

    if track.class == "Planes"
    or track.class == "Helicopters"
    or track.class == "Aircraft"
    or track.class == "Boats"
    or track.class == "Orienteering" then
        MakeGPSTrack(RaceInfo.checkpoints, false)
    else
        MakeGPSTrack(RaceInfo.checkpoints, true)
    end
    for n, cp in next, RaceInfo.checkpoints do
        if cp.blip then
            SetBlipScale(cp.blip, BlipScale(n))
        end
    end
    TriggerEvent("omni:status", "~y~" .. RaceInfo.name, {
        "~g~Author: ~w~" .. RaceInfo.track.author,
        "~g~Position: ~w~" .. GetPosition(),
        "~g~Checkpoint: ~w~0/" .. (RaceInfo.total + 1),
    })
    TriggerEvent("omni:timer:start")
    TriggerEvent("omni:staff:repair")
    TriggerEvent("omni:staff:refuel")
end

function MakeGPSTrack(points, gps)
    local useCustomGps = exports['omni_common']:IsCustomGPSEnabled()
    if not useCustomGps then return end
    if gps then
        ClearGpsMultiRoute()
        StartGpsMultiRoute(12, true, true)
        for n, point in next, points do
            if not point.blip then
                point.blip = AddBlipForCoord(point.x, point.y, point.z)
                SetBlipScale(point.blip, 0.5)
                SetBlipAsShortRange(point.blip, true)
            end
            AddPointToGpsMultiRoute(point.x, point.y, point.z)
        end
        SetGpsMultiRouteRender(true, 12, 12)
    else
        ClearGpsCustomRoute()
        StartGpsCustomRoute(12, true, true)
        for n, point in next, points do
            if not point.blip then
                point.blip = AddBlipForCoord(point.x, point.y, point.z)
                SetBlipScale(point.blip, 0.5)
                SetBlipAsShortRange(point.blip, true)
            end
            AddPointToGpsCustomRoute(point.x, point.y, point.z)
        end
        SetGpsCustomRouteRender(true, 12, 12)
    end
    -- (gps and ClearGpsMultiRoute or ClearGpsCustomRoute)()
    -- (gps and StartGpsMultiRoute or StartGpsCustomRoute)(12, true, true)
    -- for _, point in next, points do
    --     (gps and AddPointToGpsMultiRoute or AddPointToGpsCustomRoute)(point.x, point.y, point.z)
    -- end
    -- (gps and SetGpsMultiRouteRender or SetGpsCustomRouteRender)(true, 12, 12)
end

AddEventHandler("omni:stop_job", function()
    StopRace()
end)

function CleanupRace()
    for _, cp in next, RaceInfo.checkpoints do
        if cp.blip then
            RemoveBlip(cp.blip)
        end
        if cp.cp then
            DeleteCheckpoint(cp.cp)
        end
    end
    ClearGpsMultiRoute()
    if RaceInfo.track then
        if RaceInfo.track.start then
            if RaceInfo.track.start.blip then
                RemoveBlip(RaceInfo.track.start.blip)
            end
            if RaceInfo.track.start.cp then
                DeleteCheckpoint(RaceInfo.track.start.cp)
            end
        end
        if RaceInfo.track.finish then
            if RaceInfo.track.finish.blip then
                RemoveBlip(RaceInfo.track.finish.blip)
            end
            if RaceInfo.track.finish.cp then
                DeleteCheckpoint(RaceInfo.track.finish.cp)
            end
        end
    end
    ResetRaceInfo()
end

function FinishRace()
    -- do stuff with the time
    local time = GetGameTimer() - RaceInfo.startTime
    local timeText = MsToClock(time)
    local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))))
    if vehicleName == "NULL" then
        vehicleName = "On Foot"
    end
    if time < RaceInfo.track.pb or RaceInfo.track.pb == 0 then
        -- new pb!
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 0)
        SetResourceKvpInt("RACE_PB_" .. RaceInfo.track.hash, time)
        SetResourceKvp("RACE_PB_VEH_" .. RaceInfo.track.hash, vehicleName)
        TriggerServerEvent("omni:race:finish", RaceInfo, time, timeText, vehicleName, true)
        UpdateTrackData(RaceInfo.track)
    else
        PlaySoundFrontend(-1, "CHECKPOINT_AHEAD", "HUD_MINI_GAME_SOUNDSET", 0)
        TriggerServerEvent("omni:race:finish", RaceInfo, time, timeText, vehicleName, false)
    end

    TriggerEvent("omni:status", "~y~" .. RaceInfo.name, {
        "~g~Author: ~w~" .. RaceInfo.track.author,
        "~g~Position: ~w~" .. GetPosition(),
        "~g~Checkpoint: ~w~Finished",
    })
    StopRace()
end

local BLACKLISTED_VEHICLES = {
    "DELUXO",
    "BLIMP",
    "BLIMP2",
    "SHOTARO",
    "F1",
    "MAX33",
    "DAN3",
    "SUPERKART",
    "SUPERKART1",
    "SUPERKART2",
    "SUPERKART3",
    "SUPERKART4",
    "TMODEL",
    "MODELS",
    "F22",
    "IA_HELI",
    "LP700R",
    "OPPRESSOR",
    "OPPRESSOR2",
    "polgs350",
}

function IsInValidRaceVehicle(raceData)
    if exports['omni_common']:GetGlobalSpeedBoost() > 1.0 then
        return false, "Global speed boost is enabled"
    end
    if exports['es_system']:GetGlobalCruiseControl() then
        return false, "Cruise Control is enabled"
    end
    local ped = GetPlayerPed(-1)
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        if DecorExistOn(veh, "omni_no_racing") and DecorGetBool(veh, "omni_no_racing") then
            return false, "This vehicle cannot race"
        end
        if DecorExistOn(veh, "omni_speed_boost") and DecorGetFloat(veh, "omni_speed_boost") > 1.0 then
            return false, "This vehicle has speed boost enabled"
        end
        if GetPedInVehicleSeat(veh, -1) == ped then
            local model = GetEntityModel(veh)
            for _, blacklistedModel in next, BLACKLISTED_VEHICLES do
                if GetHashKey(blacklistedModel) == model then
                    return false, "Blacklisted vehicle"
                end
            end
            local class = GetVehicleClass(veh)
            for _, raceClass in next, raceData.classes do
                if class == raceClass then
                    return true, "Vehicle is valid"
                end
            end
            return false, "Vehicle class not allowed"
        end
        return false, "Not in driver seat"
    end
    if raceData.foot then
        return true, "Can be on foot"
    end
    return false, "Not in a vehicle"
end

function IsActuallyRacing(raceData)
    if exports['omni_common']:GetGlobalSpeedBoost() > 1.0 then
        return false, "Global speed boost is enabled"
    end
    local ped = GetPlayerPed(-1)
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        if DecorExistOn(veh, "omni_no_racing") and DecorGetBool(veh, "omni_no_racing") then
            return false, "This vehicle cannot race"
        end
        if DecorExistOn(veh, "omni_speed_boost") and DecorGetFloat(veh, "omni_speed_boost") > 1.0 then
            return false, "This vehicle has speed boost enabled"
        end
        if IsControlJustPressed(1, 246) then
            return false, "Cruise control isn't allowed when racing."
        end
        if GetEntityHealth(GetPlayerPed(-1)) <= 120 then
            return false, "You are in a coma"
        end
        if GetPedInVehicleSeat(veh, -1) == ped then
            local model = GetEntityModel(veh)
            for _, blacklistedModel in next, BLACKLISTED_VEHICLES do
                if GetHashKey(blacklistedModel) == model then
                    return false, "Using a blacklisted vehicle"
                end
            end
            local class = GetVehicleClass(veh)
            for _, raceClass in next, raceData.classes do
                if class == raceClass then
                    return true, "Vehicle is valid"
                end
            end
            return false, "Using a disallowed vehicle class"
        end
        return false, "Hitch-hiking with another vehicle"
    end
    return true, "Player is on foot"
end

function StopRace()
    if RaceInfo.active == true then
        RaceInfo.active = false
        if RaceInfo.track.start.blip then
            RemoveBlip(RaceInfo.track.start.blip)
        end
        if RaceInfo.track.start.cp then
            DeleteCheckpoint(RaceInfo.track.start.cp)
        end
        TriggerEvent("omni:timer:pause")
        CleanupRace()
    end
end

function MakeCheckpoint(checkpoint, nextCheckpoint)
    local cp = checkpoint
    if not cp.blip then
        cp.blip = AddBlipForCoord(cp.x, cp.y, cp.z)
    end
    SetBlipScale(cp.blip, 1.0)
    -- SetBlipRoute(cp.blip, true)
    SetBlipAsShortRange(cp.blip, false)
    local nextcp = nextCheckpoint
    if not nextcp then
        nextcp = RaceInfo.track.finish
    end
    cp.cp = CreateCheckpoint(RaceInfo.cp_type + 1, cp.x, cp.y, cp.z, nextcp.x, nextcp.y, nextcp.z, RaceInfo.cp_size, RaceSettings.cp.r, RaceSettings.cp.g, RaceSettings.cp.b, RaceSettings.cp.a, 0)
    SetCheckpointCylinderHeight(cp.cp, 5.0, 6.0, 4.0)
end

function GetCurrentCheckpointNo()
    return ((RaceInfo.total) - #RaceInfo.checkpoints)
end

function NextCheckpoint()
    local _gt = GetGameTimer()
    local _ot = RaceInfo.lastCpTime
    local timeTaken = _gt - _ot
    RaceInfo.lastCpTime = _gt
    if RaceInfo.checkpoints[1] then
        local cp = RaceInfo.checkpoints[1]
        if cp.blip then
            RemoveBlip(cp.blip)
        end
        if cp.cp then
            DeleteCheckpoint(cp.cp)
        end
        table.remove(RaceInfo.checkpoints, 1)
        PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
    end
    if RaceInfo.checkpoints[1] then
        MakeCheckpoint(RaceInfo.checkpoints[1], RaceInfo.checkpoints[2])
        for n, cp in next, RaceInfo.checkpoints do
            if cp.blip then
                SetBlipScale(cp.blip, BlipScale(n))
            end
        end
    else
        local cp = RaceInfo.track.finish
        cp.blip = AddBlipForCoord(cp.x, cp.y, cp.z)
        SetBlipRoute(cp.blip, true)
        cp.cp = CreateCheckpoint(RaceInfo.cp_type + 4, cp.x, cp.y, cp.z - 1.5, 0.0, 0.0, 0.0, RaceInfo.cp_size, RaceSettings.finish.r, RaceSettings.finish.g, RaceSettings.finish.b, RaceSettings.finish.a, 0)
        SetCheckpointCylinderHeight(cp.cp, 5.0, 6.0, 4.0)
    end
    TriggerEvent("omni:status", "~y~" .. RaceInfo.name, {
        "~g~Author: ~w~" .. RaceInfo.track.author,
        "~g~Position: ~w~" .. GetPosition(),
        "~g~Checkpoint: ~w~" .. GetCurrentCheckpointNo() .. "/" .. (RaceInfo.total + 1),
    })
    TriggerEvent("omni:staff:repair")
    TriggerEvent("omni_fuel:fill")
    TriggerServerEvent("omni:race:cp", {_gt, _ot, timeTaken})
end

Citizen.CreateThread(function()
    while true do
        Wait(2)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        if not RaceInfo.active then
            local _t = GetGameTimer()
            for _, track in next, Racetracks do
                if not track.blip then
                    local blip = AddBlipForCoord(track.start.x, track.start.y, track.start.z)
                    SetBlipSprite(blip, 315)
                    exports['omni_common']:SetBlipName(blip, "Street Race")
                    if track.pb ~= 0 and track.pb ~= nil then
                        Citizen.InvokeNative(0x74513EA3E505181E, blip, true)
                        if track.pb <= track.wr then
                            SetBlipFriendly(blip, true)
                            SetBlipSecondaryColour(blip, 0, 255, 0)
                        end
                    end

                    local raceTex = "race_general"

                    if track.class == "Planes"
                    or track.class == "Helicopters"
                    or track.class == "Aircraft" then
                        SetBlipSprite(blip, 314)
                        exports['omni_common']:SetBlipName(blip, "Aerial Race")
                        raceTex = "race_aerial"
                    elseif track.class == "Bicycles" then
                        SetBlipSprite(blip, 376)
                        exports['omni_common']:SetBlipName(blip, "Bicycle Race")
                        raceTex = "race_bicycle"
                    elseif track.class == "Motorcycles" then
                        SetBlipSprite(blip, 127)
                        exports['omni_common']:SetBlipName(blip, "Motorcycle Race")
                        raceTex = "race_motorcycle"
                    elseif track.class == "All" then
                        SetBlipSprite(blip, 379)
                        exports['omni_common']:SetBlipName(blip, "All Vehicle Race")
                        raceTex = "race_general"
                    elseif track.class == "Boats" then
                        SetBlipSprite(blip, 316)
                        exports['omni_common']:SetBlipName(blip, "Boat Race")
                        raceTex = "race_boat"
                    elseif track.class == "Orienteering" then
                        SetBlipSprite(blip, 157)
                        exports['omni_common']:SetBlipName(blip, "Orienteering")
                        raceTex = "race_orienteering"
                    elseif track.class == "Off-road" then
                        SetBlipSprite(blip, 315)
                        SetBlipColour(blip, 21)
                        exports['omni_common']:SetBlipName(blip, "Off-road Race")
                        raceTex = "race_offroad"
                    end

                    exports['omni_blip_info']:SetBlipInfoTitle(blip, track.name, false)
                    exports['omni_blip_info']:SetBlipInfoImage(blip, "biz_images", raceTex)
                    exports['omni_blip_info']:AddBlipInfoName(blip, "Author", track.author)
                    exports['omni_blip_info']:AddBlipInfoText(blip, "Vehicle Class", track.class)
                    if track.pb and track.pb ~= 0 then
                        exports['omni_blip_info']:AddBlipInfoHeader(blip, "Personal Best", MsToClock(track.pb))
                        exports['omni_blip_info']:AddBlipInfoText(blip, "Using", track.pb_veh)
                    end
                    exports['omni_blip_info']:AddBlipInfoHeader(blip, "World Record", MsToClock(track.wr))
                    exports['omni_blip_info']:AddBlipInfoName(blip, "Record Holder", track.wr_holder)
                    exports['omni_blip_info']:AddBlipInfoName(blip, "Record Vehicle", track.wr_veh)

                    track.blip = blip
                end
                if track.cooldown and track.cooldown > 0 then
                    track.cooldown = track.cooldown - 1
                else
                    local trackStartPos = vec3(track.start.x, track.start.y, track.start.z - 1.0)
                    local dist = #(pos - trackStartPos)
                    if dist < 300.0 then
                        DrawMarker(1, trackStartPos.x, trackStartPos.y, trackStartPos.z, 0, 0, 0, 0, 0, 0, 16.0, 16.0, 4.0, RaceSettings.start.r, RaceSettings.start.g, RaceSettings.start.b, RaceSettings.start.a)
                    end
                    if dist < 25.0 then
                        local text_y_off = 4.5
                        exports.omni_common:DrawText3D("~y~" .. track.name, trackStartPos.x, trackStartPos.y, trackStartPos.z + text_y_off, 5.0, 7)
                        text_y_off = 3.5
                        exports.omni_common:DrawText3D("Class: ~g~" .. track.class .. " ~w~By: ~g~" .. track.author, trackStartPos.x, trackStartPos.y, trackStartPos.z + text_y_off, 3.0, 4)
                        text_y_off = 2.75
                        if track.pb and track.pb ~= 0 then
                            exports.omni_common:DrawText3D("Personal Best: ~g~" .. MsToClock(track.pb) .. " ~w~In: ~g~" .. (track.pb_veh or 'Unknown'), trackStartPos.x, trackStartPos.y, trackStartPos.z + text_y_off, 2.5, 4)
                            text_y_off = 2.25
                        end
                        if track.wr and track.wr ~= 0 then
                            exports.omni_common:DrawText3D("World Record: ~g~" .. MsToClock(track.wr) .. " ~w~By: ~g~" .. (track.wr_holder or 'Unknown') .. " ~w~Using: ~g~" .. (track.wr_veh or 'Unknown'), trackStartPos.x, trackStartPos.y, trackStartPos.z + text_y_off, 2.5, 4)
                        end
                    end
                    if dist < 12.0 then
                        local _valid, _r = IsInValidRaceVehicle(track)
                        if _valid then
                            -- press E to start race
                            exports.omni_common:DrawScreenText(0.5, 0.8, 1.0, "Press ~g~E ~w~or ~g~LB ~w~to start this race!", 255, 255, 255, 255)
                            if track.checkpoints and track.checkpoints[1] then
                                DrawMarker(1, track.checkpoints[1].x, track.checkpoints[1].y, track.checkpoints[1].z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 4.0, 255, 255, 255, 255)
                            end
                            if IsControlPressed(0, 38) then
                                StartRace(track)
                                break
                            end
                        else
                            exports.omni_common:DrawScreenText(0.5, 0.8, 1.0, _r, 255, 255, 255, 255)
                        end
                    end
                end
            end
            local _diff = GetGameTimer() - _t
            if _diff > 100 then
                print("client racing loop " .. _diff .. " ms")
            end
        else
            -- Actually racing
            local _racing, _f = IsActuallyRacing(RaceInfo.track)
            if _racing then
                local checkpoint = RaceInfo.checkpoints[1]
                if not checkpoint then
                    checkpoint = RaceInfo.track.finish
                    local checkpointPos = vec3(checkpoint.x, checkpoint.y, checkpoint.z)
                    local dist = #(pos - checkpointPos)
                    if dist < RaceInfo.cp_size * 1.5 then
                        local _valid, _r = IsInValidRaceVehicle(RaceInfo.track)
                        if _valid then
                            FinishRace()
                        else
                            exports.omni_common:DrawScreenText(0.5, 0.8, 1.0, _r, 255, 255, 255, 255)
                        end
                    end
                else
                    local checkpointPos = vec3(checkpoint.x, checkpoint.y, checkpoint.z)
                    local dist = #(pos - checkpointPos)
                    if dist < RaceInfo.cp_size * 1.5 then
                        local _valid, _r = IsInValidRaceVehicle(RaceInfo.track)
                        if _valid then
                            NextCheckpoint()
                        else
                            exports.omni_common:DrawScreenText(0.5, 0.8, 1.0, _r, 255, 255, 255, 255)
                        end
                    end
                end
                local speed = GetEntitySpeed(GetPlayerPed(-1))
                if speed > RaceInfo.maxSpeed then
                    RaceInfo.maxSpeed = speed
                end
            else
                TriggerEvent("gd_utils:oneliner", "~y~Disqualified from race~n~~w~" .. _f, 15)
                StopRace()
            end
        end
    end
end)

local lap = 0
local laps = 5
local lap_enabled = false
local lap_points = {
    {x = 3621.4567871094, y = 5603.130859375, z = 8.0999526977539, range = 10.0},
    {x = 3634.7846679688, y = 5809.1728515625, z = 8.1232566833496, range = 9.0},
}

RegisterNetEvent("omni:events:racing:enable")
AddEventHandler("omni:events:racing:enable", function(enable)
    lap_enabled = enable
    lap = 0
    if enable then
        TriggerEvent("omni:status", "Event Race", "Ready to start!")
    else
        TriggerEvent("omni:status", "Event Race", "Not active")
    end
end)

RegisterNetEvent("omni:events:racing:setlaps")
AddEventHandler("omni:events:racing:setlaps", function(numlaps)
    print("max laps set to " .. numlaps)
    laps = numlaps
end)

RegisterNetEvent("omni:events:racing:lap")
AddEventHandler("omni:events:racing:lap", function()
    if lap < laps then
        lap = lap + 1
        TriggerEvent("omni:status", "Event Race", "Lap ~y~" .. lap .. "~w~/~y~" .. laps)
        TriggerServerEvent("omni:events:racing:lap:server", lap, laps)
    elseif lap == laps then
        lap = lap + 1
        TriggerServerEvent("omni:events:racing:lap:server", lap, laps)
        TriggerEvent("omni:status", "Event Race", "Finished!")
    end
end)

RegisterNetEvent("omni:events:racing:warp")
AddEventHandler("omni:events:racing:warp", function()
    SetEntityCoords(GetPlayerPed(-1), 3727.203125, 5759.5947265625, 8.0960397720337 + 1.0, 0, 0, 0, 0)
end)

Citizen.CreateThread(function()
    local was_lap = false
    while true do
        Wait(5)
        if lap_enabled then
            local any = false
            for k,v in next, lap_points do
                if Vdist(v.x, v.y, v.z, GetEntityCoords(GetPlayerPed(-1))) <= v.range and not was_lap then
                    was_lap = true
                    any = true
                    TriggerEvent("omni:events:racing:lap")
                    Wait(15000)
                end
            end
            if was_lap and not any then
                was_lap = false
            end
        end
    end
end)
