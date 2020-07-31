local isAdmingeEnabled = false
RegisterNetEvent("omni:adminge:toggle")
AddEventHandler("omni:adminge:toggle", function()
    if isAdmingeEnabled then
        isAdmingeEnabled = false
        SetPedRelationshipGroupHash(PlayerPedId(), `PLAYER`)
        TriggerEvent("gd_utils:notify", "Adminge Disabled")
    else
        isAdmingeEnabled = true
        SetPedRelationshipGroupHash(PlayerPedId(), `SERVER_ADMIN`)
        TriggerEvent("gd_utils:notify", "Adminge Enabled")
    end
end)
