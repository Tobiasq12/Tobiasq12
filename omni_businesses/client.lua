local DAILY_BONUSES = {}
local COLLECTIONS = {}

RegisterNetEvent("omni_biz:daily:add")
AddEventHandler("omni_biz:daily:add", function(bizId, specialData, num, name, limit)
    dailyBonusRemove(bizId)
    if specialData then
        DAILY_BONUSES[bizId] = {}
        DAILY_BONUSES[bizId].num = num
        DAILY_BONUSES[bizId].x = specialData.x
        DAILY_BONUSES[bizId].y = specialData.y
        DAILY_BONUSES[bizId].z = specialData.z
        DAILY_BONUSES[bizId].name = name
        DAILY_BONUSES[bizId].id = bizId
        DAILY_BONUSES[bizId].limit = limit
    end
end)

RegisterNetEvent("omni_biz:add_collection")
AddEventHandler("omni_biz:add_collection", function(specialData, isFaction)
    table.insert(COLLECTIONS, {name = specialData.name, x = specialData.x, y = specialData.y, z = specialData.z, faction = isFaction})
end)

RegisterNetEvent("omni_biz:daily:remove")
AddEventHandler("omni_biz:daily:remove", function(bizName)
    dailyBonusRemove(bizName)
end)

RegisterNetEvent("omni_biz:is_bank_owned")
AddEventHandler("omni_biz:is_bank_owned", function(BankOwned)
    isBankOwned = BankOwned
end)

RegisterNetEvent("omni_biz:roman_numeral_toggle")
AddEventHandler("omni_biz:roman_numeral_toggle", function()
    wantsRomanNumeral = GetResourceKvpInt("omni_biz:toggle_roman_numeral") or 3
    if wantsRomanNumeral == 3 then
        SetResourceKvpInt("omni_biz:toggle_roman_numeral", 2)
        TriggerEvent("gd_utils:notify", "~r~Toggle Off Roman Numerals")
    else
        SetResourceKvpInt("omni_biz:toggle_roman_numeral", 3)
        TriggerEvent("gd_utils:notify", "~g~Toggle On Roman Numerals")
    end
end)

RegisterNetEvent("omni_biz:roman_numeral_check")
AddEventHandler("omni_biz:roman_numeral_check", function()
    wantsRomanNumeral = GetResourceKvpInt("omni_biz:toggle_roman_numeral") or 3
    TriggerServerEvent("omni_biz:roman_numeral_set", wantsRomanNumeral)
end)


function dailyBonusRemove(bizName)
    if DAILY_BONUSES[bizName] then
        local biz = DAILY_BONUSES[bizName]
        if biz.blip then
            RemoveBlip(biz.blip)
        end
        DAILY_BONUSES[bizName] = nil
    end
end

Citizen.CreateThread(function()
    local common = exports['omni_common']
    -- Optimize lazy loader
    local GetPlayerPed = GetPlayerPed
    local GetEntityCoords = GetEntityCoords
    local AddBlipForCoord = AddBlipForCoord
    local SetBlipSprite = SetBlipSprite
    local SetBlipAsShortRange = SetBlipAsShortRange
    local SetBlipColour = SetBlipColour
    local SetBlipScale = SetBlipScale
    local DrawMarker = DrawMarker
    local IsControlJustPressed = IsControlJustPressed
    -- End optimize lazy loader
    while true do
        Wait(2)
        local playerPed = GetPlayerPed(-1)
        local playerPos = GetEntityCoords(playerPed)
        for bizName, biz in next, DAILY_BONUSES do
            if not biz.cooldown then biz.cooldown = 0 end
            if biz.cooldown > 0 then
                biz.cooldown = biz.cooldown - 1
            else
                local dist = #(vector3(biz.x, biz.y, biz.z) - playerPos)

                if not biz.blip then
                    biz.blip = AddBlipForCoord(biz.x, biz.y, biz.z)
                    SetBlipSprite(biz.blip, 434)
                    SetBlipAsShortRange(biz.blip, true)
                    if biz.num >= biz.limit then
                        SetBlipColour(biz.blip, 3)
                    else
                        SetBlipColour(biz.blip, 5)
                    end
                    SetBlipScale(biz.blip, 1.0)
                    common:SetBlipName(biz.blip, "Business Bonus")
                    exports['omni_blip_info']:SetBlipInfoTitle(biz.blip, biz.name , false)
                    exports['omni_blip_info']:AddBlipInfoText(biz.blip, "Bonus Stacks: ", biz.num .. " / " .. biz.limit)
                    exports['omni_blip_info']:SetBlipInfoImage(biz.blip, "biz_images", biz.id)
                end

                if dist < 50.0 then
                    DrawMarker(1, biz.x, biz.y, biz.z - 0.5, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 255, 255, 255, 100, false, true, 0, false)
                end
                if dist < 3.0 then
                    if biz.num > 1 then
                        common:DrawText3D("Press ~g~E ~w~to get your " .. biz.num .. " business bonuses", biz.x, biz.y, biz.z + 1)
                    else
                        common:DrawText3D("Press ~g~E ~w~to get your business bonus", biz.x, biz.y, biz.z + 1)
                    end
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("omni_biz:daily:deliver", bizName, false)
                        biz.cooldown = 200
                    end
                end
            end
        end
        for _, collection in next, COLLECTIONS do
            if not collection.cooldown then collection.cooldown = 0 end
            if collection.cooldown > 0 then
                collection.cooldown = collection.cooldown - 1
            else
                local dist = #(vector3(collection.x, collection.y, collection.z) - playerPos)
                local isFaction = collection.faction
                if not collection.blip then
                    collection.blip = AddBlipForCoord(collection.x, collection.y, collection.z)
                    SetBlipSprite(collection.blip, 434)
                    SetBlipAsShortRange(collection.blip, true)
                    SetBlipColour(collection.blip, 6)
                    SetBlipScale(collection.blip, 1.0)
                    common:SetBlipName(collection.blip, "Bonus Collector")
                end

                if dist < 50.0 then
                    DrawMarker(1, collection.x, collection.y, collection.z - 0.5, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 255, 255, 255, 100, false, true, 0, false)
                end
                if dist < 3.0 then

                    if not isFaction then
                        common:DrawText3D("Press ~g~E ~w~to collect all business bonuses (20% Tax)", collection.x, collection.y, collection.z + 1)
                    else
                        if not isBankOwned then
                            common:DrawText3D("Press ~g~E ~w~to collect all business bonuses (30% Tax)", collection.x, collection.y, collection.z + 1)
                        else
                            common:DrawText3D("Press ~g~E ~w~to collect all business bonuses (20% Tax)", collection.x, collection.y, collection.z + 1)
                        end
                    end
                    if IsControlJustPressed(0, 38) then
                        collection.cooldown = 200
                        if isBankOwned then
                            isFaction = false
                        end
                        TriggerServerEvent("omni_biz:daily:deliver:all", true, isFaction)
                    end
                end
            end
        end
    end
end)
