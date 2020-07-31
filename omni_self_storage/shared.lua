locations = {
    ["bctp"] = {
        fee = 50, name = "Blaine County Tractor Parts", size = 40000, cost = 1000000,
        storage_locations = {
            {x = 388.36904907227, y = 3586.8146972656, z = 33.29222869873},
        }
    },
    ["pbsf"] = {
        fee = 200, name = "Paleto Bay Self Storage", size = 60000, cost = 1000000,
        storage_locations = {
            {x = 46.444091796875, y = 6458.7602539063, z = 31.425287246704, area = "land"},
            {x = -37.641159057617, y = 7057.8452148438, z = 2.0027375221252, area = "ocean"},
            {x = -455.48385620117, y = 6552.7553710938, z = 10.766058921814, area = "air"},
        }
    },
    ["bhsl"] = {
        fee = 100, name = "Big House Storage LSIA", size = 250000, cost = 1000000,
        storage_locations = {
            {x = -512.517578125, y = -2200.123046875, z = 6.3940262794495},
        }
    },
    ["tsu"] = {
        fee = 200, name = "The Secure Unit", size = 150000, cost = 1000000,
        storage_locations = {
            {x = 911.31066894531, y = -1256.2835693359, z = 25.5778465271},
        }
    },
    ["dpss"] = {
        fee = 100, name = "Del Perro Self Storage", size = 80000, cost = 1000000,
        storage_locations = {
            {x = -1614.7346191406, y = -821.41516113281, z = 10.070293426514},
        }
    },
    ["gohq"] = {
        fee = 100, name = "Globe Oil HQ Self Storage", size = 45000, cost = 0,
        storage_locations = {
            {x = 2674.7131347656, y = 1429.8662109375, z = 24.500797271729},
        }
    },
    ["fthq"] = {
        fee = 0, name = "FRLLC HQ Self Storage", size = 50000, cost = 0,
        permissions = {"corp1.employee"},
        hidden = true,
        storage_locations = {
            {x = 340.37985229492, y = -561.98333740234, z = 28.743785858154},
        }
    },
    ["bats"] = {
        fee = 100, name = "Bay Area Towing HQ Self Storage", size = 100000, cost = 0,
        storage_locations = {
            {x = -639.17358398438, y = -1727.0373535156, z = 24.31266784668},
        }
    },
    ["rts"] = {
        fee = 0, name = "R.T.S. HQ Self Storage", size = 20000, cost = 0,
        permissions = {"corp9.employee"},
        hidden = true,
        storage_locations = {
            {x = 959.29248046875, y = -3005.3996582031, z = -39.63988494873},
        }
    },
    ["pigs"] = {
        fee = 0, name = "P.I.G.S. HQ Self Storage", size = 20000, cost = 0,
        permissions = {"corp11.employee"},
        hidden = true,
        storage_locations = {
            {x = 950.20416259766, y = -122.37786102295, z = 74.353050231934},
        }
    },
    ["collins"] = {
        fee = 0, name = "CollinsCo HQ Self Storage", size = 20000, cost = 0,
        permissions = {"corp2.employee"},
        hidden = true,
        storage_locations = {
            {x = 823.35955810547, y = -1370.6256103516, z = 26.136484146118},
        }
    },
    ["lc2"] = {
        fee = 50, name = "Staunton Island Self Storage", size = 40000, cost = 0,
        storage_locations = {
            {x = -3032.9343261719, y = 6938.701171875, z = 16.235837936401},
        }
    },
    -- ["mp"] = {
    --     fee = 0, name = "Marketplace Delivery", size = 0, cost = 0,
    --     storage_locations = {
    --         {x = 10000.0, y = 10000.0, z = 0.0},
    --     }
    -- },
    --[[["cst"] = {
        fee = 50, name = "Carson Self Storage", size = 10000, cost = 1000000,
        storage_locations = {
            {x = 40.713066101074, y = -1744.900390625, z = 29.303266525269},
        }
    }]]
}

function ReadableNumber(num, places)
    local ret
    local placeValue = ("%%.%df"):format(places or 0)
    if not num then
        return 0
    elseif num >= 1000000000000 then
        ret = placeValue:format(num / 1000000000000) .. " Tril" -- trillion
    elseif num >= 1000000000 then
        ret = placeValue:format(num / 1000000000) .. " Bil" -- billion
    elseif num >= 1000000 then
        ret = placeValue:format(num / 1000000) .. " Mil" -- million
    elseif num >= 1000 then
        ret = placeValue:format(num / 1000) .. "k" -- thousand
    else
        ret = num -- hundreds
    end
    return ret
end
