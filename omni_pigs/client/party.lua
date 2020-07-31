local hasPerms = false
local signedIn = false

job_blip_settings = {
    start_blip = {id = 119, color = 48},
    pickup_blip = {id = 108, color = 48},
    destination_blip = {id = 538, color = 46},
    vehicle_blip = {id = 529, color = 48},
    marker = {r = 0, g = 150, b = 255, a = 200},
    marker_special = {r = 255, g = 255, b = 0, a = 200},
}

local hq_locations = {
    {name = "Sign-in Desk", x = 988.09918212891, y = -96.77367401123, z = 74.845558166504},
}

RegisterNetEvent("omni:pigs:updatePerms")
AddEventHandler("omni:pigs:updatePerms",
    function(isPIGS)
        updatePermission(isPIGS)
    end
)
function updatePermission(hasPermission)
    hasPerms = not not hasPermission
end

function signIn()
    signedIn = true
    TriggerEvent("chat:addChannel", "Heist")
end
AddEventHandler("omni_pigs:master:initialize", signIn)
AddEventHandler("omni_pigs:slave:initialize", signIn)
AddEventHandler("omni_pigs:stop_job", function()
    signedIn = false
    exports["omni_common"]:SetStatus("", "")
    TriggerEvent("chat:removeChannel", "Heist")
end)

Citizen.CreateThread(function()
    local permCheckTimer = 0
    while true do
        Citizen.Wait(1000)
        if(permCheckTimer > 0) then
            permCheckTimer = permCheckTimer - 1
        else
            permCheckTimer = 30
            TriggerServerEvent("omni:pigs:checkPermission")
            --TriggerEvent("gd_utils:notify","Updated Permissions.")
        end
    end
end)

function HasActiveJob()
    return hasPerms
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if HasActiveJob() then
            for _, location in next, hq_locations do
                if not location.blip then
                    local blip = AddBlipForCoord(location.x, location.y, location.z)
                    SetBlipSprite(blip, job_blip_settings.start_blip.id)
                    SetBlipColour(blip, job_blip_settings.start_blip.color)
                    setBlipName(blip, location.name)
                    SetBlipAsShortRange(blip, true)
                    location.blip = blip
                end
                if (location.cooldown or 0) <= 0 then
                    drawMarker(location.x, location.y, location.z)
                    if nearMarker(location.x, location.y, location.z) then
                        if signedIn then
                            drawText("Press ~g~E ~w~to ~r~opt out ~w~of the heist")
                            if isEPressed() then
                                location.cooldown = 1000
                                TriggerServerEvent("omni_pigs:server:leave", false)
                            end
                        else
                            drawText("Press ~g~E ~w~to ~g~sign in ~w~for a heist")
                            if isEPressed() then
                                location.cooldown = 1000
                                TriggerServerEvent("omni_pigs:sign_in")
                            end
                        end
                    end
                else
                    location.cooldown = (location.cooldown or 0) - 1
                end
            end
        end
    end
end)
