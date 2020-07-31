local TRAIN_SPAWNERS = {
	{menu = {x = 212.06787109375, y = -2439.0119628906, z = 8.4611597061157}, spawn = {x = 299.56259155273, y = -2615.05859375, z = 8.0455751419067}, type = "train", track = "TRACK_MAIN"},
	{menu = {x = -323.11764526367, y = 5962.0551757813, z = 41.922676086426}, spawn = {x = -438.00308227539, y = 5674.34375, z = 64.229995727539}, type = "train", track = "TRACK_MAIN"},

	{menu = {x = 677.66552734375, y = -897.95886230469, z = 23.462064743042}, spawn = {x = 672.33288574219, y = -834.36987304688, z = 23.282960891724}, type = "train", track = "TRACK_MAIN"},

	{menu = {x = 563.56274414063, y = -1984.7172851563, z = 17.775205612183}, spawn = {x = 560.263671875, y = -1980.0190429688, z = 17.775247573853}, type = "metro", track = "TRACK_METRO"},
	{menu = {x = -1105.1019287109, y = -2743.7258300781, z = -7.4101314544678}, spawn = {x = -1130.5665283203, y = -2847.6564941406, z = -8.1714544296265}, type = "metro", track = "TRACK_METRO"},

	{menu = {x = -2309.8640136719, y = 6714.4184570313, z = 23.924310684204}, spawn = {x = -2305.5729980469, y = 6774.7387695313, z = 22.79932975769}, type = "liberty", track = "TRACK_LIBERTY"},
}

Citizen.CreateThread(function()
	local currentTrainCategory = nil
	local currentTrainType = nil
	local currentTrain = nil
	local currentTrainVariation = 1
	local spawnPos = nil
	local currentAvailableType = "train"

	WarMenu.CreateMenu('TrainMenu', 'Train Menu')
	WarMenu.CreateSubMenu('TrainCategorySelection', 'TrainMenu', 'Train Type')
	WarMenu.CreateSubMenu('TrainTypeSelection', 'TrainCategorySelection', 'Train Selection')
	WarMenu.CreateSubMenu('TrainSpawnSelection', 'TrainTypeSelection', 'Variation Selection')
	WarMenu.CreateSubMenu('TrainSpawnOptions', 'TrainSpawnSelection', 'Train Options')

	WarMenu.CreateSubMenu('TrainDeletionPrompt', 'TrainMenu', 'Delete Train?')

	WarMenu.CreateSubMenu('TrainBuySelection', 'TrainMenu', 'Purchase Train')

	-- RegisterCommand("_dtt", function()
	-- 	spawnPos = {x = 299.56259155273, y = -2615.05859375, z = 8.0455751419067}
	-- 	metro = false
	-- 	WarMenu.OpenMenu('TrainMenu')
	-- end, true)
	-- RegisterCommand("_dtm", function()
	-- 	spawnPos = {x = 560.263671875, y = -1980.0190429688, z = 17.775247573853}
	-- 	metro = true
	-- 	WarMenu.OpenMenu('TrainMenu')
	-- end, true)

	while true do
		if WarMenu.IsMenuOpened('TrainMenu') then
			if WarMenu.MenuButton("Spawn Train", "TrainCategorySelection") then
			elseif WarMenu.MenuButton("Purchase Train", "TrainBuySelection") then
			elseif WarMenu.Button("~r~Close") then
				WarMenu.CloseMenu()
			end
			currentTrainCategory = nil
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('TrainCategorySelection') then
			for cat, category in next, traincategories do
				if currentAvailableType == category.type then
					if WarMenu.ComboBox(category.name, {category.notice}, 1, 1, function() end) then
						currentTrainCategory = cat
						WarMenu.OpenMenu('TrainTypeSelection')
					end
				end
			end
			currentTrainType = nil
			if WarMenu.MenuButton("~r~Back", "TrainMenu") then
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('TrainTypeSelection') then
			local cat = getTrainCategory(currentTrainCategory)
			for _, _type in next, getTrainTypesFromCategory(currentTrainCategory) do
				local type = getTrainTypeData(_type)
				local name = ("%s (%s)"):format(cat.name, type.name)
				if WarMenu.ComboBox(name, {type.permissionText}, 1, 1, function() end) then
					WarMenu.SetSubTitle("TrainSpawnSelection", name)
					currentTrainType = _type
					WarMenu.OpenMenu('TrainSpawnSelection')
				end
			end
			currentTrainVariation = 1
			if WarMenu.MenuButton("~r~Back", "TrainCategorySelection") then
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('TrainSpawnSelection') then
			local variations = {}
			local type = getTrainTypeData(currentTrainType)
			local trains = getTrainsOfType(currentTrainType)
			for n, train in next, trains do
				table.insert(variations, ("#%i (%i wagons)"):format(n, train.cars))
			end
			if #variations == 0 then
				WarMenu.ComboBox('Error', {"No train variations available"}, 1, 1, function() end)
			else
				WarMenu.ComboBox('Requirements', {type.permissionText}, 1, 1, function() end)
				if WarMenu.ComboBox('Variation', variations, currentTrainVariation, currentTrainVariation, function(currentIndex, selectedIndex)
					currentTrainVariation = currentIndex
				end) then
				elseif WarMenu.Button("~g~Confirm") then
					currentTrain = trains[currentTrainVariation]
					local pos = spawnPos
					TriggerServerEvent("omni:checkPermissionsFromSet", {type.permissions}, function()
						spawnTrain(currentTrain.train, pos.x, pos.y, pos.z)
						TriggerEvent("omni_conductor:setTrainType", currentTrainType, type, currentTrain, trackType)
					end, function()
						TriggerEvent("gd_utils:oneliner", "~r~Couldn't spawn train.~n~~y~Requirement: ~w~" .. type.permissionText)
					end)
					WarMenu.CloseMenu()
				end
			end
			if WarMenu.MenuButton("~r~Back", "TrainTypeSelection") then
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('TrainSpawnOptions') then
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('TrainDeletionPrompt') then
		    if WarMenu.Button("Yes") then
				-- delete train
				RemoveTrain(CURRENT_TRAIN)
				CURRENT_TRAIN = nil
				WarMenu.CloseMenu()
			elseif WarMenu.Button("No") then
				WarMenu.CloseMenu()
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('TrainBuySelection') then
			WarMenu.ComboBox('Notice', {"All trains are currently free"}, 1, 1, function() end)
			if WarMenu.MenuButton("~r~Back", "TrainMenu") then
			end
			WarMenu.Display()
		else
			local pos = GetEntityCoords(PlayerPedId())
			for _, spawner in next, TRAIN_SPAWNERS do
				local dist = #(pos - vector3(spawner.menu.x, spawner.menu.y, spawner.menu.z))
				if dist < 100.0 then
					DrawMarker(0, spawner.menu.x, spawner.menu.y, spawner.menu.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 139, 69, 19, 255, true, false)
					if dist < 1.0 then
						DrawText3D("Press ~g~E ~w~to open the Train Menu", spawner.menu.x, spawner.menu.y, spawner.menu.z + 1.0)
						if IsControlJustPressed(0, 38) then
							currentAvailableType = spawner.type
							spawnPos = spawner.spawn
							trackType = spawner.track
							WarMenu.OpenMenu('TrainMenu')
						end
					elseif dist < 20.0 then
						DrawText3D("Train Spawner", spawner.menu.x, spawner.menu.y, spawner.menu.z + 1.0)
					end
				end
			end
		end

		Citizen.Wait(0)
	end
end)
