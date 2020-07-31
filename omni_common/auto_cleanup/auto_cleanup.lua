
-- Auto cleanup of vehicle carnage
Citizen.CreateThread(function()
    local EnumerateVehicles = EnumerateVehicles
    local GetVehicleEngineHealth = GetVehicleEngineHealth
    local NetworkHasControlOfEntity = NetworkHasControlOfEntity
    local SetEntityAsNoLongerNeeded = SetEntityAsNoLongerNeeded
    local DeleteEntity = DeleteEntity
    local Wait = Wait
    while true do
        Wait(30000)
        for vehicle in EnumerateVehicles() do
            if GetEntityHealth(vehicle) == 0 or IsEntityDead(vehicle) then
                if NetworkHasControlOfEntity(vehicle) then
                    if not DecorExistOn(vehicle, "omni_nocleanup") then
                        SetEntityAsNoLongerNeeded(vehicle)
                        DeleteEntity(vehicle)
                    end
                end
            end
            Wait(0)
        end
    end
end)
