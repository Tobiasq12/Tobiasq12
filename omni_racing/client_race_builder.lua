local race_data = {
    name = "Untitled",
    type = "ground",
    class = "Land Vehicles",
    classes = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,17,18,19,20},
    method = "point",
    foot = false,
    cp_size = 8.0,
    cp_type = 0,
}


local function Message(text)
    TriggerEvent("chatMessage", "Race Builder", {255, 255, 0}, text)
end

local function GetMarkerType()
    if race_data.cp_type == 0 then
        return 1
    else
        return 6
    end
end

local function DrawCheckpoint(data, special)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    if Vdist(pos.x, pos.y, pos.z, data.x, data.y, data.z) < 100 then
        if special then
            DrawMarker(GetMarkerType(), data.x, data.y, data.z - 1.0, 0, 0, 0, 0, 0, 0, race_data.cp_size, race_data.cp_size, race_data.cp_size, 255, 0, 255, 200, false, true)
        else
            DrawMarker(GetMarkerType(), data.x, data.y, data.z - 1.0, 0, 0, 0, 0, 0, 0, race_data.cp_size, race_data.cp_size, race_data.cp_size, 255, 255, 255, 200, false, true)
        end
    end
end

local function CalculateRaceDistance()
    if not race_data.enabled then
        return 0
    end
    local total_dist = 0
    total_dist = #(vec3(race_data.start.x, race_data.start.y, race_data.start.z) - vec3(race_data.checkpoints[1].x, race_data.checkpoints[1].y, race_data.checkpoints[1].z))
    for k, cp in next, race_data.checkpoints do
        local cpnext = race_data.checkpoints[k+1]
        if not cpnext then
            cpnext = race_data.finish
        end
        total_dist = total_dist + #(vec3(cp.x, cp.y, cp.z) - vec3(cpnext.x, cpnext.y, cpnext.z))
    end
    return math.floor(total_dist + 0.5)
end

local function SetBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

local function BuildData(data, extra)
    if not data.blip then
        data.blip = AddBlipForCoord(data.x, data.y, data.z)
        if extra then
            if extra.color then
                SetBlipColour(data.blip, extra.color)
            end
            if extra.sprite then
                SetBlipSprite(data.blip, extra.sprite)
            end
            if extra.name then
                SetBlipName(data.blip, extra.name)
            end
        end
    end
    return true
end

local function ClearData(data)
    if data.blip then
        RemoveBlip(data.blip)
    end
    return true
end

local function GetPos()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local data = {
        x = pos.x,
        y = pos.y,
        z = pos.z,
        h = heading,
    }
    return data
end

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if race_data.enabled then
            if race_data.start then
                DrawCheckpoint(race_data.start, true)
            end
            for cp_index, cp_data in next, race_data.checkpoints do
                DrawCheckpoint(cp_data)
            end
            if race_data.finish then
                DrawCheckpoint(race_data.finish, true)
            end
        end
    end
end)

RegisterNetEvent("omni_racing:builder:askToPublish")
AddEventHandler("omni_racing:builder:askToPublish", function()
    if not race_data.enabled then
        Message("You're not currently creating a track.")
        return false
    end
    if not race_data.finish then
        Message("The track does not have a finish line.")
        return false
    end
    local btns = {
        {"SHARE", "omni_racing:builder:publish"},
        {"CANCEL", ""},
    }
    TriggerEvent("omni:prompt", "Publish Course", "You are about to publish " .. race_data.name .. ". Cost: $25'000'000", "Course must be verified before making it into the game. Continue?", btns)
end)

RegisterNetEvent("omni_racing:builder:publish")
AddEventHandler("omni_racing:builder:publish", function()
    if not race_data.enabled then
        Message("You're not currently creating a track.")
        return false
    end
    if not race_data.finish then
        Message("The track does not have a finish line.")
        return false
    end
    TriggerServerEvent("omni_racing:builder:receivePublishedTrack", race_data)
    Message("Saved and published " .. race_data.name .. "!")
end)

RegisterNetEvent("omni_racing:builder:stats")
AddEventHandler("omni_racing:builder:stats", function()
    if not race_data.enabled then
        Message("You're not currently creating a track.")
        return false
    end
    if true then
        local text = ""
        text = text .. "Track stats"
        text = text .. "\nTrack name: " .. race_data.name
        text = text .. "\nTrack length: " .. CalculateRaceDistance() .. "m"
        text = text .. "\nCheckpoints: " .. (#race_data.checkpoints)
        text = text .. "\nRace Type: " .. race_data.type .. " (" .. race_data.method .. ")"
        text = text .. "\nVehicle Class: " .. race_data.class
        text = text .. "\nCan be on foot: " .. tostring(race_data.foot)
        Message(text)
        return true
    end
end)

RegisterNetEvent("omni_racing:builder:start")
AddEventHandler("omni_racing:builder:start", function()
    if race_data.enabled then
        Message("Start already placed. Clear or finish track to place new start.")
        return false
    end
    if true then
        local cp_data = GetPos()
        BuildData(cp_data, {color = 2})
        race_data.start = cp_data
        race_data.enabled = true
        race_data.checkpoints = {}
        Message("Created start for new track.")
    end
end)

RegisterNetEvent("omni_racing:builder:cp")
AddEventHandler("omni_racing:builder:cp", function()
    if not race_data.enabled then
        Message("Start has not been placed. Place a start first.")
        return false
    end
    if true then
        local cp_data = GetPos()
        BuildData(cp_data)
        table.insert(race_data.checkpoints, cp_data)
        Message("Added checkpoint #" .. #race_data.checkpoints)
        return true
    end
end)

RegisterNetEvent("omni_racing:builder:finish")
AddEventHandler("omni_racing:builder:finish", function()
    if not race_data.enabled then
        Message("Start has not been placed. Place a start first.")
        return false
    end
    if race_data.finish then
        Message("You've already placed a finish line.")
        return false
    end
    if true then
        local cp_data = GetPos()
        BuildData(cp_data, {color = 2})
        race_data.finish = cp_data
        race_data.distance = CalculateRaceDistance()
        race_data.method = "point"
        Message("Added finish line, marked track as POINT race")
        return true
    end
end)

RegisterNetEvent("omni_racing:builder:lap")
AddEventHandler("omni_racing:builder:lap", function()
    if not race_data.enabled then
        Message("Start has not been placed. Place a start first.")
        return false
    end
    if race_data.finish then
        Message("You've already placed a finish line.")
        return false
    end
    if true then
        local cp_data = {x = race_data.start.x, y = race_data.start.y, z = race_data.start.z, h = race_data.start.h}
        BuildData(cp_data, {color = 2})
        table.insert(race_data.finish, cp_data)
        race_data.method = "circuit"
        Message("Added circuit end, marked track as CIRCUIT race")
        return true
    end
end)

RegisterNetEvent("omni_racing:builder:type")
AddEventHandler("omni_racing:builder:type", function(type_name)
    if not race_data.enabled then
        Message("Start has not been placed. Place a start first.")
        return false
    end
    if true then
        race_data.type = type_name
        Message("Race type has been changed to: " .. string.upper(type_name))
        return true
    end
end)

RegisterNetEvent("omni_racing:builder:class")
AddEventHandler("omni_racing:builder:class", function(classes, className)
    race_data.classes = classes
    race_data.class = className
    Message("Vehicle class set to:  " .. className)
end)
RegisterNetEvent("omni_racing:builder:cp_size")
AddEventHandler("omni_racing:builder:cp_size", function(cp_size)
    race_data.cp_size = cp_size
    Message("Checkpoint size set to: " .. cp_size)
end)
RegisterNetEvent("omni_racing:builder:cp_type")
AddEventHandler("omni_racing:builder:cp_type", function(cp_type)
    race_data.cp_type = cp_type
    Message("Checkpoint type offset set to: " .. cp_type)
end)
RegisterNetEvent("omni_racing:builder:cp_onfoot")
AddEventHandler("omni_racing:builder:cp_onfoot", function(bool)
    race_data.foot = bool
    if bool then
        Message("Course can be done on foot")
    else
        Message("Course can not be done on foot")
    end
end)

RegisterNetEvent("omni_racing:builder:name")
AddEventHandler("omni_racing:builder:name", function(name)
    if true then
        race_data.name = name
        Message("Race name has been changed to: \"" .. name .. "\"")
        return true
    end
end)

RegisterNetEvent("omni_racing:builder:askToClear")
AddEventHandler("omni_racing:builder:askToClear", function()
    local btns = {
        {"RESTART", "omni_racing:builder:clear"},
        {"CANCEL", ""},
    }
    TriggerEvent("omni:prompt", "Clear Course Builder", "You are about to discard the current course.", "If you have not published the course, all progress will be lost. Continue?", btns)
end)

RegisterNetEvent("omni_racing:builder:clear")
AddEventHandler("omni_racing:builder:clear", function()
    while race_data.enabled do
        TriggerEvent("omni_racing:builder:undo")
    end
end)

RegisterNetEvent("omni_racing:builder:undo")
AddEventHandler("omni_racing:builder:undo", function()
    if not race_data.enabled then
        Message("You're not currently making a track.")
        return false
    end
    if race_data.finish then
        ClearData(race_data.finish)
        race_data.finish = nil
        Message("Removed finish line")
        return true
    end
    if #race_data.checkpoints < 1 then
        race_data.enabled = false
        ClearData(race_data.start)
        race_data.start = nil
        Message("Removed start, track creation aborted.")
        return true
    end
    if #race_data.checkpoints > 0 then
        Message("Removed checkpoint #" .. #race_data.checkpoints)
        local cp_data = race_data.checkpoints[#race_data.checkpoints]
        ClearData(cp_data)
        table.remove(race_data.checkpoints, #race_data.checkpoints)
        return true
    end
end)
