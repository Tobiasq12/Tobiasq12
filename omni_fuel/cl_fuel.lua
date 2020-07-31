LAST_VEHICLE = nil
FUEL_VALUE = 50.0
FUEL_CAPACITY = 100.0
FUEL_USAGE_MODIFIER = 1.0
FUEL_CAPACITY_MODIFIER = 1.0
FUEL_TYPE = "DIESEL"
FUEL_ACTIVE = true
FUEL_CAPACITY_REAL = 65.0

-- Percentage fill range by default when a vehicle does not have a fuel level
FUEL_DEFAULT_MIN = 60
FUEL_DEFAULT_MAX = 90

GLOBAL_FUEL_CONSUMPTION_MODIFIER = 0.6
DRIVER = true
ADVANCED_FUEL_DISPLAY = false

AD_DATA = {
    active = false,
    name = "fifteen chr name",
    text = "this message is exactly 90 characters long so I can test how much of the text can be shown",
}

RegisterNetEvent("omni:ad:setAd")
AddEventHandler("omni:ad:setAd", function(active, name, text)
    AD_DATA.active = active
    AD_DATA.name = name
    AD_DATA.text = text
end)

CLOSEST_STATION = 0

REMEMBERED_VEHICLES = {}

Minimap = {}

local IsSystemEnabled = true

-- Vehicle fuel modifiers
function CheckVehicleFuelModifiers()
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local model = GetEntityModel(veh)
    local class = GetVehicleClass(veh)
    if (class >= 0 and class <= 9) or (class == 12) or (class == 18) then
        --[[
            0: Compacts
            1: Sedans
            2: SUVs
            3: Coupes
            4: Muscle
            5: Sports Classics
            6: Sports
            7: Super
            8: Motorcycles
            9: Off-road
            12: Vans
            18: Emergency
        ]]
        FUEL_USAGE_MODIFIER = 0.7
        FUEL_CAPACITY_MODIFIER = 0.7
        FUEL_TYPE = "DIESEL"
        FUEL_ACTIVE = true
    end
    if (class == 14) then
        --[[
            14: Boats
        ]]
        FUEL_USAGE_MODIFIER = 1.8
        FUEL_CAPACITY_MODIFIER = 2.5
        FUEL_TYPE = "BOAT"
        FUEL_ACTIVE = true
    end
    if (class == 15) then
        --[[
            15: Helicopters
        ]]
        FUEL_USAGE_MODIFIER = 3.5
        FUEL_CAPACITY_MODIFIER = 2.2
        FUEL_TYPE = "HELICOPTER"
        FUEL_ACTIVE = true
    end
    if (class == 16) then
        --[[
            16: Planes
        ]]
        FUEL_USAGE_MODIFIER = 2.9
        FUEL_CAPACITY_MODIFIER = 4.4
        FUEL_TYPE = "AIRPLANE"
        FUEL_ACTIVE = true
    end
    if (class >= 10 and class <= 11) or (class >= 19 and class <= 20) or (class == 17) then
        --[[
            10: Industrial
            11: Utility
            17: Service
            19: Military
            20: Commercial
        ]]
        FUEL_USAGE_MODIFIER = 1.9
        FUEL_CAPACITY_MODIFIER = 2.8
        FUEL_TYPE = "HEAVY"
        FUEL_ACTIVE = true
    end
    if (class == 13 or class == 21) then
        --[[
            13: Cycles
            21: Trains
        ]]
        FUEL_USAGE_MODIFIER = 0.0
        FUEL_CAPACITY_MODIFIER = 1.0
        FUEL_TYPE = "RRERR"
        FUEL_ACTIVE = false
    end
    for _, checkModel in next, BLACKLISTED_VEHICLES do
        if GetHashKey(checkModel) == model then
            FUEL_USAGE_MODIFIER = 0.0
            FUEL_CAPACITY_MODIFIER = 1.0
            FUEL_TYPE = "BLACKLISTED"
            FUEL_ACTIVE = false
            break
        end
    end
    for checkModel, modelData in next, SPECIAL_VEHICLES do
        if GetHashKey(checkModel) == model then
            FUEL_USAGE_MODIFIER = modelData.usage
            FUEL_CAPACITY_MODIFIER = modelData.capacity
            FUEL_TYPE = modelData.type
            FUEL_ACTIVE = modelData.active
            break
        end
    end

    if exports['omni_common']:IsModelAnElectricVehicle(model) then
        FUEL_USAGE_MODIFIER = 0.0
        FUEL_CAPACITY_MODIFIER = 1.0
        FUEL_TYPE = "ELECTRIC"
        FUEL_ACTIVE = false
    end

    if exports['omni_common']:IsModelATrailer(model) then
        FUEL_USAGE_MODIFIER = 0.0
        FUEL_CAPACITY_MODIFIER = 1.0
        FUEL_TYPE = "TRAILER"
        FUEL_ACTIVE = false
    end

    if DecorExistOn(veh, "omni_fuel_disabled") and DecorGetBool(veh, "omni_fuel_disabled") then
        FUEL_TYPE = "ADMIN"
        FUEL_ACTIVE = false
    end
end

-- Get data for new vehicle
function FetchNewVehicleFuelData()
    LAST_VEHICLE = GetVehiclePedIsIn(GetPlayerPed(-1), true)
    CheckVehicleFuelModifiers()
    if not DecorExistOn(LAST_VEHICLE, "omni_fuel_value") then
        local key = GetDisplayNameFromVehicleModel(GetEntityModel(LAST_VEHICLE)) .. GetVehicleNumberPlateText(LAST_VEHICLE)
        if REMEMBERED_VEHICLES[key] then
            FUEL_VALUE = REMEMBERED_VEHICLES[key]
        else
            FUEL_VALUE = (FUEL_CAPACITY_MODIFIER * 100.0) * (math.random(FUEL_DEFAULT_MIN, FUEL_DEFAULT_MAX) / 100)
        end
        DecorSetFloat(LAST_VEHICLE, "omni_fuel_value", FUEL_VALUE)
    else
        FUEL_VALUE = DecorGetFloat(LAST_VEHICLE, "omni_fuel_value")
    end
    FUEL_CAPACITY_REAL = GetVehicleHandlingFloat(LAST_VEHICLE, "CHandlingData", "fPetrolTankVolume")
    FUEL_CAPACITY = FUEL_CAPACITY_MODIFIER * 100.0
end

-- Save current fuel data
function SaveFuelData()
    if LAST_VEHICLE and DoesEntityExist(LAST_VEHICLE) then
        local key = GetDisplayNameFromVehicleModel(GetEntityModel(LAST_VEHICLE)) .. GetVehicleNumberPlateText(LAST_VEHICLE)
        REMEMBERED_VEHICLES[key] = FUEL_VALUE
        DecorSetFloat(LAST_VEHICLE, "omni_fuel_value", FUEL_VALUE)
    end
end

-- Fill prompt and system
local IS_FILLING = false
local FILL_VOLUME = 0.0
local FILL_AMOUNT = 0.15
local FILLED_EXPRESS = false
function QueryFill(fuelTypes)
    if LAST_VEHICLE and DRIVER then
        if GetEntitySpeed(LAST_VEHICLE) < 0.4 or fuelTypes[1] == "BOAT" then
            local canFill = false
            for _, fuelType in next, fuelTypes do
                if FUEL_TYPE == fuelType then
                    canFill = true
                    break
                end
            end
            if not canFill then
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentString("This vehicle can not be re-fueled here.~n~Requires " .. GetFuelName(FUEL_TYPE) .. " Fuel")
                EndTextCommandDisplayHelp(0, 0, 1, 1)
            else
                if not IS_FILLING and (FUEL_VALUE < FUEL_CAPACITY - 5.0) then
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentString("Hold ~INPUT_DIVE~ to fill your vehicle~n~Hold ~INPUT_DIVE~ and ~INPUT_DETONATE~ for express fill")
                    EndTextCommandDisplayHelp(0, 0, 1, 1)
                end
                if IsControlPressed(0, 55) then
                    local filling = FILL_AMOUNT
                    if IsControlPressed(0, 47) then
                        FILLED_EXPRESS = true
                        filling = FILL_AMOUNT * 4
                    end
                    if IS_FILLING then
                        filling = math.min(FUEL_CAPACITY, FUEL_VALUE + filling) - FUEL_VALUE
                        FUEL_VALUE = FUEL_VALUE + filling
                        FILL_VOLUME = FILL_VOLUME + filling
                    else
                        IS_FILLING = true
                        FILLED_EXPRESS = false
                        FILL_VOLUME = 0.0
                    end
                else
                    if IS_FILLING then
                        IS_FILLING = false
                        TriggerServerEvent("omni_fuel:queryPayment", FILL_VOLUME, FUEL_TYPE, FILLED_EXPRESS)
                    end
                end
            end
        else
            if (FUEL_VALUE < FUEL_CAPACITY - 5.0) then
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentString("Stop the vehicle to allow fueling")
                EndTextCommandDisplayHelp(0, 0, 1, 1)
            end
        end
    else
        if #fuelTypes == 1 then
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentString("Press ~INPUT_DETONATE~ to fill a Jerry Can.~n~Fuel Type: " .. GetFuelName(fuelTypes[1]) .. " Fuel")
            EndTextCommandDisplayHelp(0, 0, 1, 1)
            if IsControlJustPressed(0, 47) then
                TriggerServerEvent("omni_fuel:fillJerryCan", fuelTypes[1], GetFuelName(fuelTypes[1]))
            end
        elseif #fuelTypes > 1 then
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentString("Fill a Jerry Can~n~~INPUT_DETONATE~: " .. GetFuelName(fuelTypes[1]) .. " Fuel~n~~INPUT_PICKUP~: " .. GetFuelName(fuelTypes[2]) .. " Fuel")
            EndTextCommandDisplayHelp(0, 0, 1, 1)
            if IsControlJustPressed(0, 47) then
                TriggerServerEvent("omni_fuel:fillJerryCan", fuelTypes[1], GetFuelName(fuelTypes[1]))
            end
            if IsControlJustPressed(0, 38) then
                TriggerServerEvent("omni_fuel:fillJerryCan", fuelTypes[2], GetFuelName(fuelTypes[2]))
            end
        end
    end
end

-- Advanced display toggle
RegisterNetEvent("omni_fuel:toggle:advancedFuelDisplay")
AddEventHandler("omni_fuel:toggle:advancedFuelDisplay", function()
    if ADVANCED_FUEL_DISPLAY then
        TriggerEvent("gd_utils:notify", "~r~Disabled ~w~advanced fuel display")
    else
        TriggerEvent("gd_utils:notify", "~g~Enabled ~w~advanced fuel display")
    end
    ADVANCED_FUEL_DISPLAY = not ADVANCED_FUEL_DISPLAY
    exports['omni_common']:setActualKvp("advancedFuelDisplay", ADVANCED_FUEL_DISPLAY)
end)

RegisterNetEvent("omni_fuel:fill")
AddEventHandler("omni_fuel:fill", function(amount, type)
    if not type or type == FUEL_TYPE then
        FUEL_VALUE = FUEL_VALUE + (amount or 1.0)
    else
        TriggerEvent("gd_utils:notify", "~r~The fuel didn't fit so you ended up spilling it instead")
    end
end)

RegisterNetEvent("omni_fuel:refund")
AddEventHandler("omni_fuel:refund", function(amount)
    FUEL_VALUE = FUEL_VALUE - (amount or 0.0)
end)

-- Fuel update loop
Citizen.CreateThread(function()
    Wait(5000)
    ADVANCED_FUEL_DISPLAY = exports['omni_common']:getActualKvp("advancedFuelDisplay")
    local Wait = Wait
    local IsPedInAnyVehicle = IsPedInAnyVehicle
    local GetPlayerPed = GetPlayerPed
    local FetchNewVehicleFuelData = FetchNewVehicleFuelData
    local GetVehiclePedIsIn = GetVehiclePedIsIn
    local GetVehicleCurrentRpm = GetVehicleCurrentRpm
    local GetVehicleEngineTemperature = GetVehicleEngineTemperature
    local GetEntitySpeed = GetEntitySpeed
    local SetVehicleFuelLevel = SetVehicleFuelLevel
    local DoesEntityExist = DoesEntityExist
    local SaveFuelData = SaveFuelData
    local omni_common = exports['omni_common']
    while IsSystemEnabled do
        Wait(100)
        Minimap = omni_common:GetMinimapAnchor()
        local ped = PlayerPedId()
        if not IS_FILLING then
            if IsPedInAnyVehicle(ped, false) then
                if not LAST_VEHICLE then
                    FetchNewVehicleFuelData()
                else
                    if GetVehiclePedIsIn(ped, false) ~= LAST_VEHICLE then
                        FetchNewVehicleFuelData()
                    end
                end
                if FUEL_ACTIVE then
                    if GetIsVehicleEngineRunning(LAST_VEHICLE) then
                        -- Consumption calculation
                        local rpm = GetVehicleCurrentRpm(LAST_VEHICLE)
                        local heat = GetVehicleEngineTemperature(LAST_VEHICLE)
                        local speed = GetEntitySpeed(LAST_VEHICLE)
                        local consumpion = ((rpm / 100.0) * (heat / 100.0) * FUEL_USAGE_MODIFIER * (1.0 + speed / 30.0)) * GLOBAL_FUEL_CONSUMPTION_MODIFIER
                        FUEL_VALUE = FUEL_VALUE - consumpion
                        FUEL_VALUE = math.min(math.max(FUEL_VALUE, 0.0), FUEL_CAPACITY)

                        local fuelLevelReal = (FUEL_CAPACITY_REAL / 100.0) * ((100.0 / FUEL_CAPACITY) * FUEL_VALUE)
                        SetVehicleFuelLevel(LAST_VEHICLE, fuelLevelReal)
                    end
                end
            else
                if LAST_VEHICLE and DoesEntityExist(LAST_VEHICLE) then
                    SaveFuelData()
                end
                LAST_VEHICLE = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    local Wait = Wait
    local GetPedInVehicleSeat = GetPedInVehicleSeat
    local PlayerPedId = PlayerPedId
    local DecorGetFloat = DecorGetFloat
    local SaveFuelData = SaveFuelData
    while IsSystemEnabled do
        Wait(1000)
        if LAST_VEHICLE then
            if GetPedInVehicleSeat(LAST_VEHICLE, -1) == PlayerPedId() then
                DRIVER = true
            else
                DRIVER = false
            end
        end
        if LAST_VEHICLE and not DRIVER then
            FUEL_VALUE = DecorGetFloat(LAST_VEHICLE, "omni_fuel_value")
        end
        if LAST_VEHICLE and DRIVER then
            SaveFuelData()
        end
    end
end)

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function DrawScreenTextCenter(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
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


-- HUD Loop
Citizen.CreateThread(function()
    Wait(5000)
    Minimap = exports['omni_common']:GetMinimapAnchor()
    local Wait = Wait
    local IsPedInAnyVehicle = IsPedInAnyVehicle
    local GetPlayerPed = GetPlayerPed
    local GetAspectRatio = GetAspectRatio
    local GetGameTimer = GetGameTimer
    local DrawScreenTextCenter = DrawScreenTextCenter
    local drawRct = drawRct
    local GetVehicleCurrentRpm = GetVehicleCurrentRpm
    local GetVehicleFuelLevel = GetVehicleFuelLevel
    while IsSystemEnabled do
        Wait(2)
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and LAST_VEHICLE then

            FUEL_VALUE = math.min(math.max(FUEL_VALUE, 0.0), FUEL_CAPACITY)

            -- Bars now use MINIMAPPER
            local safezone = 3
            local width = math.max(15, 5 * GetAspectRatio(0))
            local safezone_x = safezone * Minimap.xunit
            local safezone_y = safezone * Minimap.yunit
            local barwidth = width * (Minimap.yunit)
            local offset_x = 5 * Minimap.xunit
            local offset_y = 0 * Minimap.yunit
            -- local _, _, _, _, _, second = GetLocalTime()
            local gameTime = GetGameTimer()
            local percentage = math.floor((100.0 / FUEL_CAPACITY) * FUEL_VALUE + 0.5)
            local text = percentage .. "%"
            if ADVANCED_FUEL_DISPLAY then
                text = ("%s/%sL"):format(math.floor(FUEL_VALUE + 0.5), math.floor(FUEL_CAPACITY + 0.5)) .. " (" .. percentage .. "%)"
            end
            local warning = false
            local warningColor = {r = 255, g = 255, b = 255}
            if percentage <= 0.0 then
                warning = true
                warningColor = {r = 200, g = 200, b = 200}
                text = "OUT OF FUEL"
            elseif percentage < 5.0 then
                warning = true
                if math.floor(gameTime / 200) % 2 == 0 then
                    warningColor = {r = 255, g = 0, b = 0}
                else
                    warningColor = {r = 255, g = 255, b = 255}
                end
                text = "INSUFFICIENT FUEL! " .. text
            elseif percentage < 10.0 then
                warning = true
                if math.floor(gameTime / 500) % 2 == 0 then
                    warningColor = {r = 255, g = 0, b = 0}
                else
                    warningColor = {r = 255, g = 255, b = 255}
                end
                text = "FUEL LEVEL CRITICAL! " .. text
            elseif percentage < 20.0 then
                warning = true
                if math.floor(gameTime / 1000) % 2 == 0 then
                    warningColor = {r = 255, g = 0, b = 0}
                else
                    warningColor = {r = 255, g = 140, b = 0}
                end
                text = "FUEL LEVEL LOW! " .. text
            elseif percentage < 30.0 then
                warning = true
                warningColor = {r = 255, g = 140, b = 0}
                text = "LOW FUEL! " .. text
            end

            local barColor = {r = 255, g = 140, b = 0}
            if warning then
                barColor = warningColor
            end
            if FUEL_ACTIVE then
                DrawScreenTextCenter(Minimap.left_x, Minimap.top_y - safezone_y - barwidth, Minimap.width, -barwidth, 0.35, text, warningColor.r,warningColor.g,warningColor.b,200)
            else
                DrawScreenTextCenter(Minimap.left_x, Minimap.top_y - safezone_y - barwidth, Minimap.width, -barwidth, 0.35, "DOES NOT CONSUME FUEL", 255, 255, 255, 200)
            end

            -- if ADVANCED_FUEL_DISPLAY then
            --     drawRct(Minimap.left_x + math.min(GetVehicleCurrentRpm(LAST_VEHICLE), 0.95) * Minimap.width, Minimap.top_y - safezone_y, barwidth/4, -barwidth, 0, 0, 0, 255)
            -- end
            drawRct(Minimap.left_x, Minimap.top_y - safezone_y, Minimap.width, -barwidth, 0, 0, 0, 100)
            if FUEL_ACTIVE then
                drawRct(Minimap.left_x, Minimap.top_y - safezone_y, (Minimap.width / FUEL_CAPACITY) * FUEL_VALUE, -barwidth, barColor.r, barColor.g, barColor.b, 150)
            end
            -- if exports['omni_common']:isDebugging() then
            --     local rpm = GetVehicleCurrentRpm(LAST_VEHICLE)
            --     DrawScreenTextCenter(0.5, 0.800, 0.0, 0.0, 0.4, FUEL_TYPE .. " Fuel: " .. FUEL_VALUE, 255, 0, 0, 200)
            --     DrawScreenTextCenter(0.5, 0.825, 0.0, 0.0, 0.4, "Capacity: " .. FUEL_CAPACITY, 255, 0, 0, 200)
            --     DrawScreenTextCenter(0.5, 0.850, 0.0, 0.0, 0.4, "RPM: " .. rpm, 255, 0, 0, 200)
            --     DrawScreenTextCenter(0.5, 0.875, 0.0, 0.0, 0.4, "FUEL REAL: " .. FUEL_CAPACITY_REAL, 255, 0, 0, 200)
            --     DrawScreenTextCenter(0.5, 0.900, 0.0, 0.0, 0.4, "FUEL REAL VISUAL: " .. GetVehicleFuelLevel(LAST_VEHICLE), 255, 0, 0, 200)
            -- end
        end

    end
end)

function drawMarker(pos, big)
    -- if not IsPedInAnyVehicle(PlayerPedId(), true) then
    --     return false
    -- end
    local _s = 2.0
    if big then
        _s = _s * 4
    end
    DrawMarker(1, vector3(pos.x, pos.y, pos.z - 1.0), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(_s, _s, 1.0), 255, 255, 255, 150)
end

-- local NUM = 0
-- RegisterCommand("fuelTp", function()
--     NUM = NUM + 1
--     local pos = STATIONS[NUM].location
--     SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z, 0, 0, 0, 0)
--     TriggerEvent("chatMessage", "Fuel", {255, 255, 255}, "id: " .. NUM)
--     print("FUEL STATION: " .. NUM)
-- end)

Citizen.CreateThread(function()
    local Wait = Wait
    local GetEntityCoords = GetEntityCoords
    local PlayerPedId = PlayerPedId
    local GetFuelName = GetFuelName
    local GetNameOfZone = GetNameOfZone
    local TriggerServerEvent = TriggerServerEvent
    while IsSystemEnabled do
        Wait(2)
        if CLOSEST_STATION > 0 then
            local plyPos = GetEntityCoords(PlayerPedId(), false)
            local stationData = STATIONS[CLOSEST_STATION]
            local dist = #(plyPos - vector3(stationData.location.x, stationData.location.y, stationData.location.z))
            if dist < 40.0 then

                local big = false
                local fuelTypesText = ""
                for _, fuelType in next, stationData.types do
                    fuelTypesText = fuelTypesText .. GetFuelName(fuelType) .. " Fuel, "
                end
                if #fuelTypesText > 0 then
                    fuelTypesText = fuelTypesText:sub(1, -3)
                end

                local maxdist = 2.5
                local maxzdist = 4.0
                local textzoffset = 0.0
                if stationData.types[1] ~= "HEAVY" and stationData.types[1] ~= "DIESEL" then
                    big = true
                    maxdist = 8.5
                    maxzdist = 12.0
                    textzoffset = 2.0
                end
                if stationData.types[1] == "HELICOPTER" then
                    maxzdist = 4.0
                end
                local _textSize = 2.5
                local _textSpacing = 0.5
                if big then
                    _textSize = 5.5
                    _textSpacing = 1.25
                end

                if AD_DATA.active then
                    DrawText3D("~y~Advertisement by " .. AD_DATA.name, stationData.location.x, stationData.location.y, stationData.location.z + (textzoffset*1.5 + 1.0), _textSize * 0.8)
                    DrawText3D("~w~" .. AD_DATA.text, stationData.location.x, stationData.location.y, stationData.location.z + (textzoffset*1.5 + 1.0) - _textSpacing, _textSize * 0.6)
                end

                if stationData.name then
                    DrawText3D("~o~" .. stationData.name .. " Fuel Station", stationData.location.x, stationData.location.y, stationData.location.z + textzoffset, _textSize)
                else
                    local locationName = GetLabelText(GetNameOfZone(stationData.location.x, stationData.location.y, stationData.location.z))
                    DrawText3D("~o~" .. locationName .. " Fuel Station", stationData.location.x, stationData.location.y, stationData.location.z + textzoffset, _textSize)
                end
                for n, fuel in next, stationData.types do
                    local prices = GetFuelPrices(fuel)
                    local fuelPriceText = ("%s Fuel ~g~$%.2f/l ~w~(~g~$%.2f/l~w~)"):format(GetFuelName(fuel), prices[1], prices[2])
                    DrawText3D(fuelPriceText, stationData.location.x, stationData.location.y, stationData.location.z + textzoffset - _textSpacing * (0.5 + n / 2), _textSize * 0.5)
                end
                local ASKED = false
                for _, pump in next, stationData.pumps do
                    local pumpPos = vector3(pump.x, pump.y, 0.0)
                    local dist = #(vector3(plyPos.x, plyPos.y, 0.0) - pumpPos)
                    pumpPos = vector3(pump.x, pump.y, pump.z)

                    if dist < 25.0 then
                        drawMarker(pumpPos, big)
                    end
                    if dist < maxdist and not ASKED then
                        if math.abs(plyPos.z - pumpPos.z) < maxzdist then
                            -- You're in the marker BOI
                            QueryFill(stationData.types)
                            ASKED = true
                        end
                    end
                end
                if not ASKED and IS_FILLING then
                    IS_FILLING = false
                    TriggerServerEvent("omni_fuel:queryPayment", FILL_VOLUME, FUEL_TYPE, FILLED_EXPRESS)
                end
            end
        end
    end
end)

-- Station detection
-- Blip generation
local CLOSEST_DISTANCE = 0
Citizen.CreateThread(function()
    local Wait = Wait
    local GetEntityCoords = GetEntityCoords
    local PlayerPedId = PlayerPedId
    local AddBlipForCoord = AddBlipForCoord
    local SetBlipSprite = SetBlipSprite
    local ShowTickOnBlip = ShowTickOnBlip
    local SetBlipAsShortRange = SetBlipAsShortRange
    while IsSystemEnabled do
        Wait(5000)
        local plyPos = GetEntityCoords(PlayerPedId(), false)
        CLOSEST_STATION = 0
        CLOSEST_DISTANCE = 0
        for stationId, stationData in next, STATIONS do
            if not stationData.hidden and not stationData.blip then
                local blip = AddBlipForCoord(stationData.location.x, stationData.location.y, stationData.location.z)
                if stationData.types[1] == "BOAT" then
                    SetBlipSprite(blip, 404)
                    exports['omni_common']:SetBlipName(blip, "Fuel Station (Watercraft)")
                elseif stationData.types[1] == "AIRPLANE" then
                    SetBlipSprite(blip, 251)
                    exports['omni_common']:SetBlipName(blip, "Fuel station (Airplanes)")
                elseif stationData.types[1] == "HELICOPTER" then
                    SetBlipSprite(blip, 401)
                    exports['omni_common']:SetBlipName(blip, "Fuel station (Helicopters)")
                else
                    SetBlipSprite(blip, 361)
                    exports['omni_common']:SetBlipName(blip, "Fuel Station")
                end
                if #stationData.types > 1 then
                    -- ShowTickOnBlip(blip, true)
                end
                SetBlipAsShortRange(blip, true)
                stationData.blip = blip
                local info = {}
                table.insert(info, {3, "Price", "$8.00 / liter"})
                local b = false
                for _, fuel in next, stationData.types do
                    if b then
                        table.insert(info, {1, GetFuelName(fuel) .. " Fuel", ""})
                    else
                        table.insert(info, {4, GetFuelName(fuel) .. " Fuel", ""})
                        b = true
                    end
                end
                exports['omni_blip_info']:SetBlipInfoTitle(blip, "Fuel Station", false)
                exports['omni_blip_info']:SetBlipInfoImage(blip, "biz_images", "fuel_station")
                exports['omni_blip_info']:SetBlipInfo(blip, info)
            end

            local dist = #(plyPos - vector3(stationData.location.x, stationData.location.y, stationData.location.z))
            if dist < 150.0 then
                if CLOSEST_STATION == 0 or dist < CLOSEST_DISTANCE then
                    CLOSEST_STATION = stationId
                    CLOSEST_DISTANCE = dist
                end
            end
        end
    end
end)

RegisterNetEvent("omni:fuel:add_station")
AddEventHandler("omni:fuel:add_station", function(specialData)
    local exists = false
    for _, station in next, STATIONS do
        for _, pump in next, station.pumps do
            if pump.x == specialData.x and pump.y == specialData.y then
                exists = true
                break
            end
        end
    end
    if not exists then
        table.insert(STATIONS, {
            location = {x = specialData.x, y = specialData.y, z = specialData.z + 2.0},
            types = specialData.types or {"DIESEL"},
            name = specialData.name,
            hidden = specialData.hidden,
            pumps = {
                {x = specialData.x, y = specialData.y, z = specialData.z},
            }
        })
    end
end)

RegisterNetEvent("omni_fuel:disable")
AddEventHandler("omni_fuel:disable", function()
    IsSystemEnabled = false
end)
