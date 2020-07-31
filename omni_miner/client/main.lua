local STATE = "ONDUTY"
local JobCooldown = 0

local toolModel = "prop_tool_pickaxe"
local animDict = "melee@large_wpn@streamed_core"
local animName = "ground_attack_0_long"

local _MINING_LOCATIONS = {
    {name = "Davis Quartz - Senora Way", x = 2971.450195, y = 2797.551270, z = 40.163715, h = 312.575623, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2975.415039, y = 2794.489014, z = 39.882942, h = 290.449829, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2975.702393, y = 2792.385742, z = 39.618427, h = 280.691895, capacity = 1, tier = 32}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2978.762451, y = 2790.149658, z = 39.568707, h = 323.957428, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2973.429199, y = 2774.917725, z = 37.185314, h = 78.125069, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2969.253662, y = 2776.536377, z = 37.386951, h = 173.332672, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2964.041260, y = 2774.961182, z = 38.482609, h = 172.186020, capacity = 1, tier = 16}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2955.511963, y = 2773.754150, z = 38.592045, h = 226.178604, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2953.028320, y = 2771.825684, z = 38.006523, h = 203.194107, capacity = 1, tier = 32}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2951.194336, y = 2769.004883, z = 38.033058, h = 201.023346, capacity = 1, tier = 16}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2947.966064, y = 2768.305420, z = 37.937508, h = 195.549835, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2938.595703, y = 2772.000732, z = 38.258457, h = 90.051338, capacity = 1, tier = 16}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2935.327637, y = 2784.550781, z = 38.528759, h = 117.653305, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2931.819336, y = 2786.720703, z = 38.600780, h = 72.879173, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2927.189941, y = 2788.064697, z = 38.867859, h = 310.270050, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2927.272217, y = 2792.392822, z = 39.489326, h = 86.944801, capacity = 1, tier = 16}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2926.448975, y = 2795.146240, z = 39.783260, h = 116.189560, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2922.386230, y = 2799.349609, z = 40.282803, h = 92.362152, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2937.558838, y = 2812.180664, z = 41.798210, h = 299.319458, capacity = 1, tier = 32}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2944.979736, y = 2817.628906, z = 41.703308, h = 29.698994, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2947.352783, y = 2819.640137, z = 41.716091, h = 311.626190, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2951.721924, y = 2816.597168, z = 41.264622, h = 142.748825, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2955.253174, y = 2819.198730, z = 41.453846, h = 311.393677, capacity = 1, tier = 16}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2959.609619, y = 2818.950439, z = 42.192944, h = 359.790131, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2992.360840, y = 2776.381348, z = 42.111500, h = 67.361374, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2984.909912, y = 2763.376221, z = 41.772594, h = 91.279770, capacity = 1, tier = 32}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2988.523438, y = 2755.167236, z = 41.775326, h = 137.113739, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2974.782227, y = 2746.310303, z = 42.147903, h = 154.665176, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2954.115234, y = 2755.745117, z = 42.528923, h = 312.560089, capacity = 1, tier = 16}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2939.728027, y = 2743.836426, z = 42.320583, h = 177.494141, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2944.160400, y = 2740.593262, z = 42.786072, h = 89.065468, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2949.908447, y = 2738.587891, z = 43.462395, h = 7.347841, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2930.507080, y = 2761.293701, z = 43.670834, h = 336.324860, capacity = 1, tier = 16}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2927.375244, y = 2764.432129, z = 43.646713, h = 297.581421, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2993.791016, y = 2754.562012, z = 43.002506, h = 182.685196, capacity = 1, tier = 32}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2998.460449, y = 2758.380615, z = 41.969643, h = 206.159195, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 3001.822998, y = 2773.820068, z = 41.979084, h = 258.857269, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2932.123535, y = 2815.810303, z = 43.585381, h = 30.905043, capacity = 1, tier = 32}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2926.956055, y = 2812.354248, z = 43.309917, h = 36.808582, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2938.214355, y = 2757.539063, z = 42.989288, h = 107.610809, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2942.806396, y = 2761.179688, z = 40.856331, h = 159.916122, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2943.754883, y = 2757.163086, z = 41.845638, h = 147.941772, capacity = 1, tier = 16}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2948.099121, y = 2755.630859, z = 42.186131, h = 137.286636, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2958.839600, y = 2760.134277, z = 40.780727, h = 212.105438, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2958.453369, y = 2765.025146, z = 40.158623, h = 297.221497, capacity = 1, tier = 32}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2958.480713, y = 2768.135010, z = 39.817978, h = 158.566910, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2958.811523, y = 2772.478516, z = 39.183266, h = 79.620567, capacity = 1, tier = 16}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2981.246826, y = 2786.606689, z = 39.420212, h = 288.513397, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2980.317871, y = 2782.651855, z = 38.226738, h = 232.094940, capacity = 1, tier = 1}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2994.666260, y = 2802.485596, z = 42.534084, h = 305.594574, capacity = 1, tier = 16}, -- Collins (2)
    {name = "Davis Quartz - Senora Way", x = 2978.572998, y = 2827.559326, z = 44.914070, h = 309.345367, capacity = 1, tier = 1}, -- Collins (2)
}

local mining_locations = {}
function RandomizeMiningLocations(numberOfLocations)
    function shuffle(tbl)
        for i = #tbl, 2, - 1 do
            local j = math.random(i)
            tbl[i], tbl[j] = tbl[j], tbl[i]
        end
        return tbl
    end

    mining_locations = {}
    local locations = shuffle(_MINING_LOCATIONS)
    for i = 1, math.min(numberOfLocations, #_MINING_LOCATIONS) do
        table.insert(mining_locations, locations[i])
    end
end
RandomizeMiningLocations(15)

local job_blip_settings = {
    start_blip = {id = 455, color = 46},
    pickup_blip = {id = 280, color = 69},
    destination_blip = {id = 538, color = 46},
    vehicle_blip = {id = 529, color = 48},
    marker = {r = 255, g = 255, b = 255, a = 100},
    marker_special = {r = 255, g = 255, b = 0, a = 200},
    spawner_blip = {id = 524, color = 17},
}

function drawMarker(x,y,z,s,r,g,b)
    local marker = job_blip_settings.marker
    if s or false then
        marker = job_blip_settings.marker_special
    end
    local pos = GetEntityCoords(PlayerPedId())
    if #(vector3(x, y, z) - pos) < 50.0 then
        DrawMarker(1, x, y, z, 0,0,0,0,0,0,2.0,2.0,2.0,r,g,b,200,0,0,0,0)
    end
end

function nearMarker(x, y, z)
    local p = GetEntityCoords(PlayerPedId())
    return #(vector3(x, y, z) - p) < 2.0
end

function DrawText3D(text, x, y, z, s)
    exports['omni_common']:DrawText3D(text, x, y, z, s)
end

function isEPressed()
    return IsControlJustPressed(0, 38)
end

RegisterNetEvent("omni:miner:tryStartJob")
AddEventHandler("omni:miner:tryStartJob", function(locationIndex, location)
    if STATE == "ONDUTY" then
        local location = mining_locations[locationIndex]
        if location.capacity > 0 then
            location.capacity = location.capacity - 1
            exports['omni_common']:SetStatus("MinerMan", {"Here to mine shit and make money",""})
            startJob(locationIndex)
            Citizen.SetTimeout(3 * 60 * 1000, function()
                if location.capacity < (location.maxCapacity or 1) then
                    location.capacity = location.capacity + 1
                end
            end)
        end
    end
end)

function startJob(locationIndex)
    STATE = "MINNING"
    FreezeEntityPosition(PlayerPedId(), true)
    SetPlayerControl(PlayerPedId(), true, 2560)
    -- SetPlayerControl(player, toggle, possiblyFlags)
    local location = mining_locations[locationIndex]
    tier = location.tier
    RequestModel(GetHashKey(toolModel))
    while not HasModelLoaded(GetHashKey(toolModel)) do
        Citizen.Wait(100)
    end
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100)
    end
    local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
    local toolspawned = CreateObject(GetHashKey(toolModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
    Citizen.Wait(1000)
    local tool_net = ObjToNet(toolspawned)
    SetNetworkIdExistsOnAllMachines(tool_net, true)
    SetNetworkIdCanMigrate(tool_net, false)
    AttachEntityToEntity(toolspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.03,-0.05, -0.01, 270.0, 170.0, 0.0, 1, 1, 0, 1, 0, 1)
    AttachEntityToEntity(entity1, entity2, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, vertexIndex, fixedRot)
    local remainingStrikes = math.random(5,10)
    while remainingStrikes >= 0 do
        if STATE == "MINNING" then
            if not IsPedInVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), false) then
                Wait(1000)
                exports['omni_common']:SetStatus("MinerMan", {"Here to mine shit and make ~g~money~w~","Mining mode ~r~ACTIVATED~w~", "Swings remaining: " .. remainingStrikes})
                FreezeEntityPosition(PlayerPedId(), true)
                TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
                TaskPlayAnim(GetPlayerPed(PlayerId()), animDict, animName, 1.0, -1, -1, 51, 0, 0, 0, 0)
                Wait(2500)
                remainingStrikes = remainingStrikes - 1
            else
                TriggerEvent("gd_utils:notify", "~r~ You can't mine while in a vehicle")
                DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
            end
        else
            break
        end
    end
    TriggerServerEvent("omni:miner:finishJob", tier)
    DetachEntity(NetToObj(tool_net), 1, 1)
    DeleteEntity(NetToObj(tool_net))
    stopJob()
end

RegisterNetEvent("omni:miner:set_job_state")
AddEventHandler("omni:miner:set_job_state", function(b)
    JOB_ACTIVE = b
end)

function stopJob()
    STATE = "ONDUTY"
    FreezeEntityPosition(PlayerPedId(), false)
    SetPlayerControl(PlayerPedId(), false, 2560)
    ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
    TriggerEvent("omni:status", "")
    RandomizeMiningLocations(10)
end

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if JOB_ACTIVE then
            if STATE == "ONDUTY" then
                if nearMarker(2946.8266601563, 2742.126953125, 43.457836151123) then
                    if (JobCooldown == 0) then
                        DrawMarker(1, 2946.8266601563, 2742.126953125, 43.457836151123 - 1.0, 0,0,0,0,0,0,2.0,2.0,2.0,255,255,255,200,0,0,0,0)
                        DrawText3D("Press ~g~E~w~ to randomize mining locations", 2946.8266601563, 2742.126953125, 43.457836151123, 1.0)
                        if isEPressed() then
                            for k,v in next, mining_locations do
                                RemoveBlip(v.blip)
                                v.blip = nil
                            end
                            RandomizeMiningLocations(10)
                            JobCooldown = 60
                        end
                    else
                        DrawText3D("~r~ You can't reset for ".. JobCooldown .. " seconds", 2946.8266601563, 2742.126953125, 43.457836151123, 1.0)
                        -- TriggerEvent("gd_utils:notify", "~r~Chill the fuck out kid. You literally JUST reset this shit")
                    end
                end
                for k,v in next, mining_locations do
                    if v.capacity > 0 then
                        if v.tier == 1 then
                            drawMarker(v.x, v.y, v.z, 2.0, 255,255,255)
                            -- DrawMarker(1, v.x, v.y, v.z - 1.0, 0,0,0,0,0,0,2.0,2.0,2.0,255,255,255,200,0,0,0,0)
                        elseif v.tier == 16 then
                            drawMarker(v.x, v.y, v.z, 2.0, 210, 255, 210)
                            -- DrawMarker(1, v.x, v.y, v.z - 1.0, 0,0,0,0,0,0,2.0,2.0,2.0,210, 255, 210, 200,0,0,0,0)
                        elseif v.tier == 32 then
                            drawMarker(v.x, v.y, v.z, 2.0, 255, 200, 200, 200)
                            -- DrawMarker(1, v.x, v.y, v.z - 1.0, 0,0,0,0,0,0,2.0,2.0,2.0,255, 200, 200, 200,0,0,0,0)
                        end
                        if not v.blip then
                            if v.tier == 1 then
                                v.blip = AddBlipForCoord(v.x, v.y, v.z)
                                SetBlipSprite(v.blip, 383)
                                SetBlipColour(v.blip, 45)
                                SetBlipName(v.blip, v.name)
                                SetBlipAsShortRange(v.blip, true)
                            elseif v.tier == 16 then
                                v.blip = AddBlipForCoord(v.x, v.y, v.z)
                                SetBlipSprite(v.blip, 383)
                                SetBlipColour(v.blip, 43)
                                SetBlipName(v.blip, v.name)
                                SetBlipAsShortRange(v.blip, true)
                            elseif v.tier == 32 then
                                v.blip = AddBlipForCoord(v.x, v.y, v.z)
                                SetBlipSprite(v.blip, 383)
                                SetBlipColour(v.blip, 59)
                                SetBlipName(v.blip, v.name)
                                SetBlipAsShortRange(v.blip, true)
                            end
                        end
                        if nearMarker(v.x, v.y, v.z) then
                            DrawText3D("Press ~g~E~w~ to start mining", v.x, v.y, v.z + 1.5, 1.0)
                            DrawText3D("~y~Requires level " .. v.tier, v.x, v.y, v.z + 1.3, 1.0)
                            if isEPressed() then
                                if not IsPedInVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), true), false) then
                                    TriggerServerEvent("omni:miner:tryStartJob", k, v)
                                else
                                    TriggerEvent("gd_utils:notify","You can't mine from within a vehicle.")
                                end
                            end
                        end
                    end
                end
            else
                for k,v in next, mining_locations do
                    if STATE == "MINNING" then
                        RemoveBlip(v.blip)
                        v.blip = nil
                    end
                end
            end
        else
            for k,v in next, mining_locations do
                RemoveBlip(v.blip)
                v.blip = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if(JobCooldown > 0) then
            JobCooldown = JobCooldown - 1
        end
    end
end)
