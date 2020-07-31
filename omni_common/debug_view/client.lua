RegisterNetEvent("omni:common:debug_view")
AddEventHandler("omni:common:debug_view", function()
    if isDebugging() and isDebuggingAdvanced() then
        isDebugViewEnabled = false
        isAdvancedDebugViewEnabled = false
        TriggerEvent("gd_utils:notify", "Debug View ~r~disabled")
    elseif isDebugging() and not isDebuggingAdvanced() then
        isDebugViewEnabled = true
        isAdvancedDebugViewEnabled = true
        TriggerEvent("gd_utils:notify", "Debug View ~y~advanced")
    else
        isDebugViewEnabled = true
        isAdvancedDebugViewEnabled = false
        TriggerEvent("gd_utils:notify", "Debug View ~g~enabled")
    end
    setActualKvp("isDebugViewEnabled", isDebugViewEnabled)
    setActualKvp("isAdvancedDebugViewEnabled", isAdvancedDebugViewEnabled)
    TriggerEvent("common:debug_view", isDebugViewEnabled, isAdvancedDebugViewEnabled)
end)

RegisterNetEvent("omni:common:debug_origin")
AddEventHandler("omni:common:debug_origin", function()
    if useOrigin() then
        isUsingOrigin = false
        TriggerEvent("gd_utils:notify", "3D origin ~r~disabled")
    else
        isUsingOrigin = true
        TriggerEvent("gd_utils:notify", "3D origin ~g~enabled")
    end
    setActualKvp("isUsingOrigin", isUsingOrigin)
end)

local debugVehs = {}
local debugPeds = {}
Citizen.CreateThread(function()
    -- LOCAL OPTIMIZATION
    local Wait = Wait
    local isDebugging = isDebugging
    local FindFirstVehicle = FindFirstVehicle
    local FindNextVehicle = FindNextVehicle
    local EndFindVehicle = EndFindVehicle
    local FindFirstPed = FindFirstPed
    local FindNextPed = FindNextPed
    local EndFindPed = EndFindPed
    -- END LOCAL OPTIMIZATION
    while true do
        Wait(5)
        if isDebugging() then
            local vehs = 0
            local next = true
            local handle, vehicle = FindFirstVehicle()
            while next do
                if vehicle then
                    vehs = vehs + 1
                    debugVehs[vehicle] = vehicle
                end
                next, vehicle = FindNextVehicle(handle)
            end
            EndFindVehicle(handle)
            print("vehs: " .. vehs)
            Wait(1000)
        end
        if isDebugging() then
            local vehs = 0
            local next = true
            local handle, vehicle = FindFirstPed()
            while next do
                if vehicle then
                    vehs = vehs + 1
                    debugPeds[vehicle] = vehicle
                end
                next, vehicle = FindNextPed(handle)
            end
            EndFindPed(handle)
            print("peds: " .. vehs)
            Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    local xoff = 0.1
    local yoff = 0.3
    local loop_count = 0

    -- LOCAL OPTIMIZATION
    local Wait = Wait
    local isDebugging = isDebugging
    local IsControlPressed = IsControlPressed
    local IsDisabledControlPressed = IsDisabledControlPressed
    local GetPlayerPed = GetPlayerPed
    local GetEntityCoords = GetEntityCoords
    local DoesEntityExist = DoesEntityExist
    local DrawText3D = DrawText3D
    local GetPedRelationshipGroupHash = GetPedRelationshipGroupHash
    local GetDisplayNameFromVehicleModel = GetDisplayNameFromVehicleModel
    local GetEntityModel = GetEntityModel
    local GetVehicleBodyHealth = GetVehicleBodyHealth
    local GetVehicleEngineHealth = GetVehicleEngineHealth
    local GetEntityMaxHealth = GetEntityMaxHealth
    local GetVehicleNumberPlateText = GetVehicleNumberPlateText
    local GetEntitySpeed = GetEntitySpeed
    local IsHornActive = IsHornActive
    local OverrideVehHorn = OverrideVehHorn
    local GetVehicleHornHash = GetVehicleHornHash
    local isDebuggingAdvanced = isDebuggingAdvanced
    local GetWorldPositionOfEntityBone = GetWorldPositionOfEntityBone
    local GetEntityBoneIndexByName = GetEntityBoneIndexByName
    local GetGroundZFor_3dCoord = GetGroundZFor_3dCoord
    local DrawMarker = DrawMarker
    local GetEntityHeading = GetEntityHeading
    local GetVehiclePedIsIn = GetVehiclePedIsIn
    local GetVehicleMaxNumberOfPassengers = GetVehicleMaxNumberOfPassengers
    local GetLandingGearState = GetLandingGearState
    local GetInteriorFromEntity = GetInteriorFromEntity
    local GetRoomKeyFromEntity = GetRoomKeyFromEntity
    local GetInteriorGroupId = GetInteriorGroupId
    local GetInstanceId = GetInstanceId
    local GetEntityMatrix = GetEntityMatrix
    local GetEntityRotation = GetEntityRotation
    local DrawScreenText = DrawScreenText
    local IsPedInAnyVehicle = IsPedInAnyVehicle
    local GetVehicleAcceleration = GetVehicleAcceleration
    local GetVehicleAlarmTimeLeft = GetVehicleAlarmTimeLeft
    local GetVehicleClutch = GetVehicleClutch
    local GetVehicleCurrentGear = GetVehicleCurrentGear
    local GetVehicleCurrentRpm = GetVehicleCurrentRpm
    local GetVehicleDashboardSpeed = GetVehicleDashboardSpeed
    local GetVehicleEngineTemperature = GetVehicleEngineTemperature
    local GetVehicleFuelLevel = GetVehicleFuelLevel
    local GetVehicleGravityAmount = GetVehicleGravityAmount
    local tostring = tostring
    local GetVehicleHandbrake = GetVehicleHandbrake
    local GetVehicleHighGear = GetVehicleHighGear
    local GetVehicleIndicatorLights = GetVehicleIndicatorLights
    local GetVehicleNextGear = GetVehicleNextGear
    local GetVehicleNumberOfWheels = GetVehicleNumberOfWheels
    local GetVehicleOilLevel = GetVehicleOilLevel
    local GetVehicleSteeringAngle = GetVehicleSteeringAngle
    local GetVehicleSteeringScale = GetVehicleSteeringScale
    local GetVehicleTurboPressure = GetVehicleTurboPressure
    local IsIplActive = IsIplActive
    local RequestIpl = RequestIpl
    -- END LOCAL OPTIMIZATION

    while true do
        loop_count = loop_count + 1
        if loop_count > 1 then
            Wait(0)
            loop_count = 0
        end
        if isDebugging() then
            local controls = {}
            local str = ""
            for i=0,255 do
                if IsControlPressed(0, i) then
                    str = str .. i .. " "
                    controls[i] = true
                elseif IsDisabledControlPressed(0, i) then
                    str = str .. "d" .. i .. " "
                    controls[i] = true
                end
            end

            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped, false)

            if loop_count % 2 == 0 then
                for k,v in next, debugPeds do
                    if not DoesEntityExist(v) then
                        debugPeds[k] = nil
                    end
                    if debugPeds[k] ~= nil then
                        local vehPos = GetEntityCoords(v, false)
                        local dist = #(vehPos - pos)
                        if dist < 20 then
                            DrawText3D("rel_group: " .. GetPedRelationshipGroupHash(v), vehPos.x, vehPos.y, vehPos.z)
                        end
                    end
                end
                for k,v in next, debugVehs do
                    if not DoesEntityExist(v) then
                        debugVehs[k] = nil
                    end
                    if debugVehs[k] ~= nil then
                        local vehPos = GetEntityCoords(v, false)
                        local dist = #(vehPos - pos)
                        if dist < 20 then
                            local vehModel = GetDisplayNameFromVehicleModel(GetEntityModel(v))
                            local vehBHealth = GetVehicleBodyHealth(v)
                            local vehEHealth = GetVehicleEngineHealth(v)
                            local vehMHealth = GetEntityMaxHealth(v)
                            local plateText = GetVehicleNumberPlateText(v)
                            local vehSpeed = GetEntitySpeed(v)
                            local vehUsingHorn = IsHornActive(v)
                            local vehStr = "~n~"
                            OverrideVehHorn(v, false, 1766676233)
                            local vehHorn = GetVehicleHornHash(v)
                            -- train horn: -1452195880
                            -- bus horn: 1766676233
                            vehStr = vehStr .. "horn: " .. vehHorn
                            if vehUsingHorn then
                                vehStr = vehStr .. " doot"
                            end
                            DrawText3D(("model: %s plate: %s~n~ehp: %i bhp: %i mhp: %i spd: %i%s"):format(vehModel, plateText, math.floor(vehEHealth), math.floor(vehBHealth), math.floor(vehMHealth), math.floor(vehSpeed), vehStr), vehPos.x, vehPos.y, vehPos.z + 1.5, 1.0)
                        end
                        if dist < 20 and isDebuggingAdvanced() then
                            if true then
                                local bones = {
                                    "headlight_l",
                                    "headlight_r",
                                    "taillight_l",
                                    "taillight_r",
                                    "indicator_lf",
                                    "indicator_rf",
                                    "indicator_lr",
                                    "indicator_rr",
                                    "brakelight_l",
                                    "brakelight_r",
                                    "brakelight_m",
                                    "reversinglight_l",
                                    "reversinglight_r",
                                    "extralight_1",
                                    "extralight_2",
                                    "extralight_3",
                                    "extralight_4",
                                    "extralight_5",
                                    "extralight_6",
                                    "extralight_7",
                                    "extralight_8",
                                    "reversinglight_r",
                                    "reversinglight_r",
                                }
                                for _bid,_bname in next, bones do
                                    local _bpos = GetWorldPositionOfEntityBone(v, GetEntityBoneIndexByName(v, _bname))
                                    DrawText3D("~w~o", _bpos.x, _bpos.y, _bpos.z)
                                end
                            end
                            if true then
                                local bones = {
                                    "wheel_lf",
                                    "wheel_rf",
                                    "wheel_lm1",
                                    "wheel_rm1",
                                    "wheel_lm2",
                                    "wheel_rm2",
                                    "wheel_lm3",
                                    "wheel_rm3",
                                    "wheel_lr",
                                    "wheel_rr",
                                }
                                for _bid,_bname in next, bones do
                                    local _bpos = GetWorldPositionOfEntityBone(v, GetEntityBoneIndexByName(v, _bname))
                                    DrawText3D("~w~w", _bpos.x, _bpos.y, _bpos.z)
                                end
                            end
                            for i=1,20 do
                                local _bpos = GetWorldPositionOfEntityBone(v, GetEntityBoneIndexByName(v, "siren" .. i))
                                DrawText3D("~r~o", _bpos.x, _bpos.y, _bpos.z)
                            end
                            for i=1,4 do
                                local _bpos = GetWorldPositionOfEntityBone(v, GetEntityBoneIndexByName(v, "extralight_" .. i))
                                DrawText3D("~y~o", _bpos.x, _bpos.y, _bpos.z)
                            end
                            if true then
                                local _bpos = GetWorldPositionOfEntityBone(v, GetEntityBoneIndexByName(v, "attach_female"))
                                DrawText3D("~g~f", _bpos.x, _bpos.y, _bpos.z)
                            end
                            if true then
                                local _bpos = GetWorldPositionOfEntityBone(v, GetEntityBoneIndexByName(v, "attach_male"))
                                DrawText3D("~g~m", _bpos.x, _bpos.y, _bpos.z)
                            end
                            if true then
                                local bones = {
                                    "rudder_l",
                                    "rudder_r",
                                    "rudder_2",
                                    "aileron_l",
                                    "aileron_r",
                                    "airbrake_l",
                                    "airbrake_r",
                                    "wing_l",
                                    "wing_r",
                                    "wing_lr",
                                    "wing_rr",
                                    "engine_l",
                                    "engine_r",
                                    "nozzles_f",
                                    "nozzles_r",
                                    "afterburner",
                                    "wingtip_1",
                                    "wingtip_2",
                                }
                                for _bid,_bname in next, bones do
                                    local _bpos = GetWorldPositionOfEntityBone(v, GetEntityBoneIndexByName(v, _bname))
                                    DrawText3D("~b~T", _bpos.x, _bpos.y, _bpos.z)
                                end
                            end
                            if true then
                                local bones = {
                                    "frame_1",
                                    "frame_2",
                                    "frame_3",
                                    "frame_pickup_1",
                                    "frame_pickup_2",
                                    "frame_pickup_3",
                                    "frame_pickup_4",
                                }
                                for _bid,_bname in next, bones do
                                    local _bpos = GetWorldPositionOfEntityBone(v, GetEntityBoneIndexByName(v, _bname))
                                    DrawText3D("~r~" .. _bname, _bpos.x, _bpos.y, _bpos.z)
                                end
                            end
                        end
                    end
                end
            end

            if isDebuggingAdvanced() then
                for iy=-5,5,2 do
                    for ix=-5,5,2 do
                        local _x = pos.x + ix
                        local _y = pos.y + iy
                        local _b, _z = GetGroundZFor_3dCoord(_x, _y, 2000.0)
                        DrawMarker(1, _x, _y, _z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 255, 0, 150)
                    end
                end
            end

            local heading = GetEntityHeading(ped)
            local speed = GetEntitySpeed(ped)
            local veh = GetVehiclePedIsIn(ped, false)
            local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
            local seats = GetVehicleMaxNumberOfPassengers(veh)
            local gear = GetLandingGearState(veh)
            local interior = GetInteriorFromEntity(ped)
            local room = GetRoomKeyFromEntity(ped)
            local interiorGroup = GetInteriorGroupId(interior)
            local instance = GetInstanceId()
            -- GetEntityMatrix(entity) Vector3* rightVector, Vector3* forwardVector, Vector3* upVector, Vector3* position);
            local forwardVec, rightVec, upVec, posVec = GetEntityMatrix(veh)
            local rot = GetEntityRotation(veh, 0)

            local n = 0
            DrawScreenText(xoff, yoff + 0.035 * n, 0.6, ("controls: %s"):format(str), 255, 0, 0, 255); n = n + 1;
            DrawScreenText(xoff, yoff + 0.035 * n, 0.6, ("x: %i y: %i z: %i h: %i"):format(math.floor(pos.x), math.floor(pos.y), math.floor(pos.z), math.floor(heading)), 255, 0, 0, 255); n = n + 1;
            DrawScreenText(xoff, yoff + 0.035 * n, 0.6, ("speed: %i veh: %s seats: %i gear: %i"):format(math.floor(speed), vehName, seats, gear), 255, 0, 0, 255); n = n + 1;
            DrawScreenText(xoff, yoff + 0.035 * n, 0.6, ("interior: %i (%i) room: %i instance: %i"):format(interior, interiorGroup, room, instance), 255, 0, 0, 255); n = n + 1;
            DrawScreenText(xoff, yoff + 0.035 * n, 0.6, ("rv: %s fv: %s uv: %s pv: %s"):format(tostring(rightVec), tostring(forwardVec), tostring(upVec), tostring(posVec)), 255, 0, 0, 255); n = n + 1;
            local l = -4.5
            local lz = -1.25
            DrawMarker(1, pos.x + forwardVec.x * l + upVec.x * lz, pos.y + forwardVec.y * l + upVec.y * lz, pos.z + forwardVec.z * l + upVec.z * lz, 0, 0, 0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 255)

            if IsPedInAnyVehicle(ped, false) and isDebuggingAdvanced() then
                DrawScreenText(xoff, yoff + 0.035 * (n), 0.6, ("acceleration: %f alarm: %i"):format(GetVehicleAcceleration(veh), GetVehicleAlarmTimeLeft(veh)), 255, 0, 0, 255); n = n + 1;
                DrawScreenText(xoff, yoff + 0.035 * (n), 0.6, ("clutch: %f gear: %i"):format(GetVehicleClutch(veh), GetVehicleCurrentGear(veh)), 255, 0, 0, 255); n = n + 1;
                DrawScreenText(xoff, yoff + 0.035 * (n), 0.6, ("rpm: %f dashspeed: %f"):format(GetVehicleCurrentRpm(veh), GetVehicleDashboardSpeed(veh)), 255, 0, 0, 255); n = n + 1;
                DrawScreenText(xoff, yoff + 0.035 * (n), 0.6, ("temp: %f fuel: %f"):format(GetVehicleEngineTemperature(veh), GetVehicleFuelLevel(veh)), 255, 0, 0, 255); n = n + 1;
                DrawScreenText(xoff, yoff + 0.035 * (n), 0.6, ("grav: %f handbrake: %s"):format(GetVehicleGravityAmount(veh), tostring(GetVehicleHandbrake(veh))), 255, 0, 0, 255); n = n + 1;
                DrawScreenText(xoff, yoff + 0.035 * (n), 0.6, ("higear: %f indicators: %i"):format(GetVehicleHighGear(veh), GetVehicleIndicatorLights(veh)), 255, 0, 0, 255); n = n + 1;
                DrawScreenText(xoff, yoff + 0.035 * (n), 0.6, ("nextgear: %i wheels: %i"):format(GetVehicleNextGear(veh), GetVehicleNumberOfWheels(veh)), 255, 0, 0, 255); n = n + 1;
                DrawScreenText(xoff, yoff + 0.035 * (n), 0.6, ("oil: %f steer: %f"):format(GetVehicleOilLevel(veh), GetVehicleSteeringAngle(veh)), 255, 0, 0, 255); n = n + 1;
                DrawScreenText(xoff, yoff + 0.035 * (n), 0.6, ("steerscale: %f turbopressure: %f"):format(GetVehicleSteeringScale(veh), GetVehicleTurboPressure(veh)), 255, 0, 0, 255); n = n + 1;
            end
            if IsPedOnFoot(ped) then
                DrawScreenText(xoff, yoff + 0.035 * (n), 0.6, ("fall: %s jump: %s vspeed: %f onveh: %s"):format(IsPedFalling(ped), IsPedJumping(ped), (GetEntitySpeedVector(ped, false)).z, IsPedOnVehicle(ped)), 255, 0, 0, 255); n = n + 1;
                DrawScreenText(xoff, yoff + 0.035 * (n), 0.6, ("ragdoll: %s run: %s walk: %s sprnt: %s"):format(IsPedRagdoll(ped), IsPedRunning(ped), IsPedWalking(ped), IsPedSprinting(ped)), 255, 0, 0, 255); n = n + 1;
            end
            if not IsIplActive("prologue01") then
                RequestIpl("prologue01")
    			RequestIpl("prologue01c")
    			RequestIpl("prologue01d")
    			RequestIpl("prologue01e")
    			RequestIpl("prologue01f")
    			RequestIpl("prologue01g")
    			RequestIpl("prologue01h")
    			RequestIpl("prologue01i")
    			RequestIpl("prologue01j")
    			RequestIpl("prologue01k")
    			RequestIpl("prologue01z")
    			RequestIpl("prologue02")
    			RequestIpl("prologue03")
    			RequestIpl("prologue03b")
    			RequestIpl("prologue04")
    			RequestIpl("prologue04b")
    			RequestIpl("prologue05")
    			RequestIpl("prologue05b")
    			RequestIpl("prologue06")
    			RequestIpl("prologue06b")
    			RequestIpl("prologue06_int")
    			RequestIpl("prologuerd")
    			RequestIpl("prologuerdb ")
    			RequestIpl("prologue_DistantLights")
    			RequestIpl("prologue_LODLights")
    			RequestIpl("prologue_m2_door")
            end
        end
    end
end)
