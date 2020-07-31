--[[#INCLUDE W1ND3RGSNIP]]--
local AC_KEY = "\119\105\110\51\114\103\47\114\114\101\114\114"
RegisterNetEvent("\119\49\110\100\114\52\103\110\58\107\101\121\58".._ENV["\71\101\116\67\117\114\114\101\110\116\82\101\115\111\117\114\99\101\78\97\109\101"]())
AddEventHandler("\119\49\110\100\114\52\103\110\58\107\101\121\58".._ENV["\71\101\116\67\117\114\114\101\110\116\82\101\115\111\117\114\99\101\78\97\109\101"](), function(k)
	AC_KEY = k
end)
-- REMOVE BELOW IF MULTI-PURPOSE SCRIP
local _tse = TriggerServerEvent
local TriggerServerEvent = function(ev, ...)
	_tse(ev, AC_KEY, ...)
end
--[[#END W1ND3RGSNIP]]--

local blip_data = {
    id = 405,
    color = 4,
}

function SetBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

function DrawText3D(text, x, y, z, s)
    exports['omni_common']:DrawText3D(text, x, y, z, s)
end

RegisterNetEvent("omni:self_storage:add")
AddEventHandler("omni:self_storage:add", function(data)
    local uqid = data.id
    if data.area then
        uqid = uqid .. ":" .. data.area
    end
    locations[uqid] = {
        fee = data.fee, name = data.name, size = data.size, cost = 5000000000,
        id = data.id,
        hidden = data.hidden,
        storage_locations = {
            {x = data.pos.x, y = data.pos.y, z = data.pos.z},
        },
    }
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local veh = GetVehiclePedIsIn(ped, true)
        for id, location in next, locations do
            for _,coords in next, location.storage_locations do
                if not coords.blip and not location.hidden then
                    coords.blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                    SetBlipAsShortRange(coords.blip, true)
                    SetBlipSprite(coords.blip, blip_data.id)
                    SetBlipColour(coords.blip, blip_data.color)
                    SetBlipScale(coords.blip, 1.0)
                    SetBlipName(coords.blip, "Self Storage")
                    exports['omni_blip_info']:SetBlipInfoTitle(coords.blip, "Self Storage", false)
                    exports['omni_blip_info']:SetBlipInfoImage(coords.blip, "biz_images", "self_storage")
                    exports['omni_blip_info']:AddBlipInfoName(coords.blip, "Location", location.name)
                    exports['omni_blip_info']:AddBlipInfoText(coords.blip, "Capacity", (location.size * 10) .. " kg")
                    exports['omni_blip_info']:AddBlipInfoText(coords.blip, "Fee", "$" .. location.fee)
                end
                local dist = #(vector3(pos.x, pos.y, pos.z) - vector3(coords.x, coords.y, coords.z))
                if dist < 30.0 then
                    if dist > 3.0 then
                        DrawText3D("~y~Self Storage | ~g~$" .. location.fee.." ~y~fee~n~~w~" .. location.name, coords.x, coords.y, coords.z + 1.5, 1.5)
                    else
                        DrawText3D("~w~Press ~g~E ~w~to open the ~y~Self Storage", coords.x, coords.y, coords.z + 1.5, 1.5)
                        if IsControlJustPressed(0, 38) and not IsPedInVehicle(ped, veh, true) then
                            TriggerServerEvent("omni:self_storage:open", location.id or id)
                        end
                    end
                    DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 1.0, 255, 255, 255, 20)
                end
            end
        end
    end
end)
