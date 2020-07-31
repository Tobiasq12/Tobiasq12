Citizen.CreateThread(function()
    local Wait = Wait
    local GetVehiclePedIsIn = GetVehiclePedIsIn
    local PlayerPedId = PlayerPedId
    local DoesEntityExist = DoesEntityExist
    local IsEntityDead = IsEntityDead
    local GetEntityModel = GetEntityModel
    local IsVehicleModel = IsVehicleModel
    local GetHashKey = GetHashKey
    local IsThisModelABoat = IsThisModelABoat
    local IsThisModelAHeli = IsThisModelAHeli
    local IsThisModelAPlane = IsThisModelAPlane
    local IsThisModelABike = IsThisModelABike
    local IsThisModelABicycle = IsThisModelABicycle
    local IsEntityInAir = IsEntityInAir
    local DisableControlAction = DisableControlAction
    while true do
        Wait(0)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if DoesEntityExist(veh) and not IsEntityDead(veh) then
            local model = GetEntityModel(veh)
            local class = GetVehicleClass(veh)
            -- If it's not a boat, plane or helicopter, and the vehilce is off the ground with ALL wheels, then block steering/leaning left/right/up/down.
            if not IsVehicleModel(veh, `DELUXO`) and not (class == 9) and not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and not IsThisModelABike(model) and not IsThisModelABicycle(model) and IsEntityInAir(veh) then
                DisableControlAction(0, 59) -- leaning left/right
                DisableControlAction(0, 60) -- leaning up/down
            end
            if class == 9 or IsVehicleModel(veh, `SANCHEZ`) or IsVehicleModel(veh, `SANCHEZ2`) then
                SetIgnoreNoGpsFlag(true)
            else
                SetIgnoreNoGpsFlag(false)
            end
        end
    end
end)
