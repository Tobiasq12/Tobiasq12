local NODES_TO_SHOW = 70
local NODE_OFFSET = 20
local TRAIN_LENGTH = 5

local X = 0.45
local W = 0.50
local Y = 0.85
local H = 0.15

local nx = W / NODES_TO_SHOW
local nw = nx

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

local isTrainHudDisabled = false

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
Citizen.CreateThread(function()
    isTrainHudDisabled, r = getActualKvp("isTrainHudDisabled")
end)

RegisterNetEvent("omni_conductor:toggleTrainHud")
AddEventHandler("omni_conductor:toggleTrainHud", function()
    isTrainHudDisabled = not isTrainHudDisabled
    setActualKvp("isTrainHudDisabled", isTrainHudDisabled)
end)

local TRACK = TRACK_DATA_15
local STATIONS = TRACK_STATIONS_15
local BRIDGES = TRACK_BRIDGES_15
local TUNNELS = TRACK_TUNNELS_15
local CROSSINGS = TRACK_CROSSINGS_15

AddEventHandler("omni_conductor:setTrainType", function(currentTrainType, type, currentTrain, trackType)
    if trackType == "TRACK_MAIN" then
        NODES_TO_SHOW = 200
        NODE_OFFSET = 50
        TRAIN_LENGTH = currentTrain.cars * 3
        TRACK = TRACK_DATA_1
        STATIONS = TRACK_STATIONS_1
        BRIDGES = TRACK_BRIDGES_1
        TUNNELS = TRACK_TUNNELS_1
        CROSSINGS = TRACK_CROSSINGS_1
    elseif trackType == "TRACK_METRO" then
        NODES_TO_SHOW = 150
        NODE_OFFSET = 35
        TRAIN_LENGTH = currentTrain.cars * 2
        TRACK = TRACK_DATA_4
        STATIONS = TRACK_STATIONS_4
        BRIDGES = TRACK_BRIDGES_4
        TUNNELS = TRACK_TUNNELS_4
        CROSSINGS = TRACK_CROSSINGS_4
    elseif trackType == "TRACK_LIBERTY" then
        NODES_TO_SHOW = 70
        NODE_OFFSET = 20
        TRAIN_LENGTH = currentTrain.cars * 1
        TRACK = TRACK_DATA_15
        STATIONS = TRACK_STATIONS_15
        BRIDGES = TRACK_BRIDGES_15
        TUNNELS = TRACK_TUNNELS_15
        CROSSINGS = TRACK_CROSSINGS_15
    end
    nx = W / NODES_TO_SHOW
    nw = nx
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedInAnyTrain(ped) then
            if not isTrainHudDisabled then
                local train = GetVehiclePedIsUsing(ped)
                if DoesEntityExist(train) then
                    local currentNode = GetTrainCurrentTrackNode(train)
                    local backNode = currentNode - TRAIN_LENGTH
                    local _caridx = 1
                    local _carriage = GetTrainCarriage(train, 1)
                    -- while DoesEntityExist(_carriage) do
                    --     backNode =  GetTrainCurrentTrackNode(_carriage)
                    --     _caridx = _caridx + 1
                    --     _carriage = GetTrainCarriage(train, _caridx)
                    -- end
                    local startNode = currentNode - NODE_OFFSET
                    local endNode = startNode + NODES_TO_SHOW
                    local offsetZ = nil
                    DrawRect(X + W / 2, Y, W, H, 50, 50, 50, 150)
                    for index = 4, NODES_TO_SHOW - 4 do
                        local node = (startNode + index) % #TRACK
                        local data = TRACK[node]
                        if data then
                            if not offsetZ then
                                offsetZ = data[2]
                            end
                            local x = X + nx * index
                            local y = Y + (offsetZ - data[2]) * 0.0005
                            DrawRect(x, y, nx, nx * 2, 255, 255, 255, 225)
                            local isBridge = false
                            for _, bridge in next, BRIDGES do
                                if node >= bridge[1] and node <= bridge[2] then
                                    isBridge = true
                                    break
                                end
                            end
                            local isTunnel = false
                            for _, tunnel in next, TUNNELS do
                                if node >= tunnel[1] and node <= tunnel[2] then
                                    isTunnel = true
                                    break
                                end
                            end
                            local isCrossing = false
                            for _, crossing in next, CROSSINGS do
                                if node == crossing then
                                    isCrossing = true
                                    break
                                end
                            end
                            if isBridge then
                                DrawRect(x, y + nx * 5, nx * 2.5, nx * 7, 25, 25, 25, 225)
                            end
                            if isTunnel then
                                DrawRect(x, y + nx * -5, nx * 2.5, nx * 7, 25, 25, 25, 225)
                            end
                            local station = STATIONS[node]
                            if station then
                                local yDiff = (Y - H / 4) - y
                                DrawRect(x - nx * 2, y + yDiff / 2, nx * 2, yDiff, 100, 100, 255, 175)
                                DrawScreenTextCenter(x - nx * 2, Y - H / 2, 0.0, 0.0, 0.5, station, 100, 100, 255, 225)
                            end
                            if node == currentNode then
                                DrawRect(x - nx * 2, y + nx * -2.5, nx * 2, nx * 3, 255, 0, 0, 225)
                            elseif node >= backNode and node < currentNode then
                                DrawRect(x - nx * 2, y + nx * -2.5, nx * 2, nx * 3, 150, 150, 150, 225)
                            end
                            if isCrossing then
                                local r,g,b = 255, 0, 0
                                local _, _, _, _, _, sec = GetLocalTime()
                                if sec % 2 == 0 then
                                    r,g,b = 25, 25, 25
                                end
                                DrawRect(x, y + nx * -2, nx, nx * -6, 150, 150, 150, 175)
                                DrawRect(x + nx, y + nx * -6, nx * 2, nx * -3, r, g, b, 175)
                                if sec % 2 == 0 then
                                    r,g,b = 255, 0, 0
                                else
                                    r,g,b = 25, 25, 25
                                end
                                DrawRect(x - nx, y + nx * -6, nx * 2, nx * -3, r, g, b, 175)
                            end
                        end
                    end
                end
            end
        end
        Wait(0)
    end
end)
