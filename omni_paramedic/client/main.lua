------------------
-- CONFIG START --
------------------
local STATE = "none"
local ONDUTY = false
local JobCooldown = 0
local current_job = {}
local current_location_pool = {}
local streak = 0
local CURRENT_REGION = "none"

local DEBUGGING_SCRIPT = false

local promptGoOnDuty = "Press ~g~E ~w~to ~g~Start Work ~w~as a ~y~Paramedic"
local promptSwapOnDuty = "Press ~g~E ~w~to ~g~Change Working Region"
local alreadyOnDutyText = "You are already on duty"

local job_blip_settings = {
    start_blip = {id = 61, color = 49},
    destination_blip = {id = 280, color = 46},
    dropoff_blip = {id = 538, color = 2},
    marker = {r = 0, g = 150, b = 255, a = 200},
    marker_special = {r = 255, g = 255, b = 0, a = 200},
}

CreateThread(function()
    local function DrawScreenText(bl, x, y, scale, text, r, g, b, a)
        SetTextFont(4)
        SetTextProportional(0)
        SetTextScale(scale, scale)
        SetTextColour(r, g, b, a)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        local r = (bl == 0)
        if r then
            BeginTextCommandWidth("STRING")
            AddTextComponentString(text)
            local width = EndTextCommandGetWidth(true)
            x = x - width
            text = "~o~" .. text
        end
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(x, y)
    end

    local yx,yl,yo,ym,ys = 0.25,0,0.25,0.0275, 0.6
    local yr,yg,yb,ya = 255,255,255,255
    local function DrawDataLine(prefix, data, iftrue, iffalse, ignoretable)
        if not (data ~= nil and type(data) == 'table') then
            if prefix then
                DrawScreenText(0, yx, yo+yl*ym, ys, ("%s"):format(prefix), yr,yg,yb,ya)
            end
        end
        if data ~= nil then
            local text = data
            if type(data) == 'table' then
                if not ignoretable then DrawDataLine("", prefix, "o") end
                if data.name and data.x and data.y and data.z then
                    text = ("vector3(%02.3f, %02.3f, %02.3f) ~g~%s"):format(data.x, data.y, data.z, data.name)
                    DrawDataLine(prefix, text, iftrue, iffalse)
                else
                    for k, v in next, data do
                        DrawDataLine(k, v, iftrue, iffalse, true)
                    end
                end
            else
                if iftrue and data then
                    data = ("~%s~%s"):format(iftrue, data)
                elseif iffalse then
                    data = ("~%s~%s"):format(iffalse, data)
                end
                DrawScreenText(1, yx, yo+yl*ym, ys, ("%s"):format(data), yr,yg,yb,ya)
            end
        end
        yl=yl+1
    end

    local function DrawDebug()
        CreateThread(function()
            while true do
                Wait(0)
                yl = 0
                local s, d, cj = STATE, ONDUTY, current_job
                DrawDataLine("", "Debug Information", "o")
                DrawDataLine("State", s, "g")
                DrawDataLine("On Duty", d, "g", "r")
                if next(cj) ~= nil then
                    DrawDataLine()
                    DrawDataLine("Current Job", cj)
                end
            end
        end)
    end
    if DEBUGGING_SCRIPT then DrawDebug() end
end)

local function EnsureReportableData(data)
    local ret = {}
    for key, value in next, data do
        ret[key] = value
        local data_type = type(value)
        if data_type == "vector2" then
            ret[key] = tostring(value)
        elseif data_type == "vector3" then
            ret[key] = tostring(value)
        elseif data_type == "vector4" then
            ret[key] = tostring(value)
        elseif data_type == "quat" then
            ret[key] = tostring(value)
        elseif data_type == "table" then
            ret[key] = EnsureReportableData(value)
        end
    end
    return ret
end

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

function reportCurrentMission()
    local data = EnsureReportableData(current_job)
    TriggerServerEvent("omni_paramedic:reportMission", data)
end

RegisterNetEvent("omni:paramedic:tryStartJob")
AddEventHandler("omni:paramedic:tryStartJob",
    function(region)
        startJob(region)
    end
)

function PlayAnim(ped,base,sub,nr,time)
	Citizen.CreateThread(function()
        RequestAnimDict(base)
		while not HasAnimDictLoaded(base) do
			Wait(1)
		end
		if IsEntityPlayingAnim(ped, base, sub, 3) then
			ClearPedSecondaryTask(ped)
		else
			for i = 1, nr do
				TaskPlayAnim(ped, base, sub, 8.0, -8, -1, 16, 0, 0, 0, 0)
				Wait(time)
			end
		end
	end)
end

function isModelValidVehicle(model)
    for k,v in next, job_vehicles do
        if model == GetHashKey(v.name) then
            return true
        end
    end
    return false
end

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
    return isModelValidVehicle(model)
end

function isOnDuty()
    return ONDUTY == true
end

function isEPressed()
    return IsControlJustPressed(0, 38)
end

local function GetRandomDestination()
    local dest = current_location_pool[math.random(#current_location_pool)]
    local dist = #(vec3(current_job.pos.x, current_job.pos.y, current_job.pos.z) - vec3(dest.x, dest.y, dest.z))
    while dist < 100 do
        dest = GetRandomDestination()
        dist = #(vec3(current_job.pos.x, current_job.pos.y, current_job.pos.z) - vec3(dest.x, dest.y, dest.z))
    end
    dist = math.floor(dist)
    return dest, dist
end

function checkMarker(x,y,z,s)
    local marker = job_blip_settings.marker
    if s or false then
        marker = job_blip_settings.marker_special
    end
    local pos = GetEntityCoords(PlayerPedId())
    local dist = #(pos - vec3(x, y, z))
    if dist < 50.0 then
        DrawMarker(1, x, y, z - 1.0, 0,0,0, 0,0,0, s, s, 4.0, marker.r,marker.g,marker.b, marker.a)
        if dist < 5.0 then
            return true
        end
    end
    return false
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

function getClosestDropoff(heli)
	local pos = GetEntityCoords(PlayerPedId())
	local closest = nil
	local dist = 0
	for _, dropoff in next, hospital_dropoff do
		if (heli == dropoff.heli) and not dropoff.hidden then
			local _dist = #(pos - vector3(dropoff.x, dropoff.y, dropoff.z))
			if _dist < dist or (not closest) then
				closest = dropoff
				dist = _dist
			end
		end
	end
	return closest, dist
end

function startJob(region)
    if ONDUTY then
        if STATE == "available" then
            if region and CURRENT_REGION ~= region then
                if ZONES[region] then
                    if region then
                        if ZONES[region] then
                            current_location_pool = {}
                            TriggerEvent("gd_utils:image_notify", "CHAR_CALL911", "CHAR_CALL911", "~o~EMS Region", "~y~" .. ZONES[region]["name"],
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
                            CURRENT_REGION = region
                        end
                    end
                end
            end
        end
    else
        if JobCooldown == 0 then
            TriggerEvent("gd_utils:image_notify", "CHAR_CALL911", "CHAR_CALL911", "~o~EMS Dispatcher", "~g~On duty", "You are now marked as on-duty and available for calls")
            JobCooldown = 0
            ONDUTY = true
            streak = 0
            STATE = "available"
            current_job = {}
            if region then
                if ZONES[region] then
                    current_location_pool = {}
                    TriggerEvent("gd_utils:image_notify", "CHAR_CALL911", "CHAR_CALL911", "~o~EMS Region", "~y~" .. ZONES[region]["name"],
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
            end
            local numStops = #current_location_pool
            print(region, "#", numStops)
            TriggerEvent("omni:status", "Paramedic", {"Status: ~g~Available"})
            CURRENT_REGION = region
        else
            TriggerEvent("gd_utils:notify", ("You can not go on duty for~r~ %i ~w~seconds"):format(JobCooldown))
        end
    end
end

function stopJob()
    if ONDUTY then
        TriggerEvent("gd_utils:image_notify", "CHAR_CALL911", "CHAR_CALL911", "~o~EMS Dispatcher", "~r~Off duty", "You are now marked as off-duty")
        ONDUTY = false
        STATE = "none"
        CURRENT_REGION = "none"
        RemoveBlip(current_job.dest_blip)
        DeleteEntity(current_job.victim)
        current_job = {}
        TriggerEvent("omni:timer:stop")
        TriggerEvent("omni:status", "")
        ShowStartBlips()
    end
end

AddEventHandler("omni:stop_job", function()
    stopJob()
end)

function createMission()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local marker = 0
    current_job = {}
    current_job.vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
    current_job.pos = pos
    dest, dist = GetRandomDestination()
    current_job.dest = dest
    current_job.distance = dist
    victim = GenerateRandomPed({"human"})
    while not HasModelLoaded(victim) do
        Wait(5)
        RequestModel(victim)
    end
    current_job.victimModel = victim
    current_job.victim = CreatePed(4, victim, current_job.dest.x, current_job.dest.y, current_job.dest.z, 0.0, false, false)
    local blip_ped = AddBlipForEntity(current_job.victim)
    -- local destName = current_job.name
    SetBlipSprite(blip_ped, job_blip_settings.destination_blip.id)
    SetBlipColour(blip_ped,job_blip_settings.destination_blip.color)
    SetBlipRoute(blip_ped, true)
    current_job.zoneName = GetLabelText(GetNameOfZone(current_job.dest.x, current_job.dest.y, current_job.dest.z))
    current_job.str, current_job.cross = GetStreetNameAtCoord(current_job.dest.x, current_job.dest.y, current_job.dest.z)
    current_job.areaName = GetStreetNameFromHashKey(current_job.str)
    TriggerEvent("omni:status", "Paramedic", {"Status: ~y~On route to pickup"})
    -- dict, tex, title, subject, text
    STATE = "pickup"
    HideStartBlips()
    StartStatePickupRagdoll()
    TriggerEvent("gd_utils:image_notify", "CHAR_CALL911", "CHAR_CALL911", "~o~EMS Dispatcher", "~o~Emergency Call", "Reports of ~g~" .. dispatch[math.random(#dispatch)] .. "~w~~n~Respond to ~y~" .. current_job.areaName .. "~w~ in ~y~" .. current_job.zoneName)
end

-- Force ped to ragdoll until the pickup state ends
local isStatePickupRagdollEnabled = false
function StartStatePickupRagdoll()
    -- Prevent multiple from running
    if not isStatePickupRagdollEnabled then
        isStatePickupRagdollEnabled = true
        CreateThread(function()
            -- Actual ragdolling code
            while isOnDuty() and STATE == "pickup" do
                SetPedToRagdoll(current_job.victim, 1000, 1000, 0, 0, 0, 0)
                Wait(500)
            end
            -- State has changed, we can allow a new ragroll loop to start whenever
            isStatePickupRagdollEnabled = false
        end)
    end
end

function promptPickup()
    drawText("Press ~g~E ~w~to tend to the wounded")
    if IsControlJustPressed(0, 38) then
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, true)
        RemoveBlip(current_job.dest_blip)
        -- RemoveBlip(GetBlipFromEntity(current_job.victim))
        PlayAnim(PlayerPedId(),'amb@medic@standing@kneel@enter','enter',1,1000) -- 5sec
        -- StopAnimTask(PlayerPedId(), 'amb@medic@standing@kneel@enter','enter',2.0)
        Wait(8000)
        STATE = "follow"
    end
end

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
                local veh = GetVehiclePedIsIn(ped, true)
                local model = GetEntityModel(veh)
                local isVehHeli = IsThisModelAHeli(model)

                if shouldDrawStartBlips then
                    for k, v in next, hospital_stations do
                        if areStartBlipsVisible and CURRENT_REGION ~= v.region then
                            -- Make blip appear based on heli or ground marker
                            local useBlip = (v.ground and not isVehHeli) or (v.heli and isVehHeli)
                            if (not v.blip) and useBlip then
                                v.blip = AddBlipForCoord(v.x, v.y, v.z)
                                SetBlipSprite(v.blip, job_blip_settings.start_blip.id)
                                SetBlipColour(v.blip, job_blip_settings.start_blip.color)
                                SetBlipName(v.blip, "Paramedic Station")
                                SetBlipAsShortRange(v.blip, true)
                                BLIP_INFO:SetBlipInfoTitle(v.blip, v.name, false)
                                BLIP_INFO:AddBlipInfoName(v.blip, "Region", ZONES[v.region].name)
                                BLIP_INFO:AddBlipInfoName(v.blip, "Base", ZONES[v.region].base)
                                if v.preview then BLIP_INFO:SetBlipInfoImage(v.blip, "PM_" .. v.preview, v.preview) end
                                BLIP_INFO:AddBlipInfoHeader(v.blip)
                                BLIP_INFO:AddBlipInfoText(v.blip, ZONES[v.region].description)
                            elseif v.blip and not useBlip then
                                BLIP_INFO:ResetBlipInfo(v.blip)
                                RemoveBlip(v.blip)
                                v.blip = nil
                            end

                            if checkMarker(v.x, v.y, v.z, 5.0) then -- Draw the marker to go on duty
                                if ONDUTY then
                                    drawText(promptSwapOnDuty)
                                else
                                    drawText(promptGoOnDuty)
                                end
                                if isEPressed() then
                                    TriggerServerEvent("omni_medic:dutycheck", v.region)
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
                    for k, v in next, hospital_stations do
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

CreateThread(function()
    if DEBUGGING_SCRIPT then
        InitializeStartBlips()
        startJob("CENTRAL")
    end
end)

function ShowStartBlips()
    areStartBlipsVisible = true
end
function HideStartBlips()
    areStartBlipsVisible = false
end

RegisterNetEvent("omni_paramedic:setJobActive")
AddEventHandler("omni_paramedic:setJobActive", function(b)
    if b then
        InitializeStartBlips()
    else
        shouldDrawStartBlips = false
        stopJob()
    end
end)

Citizen.CreateThread(function()
    local COMMON = exports['omni_common']
    while true do
        Wait(5)
        local plyPed = PlayerPedId()
        local playerPos = GetEntityCoords(plyPed)
        local veh = GetVehiclePedIsUsing(plyPed, true)
        local vehModel = GetEntityModel(veh)
        local onDuty = isOnDuty()
        if onDuty then
            if STATE == "pickup" then
                SetPedToRagdoll(current_job.victim, 1000, 1000, 0, 0, 0, 0)
                local dist = #(playerPos - vector3(current_job.dest.x, current_job.dest.y, current_job.dest.z))
                current_job.distance = math.floor(dist)
                COMMON:SetStatus("Paramedic", {"Status: ~y~On Route~w~","~g~Area of Emergency: ~w~".. current_job.dest.name, "~g~Distance: ~w~" .. current_job.distance .. "m"},"")
                if dist <= 50.0 then
                    -- DrawMarker(36, current_job.dest.x, current_job.dest.y, current_job.dest.z + 0.2, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 100, true, true, 0, false)
                    DrawMarker(0, current_job.dest.x, current_job.dest.y, current_job.dest.z + 2.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75, 0.75, 1.0, 255, 232, 60, 255, 1, 0, 0, 1, 0, 0, 0)
                    DrawMarker(1, current_job.dest.x, current_job.dest.y, current_job.dest.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 232, 60, 40, 0, 0, 0, 1, 0, 0, 0)
                end
                if dist <= 2.0 then
                    if not IsPedInVehicle(plyPed, veh, false) then
                        promptPickup()
                    end
                elseif dist <= 4.0 then
                elseif dist <= 10.0 then
                    -- if IsControlPressed(0, 74) then
                    --     drawText("Keep holding ~r~H ~w~to confim reporing the location")
                    --     current_job.reportTimer = (current_job.reportTimer or 300) - 1
                    --     if current_job.reportTimer <= 0 then
                    --         reportCurrentMission()
                    --         createMission()
                    --     end
                    -- else
                    --     drawText("If the location is impossible, hold ~r~H ~w~to report it")
                    -- end
                end
            elseif STATE == "stretcher_fetch" then
                -- (have chance of stretcher sidequest?)
                -- get a stretcher (https://github.com/Xerxes468893/stretcher/ script to base from?)
                -- walk over to your vehicle and do interaction
                -- make sure ped is ragdolled, can be done in pickup ragdoll loop
                -- spawn stretcher and set new state "stretcher_pickup"
                -- maybe steal the code used for the mule job with the packages
                STATE = "stretcher_pickup"
            elseif STATE == "stretcher_pickup" then
                -- pick up the patient on the stretcher
                -- make sure ped is ragdolled, can be done in pickup ragdoll loop
                -- walk with the stretcher (slowed movement? heh)
                -- interact with ped, probably can snap onto the thing and get stuck
                -- maybe play an animation and freeze player because gameplay
                -- once ped is on stretcher, set new state "stretcher_deliver"
                STATE = "stretcher_deliver"
            elseif STATE == "stretcher_deliver" then
                -- put the stretcher and patient in the vehicle
                -- walk back to your vehicle with the stretcher and ped
                -- put it in, there's probably an animation for this in the stretcher script linked (https://github.com/Xerxes468893/stretcher/)
                -- delete the stretcher object and force the ped into the vehicle
                -- maybe respawn a new ped like we do after the "follow" state due to onesync networking crash
                -- once this is done set new state "stretcher_complete"
                STATE = "stretcher_complete"
            elseif STATE == "stretcher_deliver" then
                -- get the player to enter the vehicle
                -- just wait for them to do that
                -- and thats about it
                -- once theyre in the vehicle the ped is in set state to "transport"
                STATE = "transport"
            elseif STATE == "follow" then
                if IsPedInAnyVehicle(plyPed, false) then
                    if isModelValidVehicle(vehModel) then
                        local p = GetEntityCoords(current_job.victim)
                        local h = GetEntityHeading(current_job.victim)
                        DeleteEntity(current_job.victim)
                        current_job.victim = CreatePed(4, current_job.victimModel, p, h, true, false)
                        TaskEnterVehicle(current_job.victim, veh, 5000, 2, 100.0, 0, false)
                        STATE = "entercar"
                    end
                else
                    if not GetIsTaskActive(current_job.victim, 259 --[[259 - CTaskMoveFollowEntityOffset]]) then
                        TaskFollowToOffsetOfEntity(current_job.victim, plyPed, 0.0, -1.0, 0.0, 100.0, 10000, 1.0, true)
                    end
                end
            elseif STATE == "entercar" then
                local veh = GetVehiclePedIsUsing(plyPed, true)
                local vehModel = GetEntityModel(veh)
                if IsPedInAnyVehicle(plyPed, false) then
                    local getin = IsPedInVehicle(current_job.victim, veh, true)
                    local inside = IsPedInVehicle(current_job.victim, veh, false)
                    if not getin and not inside then
                        -- they're not trying to get in
                        if not GetIsTaskActive(current_job.victim, 160 --[[160 - CTaskEnterVehicle]]) then
                            TaskEnterVehicle(current_job.victim, veh, 5000, 2, 100.0, 0, false)
                        end
                    elseif getin and not inside then
                        -- still waiting
                        if not GetIsTaskActive(current_job.victim, 160 --[[160 - CTaskEnterVehicle]]) then
                            TaskEnterVehicle(current_job.victim, veh, 5000, 2, 100.0, 0, false)
                        end
                    elseif getin and inside then
                        -- they're in
                        STATE = "transport"
                    end
                else
                    STATE = "follow"
                end
            elseif STATE == "transport" then
                local location, dist = getClosestDropoff(false)
                if IsThisModelAHeli(vehModel) then
                    location, dist = getClosestDropoff(true)
                elseif IsThisModelAPlane(vehModel) then
                    location, dist = getClosestDropoff(true)
                end
                current_job.distance = dist
                current_job.dest = location
                current_job.dest_blips = {}
                for k, v in next, hospital_dropoff do
                    local blip = AddBlipForCoord(v.x, v.y, v.z)
                    SetBlipSprite(blip, job_blip_settings.dropoff_blip.id)
                    SetBlipColour(blip, job_blip_settings.dropoff_blip.color)
                    SetBlipAsShortRange(blip, true)
                    SetBlipScale(blip, 0.75)
                    current_job.dest_blips[#current_job.dest_blips + 1] = blip
                end
                current_job.dest_blip = AddBlipForCoord(location.x, location.y, location.z)
                SetBlipSprite(current_job.dest_blip, job_blip_settings.dropoff_blip.id)
                SetBlipColour(current_job.dest_blip, job_blip_settings.dropoff_blip.color)
                SetBlipRoute(current_job.dest_blip, true)
                TriggerEvent("gd_utils:image_notify", "CHAR_CALL911", "CHAR_CALL911", "~o~EMS Dispatcher", "~b~Advisory", "Closest recommended medical facility is ~g~" .. current_job.dest.name)
                STATE = "transport_deliver"
            elseif STATE == "transport_deliver" then
                local playerPos = GetEntityCoords(plyPed)
                local dist = #(playerPos - vector3(current_job.dest.x, current_job.dest.y, current_job.dest.z))
                current_job.distance = math.floor(dist)
                COMMON:SetStatus("Paramedic", {"Status: ~y~On Route~w~","~g~Recommended Dropoff: ~w~".. current_job.dest.name .."", "~g~Distance: ~w~" .. current_job.distance .. "m"},"")
                if isModelValidVehicle(vehModel) then
                    if not IsPedInVehicle(current_job.victim, veh) then
                        TaskEnterVehicle(current_job.victim, veh, 1500, 2, 2.0, 1, 0)
                    end
                else
                    TaskLeaveVehicle(current_job.victim, veh, 0)
                end
                for k,v in next, hospital_dropoff do
                    local victim = GetEntityCoords(current_job.victim)
                    local dist = #(vec3(v.x, v.y, v.z) - victim)

                    if dist < 50 then
                        DrawMarker(1, v.x, v.y, v.z - 1.0, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 255, 165, 0,165, 0, 0, 0,0)
                        if dist < 5 then
                            if GetEntitySpeed(veh) < 2 then
                                local wasInHeli = false
                                if IsThisModelAHeli(vehModel) then
                                    wasInHeli = true
                                end
                                streak = streak + 1
                                TriggerServerEvent("omni_medic:dropoff:event", wasInHeli, streak)
                                TriggerEvent("omni:status", "Paramedic", {"Status: ~g~Available", "Streak: ~g~" .. streak})
                                STATE = "available"
                                ShowStartBlips()
                                RemoveBlip(current_job.dest_blip)
                                DeleteEntity(current_job.victim)
                                for _, blip in next, current_job.dest_blips do
                                    RemoveBlip(blip)
                                end
                                current_job = {}
                            else
                                drawText("You need to be stopped to do this")
                            end
                        end
                    end
                    -- if STATE == "transport" then
                    --     -- if not v.blip then
                    --     --     if IsThisModelAHeli(GetEntityModel(veh)) then
                    --     --         if v.heli then
                    --     --             v.blip = AddBlipForCoord(v.x, v.y, v.z)
                    --     --             SetBlipSprite(v.blip, job_blip_settings.start_blip.id)
                    --     --             SetBlipColour(v.blip, job_blip_settings.start_blip.color)
                    --     --             SetBlipName(v.blip, "Paramedic: Heli Dropoff")
                    --     --             SetBlipAsShortRange(v.blip, true)
                    --     --         end
                    --     --     else
                    --     --         if not v.heli then
                    --     --             v.blip = AddBlipForCoord(v.x, v.y, v.z)
                    --     --             SetBlipSprite(v.blip, job_blip_settings.start_blip.id)
                    --     --             SetBlipColour(v.blip, job_blip_settings.start_blip.color)
                    --     --             SetBlipName(v.blip, "Paramedic: Vehicle Dropoff")
                    --     --             SetBlipAsShortRange(v.blip, true)
                    --     --         end
                    --     --     end
                    --     -- end
                    -- else
                    --     RemoveBlip(v.blip)
                    --     v.blip = nil
                    -- end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local delay = 120
    if DEBUGGING_SCRIPT then delay = 1 end
    while true do
        Wait(1000 * delay) -- Half minute timer
        if isInValidVehicle() then
            if isOnDuty() then
                if STATE == "available" then
                    createMission()
                else
                    TriggerEvent("gd_utils:image_notify", "CHAR_CALL911", "CHAR_CALL911", "~o~EMS Dispatcher", "~o~Chatter", "[...]")
                end
            end
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

Citizen.CreateThread(function()
    local Top10 = {
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
    }
    local top10pos = vector3(-473.39331054688, -339.66552734375, 37.701808929443)
    RegisterNetEvent("omni_paramedic:updateStreakRecords")
    AddEventHandler("omni_paramedic:updateStreakRecords", function(records)
        Top10 = records
    end)
    while true do
        Wait(0)
        local pos = GetEntityCoords(PlayerPedId())
        local dist = #(pos - top10pos)
        if dist < 15.0 then
            DrawText3D("~g~Highest Paramedic Streaks", top10pos.x, top10pos.y, top10pos.z, 2.0)
            for n, entry in next, Top10 do
                DrawText3D(("~g~#%s~w~: ~y~%s ~w~by ~y~%s"):format(n, entry.amount, entry.username), top10pos.x, top10pos.y, top10pos.z - n * 0.25 - 0.25, 1.25)
            end
        end
    end
end)
