-- ###################################
--
--        C   O   N   F   I   G
--
-- ###################################



-- show/hide compoent
local HUD = {

	Speed 			= 'mph', -- kmh or mph

	DamageSystem 	= true,

	SpeedIndicator 	= true,

	ParkIndicator 	= false,

	Top 			= false, -- ALL TOP PANAL ( oil, dsc, plate, fluid, ac )

	Plate 			= false, -- only if Top is false and you want to keep Plate Number

}

Citizen.CreateThread(function()
    local use_metric = getActualKvp("use_metric")
    if use_metric then
		HUD.Speed = 'kmh'
	else
		HUD.Speed = 'mph'
	end
end)

RegisterNetEvent("omni:toggle:mphkmh")
AddEventHandler("omni:toggle:mphkmh", function()
	if HUD.Speed == 'mph' then
		setActualKvp("use_metric", true)
		HUD.Speed = 'kmh'
		TriggerEvent("gd_utils:notify", "Speedometer set to ~y~KMH")
	else
		setActualKvp("use_metric", false)
		HUD.Speed = 'mph'
		TriggerEvent("gd_utils:notify", "Speedometer set to ~y~MPH")
	end
end)

-- move all ui
local UI = {

	x =  0.010 ,	-- Base Screen Coords 	+ 	 x
	y = -0.001 ,	-- Base Screen Coords 	+ 	-y

}





-- ###################################
--
--             C   O   D   E
--
-- ###################################



Citizen.CreateThread(function()
	-- LOCAL OPTIMIZATION
    local Wait = Wait
	local GetPlayerPed = GetPlayerPed
	local IsPedInAnyVehicle = IsPedInAnyVehicle
	local GetVehiclePedIsIn = GetVehiclePedIsIn
	local GetVehicleNumberPlateText = GetVehicleNumberPlateText
	local IsVehicleStopped = IsVehicleStopped
	local GetVehicleEngineHealth = GetVehicleEngineHealth
	local GetVehicleBodyHealth = GetVehicleBodyHealth
	local IsVehicleInBurnout = IsVehicleInBurnout
	local GetEntityModel = GetEntityModel
	local GetEntitySpeed = GetEntitySpeed
	local IsThisModelABoat = IsThisModelABoat
	local IsThisModelAPlane = IsThisModelAPlane
	local IsThisModelAHeli = IsThisModelAHeli
	local drawTxt = drawTxt
	local drawRct = drawRct
	local IsPedInFlyingVehicle = IsPedInFlyingVehicle
	local PlayerPedId = PlayerPedId
	local GetEntityCoords = GetEntityCoords
	local GetAspectRatio = GetAspectRatio
	local GetLocalTime = GetLocalTime
	local GetVehicleTrailerVehicle = GetVehicleTrailerVehicle
	local PlayerPedId = PlayerPedId
	local isCruiseControlEnabled = false
	local common = exports['omni_common']
	local system = exports['es_system']
    -- END LOCAL OPTIMIZATION
	while true do
		Wait(0)
		local MyPed = PlayerPedId()

		if(IsPedInAnyVehicle(MyPed, false))then
			EnsureDict("carhud")
			local Minimap = common:GetMinimapAnchor()

			local MyPedVeh = GetVehiclePedIsIn(MyPed,false)
			local PlateVeh = GetVehicleNumberPlateText(MyPedVeh)
			local VehStopped = IsVehicleStopped(MyPedVeh)
			local VehEngineHP = GetVehicleEngineHealth(MyPedVeh)
			local VehBodyHP = GetVehicleBodyHealth(MyPedVeh)
			local VehBurnout = IsVehicleInBurnout(MyPedVeh)
			local VehModel = GetEntityModel(MyPedVeh)
			local VehSpeed = GetEntitySpeed(MyPedVeh)
			local speed_type = "mph"
			if HUD.Speed == 'kmh' then
				Speed = VehSpeed * 3.6
				speed_type = "kmh"
			elseif HUD.Speed == 'mph' then
				Speed = VehSpeed * 2.236936
				speed_type = "mph"
			else
				Speed = 0.0
			end
			local isBoat, isPlane, isHeli = IsThisModelABoat(VehModel), IsThisModelAPlane(VehModel), IsThisModelAHeli(VehModel)
			local useKnots = (isBoat or isPlane or isHeli)
			local isFlyingVehicle = IsPedInFlyingVehicle(MyPed)

			if useKnots then
				Speed = (VehSpeed * 3.6) * 0.539957
				speed_type = "knots"
			end

			if HUD.Top then
				drawTxt(UI.x + 0.563, 	UI.y + 1.2624, 1.0,1.0,0.55, "~w~" .. PlateVeh, 255, 255, 255, 255)
				drawRct(UI.x + 0.0625, 	UI.y + 0.768, 0.045, 0.037, 0,0,0,150)
				drawRct(UI.x + 0.028, 	UI.y + 0.777, 0.029, 0.02, 0,0,0,150)
				drawRct(UI.x + 0.1131, 	UI.y + 0.777, 0.031, 0.02, 0,0,0,150)
				drawRct(UI.x + 0.1445, 	UI.y + 0.777, 0.0129, 0.028, 0,0,0,150)
				drawRct(UI.x + 0.014, 	UI.y + 0.777, 0.013, 0.028, 0,0,0,150)
				drawRct(UI.x + 0.014, 	UI.y + 0.768, 0.043, 0.007, 0,0,0,150)
				drawRct(UI.x + 0.0279, 	UI.y + 0.798, 0.0293, 0.007, 0,0,0,150)
				drawRct(UI.x + 0.0575, 	UI.y + 0.768, 0.004, 0.037, 0,0,0,150)
				drawRct(UI.x + 0.1131, 	UI.y + 0.768, 0.044, 0.007, 0,0,0,150)
				drawRct(UI.x + 0.1131, 	UI.y + 0.798, 0.031, 0.007, 0,0,0,150)
				drawRct(UI.x + 0.1085, 	UI.y + 0.768, 0.004, 0.037, 0,0,0,150)

				if VehBurnout then
					drawTxt(UI.x + 0.535, UI.y + 1.266, 1.0,1.0,0.44, "~r~DSC", 255, 255, 255, 200)
				else
					drawTxt(UI.x + 0.535, UI.y + 1.266, 1.0,1.0,0.44, "DSC", 255, 255, 255, 150)
				end

				if (VehEngineHP > 0) and (VehEngineHP < 300) then
					drawTxt(UI.x + 0.619, UI.y + 1.266, 1.0,1.0,0.45, "~y~Fluid", 255, 255, 255, 200)
					drawTxt(UI.x + 0.514, UI.y + 1.269, 1.0,1.0,0.45, "~w~~y~Oil", 255, 255, 255, 200)
					drawTxt(UI.x + 0.645, UI.y + 1.270, 1.0,1.0,0.45, "~y~AC", 255, 255, 255, 200)
				elseif VehEngineHP < 1 then
					drawRct(UI.x + 0.159, UI.y + 0.809, 0.005, 0,0,0,0,100)  -- panel damage
					drawTxt(UI.x + 0.645, UI.y + 1.270, 1.0,1.0,0.45, "~r~AC", 255, 255, 255, 200)
					drawTxt(UI.x + 0.619, UI.y + 1.266, 1.0,1.0,0.45, "~r~Fluid", 255, 255, 255, 200)
					drawTxt(UI.x + 0.514, UI.y + 1.269, 1.0,1.0,0.45, "~w~~r~Oil", 255, 255, 255, 200)
					drawTxt(UI.x + 0.645, UI.y + 1.270, 1.0,1.0,0.45, "~r~AC", 255, 255, 255, 200)
				else
					drawTxt(UI.x + 0.619, UI.y + 1.266, 1.0,1.0,0.45, "Fluid", 255, 255, 255, 150)
					drawTxt(UI.x + 0.514, UI.y + 1.269, 1.0,1.0,0.45, "Oil", 255, 255, 255, 150)
					drawTxt(UI.x + 0.645, UI.y + 1.270, 1.0,1.0,0.45, "~w~AC", 255, 255, 255, 150)
				end
				if HUD.ParkIndicator then
					drawRct(UI.x + 0.159, UI.y + 0.768, 0.0122, 0.038, 0,0,0,150)
					if VehStopped then
						drawTxt(UI.x + 0.6605, UI.y + 1.262, 1.0,1.0,0.6, "~r~P", 255, 255, 255, 200)
					else
						drawTxt(UI.x + 0.6605, UI.y + 1.262, 1.0,1.0,0.6, "P", 255, 255, 255, 150)
					end
				end
			else
				if HUD.Plate then
					drawTxt(UI.x + 0.61, 	UI.y + 1.385, 1.0,1.0,0.55, "~w~" .. PlateVeh, 255, 255, 255, 255)

					drawRct(UI.x + 0.11, 	UI.y + 0.89, 0.045, 0.037, 0,0,0,150)
				end
				if HUD.ParkIndicator then
					drawRct(UI.x + 0.142, UI.y + 0.848, 0.0122, 0.038, 0,0,0,150)

					if VehStopped then
						drawTxt(UI.x + 0.643, UI.y + 1.34, 1.0,1.0,0.6, "~r~P", 255, 255, 255, 200)
					else
						drawTxt(UI.x + 0.643, UI.y + 1.34, 1.0,1.0,0.6, "P", 255, 255, 255, 150)
					end
				end
			end
			if HUD.SpeedIndicator then
				local speedPanelWidth = 0.046
				local speedPanelHeight = 0.03
				drawRct(Minimap.right_x - speedPanelWidth, Minimap.bottom_y - Minimap.height / 10 - speedPanelHeight, speedPanelWidth, speedPanelHeight,0,0,0,150) -- Speed panel
				local text_x = Minimap.right_x - speedPanelWidth
				local text_y = Minimap.bottom_y - Minimap.height / 10 - speedPanelHeight
				if speed_type == 'kmh' then
					drawTxt(text_x, text_y, 1.0,1.0,0.64 , "~w~" .. math.ceil(Speed), 255, 255, 255, 255)
					drawTxt(text_x + speedPanelWidth/2.1, text_y + 0.01, 1.0,1.0,0.4, "~w~ km/h", 255, 255, 255, 255)
				elseif speed_type == "knots" then
					drawTxt(text_x, text_y, 1.0,1.0,0.64 , "~w~" .. math.ceil(Speed), 255, 255, 255, 255)
					drawTxt(text_x + speedPanelWidth/2.1, text_y + 0.01, 1.0,1.0,0.4, "~w~ nm/h", 255, 255, 255, 255)
				elseif speed_type == 'mph' then
					drawTxt(text_x, text_y, 1.0,1.0,0.64 , "~w~" .. math.ceil(Speed), 255, 255, 255, 255)
					drawTxt(text_x + speedPanelWidth/2.1, text_y + 0.01, 1.0,1.0,0.4, "~w~ mph", 255, 255, 255, 255)
				else

				end
				if system:GetGlobalCruiseControl() then
					DrawSprite("carhud", "CruiseControl", Minimap.right_x - speedPanelWidth - (speedPanelHeight / GetAspectRatio(0)) * 0.5, Minimap.bottom_y - Minimap.height / 10 - 0.015, speedPanelHeight / GetAspectRatio(0), speedPanelHeight, 0, 255, 255, 255, 255)
				end
			end
			if isHeli or isPlane or isFlyingVehicle then
				local speedPanelWidth = 0.040
				local speedPanelHeight = 0.03
				drawRct(Minimap.left_x, Minimap.bottom_y - Minimap.height / 10 - speedPanelHeight, speedPanelWidth, speedPanelHeight,0,0,0,150) -- Speed panel
				local text_x = Minimap.left_x
				local text_y = Minimap.bottom_y - Minimap.height / 10 - speedPanelHeight
				local aircraftPos = GetEntityCoords(MyPedVeh)
				local aircraftZ = aircraftPos.z
				local altitude = math.floor(aircraftZ * 3.281)
				drawTxt(text_x, text_y, 1.0,1.0,0.64 , "~w~" .. math.ceil(altitude), 255, 255, 255, 255)
				drawTxt(text_x + speedPanelWidth/1.45, text_y + 0.01, 1.0,1.0,0.4, "~w~ ft", 255, 255, 255, 255)
				drawTxt(text_x, text_y - speedPanelHeight/1.5, 1.0,1.0,0.4, "~w~altitude", 255, 255, 255, 255)
			end

			if HUD.DamageSystem then
				-- Bars now use MINIMAPPER
				local safezone = 3
				local width = math.max(15, 5 * GetAspectRatio(0))
				local safezone_x = safezone * Minimap.xunit
				local safezone_y = safezone * Minimap.yunit
				local barwidth = width * (Minimap.xunit)
				local offset_x = 5 * Minimap.xunit
				local offset_y = 0 * Minimap.yunit
		        local _, _, _, _, _, second = GetLocalTime()
				drawRct(Minimap.right_x + offset_x, Minimap.top_y, barwidth, Minimap.height, 0, 0, 0, 200)
				drawRct(Minimap.right_x + offset_x + barwidth + safezone_x, Minimap.top_y, barwidth, Minimap.height, 0, 0, 0, 200)
				if VehBodyHP >= 350 or (VehBodyHP < 350 and second % 2 == 0) then
					drawRct(Minimap.right_x + offset_x + safezone_x, Minimap.bottom_y, (width - safezone * 2) * Minimap.xunit, (Minimap.height/1000) * (1000 - VehBodyHP) * -1, 255, 0, 0, 200)
				else
					drawRct(Minimap.right_x + offset_x + safezone_x, Minimap.bottom_y, (width - safezone * 2) * Minimap.xunit, (Minimap.height/1000) * (1000 - VehBodyHP) * -1, 255, 150, 0, 200)
				end
				if VehEngineHP >= 350 or (VehEngineHP < 350 and second % 2 == 1) then
					drawRct(Minimap.right_x + offset_x + barwidth + safezone_x * 2, Minimap.bottom_y, (width - safezone * 2) * Minimap.xunit, (Minimap.height/1000) * (1000 - VehEngineHP) * -1, 255, 0, 0, 200)
				else
					drawRct(Minimap.right_x + offset_x + barwidth + safezone_x * 2, Minimap.bottom_y, (width - safezone * 2) * Minimap.xunit, (Minimap.height/1000) * (1000 - VehEngineHP) * -1, 255, 150, 0, 200)
				end
				local hasTrailer, MyPedTrailer = GetVehicleTrailerVehicle(MyPedVeh)
				if hasTrailer then
					local TrailerHP = GetVehicleBodyHealth(MyPedTrailer)
					drawRct(Minimap.right_x + offset_x + barwidth * 2 + safezone_x * 2, Minimap.top_y, barwidth, Minimap.height, 0, 0, 0, 200)
					if TrailerHP >= 350 or (TrailerHP < 350 and second % 2 == 0) then
						drawRct(Minimap.right_x + offset_x + barwidth * 2 + safezone_x * 3, Minimap.bottom_y, (width - safezone * 2) * Minimap.xunit, (Minimap.height/1000) * (1000 - TrailerHP) * -1, 255, 0, 0, 200)
					else
						drawRct(Minimap.right_x + offset_x + barwidth * 2 + safezone_x * 3, Minimap.bottom_y, (width - safezone * 2) * Minimap.xunit, (Minimap.height/1000) * (1000 - TrailerHP) * -1, 255, 150, 0, 200)
					end
				end
				-- local s = 0.5
				-- local sv = (s / 1.77777778) * (0.173 / 1.77777778)
				-- local hs = 0.005 * s
				-- local vs = 0.173 * sv
				-- drawRct(UI.x + 0.159 - hs, 	UI.y + 0.809 - vs, 0.005 + hs*2,0.173 + vs*2,0,0,0,200)
				-- drawRct(UI.x + 0.1711 - hs, 	UI.y + 0.809 - vs, 0.005 + hs*2,0.173 + vs*2,0,0,0,200)
				-- drawRct(UI.x + 0.159, 	UI.y + 0.809, 0.005,0.173,255,0,0,100)
				-- drawRct(UI.x + 0.1711, 	UI.y + 0.809, 0.005,0.173,255,0,0,100)
				-- drawRct(UI.x + 0.1711, 	UI.y + 0.809, 0.005,VehBodyHP/5800,0,0,0,100)
				-- drawRct(UI.x + 0.159, 	UI.y + 0.809, 0.005, VehEngineHP / 5800,0,0,0,100)
			end
		end
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y - 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function EnsureDict(dictionary)
    if not HasStreamedTextureDictLoaded(dictionary) then
        RequestStreamedTextureDict(dictionary, true)
        while not HasStreamedTextureDictLoaded(dictionary) do
            Wait(1)
        end
    end
end
