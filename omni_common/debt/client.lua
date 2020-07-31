local DEBT = {
    debt = 0,
    money = 0,
    debts = 0,
    millionaires = 0,
    billionaires = 0,
    user_id = 0,
    players = 0,
}
local DEBT_LOCATIONS = {
    {x = 236.62799072266, y = 217.43190002441, z = 106.28673553467}
}

local USER_ID_LOCATIONS = {
    {x = 232.4554901123, y = -880.43334960938, z = 30.492107391357}
}

local USER_VOID_LEADER_BOARD = {
    {x = -523.07629394531, y = -241.9386138916, z = 36.078987121582}
}

Citizen.CreateThread(function()
    local Wait = Wait
    local GetEntityCoords = GetEntityCoords
    local GetPlayerPed = GetPlayerPed
    local DrawText3D = DrawText3D
    while true do
        Wait(0)
        local pedPos = GetEntityCoords(GetPlayerPed(-1))
        for k,v in next, DEBT_LOCATIONS do
            local dist = #(vector3(v.x, v.y, v.z) - pedPos)
            if dist <= 8.0 and dist > 1.0 then
                DrawText3D("~b~Transport Tycoon Economy Statistics", v.x, v.y, v.z + 1.65, 1.35)
                if DEBT.debts_diff then
                    DrawText3D("~y~Active Loans: ~w~" .. formatNumber(DEBT.debts, 0, "", "") .. " ~w~(" .. formatNumber(DEBT.debts_diff, 0, "~g~+", "~r~-") .. "~w~)", v.x, v.y, v.z + 1.25, 1.25)
                else
                    DrawText3D("~y~Active Loans: ~w~" .. formatNumber(DEBT.debts, 0, "", ""), v.x, v.y, v.z + 1.25, 1.25)
                end
                if DEBT.debt_diff then
                    DrawText3D("~y~Total Tycoon Debt: ~r~$" .. formatNumber(DEBT.debt, 0, "", "") .. " ~w~(" .. formatNumber(DEBT.debt_diff, 0, "~r~+", "~g~-") .. "~w~)", v.x, v.y, v.z + 1.0, 1.25)
                else
                    DrawText3D("~y~Total Tycoon Debt: ~r~$" .. formatNumber(DEBT.debt, 0, "", ""), v.x, v.y, v.z + 1.0, 1.25)
                end
                if DEBT.money_diff then
                    DrawText3D("~y~Total Economy Size: ~g~$" .. formatNumber(DEBT.money, 0, "", "") .. " ~w~(" .. formatNumber(DEBT.money_diff, 0, "~g~+", "~r~-") .. "~w~)", v.x, v.y, v.z + 0.75, 1.25)
                else
                    DrawText3D("~y~Total Economy Size: ~g~$" .. formatNumber(DEBT.money, 0, "", ""), v.x, v.y, v.z + 0.75, 1.25)
                end
                if DEBT.millionaires_diff then
                    DrawText3D("~y~Millionaires: ~w~" .. formatNumber(DEBT.millionaires, 0, "", "") .. " ~w~(" .. formatNumber(DEBT.millionaires_diff, 0, "~g~+", "~r~-") .. "~w~)", v.x, v.y, v.z + 0.50, 1.25)
                else
                    DrawText3D("~y~Millionaires: ~w~" .. formatNumber(DEBT.millionaires, 0, "", ""), v.x, v.y, v.z + 0.50, 1.25)
                end
                if DEBT.billionaires_diff then
                    DrawText3D("~y~Billionaires: ~w~" .. formatNumber(DEBT.billionaires, 0, "", "") .. " ~w~(" .. formatNumber(DEBT.billionaires_diff, 0, "~g~+", "~r~-") .. "~w~)", v.x, v.y, v.z + 0.25, 1.25)
                else
                    DrawText3D("~y~Billionaires: ~w~" .. formatNumber(DEBT.billionaires, 0, "", ""), v.x, v.y, v.z + 0.25, 1.25)
                end
            end
        end
        for k,v in next, USER_ID_LOCATIONS do
            local dist = #(vector3(v.x, v.y, v.z) - pedPos)
            if dist <= 14.0 and dist > 1.0 then
                DrawText3D("~b~Transport Tycoon Player Statistics", v.x, v.y, v.z + 1.65, 1.35)
                if DEBT.user_id_diff then
                    DrawText3D("~y~Total Users: ~w~" .. formatNumber(DEBT.user_id, 0, "", "") .. " ~w~(" .. formatNumber(DEBT.user_id_diff, 0, "~g~+", "~r~-") .. "~w~)", v.x, v.y, v.z + 1.25, 1.25)
                else
                    DrawText3D("~y~Total Users: ~w~" .. formatNumber(DEBT.user_id, 0, "", ""), v.x, v.y, v.z + 1.25, 1.25)
                end
                if DEBT.players_diff then
                    DrawText3D("~y~Online Players: ~w~" .. formatNumber(DEBT.players, 0, "", "") .. " ~w~(" .. formatNumber(DEBT.players_diff, 0, "~g~+", "~r~-") .. "~w~)", v.x, v.y, v.z + 1.0, 1.25)
                else
                    DrawText3D("~y~Online Players: ~w~" .. formatNumber(DEBT.players, 0, "", ""), v.x, v.y, v.z + 1.0, 1.25)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local Top10 = {
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
        {user_id = 0, username = "nobody", amount = 0},
    }
    local top10pos = vector3(244.54238891602, 211.20210266113, 108.28680419922)
    RegisterNetEvent("omni_void_leaderboard:updateBoard")
    AddEventHandler("omni_void_leaderboard:updateBoard", function(records)
        Top10 = records
    end)
    while true do
        Wait(1)
        local pos = GetEntityCoords(PlayerPedId())
        local dist = #(pos - top10pos)
        if dist < 15.0 then
            DrawText3D("~b~VoidBoard Highest Contributors", top10pos.x, top10pos.y, top10pos.z, 2.0)
            for n, entry in next, Top10 do
                DrawText3D(("~g~#%s~w~: ~y~%s ~w~by ~y~%s"):format(n, ReadableNumber(entry.amount, 2), entry.username), top10pos.x, top10pos.y, top10pos.z - n * 0.25 - 0.25, 1.25)
            end
        end
    end
end)

RegisterNetEvent("omni:debt:update")
AddEventHandler("omni:debt:update", function(debt)
    DEBT = debt
end)
