-- Flightinstruments by IceHax

local enable_flight_instruments = true
local old_flight_instruments = false
local enable_flight_odometer = true
local simple_altometer = false
local enable_flight_speedometer_odometer = false
local enable_flight_heading_odometer = false
local enable_static_flight_heading_dial = false

Citizen.CreateThread(function()
    enable_flight_instruments, r = getActualKvp("enable_flight_instruments")
    if r == "nil" then enable_flight_instruments = not enable_flight_instruments end

    enable_flight_odometer, r = getActualKvp("enable_flight_odometer")
    if r == "nil" then enable_flight_odometer = true end

    old_flight_instruments = getActualKvp("old_flight_instruments")
    simple_altometer = getActualKvp("simple_altometer")

    enable_flight_speedometer_odometer = getActualKvp("enable_flight_speedometer_odometer")
    enable_flight_heading_odometer = getActualKvp("enable_flight_heading_odometer")

    enable_static_flight_heading_dial = getActualKvp("enable_static_flight_heading_dial")
end)

function EnsureDict(dictionary)
    if not HasStreamedTextureDictLoaded(dictionary) then
        RequestStreamedTextureDict(dictionary, true)
        while not HasStreamedTextureDictLoaded(dictionary) do
            Wait(1)
        end
    end
end

local function GetOdometerInt(num, precision, flat)
    local prefix = math.floor(num) % 10
    local suffix = ((math.floor(num * 100) / 10) % 10)
    if simple_altometer or flat then
        suffix = 1
    else
        if suffix <= 6 - precision * 4 then
            suffix = 1
        elseif suffix <= 7 - precision * 2 then
            suffix = 2
        elseif suffix <= 8 - precision * 2 then
            suffix = 3
        elseif suffix <= 9 - precision * 1 then
            suffix = 4
        else
            suffix = 1
            prefix = (prefix + 1) % 10
        end
    end
    return prefix .. "_" .. suffix
end

function DrawFlightInstruments()
    local plane = GetVehiclePedIsIn(PlayerPedId(), false)
    local speed = GetEntitySpeed(plane) * 2.236936
    local realspeed = speed
    local altitude = GetEntityCoords(PlayerPedId()).z * 3.28084
    -- local altitude = GetEntityHeightAboveGround(PlayerPedId()) * 3.28084
    local heading = GetEntityHeading(plane)
    local verticalspeed = GetEntityVelocity(plane).z * 196.850394

    local headingText = math.floor((heading / 10) + 0.5)
    if speed < 40 then speed = 40 end
    if speed > 200 then speed = 200 end
    if altitude<0 then altitude = 0 end
    if verticalspeed>2000 then verticalspeed = 2000 elseif verticalspeed < -2000 then verticalspeed = -2000 end
    local flightstate

    EnsureDict("odometer")
    EnsureDict("flightinstruments")

    -- 20 - 220
    -- 360 / 200
    local xoff = -0.25
    local yoff = -0.07
    if old_flight_instruments then
        xoff = 0.0
        yoff = 0.0
    else
        yoff = yoff + 0.07 * math.min(math.max(((1/40) * (realspeed-20)), 0.0), 1.0)
        -- print("yoff", yoff)
    end
    local xscale = 1.0
    local yscale = 1.0
    local aspect = GetAspectRatio(0)

    local gearState = GetLandingGearState(GetVehiclePedIsIn(GetPlayerPed(-1), false))
    local states = {
        "gear-green",
        "gear-none",
        "gear-none",
        "gear-both",
        "gear-red"
    }
    local gearTexture = states[gearState + 1] or "gear-red"

    DrawSprite("flightinstruments", "speedometer", xoff + 0.9, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, 0, 255, 255, 255, 255)
    DrawSprite("flightinstruments", "speedometer_needle", xoff + 0.9, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, ((speed-20) / 0.5555555555555556), 255, 255, 255, 255)
    DrawSprite("flightinstruments", "altimeter", xoff + 0.80, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, 0, 255, 255, 255, 255)
    DrawSprite("flightinstruments", "altimeter-needle100", xoff + 0.80, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, altitude/100*36, 255, 255, 255, 255)
    DrawSprite("flightinstruments", "altimeter-needle1000", xoff + 0.80, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, altitude/1000*36, 255, 255, 255, 255)
    DrawSprite("flightinstruments", "altimeter-needle10000", xoff + 0.80, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, altitude/10000*36, 255, 255, 255, 255)
    if enable_static_flight_heading_dial then
        DrawSprite("flightinstruments", "heading", xoff + 0.70, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, 0, 255, 255, 255, 255)
        DrawSprite("flightinstruments", "heading_needle", xoff + 0.70, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, -heading, 255, 255, 255, 255)
    else
        DrawSprite("flightinstruments", "heading_dial", xoff + 0.70, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, heading, 255, 255, 255, 255)
        DrawSprite("flightinstruments", "heading_needle", xoff + 0.70, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, 0, 255, 255, 255, 255)
        DrawSprite("flightinstruments", "heading_cage", xoff + 0.70, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, 0, 255, 255, 255, 255)
    end
    DrawSprite("flightinstruments", "verticalspeedometer", xoff + 0.60, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, 0, 255, 255, 255, 255)
    DrawSprite("flightinstruments", gearTexture, xoff + 0.60, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, 0, 255, 255, 255, 255)
    DrawSprite("flightinstruments", "verticalspeedometer_needle", xoff + 0.60, yoff + 0.9, xscale * 0.08, yscale * 0.08 * aspect, 270+(verticalspeed/1000*90), 255, 255, 255, 255)

 -- 0123456789
 -- 1111112345

    if enable_flight_odometer then
        local feet = altitude
        local onground = IsVehicleOnAllWheels(plane)
        DrawSprite("odometer", GetOdometerInt(feet / 1000, -0.85, onground), xoff + 0.807 - 0.014 * 2, yoff + 0.975, xscale * 0.014, yscale * 0.014 * aspect, 0, 255, 255, 255, 255)
        DrawSprite("odometer", GetOdometerInt(feet / 100, -0.85, onground), xoff + 0.807 - 0.014 * 1, yoff + 0.975, xscale * 0.014, yscale * 0.014 * aspect, 0, 255, 255, 255, 255)
        DrawSprite("odometer", GetOdometerInt(feet / 10, 0.5, onground), xoff + 0.807 - 0.014 * 0, yoff + 0.975, xscale * 0.014, yscale * 0.014 * aspect, 0, 255, 255, 255, 255)
        DrawSprite("odometer", GetOdometerInt(feet / 1, 1.0, onground), xoff + 0.807 - 0.014 * -1, yoff + 0.975, xscale * 0.014, yscale * 0.014 * aspect, 0, 255, 255, 255, 255)
        if enable_flight_speedometer_odometer then
            local knots = realspeed * 0.868976242
            DrawSprite("odometer", GetOdometerInt(knots / 100, -0.85), xoff + 0.9 - 0.014 * 1, yoff + 0.975, xscale * 0.014, yscale * 0.014 * aspect, 0, 255, 255, 255, 255)
            DrawSprite("odometer", GetOdometerInt(knots / 10, -0.85), xoff + 0.9 - 0.014 * 0, yoff + 0.975, xscale * 0.014, yscale * 0.014 * aspect, 0, 255, 255, 255, 255)
            DrawSprite("odometer", GetOdometerInt(knots / 1, 1.0), xoff + 0.9 - 0.014 * -1, yoff + 0.975, xscale * 0.014, yscale * 0.014 * aspect, 0, 255, 255, 255, 255)
        end
        if enable_flight_heading_odometer then
            local actualHeading = heading
            if math.floor(360 - actualHeading) <= 10 then
                actualHeading = actualHeading + 360
            end
            DrawSprite("odometer", GetOdometerInt((360 - actualHeading) / 100, -0.85), xoff + 0.70 - 0.014 * 0.5, yoff + 0.975, xscale * 0.014, yscale * 0.014 * aspect, 0, 255, 255, 255, 255)
            DrawSprite("odometer", GetOdometerInt((360 - actualHeading) / 10, 0.20), xoff + 0.70 - 0.014 * -0.5, yoff + 0.975, xscale * 0.014, yscale * 0.014 * aspect, 0, 255, 255, 255, 255)
        end
    end
end

RegisterNetEvent("flightinstruments:toggle")
AddEventHandler("flightinstruments:toggle", function()
    enable_flight_instruments = not enable_flight_instruments
    setActualKvp("enable_flight_instruments", enable_flight_instruments)
    if enable_flight_instruments then
        TriggerEvent("gd_utils:notify", "Flight instruments: ~g~Enabled")
    else
        TriggerEvent("gd_utils:notify", "Flight instruments: ~r~Disabled")
    end
end)

RegisterNetEvent("flightinstruments:layout_toggle")
AddEventHandler("flightinstruments:layout_toggle", function()
    old_flight_instruments = not old_flight_instruments
    setActualKvp("old_flight_instruments", old_flight_instruments)
    if old_flight_instruments then
        TriggerEvent("gd_utils:notify", "Flight instruments: ~g~Old Layout")
    else
        TriggerEvent("gd_utils:notify", "Flight instruments: ~r~New Layout")
    end
end)

RegisterNetEvent("flightinstruments:odometer_toggle")
AddEventHandler("flightinstruments:odometer_toggle", function()
    enable_flight_odometer = not enable_flight_odometer
    setActualKvp("enable_flight_odometer", enable_flight_odometer)
    if enable_flight_odometer then
        TriggerEvent("gd_utils:notify", "Flight odometer: ~g~Enabled")
    else
        TriggerEvent("gd_utils:notify", "Flight odometer: ~r~Disabled")
    end
end)

RegisterNetEvent("flightinstruments:odometer_speedometer")
AddEventHandler("flightinstruments:odometer_speedometer", function()
    enable_flight_speedometer_odometer = not enable_flight_speedometer_odometer
    setActualKvp("enable_flight_speedometer_odometer", enable_flight_speedometer_odometer)
    if enable_flight_speedometer_odometer then
        TriggerEvent("gd_utils:notify", "Flight odometer: ~g~Speedometer Enabled")
    else
        TriggerEvent("gd_utils:notify", "Flight odometer: ~r~Speedometer Disabled")
    end
end)

RegisterNetEvent("flightinstruments:odometer_heading")
AddEventHandler("flightinstruments:odometer_heading", function()
    enable_flight_heading_odometer = not enable_flight_heading_odometer
    setActualKvp("enable_flight_heading_odometer", enable_flight_heading_odometer)
    if enable_flight_heading_odometer then
        TriggerEvent("gd_utils:notify", "Flight odometer: ~g~Heading Enabled")
    else
        TriggerEvent("gd_utils:notify", "Flight odometer: ~r~Heading Disabled")
    end
end)

RegisterNetEvent("flightinstruments:odometer_simple")
AddEventHandler("flightinstruments:odometer_simple", function()
    simple_altometer = not simple_altometer
    setActualKvp("simple_altometer", simple_altometer)
    if simple_altometer then
        TriggerEvent("gd_utils:notify", "Flight odometer: ~g~Simple Mode Enabled")
    else
        TriggerEvent("gd_utils:notify", "Flight odometer: ~r~Simple Mode Disabled")
    end
end)

Citizen.CreateThread(function()
    local Wait = Wait
    local IsPedInAnyPlane = IsPedInAnyPlane
    local PlayerPedId = PlayerPedId
    local IsPedInFlyingVehicle = IsPedInFlyingVehicle
    local IsPedInAnyHeli = IsPedInAnyHeli
    while true do
        Wait(0)
        if enable_flight_instruments then
            if (IsPedInAnyPlane(PlayerPedId()) or (IsPedInFlyingVehicle(PlayerPedId()) and not IsPedInAnyHeli(PlayerPedId()))) then
                DrawFlightInstruments()
            end
        end
    end
end)
