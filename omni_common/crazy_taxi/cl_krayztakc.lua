local CrazyTaxi = {
    disabled = false,
    draw = false,
    pos = vec3(0.0, 0.0, 0.0),
    type = 20,
    scale = 1.0,
    r = 255,
    g = 255,
    b = 0,
    instances = {},
}

Citizen.CreateThread(function()
    CrazyTaxi.disabled = getActualKvp("disableCrazyTaxi")
end)

RegisterNetEvent("omni_common:crazy_taxi:toggle")
AddEventHandler("omni_common:crazy_taxi:toggle", function()
    CrazyTaxi.disabled = not CrazyTaxi.disabled
    setActualKvp("disableCrazyTaxi", CrazyTaxi.disabled)
end)

function EnsureCrazyTaxi(name)
    if not CrazyTaxi.instances[name] then
        CrazyTaxi.instances[name] = {
            draw = false,
            pos = vec3(0.0, 0.0, 0.0),
            type = 20,
            scale = 1.0,
            r = 255,
            g = 255,
            b = 0,
        }
    end
end

function SetNewCrazyTaxiDestination(name, pos, r, g, b)
    EnsureCrazyTaxi(name)
    local instance = CrazyTaxi.instances[name]
    if instance then
        SetCrazyTaxiScale(name, 1.0)
        SetCrazyTaxiType(name, 20)
        SetCrazyTaxiColor(name, r, g, b)
        SetCrazyTaxiDestination(name, pos)
    end
end

function SetCrazyTaxiDestination(name, pos)
    EnsureCrazyTaxi(name)
    local instance = CrazyTaxi.instances[name]
    if instance then
        instance.pos = vec3(pos.x, pos.y, pos.z)
        instance.draw = true
    end
end

function SetCrazyTaxiScale(name, scale)
    EnsureCrazyTaxi(name)
    local instance = CrazyTaxi.instances[name]
    if instance then
        instance.scale = scale
    end
end

function SetCrazyTaxiType(name, type)
    EnsureCrazyTaxi(name)
    local instance = CrazyTaxi.instances[name]
    if instance then
        instance.type = type
    end
end
function SetCrazyTaxiColor(name, r, g, b)
    EnsureCrazyTaxi(name)
    local instance = CrazyTaxi.instances[name]
    if instance then
        instance.r = math.floor(r)
        instance.g = math.floor(g)
        instance.b = math.floor(b)
    end
end

function HideCrazyTaxi(name)
    if not name then
        CrazyTaxi.draw = false
    else
        EnsureCrazyTaxi(name)
        local instance = CrazyTaxi.instances[name]
        if instance then
            instance.draw = false
        end
    end
end

function ShowCrazyTaxi(name)
    if not name then
        CrazyTaxi.draw = true
    else
        EnsureCrazyTaxi(name)
        local instance = CrazyTaxi.instances[name]
        if instance then
            instance.draw = true
        end
    end
end

local prevscale = 0.0
Citizen.CreateThread(function()
    while true do
        if not CrazyTaxi.disabled then
            local pos = GetEntityCoords(PlayerPedId())
            local zoff = 0.0
            for _, instance in next, CrazyTaxi.instances do
                if instance.draw then
                    local dist = #(pos - instance.pos)
                    if dist < 5.0 then
                        instance.draw = false
                    else
                        local offset = pos - instance.pos
                        local alpha = math.floor(math.max(math.min((dist - 100.0) / 2, 255), 0))
                        local scale = lerp(prevscale, (#(GetGameplayCamCoords() - GetEntityCoords(PlayerPedId())) / 10.0) * instance.scale, 0.025)
                        prevscale = scale
                        local function drawMark(pos)
                            local scale = scale * 1.5
                            -- DrawMarker(instance.type, pos, offset * vec3(1.0, 1.0, 1.0), 90.0, 0.0, 0.0, -1.25 * scale, -1.25 * scale, -1.25 * scale, 0, 0, 0, alpha)
                            DrawMarker(instance.type, pos, offset * vec3(1.0, 1.0, 1.0), -90.0, 0.0, 0.0, 1.0 * scale, 1.0 * scale, 1.0 * scale, instance.r, instance.g, instance.b, alpha)
                        end
                        drawMark(pos + vec3(0.0, 0.0, math.max(1.0, scale * (1.5 + zoff))))
                    end
                    zoff = zoff + 0.5
                end
            end
        end
        Wait(0)
    end
end)
