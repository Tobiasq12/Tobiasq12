--[[
      ▄▌ █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
   ▄▄██▌ █     Created* for Transport Tycoon  █
▄▄▄▌▐██▌ █                 by Omni            █
███████▌ █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█
▀(@)▀▀▀▀▀▀▀(@)(@)▀▀   ▀▀▀▀▀▀▀▀▀▀▀▀▀(@)(@)▀▀▀▀▀▀
]]

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

------------------
-- CONFIG START --
------------------

-- Messages
startText = "Press ~g~E ~w~to go on duty"

-- Blip Settings
job_blip_settings = {
    start_blip = {id = 318, color = 18},
    destination_blip = {id = 515, color = 18},
    dropoffs_blip = {id = 355 , color = 25},
    marker = {r = 0, g = 0, b = 255, a = 100},
    marker_special = {r = 255, g = 255, b = 0, a = 200},
}


local beach_item_set = {
	"trash",
	"trash",
    "trash",
	"trash",
	"refined_sand",
	"refined_sand",
}

local job_starts = {
	{name = "LS Beach", x = -1482.8100585938, y = -1029.8590087891, z = 6.1347374916077}
}

local dozer_locations = {
    {id = "VB_01", name = "Vespucci Beach", x = -1483.1546630859, y = -1211.9744873047, z = 2.8375680446625, capacity = 100, current = 0, size = 100.0, bonuses = {}, itemset = beach_item_set},
    {id = "VB_02", name = "Vespucci Beach", x = -1408.8197021484, y = -1446.8592529297, z = 3.9947254657745, capacity = 100, current = 0, size = 100.0, bonuses = {}, itemset = beach_item_set},
    {id = "VB_03", name = "Vespucci Beach", x = -1321.5003662109, y = -1663.0168457031, z = 2.6428420543671, capacity = 100, current = 0, size = 100.0, bonuses = {}, itemset = beach_item_set},
}

local job_vehicles = {
    {name = "cat259", tier = 2},
    {name = "steamroller", tier = 3},
    {name = "bulldozer", tier = 4},
    {name = "ct660dump", tier = 5},
    {name = "cat745c", tier = 6},
    {name = "motorgrader", tier = 7},
}

----------------
-- CONFIG END --
----------------

local WITHIN_ZONE = false
local CURRENT_ZONE = nil
local isOnJob = false

function GiveItemFromSet(location, min, max)
    local tier = getTier()
    local itemset = location.itemset
    local item = itemset[math.random(#itemset)]
    local amount = math.random(min, max) * tier
    if amount > 0 then
        -- Code to give items
        TriggerServerEvent("omni_sand:receiveItem", item, amount)
		-- print(" Recieved " .. item ..  amount)
        -- TriggerEvent("gd_utils:notify", "Got " .. amount .. "x " .. item)
    end
end

function drawText(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 500, true)
end

function drawMarker(x,y,z,s)
    local marker = job_blip_settings.marker
    if s or false then
        marker = job_blip_settings.marker_special
    end
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if #(pos - vec3(x, y, z)) < 50.0 then
        DrawMarker(1, x, y, z, 0,0,0,0,0,0,2.0,2.0,2.0,marker.r,marker.g,marker.b,marker.a,0,0,0,0)
    end
end

function getTier()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    if IsVehicleAttachedToTrailer(veh) then
        _, veh = GetVehicleTrailerVehicle(veh)
    end
    if not veh then
        return 0
    end
    local model = GetEntityModel(veh)
    for k,v in next, job_vehicles do
        if model == GetHashKey(v.name) then
            return v.tier
        end
    end
    return 0
end

function isEPressed()
    return IsControlJustPressed(0, 38)
end

function nearMarker(x, y, z, range)
    local p = GetEntityCoords(GetPlayerPed(-1))
    local r = range
    if range == nil then
        r = 2.0
    end
    local zDist = math.abs(z - p.z)
    return ((#(p - vec3(x, y, z)) < r) and (zDist < 4))
end

function promptJob(location)
	drawText(string.format(startText))
    if isEPressed() then
        TriggerServerEvent("omni_sand:tryStartJob", location)
        return
    end
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
    for k,v in next, job_vehicles do
        if model == GetHashKey(v.name) then
            return true
        end
    end
    return false
end

function startJob()
	if not isOnJob then
		isOnJob = true
		-- print("is on Job")
	end
end

RegisterNetEvent("omni_sand:startJob")
AddEventHandler("omni_sand:startJob",
    function()
        startJob()
    end
)

AddEventHandler("omni:stop_job", function()
    if isOnJob then
		for _, location in next, dozer_locations do
            if DoesBlipExist(location.blip) then
                RemoveBlip(location.blip)
				RemoveBlip(location.world_blip)
				location.world_blip = nil
				location.blip = nil
            end

    		for _, bonus in next, location.bonuses do
    			if bonus.blip then
    				RemoveBlip(bonus.blip)
    				bonus.blip = nil
    			end
    		end
            location.bonuses = {}
        end
        isOnJob = false
    end
end)

-- Main Loop
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = GetPlayerPed(-1)
        WITHIN_ZONE = false
        CURRENT_ZONE = nil
		if not isOnJob then
			-- NOT ON JOB
            local p = GetEntityCoords(GetPlayerPed(-1))
            for k,v in next, job_starts do
                drawMarker(v.x, v.y, v.z - 1.0)
                if nearMarker(v.x, v.y, v.z) then
                    promptJob()
                end
            end
		else
	        if isInValidVehicle() then
	            local pos = GetEntityCoords(ped, false)
	            for _, location in next, dozer_locations do
	                if not location.world_blip then
	                    local blip = AddBlipForCoord(location.x, location.y, location.z)
	                    SetBlipSprite(blip, 527)
	                    SetBlipColour(blip, 26)
	                    SetBlipAsShortRange(blip, true)
	                    exports['omni_common']:SetBlipName(blip, "Sand Excavation Zone")
	                    location.world_blip = blip
	                end
	                if not WITHIN_ZONE then
	                    -- Check if we are within the dozing area
	                    local dist = #(vector3(location.x, location.y, location.z) - pos)
	                    if dist < location.size + 150.0 then
	                        -- Within a dozer area
	                        DrawMarker(1, location.x, location.y, location.z, 0, 0, 0, 0, 0, 0, location.size * 2, location.size * 2, 2.0, 255, 255, 255, 255)

	                        -- Make the radius blip if no present
	                        if not location.blip then
	                            local blip = AddBlipForRadius(location.x, location.y, location.z, location.size)
	                            SetBlipAlpha(blip, 150)
	                            SetBlipColour(blip, 26)
	                            location.blip = blip
	                        end

	                        -- Check if we are within the zone itself
	                        if dist < location.size then
	                            -- Within the Dozer zone

	                            -- Mark as current zone (for Dozer generator and bonus generator)
	                            WITHIN_ZONE = true
	                            CURRENT_ZONE = location

	                            -- Check and draw bonuses
	                            for _bonus_id, bonus in next, location.bonuses do
	                                -- Create bonus blip if not present
	                                if not bonus.blip then
	                                    local blip = AddBlipForCoord(bonus.x, bonus.y, location.z)
	                                    exports['omni_common']:SetBlipName(blip, "Sand Bonus")
	                                    bonus.blip = blip
	                                end
	                                -- Draw Marker on water (fancy!!)
	                                -- local _, h = GetWaterHeight(bonus.x, bonus.y, 100.0)
	                                DrawMarker(1, bonus.x, bonus.y, bonus.z, 0, 0, 0, 0, 0, 0, bonus.size * 2, bonus.size * 2, 5.0, 255, 0, 0, 255)

	                                -- Check distance
	                                local dist = #(vector3(bonus.x, bonus.y, location.z) - pos)
	                                if dist < bonus.size * 2 then
	                                    RemoveBlip(bonus.blip)
	                                    bonus.blip = nil
	                                    GiveItemFromSet(location, 2, 4)
	                                    table.remove(location.bonuses, _bonus_id)
	                                end
	                            end
	                        end
	                    else
	                        -- Not within a Dozer area

	                        -- Remove area blip
	                        if location.blip then
	                            RemoveBlip(location.blip)
	                            location.blip = nil
	                        end
	                        -- Remove bonus blips
	                        for _, bonus in next, location.bonuses do
	                            if bonus.blip then
	                                RemoveBlip(bonus.blip)
	                                bonus.blip = nil
	                            end
	                        end
	                    end
	                end
	            end
	        else
	            -- Not in a tug
	            -- Remove blips
	            for _, location in next, dozer_locations do
	                if location.world_blip then
	                    RemoveBlip(location.world_blip)
	                    location.world_blip = nil
	                end
	                if location.blip then
	                    RemoveBlip(location.blip)
	                    location.blip = nil
	                end
	                for _, bonus in next, location.bonuses do
	                    if bonus.blip then
	                        RemoveBlip(bonus.blip)
	                        bonus.blip = nil
	                    end
	                end
	            end
	        end
	    end
	end
end)

-- Dozer Generator Loop
local last_pos = vector3(0.0, 0.0, 0.0)
Citizen.CreateThread(function()
    while true do
        Wait(2500)
        local ped = GetPlayerPed(-1)
        if WITHIN_ZONE then
            local pos = GetEntityCoords(ped, false)
            local dist = #(pos - last_pos)
            if dist > 26.0 then
                last_pos = pos
                -- Make me a SAND
                -- INSERT CODE TO GIVE Sand
                GiveItemFromSet(CURRENT_ZONE, -3, 3)
            end
        end
    end
end)

-- Bonus Generator Loop
local bonus_wait_time = 35 * 1000
Citizen.CreateThread(function()
    while true do
        if WITHIN_ZONE then
            local zone = CURRENT_ZONE
            local bonus = {}
            -- Make sure the position is never outside the zone
            local function gen()
                bonus.x = zone.x + math.random(-zone.size, zone.size)
                bonus.y = zone.y + math.random(-zone.size, zone.size)
                local dist = #(vector3(bonus.x, bonus.y, 0.0) - vector3(zone.x, zone.y, 0.0))
                if dist > zone.size then
                    gen()
                end
            end
            gen()
            bonus.size = 6.0
            if #zone.bonuses <= 5 then
                table.insert(zone.bonuses, bonus)
            end
        end
        Wait(bonus_wait_time)
    end
end)
