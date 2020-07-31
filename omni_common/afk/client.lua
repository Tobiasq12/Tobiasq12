-- CONFIG --

-- AFK Kick Time Limit (in seconds)
secondsUntilKick = 900

-- Warn players if 3/4 of the Time Limit ran up
kickWarning = true

time = secondsUntilKick

-- CODE --

Citizen.CreateThread(function()
	local Wait = Wait
	local GetPlayerPed = GetPlayerPed
	local GetEntityCoords = GetEntityCoords
	local TriggerEvent = TriggerEvent
	local TriggerServerEvent = TriggerServerEvent
	while true do
		Wait(1000)

		playerPed = GetPlayerPed(-1)
		if playerPed then
			currentPos = GetEntityCoords(playerPed, true)

			if currentPos == prevPos then
				if time > 0 then
					if kickWarning and time == math.ceil(secondsUntilKick / 4) then
						TriggerEvent("chatMessage", "ANTI-AFK", {255, 0, 0}, "^1You are currently AFK. Move now to prevent being kicked.")
						TriggerEvent("gd_utils:overlay", " ", "~r~You are currently AFK", "~w~Move now to prevent being kicked.")
					end

					time = time - 1
				else
					TriggerServerEvent("omni:kickAFK")
				end
			else
				time = secondsUntilKick
			end

			prevPos = currentPos
		end
	end
end)

RegisterNetEvent("omni:resetAFK")
AddEventHandler("omni:resetAFK", function()
	time = secondsUntilKick
end)
