function reqModel(model)
    RequestModel(model)
    local _t = 0
    while not HasModelLoaded(model) and _t < 100 do
        _t = _t + 1
        Wait(0)
    end
    return model
end

function log(text)
    print("[omni_pigs/client] " .. text)
end

function generatePed(origin, distance, model, cb)
    reqModel(model)
    local success, pos, nodeid = GetRandomVehicleNode(origin.x, origin.y, origin.z, distance, 0, 0, 0)
    if success then
        local ped = CreatePed(25, model, pos.x, pos.y, pos.z + 0.5, math.random(0,360) * 1.0, true, true)
        SetNetworkIdCanMigrate(PedToNet(ped), false)
        SetPedRelationshipGroupHash(ped, `PIGS_ENEMY`)
        print("GENERATED PED")
        cb(ped)
        TaskCombatPed(ped, GetPlayerPed(-1), 0, 16)
    end
end

function generateVehicle(origin, distance, model, cb)
    reqModel(model)
    local success, position, nodeid = GetRandomVehicleNode(origin.x, origin.y, origin.z, distance, 0, 0, 0)
    if success then
        local veh = CreateVehicle(model, position.x, position.y, position.z, math.random(0,360) * 1.0, true, true)
        SetNetworkIdCanMigrate(VehToNet(veh), false)
        print("GENERATED VEH")
        cb(veh)
        Citizen.CreateThread(function()
            Wait(120*1000)
            SetEntityAsNoLongerNeeded(veh)
        end)
    end
end

function generateHelicopter(origin, distance, model, cb)
    reqModel(model)
    local pos = vector3(origin.x + math.random(-distance, distance), origin.y + math.random(-distance, distance), origin.z + 150.0)
    local veh = CreateVehicle(model, pos.x, pos.y, pos.z, math.random(0,360) * 1.0, true, true)
    SetNetworkIdCanMigrate(VehToNet(veh), false)
    print("GENERATED HEL")
    cb(veh)
    Citizen.CreateThread(function()
        Wait(120*1000)
        SetEntityAsNoLongerNeeded(veh)
    end)
end

function setBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

function drawText(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 500, true)
end

function isEPressed()
    return IsControlJustPressed(0, 38)
end

function drawMarker(x,y,z)
    DrawMarker(1, x, y, z - 1.0, 0,0,0,0,0,0,1.0,1.0,1.0,0,155,255,200,0,0,0,0)
    --DrawMarker(type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, red, green, blue, alpha, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts)
end

function nearMarker(x, y, z)
    local p = GetEntityCoords(GetPlayerPed(-1))
    local zDist = math.abs(z - p.z)
    return (#(p - vec3(x, y, z)) < 1.25 and zDist < 1)
end

function setBlipDestination(pos)
    if DoesBlipExist(current_job.blip) then RemoveBlip(current_job.blip) end
    current_job.blip = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite(current_job.blip, 1)
    setBlipName(current_job.blip, pos.name)
    SetBlipColour(current_job.blip, 70)
    SetBlipRoute(current_job.blip, true)
end

function StayStillInPlace(position, distance, time, success, fail)
    local _drawMarker = true
    Citizen.CreateThread(function()
        local ped = GetPlayerPed(-1)
        local _time_passed = 0
        local _success = true
        local _reason = ""
        local blip = AddBlipForRadius(position.x, position.y, position.z, distance)
        TriggerEvent("omni:timer:countdown", time)
        while _time_passed < time do
            Wait(1000)
            local pos = GetEntityCoords(ped)
            local dist = #(pos - vector3(position.x, position.y, position.z))
            -- If ragdolled or outside the designated zone, fail
            if dist > distance then
                _success = false
                _reason = "left their zone"
                break
            end
            if IsPedRagdoll(ped) then
                _success = false
                _reason = "knocked down"
                break
            end
            _time_passed = _time_passed + 1
        end
        _drawMarker = false
        RemoveBlip(blip)
        TriggerEvent("omni:timer:stop", true)
        if _success then
            success()
        else
            fail(_time_passed, _reason)
        end
    end)
    Citizen.CreateThread(function()
        while true do
            Wait(0)
            if _drawMarker then
                DrawMarker(1, position.x, position.y, position.z - 1.0, 0,0,0,0,0,0,distance*2,distance*2,1.0,255,0,0,100,0,0,0,0)
            else
                break
            end
        end
    end)
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

local normal_vehicles = {
    "dilettante",
    "granger",
    "mesa3",
    "bison",
}

local normal_peds = {
    "s_m_m_security_01"
}

local armed_vehicles = {
    "fbi2",
    "granger",
    "insurgent",
}

local armed_peds = {
    "s_m_m_chemsec_01",
    "s_m_m_armoured_01",
    "s_m_m_armoured_02",
}

local heli_vehicles = {
    "polmav",
    "frogger",
    "swift",
}
local all_vehicles = {}
for _, mod in next, normal_vehicles do
    table.insert(all_vehicles, mod)
end
for _, mod in next, armed_vehicles do
    table.insert(all_vehicles, mod)
end

local all_peds = {}
for _, mod in next, normal_peds do
    table.insert(all_peds, mod)
end
for _, mod in next, armed_peds do
    table.insert(all_peds, mod)
end

function SpawnRandomSecurity(position, level, cb_ped, cb_veh)
    generateVehicle(position, 200.0, normal_vehicles[math.random(#normal_vehicles)], function(veh)
        for i = 1, level, 1 do
            generatePed(position, 120.0, normal_peds[math.random(#normal_peds)], function(ped)
                GiveWeaponToPed(ped, "WEAPON_PISTOL", 100, false, true)
                SetPedIntoVehicle(ped, veh, i - 2)
                if cb_ped then
                    cb_ped(ped)
                end
            end)
        end
        if cb_veh then
            cb_veh(veh)
        end
    end)
end
function SpawnRandomPeds(position, level, cb_ped, cb_veh)
    generateVehicle(position, 200.0, normal_vehicles[math.random(#normal_vehicles)], function(veh)
        for i = 1, level, 1 do
            generatePed(position, 120.0, armed_peds[math.random(#armed_peds)], function(ped)
                GiveWeaponToPed(ped, "WEAPON_ASSAULTSMG", 100, false, true)
                SetPedIntoVehicle(ped, veh, i - 2)
                if cb_ped then
                    cb_ped(ped)
                end
            end)
        end
        if cb_veh then
            cb_veh(veh)
        end
    end)
end
function SpawnRandomVehicles(position, level, cb_ped, cb_veh)
    for i = 1, level, 1 do
        generateVehicle(position, 200.0, normal_vehicles[math.random(#normal_vehicles)], function(veh)
            for j = 1, 3 do
                generatePed(position, 200.0, all_peds[math.random(#all_peds)], function(ped)
                    GiveWeaponToPed(ped, "WEAPON_PISTOL", 100, false, true)
                    SetPedIntoVehicle(ped, veh, j - 2)
                    if cb_ped then
                        cb_ped(ped)
                    end
                end)
            end
            if cb_veh then
                cb_veh(veh)
            end
        end)
    end
end
function SpawnRandomArmedVehicles(position, level, cb_ped, cb_veh)
    for i = 1, level, 1 do
        generateVehicle(position, 200.0, armed_vehicles[math.random(#armed_vehicles)], function(veh)
            for j = -1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
                generatePed(position, 200.0, armed_peds[math.random(#armed_peds)], function(ped)
                    GiveWeaponToPed(ped, "WEAPON_ASSAULTSMG", 100, false, true)
                    SetPedIntoVehicle(ped, veh, j)
                    if cb_ped then
                        cb_ped(ped)
                    end
                end)
            end
            if cb_veh then
                cb_veh(veh)
            end
        end)
    end
end
function SpawnRandomHelicopters(position, level, cb_ped, cb_veh)
    generateHelicopter(position, 250.0, heli_vehicles[math.random(#heli_vehicles)], function(veh)
        for j = -1, 3 do
            generatePed(position, 40.0, armed_peds[math.random(#armed_peds)], function(ped)
                GiveWeaponToPed(ped, "WEAPON_ASSAULTSMG", 100, false, true)
                SetPedIntoVehicle(ped, veh, j)
                if cb_ped then
                    cb_ped(ped)
                end
            end)
        end
        if cb_veh then
            cb_veh(veh)
        end
    end)
end
