--====================================================================================
-- ATC script made by GlitchDetector for Transport Tycoon
-- Original Menu Script Author: Jonathan D @ Gannon
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv

--====================================================================================

--====================================================================================
--  EMS Menu
--====================================================================================



function Enter_Veh()
TriggerEvent("omni_medic:vehicle")
end
function Exit_Veh()
TriggerEvent("omni_medic:vehicle:exit")
end
function Dropoff()
TriggerEvent("omni_medic:hospital:deliver")
end




--====================================================================================
--  Build Menu
--====================================================================================
Menu = {}
Menu.item = {
   ['Title'] = 'Medical Menu',
        ['Items'] = {
        {['Title'] = 'EMS', ['SubMenu'] = {
            ['Title'] = 'EMS',
            ['Items'] = {
                { ['Title'] = '~r~Enter Vehicle ~w~', ['Function'] = Enter_Veh},
                { ['Title'] = '~y~Exit/Follow Vehicle ~w~', ['Function'] = Exit_Veh},
                { ['Title'] = '~y~Dropoff Patient ~w~', ['Function'] = Dropoff},

            }
        }},

       --[[ {['Title'] = 'Emotes List 1', ['SubMenu'] = {
            ['Title'] = 'Animations',
            ['Items'] = {
                { ['Title'] = '~g~Sitting', ['Function'] = EmoteCheck_Sitting},
                { ['Title'] = '~g~Seat', ['Function'] = EmoteCheck_Seat},
                { ['Title'] = '~g~Sunbathe', ['Function'] = EmoteCheck_Sunbathe},
                { ['Title'] = '~g~Guitar', ['Function'] = EmoteCheck_Guitar},
                { ['Title'] = '~g~Greet', ['Function'] = EmoteCheck_Greet},
                { ['Title'] = '~g~Yoga', ['Function'] = EmoteCheck_Yoga},


              }
        }},]]

        --[[{['Title'] = '~y~Misc ATC', ['SubMenu'] = {
            ['Title'] = 'Misc ATC',
            ['Items'] = {
                --{ ['Title'] = 'Broadcast Location', ['Function'] = sendLocation},
                { ['Title'] = '~y~Emergency Landing', ['Function'] = emergencyLanding},
                { ['Title'] = '~r~Mayday', ['Function'] = mayday},
            }
        }},]]

    }
}
--====================================================================================
--  Option Menu
--====================================================================================
Menu.backgroundColor = { 52, 73, 94, 196 }
Menu.backgroundColorActive = { 22, 160, 134, 255 }
Menu.tileTextColor = { 22, 160, 134, 255 }
Menu.tileBackgroundColor = { 255,255,255, 255 }
Menu.textColor = { 255,255,255,255 }
Menu.textColorActive = { 255,255,255, 255 }

Menu.keyOpenMenu = 157 -- 1
Menu.keyUp = 172 -- PhoneUp
Menu.keyDown = 173 -- PhoneDown
Menu.keyLeft = 174 -- PhoneLeft || Not use next release Maybe
Menu.keyRight =	175 -- PhoneRigth || Not use next release Maybe
Menu.keySelect = 176 -- PhoneSelect
Menu.KeyCancel = 177 -- PhoneCancel

Menu.posX = 1 - 0.3
Menu.posY = 1 - 0.7

Menu.ItemWidth = 0.20
Menu.ItemHeight = 0.03

Menu.isOpen = false   -- /!\ Ne pas toucher
Menu.currentPos = {1} -- /!\ Ne pas toucher

--====================================================================================
--  Menu System
--====================================================================================

function Menu.drawRect(posX, posY, width, heigh, color)
    DrawRect(posX + width / 2, posY + heigh / 2, width, heigh, color[1], color[2], color[3], color[4])
end

function Menu.initText(textColor, font, scale)
    font = font or 0
    scale = scale or 0.35
    SetTextFont(font)
    SetTextScale(0.0,scale)
    SetTextCentre(true)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(textColor[1], textColor[2], textColor[3], textColor[4])
    SetTextEntry("STRING")
end

function Menu.draw()
    -- Draw Rect
    local pos = 0
    local menu = Menu.getCurrentMenu()
    local selectValue = Menu.currentPos[#Menu.currentPos]
    local nbItem = #menu.Items
    -- draw background title & title
    Menu.drawRect(Menu.posX, Menu.posY , Menu.ItemWidth, Menu.ItemHeight * 2, Menu.tileBackgroundColor)
    Menu.initText(Menu.tileTextColor, 4, 0.7)
    AddTextComponentString(menu.Title)
    DrawText(Menu.posX + Menu.ItemWidth/2, Menu.posY)

    -- draw bakcground items
    Menu.drawRect(Menu.posX, Menu.posY + Menu.ItemHeight * 2, Menu.ItemWidth, Menu.ItemHeight + (nbItem-1)*Menu.ItemHeight, Menu.backgroundColor)
    -- draw all items
    for pos, value in pairs(menu.Items) do
        if pos == selectValue then
            Menu.drawRect(Menu.posX, Menu.posY + Menu.ItemHeight * (1+pos), Menu.ItemWidth, Menu.ItemHeight, Menu.backgroundColorActive)
            Menu.initText(Menu.textColorActive)
        else
            Menu.initText(Menu.textColor)
        end
        AddTextComponentString(value.Title)
        DrawText(Menu.posX + Menu.ItemWidth/2, Menu.posY + Menu.ItemHeight * (pos+1))
    end

end

function Menu.getCurrentMenu()
    local currentMenu = Menu.item
    for i=1, #Menu.currentPos - 1 do
        local val = Menu.currentPos[i]
        currentMenu = currentMenu.Items[val].SubMenu
    end
    return currentMenu
end

function Menu.initMenu()
    Menu.currentPos = {1}
end

function Menu.keyControl()
    if IsControlJustPressed(1, Menu.keyDown) then
        local cMenu = Menu.getCurrentMenu()
        local size = #cMenu.Items
        local slcp = #Menu.currentPos
        Menu.currentPos[slcp] = (Menu.currentPos[slcp] % size) + 1

    elseif IsControlJustPressed(1, Menu.keyUp) then
        local cMenu = Menu.getCurrentMenu()
        local size = #cMenu.Items
        local slcp = #Menu.currentPos
        Menu.currentPos[slcp] = ((Menu.currentPos[slcp] - 2 + size) % size) + 1

    elseif IsControlJustPressed(1, Menu.KeyCancel) then
        table.remove(Menu.currentPos)
        if #Menu.currentPos == 0 then
            Menu.isOpen = false
        end

    elseif IsControlJustPressed(1, Menu.keySelect)  then
        local cSelect = Menu.currentPos[#Menu.currentPos]
        local cMenu = Menu.getCurrentMenu()
        if cMenu.Items[cSelect].SubMenu ~= nil then
            Menu.currentPos[#Menu.currentPos + 1] = 1
        else
            if cMenu.Items[cSelect].Function ~= nil then
                cMenu.Items[cSelect].Function(cMenu.Items[cSelect])
            end
            if cMenu.Items[cSelect].Event ~= nil then
                TriggerEvent(cMenu.Items[cSelect].Event, cMenu.Items[cSelect])
            end
            if cMenu.Items[cSelect].Close == nil or cMenu.Items[cSelect].Close == true then
                Menu.isOpen = false
            end
        end
    end

end


--[[RegisterNetEvent("atc:open:menu")
AddEventHandler("atc:open:menu", function()
TriggerClientEvent("atc:open:menu")
while true do
		Citizen.Wait(1)

             Menu.initMenu()
             Menu.isOpen = not Menu.isOpen

            if Menu.isOpen then
                Menu.draw()
                Menu.keyControl()

        end
	end

end)]]

function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, false)
end
--Notify("~g~Press HOME to open pet access pet menu!")


RegisterNetEvent("medic:menu")
AddEventHandler("medic:menu", function()
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1)
        if IsControlJustPressed(1, 164) then -- 4
             Menu.initMenu()
             Menu.isOpen = not Menu.isOpen

         end
            if Menu.isOpen then
                Menu.draw()
                Menu.keyControl()

           end

	    end
    end)
end)
