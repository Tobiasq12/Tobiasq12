local VARIATIONS = {
    TANKER = {
        name = "TANKER",
        extras = {
            false, true, false, false, false
        },
        back = {
            vector3(-4.5, 0.0, -1.25),
        },
        connection = {
            vector3(-3.65, -0.75, 0.0),
        },
        side = {
            vector3(-1.0, 2.0, -1.25),
        },
    },
    BOX = {
        name = "BOX",
        extras = {
            true, false, false, false, false
        },
        back = {
            vector3(-4.5, 0.0, -1.25),
        },
    },
    BALES = {
        name = "BALES",
        extras = {
            false, false, true, false, false
        },
        side = {
            vector3(-1.0, 2.0, -1.25),
        },
    },
    FLATBED = {
        name = "FLATBED",
        extras = {
            false, false, false, true, false
        },
        back = {
            vector3(-4.5, 0.0, -1.25),
        },
        side = {
            vector3(-1.0, 2.0, -1.25),
        },
        bed = {
            vector3(-0.75, 0.0, -0.25),
        }
    },
    CRANE = {
        name = "CRANE",
        extras = {
            false, false, false, false, true
        },
        back = {
            vector3(-4.5, 0.0, -1.25),
        },
    },
    EMPTY = {
        name = "EMPTY",
        extras = {
            false, false, false, false, false
        },
    },
}

local VARIATION = VARIATIONS.BOX

function GetMuleVariation()
    return VARIATION.name
end

function GetMuleVariationData()
    return VARIATION
end

function RefitMule(variantName)
    if VARIATIONS[variantName] then
        DoScreenFadeOut(1000)
        while IsScreenFadingOut() do
            Wait(10)
        end
        VARIATION = VARIATIONS[variantName]
        AddTextEntry("MULE5", "Commercial Mule (" .. VARIATION.name .. ")")
        Wait(1000)
        DoScreenFadeIn(1000)
        while IsScreenFadingIn() do
            Wait(10)
        end
    else
        print("Mule refit " .. variantName .. " does not exist.")
    end
end

function DrawInteractiveMarker(vehicle, data, size, ground)
    if IsPedInVehicle(GetPlayerPed(-1), vehicle, false) then
        return 0.0, 0.0, 0.0, false
    end
    local fwdDir, rightDir, upDir, pos = GetEntityMatrix(vehicle)
    local x = pos.x + (fwdDir.x * data[1].x) + (rightDir.x * data[1].y) + (upDir.x * data[1].z)
    local y = pos.y + (fwdDir.y * data[1].x) + (rightDir.y * data[1].y) + (upDir.y * data[1].z)
    local z = pos.z + (fwdDir.z * data[1].x) + (rightDir.z * data[1].y) + (upDir.z * data[1].z)
    local b, gz = GetGroundZFor_3dCoord(x, y, z + 3.0, 0)
    -- DrawMarker(type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, red, green, blue, alpha, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts)
    local vis = #(vector3(x, y, z) - vector3(x, y, gz)) < 1.5
    if b and ground then
        z = gz
    end
    if vis then
        DrawMarker(20, x, y, z + 1.0, 0, 0, 0, 0, 0, 0, size, size, size, 255, 0, 0, 255, true, false, 0, true)
    end
    return x, y, z, vis
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, true)
        if IsVehicleModel(vehicle, "MULE5") then
            local fwdDir, rightDir, upDir, pos = GetEntityMatrix(vehicle)
            for extra_id, extra_bool in next, VARIATION.extras do
                if IsVehicleExtraTurnedOn(vehicle, extra_id) and not extra_bool or not IsVehicleExtraTurnedOn(vehicle, extra_id) and extra_bool then
                    print("SET EXTRA " .. extra_id .. ": " .. tostring(extra_bool))
                    SetVehicleExtra(vehicle, extra_id, not extra_bool)
                end
            end
            if exports['omni_common']:isDebugging() then
                for location, data in next, VARIATION do
                    if location ~= "extras" and location ~= "name" then
                        DrawInteractiveMarker(vehicle, data, 1.0, true)
                    end
                end
            end
        end
        Wait(1)
    end
end)

RegisterNetEvent("e621:pos:client")
AddEventHandler("e621:pos:client", function(name)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    local zoneName = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
    local heading = GetEntityHeading(GetPlayerPed(-1))
    local str, cross = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local areaName = GetStreetNameFromHashKey(str)
    if name == nil then
        name = zoneName .. " - " .. areaName
    end
    print("Saving pos " .. name)
    TriggerServerEvent("e621:pos:server", {x=pos.x,y=pos.y,z=pos.z,h=heading}, name)
end)
