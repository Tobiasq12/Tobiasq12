
-- Blacklisted vehicles, any model put here will have fuel disabled
BLACKLISTED_VEHICLES = {
    "security",
    "security1",
    "security2",
    "security3",
    "sectruck",
    "dilettante2",
}

-- Special vehicles, define any vehicles with special traits here, [model] = data
-- DATA FIELDS:
-- usage: fuel consumption modifier
-- capacity: fuel capacity modifier
-- type: fuel type, common types are "DIESEL", "SPECIAL" and "HEAVY"
-- active: if fuel is enabled on this vehicle
SPECIAL_VEHICLES = {
    -- ["dilettante2"] = {usage = 8.0, capacity = 0.5, type = "MAD DAB", active = true},
}

FUEL_PRICES = {
    ["ELECTRIC"] = {0, 0},
    ["DIESEL"] = {20, 60},
    ["HEAVY"] = {40, 100},
    ["BOAT"] = {50, 120},
    ["AIRPLANE"] = {60, 150},
    ["HELICOPTER"] = {50, 120},
    ["RRERR"] = {621, 926},
    ["ADMIN"] = {621, 926},
    ["BLACKLISTED"] = {621, 926},
}

FUEL_NAMES = {
    ["ELECTRIC"] = "Electric",
    ["DIESEL"] = "Petrol",
    ["HEAVY"] = "Diesel",
    ["BOAT"] = "Boat",
    ["AIRPLANE"] = "Airplane",
    ["HELICOPTER"] = "Helicopter",
    ["RRERR"] = "Windragon",
    ["ADMIN"] = "Staff",
    ["BLACKLISTED"] = "Blacklisted",
}

function GetFuelPrices(fuelType)
    return FUEL_PRICES[fuelType] or {0, 0}
end
function GetFuelName(fuelType)
    return FUEL_NAMES[fuelType] or fuelType .. " (Invalid)"
end
