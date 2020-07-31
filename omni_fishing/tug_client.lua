-- Injection Protection Snippet --
--[[#INCLUDE W1ND3RGSNIP]]--
local AC_KEY = "\119\105\110\51\114\103\47\114\114\101\114\114"
RegisterNetEvent("\119\49\110\100\114\52\103\110\58\107\101\121\58".._ENV["\71\101\116\67\117\114\114\101\110\116\82\101\115\111\117\114\99\101\78\97\109\101"]())
AddEventHandler("\119\49\110\100\114\52\103\110\58\107\101\121\58".._ENV["\71\101\116\67\117\114\114\101\110\116\82\101\115\111\117\114\99\101\78\97\109\101"](), function(k)
	AC_KEY = k
end)
-- REMOVE BELOW IF MULTI-PURPOSE SCRIP
local _tse = TriggerServerEvent
local TriggerServerEvent = function(ev, ...)
	_tse(ev, AC_KEY, ...)
end
--[[#END W1ND3RGSNIP]]--
-- End of Injection Protection --

local alamo_tug_fish = {
    "fish_salmon",
	"fish_trout",
}

local ocean_tug_fish = {
    "fish_cod",
	"fish_mackerel",
	"fish_saithe",
}

local ocean_tug_cage = {
	"fish_cod",
	"fish_saithe",
    "fish_salmon",
    "fish_trout",
}


local tugging_locations = {
    {id = "AS_01", name = "Alamo Sea", x = 2088.3854980469, y = 4279.0024414063, z = 30.0, capacity = 100, current = 0, size = 250.0, bonuses = {}, itemset = alamo_tug_fish},
    {id = "PB_01", name = "Paleto Bay", x = -4009.3427734375, y = 4993.6528320313, z = 0.0, capacity = 100, current = 0, size = 1000.0, bonuses = {}, itemset = ocean_tug_fish},
    {id = "PB_02", name = "Northern PB", x = 1364.8439941406, y = 7992.4951171875, z = 0.0, capacity = 100, current = 0, size = 1000.0, bonuses = {}, itemset = ocean_tug_cage},
    {id = "GM_01", name = "Gordo Mountain", x = 4665.1606445313, y = 5496.259765625, z = 0.0, capacity = 100, current = 0, size = 1000.0, bonuses = {}, itemset = ocean_tug_cage},
    {id = "PO_01", name = "Pacific Ocean Airport", x = 4442.6157226563, y = 1449.7601318359, z = 0.0, capacity = 100, current = 0, size = 1000.0, bonuses = {}, itemset = ocean_tug_cage},

}

local WITHIN_ZONE = false
local CURRENT_ZONE = nil

function GiveFishFromSet(location, min, max)
    local itemset = location.itemset
    local item = itemset[math.random(#itemset)]
    local amount = math.random(min, max)
    if amount > 0 then
        -- Code to give items
        TriggerServerEvent("omni_fishing:receiveFishTug", item, amount)
        -- TriggerEvent("gd_utils:notify", "Got " .. amount .. "x " .. item)
    end
end

-- Main Loop
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = GetPlayerPed(-1)
        WITHIN_ZONE = false
        CURRENT_ZONE = nil
        if IsVehicleModel(GetVehiclePedIsIn(ped, false), "TUG") then
            local pos = GetEntityCoords(ped, false)
            for _, location in next, tugging_locations do
                if not location.world_blip then
                    local blip = AddBlipForCoord(location.x, location.y, location.z)
                    SetBlipSprite(blip, 400)
                    SetBlipColour(blip, 25)
                    SetBlipAsShortRange(blip, true)
                    exports['omni_common']:SetBlipName(blip, "Net Fishing Zone")
                    location.world_blip = blip
                end
                if not WITHIN_ZONE then
                    -- Check if we are within the fishing area
                    local dist = #(vector3(location.x, location.y, location.z) - pos)
                    if dist < location.size + 150.0 then
                        -- Within a fishing area
                        DrawMarker(1, location.x, location.y, location.z, 0, 0, 0, 0, 0, 0, location.size * 2, location.size * 2, 2.0, 255, 255, 255, 255)

                        -- Make the radius blip if no present
                        if not location.blip then
                            local blip = AddBlipForRadius(location.x, location.y, location.z, location.size)
                            SetBlipAlpha(blip, 150)
                            SetBlipColour(blip, 25)
                            location.blip = blip
                        end

                        -- Check if we are within the zone itself
                        if dist < location.size then
                            -- Within the fishing zone

                            -- Mark as current zone (for fishing generator and bonus generator)
                            WITHIN_ZONE = true
                            CURRENT_ZONE = location

                            -- Check and draw bonuses
                            for _bonus_id, bonus in next, location.bonuses do
                                -- Create bonus blip if not present
                                if not bonus.blip then
                                    local blip = AddBlipForCoord(bonus.x, bonus.y, location.z)
                                    exports['omni_common']:SetBlipName(blip, "Net Fishing Bonus")
                                    bonus.blip = blip
                                end
                                -- Draw Marker on water (fancy!!)
                                local _, h = GetWaterHeight(bonus.x, bonus.y, 100.0)
                                DrawMarker(1, bonus.x, bonus.y, h, 0, 0, 0, 0, 0, 0, bonus.size * 2, bonus.size * 2, 2.0, 255, 255, 255, 255)

                                -- Check distance
                                local dist = #(vector3(bonus.x, bonus.y, location.z) - pos)
                                if dist < bonus.size * 2 then
                                    RemoveBlip(bonus.blip)
                                    bonus.blip = nil
                                    GiveFishFromSet(location, 4, 9)
                                    table.remove(location.bonuses, _bonus_id)
                                end
                            end
                        end
                    else
                        -- Not within a fishing area

                        -- Remove area blip
                        if location.blip then
                            RemoveBlip(location.blip)
                            location.blip = nil
                        end
                        -- Remove bonus blips
                        for _, bonus in next, location.bonuses do
                            if bonus.blip then
                                RemoveBlip(bonus.blip)
                                bonus.blip = nil
                            end
                        end
                    end
                end
            end
        else
            -- Not in a tug
            -- Remove blips
            for _, location in next, tugging_locations do
                if location.world_blip then
                    RemoveBlip(location.world_blip)
                    location.world_blip = nil
                end
                if location.blip then
                    RemoveBlip(location.blip)
                    location.blip = nil
                end
                for _, bonus in next, location.bonuses do
                    if bonus.blip then
                        RemoveBlip(bonus.blip)
                        bonus.blip = nil
                    end
                end
            end
        end
    end
end)

-- Fish Generator Loop
local last_pos = vector3(0.0, 0.0, 0.0)
Citizen.CreateThread(function()
    while true do
        Wait(2500)
        local ped = GetPlayerPed(-1)
        if WITHIN_ZONE then
            local pos = GetEntityCoords(ped, false)
            local dist = #(pos - last_pos)
            if dist > 55.0 then
                last_pos = pos
                local bonusFish = 0
                local weather = exports['omni_external']:GetGlobalCurrentWeather()
                if weather == "RAIN" then bonusFish = 1 end
                if weather == "THUNDER" then bonusFish = 2 end
                GiveFishFromSet(CURRENT_ZONE, -3 + bonusFish, 3 + bonusFish)
            end
        end
    end
end)

-- Bonus Generator Loop
local bonus_wait_time = 35 * 1000
Citizen.CreateThread(function()
    while true do
        if WITHIN_ZONE then
            local zone = CURRENT_ZONE
            local bonus = {}
            -- Make sure the position is never outside the zone
            local function gen()
                bonus.x = zone.x + math.random(-zone.size, zone.size)
                bonus.y = zone.y + math.random(-zone.size, zone.size)
                local dist = #(vector3(bonus.x, bonus.y, 0.0) - vector3(zone.x, zone.y, 0.0))
                if dist > zone.size then
                    gen()
                end
            end
            gen()
            bonus.size = 12.0
            if #zone.bonuses <= 5 then
                table.insert(zone.bonuses, bonus)
            end
        end
        Wait(bonus_wait_time)
    end
end)
