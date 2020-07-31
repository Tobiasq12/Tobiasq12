local MARKETPLACES = {
    {
        name = "Grand Exchange Marketplace",
        pos = {x = -606.76605224609, y = -127.77203369141, z = 39.008575439453, h = 150.62190246582},
    }
}

local blip_data = {
    id = 133,
    color = 5,
}

function SetBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

function DrawText3D(text, x, y, z, s)
    exports['omni_common']:DrawText3D(text, x, y, z, s)
end

RegisterNetEvent("omni_marketplace:add_marketplace")
AddEventHandler("omni_marketplace:add_marketplace", function(data)
    table.insert(MARKETPLACES, {
        name = data.name,
        pos = {x = data.x, y = data.y, z = data.z, h = 0.0},
    })
end)

RegisterNetEvent("omni_marketplace:openMenu")
AddEventHandler("omni_marketplace:openMenu", function()
    TriggerServerEvent("omni_marketplace:openMenu")
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        for _, location in next, MARKETPLACES do
            if not location.cooldown then location.cooldown = 0 end
            if location.cooldown > 0 then location.cooldown = location.cooldown - 1 end
            if location.cooldown <= 0 then
                local coords = location.pos
                if not location.blip then
                    location.blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                    SetBlipAsShortRange(location.blip, true)
                    SetBlipSprite(location.blip, blip_data.id)
                    SetBlipColour(location.blip, blip_data.color)
                    SetBlipScale(location.blip, 1.0)
                    SetBlipName(location.blip, "Marketplace")
                end
                local dist = #(vector3(pos.x, pos.y, pos.z) - vector3(coords.x, coords.y, coords.z))
                if dist < 30.0 then
                    DrawText3D("~y~" .. location.name, coords.x, coords.y, coords.z + 1.5, 1.5)
                    DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0, 0, 0, 0, 0, 0, 16.0, 16.0, 1.0, 255, 255, 255, 20)
                    if dist < 8.0 then
                        if not location.was_in then
                            location.was_in = true
                            TriggerEvent("gd_utils:notify", "Press E to access the marketplace")
                        end
                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent("omni_marketplace:openMenu", true)
                            -- location.cooldown = 120
                        end
                    else
                        location.was_in = false
                    end
                else
                    location.was_in = false
                end
            end
        end
    end
end)
