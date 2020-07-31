local IndicatorL = false
local IndicatorR = false

Citizen.CreateThread(function()
    local Wait = Wait
    local IsControlJustPressed = IsControlJustPressed
    local IsPedInAnyVehicle = IsPedInAnyVehicle
    local GetPlayerPed = GetPlayerPed
    local TriggerEvent = TriggerEvent
    while true do
        Wait(0)
		if IsControlJustPressed(1, 84) then -- left (Default Button = Left Arrow)
			if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
				TriggerEvent('Indicator', 'left')
			end
		end

		if IsControlJustPressed(1, 83) then --right (Default Button = Right Arrow)
			if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
				TriggerEvent('Indicator', 'right')
			end
		end

		if IsControlJustPressed(1, 243) then --hazard (Default button = Y)
			if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
				TriggerEvent('Indicator', 'right')
				TriggerEvent('Indicator', 'left')
			end
		end
    end
end)

AddEventHandler('Indicator', function(dir)
	Citizen.CreateThread(function()
		local Ped = GetPlayerPed(-1)
		if IsPedInAnyVehicle(Ped, true) then
			local Veh = GetVehiclePedIsIn(Ped, false)
			if GetPedInVehicleSeat(Veh, -1) == Ped then
				if dir == 'left' then
					IndicatorL = not IndicatorL
					TriggerServerEvent('IndicatorL', IndicatorL)
				elseif dir == 'right' then
					IndicatorR = not IndicatorR
					TriggerServerEvent('IndicatorR', IndicatorR)
				end
			end
		end
	end)
end)

RegisterNetEvent('updateIndicators')
AddEventHandler('updateIndicators', function(PID, dir, Toggle)
	--if isPlayerOnline(PID) then
    local player = GetPlayerFromServerId(PID)
    if player ~= -1 then
    	local Veh = GetVehiclePedIsIn(GetPlayerPed(), false)
    	if dir == 'left' then
    		SetVehicleIndicatorLights(Veh, 1, Toggle)
    	elseif dir == 'right' then
    		SetVehicleIndicatorLights(Veh, 0, Toggle)
    	end
	end
	--end
end)
