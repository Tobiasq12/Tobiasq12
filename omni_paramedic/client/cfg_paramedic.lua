job_vehicles = {
	{name = "ambulance", heli = false},
	{name = "uh1nasa", heli = true},
	{name = "polmav", heli = true},
	{name = "frllc_firesuv", heli = false},
	{name = "ems_suv", heli = false},
	{name = "ambulance2", heli = false},
	{name = "aw139", heli = true},
	{name = "firetruk", heli = false},
	{name = "lguard", heli = false},
	{name = "emsnspeedo", heli = false},
	{name = "cgexecutioner", heli = false},
	{name = "cgsandking", heli = false},
	{name = "cgpredato", heli = false},
	{name = "cgdinghy", heli = false},
	{name = "cgheli", heli = true},
	{name = "pranger", heli = false},
}

hospital_stations = {
	{name = "Mount Zonah Medical Center", x = -443.00149536133, y = -329.16247558594, z = 78.168190002441, heli = true, region = "LOSSANTOS", preview = "MTZ"},
	{name = "Mount Zonah Medical Center", x = -497.90594482422, y = -336.33676147461, z = 34.501747131348, ground = true, region = "LOSSANTOS", preview = "MTZ"},

	-- {name = "Eugenics Rockford Hills", x = -909.63830566406, y = -335.59121704102, z = 38.978973388672, ground = true, region = "WESTVW"}, -- No zones yet?

	{name = "Pillbox Hill Medical Center", x = 360.55487060547, y = -585.36303710938, z = 28.823513031006, ground = true, region = "EASTVW", preview = "PIL"},

	{name = "St. Fiarce Hospital", x = 1151.0407714844, y = -1529.8292236328, z = 35.3720703125, ground = true, heli = true, region = "PALOMINO", preview = "STF"},

	{name = "Central Los Santos Medical Cener", x = 334.19772338867, y = -1433.2696533203, z = 46.511295318604, heli = true, region = "CENTRAL", preview = "CEN"},
	{name = "Central Los Santos Medical Cener", x = 306.66244506836, y = -1433.2667236328, z = 29.905075073242, ground = true, region = "CENTRAL", preview = "CEN"},

	{name = "Sandy Shores Medical Center", x = 1839.4000244141, y = 3672.6999511719, z = 34.276744842529, ground = true, heli = true, region = "CENTRALSA", preview = "SAN"},

	{name = "Fort Zancudo Fire Station", x = -2083.9890136719, y = 2806.5068359375, z = 32.960605621338, ground = true, heli = true, region = "ZANCUDO", preview = "ZAN"},

	-- {name = "Fire Station No. 1 Blaine County", x = -371.6067199707, y = 6100.8803710938, z = 31.493070602417, ground = true, heli = true, region = "PALETO"}, -- No zones yet?
	{name = "Paleto Bay Care Center", x = -247.7352142334, y = 6331.4282226563, z = 32.42618560791, ground = true, heli = true, region = "PALETO", preview = "PAL"}, -- No zones yet?

	-- Liberty
	{name = "Carson General Hospital", x = -2872.525390625, y = 7316.9047851563, z = 16.2776222229, ground = true, heli = true, region = "LIBERTY", preview = "LC2"},
	{name = "Hope Medical College", x = -4327.9404296875, y = 7218.7250976563, z = 59.308750152588, ground = true, heli = true, region = "LIBERTY", preview = "LC3"}, -- No zones yet?
	{name = "Sweeney General Hospital", x = -1932.3826904297, y = 6772.353515625, z = 22.09992980957, ground = true, heli = true, region = "LIBERTY", preview = "LC1"}, -- No zones yet?
}

hospital_dropoff = {
	{name = "Eugenics Rockford Hills", x = -454.62744140625, y = -339.76263427734, z = 33.908260345459, heli = false, hidden = true},

	{name = "Fort Zancudo Fire Station", x = -1877.0311279297, y = 2805.4685058594, z = 32.806480407715, heli = true},
	{name = "Fort Zancudo Fire Station", x = -2101.0283203125, y = 2834.125, z = 32.809734344482, heli = false},

	{name = "Mount Zonah Medical Center", x = -454.62744140625, y = -339.76263427734, z = 33.908260345459, heli = false},
	{name = "Mount Zonah Medical Center", x = -506.66842651367, y = -308.57647705078, z = 72.710998535156, heli = true},
	{name = "Mount Zonah Medical Center", x = -457.09848022461, y = -290.68637084961, z = 78.55638885498, heli = true},

	{name = "St. Fiacre Hospital", x = 1138.8172607422, y = -1603.0270996094, z = 34.692539215088, heli = false},
	{name = "St. Fiacre Hospital", x = 1173.6593017578, y = -1561.2351074219, z = 39.401565551758, heli = true},

	{name = "Sandy Shores Medical Center", x = 1828.2261962891, y = 3694.0148925781, z = 34.224277496338, heli = false},
	{name = "Sandy Shores Medical Center", x = 1772.1634521484, y = 3655.29296875, z = 34.396625518799, heli = true},

	{name = "Fire Station No. 1 Blaine County", x = -373.38916015625, y = 6098.880859375, z = 31.444456100464, heli = false},
	{name = "Paleto Bay Care Center", x = -232.46057128906, y = 6316.7338867188, z = 31.290203094482, heli = false},

	{name = "Paleto Bay Sheriff Office", x = -475.21353149414, y = 5988.1850585938, z = 31.147464752197, heli = true},

	{name = "Central Los Santos Medical Center", x = 312.88082885742, y = -1464.7690429688, z = 46.509490966797, heli = true},
	{name = "Central Los Santos Medical Center", x = 299.16931152344, y = -1453.1658935547, z = 46.509498596191, heli = true},
	{name = "Central Los Santos Medical Center", x = 298.43869018555, y = -1444.201171875, z = 29.802074432373, heli = false},

	{name = "Pillbox Hill Medical Center", x = 364.25967407227, y = -591.76580810547, z = 28.684616088867, heli = false},
	{name = "Pillbox Hill Medical Center", x = 351.75738525391, y = -587.59576416016, z = 74.165641784668, heli = true},

	-- Liberty
	{name = "Carson General Hospital", x = -2875.1274414063, y = 7353.9091796875, z = 46.912719726563, heli = true},
	{name = "Carson General Hospital", x = -2900.9445800781, y = 7277.8344726563, z = 16.277626037598, heli = false},

	{name = "Hope Medical College", x = -4310.9028320313, y = 7214.576171875, z = 71.431579589844, heli = true},
	{name = "Hope Medical College", x = -4341.8774414063, y = 7155.666015625, z = 58.858520507813, heli = false},

	{name = "Sweeney General Hospital", x = -1915.3151855469, y = 6767.4765625, z = 34.494846343994, heli = true},
	{name = "Sweeney General Hospital", x = -1943.8594970703, y = 6705.9487304688, z = 14.963404655457, heli = false},
}


-----------------------
-- CALLOUT VARIABLES --
-----------------------

notify = "~r~Medical Dispatch: Call for help"

dispatch = {
	"Heart attack",
	"Heavy bleeding",
	"Stabbed",
	"Neck pains",
	"Back pains",
	"Hit and run",
	"Passed out",
	"Victim of crime",
	"Hurt feelings",
	"Bullet wounds",
	"Breathing problems",
	"Seizure",
	"Unconscious person",
	"Possible stroke",
	"Unresponsive individual",
	"Fallen and can't get up",
	"Planking",
	"Attempted an hero",
	"Heavy intoxication",
	"Allergic reaction",
}
