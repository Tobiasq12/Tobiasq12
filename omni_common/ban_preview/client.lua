local BANS_LOADED = false
local LOADED_BANS = {}

function ViewAllBans()
    if not BANS_LOADED then
        local data = json.decode(LoadResourceFile(GetCurrentResourceName(), "ban_preview/ban_list.json"))
        for _, player in next, data do
            local user_id = player.user_id
            local player_info = json.decode(player.dvalue)
            if player_info then
                if player_info.position then
                    local ban = {}
                    local pos = vector3(player_info.position.x, player_info.position.y, player_info.position.z)
                    local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
                    SetBlipSprite(blip, 163)
                    SetBlipAsShortRange(blip, true)
                    SetBlipColour(blip, 1)
                    ban.pos = pos
                    ban.blip = blip
                    ban.user_id = user_id
                    table.insert(LOADED_BANS, ban)
                end
            end
        end
        BANS_LOADED = true
    else
        for _, data in next, LOADED_BANS do
            RemoveBlip(data.blip)
        end
        LOADED_BANS = {}
        BANS_LOADED = false
    end
end

RegisterCommand("view_all_bans", function()
    ViewAllBans()
end, false)
