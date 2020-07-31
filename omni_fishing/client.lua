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

----------------
-- E  D  I  T --
----------------

local StartFishing_KEY = 38 -- E
local Caught_KEY = 38 -- E
local SuccessLimit = 0.09 -- Maxim 0.1 (high value, low success chances)
local AnimationSpeed = 0.0015
local ShowChatMSG = true -- or false
local current_job = {}
local debugMarkers = {}

startText = "Press ~g~E ~w~to start a ~g~%s Route"
startTextSpecial = "Press ~g~E ~w~to start a ~g~Delivery~w~ from ~g~%s~w~"
invalidVehicleText = "You need a ~g~Tug Boat ~w~to do this"
-- tooLowTierText = "Cargo routes are reserved for ~g~PostOP Mules ~w~only"
engineRunningText = "Fully ~r~STOP ~w~to pickup the trash"

startRouteMessage = "Complete the ~g~Net Fishing ~w~route"
jobDoneMessage = "Finished the ~g~Net Fishing ~w~route"

job_blip_settings = {
    start_blip = {id = 318, color = 18},
    destination_blip = {id = 400, color = 25},
    marker = {r = 0, g = 150, b = 0, a = 200},
    marker_special = {r = 255, g = 255, b = 0, a = 200},
}

--------------------------------EDITS--------------------------------

local fishstore = {
	--{name="Fish Store", id=356, colour=75, x=-1845.090, y=-1197.110, z=19.186},
}

local items_fresh = {
	"fish_salmon",
	"fish_trout",
}

local items_ocean = {
	"fish_cod",
	"fish_mackerel",
	"fish_saithe",
}

local items_mixed = {
	"fish_salmon",
	"fish_trout",
	"fish_cod",
	"fish_mackerel",
	"fish_saithe",
}

local items_cage = {
	"fish_crab",
	"fish_lobster",
	"fish_kingcrab",
}

local items_tropical = {
	"fish_angelfish",
	"fish_gobies",
	"fish_frogfish",
	"fish_angelfish",
	"fish_gobies",
	"fish_frogfish",
	"trash"
}

local items_mountain = {
	"fish_rocky",
	"fish_mossy",
	"fish_rocky",
	"fish_mossy",
	"trash",
}

local items_deep_sea = {
	"fish_cod",
	"fish_mackerel",
	"fish_saithe",
	"fish_crab",
	"fish_crab",
	"fish_lobster",
	"fish_kingcrab",
	"fish_angelfish",
	"fish_gobies",
	"fish_frogfish",
	"trash",
	"trash",
	"fish_monster_octopus",
	"fish_monster_octopus",
	"fish_monster_octopus",
	"fish_monster_octopus",
	"fish_monster_shark",
	"fish_monster_shark",
	"fish_monster_shark",
	"fish_monster_whale",
	"fish_monster_whale",
}

local fishingzones = {
    -- {name = "Paleto Cove", tier = 2, itemset = items_ocean, size = 50.0, x = -1614.893, y = 5260.193, z = 1.0},
    {name = "Pacific Ocean", tier = 3, itemset = items_cage, size = 50.0, x = 3867.511, y = 4463.621, z = 1.0},
    {name = "Pacific Cove", tier = 4, itemset = items_tropical, size = 50.0, x = 3108.7377929688, y = 2208.2241210938, z = 1.1134322881699},
    {name = "Tongva Valley River", tier = 1, itemset = items_fresh, size = 20.0, x = -1527.0656738281, y = 1509.9240722656, z = 109.24099731445},
    {name = "Land Act Reservoir", tier = 1, itemset = items_fresh, size = 20.0, x = 1690.4403076172, y = 29.570652008057, z = 160.36741638184},
    {name = "Cassidy Creek", tier = 1, itemset = items_fresh, size = 30.0, x = -951.16296386719, y = 4377.4790039063, z = 9.3424100875854},
    {name = "Zancudo River", tier = 1, itemset = items_fresh, size = 30.0, x = -354.89538574219, y = 3022.1694335938, z = 13.180494308472},
    {name = "Mirror Park", tier = 1, itemset = items_fresh, size = 50, x = 1101.2432861328, y = -687.15307617188, z = 55.58309173584},
    {name = "Vinewood Hills", tier = 1, itemset = items_fresh, size = 50, x = 40.892406463623, y = 848.04650878906, z = 196.26739501953},
    {name = "Mount Gordo", tier = 3, itemset = items_mountain, size = 50, x = 2555.2702636719, y = 6151.5219726563, z = 161.16053771973},
    {name = "Mouth Of Zancudo River", tier = 2, itemset = items_mixed, size = 50, x = -2807.4614257813, y = 2675.5161132813, z = 0.40950974822044},
    {name = "Mouth Of Cassidy Creek", tier = 2, itemset = items_mixed, size = 50, x = -2009.0286865234, y = 4713.0771484375, z = -0.62241005897522},
    {name = "Pacific Ocean", tier = 2, itemset = items_ocean, size = 50.0, x = -2614.8659667969, y = -1642.1446533203, z = 1.0}, -- South West
    {name = "Pacific Ocean", tier = 2, itemset = items_ocean, size = 50.0, x = 1044.3646240234, y = 6984.2827148438, z = 1.0}, -- Northern Ocean
    {name = "Pacific Ocean", tier = 2, itemset = items_ocean, size = 50.0, x = 3920.9289550781, y = 5346.3666992188, z = 1.0}, -- North East
    {name = "Pacific Ocean", tier = 2, itemset = items_ocean, size = 50.0, x = 2655.3779296875, y = -1435.8673095703, z = 1.0}, -- South East
    {name = "Aircraft Carrier", tier = 2, itemset = items_ocean, size = 50.0, x = 2902.5170898438, y = -4528.8251953125, z = 1.0}, -- Aircraft Carrier
    {name = "Pacific Ocean Oil Rig", tier = 4, itemset = items_deep_sea, size = 40.0, x = -4147.0581054688, y = 8936.7841796875, z = 1.0}, -- Aircraft Carrier
	{name = "Tack Zone", tier = 2, itemset = items_ocean, size = 50.0, x = 3667.2004394531, y = 5643.3525390625, z = 1.0}, -- North Eastern Ocean
    {name = "Del Perro Pier", tier = 2, itemset = items_ocean, size = 10.0, x = -1842.4846191406, y = -1256.9499511719, z = 8.6157884597778},
}

local lang = 'en'

local txt = {
    ['YourLanguage'] = {
		['sellFish'] = 'EDIT',
		['zoneFish'] = 'EDIT',
		['catchFish'] = 'EDIT'
    },
	['en'] = {
		['sellFish'] = 'Press ~g~E~s~ to sell your fish!',
		['zoneFish'] = 'Press ~g~E~s~ to start fishing!',
		['catchFish'] = 'Press ~g~E~s~ to catch fish!',
	},
	['no'] = {
		['sellFish'] = 'Press ~g~E~s~ to sell your fish!',
		['zoneFish'] = 'Press ~g~E~s~ to start fishing!',
		['catchFish'] = 'Press ~g~E~s~ to catch fish!',
	}
}
--------------------------------EDITS--------------------------------


--------------------------------BLIPS--------------------------------

function SetFishingBlips(bool)
	if (bool) then
		for _, item in pairs(fishstore) do
            if not item.blip then
    			item.blip = AddBlipForCoord(item.x, item.y, item.z)
    			SetBlipSprite(item.blip, item.id)
    			SetBlipColour(item.blip, item.colour)
    			SetBlipAsShortRange(item.blip, true)
    			BeginTextCommandSetBlipName("STRING")
    			AddTextComponentString(item.name)
    			EndTextCommandSetBlipName(item.blip)
            end
		end

		for _, item in pairs(fishingzones) do
            if not item.blip and not item.hidden then
    			item.blip = AddBlipForCoord(item.x, item.y, item.z)
    			SetBlipSprite(item.blip, 400)
    			SetBlipColour(item.blip, 59)
    			SetBlipAsShortRange(item.blip, true)
    			BeginTextCommandSetBlipName("STRING")
    			AddTextComponentString("Fishing Zone")
    			EndTextCommandSetBlipName(item.blip)
                local unique = {}
                for _, itemid in next, item.itemset do
                    unique[itemid] = true
                end
                local info = {}
                local b = false
                table.insert(info, {3, "Known species:", " "})
                for itemid, _ in next, unique do
                    local itemdata = itemdef[itemid]
                    if itemdata then
                        local leveltext = " "
                        if itemdata[4] > 0 then
                            leveltext = "Level " .. itemdata[4] .. "+"
                        end
                        if b then
                            table.insert(info, {1, itemdata[1], leveltext})
                        else
                            table.insert(info, {4, itemdata[1], leveltext})
                            b = true
                        end
                    end
                end
                exports['omni_blip_info']:SetBlipInfo(item.blip, info)
                exports['omni_blip_info']:SetBlipInfoTitle(item.blip, item.name .. " Fishing Zone")
                exports['omni_blip_info']:SetBlipInfoImage(item.blip, "biz_images", "fishing_zone")
            end
		end
	else
		for _, item in pairs(fishstore) do
            if item.blip then
                RemoveBlip(item.blip)
                item.blip = nil
            end
		end

		for _, item in pairs(fishingzones) do
            if item.blip then
                RemoveBlip(item.blip)
                item.blip = nil
            end
		end
    end
end

RegisterNetEvent("omni_fishing:showBlips")
AddEventHandler("omni_fishing:showBlips", function()
    SetFishingBlips(true)
end)
RegisterNetEvent("omni_fishing:hideBlips")
AddEventHandler("omni_fishing:hideBlips", function()
    SetFishingBlips(false)
end)

--------------------------------BLIPS--------------------------------

----------------
-- C  O  D  E --
----------------

-- V A R S
local IsFishing = false
local CFish = false
local BarAnimation = 0
local Faketimer = 0
local RunCodeOnly1Time = true
local PosX = 0.5
local PosY = 0.12
local TimerAnimation = 0.1
local multiplier = 1
local ActiveZone = 1
local isAfkFish = false
local timer = 0


RegisterNetEvent("omni_fishing:startJob")
AddEventHandler("omni_fishing:startJob",
    function(speed_multi, zone_id)
		startJob(speed_multi, zone_id)
    end
)

RegisterNetEvent("omni_fishing:startAfkFish")
AddEventHandler("omni_fishing:startAfkFish",
    function(zone_id)
		startAfkFishing(zone_id)
    end
)

AddEventHandler("omni:stop_job", function()
    stopAfkFishing()
end)

function stopAfkFishing()
	if isAfkFish then
		StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
		timer = 0
		isAfkFish = false
		DeleteEntity(FishRod)
		TriggerEvent("gd_utils:notify", "~r~Automatic fishing aborted")
		TriggerEvent("lingering-info:addTimedInfo", "Auto Fishing", 0, true)
	end
end

-- Starts Job
function startJob(speed_multi, zone_id)
	-- print("Fishing Started with a " .. speed_multi .. " Speed multiplier")
	if ShowChatMSG then Chat(msg[1]) end
	multiplier = speed_multi or 1
	IsFishing = true
	RunCodeOnly1Time = true
	BarAnimation = 0
	ActiveZone = zone_id
end

function startAfkFishing(zone_id)
	isAfkFish = true
	timer = 300
	ActiveZone = zone_id
	FishRod = AttachEntityToPed('prop_fishing_rod_01', 60309, 0, 0, 0, 0, 0, 0)
	RequestAnimDict('amb@world_human_stand_fishing@idle_a')
	while not HasAnimDictLoaded('amb@world_human_stand_fishing@idle_a') do
		Citizen.Wait(1)
	end
	TriggerEvent("gd_utils:notify", "~g~Automatic fishing started")
	TriggerEvent("lingering-info:addTimedInfo", "Auto Fishing", timer , true)
	TriggerEvent("omni:resetAFK")
end
-- Manual Fishing --
-- T H R E A D
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(1, 82) then
			TriggerEvent("boatAnchor")
		end
		local pedCoords = GetEntityCoords(PlayerPedId())
		for zone_id, zone in next, fishingzones do
			if #(vec3(zone.x, zone.y, zone.z) - pedCoords) < zone.size + 200.0 then
				DrawMarker(1, zone.x, zone.y, zone.z - 1, 0, 0, 0, 0, 0, 0, zone.size * 2, zone.size * 2, 1.5001, 155, 255, 0,165, 0, 0, 0,0)
			end
			if not isAfkFish then
				if #(vec3(zone.x, zone.y, zone.z) - pedCoords) < zone.size and math.abs(zone.z - pedCoords.z) < 10.0 then
					DisplayHelpText(txt[lang]['zoneFish'])
					if IsControlJustPressed(1, StartFishing_KEY) then
						DisplayHelpText(txt[lang]['catchFish'])
						if not IsPedInAnyVehicle(GetPed(), false) then
							if not IsPedSwimming(GetPed()) then
								TriggerServerEvent("omni_fishing:tryStartJob", zone_id)
							else
								if ShowChatMSG then Chat(msg[6]) end
							end
						end
					end
				end
			end
		end
		local zone = fishingzones[ActiveZone]
		while IsFishing do
			local time = ((2 + (math.random(0,300)) / 100)*3000) / multiplier
			local weather = exports['omni_external']:GetGlobalCurrentWeather()
			if weather == "CLEARING" then time = time / 1.1 end
			if weather == "RAIN" then time = time / 1.2 end
			if weather == "THUNDER" then time = time / 1.4 end
			-- print("Fishing wait time is: " .. time / 1000 .. " seconds")
			TaskStandStill(GetPed(), time+7000)
			FishRod = AttachEntityToPed('prop_fishing_rod_01',60309, 0,0,0, 0,0,0)
			PlayAnim(GetPed(),'amb@world_human_stand_fishing@base','base',4,3000)
			Citizen.Wait(time)
			CFish = true
			IsFishing = false
		end
		while CFish do
			Citizen.Wait(1)
			FishGUI(true)
			if RunCodeOnly1Time then
				Faketimer = 1
				PlayAnim(GetPed(),'amb@world_human_stand_fishing@idle_a','idle_c',1,0) -- 10sec
				Chat('~y~'..msg[5])
				RunCodeOnly1Time = false
			end
			if TimerAnimation <= 0 then
				CFish = false
				TimerAnimation = 0.1
				StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
				Citizen.Wait(200)
				DeleteEntity(FishRod)
				if ShowChatMSG then Chat('~r~'..msg[2]) end
			end
			if IsControlJustPressed(1, Caught_KEY) then
				if BarAnimation >= SuccessLimit then
					CFish = false
					TimerAnimation = 0.1
					local fish = zone.itemset[math.random(#zone.itemset)]
					TriggerServerEvent("omni_fishing:receiveFish", fish)
					TriggerEvent("omni:resetAFK")
					if ShowChatMSG then Chat('~g~'..msg[3]) end
					StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
					Citizen.Wait(200)
					DeleteEntity(FishRod)
				else
					CFish = false
					TimerAnimation = 0.1
					StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
					Citizen.Wait(200)
					DeleteEntity(FishRod)
					if ShowChatMSG then Chat('~r~'..msg[4]) end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local time = ((2 + (math.random(0,300)) / 100)*3000)
		Wait(time)
		if isAfkFish then
			if timer > 0 then
				local pedCoords = GetEntityCoords(PlayerPedId())
				zone = fishingzones[ActiveZone]
				if #(vec3(zone.x, zone.y, zone.z) - pedCoords) < zone.size and math.abs(zone.z - pedCoords.z) < 10.0 then
					local catch = math.random(1, 100)
					local fish = zone.itemset[math.random(#zone.itemset)]
					if isAfkFish then
						local catch = math.random(1, 100)
						if catch >= 50 then
							TriggerServerEvent("omni_fishing:receiveFish", fish)
						end
					else
						StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
					end
				else
					isAfkFish = false
					timer = 0
					TriggerEvent("gd_utils:notify", "~r~You've left the fishing area")
				end
			else
				isAfkFish = false
				DeleteEntity(FishRod)
				TriggerEvent("gd_utils:notify", "~r~Your rod snapped from excitement")
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if timer > 0 then
			timer = timer - 1
			-- print("Timer: " .. timer)
			if not IsEntityPlayingAnim(PlayerPedId(), 'amb@world_human_stand_fishing@idle_a','idle_c', 1) then
				-- print("TASK")
				TaskPlayAnim(PlayerPedId(), 'amb@world_human_stand_fishing@idle_a','idle_c', 1.0, 1, -1, 16, 0, 0, 0, 0)
			end
		else
			StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
		end
	end
end)

Citizen.CreateThread(function() -- Thread for  timer
	while true do
		Citizen.Wait(1000)
		Faketimer = Faketimer + 1
	end
end)

-- F  U  N  C  T  I  O  N  S
function GetPed() return GetPlayerPed(-1) end

function text(x,y,scale,text)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(255,255,255,255)
    SetTextDropShadow(0,0,0,0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function FishGUI(bool)
	if not bool then return end
	DrawRect(PosX,PosY+0.005,TimerAnimation,0.005,255,255,0,255)
	DrawRect(PosX,PosY,0.1,0.01,0,0,0,255)
	TimerAnimation = TimerAnimation - 0.0001025
	if BarAnimation >= SuccessLimit then
		DrawRect(PosX,PosY,BarAnimation,0.01,102,255,102,150)
		SetPadShake(0, 100, 60)
	else
		DrawRect(PosX,PosY,BarAnimation,0.01,255,51,51,150)
		StopPadShake(0)
	end
	if BarAnimation <= 0 then
		up = true
	end
	if BarAnimation >= 0.1	then -- <- Don't use  fucking posY you stupid shit makes it un changeable
		up = false
	end
	if not up then
		BarAnimation = BarAnimation - AnimationSpeed
	else
		BarAnimation = BarAnimation + AnimationSpeed
	end
end
function PlayAnim(ped,base,sub,nr,time)
	Citizen.CreateThread(function()
		RequestAnimDict(base)
		while not HasAnimDictLoaded(base) do
			Citizen.Wait(1)
		end
		if IsEntityPlayingAnim(ped, base, sub, 3) then
			ClearPedSecondaryTask(ped)
		else
			for i = 1,nr do
				TaskPlayAnim(ped, base, sub, 8.0, -8, -1, 16, 0, 0, 0, 0)
				Citizen.Wait(time)
			end
		end
	end)
end

function AttachEntityToPed(prop,bone_ID,x,y,z,RotX,RotY,RotZ)
	BoneID = GetPedBoneIndex(GetPed(), bone_ID)
	obj = CreateObject(GetHashKey(prop),  1729.73,  6403.90,  34.56,  true,  true,  true)
	vX,vY,vZ = table.unpack(GetEntityCoords(GetPed()))
	xRot, yRot, zRot = table.unpack(GetEntityRotation(GetPed(),2))
	AttachEntityToEntity(obj,  GetPed(),  BoneID, x,y,z, RotX,RotY,RotZ,  false, false, false, false, 2, true)
	return obj
end
function Chat(text)
	TriggerEvent("gd_utils:notify", text)
end

RegisterNetEvent( 'boatAnchor' )

local anchored = false
local boat = nil
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local ped = GetPlayerPed(-1)
		if IsPedInAnyBoat(ped) then
		boat  = GetVehiclePedIsIn(ped, true)
		end
		if IsControlJustPressed(1, 82) and not IsPedInAnyVehicle(ped) and boat ~= nil then
			if not anchored then
				SetBoatAnchor(boat, true)
				ShowNotification( "Boat anchored!" )
			else
				SetBoatAnchor(boat, false)
				ShowNotification( "Boat anchor removed!" )
			end
			anchored = not anchored
		end
				if IsPedInAnyVehicle(ped) then
			anchored = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local ped = GetPlayerPed(-1)
		if IsPedInAnyBoat(ped) then
		boat  = GetVehiclePedIsIn(ped, true)
		end
		if IsControlJustPressed(1, 81) and not IsPedInAnyVehicle(ped) and boat ~= nil then
			if not anchored then
				FreezeEntityPosition(boat, true)
				ShowNotification( "Boat anchored!" )
			else
				FreezeEntityPosition(boat, false)
				ShowNotification( "Boat anchor removed!" )
			end
			anchored = not anchored
		end
				if IsPedInAnyVehicle(ped) then
			anchored = false
		end
	end
end)

function ShowNotification( text )
	TriggerEvent("gd_utils:notify", text)
    -- SetNotificationTextEntry( "STRING" )
    -- AddTextComponentSubstringPlayerName( text )
    -- DrawNotification( false, false )
end

function log( msg )
    Citizen.Trace( "\n[DEBUG]: " .. msg )
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawText(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 500, true)
end

function drawMessage(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 20000, false)
end

--------------------------------EDITED BY Collins--------------------------------
