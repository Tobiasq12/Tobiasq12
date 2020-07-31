local CURRENT_AI_PED = nil
local cooldown = 0
local AI_PED_SET = 1
local AI_AGRESSION_SET = 1
local AI_PEDS = {
    {name = "Abigail", hash = 1074457665},
    {name = "Abner", hash = -257153498},
    {name = "ImpotentRage", hash = 880829941},
    {name = "TomEpsilon", hash = -847807830},
    {name = "LesterCrest", hash = 1302784073},

}

local AI_AGRESSION_SETS = {
    {name = "Normal", flag = 786603},
    {name = "Avoid Traffic", flag = 786468},
    {name = "Rushed", flag = 1074528293},
    {name = "Shortest Path (crazy)", flag = 262144},
    {name = "REVERSE!", flag = 788415},
    {name = "Offroad", flag = 787391},

}
local AI_PED_SET_LABELS = {}
local AI_AGRESSION_SET_LABELS = {}

for _, data in next, AI_PEDS do
    table.insert(AI_PED_SET_LABELS, data.name)
end

for _, data in next,  AI_AGRESSION_SETS do
    table.insert(AI_AGRESSION_SET_LABELS, data.name)
end

RegisterNetEvent("omni:driver_menu_check")
AddEventHandler("omni:driver_menu_check", function()
    TriggerServerEvent("omni:try_driver_menu_check")
    -- print("driver menu check")
end)

RegisterNetEvent("omni:spawn_driver")
AddEventHandler("omni:spawn_driver", function()
	local ped = GetPlayerPed(-1) -- current ped
    TriggerEvent("gd_utils:notify", "Driver Spawned")
    while not HasModelLoaded(CURRENT_AI_PED_HASH) do
        Wait(10)
        RequestModel(CURRENT_AI_PED_HASH)
    end
    CURRENT_AI_PED = CreatePed(4, CURRENT_AI_PED_HASH, GetEntityCoords(ped), 0.0, true, false)
    cooldown = 120
    AddBlipForEntity(CURRENT_AI_PED)
    CURRENT_AI_PED_BLIP = GetBlipFromEntity(CURRENT_AI_PED)
    SetBlipSprite(CURRENT_AI_PED_BLIP, 280)
    SetBlipAsFriendly(CURRENT_AI_PED_BLIP, 1)
    SetBlipColour(CURRENT_AI_PED_BLIP, 5)
    exports['omni_common']:SetBlipName(CURRENT_AI_PED_BLIP, "Personal Driver")
    SetEntityInvincible(CURRENT_AI_PED, true)
end)

RegisterNetEvent("driver:location:waypoint")
AddEventHandler("driver:location:waypoint", function()
    local ped = GetPlayerPed(-1)
	local vehicle_model = nil
    if(IsPedInAnyVehicle(ped))then
        vehicle_model = GetVehiclePedIsIn(ped, false)
    end

    if(not IsWaypointActive())then
        TriggerEvent("gd_utils:notify", "~r~No Waypoint found.~w~")
        return
    end

    local waypointBlip = GetFirstBlipInfoId(8) -- 8 = Waypoint ID
    local x, y, z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector()))

    TaskVehicleDriveToCoordLongrange(CURRENT_AI_PED, vehicle_model, x, y, z, 27.0, CURRENT_AI_PED_FLAG, 0.0)
    TriggerEvent("gd_utils:notify", "~p~Driving to waypoint.")
end)

RegisterNetEvent("driver:enter_vehicle")
AddEventHandler("driver:enter_vehicle", function()
	local ped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if CURRENT_AI_PED ~= nil then
	    TaskWarpPedIntoVehicle(ped, vehicle, 2)
        Wait(500)
	    TriggerEvent("gd_utils:notify", "Driver entering vehicle.")
	    TaskEnterVehicle(CURRENT_AI_PED, vehicle, 10, - 1, 1.0, 1, 0)
    end
end)

RegisterNetEvent("driver:vehicle:roam") -- add type as well
AddEventHandler("driver:vehicle:roam", function()
	local get_ped = GetPlayerPed(-1) -- current ped
	local vehicle_model = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	if CURRENT_AI_PED ~= nil then
	    TaskVehicleDriveWander(CURRENT_AI_PED, vehicle_model, 60.0, CURRENT_AI_PED_FLAG)
	    TriggerEvent("gd_utils:notify", "Driver is now roaming.")
	end
end)

Citizen.CreateThread(function()
    WarMenu.CreateMenu('DriverMenu', 'AI Driver Menu')
    WarMenu.CreateSubMenu('PedSettings', 'DriverMenu', "Ped Settings")
    WarMenu.CreateSubMenu('PedCommands', 'DriverMenu', "Ped Commands")

    RegisterNetEvent("omni:driver_menu:open")
    AddEventHandler("omni:driver_menu:open", function()
        WarMenu.OpenMenu("DriverMenu")
    end)

    while true do
        local ped = PlayerPedId()
        if WarMenu.IsAnyMenuOpened() then
            if WarMenu.IsMenuOpened('DriverMenu') then
                if WarMenu.MenuButton("Ped Settings", "PedSettings")then
                elseif WarMenu.MenuButton("Ped Commands", "PedCommands") then
                end
                if WarMenu.Button("~r~Close") then
                    WarMenu.CloseMenu()
                end
                WarMenu.Display()

            elseif WarMenu.IsMenuOpened('PedSettings') then
                if WarMenu.ComboBox("Driver Select", AI_PED_SET_LABELS, AI_PED_SET, AI_PED_SET, function(c,_)
                    if c ~= AI_PED_SET then
                        AI_PED_SET = c
                    end
                    CURRENT_AI_PED_HASH = AI_PEDS[AI_PED_SET].hash
                end) then
                end
                if WarMenu.ComboBox("Driving Style Select", AI_AGRESSION_SET_LABELS, AI_AGRESSION_SET, AI_AGRESSION_SET, function(c,_)
                    if c ~= AI_AGRESSION_SET then
                        AI_AGRESSION_SET = c
                    end
                    CURRENT_AI_PED_FLAG = AI_AGRESSION_SETS[AI_AGRESSION_SET].flag
                    -- print("Agression: " .. CURRENT_AI_PED_FLAG)
                end) then
                end
                if WarMenu.Button("~g~Spawn Driver") then
                    if cooldown == 0 then
                        if CURRENT_AI_PED == nil then
                            TriggerEvent("omni:spawn_driver")
                        else
                            TriggerEvent("gd_utils:notify", "You can only have one ped out at a time, dismiss your old one.")
                        end
                    else
                        TriggerEvent("gd_utils:notify", ("You can spawn another driver in %i seconds"):format(cooldown))
                    end
                end
                if WarMenu.Button("~r~Dismiss Driver") then
                    DeleteEntity(CURRENT_AI_PED)
                    RemoveBlip(CURRENT_AI_PED_BLIP)
                    TriggerEvent("gd_utils:notify", "Driver Dismissed.")
                    CURRENT_AI_PED = nil
                    CURRENT_AI_PED_HASH = 0
                end
                if WarMenu.MenuButton("~y~Back", "DriverMenu") then
                end
                WarMenu.Display()

            elseif WarMenu.IsMenuOpened('PedCommands') then
                if WarMenu.Button("~g~Task Enter Vehicle~w~") then
                    TriggerEvent("driver:enter_vehicle")
                end
                if WarMenu.Button("~p~Task Goto Waypoint~w~") then
                    TriggerEvent("driver:location:waypoint")
                end
                if WarMenu.Button("Task Vehicle Roam") then
                    TriggerEvent("driver:vehicle:roam")
                end
                if WarMenu.Button("Task Stop Vehicle") then
                    TriggerEvent("gd_utils:notify", "Driver Stopping Vehicle.")
                    TaskVehicleDriveWander(CURRENT_AI_PED, GetVehiclePedIsIn(PlayerPedId()), 0.0, CURRENT_AI_PED_FLAG)
                end
                if WarMenu.MenuButton("~y~Back", "DriverMenu") then
                end
                WarMenu.Display()

            end
        end
        Wait(0)
    end
end)

RemoveWeaponFromPed(PlayerPedId(), `weapon_specialcarbine_mk2`)
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if cooldown > 0 then
            cooldown = cooldown - 1
        end
    end
end)
