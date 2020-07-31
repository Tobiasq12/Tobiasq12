isDebugViewEnabled = false
isAdvancedDebugViewEnabled = false
isUsingOrigin = true

isUsingSeatbelt = false
isUsingPermabelt = false

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

function getActualKvpFloat(name)
    local kvp = GetResourceKvpFloat(name)
    if kvp == nil then
        return 0.0
    end
    return kvp
end

function setActualKvpFloat(name, val)
    SetResourceKvpFloat(name, val)
end

Citizen.CreateThread(function()
    isUsingOrigin, r = getActualKvp("isUsingOrigin")
    if r == "nil" then isUsingOrigin = not isUsingOrigin end

    isAdvancedDebugViewEnabled = getActualKvp("isAdvancedDebugViewEnabled")
    isDebugViewEnabled = getActualKvp("isDebugViewEnabled")
    isUsingPermabelt = getActualKvp("isUsingPermabelt")
end)

USER_ID = 0
RegisterNetEvent("omni:set:user_id")
AddEventHandler("omni:set:user_id", function(id)
    USER_ID = id
end)

RegisterNetEvent("omni:client:forward")
AddEventHandler("omni:client:forward", function(evt)
    TriggerServerEvent(evt)
end)

RegisterNetEvent("omni:event:reviveandtp")
AddEventHandler("omni:event:reviveandtp", function(x, y, z, b)
    local ped = GetPlayerPed(-1)
    SetEntityHealth(ped, 1000)
    TriggerEvent("gd_utils:move", x, y, z, b)
end)

RegisterNetEvent("omni:randomizer:set_seed")
AddEventHandler("omni:randomizer:set_seed", function(seed)
    math.randomseed(seed ^ 2)
    Citizen.CreateThread(function()
        while true do
            Wait(math.random(100, 1000))
            for n = 0, math.random(3, 8) do
                math.random()
            end
        end
    end)
end)

function shuffle(tbl)
    for i = #tbl, 2, - 1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end


function IsSeatbeltOn()
    return isUsingSeatbelt
end

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds / 3600));
        mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
        secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
        return hours..":"..mins..":"..secs
    end
end

function MsToClock(milliseconds)
    local milliseconds = tonumber(milliseconds)

    if milliseconds <= 0 then
        return "00:00.000";
    else
        hours = string.format("%02.f", math.floor(milliseconds / 3600000));
        mins = string.format("%02.f", math.floor(milliseconds / 60000 - (hours * 60)));
        secs = string.format("%02.f", math.floor(milliseconds / 1000 - hours * 3600 - mins * 60));
        mills = string.format("%03.f", math.floor(milliseconds - hours * 3600000 - mins * 60000 - secs * 1000));
        if milliseconds > 3600000 then
            return hours..":"..mins..":"..secs.."."..mills
        else
            return mins..":"..secs.."."..mills
        end
    end
end

function HasEnabledPermanentSeatbelt()
    return isUsingPermabelt
end

function StartLoadingText(text)
    BeginTextCommandBusyString("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandBusyString()
end

function StopLoadingText()
    RemoveLoadingPrompt()
end

function IsRadarExtended()
    return not not isRadarExtended
end

local disableCustomGPSPathForJobs = false
Citizen.CreateThread(function()
    disableCustomGPSPathForJobs = getActualKvp("disableCustomGPSPathForJobs")
end)
RegisterNetEvent("omni:common:customgps:toggle")
AddEventHandler("omni:common:customgps:toggle", function()
    disableCustomGPSPathForJobs = not disableCustomGPSPathForJobs
    setActualKvp("disableCustomGPSPathForJobs", disableCustomGPSPathForJobs)
    if disableCustomGPSPathForJobs then
        TriggerEvent("gd_utils:notify", "Custom GPS pathing ~r~disabled")
    else
        TriggerEvent("gd_utils:notify", "Custom GPS pathing ~g~enabled")
    end
end)

function IsCustomGPSEnabled()
    return not disableCustomGPSPathForJobs
end

RegisterNetEvent("omni:toggle:permabelt")
AddEventHandler("omni:toggle:permabelt", function()
    isUsingPermabelt = not isUsingPermabelt
    setActualKvp("isUsingPermabelt", isUsingPermabelt)
    if isUsingPermabelt == true then
        TriggerEvent("gd_utils:notify", "Permabelt ~g~enabled")
    else
        TriggerEvent("gd_utils:notify", "Permabelt ~r~disabled")
    end
end)
RegisterNetEvent("omni:toggle:seatbelt")
AddEventHandler("omni:toggle:seatbelt", function()
    SetSeatbelt(not IsSeatbeltOn())
end)

function SetSeatbelt(state)
    if IsSeatbeltOn() ~= state then
        if state == true then
            TriggerEvent("gd_utils:notify", "Seatbelt buckled!")
            TriggerEvent("omni:vrp:anim:seatbelt")
        else
            TriggerEvent("gd_utils:notify", "Unbuckled seatbelt!")
        end
    end
    isUsingSeatbelt = state
end

function GetUserId()
    return USER_ID
end

function useOrigin()
    return isUsingOrigin
end

function isDebugging()
    return isDebugViewEnabled
end

function isDebuggingAdvanced()
    return (isDebugging() and isAdvancedDebugViewEnabled)
end

function GetMinimapPosition()
    return exports['omni_common']:GetMinimapAnchor()
end

function lerp(a, b, t)
	return a + (b - a) * t
end

function ReadableNumber(num, places)
    local ret
    local placeValue = ("%%.%df"):format(places or 0)
    if not num then
        return 0
    elseif num >= 1000000000000 then
        ret = placeValue:format(num / 1000000000000) .. "T" -- trillion
    elseif num >= 1000000000 then
        ret = placeValue:format(num / 1000000000) .. "B" -- billion
    elseif num >= 1000000 then
        ret = placeValue:format(num / 1000000) .. "M" -- million
    elseif num >= 1000 then
        ret = placeValue:format(num / 1000) .. "k" -- thousand
    else
        ret = num -- hundreds
    end
    return ret
end

local function round(val, decimal)
    if (decimal) then
        return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
    else
        return math.floor(val+0.5)
    end
end

local function comma_value(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end

function formatNumber(amount, decimal, prefix, neg_prefix)
    local str_amount,  formatted, famount, remain

    decimal = decimal or 2  -- default 2 decimal places
    neg_prefix = neg_prefix or "-" -- default negative sign
    pos_prefix = prefix or "" -- default negative sign

    famount = math.abs(round(amount,decimal))
    famount = math.floor(famount)

    remain = round(math.abs(amount) - famount, decimal)

    -- comma to separate the thousands
    formatted = comma_value(famount)

    -- attach the decimal portion
    if (decimal > 0) then
        remain = string.sub(tostring(remain),3)
        formatted = formatted .. "." .. remain ..
        string.rep("0", decimal - string.len(remain))
    end

    -- attach prefix string e.g '$'
    if amount >= 0 then
        formatted = (pos_prefix or "") .. formatted
    end

    -- if value is negative then format accordingly
    if (amount<0) then
        if (neg_prefix=="()") then
            formatted = "("..formatted ..")"
        else
            formatted = neg_prefix .. formatted
        end
    end

    return formatted
end

local CommonFont = 4
RegisterCommand("commonfont", function(_, args)
    local newFont = tonumber(args[1])
    if newFont then
        CommonFont = newFont
    end
end, true)

function DrawText3D(text, x, y, z, s, font, a)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    if s == nil then
        s = 1.0
    end
    if font == nil then
        font = CommonFont
    end
    if a == nil then
        a = 255
    end

    local scale = ((1 / dist) * 2) * s
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        if useOrigin() then
            SetDrawOrigin(x, y, z, 0)
        end
        SetTextScale(0.0 * scale, 1.1 * scale)
        if useOrigin() then
            SetTextFont(font)
        else
            SetTextFont(font)
        end
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, a)
        -- SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        if useOrigin() then
            DrawText(0.0, 0.0)
            ClearDrawOrigin()
        else
            DrawText(_x, _y)
        end
    end
end

function FixVehicle()
	Wait(0)
	local myPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(myPed, false) then
    	local pcar = GetVehiclePedIsIn(GetPlayerPed(-1), false)

    	SetVehicleFixed(pcar)
        SetVehicleBodyHealth(pcar, 1000.0)
        SetVehicleEngineHealth(pcar, 1000.0)
    	local _, trailer = GetVehicleTrailerVehicle(pcar)
    	if trailer then
            SetVehicleFixed(trailer)
            SetVehicleBodyHealth(trailer, 1000.0)
            SetVehicleEngineHealth(trailer, 1000.0)
            DetachVehicleFromTrailer(pcar)
            DetachVehicleFromTrailer(trailer)
            Wait(50)
            AttachVehicleToTrailer(pcar, trailer, 10.0)
    	end
    end
end

-- Citizen.CreateTread(function()
--     while true do
--         local local_ped = PlayerPedId()
--         for i=1,128 do
--             if NetworkIsPlayerActive(i) then
--                 local ped = GetPlayerPed(i)
--                 if not ped == local_ped then
--                     local pos = GetEntityCoords(ped, false)
--
--                 end
--             end
--         end
--         Wait(1)
--     end
-- end)

function DrawScreenText(x, y, scale, text, r, g, b, a)
    SetTextFont(CommonFont)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function DrawScreenTextCenter(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(CommonFont)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x + width / 2, y + height / 2)
end

function DrawRectCenter(x, y, width, height, r, g, b, a)
    DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

function SetBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

function PreventVehicleMigration(entity)
    SetNetworkIdCanMigrate(VehToNet(entity), false)
end

function PreventPedMigration(entity)
    SetNetworkIdCanMigrate(PedToNet(entity), false)
end

function PreventObjectMigration(entity)
    SetNetworkIdCanMigrate(ObjToNet(entity), false)
end

function GetPlateHash(plate)
    local hash = 0
    for i = 1, #plate do
        hash = hash + plate:byte(i)
    end
    return hash
end

function SetVehiclePlateHash(veh, plate)
    local hash = GetPlateHash(plate)
    DecorSetInt(veh, "omni_plate_hash", hash)
end

function SetVehiclePlate(veh, plate)
    DecorSetBool(veh, "omni_custom_plate", true)
    SetVehiclePlateHash(veh, plate)
    SetVehicleNumberPlateText(veh, plate)
end

RegisterNetEvent("omni_common:plate:set:vehicle")
AddEventHandler("omni_common:plate:set:vehicle", function(plate)
    -- Only allow if sent by server
    if source ~= nil then
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            SetVehiclePlate(veh, plate)
        end
    end
end)

function ShowHelpText(label, value)
    BeginTextCommandDisplayHelp(label)
    EndTextCommandDisplayHelp(0, 0, true, value)
end

-- Entity Iterator by IllidanS4: https://gist.github.com/IllidanS4/9865ed17f60576425369fc1da70259b2

--[[The MIT License (MIT)
Copyright (c) 2017 IllidanS4
Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
]]

local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end

    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)

    local next = true
    repeat
      coroutine.yield(id)
      next, id = moveFunc(iter)
    until not next

    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
  return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
  return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end


--[[Usage:
for ped in EnumeratePeds() do
  <do something with 'ped'>
end
]]


-- Citizen.CreateThread(function()
--     local v = {x = 3104.5927734375, y = -4776.71484375, z = -183.74844360352}
--     while true do
--         Wait(0)
--         if  Vdist(v.x, v.y, v.z, GetEntityCoords(GetPlayerPed(-1))) <= 30.0 then
--             DrawText3D("Tier 2 Cargo Trucking CFX", v.x, v.y, v.z)
--         end
--     end
-- end)
-- x = 3104.5927734375, y = -4776.71484375, z = -183.74844360352

-- Citizen.CreateThread(function()
--     --
--     -- while not LoadStream("Woosh_01", "FBI_HEIST_ELEVATOR_SHAFT_DEBRIS_SOUNDS") do
--     --     Wait(109)
--     -- end
--     -- print("Loaded")
--     -- PlayPoliceReport("SCRIPTED_SCANNER_REPORT_NIGEL_1A_01", 0.0)
--     --
--     DoScreenFadeIn(1)
--     local audio = {
--         {"DLC_HALLOWEEN\\HALLOWEEN_SPOOKY_WIND_01", "DLC_HALLOWEEN_AMBIENT_WIND_01"},
--         -- {"DLC_HALLOWEEN\\AMBIENT_DARK_LOOP_02", "DLC_HALLOWEEN\\AMBIENT_DARK_LOOP_02\\AMBIENT_DARK_LOOP_02"},
--         -- {"DLC_HALLOWEEN\\AMBIENT_DARK_LOOP_02", "DLC_HALLOWEEN\\AMBIENT_DARK_LOOP_02"},
--         -- {"DLC_GTAO\\FM", "FM_1FYAB_01"},
--         -- {"POLICE_SCANNER\\random_chat", "RANDOMCHAT2"},
--     }
--     for _, data in next, audio do
--         print("Loading Audio Bank " .. data[1])
--         while not RequestScriptAudioBank(data[1], 0, -1) do
--             Wait(100)
--         end
--         print("Succesfully loaded")
--     end
--     for _, data in next, audio do
--         local soundId = GetSoundId()
--         print("Playing " .. data[2] .. " from " .. data[1])
--         PlaySoundFromEntity(soundId, data[2], GetPlayerPed(-1), "DLC_HALLOWEEN_AMBIENT_WIND_01", 0, 0, 0)
--
--         Wait(500)
--         print("HasSoundFinished?: " .. tostring(HasSoundFinished(soundId)))
--         Wait(500)
--         StopSound(soundId)
--         print("Stopped Sound")
--     end
-- end)
--
-- RegisterCommand("lexington", function()
--     x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
--
--     print("Requesting model")
--     RequestModel("lexington")
--     print("model in cd image?: " .. tostring(IsModelInCdimage("lexington")))
--     print("Staring loop")
--     while not HasModelLoaded("lexington") do
--        Wait(1)
--     end
--     print("Loop end")
--     local object = CreateObject("lexington", x, y, z, false, true, false)
--     print("Spawned")
-- end)

-- Citizen.CreateThread(function()
--     local e = true
--     while true do
--         Wait(250)
--         local v = GetVehiclePedIsUsing(GetPlayerPed(-1))
--         if e then
--             SetVehicleModColor_1(v, 0, 16, 0)
--             SetVehicleModColor_2(v, 0, 16)
--             SetVehicleInteriorColour(v, 16)
--             SetVehicleModKit(v, 1)
--         else
--             SetVehicleModColor_1(v, 0, 53, 0)
--             SetVehicleModColor_2(v, 0, 53)
--             SetVehicleInteriorColour(v, 53)
--             SetVehicleModKit(v, 1)
--         end
--         e = not e
--     end
-- end)

Citizen.CreateThread(function()
    local stations = {
        {
            text = {x = 641.67059326172, y = 3500.1960449219, z = 35.470592498779},
            pos = {x = 646.00756835938, y = 3500.7197265625, z = 34.468830108643},
        },
    }

    function WeightNumber(num, places)
        local ret
        local placeValue = ("%%.%df"):format(places or 0)
        if not num then
            return 0
        elseif num >= 1000 then
            ret = placeValue:format(num / 1000) .. " t" -- thousand
        else
            ret = num .. " kg"
        end
        return ret
    end

    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for _, station in next, stations do
            local dist = #(pos - vector3(station.pos.x, station.pos.y, station.pos.z))
            if dist < 20.0 then

            end
            if dist < 2.0 then
                local weight = 0
                local veh = GetVehiclePedIsIn(ped, false)
                if veh then
                    weight = weight + GetVehicleHandlingFloat(veh, 'CHandlingData', 'fMass')
                    local hasTrailer, trailer = GetVehicleTrailerVehicle(veh)
                    if hasTrailer then
                        weight = weight + GetVehicleHandlingFloat(trailer, 'CHandlingData', 'fMass')
                    end
                end
                DrawText3D(("%s"):format(WeightNumber(weight, 2)), station.text.x, station.text.y, station.text.z, 4.0)
                DrawText3D(("%s"):format("~y~Total weight"), station.text.x, station.text.y, station.text.z + 0.6, 3.0)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        -- if (IsControlJustPressed(0, 289) or IsDisabledControlJustPressed(0, 289)) and GetLastInputMethod(0) then
        --     TriggerServerEvent("omni:noclip:server:check")
        -- end
        if (IsControlJustPressed(0, 170) or IsDisabledControlJustPressed(0, 170)) and GetLastInputMethod(0) then
            TriggerServerEvent("omni:waypoint:server:check")
        end
    end
end)

Citizen.CreateThread(function()
    local n = false
    local ldbrd = false
    local prev_prius = nil
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, true)
        if veh then
            if not IsVehicleModel(veh, "dilettante2") then
                if prev_prius then
                    if DoesEntityExist(prev_prius) then
                        veh = prev_prius
                    else
                        prev_prius = nil
                    end
                end
            end
        end
        if veh and IsVehicleModel(veh, "dilettante2") then
            prev_prius = veh
            local lights = {
                AMBER = {r = 222, g = 126, b = 0, dash = 42, int = 42},
                RED = {r = 140, g = 4, b = 0, dash = 42, int = 70},
                BLUE = {r = 0, g = 85, b = 196, dash = 42, int = 44},
                WHITE = {r = 240, g = 240, b = 240, dash = 111, int = 111},
                GREEN = {r = 105, g = 189, b = 69, dash = 139, int = 139},
                BLACK = {r = 8, g = 8, b = 8, dash = 0, int = 0},
                HOTPINK = {r = 176, g = 18, b = 89, dash = 135, int = 135},
                LIMEGREEN = {r = 86, g = 143, b = 0, dash = 92, int = 92},
                BRONZE = {r = 74, g = 52, b = 27, dash = 90, int = 90},
                BROWN = {r = 59, g = 23, b = 0, dash = 104, int = 104},
                LIGHTBLUE = {r = 0, g = 174, b = 239, dash = 140, int = 140},
                PURPLE = {r = 50, g = 6, b = 66, dash = 145, int = 145},
                ON = {r = 8, g = 8, b = 8, dash = 0, int = 0},
            }
            local LIGHTS = lights
            local ON = LIGHTS.AMBER
            local OFF = LIGHTS.BLACK

            local CAR_VARIATIONS = {
                [0] = LIGHTS.AMBER,
                [1] = LIGHTS.RED,
                [2] = LIGHTS.BLUE,
                [3] = LIGHTS.WHITE,
                [4] = LIGHTS.GREEN,
                [5] = LIGHTS.HOTPINK,
                [6] = LIGHTS.LIMEGREEN,
                [7] = LIGHTS.BRONZE,
                [8] = LIGHTS.BROWN,
                [9] = LIGHTS.LIGHTBLUE,
                [10] = LIGHTS.PURPLE,
            }

            local carCol, _ = GetVehicleColours(veh)
            if CAR_VARIATIONS[math.floor(carCol/4)] then
                LIGHTS.ON = CAR_VARIATIONS[math.floor(carCol/4)]
                ON = LIGHTS.ON
            else
                LIGHTS.ON = LIGHTS.AMBER
            end
            -- ON = CAR_VARIATIONS[math.random(#CAR_VARIATIONS)]
            -- if math.floor(GetGameTimer() / 250) % 3 == 0 then
            --     LIGHTS.ON = LIGHTS.RED
            -- else
            --     LIGHTS.ON = LIGHTS.BLUE
            -- end

            if IsVehicleSirenOn(veh) then
                if not IsHornActive(veh) then
                    local segs = 16
                    local segl = 1750
                    local slow = 250
                    local fast = 150
                    local strobe = 100
                    if math.floor(GetGameTimer() / segl) % segs <= 1 then
                        if math.floor(GetGameTimer() / slow) % 2 == 0 then
                            if n then
                                n = not n
                                SetVehicleCustomSecondaryColour(veh, ON.r, ON.g, ON.b)
                                SetVehicleInteriorColour(veh, ON.int)
                            end
                        else
                            if not n then
                                n = not n
                                SetVehicleCustomSecondaryColour(veh, OFF.r, OFF.g, OFF.b)
                                SetVehicleInteriorColour(veh, OFF.int)
                            end
                        end
                    elseif math.floor(GetGameTimer() / segl) % segs == 4 then
                        if math.floor(GetGameTimer() / strobe) % 2 == 0 then
                            if n then
                                ON = LIGHTS.ON
                                n = not n
                                -- SetVehicleColours(vehicle, carCol, carCol)
                                SetVehicleCustomSecondaryColour(veh, ON.r, ON.g, ON.b)
                                SetVehicleInteriorColour(veh, OFF.int) -- Right bar
                            end
                        else
                            if not n then
                                ON = LIGHTS.ON
                                n = not n
                                SetVehicleCustomSecondaryColour(veh, OFF.r, OFF.g, OFF.b)
                                SetVehicleInteriorColour(veh, OFF.int)
                            end
                        end
                    elseif math.floor(GetGameTimer() / segl) % segs == 6 then
                        if math.floor(GetGameTimer() / strobe) % 2 == 0 then
                            if n then
                                ON = LIGHTS.ON
                                n = not n
                                -- SetVehicleColours(vehicle, carCol, carCol)
                                SetVehicleCustomSecondaryColour(veh, OFF.r, OFF.g, OFF.b)
                                SetVehicleInteriorColour(veh, ON.int) -- Right bar
                            end
                        else
                            if not n then
                                ON = LIGHTS.ON
                                n = not n
                                SetVehicleCustomSecondaryColour(veh, OFF.r, OFF.g, OFF.b)
                                SetVehicleInteriorColour(veh, OFF.int)
                            end
                        end
                    else
                        if math.floor(GetGameTimer() / slow) % 2 == 0 then
                            if n then
                                ON = LIGHTS.ON
                                n = not n
                                -- SetVehicleColours(vehicle, carCol, carCol)
                                SetVehicleCustomSecondaryColour(veh, ON.r, ON.g, ON.b)
                                SetVehicleInteriorColour(veh, OFF.int) -- Right bar
                            end
                        else
                            if not n then
                                ON = LIGHTS.ON
                                n = not n
                                SetVehicleCustomSecondaryColour(veh, OFF.r, OFF.g, OFF.b)
                                SetVehicleInteriorColour(veh, ON.int)
                            end
                        end
                    end
                else
                    ON = LIGHTS.ON
                        if math.floor(GetGameTimer() / 250) % 2 == 0 then
                            if n then
                                n = not n
                                SetVehicleCustomSecondaryColour(veh, ON.r, ON.g, ON.b)
                                SetVehicleInteriorColour(veh, ON.int)
                            end
                        else
                            if not n then
                                n = not n
                                SetVehicleCustomSecondaryColour(veh, OFF.r, OFF.g, OFF.b)
                                SetVehicleInteriorColour(veh, OFF.int)
                            end
                        end
                end
            else
                if not IsHornActive(veh) then
                    SetVehicleCustomSecondaryColour(veh, OFF.r, OFF.g, OFF.b)
                    SetVehicleInteriorColour(veh, OFF.int)
                else
                    ON = LIGHTS.ON
                    local _c = math.floor(GetGameTimer() / 100) % 4
                    if _c == 0 then
                        if n then
                            n = not n
                            SetVehicleCustomSecondaryColour(veh, ON.r, ON.g, ON.b)
                            SetVehicleInteriorColour(veh, OFF.int)
                        end
                    elseif _c == 2 then
                        if n then
                            n = not n
                            SetVehicleCustomSecondaryColour(veh, OFF.r, OFF.g, OFF.b)
                            SetVehicleInteriorColour(veh, ON.int)
                        end
                    else
                        if not n then
                            n = not n
                            SetVehicleCustomSecondaryColour(veh, OFF.r, OFF.g, OFF.b)
                            SetVehicleInteriorColour(veh, OFF.int)
                        end
                    end
                end
            end

            local blinks = GetVehicleIndicatorLights(veh)
            if blinks > 0 then
                if math.floor(GetGameTimer() / 150) % 10 < 6 and not ldbrd then
                    ldbrd = not ldbrd
                    SetVehicleDashboardColour(veh, ON.dash) -- Front piece
                    SetVehicleMod(veh, 0, blinks)
                end
                if math.floor(GetGameTimer() / 150) % 10 >= 6 and ldbrd then
                    ldbrd = not ldbrd
                    SetVehicleDashboardColour(veh, OFF.dash)
                    SetVehicleMod(veh, 0, 0)
                end
            else
                ldbrd = false
                SetVehicleMod(veh, 0, 0)
            end
        end
    end
end)

-- Teleport to map blip
function teleportToWaypoint()
	local targetPed = GetPlayerPed(-1)
	if(IsPedInAnyVehicle(targetPed))then
		targetPed = GetVehiclePedIsUsing(targetPed)
	end

	if(not IsWaypointActive())then
		return
	end

	local waypointBlip = GetFirstBlipInfoId(8) -- 8 = Waypoint ID
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector()))



	-- Ensure Entity teleports above the ground
	local ground
	local groundFound = false
	local groundCheckHeights = {0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}


	for i,height in ipairs(groundCheckHeights) do
		RequestCollisionAtCoord(x, y, height)
		Wait(0)
		SetEntityCoordsNoOffset(targetPed, x,y,height, 0, 0, 1)
		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if(ground) then
			z = z + 3
			groundFound = true
			break;
		end
	end

	if(not groundFound)then
		z = 1000
		GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0) -- Parachute
	end

	SetEntityCoordsNoOffset(targetPed, x,y,z, 0, 0, 1)

	TriggerEvent("gd_utils:notify", "Teleported to waypoint.")
end

RegisterNetEvent("omni:mello:marker")
AddEventHandler("omni:mello:marker", function()
	teleportToWaypoint()
end)

-- RegisterCommand("blippers", function()
--     local data = {}
--     for i = 1, 600, 1 do
--         local blip = GetFirstBlipInfoId(i)
--
--         if DoesBlipExist(blip) then -- If the first blip exists, we're going to need an entry
--             blipTable[i] = {}
--         end
--         while (DoesBlipExist(blip)) do
--
--             local x,y,z = table.unpack(GetBlipCoords(blip))
--
--             -- Damn! There's no way to get the fucking display text for the blip :(
--             table.insert(blipTable[spriteId], {
--                 x = tonumber(string.format("%.2f", x)), -- Round them to 2dp
--                 y = tonumber(string.format("%.2f", y)),
--                 z = tonumber(string.format("%.2f", z))
--             })
--
--             blip = GetNextBlipInfoId(i)
--         end
--     end
--     TriggerServerEvent("")
-- end, false)

-- ped_models = {
--     "S_M_Y_Prisoner_01",
-- }
-- function getRandomPedModel()
--     local mod = ped_models[math.random(#ped_models)]
--     return mod
-- end
--
-- function createPedsThatEnterVehicle(number)
--     local peds = {}
--     local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
--     local pos = GetEntityCoords(veh)
--     local _model = getRandomPedModel()
--     local model = GetHashKey(_model)
--     RequestModel(model)
--     while not HasModelLoaded(model) do Citizen.Wait(1) end
--
--     local _peds = 0
--
--     print("Making " .. number .. " peds enter the vehicle")
--
--     for _i = 1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
--         if _peds >= number then break end
--         if not DoesEntityExist(GetPedInVehicleSeat(veh, _i)) then
--             local ped = CreatePed(4, model, pos.x + GetEntityForwardX(veh) * (6 + _peds), pos.y + GetEntityForwardY(veh) * (6 + _peds), pos.z, 0, true, 0)
--             TaskWarpPedIntoVehicle(ped, veh, _i)
--             SetPedRelationshipGroupHash(ped, `SCRIPTED_FUCKERS`)
--             table.insert(peds, ped)
--             _peds = _peds + 1
--         end
--     end
--     return peds
-- end
--
-- RegisterCommand("fill_veh", function(source)
--     local veh = GetVehiclePedIsIn(PlayerPedId(), true)
--     fillVehicleWithPeds(veh, "faggots")
-- end)
--
-- function fillVehicleWithPeds(veh, pedsModel)
--     -- local pedModel = reqModel(pedsModel)
--     -- print("Filling vehicle with peds " .. pedsModel)
--     local peds = createPedsThatEnterVehicle(GetVehicleMaxNumberOfPassengers(veh))
--     -- for i=1, GetVehicleMaxNumberOfPassengers(veh) do
--     --     -- local ped = CreatePedInsideVehicle(veh, 26, pedModel, i, true, false)
--     --     local pos = GetEntityCoords(veh, false)
--     --     local ped = CreatePed(26, pedModel, pos, 0.0, true, 0)
--     --     TaskWarpPedIntoVehicle(ped, veh, i)
--     --     -- SetPedKeepTask(ped, true)
--     --     -- SetBlockingOfNonTemporaryEvents(ped, true)
--     --     --
--     --     -- SetPedAllowVehiclesOverride(ped, false)
--     --     -- SetPedCanPlayAmbientAnims(ped, false)
--     --     -- SetPedCanPlayAmbientBaseAnims(ped, false)
--     --     table.insert(peds, ped)
--     -- end
--     return peds
-- end

RegisterNetEvent("onesync:verifyPlayerData")
AddEventHandler("onesync:verifyPlayerData", function(data)
    for _, playerData in next, data do
        local serverId = playerData.player
        local player = GetPlayerFromServerId(serverId)
        local name = GetPlayerName(player)
        if name ~= playerData.name then
            Citizen.Trace("== INVALID PLAYER DATA FOR " .. tostring(serverId) .. " == ")
            Citizen.Trace("SERVER SRC: " .. tostring(serverId) .. " LOCAL SRC: " .. tostring(player))
            Citizen.Trace("SERVER NAME: " .. tostring(playerData.name) .. " LOCAL NAME: " .. tostring(name))
        else
            Citizen.Trace("== VALID PLAYER DATA FOR " .. tostring(serverId) .. " == ")
        end
    end
end)

local WEAPONS = {
    [`WEAPON_UNARMED`] = "WEAPON_UNARMED",
    [`WEAPON_ANIMAL`] = "WEAPON_ANIMAL",
    [`WEAPON_COUGAR`] = "WEAPON_COUGAR",
    [`WEAPON_KNIFE`] = "WEAPON_KNIFE",
    [`WEAPON_NIGHTSTICK`] = "WEAPON_NIGHTSTICK",
    [`WEAPON_HAMMER`] = "WEAPON_HAMMER",
    [`WEAPON_BAT`] = "WEAPON_BAT",
    [`WEAPON_GOLFCLUB`] = "WEAPON_GOLFCLUB",
    [`WEAPON_CROWBAR`] = "WEAPON_CROWBAR",
    [`WEAPON_PISTOL`] = "WEAPON_PISTOL",
    [`WEAPON_COMBATPISTOL`] = "WEAPON_COMBATPISTOL",
    [`WEAPON_APPISTOL`] = "WEAPON_APPISTOL",
    [`WEAPON_PISTOL50`] = "WEAPON_PISTOL50",
    [`WEAPON_MICROSMG`] = "WEAPON_MICROSMG",
    [`WEAPON_SMG`] = "WEAPON_SMG",
    [`WEAPON_ASSAULTSMG`] = "WEAPON_ASSAULTSMG",
    [`WEAPON_ASSAULTRIFLE`] = "WEAPON_ASSAULTRIFLE",
    [`WEAPON_CARBINERIFLE`] = "WEAPON_CARBINERIFLE",
    [`WEAPON_ADVANCEDRIFLE`] = "WEAPON_ADVANCEDRIFLE",
    [`WEAPON_MG`] = "WEAPON_MG",
    [`WEAPON_COMBATMG`] = "WEAPON_COMBATMG",
    [`WEAPON_PUMPSHOTGUN`] = "WEAPON_PUMPSHOTGUN",
    [`WEAPON_SAWNOFFSHOTGUN`] = "WEAPON_SAWNOFFSHOTGUN",
    [`WEAPON_ASSAULTSHOTGUN`] = "WEAPON_ASSAULTSHOTGUN",
    [`WEAPON_BULLPUPSHOTGUN`] = "WEAPON_BULLPUPSHOTGUN",
    [`WEAPON_STUNGUN`] = "WEAPON_STUNGUN",
    [`WEAPON_SNIPERRIFLE`] = "WEAPON_SNIPERRIFLE",
    [`WEAPON_HEAVYSNIPER`] = "WEAPON_HEAVYSNIPER",
    [`WEAPON_REMOTESNIPER`] = "WEAPON_REMOTESNIPER",
    [`WEAPON_GRENADELAUNCHER`] = "WEAPON_GRENADELAUNCHER",
    [`WEAPON_GRENADELAUNCHER_SMOKE`] = "WEAPON_GRENADELAUNCHER_SMOKE",
    [`WEAPON_RPG`] = "WEAPON_RPG",
    [`WEAPON_PASSENGER_ROCKET`] = "WEAPON_PASSENGER_ROCKET",
    [`WEAPON_AIRSTRIKE_ROCKET`] = "WEAPON_AIRSTRIKE_ROCKET",
    [`WEAPON_STINGER`] = "WEAPON_STINGER",
    [`WEAPON_MINIGUN`] = "WEAPON_MINIGUN",
    [`WEAPON_GRENADE`] = "WEAPON_GRENADE",
    [`WEAPON_STICKYBOMB`] = "WEAPON_STICKYBOMB",
    [`WEAPON_SMOKEGRENADE`] = "WEAPON_SMOKEGRENADE",
    [`WEAPON_BZGAS`] = "WEAPON_BZGAS",
    [`WEAPON_MOLOTOV`] = "WEAPON_MOLOTOV",
    [`WEAPON_FIREEXTINGUISHER`] = "WEAPON_FIREEXTINGUISHER",
    [`WEAPON_PETROLCAN`] = "WEAPON_PETROLCAN",
    [`WEAPON_DIGISCANNER`] = "WEAPON_DIGISCANNER",
    [`WEAPON_BRIEFCASE`] = "WEAPON_BRIEFCASE",
    [`WEAPON_BRIEFCASE_02`] = "WEAPON_BRIEFCASE_02",
    [`WEAPON_BALL`] = "WEAPON_BALL",
    [`WEAPON_FLARE`] = "WEAPON_FLARE",
    [`WEAPON_VEHICLE_ROCKET`] = "WEAPON_VEHICLE_ROCKET",
    [`WEAPON_BARBED_WIRE`] = "WEAPON_BARBED_WIRE",
    [`WEAPON_DROWNING`] = "WEAPON_DROWNING",
    [`WEAPON_DROWNING_IN_VEHICLE`] = "WEAPON_DROWNING_IN_VEHICLE",
    [`WEAPON_BLEEDING`] = "WEAPON_BLEEDING",
    [`WEAPON_ELECTRIC_FENCE`] = "WEAPON_ELECTRIC_FENCE",
    [`WEAPON_EXPLOSION`] = "WEAPON_EXPLOSION",
    [`WEAPON_FALL`] = "WEAPON_FALL",
    [`WEAPON_EXHAUSTION`] = "WEAPON_EXHAUSTION",
    [`WEAPON_HIT_BY_WATER_CANNON`] = "WEAPON_HIT_BY_WATER_CANNON",
    [`WEAPON_RAMMED_BY_CAR`] = "WEAPON_RAMMED_BY_CAR",
    [`WEAPON_RUN_OVER_BY_CAR`] = "WEAPON_RUN_OVER_BY_CAR",
    [`WEAPON_HELI_CRASH`] = "WEAPON_HELI_CRASH",
    [`WEAPON_FIRE`] = "WEAPON_FIRE",
    [`WEAPON_SNSPISTOL`] = "WEAPON_SNSPISTOL",
    [`WEAPON_BOTTLE`] = "WEAPON_BOTTLE",
    [`WEAPON_GUSENBERG`] = "WEAPON_GUSENBERG",
    [`WEAPON_SPECIALCARBINE`] = "WEAPON_SPECIALCARBINE",
    [`WEAPON_HEAVYPISTOL`] = "WEAPON_HEAVYPISTOL",
    [`WEAPON_BULLPUPRIFLE`] = "WEAPON_BULLPUPRIFLE",
    [`WEAPON_DAGGER`] = "WEAPON_DAGGER",
    [`WEAPON_VINTAGEPISTOL`] = "WEAPON_VINTAGEPISTOL",
    [`WEAPON_FIREWORK`] = "WEAPON_FIREWORK",
    [`WEAPON_MUSKET`] = "WEAPON_MUSKET",
    [`WEAPON_HEAVYSHOTGUN`] = "WEAPON_HEAVYSHOTGUN",
    [`WEAPON_MARKSMANRIFLE`] = "WEAPON_MARKSMANRIFLE",
    [`WEAPON_HOMINGLAUNCHER`] = "WEAPON_HOMINGLAUNCHER",
    [`WEAPON_PROXMINE`] = "WEAPON_PROXMINE",
    [`WEAPON_SNOWBALL`] = "WEAPON_SNOWBALL",
    [`WEAPON_FLAREGUN`] = "WEAPON_FLAREGUN",
    [`WEAPON_GARBAGEBAG`] = "WEAPON_GARBAGEBAG",
    [`WEAPON_HANDCUFFS`] = "WEAPON_HANDCUFFS",
    [`WEAPON_COMBATPDW`] = "WEAPON_COMBATPDW",
    [`WEAPON_MARKSMANPISTOL`] = "WEAPON_MARKSMANPISTOL",
    [`WEAPON_KNUCKLE`] = "WEAPON_KNUCKLE",
    [`WEAPON_HATCHET`] = "WEAPON_HATCHET",
    [`WEAPON_RAILGUN`] = "WEAPON_RAILGUN",
    [`WEAPON_MACHETE`] = "WEAPON_MACHETE",
    [`WEAPON_MACHINEPISTOL`] = "WEAPON_MACHINEPISTOL",
    [`WEAPON_AIR_DEFENCE_GUN`] = "WEAPON_AIR_DEFENCE_GUN",
    [`WEAPON_SWITCHBLADE`] = "WEAPON_SWITCHBLADE",
    [`WEAPON_REVOLVER`] = "WEAPON_REVOLVER",
    [`WEAPON_DBSHOTGUN`] = "WEAPON_DBSHOTGUN",
    [`WEAPON_COMPACTRIFLE`] = "WEAPON_COMPACTRIFLE",
    [`WEAPON_AUTOSHOTGUN`] = "WEAPON_AUTOSHOTGUN",
    [`WEAPON_BATTLEAXE`] = "WEAPON_BATTLEAXE",
    [`WEAPON_COMPACTLAUNCHER`] = "WEAPON_COMPACTLAUNCHER",
    [`WEAPON_MINISMG`] = "WEAPON_MINISMG",
    [`WEAPON_PIPEBOMB`] = "WEAPON_PIPEBOMB",
    [`WEAPON_POOLCUE`] = "WEAPON_POOLCUE",
    [`WEAPON_WRENCH`] = "WEAPON_WRENCH",
    [`GADGET_NIGHTVISION`] = "GADGET_NIGHTVISION",
    [`GADGET_PARACHUTE`] = "GADGET_PARACHUTE",
    [`VEHICLE_WEAPON_ROTORS`] = "VEHICLE_WEAPON_ROTORS",
    [`VEHICLE_WEAPON_TANK`] = "VEHICLE_WEAPON_TANK",
    [`VEHICLE_WEAPON_SPACE_ROCKET`] = "VEHICLE_WEAPON_SPACE_ROCKET",
    [`VEHICLE_WEAPON_PLANE_ROCKET`] = "VEHICLE_WEAPON_PLANE_ROCKET",
    [`VEHICLE_WEAPON_PLAYER_LAZER`] = "VEHICLE_WEAPON_PLAYER_LAZER",
    [`VEHICLE_WEAPON_PLAYER_LASER`] = "VEHICLE_WEAPON_PLAYER_LASER",
    [`VEHICLE_WEAPON_PLAYER_BULLET`] = "VEHICLE_WEAPON_PLAYER_BULLET",
    [`VEHICLE_WEAPON_PLAYER_BUZZARD`] = "VEHICLE_WEAPON_PLAYER_BUZZARD",
    [`VEHICLE_WEAPON_PLAYER_HUNTER`] = "VEHICLE_WEAPON_PLAYER_HUNTER",
    [`VEHICLE_WEAPON_ENEMY_LASER`] = "VEHICLE_WEAPON_ENEMY_LASER",
    [`VEHICLE_WEAPON_SEARCHLIGHT`] = "VEHICLE_WEAPON_SEARCHLIGHT",
    [`VEHICLE_WEAPON_RADAR`] = "VEHICLE_WEAPON_RADAR",
    [`VEHICLE_WEAPON_WATER_CANNON`] = "VEHICLE_WEAPON_WATER_CANNON",
    [`VEHICLE_WEAPON_TURRET_INSURGENT`] = "VEHICLE_WEAPON_TURRET_INSURGENT",
    [`VEHICLE_WEAPON_TURRET_TECHNICAL`] = "VEHICLE_WEAPON_TURRET_TECHNICAL",
    [`VEHICLE_WEAPON_NOSE_TURRET_VALKYRIE`] = "VEHICLE_WEAPON_NOSE_TURRET_VALKYRIE",
    [`VEHICLE_WEAPON_PLAYER_SAVAGE`] = "VEHICLE_WEAPON_PLAYER_SAVAGE",
    [`VEHICLE_WEAPON_TURRET_LIMO`] = "VEHICLE_WEAPON_TURRET_LIMO",
    [`VEHICLE_WEAPON_CANNON_BLAZER`] = "VEHICLE_WEAPON_CANNON_BLAZER",
    [`VEHICLE_WEAPON_TURRET_BOXVILLE`] = "VEHICLE_WEAPON_TURRET_BOXVILLE",
    [`VEHICLE_WEAPON_RUINER_BULLET`] = "VEHICLE_WEAPON_RUINER_BULLET",
}

function ResolveWeapon(hash)
    return WEAPONS[hash] or "WEAPON_INVALID"
end
