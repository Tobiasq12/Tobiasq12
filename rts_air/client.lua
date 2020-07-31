local starttimer = 0
-- Point B
local carSpawns = {
    {
        pickup = {x = -941.732421875, y = -2955.1806640625, z = 13.945069313049, h = 146.86517333984},-- LSIA
        spawn = {x = -969.96710205078, y = -3006.666015625, z = 14.961208343506, h = 61.230731964111},
    },
    {
        pickup = {x = 3038.8386230469, y = -1486.3408203125, z = 19.43878364563, h = 348.85330200195},-- Pacific Ocean
        spawn = {x = 3025.6184082031, y = -1446.9311523438, z = 19.43879699707, h = 331.166015625},
    },
    -- {
    --     pickup = {x = 2949.3127441406, y = -593.59484863281, z = 8.4869747161865, h = 348.85330200195},-- Pacific Ocean
    --     spawn = {x = 2973.158203125, y = -573.35052490234, z = 8.4335422515869, h = 220.23823547363},
    -- },
    {
        pickup = {x = 3058.0029296875, y = -4762.0151367188, z = 15.261320114136, h = 23.59602355957},-- Carrier
        spawn = {x = 3068.994140625, y = -4744.5166015625, z = 16.277074813843, h = 25.774589538574},
    },
    {
        pickup = {x = 1695.2416992188, y = 3288.837890625, z = 41.146545410156, h = 137.60607910156},-- Sandy Shores
        spawn = {x = 1727.7736816406, y = 3256.7900390625, z = 42.237731933594, h = 104.77538299561},
    },
    {
        pickup = {x = -1834.1702880859, y = 3018.4836425781, z = 32.81042098999, h = 321.48965454102},-- Zancudo
        spawn = {x = -1831.7210693359, y = 2977.1743164063, z = 33.825290679932, h = 59.017024993896},
    },
    -- {
    --     pickup = {x = -423.42916870117, y = 6519.240234375, z = 7.5994844436646, h = 125.54257202148},-- Paleyto Bai
    --     spawn = {x = -403.81115722656, y = 6569.7807617188, z = 8.6980037689209, h = 46.065227508545},
    -- },
    {
        pickup = {x = -166.74499511719, y = 6593.8139648438, z = 10.766191482544, h = 0.0},-- Paleyto Bai
        spawn = {x = -155.78730773926, y = 6638.1552734375, z = 10.766198158264, h = 341.79815673828},
    },
    {
        pickup = {x = 2145.3779296875, y = 4781.8618164063, z = 40.970283508301, h = 285.44366455078},-- McKenzie
        spawn = {x = 2119.7644042969, y = 4803.6767578125, z = 42.211200714111, h = 115.0562210083},
    },
    -- {
    --     pickup = {x = 1299.3717041016, y = 6729.8974609375, z = 5.9842886924744, h = 0.0},-- Procopio
    --     spawn = {x = 1308.9975585938, y = 6748.5151367188, z = 5.9836959838867, h = 352.74993896484},
    -- },
    {
        pickup = {x = 535.45288085938, y = 3778.6525878906, z = 33.406047821045, h = 351.03466796875},-- SSIA
        spawn = {x = 534.21917724609, y = 3737.2795410156, z = 33.426044464111, h = 86.317459106445},
    },
    {
        pickup = {x = 2926.5009765625, y = 6494.0166015625, z = 21.018966674805, h = 38.748870849609},-- Mt. Gordo
        spawn = {x = 2892.9694824219, y = 6525.4897460938, z = 21.018985748291, h = 18.585643768311},
    },
}

-- Point C
local planeLocations = {
    {name = "LSIA", x = -1061.6075439453, y = -2968.0295410156, z = 14.980706214905},
    {name = "Pacific Ocean", x = 3025.7409667969, y = -1446.5844726563, z = 19.43879699707, h = 152.61920166016},
    {name = "Carrier", x = 3060.16015625, y = -4725.4663085938, z = 16.275838851929},
    {name = "Sandy Shores", x = 1782.7788085938, y = 3271.87109375, z = 42.978950500488},
    {name = "Zancudo", x = -1831.7210693359, y = 2977.1743164063, z = 33.825290679932},
    {name = "Paleto Bay", x = -155.78730773926, y = 6638.1552734375, z = 10.766198158264},
    {name = "McKenzie", x = 2054.39453125, y = 4807.0712890625, z = 42.382900238037},
    -- {name = "Procopio", x = 1308.9975585938, y = 6748.5151367188, z = 5.9836959838867},
    {name = "SSIA", x = 534.21917724609, y = 3737.2795410156, z = 33.426044464111},
    {name = "Mt. Gordo", x = 2882.1494140625, y = 6521.48046875, z = 21.018962860107},
}

local helicopterLocations = {
    {name = "Oil Rig", x = -4192.5590820313, y = 8881.8994140625, z = 27.359039306641},
    {name = "Humane Labs", x = 3569.1328125, y = 3662.8850097656, z = 34.977542877197},
    {name = "Small Racetrack", x = 3702.3771972656, y = 5769.9301757813, z = 9.1074771881104},
    {name = "North Calafia Way", x = 1299.2691650391, y = 4365.6733398438, z = 48.639442443848},
    {name = "North Bunker", x = -392.07293701172, y = 4362.458984375, z = 59.407638549805},
    {name = "West Sandy Shores Bunker", x = 18.194406509399, y = 2610.7358398438, z = 87.007080078125},
    {name = "East Sandy Shores Bunker", x = 2073.6499023438, y = 1748.6480712891, z = 103.78193664551},
    {name = "Oil Refinery", x = 2755.7145996094, y = 1366.1864013672, z = 23.830404281616},
    {name = "East Vinewood Hills Mansion", x = 260.95367431641, y = 777.79797363281, z = 200.71784973145},
    {name = "Amphitheatre", x = 654.15496826172, y = 670.22796630859, z = 129.92758178711},
    {name = "East Vinewood Hills Mansion", x = 263.30606079102, y = 776.16101074219, z = 200.71788024902},
    {name = "Dog Track & Casino", x = 1010.9430541992, y = 161.05612182617, z = 82.006561279297},
    {name = "East Vinewood Hills Mansion", x = -126.63202667236, y = 996.78405761719, z = 236.76116943359},
    {name = "Vinewood Hills Mansion", x = -770.99688720703, y = 770.2978515625, z = 214.21501159668 },
    {name = "Vinewood Hotel", x = -1192.2019042969, y = 331.2998046875, z = 71.817459106445},
    {name = "Country Club / Golf Course", x = -1397.9582519531, y = 66.826812744141, z = 54.436450958252},
    {name = "Bell Building", x = -2343.267578125, y = 318.69793701172, z = 170.64039611816},
    {name = "Lombank Building", x = -1582.3245849609, y = -569.41754150391, z = 117.34466552734},
    {name = "Mini-Maze Bank", x = -1391.8049316406, y = -477.88122558594, z = 92.266937255859},
    {name = "Playboy Mansion", x = -1524.9318847656, y = 92.244972229004, z = 57.582611083984},
    {name = "IAA Building", x = 139.22926330566, y = -627.30810546875, z = 263.86813354492},
    {name = "RTS Headquarters", x = -144.66540527344, y = -593.05865478516, z = 212.7917175293},
    {name = "Maze Bank", x = -75.150993347168, y = -819.01031494141, z = 327.19174194336},
    {name = "Peaceful Street Building", x = -277.17874145508, y = -734.23022460938, z = 125.01321411133},
    {name = "FIB Building", x = 122.74672698975, y = -742.2197265625, z = 263.86273193359},
    {name = "Calais Avenue Building", x = -589.17114257813, y = -717.29327392578, z = 130.25492858887},
    {name = "Little Seoul Building", x = -819.23345947266, y = -687.33447265625, z = 122.28367614746},
    {name = "Under Construction Skyscraper", x = -90.653030395508, y = -988.19464111328, z = 105.27839660645},
    {name = "Buen Vino Road Mansion", x = -2563.0932617188, y = 1907.0256347656, z = 170.17726135254},
}

local planes = {
    common = {
        {"mammatus", "172 Skyhawk"},
        {"duster", "Stearman PT-17 Crop Duster"},
        {"dodo", "Cessna 152"},
        {"cuban800", "Cessna 310"},
        {"velum", "TMB 850"},
        {"velum2", "TMB 850 5 seater"},
    },
    unique = {
        {"mogul","Beechcraft Model 18"},
        {"vestra", "Cirrus Vision SF50"},
        {"tula", "Kaman K-16"},
        {"seabreeze"," Seawind 300c"},
    },
    legendary = {
        {"howard", "Hughes H-1 Racer"},
        {"nimbus", "Nimbus Cessna Citation X"},
        {"miljet", "Bombardier CRJ200"},
        {"rogue", "Beechcraft T-6 Texan II"},
    },
    impossible = {
        {"molotok", "MiG-17"},
        {"pyro", "De Havilland Vampire"},
        {"besra","Northrop F20 Tigershark"},
        {"dash8", "Dash 8"},
        {"starling", "Messerschmitt Me 163 Komet"},
        {"nokota", "North American P-51 Mustang"},
        {"alphaz1", "Reberry 3M1C1R"},
    }
}

local helicopters = {
    common = {
        {"frogger", "Eurocopter EC130"},
        {"maverick", "Maverick"},
    },
    unique = {
        {"buzzard2", "Buzzard"},
        {"swift2", "Swift Deluxe"},
    },
    legendary = {
        {"supervolito", "SuperVolito"},
        {"supervolito2", "SuperVolito Carbon"},
        {"volatus", "Volatus"},
    },
    impossible = {
        {"havok", "CH-7"},
        {"seasparrow", "Amphibious Bell 47"},
        {"tourmav", "Tour Maverick"},
    }
}

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

local cooldown = 0
local current_job = {}

function SetBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

local function GetRandomTier()
    if math.random(0,100) < 70 then
        local random = math.random(0,100)
        if random < 5 then
            -- impossible
            return 5, "Amazing", planes.impossible, "plane"
        elseif random < 25 then
            -- unique
            return 2, "Unique", planes.unique, "plane"
        elseif random < 85 then
            -- common
            return 1, "Common", planes.common, "plane"
        else
            -- legendary
            return 4, "Legendary", planes.legendary, "plane"
        end
    else
        local random = math.random(0,100)
        if random < 5 then
            -- impossible
            return 5, "Amazing Helicopter", helicopters.impossible, "helicopter"
        elseif random < 25 then
            -- unique
            return 2, "Unique Helicopter", helicopters.unique, "helicopter"
        elseif random < 85 then
            -- common
            return 1, "Common Helicopter", helicopters.common, "helicopter"
        else
            -- legendary
            return 4, "Legendary Helicopter", helicopters.legendary, "helicopter"
        end
    end
end

--[[
    TIERS
    00 - 50 (50%) [common]
    50 - 70 (20%) [unique]
    70 - 85 (15%) [epic]
    85 - 95 (10%) [legendary]
    95 - 100 (5%) [impossible]
]]

local function GetRandomVehicle()
    local tier, tiername, tierList, jobType = GetRandomTier()
    local vehicleData = tierList[math.random(1,#tierList)]
    return vehicleData[1], vehicleData[2], tier, tiername, jobType
end

local function GetRandomDestination(jobType, location)
    local dest = {name = "Invalid JobType", x = -1061.6075439453, y = -2968.0295410156, z = 14.980706214905}
    if jobType == "plane" then
        dest = planeLocations[math.random(1,#planeLocations)]
    elseif jobType == "helicopter" then
        dest = helicopterLocations[math.random(1,#helicopterLocations)]
    end
    local dist = #(vec3(location.spawn.x, location.spawn.y, location.spawn.z) - vec3(dest.x, dest.y, dest.z))
    while dist < 2000 do
        dest = GetRandomDestination(jobType, location)
        dist = #(vec3(location.spawn.x, location.spawn.y, location.spawn.z) - vec3(dest.x, dest.y, dest.z))
    end
    dist = math.floor(dist)
    return dest, dist
end

function drawText(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 500, true)
end

local function StartJob()
    local blip = AddBlipForCoord(current_job.destination.x, current_job.destination.y, current_job.destination.z)
    local destName = current_job.name
    SetBlipSprite(blip, 525)
    SetBlipColour(blip, 6)
    SetBlipRoute(blip, true)
    SetBlipName(blip, destName)
    current_job.dest_blip = blip
    TriggerEvent("omni:status", "~y~R.T.S. Aviator Delivery", {"~g~Vehicle: ~w~" .. current_job.vehicleName, "~g~Destination: ~w~" .. destName, "~g~Distance: ~w~" .. current_job.distance .. "m"})
    TriggerEvent("gd_utils:overlay", " ", current_job.tierName .. " Delivery", "Deliver the ~g~" .. current_job.vehicleName .. " ~w~to ~g~" .. destName )
    TriggerEvent("gd_utils:over_vehicle", true)
    starttimer = GetGameTimer()
end

local function StopJob()
    if current_job.active then
        RemoveBlip(current_job.dest_blip)
        RemoveBlip(current_job.veh_blip)
        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
        current_job = {}
        TriggerEvent("omni:status", "", "")
    end
end

AddEventHandler('omni:stop_job', function()
    StopJob()
end)

RegisterNetEvent("omni:rts:start_air_job")
AddEventHandler("omni:rts:start_air_job", function(location)
    local vehicleId, vehicleName, vehicleTier, vehicleTierName, jobType = GetRandomVehicle()
    print(("VehID: %s VehName: %s VehTier: %i VehTierName: %s"):format(vehicleId, vehicleName, vehicleTier, vehicleTierName))
    local destination, distance = GetRandomDestination(jobType, location)
    TriggerEvent("gd_utils:summon", vehicleId, "RTS LVL" .. vehicleTier, function(veh)
        local blip = AddBlipForEntity(veh)
        SetBlipSprite(blip, 583)
        SetBlipColour(blip, 6)
        DecorSetBool(veh, "omni_ignore_locker", true)
        DecorSetBool(veh, "omni_norepmod", true)
        current_job = {
            vehicle = veh,
            tier = vehicleTier,
            tierName = vehicleTierName,
            vehicleName = vehicleName,
            vehicleId = vehicleId,
            active = true,
            from = location,
            destination = destination,
            veh_blip = blip,
            name = destination.name,
            jobType = jobType,
            distance = distance,
        }
        StartJob()
    end, location.spawn)
end)

function promptCar(location)
    drawText("[RTS] Press ~g~E ~w~to pick up an ~y~aircraft ~w~by showing your ~o~license")
    if IsControlJustPressed(0, 38) then
        cooldown = 2000
        -- TriggerEvent("omni:rts:start_job", location)
        TriggerServerEvent("omni:rts:check_air_job", location)
    end
end

function promptDeliver()
    drawText("Press ~g~E ~w~to deliver the ~y~aircraft")
    if IsControlJustPressed(0, 38) then
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, false)
        if PlayerPedId() == GetPedInVehicleSeat(veh, -1) then
            local score = (GetVehicleBodyHealth(veh) + GetVehicleEngineHealth(veh)) - 1000
            current_job.endtimer = GetGameTimer() - starttimer
            TriggerServerEvent("omni:rts:finish_air_job", score, current_job)
            TriggerEvent("gd_utils:dv")
            StopJob()
        end
    end
end

local RTS_JOB_ACTIVE = false
RegisterNetEvent("rts:set_job_state")
AddEventHandler("rts:set_job_state", function(b)
    RTS_JOB_ACTIVE = b
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if RTS_JOB_ACTIVE then
            local playerPos = GetEntityCoords(PlayerPedId())
            if not current_job.active then
                if cooldown <= 0 then
                    for k,v in next, carSpawns do
                        local dist = #(playerPos - vector3(v.pickup.x, v.pickup.y, v.pickup.z))
                        if dist <= 10.0 then
                            DrawMarker(33, v.pickup.x, v.pickup.y, v.pickup.z - 0.2, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 100, true, true, 0, false)
                        end
                        if dist <= 4.0 then
                            promptCar(v)
                        end
                    end
                else
                    cooldown = cooldown - 1
                end
            else
                local dist = math.floor(#(playerPos - vector3(current_job.destination.x, current_job.destination.y, current_job.destination.z)))
                exports['omni_common']:SetStatus("~o~R.T.S. Aviator Delivery", {"~w~Vehicle: ~w~" .. current_job.vehicleName, "~w~Destination: ~w~" .. current_job.name, "~w~Distance: ~w~" .. dist .. "m"})
                if dist <= 25.0 then
                    DrawMarker(36, current_job.destination.x, current_job.destination.y, current_job.destination.z + 0.2, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 100, true, true, 0, false)
                    DrawMarker(1, current_job.destination.x, current_job.destination.y, current_job.destination.z - 1.0, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 3.0, 255, 255, 255, 100, false, false, 0, false)
                end
                if dist <= 2.0 then
                    if IsPedInVehicle(PlayerPedId(), current_job.vehicle, false) then
                        promptDeliver()
                    end
                end
            end
        end
    end
end)
