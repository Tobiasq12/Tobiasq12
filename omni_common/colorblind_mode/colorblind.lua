local COLORBLIND_REPLACEMENTS = {
    6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
}
local COLORBLIND_ENABLED = false
local COLORS = {}

function SetColorblindMode(bool, notify)
    if bool then
        for _, index in next, COLORBLIND_REPLACEMENTS do
            SetHudColour(index, 240, 240, 240, 255)
        end
        COLORBLIND_ENABLED = true
        if notify then TriggerEvent("gd_utils:notify", "Colorblind mode ~g~ENABLED") end
    else
        for _, index in next, COLORBLIND_REPLACEMENTS do
            SetHudColour(index, COLORS[index][1], COLORS[index][2], COLORS[index][3], COLORS[index][4])
        end
        COLORBLIND_ENABLED = false
        if notify then TriggerEvent("gd_utils:notify", "Colorblind mode ~r~DISABLED") end
    end
    setActualKvp("COLORBLIND_ENABLED", COLORBLIND_ENABLED)
end

function ToggleColorblindMode()
    SetColorblindMode(not IsInColorblindMode(), true)
end

RegisterCommand("colorblind", function()
    ToggleColorblindMode()
end)

RegisterNetEvent("omni:colorblind:toggle")
AddEventHandler("omni:colorblind:toggle", function()
    ToggleColorblindMode()
end)

function IsInColorblindMode()
    return COLORBLIND_ENABLED
end

Citizen.CreateThread(function()
    for _, index in next, COLORBLIND_REPLACEMENTS do
        local r,g,b,a = GetHudColour(index)
        COLORS[index] = {r,g,b,a}
    end

    SetColorblindMode(getActualKvp("COLORBLIND_ENABLED"), false)
end)
