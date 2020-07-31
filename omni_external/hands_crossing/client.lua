local WasIdleLastCheck = false
local WasPlayingAnim = false
local IdleTimer = 0
local handsCrossingDisabled = true

RegisterNetEvent("omni:hands_crossing:toggle")
AddEventHandler("omni:hands_crossing:toggle", function()
    handsCrossingDisabled = not handsCrossingDisabled
    setActualKvp("handsCrossingDisabled", handsCrossingDisabled)
    if handsCrossingDisabled then
        TriggerEvent("gd_utils:notify", "Hands-crossing idle animation: ~r~Disabled")
    else
        TriggerEvent("gd_utils:notify", "Hands-crossing idle animation: ~g~Enabled")
    end
end)

Citizen.CreateThread(function()
    RequestAnimDict("amb@world_human_hang_out_street@female_arms_crossed@base")
    RequestAnimDict("amb@world_human_hang_out_street@female_arms_crossed@exit")
    RequestAnimDict("amb@world_human_hang_out_street@female_arms_crossed@enter")
    RequestAnimDict("amb@world_human_hang_out_street@female_arms_crossed@idle_a")
    local GetPlayerPed = GetPlayerPed
    local IsPedOnFoot = IsPedOnFoot
    local GetEntitySpeed = GetEntitySpeed
    local TaskPlayAnim = TaskPlayAnim
    local Wait = Wait
    handsCrossingDisabled = getActualKvp("handsCrossingDisabled")
    while true do
        if not handsCrossingDisabled then
            local ped = GetPlayerPed(-1)
            local IsIdle = (IsPedOnFoot(ped) and GetEntitySpeed(ped) <= 0.01)
            if WasIdleLastCheck and IsIdle and IdleTimer > 10 then
                if not WasPlayingAnim then
                    WasPlayingAnim = true
                    TaskPlayAnim(ped, "amb@world_human_hang_out_street@female_arms_crossed@enter", "enter", 1.0, -1.0, -1, 48, 0, 0, 0, 0)
                    -- print("Arms crossing start")
                    Wait(2400)
                else
                    -- Playing anim
                    local anims = {"idle_a", "idle_b"}
                    TaskPlayAnim(ped, "amb@world_human_hang_out_street@female_arms_crossed@idle_a", anims[math.random(#anims)], 1.0, 0.1, -1, 48, 0, 0, 0, 0)
                    -- print("Arms crossing repeat")
                    Wait(10500)
                end
            else
                if IsIdle then
                    IdleTimer = IdleTimer + 1
                else
                    IdleTimer = 0
                end
                Wait(25000)
                -- print("Idle: " .. IdleTimer)
            end
            WasIdleLastCheck = IsIdle
        else
            Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    local Wait = Wait
    local GetPlayerPed = GetPlayerPed
    local IsPedOnFoot = IsPedOnFoot
    local GetEntitySpeed = GetEntitySpeed
    local TaskPlayAnim = TaskPlayAnim
    while true do
        if not handsCrossingDisabled then
            Wait(100)
            local ped = GetPlayerPed(-1)
            local IsIdle = (IsPedOnFoot(ped) and GetEntitySpeed(ped) <= 0.01)
            if WasPlayingAnim and not IsIdle then
                TaskPlayAnim(ped, "amb@world_human_hang_out_street@female_arms_crossed@exit", "exit", 1.0, -1.0, -1, 48, 0, 0, 0, 0)
                -- print("Arms crossing end")
                WasPlayingAnim = false
                IdleTimer = 0
            end
        else
            Wait(1000)
        end
    end
end)
