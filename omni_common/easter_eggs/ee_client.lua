local CURRENT_EASTER_EGGS = {}
local EE_MODEL = `prop_power_cell`

Citizen.CreateThread(function()
    print("Loaded power cells")
    TriggerServerEvent("omni:easter_egg:requestLocations", "rrerr")
    -- LOCAL OPTIMIZATION
    local Wait = Wait
    local GetEntityCoords = GetEntityCoords
    local PlayerPedId = PlayerPedId
    local CreatePickupRotate = CreatePickupRotate
    local GetHashKey = GetHashKey
    local AddBlipForRadius = AddBlipForRadius
    local IsPedInAnyHeli = IsPedInAnyHeli
    local IsPedInAnyPlane = IsPedInAnyPlane
    local IsPedInModel = IsPedInModel
    local SetBlipAlpha = SetBlipAlpha
    local HasPickupBeenCollected = HasPickupBeenCollected
    local TriggerServerEvent = TriggerServerEvent
    -- END LOCAL OPTIMIZATION
    while true do
        Wait(100)
        local pos = GetEntityCoords(PlayerPedId(), false)
        for _, location in next, CURRENT_EASTER_EGGS do
            if not location.pickup and not location.collected and not location.initialized then
                if not HasModelLoaded(EE_MODEL) then
                    RequestModel(EE_MODEL)
                    while not HasModelLoaded(EE_MODEL) do
                        Wait(100)
                    end
                end
                location.pickup = CreatePickupRotate("pickup_custom_script", location.x, location.y, location.z, 0.0, 0.0, 0.0, 8, -1, 0, false, EE_MODEL)
                location.fakeLocation = vector3(location.x + math.random(-60.0, 60.0), location.y + math.random(-60.0, 60.0), 0.0)
                location.blip = AddBlipForRadius(location.fakeLocation, 100.0)
                -- AddBlipForPickup(location.pickup)
                -- AddBlipForCoord(location.fakeLocation)
                location.initialized = true
                location.collected = false
            end
            local dist = #(vector3(pos.x, pos.y, 0.0) - location.fakeLocation)
            local alphaMod = 1.0
            if IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) or IsPedInModel(PlayerPedId(), "DELUXO") then
                alphaMod = 0.0
            end
            SetBlipAlpha(location.blip, math.floor(math.max((150 - dist * 2) * alphaMod, 0.0)))
            if HasPickupBeenCollected(location.pickup) then
                -- Prevent remote pickup
                if #(vec3(location.x, location.y, location.z) - pos) < 25.0 then
                    TriggerServerEvent("omni:easter_egg:pickupLocation", {id = location.id})
                end
                location.pickup = nil
                location.collected = true
            end
        end
    end
end)
--[   citizen-scripting-lua        ]: EVENT CEventNetworkPlayerCollectedPickup: [16646185,0,738282662,0,-2059885722,0]
-- PICKUP ID, ?, PICKUP TYPE, Amount?, MODEL, Amount?

function CleanupEasterEggs()
    for _, location in next, CURRENT_EASTER_EGGS do
        if location.pickup and DoesPickupExist(location.pickup) then
            RemovePickup(location.pickup)
        end
        if location.blip then
            RemoveBlip(location.blip)
        end
    end
    CURRENT_EASTER_EGGS = {}
end

AddEventHandler("onResourceStop", function(name)
    if name == GetCurrentResourceName() then
        CleanupEasterEggs()
    end
end)

RegisterNetEvent("omni:easter_egg:receiveLocations")
AddEventHandler("omni:easter_egg:receiveLocations", function(list)
    CleanupEasterEggs()
    CURRENT_EASTER_EGGS = {}
    for _, item in next, list do
        table.insert(CURRENT_EASTER_EGGS, item)
    end
end)

local EASTER_EGG_WEAPONS = {
    {-34.453483581543,-1112.5699462891,26.422332763672,2508868239,"Bat",1},
    {213.80030822754,-808.83648681641,31.014888763428,2578778090,"Knife",1},
    {880.73449707031,-951.00091552734,39.218517303467,2460120199,"Dagger",1},
    {457.92831420898,-1001.0697631836,24.914875030518,3218215474,"SNS Pistol",150},
    {286.73358154297,-987.78137207031,33.110862731934,3231910285,"Special Rifle",300},
    {29.194568634033,-1340.2020263672,29.497022628784,1627465347,"Gusenberg",300},
    {480.84658813477,-1302.4848632813,29.250272750854,4192643659,"Broken Bottle",300},
    {-119.6558303833,-976.23822021484,306.32977294922,3342088282,"Marksman Rifle",300},
}

Citizen.CreateThread(function()
    local cooldown = 0
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped, false)
        if cooldown <= 0 then
            for _, wep in next, EASTER_EGG_WEAPONS do
                local dist = #(vector3(wep[1], wep[2], wep[3]) - pos)
                if dist <= 3.0 then
                    DrawScreenTextCenter(0.5, 0.8, 0, 0, 0.6, "Press ~g~E ~w~to receive a ~y~" .. wep[5], 255, 255, 255, 255)
                    if (IsControlJustReleased(1, 38)) then
    				    GiveWeaponToPed(ped, wep[4], wep[6], true, false)
                        TriggerEvent("gd_utils:message", "~y~EASTER EGG", wep[5] .. " received!")
                        cooldown = 1000
                    end
                end
            end
        else
            cooldown = cooldown - 1
        end
    end
end)
