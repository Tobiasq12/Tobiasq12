

Citizen.CreateThread(function()
    local Script = MainScript:new()
    Script:MainScript()
    local IsTornadoActive = false
    local Tornado = nil

    RegisterNetEvent("omni_tornado:spawn")
    AddEventHandler("omni_tornado:spawn", function(pos, dest)
        pos = vec3(pos.x, pos.y, pos.z)
        dest = vec3(dest.x, dest.y, dest.z)
        if not Tornado then
            Tornado = Script._factory:CreateVortex(pos)
        end
        Tornado._position = pos
        Tornado._destination = dest
        IsTornadoActive = true

        Citizen.Trace("Tornado spawned.")
    end)

    RegisterNetEvent("omni_tornado:setPosition")
    AddEventHandler("omni_tornado:setPosition", function(pos)
        pos = vec3(pos.x, pos.y, pos.z)
        if not Tornado then
            Tornado = Script._factory:CreateVortex(pos)
        end
        Tornado._position = pos
    end)

    RegisterNetEvent("omni_tornado:setDestination")
    AddEventHandler("omni_tornado:setDestination", function(dest)
        dest = vec3(dest.x, dest.y, dest.z)
        if not Tornado then
            Tornado = Script._factory:CreateVortex(dest)
        end
        Tornado._destination = dest
    end)

    RegisterNetEvent("omni_tornado:delete")
    AddEventHandler("omni_tornado:delete", function()
        IsTornadoActive = false
    end)

    RegisterNetEvent("omni_tornado:whereIsIt")
    AddEventHandler("omni_tornado:whereIsIt", function()
        if IsTornadoActive then
            local pos = table.unpack(Tornado._position)
            local dest = table.unpack(Tornado._destination)
            TriggerServerEvent("omni_tornado:hereItIs", pos, dest)
        end
    end)

    while true do
        if IsTornadoActive and Tornado then
            Script:OnUpdate(GetGameTimer())
            local dist = #(Tornado._position - GetEntityCoords(GetPlayerPed(-1), false))
        else
            if Tornado then
                -- Tornado._lock = true
                -- Script:OnUpdate(GetGameTimer())
                Script._factory:RemoveAll()
                Tornado = nil

                Citizen.Trace("Tornado dissipated.")
            end
        end
        Wait(15)
    end

end)
