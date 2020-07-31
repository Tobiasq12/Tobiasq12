function getActualKvp(name)
    local kvp = GetResourceKvpInt(name)
    if kvp == nil or kvp == 0 then
        return false, "nil"
    end
    if kvp == 2 then
        return false, "zero"
    end
    return true, "actually " .. kvp
end

function setActualKvp(name, bool)
    if bool then
        SetResourceKvpInt(name, 3)
    else
        SetResourceKvpInt(name, 2)
    end
    TriggerServerEvent("omni:stat:count", "KVP: Set " .. name .. " to " .. (bool and "true" or "false"), 1)
end

function DrawSprite3D(dict, sprite, x, y, z, s, a)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local gcc = GetGameplayCamCoords()
    local dist = #(gcc - vec3(x, y, z))

    if s == nil then
        s = 1.0
    end
    if a == nil then
        s = 255
    end

    local scale = ((1 / (dist * 4)) * 2) * s
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetDrawOrigin(x, y, z, 0)
        DrawSprite(dict, sprite, 0.0, 0.0, scale, scale * GetAspectRatio(0), 0.0, 255, 255, 255, a)
        ClearDrawOrigin()
    end
end
