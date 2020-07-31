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

local BOX_JOB = {}

local function StartBoxJob(pickupData, dropoffData, pay_range)
    BOX_JOB.active = true
    BOX_JOB.pickups = pickupData
    BOX_JOB.dropoffs = dropoffData
    BOX_JOB.cargo = 0
    BOX_JOB.capacity = 50
    BOX_JOB.pay_range = pay_range
    BOX_JOB.blips = {}
    for _, data in next, BOX_JOB.pickups do
        data.blip = AddBlipForCoord(data.x, data.y, data.z)
        SetBlipColour(data.blip, 6)
        SetBlipScale(data.blip, 0.75)
    end
    for _, data in next, BOX_JOB.dropoffs do
        data.blip = AddBlipForCoord(data.x, data.y, data.z)
        ShowNumberOnBlip(data.blip, data.number)
    end
end

local function GetRandomBoxPickups()
    return BOX_PICKUPS
end

local function StartRandomBoxJob()
    local pickups = GetRandomBoxPickups()

    local dropoffs = {}
    for _, data in next, BOX_DELIVERIES.WAREHOUSES[3].stops do
        table.insert(dropoffs, data)
    end
    for _, dropoff in next, dropoffs do
        dropoff.number = math.random(1,3)
    end
    StartBoxJob(pickups, dropoffs, BOX_DELIVERIES.WAREHOUSES[3].pay_range)
end

local function AreAllDropoffsCompleted()
    for _, data in next, BOX_JOB.dropoffs do
        if data.number > 0 then
            return false, "A dropoff has yet to be completed"
        end
    end
    return true, "All dropoffs have been completed"
end

RegisterNetEvent("omni_mule:box:route:random")
AddEventHandler("omni_mule:box:route:random", function()
    StartRandomBoxJob()
end)
RegisterNetEvent("omni_mule:box:route:start")
AddEventHandler("omni_mule:box:route:start", function(route)
    local pickups = GetRandomBoxPickups()

    local dropoffs = {}
    for _, data in next, route.stops do
        table.insert(dropoffs, data)
    end
    for _, dropoff in next, dropoffs do
        dropoff.number = math.random(route.cargo_range[1], route.cargo_range[2])
    end
    StartBoxJob(pickups, dropoffs, route.pay_range)
end)

local function GenerateRouteList()
    TriggerServerEvent("omni_mule:box:openMenu")
end

local function IsOnBoxJob()
    return BOX_JOB.active ~= nil
end

local function GetBoxCargoCount()
    return BOX_JOB.cargo or 0
end

local function GetBoxCargoCapacity()
    return BOX_JOB.capacity or 0
end

local function Message(text, x, y, z, s)
    exports['omni_common']:DrawText3D(text, x, y, z, s or 1.0)
end

local BOX_MODEL = "prop_cardbordbox_03a"
-- local BOX_MODEL = "db_apart_01_"
local BOX_STATE = "IDLE"
local BOX_PROP = nil
local BOX_AMOUNT = 0
local BOX_CARRY_LIMIT = 10
local function GetBoxState()
    return BOX_STATE
end
local function SetBoxState(state)
    local dict = "anim@heists@load_box"
    local name = "idle"
    if state == "CARRY" then
        local _prev = BOX_STATE
        BOX_STATE = "CARRY"
        -- Give Box

        local inspeed = 8.0001
        local outspeed = -8.0001
        if not BOX_PROP then
            -- spawn boxx
            local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
            BOX_PROP = CreateObject(GetHashKey(BOX_MODEL), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
            while not DoesEntityExist(BOX_PROP) do
                Wait(0)
            end
        end
        TaskPlayAnim(GetPlayerPed(-1), dict, "lift_box", inspeed, outspeed, -1, 48, 0, 0, 0, 0)
        FreezeEntityPosition(GetPlayerPed(-1), true)
        Wait(1200)
        AttachEntityToEntity(BOX_PROP, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.095, 0.0, -0.25, 270.0, 170.0, 0.0, 1, 1, 0, 1, 0, 1)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        Wait(1800)
        if _prev ~= BOX_STATE then
            Citizen.CreateThread(function()
                while GetBoxState() == "CARRY" do
                    -- play anim
                    if HasAnimDictLoaded(dict) and not IsEntityPlayingAnim(GetPlayerPed(-1), dict, name, 3) then
                        TaskPlayAnim(GetPlayerPed(-1), dict, name, inspeed, outspeed, -1, 48, 0, 0, 0, 0)
                        -- print("anim")
                    end
                    Wait(0)
                    local boxPos = GetEntityCoords(BOX_PROP, false)
                    Message("Carrying~n~" .. BOX_AMOUNT .. "x Cargo", boxPos.x, boxPos.y, boxPos.z)
                    DisableControlAction(0, 23, true)
                end
            end)
        else
            return false, "Was already carrying box"
        end
        return true, "Now carrying a box"
    else
        BOX_STATE = "IDLE"
        -- Remove Box
        if IsEntityPlayingAnim(GetPlayerPed(-1), dict, name, 3) then
            local inspeed = 8.0001
            local outspeed = -8.0001
            TaskPlayAnim(GetPlayerPed(-1), dict, "load_box_2", inspeed, outspeed, -1, 48, 0, 0, 0, 0)
            FreezeEntityPosition(GetPlayerPed(-1), true)
            Wait(1800)
            FreezeEntityPosition(GetPlayerPed(-1), false)
            if BOX_PROP then
                DetachEntity(BOX_PROP, 1, 1)
                DeleteEntity(BOX_PROP)
                BOX_PROP = nil
            end
        end
        DisableControlAction(0, 23, false)
        return true, "No longer carrying box"
    end
end

local function StopBoxJob()
    if BOX_JOB.active then
        SetBoxState("IDLE")
        -- Remove blips
        for _, data in next, BOX_JOB.dropoffs do
            if data.blip then
                RemoveBlip(data.blip)
            end
        end
        for _, data in next, BOX_JOB.pickups do
            if data.blip then
                RemoveBlip(data.blip)
            end
        end
        for _, blip in next, BOX_JOB.blips do
            if blip then
                RemoveBlip(blip)
            end
        end

        -- Blank out job data
        BOX_JOB = {}
    end
end

AddEventHandler("omni:stop_job", function()
    StopBoxJob()
end)

local function ReceiveBoxCargo()
    BOX_AMOUNT = math.min(BOX_CARRY_LIMIT, BOX_AMOUNT + 10)
    SetBoxState("CARRY")
end

local function StoreBoxCargo()
    SetBoxState("IDLE")
end

local function DeliverBoxCargo(loc)
    local remove = math.min(loc.number, BOX_AMOUNT)
    loc.number = loc.number - remove
    if loc.number <= 0 then
        RemoveBlip(loc.blip)
    else
        ShowNumberOnBlip(loc.blip, loc.number)
    end
    if remove > 0 then
        TriggerServerEvent("omni_mule:box:deliver", BOX_JOB.pay_range, remove)
    end
    BOX_AMOUNT = BOX_AMOUNT - remove
    StoreBoxCargo()
    if BOX_AMOUNT > 0 then
        SetBoxState("CARRY")
    end
end

local function LoadBoxCargo()
    BOX_JOB.cargo = math.min(BOX_JOB.cargo + BOX_AMOUNT, GetBoxCargoCapacity())
    BOX_AMOUNT = 0
    SetBoxState("IDLE")
end

local function TakeBoxCargo()
    if BOX_JOB.cargo > 0 then
        BOX_AMOUNT = math.min(BOX_CARRY_LIMIT, BOX_AMOUNT + 1)
        BOX_JOB.cargo = math.max(BOX_JOB.cargo - 1, 0)
        SetBoxState("CARRY")
    end
end

Citizen.CreateThread(function()
    -- StartRandomBoxJob()
    local _timeout = 0
    _timeout = 0
    print("Loading anim..")
    RequestAnimDict("anim@heists@load_box")
    while not HasAnimDictLoaded("anim@heists@load_box") and _timeout < 1000 do -- max time, 10 seconds
        Wait(10)
        _timeout = _timeout + 1
    end
    print("Loaded anim")

    _timeout = 0
    RequestModel(BOX_MODEL)
    print("Loading box model..")
    while not HasModelLoaded(BOX_MODEL) and _timeout < 1000 do
        Wait(10)
        _timeout = _timeout + 1
    end
    print("Loaded box model")

    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped, false)
        local vehicle = GetVehiclePedIsIn(ped, false)
        if IsOnBoxJob() then
            if GetMuleVariation() == "BOX" then
                local job_vehicle = GetVehiclePedIsIn(ped, true)
                if IsVehicleModel(job_vehicle, "MULE5") then

                    -- PICKUP LOAD
                    for _, loc in next, BOX_JOB.pickups do
                        local dist = #(pos - vector3(loc.x, loc.y, loc.z))
                        if dist < 50.0 then
                            DrawMarker(1, loc.x, loc.y, loc.z - 1.0, 0, 0, 0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 255, 200)
                            if GetBoxState() == "CARRY" then
                                if dist < 2.0 then
                                    Message("Press E to store the cargo", loc.x, loc.y, loc.z + 1.0)
                                    if IsControlJustPressed(0, 38) then
                                        StoreBoxCargo()
                                    end
                                end
                            elseif GetBoxState() == "IDLE" then
                                if dist < 2.0 then
                                    Message("Press E to receive cargo", loc.x, loc.y, loc.z + 1.0)
                                    if IsControlJustPressed(0, 38) then
                                        ReceiveBoxCargo()
                                    end
                                end
                            end
                        end
                    end

                    -- DEAL WITH LOADING/UNLOADING OF TRUCK
                    local x, y, z, vis = DrawInteractiveMarker(job_vehicle, GetMuleVariationData().back, 1.5, true)
                    local dist = #(pos - vector3(x, y, z))
                    if vis then
                        if GetBoxState() == "CARRY" then
                            if dist < 2.0 then
                                if GetBoxCargoCount() < GetBoxCargoCapacity() then
                                    Message("Press E to load the cargo", x, y, z + 1.0)
                                    if IsControlJustPressed(0, 38) then
                                        LoadBoxCargo()
                                    elseif IsControlPressed(0, 38) then
                                        TakeBoxCargo()
                                    end
                                else
                                    Message("No more room", x, y, z + 1.0)
                                end
                            end
                        elseif GetBoxState() == "IDLE" then
                            if dist < 2.0 then
                                if GetBoxCargoCount() > 0 then
                                    Message("Press E to unload cargo", x, y, z + 1.0)
                                    Message("(Hold to unload multiple)", x, y, z + 0.75)
                                    if IsControlJustPressed(0, 38) then
                                        TakeBoxCargo()
                                    end
                                else
                                    Message("You do not have any cargo", x, y, z + 1.0)
                                end
                            end
                        end
                        if dist < 2.0 then
                            Message(("Cargo: %i/%i"):format(BOX_JOB.cargo, BOX_JOB.capacity), x, y, z + 1.5)
                        end
                    end
                    -- END TRUCK LOAD/UNLOAD

                    -- DELIVERY
                    for _, loc in next, BOX_JOB.dropoffs do
                        local dist = #(pos - vector3(loc.x, loc.y, loc.z))
                        if dist < 50.0 and loc.number > 0 then
                            DrawMarker(1, loc.x, loc.y, loc.z - 1.0, 0, 0, 0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 255, 200)
                            Message(("Cargo needed: %i"):format(loc.number), loc.x, loc.y, loc.z + 0.5, 2.0)
                            if dist < 2.0 then
                                if GetBoxState() == "CARRY" then
                                    Message("Press E to deliver the cargo", loc.x, loc.y, loc.z + 0.0)
                                    if IsControlJustPressed(0, 38) then
                                        DeliverBoxCargo(loc)
                                    end
                                end
                            end
                        end
                    end
                end
            else

            end

            if AreAllDropoffsCompleted() then
                TriggerServerEvent("omni_mule:box:complete", BOX_JOB.pay_range, #BOX_JOB.dropoffs)
                StopBoxJob()
            end
        else
            for _, loc in  next, BOX_STARTS do
                local dist = #(pos - vector3(loc.x, loc.y, loc.z))
                if dist < 50.0 then
                    DrawMarker(1, loc.x, loc.y, loc.z - 1.0, 0, 0, 0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 255, 200)
                end
                if dist < 2.0 then
                    if GetMuleVariation() == "BOX" then
                        Message("Press E to open the Route Selection Menu", loc.x, loc.y, loc.z + 1.0)
                        if IsControlJustPressed(0, 38) then
                            GenerateRouteList()
                        end
                    else
                        Message("You need a Mule that's refitted for Cargo", loc.x, loc.y, loc.z + 1.0)
                    end
                end
            end
        end
        if IsVehicleModel(vehicle, "MULE5") then
            for _, loc in  next, REFIT_LOCATIONS do
                if GetMuleVariation() ~= "BOX" then
                    local dist = #(pos - vector3(loc.x, loc.y, loc.z))
                    if dist < 50.0 then
                        Message("Refit Station", loc.x, loc.y, loc.z + 2.0, 3.0)
                        DrawMarker(1, loc.x, loc.y, loc.z - 1.0, 0, 0, 0, 0.0, 0.0, 0.0, 4.5, 4.5, 1.5, 255, 255, 255, 200)
                    end
                    if dist < 4.0 then
                        Message("Press E to refit mule for Cargo", loc.x, loc.y, loc.z + 1.0, 2.0)
                        if IsControlJustPressed(0, 38) then
                            RefitMule("BOX")
                        end
                    end
                end
            end
        end
        Wait(0)
    end
end)
