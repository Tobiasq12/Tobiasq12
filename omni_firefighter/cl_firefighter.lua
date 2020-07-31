
local promptGoOnDuty = "Press ~g~E ~w~to ~g~Start Work ~w~as a ~y~FireFighter"

local STATE = "none"
local ONDUTY = false
local JobCooldown = 0
local zone_range = 0
local totalcallouts = 0
local totalWater = 1000
local current_job = {}
local current_location_pool = {}

local DEBUGGING_SCRIPT = false

local job_blip_settings = {
    start_blip = {id = 648, color = 1},
    destination_blip = {id = 648, color = 46},
    dropoff_blip = {id = 538, color = 2},
    marker = {r = 0, g = 150, b = 255, a = 200},
    marker_special = {r = 255, g = 255, b = 255, a = 200},
}

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

function Lerp(a, b, t)
	return a + (b - a) * t
end

CreateThread(function()
    if DEBUGGING_SCRIPT then
        InitializeStartBlips()
        TriggerServerEvent("omni:firefighter:dutycheck", "GSD", 5)
    end
end)

RegisterNetEvent("omni:fire:startJob")
AddEventHandler("omni:fire:startJob",
    function(region, tier)
        startJob(region, tier)
    end
)

AddEventHandler("omni:stop_job", function()
    stopJob()
end)

function startJob(region, tier)
    if JobCooldown == 0 then
        if ONDUTY ~= true then
            TriggerEvent("gd_utils:image_notify", "CHAR_CALL911", "CHAR_CALL911", "~o~Fire Dispatcher", "~g~On duty", "You are now marked as on-duty and available for calls")
            currentWater = 1000
            JobCooldown = 300
            ONDUTY = true
            STATE = "available"
            GiveWeaponToPed(PlayerPedId(), "weapon_fireextinguisher", 1000, false, true)
            SetPedInfiniteAmmo(PlayerPedId(), true, "weapon_fireextinguisher")
            HideStartBlips()
            current_job = {}
            if region then
                if ZONES[region] then
                    current_location_pool = {}
                    TriggerEvent("gd_utils:image_notify", "CHAR_CALL911", "CHAR_CALL911", "~o~Fire Region", "~y~" .. ZONES[region]["name"],
                        [[]] .. ZONES[region]["description"]
                    )
                    if ZONES[region]["regions"] then
                        for _, subregion in next, ZONES[region]["regions"] do
                            if ZONE_LOCATIONS[subregion] then
                                for _, location in next, ZONE_LOCATIONS[subregion] do
                                    current_location_pool[#current_location_pool + 1] = location
                                end
                            end
                        end
                    elseif ZONE_LOCATIONS[region] then
                        for _, location in next, ZONE_LOCATIONS[region] do
                            current_location_pool[#current_location_pool + 1] = location
                        end
                    end
                end
                regionTier = tier
            end
            local numStops = #current_location_pool
            -- print(region, "#", numStops)
            TriggerEvent("omni:status", "~r~Firefighter~w~", {"Status: ~g~Available", "Current Streak:  " .. totalcallouts})
        end
    else
        TriggerEvent("gd_utils:notify", ("You can not go on duty for~r~ %i ~w~seconds"):format(JobCooldown))
    end
end

function stopJob()
    if ONDUTY then
        TriggerEvent("gd_utils:image_notify", "CHAR_CALL911", "CHAR_CALL911", "~o~Fire Dispatcher", "~r~Off duty", "You are now marked as off-duty")
        DeleteObject(current_job.vehicle)
        RemoveWeaponFromPed(PlayerPedId(),  "weapon_fireextinguisher")
        SetPedInfiniteAmmo(PlayerPedId(), false, "weapon_fireextinguisher")
        RemoveBlip(current_job.dest_blip)
        if STATE == "fire" then
            RemoveParticleFxInRange(current_job.dest.x, current_job.dest.y, current_job.dest.z, zone_range)
            for k,v in next, zone_fires do
                RemoveBlip(v.blip)
                StopFireInRange(v.x, v.y, v.z, zone_range)
            end
            for k, v in next, zone_vehicles do
                if DoesEntityExist(v) then
                    DeleteObject(v)
                    DeleteVehicle(v)
                end
            end
        end
        for k, v in next, fire_station_hydrants do
            if v.blip then
                RemoveBlip(v.blip)
            end
        end
        current_job = {}
        ONDUTY = false
        STATE = "none"
        TriggerEvent("omni:timer:stop")
        TriggerEvent("omni:status", "")
        ShowStartBlips()
    end
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

function isEPressed()
    return IsControlJustPressed(0, 38)
end

function checkMarker(x,y,z,s)
    local marker = job_blip_settings.marker
    if s or false then
        marker = job_blip_settings.marker_special
    end
    local pos = GetEntityCoords(PlayerPedId())
    local dist = #(pos - vec3(x, y, z))
    if dist < 50.0 then
        DrawMarker(1, x, y, z - 1.0,0,0,0, 0,0,0, s, s, 0.5, marker.r,marker.g,marker.b, marker.a)
        if dist < 2.0 then
            return true
        end
    end
    return false
end

local function GetRandomDestination()
    local dest = current_location_pool[math.random(#current_location_pool)]
    local pos = GetEntityCoords(PlayerPedId())
    local dist = #(vec3(pos.x, pos.y, pos.z) - vec3(dest.x, dest.y, dest.z))
    while dist < 500 do
        dest = GetRandomDestination()
        dist = #(vec3(pos.x, pos.y, pos.z) - vec3(dest.x, dest.y, dest.z))
    end
    dist = math.floor(dist)
    return dest, dist
end

function GetFireType(dest)
    for k, v in next, current_location_pool do
        if dest.x == v.x and dest.y == v.y and dest.z == v.z then
            fireType = v.type
            return fireType
        end
    end
end

function GetVehicleTarget(dest)
    for k, v in next, current_location_pool do
        if dest.x == v.x and dest.y == v.y and dest.z == v.z then
            vehicleTarget = v.amount
            return vehicleTarget
        end
    end
end

local function EnsureParticleAsset(asset)
    if not HasNamedPtfxAssetLoaded(asset) then
        RequestNamedPtfxAsset(asset)
        while not HasNamedPtfxAssetLoaded(asset) do
            Wait(0)
        end
    end
    UseParticleFxAssetNextCall(asset)
end

local function StartFire(dest, fireType, isMultiplayer)
    isVehicleFire = false
    totalfires = math.random(20, 50)
    vehicleTarget = 0
    min_range = -3
    max_range = 3
    firecount = 0
    zone_fires = {}
    zone_vehicles = {}
    if fireType == "Vehicle fire" or fireType == "Multi-vehicle fire" then
        if fireType == "Vehicle fire" then
            vehicleTarget = 1
            min_range = -5
            max_range = 5
        elseif fireType == "Multi-vehicle fire" then
            vehicleTarget = 2
            min_range = -5
            max_range = 5
        end
        isVehicleFire = true
        totalVehicles = 0
        while true do
            Wait(1)
            if totalVehicles < vehicleTarget then
                vehicle = "rhapsody"
                local vehicle = GenerateRandomVehicle({"Vans", "Sports"})
                -- print(vehicle)
                -- , "Super", "Sports Classic", "Sports"
                while not HasModelLoaded(vehicle) do
                   Wait(1)
                   RequestModel(vehicle)
                end
                -- job_vehicle = CreateObjectNoOffset(vehicle, current_job.dest.x + math.random(min_range, max_range), current_job.dest.y + math.random(min_range, max_range), current_job.dest.z, false, false, false)
                -- CreateObjectNoOffset(modelHash, x, y, z, isNetwork, p5, dynamic)
                job_vehicle = CreateVehicle(vehicle, current_job.dest.x + math.random(min_range, max_range), current_job.dest.y + math.random(min_range, max_range), current_job.dest.z, 0.0, false, false)
                SetEntityInvincible(job_vehicle, true)
                SetVehicleDoorsLocked(job_vehicle, 2)
                DecorSetBool(job_vehicle, "omni_nocleanup", true)
                table.insert(zone_vehicles, job_vehicle)
                totalVehicles = totalVehicles + 1
            else
                -- print("total vehicles generated")
                break
            end
        end
    end


    while true do
        Wait(1)
        local zone = dest
        zone_range = 100.0
        fires = {}
        -- Make sure the position is never outside the zone
        local function gen()
            fires.x = zone.x + math.random(min_range, max_range)
            fires.y = zone.y + math.random(min_range, max_range)
            l, fires.z = GetGroundZAndNormalFor_3dCoord(fires.x, fires.y, zone.z)
            if fires.z == 0 or fires.z == nil or fires.z <= (zone.z - 2.0) then -- make sure the fire is within the reach of what was set if the get ground function fails
                -- print("fire z: " .. fires.z)
                fires.z = zone.z
                -- print("setting fire z to zone z")
            end
            firecount = firecount + 1
            local dist = #(vector3(fires.x, fires.y, fires.z) - vector3(zone.x, zone.y, zone.z))
            if dist > zone_range then
                gen()
            end
        end
        gen()
        if #zone_fires <= totalfires then
            table.insert(zone_fires, fires)
        else
            -- print("hit required total fires")
            break
        end
    end

    for k, fires in next, zone_fires do
        fires.fire = StartScriptFire(fires.x, fires.y, fires.z, 25, false)

        issmoking = math.random(1,2)
        if issmoking == 1 then
            EnsureParticleAsset("core")
            fires.smoke = StartParticleFxLoopedAtCoord(
                "ent_amb_smoke_scrap" --[[ string ]],
                fires.x or 0.0 --[[ number ]],
                fires.y or 0.0 --[[ number ]],
                fires.z or 0.0 --[[ number ]],
                xr or 0.0 --[[ number ]],
                yr or 0.0 --[[ number ]],
                zr or 0.0 --[[ number ]],
                scale or 1.0 --[[ number ]],
                xa or false --[[ boolean ]],
                ya or false --[[ boolean ]],
                za or false --[[ boolean ]]
            )
            if DEBUGGING_SCRIPT then
                print("smoke #: " .. fires.smoke)
            end
        end
        if not fires.blip then
            blip = AddBlipForCoord(fires.x, fires.y, fires.z)
            SetBlipSprite(blip, job_blip_settings.destination_blip.id)
            SetBlipColour(blip, job_blip_settings.destination_blip.color)
            exports['omni_common']:SetBlipName(blip, "Fire")
            fires.blip = blip
        end
        if DEBUGGING_SCRIPT then
            print("started fire # ".. fires.fire .. " at: x = " .. fires.x .." y = " .. fires.y .. " z = ".. fires.z)
        end
    end
    STATE = "fire"
    if DEBUGGING_SCRIPT then
        print("Changing state to fire")
    end
end

function createMission()
    if isInValidVehicle() then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        current_job = {}
        current_job.player_vehicle = GetEntityModel(GetVehiclePedIsIn(PlayerPedId()))
        current_job.pos = pos
        dest, dist = GetRandomDestination()
        current_job.dest = dest
        current_job.distance = dist
        current_job.zoneName = GetLabelText(GetNameOfZone(current_job.dest.x, current_job.dest.y, current_job.dest.z))
        current_job.str, current_job.cross = GetStreetNameAtCoord(current_job.dest.x, current_job.dest.y, current_job.dest.z)
        current_job.areaName = GetStreetNameFromHashKey(current_job.str)
        current_job.dest_blip = AddBlipForCoord(current_job.dest.x, current_job.dest.y, current_job.dest.z)
        fireType = GetFireType(current_job.dest)
        TriggerEvent("gd_utils:image_notify", "CHAR_CALL911", "CHAR_CALL911", "~o~Fire Dispatcher", "~o~Emergency Call", "Reports sightings of a ".. fireType .." respond to ~y~" .. current_job.areaName .. "~w~ in ~y~" .. current_job.zoneName)
        SetBlipRoute(current_job.dest_blip, true)
        StartFire(current_job.dest, fireType, isMultiplayer)
    else
        TriggerEvent("gd_utils:notify", ("You need to be in a firetruck to receive callouts"))
    end
end

Citizen.CreateThread(function()
    local waitTime = 100
    if DEBUGGING_SCRIPT then
        waitTime = 10 -- needs to be low enough to draw the markers
    else
        waitTime = 100
    end
    while true do

        Wait(waitTime)
        if ONDUTY then
            local pos = GetEntityCoords(PlayerPedId())
            if STATE == "available" then
                if not (currentWater <= (totalWater / 2)) then
                    TriggerEvent("omni:status", "~r~Firefighter", {"Status: ~g~Available", "Current Streak:  " .. totalcallouts, "~blue~Water Tank~w~:  " .. currentWater.. " / " .. totalWater})
                else
                    TriggerEvent("omni:status", "~r~Firefighter", {"Status: ~g~Available", "Current Streak:  " .. totalcallouts, "~blue~Water Tank~w~:  " .. currentWater.. " / " .. totalWater, "~r~Visit a fire hydrant to refill the tank!~w~"})
                end
            elseif STATE == "fire" then
                local distance = #(vector3(pos.x, pos.y, pos.z) - vector3(current_job.dest.x, current_job.dest.y, current_job.dest.z))
                if DEBUGGING_SCRIPT then
                    DrawMarker(1, current_job.dest.x, current_job.dest.y, current_job.dest.z, 0, 0, 0, 0, 0, 0, zone_range * 2, zone_range * 2, 50.0, 255, 255, 255, 100)
                end
                if distance < zone_range then
                    SetBlipRoute(current_job.dest_blip, false)
                    currentfires = GetNumberOfFiresInRange(current_job.dest.x, current_job.dest.y, current_job.dest.z, zone_range)
                    TriggerEvent("omni:status", "~r~Firefighter", {"Status: ~y~On Scene", "Fires Remaining: " .. currentfires .. " (" .. math.floor((currentfires * 100) / totalfires) .. "%)", "~blue~Water Tank~w~:  " .. currentWater.. " / " .. totalWater})
                    if currentfires <= math.floor(totalfires * 0.30) then
                        TriggerEvent("gd_utils:image_notify", "CHAR_CALL911", "CHAR_CALL911", "~o~Fire Dispatcher", "~o~Emergency Call", "Callout complete, leave the scene")
                        RemoveBlip(current_job.dest_blip)
                        for k,v in next, zone_fires do
                            RemoveBlip(v.blip)
                            RemoveScriptFire(v.fire)
                            if DEBUGGING_SCRIPT then
                                print("removing fires: " .. v.fire)
                            end
                        end
                        if DEBUGGING_SCRIPT then
                            print("STATE changed to return")
                        end
                        STATE = "return"
                    end
                else
                    TriggerEvent("omni:status", "~r~Firefighter", {"Status: ~y~En Route", "Type: " .. fireType, "Distance: " .. math.floor(distance).. "m","~g~Area~w~: " .. current_job.zoneName .. " " .. "~g~Street~w~: ".. current_job.areaName, "~blue~Water Tank~w~:  " .. currentWater.. " / " .. totalWater})
                    if IsPedInVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId())) then
                        if GetEntityModel(GetVehiclePedIsIn(PlayerPedId())) ~= current_job.player_vehicle then
                            -- print("incorrect vehicle model")
                            stopJob()
                            TriggerEvent("gd_utils:notify", ("~r~you can only use a firetruck to get to the scene"))
                        end
                    end
                end
            elseif STATE == "return" then
                local distance = #(vector3(pos.x, pos.y, pos.z) - vector3(current_job.dest.x, current_job.dest.y, current_job.dest.z))
                if DEBUGGING_SCRIPT then
                    DrawMarker(1, current_job.dest.x, current_job.dest.y, current_job.dest.z, 0, 0, 0, 0, 0, 0, zone_range * 2, zone_range * 2, 50.0, 255, 255, 255, 100)
                end
                TriggerEvent("omni:status", "~r~Firefighter", {"Status: ~y~Leaving Scene", "~blue~Water Tank~w~:  " .. currentWater.. " / " .. totalWater})
                if distance > zone_range then
                    if isVehicleFire then
                        for k, v in next, zone_vehicles do
                            if DoesEntityExist(v) then
                                -- print(v)
                                SetModelAsNoLongerNeeded(v)
                                SetObjectAsNoLongerNeeded(v)
                                SetEntityAsNoLongerNeeded(v)
                                DeleteObject(v)
                                DeleteVehicle(v)
                            end
                        end
                    end
                    for k, fires in next, zone_fires do
                        if DoesParticleFxLoopedExist(fires.smoke) then
                            if DEBUGGING_SCRIPT then
                                print("Removing Smoke Particles: " .. fires.smoke)
                            end
                            RemoveParticleFx(fires.smoke, true)
                        else
                            if DEBUGGING_SCRIPT then
                                print("no particles found")
                            end
                        end
                    end
                    -- RemoveParticleFxInRange(current_job.dest.x, current_job.dest.y, current_job.dest.z, zone_range)
                    totalcallouts = totalcallouts + 1
                    TriggerServerEvent("omni:firefighter:finishcallout", regionTier, totalcallouts)
                    TriggerEvent("omni:status", "~r~Firefighter", {"Status: ~g~Available", "Current Streak:  " .. totalcallouts})
                    zone_vehicles = {}
                    zone_fires = {}
                    STATE = "available"
                end
            end
        end
    end
end)

local shouldDrawStartBlips = false
local areStartBlipsVisible = true

-- Starts the blip code loop
-- Only runs one instance, terminates thread once it's no longer needed
-- If already running, nothing happen
function InitializeStartBlips()
    local BLIP_INFO = exports['omni_blip_info']
    if not shouldDrawStartBlips then
        shouldDrawStartBlips = true
        Citizen.CreateThread(function()
            while true do
                Wait(5)
                local ped = PlayerPedId()
                if shouldDrawStartBlips then
                    for k, v in next, fire_stations do
                        regiontier =  ((v.tier - 1) * 10)
                        if regiontier <= 0 then
                            regiontier = 1
                        end
                        if areStartBlipsVisible then
                            -- Make blip appear based on heli or ground marker
                            if not v.blip then
                                v.blip = AddBlipForCoord(v.x, v.y, v.z)
                                SetBlipSprite(v.blip, job_blip_settings.start_blip.id)
                                SetBlipColour(v.blip, job_blip_settings.start_blip.color)
                                SetBlipName(v.blip, "Fire Station")
                                SetBlipAsShortRange(v.blip, true)
                                BLIP_INFO:SetBlipInfoTitle(v.blip, v.name, false)
                                BLIP_INFO:AddBlipInfoName(v.blip, "Region", ZONES[v.region].name)
                                BLIP_INFO:AddBlipInfoName(v.blip, "Base", ZONES[v.region].base)
                                BLIP_INFO:AddBlipInfoName(v.blip, ZONES[v.region].level_requirement, regiontier)
                                if v.region then BLIP_INFO:SetBlipInfoImage(v.blip, "FF_" .. v.region, v.region) end
                                BLIP_INFO:AddBlipInfoHeader(v.blip)
                                BLIP_INFO:AddBlipInfoText(v.blip, ZONES[v.region].description)

                            end

                            if checkMarker(v.x, v.y, v.z, 2.0) then -- Draw the marker to go on duty
                                drawText(promptGoOnDuty)
                                if isEPressed() then
                                    TriggerServerEvent("omni:firefighter:dutycheck", v.region, v.tier)
                                end
                            end
                        else
                            if v.blip then
                                BLIP_INFO:ResetBlipInfo(v.blip)
                                RemoveBlip(v.blip)
                                v.blip = nil
                            end
                        end
                    end
                else
                    -- Remove blips since blips shouldn't be drawn anymore
                    for k, v in next, fire_stations do
                        if v.blip then
                            BLIP_INFO:ResetBlipInfo(v.blip)
                            RemoveBlip(v.blip)
                            v.blip = nil
                        end
                    end
                    break
                end
            end
        end)
    end
end

function ShowStartBlips()
    areStartBlipsVisible = true
end

function HideStartBlips()
    areStartBlipsVisible = false
end

function isInValidVehicle()
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if IsVehicleAttachedToTrailer(veh) then
        _, veh = GetVehicleTrailerVehicle(veh)
    end
    local validVehicle = false
    for k,v in next, job_vehicles do
        if GetEntityModel(veh) == GetHashKey(v.name) then validVehicle = true break end
    end
    return validVehicle
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function nearFireHydrant()
	local player = PlayerPedId()
	local playerLoc = GetEntityCoords(player, 0)
    local pos = GetEntityCoords(player)

	for _, v in next, fire_hydrants do
		FireHydrant = GetClosestObjectOfType(playerLoc, 2.0, v.model, false)
		if DoesEntityExist(FireHydrant) then
            return true
		end
	end
	return false
end

function nearStationHydrant()
    local pos = GetEntityCoords(PlayerPedId())
    for k, v in next, fire_station_hydrants do
        dist = #(vec3(pos.x,pos.y,pos.z) - vec3(v.x,v.y,v.z))
        if dist <= 10 then
            DrawMarker(1, v.x, v.y, v.z - 1.0,0,0,0, 0,0,0, 2.0, 2.0, 0.5, 255,255,255,150)
            return true
        end
    end
end

RegisterNetEvent("omni_firefighter:setJobActive")
AddEventHandler("omni_firefighter:setJobActive", function(b)
    if b then
        InitializeStartBlips()
    else
        shouldDrawStartBlips = false
        stopJob()
    end
end)

Citizen.CreateThread(function()
    omni_common = exports['omni_common']
    while true do
        Wait(1)
        if ONDUTY then
            if isInValidVehicle() then
                local hasWeapon, weapon = GetCurrentPedVehicleWeapon(PlayerPedId())
                if IsControlPressed(0, 68) then
                    if currentWater > 0 then
                        currentWater = currentWater - 1
                        DisableVehicleWeapon(false, weapon, GetVehiclePedIsIn(PlayerPedId()), PlayerPedId())
                    else
                        DisableVehicleWeapon(true, weapon, GetVehiclePedIsIn(PlayerPedId()), PlayerPedId())
                    end
                end
            end
        end
        if ONDUTY then
            if isInValidVehicle() then
                GiveWeaponToPed(PlayerPedId(), "weapon_fireextinguisher", 1000, false, true)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if ONDUTY then
            if isInValidVehicle() then
                if currentWater < totalWater then
                    if nearFireHydrant() or nearStationHydrant() then
                        SetInstructionalButton("Hold to refill water tank ", 76, true)
                        if IsControlPressed(0, 76) then
                            currentWater = currentWater + 1
                        end
                    else
                        SetInstructionalButton("Hold to refill water tank ", 76, false)
                    end
                    for k, v in next, fire_station_hydrants do
                        if not v.blip then
                            blip = AddBlipForCoord(v.x, v.y, v.z)
                            SetBlipSprite(blip, 652)
                            SetBlipColour(blip, 46)
                            SetBlipAsShortRange(blip, true)
                            exports['omni_common']:SetBlipName(blip, "Station Fire Hydrant")
                            v.blip = blip
                        end
                    end
                else
                    for k, v in next, fire_station_hydrants do
                        if v.blip then
                            RemoveBlip(v.blip)
                            v.blip = nil
                        end     
                    end
                    SetInstructionalButton("Hold to refill water tank ", 76, false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local Top10 = {
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
    }
    local top10pos = vector3(207.49183654785, -1632.5252685547, 31.732568740845)
    RegisterNetEvent("omni_firefighter:updateStreakRecords")
    AddEventHandler("omni_firefighter:updateStreakRecords", function(records)
        Top10 = records
    end)
    while true do
        Wait(1)
        local pos = GetEntityCoords(PlayerPedId())
        local dist = #(pos - top10pos)
        if dist < 15.0 then
            omni_common:DrawText3D("~g~Highest FireFighter Streaks", top10pos.x, top10pos.y, top10pos.z, 2.0)
            for n, entry in next, Top10 do
                omni_common:DrawText3D(("~g~#%s~w~: ~y~%s ~w~by ~y~%s"):format(n, entry.amount, entry.username), top10pos.x, top10pos.y, top10pos.z - n * 0.25 - 0.25, 1.25)
            end
        end
    end
end)

if DEBUGGING_SCRIPT then
    InitializeStartBlips()
end

-- InitializeStartBlips()

Citizen.CreateThread(function()
    local delay = 60
    if DEBUGGING_SCRIPT then delay = 1 end
    while true do
        Wait(1000 * delay)
        if STATE == "available" then
            if DEBUGGING_SCRIPT then
                print("callout triggered")
            end
            createMission()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if (JobCooldown > 0) then
            JobCooldown = JobCooldown - 1
        end
    end
end)
