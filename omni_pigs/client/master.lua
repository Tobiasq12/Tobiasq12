Citizen.CreateThread(function()
    local current_job = {}
    local party = {
        members = 1,
        ready = 0,
        limit = 0,
        data = {

        }
    }
    local tracked_peds = {}
    local tracked_vehicles = {}
    local active = false
    local STATE = "IDLE"
    local hud_data = {}
    local _hud_data = {}
    local _master_ready = false

    local job_starts = {
        -- { name = "Mission Brief", x = 1004.7577514648, y = -3150.9008789063, z = -39.507123565674},
        { name = "Mission Brief", x = 977.88208007813, y = -95.16414642334, z = 74.868125915527, h = 308.4482421875},
    }

    local function trackPed(ped)
        log("TRACKING PED")
        table.insert(tracked_peds, ped)
    end
    local function trackVeh(veh)
        log("TRACKING VEH")
        table.insert(tracked_vehicles, veh)
    end

    RegisterNetEvent("omni_pigs:master:party")
    AddEventHandler("omni_pigs:master:party", function(data)
        party.members = #data.slaves + 1
        local ready = 0
        for _, slave in next, data.slaves do
            if slave.ready then
                ready = ready + 1
            end
        end
        if data.master.ready then
            ready = ready + 1
        end
        party.ready = ready
        party.people = {}
        table.insert(party.people, data.master)
        for _, slave in next, data.slaves do
            table.insert(party.people, slave)
        end
        party.difficulty = math.min(1 + math.floor(party.members / 2.5), 5)
    end)

    RegisterNetEvent("omni_pigs:master:initialize")
    AddEventHandler("omni_pigs:master:initialize", function(limits)
        -- Set you as the master
        TriggerEvent("omni:vrp:enable_area_checks", false)
        log("Initialized")
        active = true
        STATE = "GET_PARTY"
        party.limit = limits.size + 1
    end)

    function ClearEntities()
        for _, ent in next, tracked_peds do
            SetEntityAsNoLongerNeeded(ent)
            DeleteEntity(ent)
        end
        tracked_peds = {}
        for _, ent in next, tracked_vehicles do
            SetEntityAsNoLongerNeeded(ent)
            -- DeleteEntity(ent)
        end
        tracked_vehicles = {}
    end

    function isOnJob()
        return active
    end

    RegisterNetEvent("omni_pigs:stop_job")
    AddEventHandler("omni_pigs:stop_job", function()
        if active then
            log("Stopping job")
            StopJob(false)
        end
    end)

    RegisterNetEvent("omni_pigs:reset")
    AddEventHandler("omni_pigs:reset", function()
        if active then
            log("Resetting job")
            StopJob(true)
        end
    end)

    AddEventHandler("omni:stop_job", function()
        if active then
            if STATE == "GET_PARTY" then
                TriggerServerEvent("omni_pigs:server:leave", true)
            else
                TriggerServerEvent("omni_pigs:server:master:reset")
            end
        end
    end)

    function StopJob(_active)
        TriggerEvent("omni:vrp:enable_area_checks", not _active)
        RemoveBlips()
        ClearEntities()
        active = _active
        log("Set active to " .. tostring(_active))
        STATE = "GET_PARTY"
    end

    function RemoveBlips()
        for _, start in next, job_starts do
            if start.blip then
                RemoveBlip(start.blip)
                start.blip = nil
            end
        end
        local current = current_job.location
        if current then
            for k, loc in next, current do
                if k == "blip" then
                    RemoveBlip(loc)
                    loc = nil
                end
                if type(loc) == 'table' then
                    for _, spot in next, loc do
                        if spot.blip then
                            RemoveBlip(spot.blip)
                            spot.blip = nil
                        end
                    end
                end
            end
        end
    end

    function SpawnEnemies(position, level)
        if level > 4 then
            SpawnRandomArmedVehicles(position, 3, trackPed, trackVeh)
            SpawnRandomHelicopters(position, 1, trackPed, trackVeh)
        end
        if level > 3 then
            SpawnRandomHelicopters(position, 1, trackPed, trackVeh)
            SpawnRandomArmedVehicles(position, 1, trackPed, trackVeh)
        end
        if level > 2 then
            SpawnRandomPeds(position, 3, trackPed, trackVeh)
            SpawnRandomArmedVehicles(position, 1, trackPed, trackVeh)
        end
        if level > 1 then
            SpawnRandomVehicles(position, 2, trackPed, trackVeh)
        end
        if level > 0 then
            SpawnRandomSecurity(position, 2, trackPed, trackVeh)
        end
    end

    function UpdateHUD()
        -- Update the status text based on current state & datas
        log("Updating HUD: " .. tostring(active))
        local text = {}
        if STATE == "HEIST_SETUP" then
            local loc_diff = "[~r~" .. string.rep("|", current_job.location.level) .. "~w~" .. string.rep("|", 5 - current_job.location.level) .. "]"
            local rnd_prog = "[~g~" .. string.rep("|", current_job.storesRobbed) .. "~w~" .. string.rep("|", current_job.storesToRob - current_job.storesRobbed) .. "]"
            table.insert(text, "" .. current_job.location.name .. " " .. loc_diff .. " " .. rnd_prog)
            table.insert(text, "~y~Enter the building and get into position")
            if party.ready < party.members / 2 then
                table.insert(text, "Ready: ~r~" .. party.ready .. " / " .. party.members)
            else
                if party.ready == party.members then
                    table.insert(text, "Ready: ~g~" .. party.ready .. " / " .. party.members)
                else
                    table.insert(text, "Ready: " .. party.ready .. " / " .. party.members)
                end
            end
        elseif STATE == "HEIST_DEFENSE" then
            table.insert(text, "" .. current_job.location.name)
            table.insert(text, "~y~Maintain and defend your position!")
        elseif STATE == "HEIST_ESCAPE" then
            table.insert(text, "" .. current_job.location.name)
            table.insert(text, "~y~Escape from or eliminate the security!")
            table.insert(text, "Security remaining: " .. #tracked_peds)
        elseif STATE == "HEIST_ROUND_COMPLETE" then
            table.insert(text, "~y~Heist run complete! Get back to HQ!")
        elseif STATE == "HEIST_COMPLETE" then
            table.insert(text, "" .. current_job.location.name)
            table.insert(text, "~y~Successfully completed the heist!")
        elseif STATE == "IDLE" then
            table.insert(text, "~y~The job is in an invalid IDLE state, please re-make the party.")
        elseif STATE == "GET_PARTY" then
            table.insert(text, "~y~Waiting for party leader to start...")
            table.insert(text, "Party leader: " .. GetPlayerName(PlayerId()))
            local loc_diff = "[~r~" .. string.rep("|", party.difficulty) .. "~w~" .. string.rep("|", 5 - party.difficulty) .. "]"
            table.insert(text, "Party members: " .. party.members .. "/" .. party.limit .. " " .. loc_diff)
        elseif STATE == "HEIST_START" then
            table.insert(text, "~y~Gathering heist information...")
        else
            text = nil
        end
        if text then
            for key, val in next, hud_data do
                table.insert(text, key .. ": " .. val)
            end
            exports["omni_common"]:SetStatus("Heist (Party Leader)", text)
            TriggerServerEvent("omni_pigs:server:master:updateHUD", text)
        end
        _hud_data = {}
        for key, val in next, hud_data do
            _hud_data[key] = val
        end
    end

    function StartJob(location, level)
        RemoveBlips()
        SetPedRelationshipGroupHash(GetPlayerPed(-1), `PIGS_EMPLOYEE`)
        current_job.storesToRob = math.random(3,6)
        current_job.storesRobbed = 0
        current_job.level = level
        current_job.kills = 0
        current_job.take = 0
        current_job.history = {}
        current_job.location = location
        current_job.total_take = 0
        hud_data = {}
        HeistStart()
    end

    function SetLocation(location)
        RemoveBlips()
        current_job.location = location
    end

    function isLocationInHistory(name)
        if current_job.history then
            for _, loc in next, current_job.history do
                if loc.name == name then
                    return true
                end
            end
        end
        return false
    end

    -- Get a random location that's either the set level or level - 1
    function GetRandomLocation(level, first)
        local location = nil
        local _loop = 0
        local _dist_bonus = 0
        while not location and _loop < 1250 do
            _loop = _loop + 1
            local loc = HEIST_LOCATIONS[math.random(#HEIST_LOCATIONS)]
            if loc.level <= level and loc.level >= level - 1 then
                if not isLocationInHistory(loc.name) then
                    local dist = #(vector3(loc.x, loc.y, loc.z) - vector3(current_job.location.x, current_job.location.y, current_job.location.z))
                    if dist < (((level + 1) * 1500) + _dist_bonus) or first then
                        log("Dist: " .. dist .. " (bonus: " .. _dist_bonus .. ")")
                        location = loc
                        break
                    else
                        log("Location unavailable, increasing distance bonus by 150...")
                        _dist_bonus = _dist_bonus + 150
                    end
                end
            end
        end
        if location == nil then
            log("There are no available locations to go to???????")
            return location
        end
        table.insert(current_job.history, location)
        return location
    end

    function HeistStart()
        current_job.storesRobbed = current_job.storesRobbed + 1
        if current_job.storesRobbed > current_job.storesToRob then
            HeistRoundComplete()
        else
            local location = GetRandomLocation(current_job.level, (current_job.storesRobbed == 1))
            if location then
                _master_ready = false
                -- Calculate the take for the next location
                local _money_value = math.random(2700, 3600) -- Value per "take"
                local _difficulty_party_modifier = (location.level + party.members - 1) -- Amount of takes (including the scale modifier)
                local _scale_modifier = 1.5 -- Power of the party modifier

                -- 900 - 1200, modifier 1.8: https://puu.sh/C6k9j.png
                -- 900 - 1200, modifier 1.5: https://puu.sh/C6GaU.png

                current_job.take = _money_value * (_difficulty_party_modifier ^ _scale_modifier)
                STATE = "HEIST_START"
                SetLocation(location)
                TriggerServerEvent("omni_pigs:server:master:nextLocation", location)
                HeistSetup()
            else
                HeistRoundComplete()
            end
        end
    end

    function HeistRoundComplete()
        STATE = "HEIST_ROUND_COMPLETE"
        TriggerServerEvent("omni_pigs:server:master:heistRoundComplete", current_job.kills)
        UpdateHUD()
        Wait(10000)
        STATE = "GET_PARTY"
        hud_data = {}
        UpdateHUD()
    end

    function HeistSetup()
        STATE = "HEIST_SETUP"
        TriggerServerEvent("omni_pigs:server:master:startSetup")
        UpdateHUD()
    end

    function HeistDefense()
        STATE = "HEIST_DEFENSE"
        _heist_take = true
        TriggerServerEvent("omni_pigs:server:master:startDefense", current_job.level)
        UpdateHUD()
        SpawnEnemies(current_job.location, current_job.level)
        StayStillInPlace(current_job.location, 5.0, 30 + ((current_job.level - 1) * 10), function()
            HeistDefenseComplete()
        end, function(time, reason)
            HeistDefenseFailed(reason)
        end)
    end

    function HeistDefenseComplete()
        STATE = "HEIST_DEFENSE_COMPLETE"
        TriggerServerEvent("omni_pigs:server:master:defenseSuccess")
        Wait(2500)
        if STATE == "HEIST_DEFENSE_COMPLETE" then
            HeistEscape()
        end
    end

    function HeistDefenseFailed(reason)
        STATE = "HEIST_DEFENSE_FAILED"
        _heist_take = false
        TriggerServerEvent("omni_pigs:server:master:defenseFailed", reason)
        Wait(2500)
        if STATE == "HEIST_DEFENSE_FAILED" then
            HeistEscape()
        end
    end

    function HeistEscape()
        STATE = "HEIST_ESCAPE"
        TriggerServerEvent("omni_pigs:server:master:startEscape")
        UpdateHUD()
    end

    function HeistEscapeComplete()
        STATE = "HEIST_ESCAPE_COMPLETE"
        if _heist_take then
            current_job.total_take = math.floor(current_job.total_take + current_job.take)
        else
            current_job.total_take = math.floor(current_job.total_take + (current_job.take / 2))
        end
        hud_data["Total Take"] = "~g~$" .. ReadableNumber(current_job.total_take, 2)
        TriggerServerEvent("omni_pigs:server:master:escapeComplete")
        UpdateHUD()
        HeistComplete()
    end

    function HeistComplete()
        STATE = "HEIST_COMPLETE"
        ClearEntities()
        if _heist_take then
            TriggerServerEvent("omni_pigs:server:master:heistComplete", current_job.take, _heist_take, current_job.kills)
        else
            TriggerServerEvent("omni_pigs:server:master:heistComplete", current_job.take / 2, _heist_take, current_job.kills)
        end
        UpdateHUD()
        Wait(10000)
        if STATE == "HEIST_COMPLETE" then
            HeistStart()
        end
    end

    -- Main loop
    Citizen.CreateThread(function()
        while true do
            Wait(0)
            if active then
                if STATE == "HEIST_SETUP" then
                    -- Get to the heist location and get ready
                    for _, location in next, current_job.location.positions do
                        if not location.blip then
                            local blip = AddBlipForCoord(location.x, location.y, location.z)
                            setBlipName(blip, "Heist Target")
                            SetBlipRoute(blip, true)
                            location.blip = blip
                        end
                        drawMarker(location.x, location.y, location.z)
                        if nearMarker(location.x, location.y, location.z) then
                            if _master_ready then
                                if party.ready < party.members / 2 then
                                    drawText("~r~You can not start the heist until at least half of the party is ready")
                                else
                                    drawText("Press ~g~E ~w~to ~r~start the heist ~w~when ~g~everybody ~w~is ready")
                                    if isEPressed() then
                                        SetLocation(location)
                                        HeistDefense()
                                        break
                                    end
                                end
                            else
                                drawText("Press ~g~E ~w~to ready up at ~y~" .. location.title)
                                if isEPressed() then
                                    TriggerServerEvent("omni_pigs:server:master:ready")
                                    _master_ready = true
                                    break
                                end
                            end
                        end
                    end
                elseif STATE == "HEIST_DEFENSE" then
                    -- Sit tight and defend your location
                    -- This is also tracked by the StayStillInPlace function
                elseif STATE == "HEIST_ESCAPE" then
                    -- Kill and/or escape the enemies
                    local peds_left = #tracked_peds
                    if peds_left == 0 then
                        HeistEscapeComplete()
                    end
                elseif STATE == "HEIST_DEFENSE_COMPLETE" then
                    -- Mid-state after completing defense phase
                elseif STATE == "HEIST_DEFENSE_FAILED" then
                    -- Mid-state after failing defense phase
                elseif STATE == "HEIST_ESCAPE_COMPLETE" then
                    -- Heist escape was completed
                elseif STATE == "HEIST_COMPLETE" then
                    -- YEET YOUR SUCCESSED
                elseif STATE == "IDLE" then
                    -- Default state should never actually run here
                elseif STATE == "GET_PARTY" then
                    -- Waiting for party
                    for _, start in next, job_starts do
                        if not start.blip then
                            local blip = AddBlipForCoord(start.x, start.y, start.z)
                            setBlipName(blip, "Mission Brief")
                            start.blip = blip
                        end
                        drawMarker(start.x, start.y, start.z)
                        if nearMarker(start.x, start.y, start.z) then
                            drawText("Press ~g~E ~w~to start a new Heist Round ~y~(Difficulty Level " .. party.difficulty .. ")")
                            if isEPressed() then
                                StartJob(start, party.difficulty)
                                break
                            end
                        end
                    end
                elseif STATE == "HEIST_START" then
                    -- Heist is being started...
                end
                local ply = GetPlayerPed(-1)
                local plyPos = GetEntityCoords(ply, false)
                for i, ped in next, tracked_peds do
                    if ped ~= nil then
                        if not DoesEntityExist(ped) then
                            table.remove(tracked_peds, i)
                        elseif IsPedDeadOrDying(ped, 0) then
                            SetEntityAsNoLongerNeeded(ped)
                            current_job.kills = (current_job.kills or 0) + 1
                            hud_data["Enemies Killed"] = current_job.kills
                            table.remove(tracked_peds, i)
                        else
                            local pedPos = GetEntityCoords(ped)
                            local dist = #(plyPos - pedPos)
                            if dist > 600.0 then
                                DeletePed(ped)
                                table.remove(tracked_peds, i)
                            end
                        end
                    end
                end
                -- Update HUD if HUD data has changed
                for key, val in next, hud_data do
                    if val ~= _hud_data[key] then
                        UpdateHUD()
                        break
                    end
                end
            end
        end
    end)
    Citizen.CreateThread(function()
        while true do
            if active then
                UpdateHUD()
            end
            Wait(2500)
        end
    end)

end)
