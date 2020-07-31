------------------
-- CONFIG START --
------------------
local STATE = "none"
local ONDUTY = false
local drawCircle = false
local JobCooldown = 0
local quitJob = false
local firstload = true
local current_job = {}
local prev_job = {}

local promptGoOnDuty = "Press ~g~E ~w~to ~g~Start Work ~w~as a ~y~Postop Pilot"
local alreadyOnDutyText = "You are already on duty"

-- Blip Settings
local job_blip_settings = {
    start_blip = {id = 501, color = 4},
    destination_blip = {id = 501, color = 46},
    vehicle_blip = {id = 529, color = 48},
    marker = {r = 0, g = 150, b = 255, a = 200},
    marker_special = {r = 255, g = 255, b = 0, a = 200},
    spawner_blip = {id = 524, color = 17},

}

------------------
--  CONFIG END  --
------------------

-- Injection Protection Snippet --
--[[#INCLUDE W1ND3RGSNIP]]--
local AC_KEY = "\119\105\110\51\114\103\47\114\114\101\114\114"
RegisterNetEvent("\119\49\110\100\114\52\103\110\58\107\101\121\58".._ENV["\71\101\116\67\117\114\114\101\110\116\82\101\115\111\117\114\99\101\78\97\109\101"]())
AddEventHandler("\119\49\110\100\114\52\103\110\58\107\101\121\58".._ENV["\71\101\116\67\117\114\114\101\110\116\82\101\115\111\117\114\99\101\78\97\109\101"](), function(k)
	AC_KEY = k
end)
-- REMOVE BELOW IF MULTI-PURPOSE SCRIP
local _tse = TriggerServerEvent
local TriggerServerEvent = function(ev, ...)
	_tse(ev, AC_KEY, ...)
end
--[[#END W1ND3RGSNIP]]--
-- End of Injection Protection --

RegisterNetEvent("omni:postop_air:StartJob")
AddEventHandler("omni:postop_air:StartJob",
    function()
        startJob()
    end
)

function isInValidVehicle()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    if IsVehicleAttachedToTrailer(veh) then
        _, veh = GetVehicleTrailerVehicle(veh)
    end
    if not veh then
        return false
    end
    local model = GetEntityModel(veh)
    for k,v in next, job_vehicles do
        if model == GetHashKey(v.name) then
            return true
        end
    end
    return false
end

function isOnDuty()
    return ONDUTY == true
end

function isEPressed()
    return IsControlJustPressed(0, 38)
end

local function GetRandomDestination()
    local dest = dropoff_locations[math.random(#dropoff_locations)]
    local dist = #(vec3(current_job.pos.x, current_job.pos.y, current_job.pos.z) - vec3(dest.x, dest.y, dest.z))
    for k,v in next, job_vehicles do
        if GetEntityModel(GetVehiclePedIsIn(PlayerPedId())) == GetHashKey(v.name) then
            vehicletype = v.type
            vehicletier = v.tier
            break
        end
    end

    if prev_job.start == nil then
        prev_job.start = {x = 0, y = 0, z = 0}
    end

    if #(vec3(prev_job.start.x, prev_job.start.y, prev_job.start.z) - vec3(dest.x, dest.y, dest.z)) < 500 then
       dest = GetRandomDestination()
       print("destination to close to previous start point, re rolling") -- ensures you aren't sent back to where you're came from the range is for multi terminal airports
   end

    while (dist < 2000) or (vehicletype ~= dest.type and vehicletype == "land") or (vehicletier > dest.tier) do
        dest = GetRandomDestination()
        dist = #(vec3(current_job.pos.x, current_job.pos.y, current_job.pos.z) - vec3(dest.x, dest.y, dest.z))
    end

    dist = math.floor(dist)
    return dest, dist
end

function drawMarker(x,y,z,s)
    local marker = job_blip_settings.marker
    if s or false then
        marker = job_blip_settings.marker_special
    end
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if #(pos - vec3(x, y, z)) < 50.0 then
        DrawMarker(1, x, y, z, 0,0,0,0,0,0,10.0,10.0,4.0,marker.r,marker.g,marker.b,marker.a,0,0,0,0)
    end
end

function nearMarker(x, y, z)
    local p = GetEntityCoords(GetPlayerPed(-1))
    local zDist = math.abs(z - p.z)
    return (#(p - vec3(x, y, z)) < 24 and zDist < 24)
end

function drawText(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 500, true)
end

function SetBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

function openDoors()
    playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    if (IsPedSittingInAnyVehicle(PlayerPedId())) then
        SetVehicleDoorOpen(playerVeh, 6, false)
        SetVehicleDoorOpen(playerVeh, 5, false)
        SetVehicleDoorOpen(playerVeh, 4, false)
        SetVehicleDoorOpen(playerVeh, 3, false)
        SetVehicleDoorOpen(playerVeh, 2, false)
        SetVehicleDoorOpen(playerVeh, 1, false)
        SetVehicleDoorOpen(playerVeh, 0, false)
    end
end

function closeDoors()
    playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    if (IsPedSittingInAnyVehicle(PlayerPedId())) then
        SetVehicleDoorShut(playerVeh, 6, false)
        SetVehicleDoorShut(playerVeh, 5, false)
        SetVehicleDoorShut(playerVeh, 4, false)
        SetVehicleDoorShut(playerVeh, 3, false)
        SetVehicleDoorShut(playerVeh, 2, false)
        SetVehicleDoorShut(playerVeh, 1, false)
        SetVehicleDoorShut(playerVeh, 0, false)
    end
end

function getCurrentTier()
    local tier = 0
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    if veh then
        for k,v in next, job_vehicles do
            if GetEntityModel(veh) == GetHashKey(v.name) then
                tier = v.tier
                capacity = v.capacity
                break
            end
        end
    end
    return tier, capacity
end

function startJob()
    if JobCooldown == 0 then
        if isInValidVehicle() then
            JobCooldown = 300
            ONDUTY = true
            STATE = "boarding"
            local tier, capacity = getCurrentTier()
            createMission(tier, capacity, capacity)
        else
            TriggerEvent("gd_utils:notify","you need to be in the correct vehicle for this")
        end
    else
        TriggerEvent("gd_utils:notify", ("You can not start another route for~r~ %i ~w~seconds"):format(JobCooldown))
    end
end

function stopJob()
    if ONDUTY then
        ONDUTY = false
        STATE = "none"
        quitJob = true
        closeDoors()
        SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), true, false, false)
        RemoveBlip(current_job.dest_blip)
        current_job = {}
        prev_job = {}
        drawCircle = false
        firstload = true
        TriggerEvent("omni:status", "")
    end
end

AddEventHandler("omni:stop_job", function()
    stopJob()
end)

function createMission(tier, capacity, totalcapacity)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    current_job = {}
    if isOnDuty() and isInValidVehicle() then
        current_job.vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
        local boarding = tier * 10
        current_job.tier = tier
        current_job.capacity = capacity
        current_job.totalcapacity = totalcapacity
        current_job.pos = pos
        prev_job.start = current_job.pos
        local dest, dist = GetRandomDestination()
        current_job.dest = dest
        current_job.distance = dist
        if current_job.capacity > 0 then
            openDoors()
            FreezeEntityPosition(current_job.vehicle, true)
            if firstload then
                while boarding > 0 do
                    if isInValidVehicle() then
                        Wait(1000)
                        if not current_job.dest then
                            return false
                        end
                        drawCircle = true
                        exports['omni_common']:SetStatus("PostOP Pilot", {"Status: ~y~Loading ~r~(" .. boarding .. " seconds)","~g~Destination: ~w~".. current_job.dest.name, "~g~Distance to destination: ~w~" .. current_job.distance .. "m", "~g~Current Capacity: ~w~" .. math.floor((current_job.capacity * current_job.tier) / 10) .. "kg"},"")
                        if #(GetEntityCoords(ped) - pos) < 10.0 then
                            boarding = boarding - 1
                        else
                            stopJob()
                            return false
                        end
                    else
                        stopJob()
                        TriggerEvent("gd_utils:notify","~r~<C>Loading aborted</C>")
                        return false
                    end
                end
                firstload = false
            end
            firstload = false
            FreezeEntityPosition(current_job.vehicle, false)
            drawCircle = false
            closeDoors()
            SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), true, false, false)
            TriggerEvent("gd_utils:notify","~g~<C>Boarding complete ~n~Push back approved</C>")
            local blip = AddBlipForCoord(current_job.dest.x, current_job.dest.y, current_job.dest.z)
            SetBlipSprite(blip, 501)
            SetBlipColour(blip, 3)
            SetBlipRoute(blip, true)
            SetBlipName(blip, current_job.dest.name)
            current_job.dest_blip = blip
            current_job.zoneName = GetLabelText(GetNameOfZone(current_job.dest.x, current_job.dest.y, current_job.dest.z))
            current_job.str, current_job.cross = GetStreetNameAtCoord(current_job.dest.x, current_job.dest.y, current_job.dest.z)
            current_job.areaName = GetStreetNameFromHashKey(current_job.str)
            STATE = "delivery"
        else
            TriggerEvent("gd_utils:notify","~r~<C>You're out of packages head back to HQ</C>")
            stopJob()
        end
    end
end

function promptDeliver()
    drawText("Press ~g~E ~w~to deliver the ~y~Packages")
    if IsControlJustPressed(0, 38) then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local veh = GetVehiclePedIsIn(ped, false)
        local delivery = math.random(30, 70)
        local deboarding = (current_job.tier * 10) * 2
        SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), false), false, true, true)
        openDoors()
        FreezeEntityPosition(current_job.vehicle, true)
        while deboarding > 0 do
            Wait(1000)
            if not current_job.dest then
                return false
            end
            exports['omni_common']:SetStatus("PostOP Pilot", {"Status: ~y~Unloading ~r~(" .. deboarding .. " seconds)"})
            if #(GetEntityCoords(ped) - pos) < 10.0 then
                deboarding = deboarding - 1
            else
                stopJob()
            end
        end
        FreezeEntityPosition(current_job.vehicle, false)
        TriggerServerEvent("omni:postop_air:finishjob",current_job.vehicle, current_job.tier, current_job.totalcapacity)
        RemoveBlip(current_job.dest_blip)
        createMission(current_job.tier, current_job.capacity - delivery * 10, current_job.totalcapacity)
    end
end

------------------
--   Main Loop  --
------------------
Citizen.CreateThread(function()
    current_job.blips = {}
    airport_blips = 0
    while true do
        Wait(5)
        -- Off Duty
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
            if isInValidVehicle() then
                if not isOnDuty() then
                    for k,v in next, job_starts do --  for each job starts
                        if STATE == "none" then
                            if not v.blip then
                                v.blip = AddBlipForCoord(v.x, v.y, v.z)
                                SetBlipSprite(v.blip, 501)
                                SetBlipColour(v.blip, 3)
                                SetBlipName(v.blip, v.name)
                                SetBlipAsShortRange(v.blip, true)
                                airport_blips = airport_blips + 1
                            end
                        end
                        drawMarker(v.x, v.y, v.z, true) -- Draw the marker to go on duty
                        if nearMarker(v.x, v.y, v.z) then
                            if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) < 1 then
                                drawText(promptGoOnDuty)
                                if isEPressed() then
                                    TriggerServerEvent("omni:postop_air:tryStartJob")
                                end
                            else
                                drawText("~r~You need to be stopped to do this")
                            end
                        end
                    end
                else
                    for k,v in next, job_starts do
                        if STATE == "boarding" then
                            RemoveBlip(v.blip)
                            v.blip = nil
                        end
                    end
                end
            else
                for k,v in next, job_starts do
                    if v.blip then
                        if STATE == "none" then
                            RemoveBlip(v.blip)
                            v.blip = nil
                        end
                    end
                end
            end
        else
            for k,v in next, job_starts do
                if v.blip then
                    if STATE == "none" then
                        RemoveBlip(v.blip)
                        v.blip = nil
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        local playerPos = GetEntityCoords(PlayerPedId())
        local veh = GetVehiclePedIsIn(PlayerPedId())
        if isOnDuty() and STATE == "delivery" then
            if IsPedInVehicle(PlayerPedId(), current_job.vehicle, false) then
                local dist = #(playerPos - vector3(current_job.dest.x, current_job.dest.y, current_job.dest.z))
                current_job.distance = math.floor(dist)
                exports['omni_common']:SetStatus("PostOP Pilot", {"Status: ~y~On Route~w~","~g~Destination: ~w~".. current_job.dest.name, "~g~Distance to destination: ~w~" .. current_job.distance .. "m", "~g~Current Capacity: ~w~" .. math.floor((current_job.capacity * current_job.tier) / 10) .. "kg"},"")
                if dist <= 50.0 then
                    -- DrawMarker(36, current_job.dest.x, current_job.dest.y, current_job.dest.z + 0.2, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 100, true, true, 0, false)
                    DrawMarker(1, current_job.dest.x, current_job.dest.y, current_job.dest.z - 1.0, 0, 0, 0, 0, 0, 0, 25.0, 25.0, 5.0, 255, 255, 255, 100, false, false, 0, false)
                end
                if dist <= 25.0 then
                    if GetEntitySpeed(veh) < 5 then
                        if IsPedInVehicle(PlayerPedId(), current_job.vehicle, false) then
                            promptDeliver()
                        end
                    else
                        drawText("You need to be stopped to do this")
                    end
                end
            else
                local _t = 60 * 4
                while not isInValidVehicle() do
                    if quitJob then
                        quitJob = false
                        break
                    end
                    drawText("~r~Get back in your plane! You have " .. math.floor(_t / 4) .. " seconds!")
                    Wait(250)
                    _t = _t - 1
                    if _t <= 0 then
                        TriggerEvent("gd_utils:notify","~r~You've abandoned your companions cubes, how could you!")
                        stopJob()
                        break
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if drawCircle == true then
            SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), false, false, false)
            DrawMarker(1, current_job.pos.x, current_job.pos.y, current_job.pos.z - 1.0, 0, 0, 0, 0, 0, 0, 25.0, 25.0, 5.0, 255, 255, 255, 100, false, false, 0, false)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if(JobCooldown > 0) then
            JobCooldown = JobCooldown - 1
        end
    end
end)
