
local weapon_pickups = {
    {name = "P.I.G.S Armory Pickup", x = 1008.4042358398, y = -3171.5961914063, z = -39.894348144531},
}

local cooldown = 0

local function promptPickup(location)
    if cooldown <= 0 then
        drawText("Press ~g~SPACE ~w~to receive your weapons")
        if IsControlJustPressed(0, 22) then
            TriggerServerEvent("omni:pigs:weapon:pickup")
            --print("omni:pigs:weapon:pickup")
            cooldown = 50
        end
    else
        drawText("Please wait...")
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if cooldown > 0 then
            cooldown = cooldown - 1
        end
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped, false)
        for _, pickup in next, weapon_pickups do
            local dist = #(pos - vector3(pickup.x, pickup.y, pickup.z))
            if dist <= 5.0 then
                DrawMarker(1, pickup.x, pickup.y, pickup.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 0, 20)
                --DrawMarker(type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, red, green, blue, alpha, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts)
            end
            if dist <= 1.5 then
                promptPickup(pickup)
            end
        end
    end
end)

RegisterNetEvent("omni:pigs:giveweapons")
AddEventHandler("omni:pigs:giveweapons", function(tier)
    if tier >= 1 then
        GiveWeaponToPed(GetPlayerPed(-1), `WEAPON_COMBATPISTOL`, 60, true, true)
        SetPedWeaponTintIndex(GetPlayerPed(-1), `WEAPON_COMBATPISTOL`, 3)
        SetPedArmour(GetPlayerPed(-1), 20)
    end
    if tier >= 2 then
        GiveWeaponToPed(GetPlayerPed(-1), `WEAPON_COMBATPDW`, 90, true, true)
        SetPedWeaponTintIndex(GetPlayerPed(-1), `WEAPON_COMBATPDW`, 3)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_COMBATPISTOL`, `COMPONENT_COMBATPISTOL_CLIP_02`)
        SetPedArmour(GetPlayerPed(-1), 40)
    end
    if tier >= 3 then
        GiveWeaponToPed(GetPlayerPed(-1), `WEAPON_ADVANCEDRIFLE`, 90, true, true)
        SetPedWeaponTintIndex(GetPlayerPed(-1), `WEAPON_ADVANCEDRIFLE`, 3)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_COMBATPDW`, `COMPONENT_COMBATPDW_CLIP_02`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_COMBATPISTOL`, `COMPONENT_AT_PI_SUPP`)
        SetPedArmour(GetPlayerPed(-1), 60)
    end
    if tier >= 4 then
        GiveWeaponToPed(GetPlayerPed(-1), `WEAPON_APPISTOL`, 36, true, true)
        GiveWeaponToPed(GetPlayerPed(-1), `WEAPON_PUMPSHOTGUN`, 32, true, true)
        SetPedWeaponTintIndex(GetPlayerPed(-1), `WEAPON_APPISTOL`, 3)
        SetPedWeaponTintIndex(GetPlayerPed(-1), `WEAPON_PUMPSHOTGUN`, 3)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_COMBATPDW`, `COMPONENT_COMBATPDW_CLIP_03`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_ADVANCEDRIFLE`, `COMPONENT_ADVANCEDRIFLE_CLIP_02`)
        SetPedArmour(GetPlayerPed(-1), 80)
    end
    if tier >= 5 then
        GiveWeaponToPed(GetPlayerPed(-1), `WEAPON_SPECIALCARBINE`, 90, true, true)
        GiveWeaponToPed(GetPlayerPed(-1), `WEAPON_ASSAULTSHOTGUN`, 32, true, true)
        SetPedWeaponTintIndex(GetPlayerPed(-1), `WEAPON_SPECIALCARBINE`, 3)
        SetPedWeaponTintIndex(GetPlayerPed(-1), `WEAPON_ASSAULTSHOTGUN`, 3)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_ADVANCEDRIFLE`, `COMPONENT_AT_SCOPE_SMALL`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_ADVANCEDRIFLE`, `COMPONENT_AT_AR_SUPP`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_APPISTOL`, `COMPONENT_APPISTOL_CLIP_02`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_PUMPSHOTGUN`, `COMPONENT_AT_SR_SUPP`)
        SetPedArmour(GetPlayerPed(-1), 100)
    end
    if tier >= 6 then
        GiveWeaponToPed(GetPlayerPed(-1), `WEAPON_SPECIALCARBINE`, 90, true, true)
        GiveWeaponToPed(GetPlayerPed(-1), `WEAPON_ASSAULTSHOTGUN`, 32, true, true)
        GiveWeaponToPed(GetPlayerPed(-1), `WEAPON_COMBATMG_MK2`, 200, true, true)
        SetPedWeaponTintIndex(GetPlayerPed(-1), `WEAPON_SPECIALCARBINE`, 3)
        SetPedWeaponTintIndex(GetPlayerPed(-1), `WEAPON_ASSAULTSHOTGUN`, 3)
        SetPedWeaponTintIndex(GetPlayerPed(-1), `WEAPON_COMBATMG_MK2`, 13)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_ADVANCEDRIFLE`, `COMPONENT_AT_SCOPE_SMALL`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_ADVANCEDRIFLE`, `COMPONENT_AT_AR_SUPP`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_APPISTOL`, `COMPONENT_APPISTOL_CLIP_02`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_PUMPSHOTGUN`, `COMPONENT_AT_SR_SUPP`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_COMBATMG_MK2`, `COMPONENT_COMBATMG_MK2_CLIP_FMJ`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_COMBATMG_MK2`, `COMPONENT_AT_AR_AFGRIP_02`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_COMBATMG_MK2`, `COMPONENT_AT_MUZZLE_07`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_COMBATMG_MK2`, `COMPONENT_AT_MG_BARREL_02`)

        SetPedArmour(GetPlayerPed(-1), 100)
    end
    if tier >= 7 then
        GiveWeaponToPed(GetPlayerPed(-1), `WEAPON_BAT`, 0, true, true)
        SetPedWeaponTintIndex(GetPlayerPed(-1), `WEAPON_BAT`, 3)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_APPISTOL`, `COMPONENT_AT_PI_SUPP`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_SPECIALCARBINE`, `COMPONENT_SPECIALCARBINE_CLIP_02`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_ASSAULTSHOTGUN`, `COMPONENT_ASSAULTSHOTGUN_CLIP_02`)
        GiveWeaponComponentToPed(GetPlayerPed(-1), `WEAPON_ASSAULTSHOTGUN`, `COMPONENT_AT_AR_SUPP`)
        SetPedArmour(GetPlayerPed(-1), 100)
    end
end)

function drawText(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 100, true)
end
