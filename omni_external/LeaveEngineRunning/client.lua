Citizen.CreateThread(function()
    local Wait = Wait
    local GetPlayerPed = GetPlayerPed
    local GetVehiclePedIsIn = GetVehiclePedIsIn
    local DoesEntityExist = DoesEntityExist
    local IsPedInAnyVehicle = IsPedInAnyVehicle
    local IsControlPressed = IsControlPressed
    local IsEntityDead = IsEntityDead
    local IsPauseMenuActive = IsPauseMenuActive
    local GetIsVehicleEngineRunning = GetIsVehicleEngineRunning
    local SetVehicleEngineOn = SetVehicleEngineOn
    while true do
        Wait(0)

        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, true)

        if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
            local engineWasRunning = GetIsVehicleEngineRunning(veh)
            for i=1,10 do
                Wait(200)
                if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) and not IsPauseMenuActive() then
                    if (engineWasRunning) then
                        SetVehicleEngineOn(veh, true, true, true)
                    end
                end
            end
        end
    end
end)
