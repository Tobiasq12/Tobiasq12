local DECOR = {
    FLOAT = 1,
    BOOL = 2,
    INT = 3,
    UNK = 4,
    TIME = 5,
}

local DECORATORS = {

    -- Custom Plate handling
    ["omni_custom_plate"] = DECOR.BOOL,
    ["omni_plate_hash"] = DECOR.INT,

    -- User Data
    ["omni_user_id"] = DECOR.INT,

    -- Fuel Control
    ["omni_fuel_value"] = DECOR.FLOAT,
    ["omni_fuel_disabled"] = DECOR.BOOL,

    -- Generic Vehicle Decorators
    ["omni_delete_upon_exit"] = DECOR.BOOL,
    ["omni_speed_boost"] = DECOR.FLOAT,
    ["omni_spawn_time"] = DECOR.TIME,
    ["omni_last_use"] = DECOR.TIME,
    ["omni_owner_id"] = DECOR.INT,
    ["omni_owner_cid"] = DECOR.INT,
    ["omni_admin_spawned"] = DECOR.BOOL,
    ["omni_script_spawned"] = DECOR.BOOL,
    ["omni_voucher_spawned"] = DECOR.BOOL,

    ["mass"] = DECOR.FLOAT,

    -- Vehicle Restrictions
    ["omni_admin_only"] = DECOR.BOOL,
    ["omni_no_seatbelt"] = DECOR.BOOL,
    ["omni_no_racing"] = DECOR.BOOL,

    -- Special Vehicle Properties
    ["omni_ignore_locker"] = DECOR.BOOL,
    ["omni_can_delete"] = DECOR.BOOL,
    ["omni_norepmod"] = DECOR.BOOL,
    ["omni_nocleanup"] = DECOR.BOOL,

    -- Emergency Siren Control
    ["esc_siren_enabled"] = DECOR.BOOL,

    -- Player Blip
    ["omni_blip_sprite"] = DECOR.INT,
    ["omni_blip_hidden"] = DECOR.BOOL,
}

for k,v in next, DECORATORS do
    DecorRegister(k, v)
    -- print("Registered Decorator " .. k .. " (" .. v .. ")")
end

local decorFunctions = {
    [DECOR.FLOAT] = function(propertyName, entity, fn)
        local val = DecorGetFloat(entity, propertyName)
        fn(val)
    end,
    [DECOR.BOOL] = function(propertyName, entity, fn)
        local val = DecorGetBool(entity, propertyName)
        fn(val)
    end,
    [DECOR.INT] = function(propertyName, entity, fn)
        local val = DecorGetInt(entity, propertyName)
        fn(val)
    end,
    [DECOR.UNK] = function(propertyName, entity, fn)
        local val = DecorGetInt(entity, propertyName)
        fn(val)
    end,
    [DECOR.TIME] = function(propertyName, entity, fn)
        local val = DecorGetInt(entity, propertyName)
        fn(val)
    end,
}

local decorSetFunctions = {
    [DECOR.FLOAT] = function(propertyName, entity, val)
        DecorSetFloat(entity, propertyName, val)
    end,
    [DECOR.BOOL] = function(propertyName, entity, val)
        DecorSetBool(entity, propertyName, val)
    end,
    [DECOR.INT] = function(propertyName, entity, val)
        DecorSetInt(entity, propertyName, val)
    end,
    [DECOR.UNK] = function(propertyName, entity, val)
        DecorSetInt(entity, propertyName, val)
    end,
    [DECOR.TIME] = function(propertyName, entity, val)
        DecorSetInt(entity, propertyName, val)
    end,
}

RegisterCommand("decorators", function()
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        for decorator, decorType in next, DECORATORS do
            if DecorExistOn(veh, decorator) then
                decorFunctions[decorType](decorator, veh, function(val)
                    print(decorator .. ": " .. tostring(val))
                end)
            end
        end
    end
end, false)

Citizen.CreateThread(function()
    while true do
        Wait(10000)
        local ped = PlayerPedId()
        DecorSetInt(ped, "omni_user_id", GetUserId())
    end
end)

RegisterNetEvent("omni:decorator:set:vehicle")
AddEventHandler("omni:decorator:set:vehicle", function(decorator, value)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local type = DECORATORS[decorator]
        if type then
            decorSetFunctions[type](decorator, veh, value)
        end
    end
end)

Citizen.CreateThread(function()
    -- while true do
    --     Wait(1250)
    --     if isDebuggingAdvanced() then
    --         local ped = GetPlayerPed(-1)
    --         if IsPedInAnyVehicle(ped, false) then
    --             local veh = GetVehiclePedIsIn(ped, false)
    --             for k,v in next, DECORATORS do
    --                 if DecorExistOn(veh, k) then
    --                     if v == DECOR.FLOAT then
    --                         print(k .. ": " .. tostring(DecorGetFloat(veh, k)))
    --                     elseif v == DECOR.BOOL then
    --                         print(k .. ": " .. tostring(DecorGetBool(veh, k)))
    --                     elseif v == DECOR.INT then
    --                         print(k .. ": " .. tostring(DecorGetInt(veh, k)))
    --                     else
    --
    --                     end
    --                 else
    --                     print(k .. ": (not set)")
    --                 end
    --             end
    --         end
    --     end
    -- end
end)
