-- 0-4: tiny
-- 5-7: short
-- 8-8: medium
-- 9+: long
traindata = {
    {name = "Freight: Tiny Flatbed", train = 0, id = "FREIGHT_FLAT_TINY", cars = 2, engines = 1, types = {"flatbed"}},
    {name = "Freight: Medium Flatbed", train = 1, id = "FREIGHT_FLAT_MEDIUM", cars = 8, engines = 1, types = {"flatbed"}},
    {name = "Freight: Long Flatbed", train = 22, id = "FREIGHT_FLAT_LONG", cars = 12, engines = 1, types = {"flatbed"}},
    {name = "Freight: Long Flatbed", train = 44, id = "FREIGHT_FLAT_LONG", cars = 12, engines = 1, types = {"flatbed"}},
    {name = "Freight: Tiny Mixed", train = 6, id = "FREIGHT_MIXED_TINY", cars = 4, engines = 1, types = {"container", "flatbed", "tanker"}},
    {name = "Freight: Tiny Mixed", train = 28, id = "FREIGHT_MIXED_TINY", cars = 4, engines = 1, types = {"tanker", "container", "flatbed"}},
    {name = "Freight: Short Mixed", train = 2, id = "FREIGHT_MIXED_SHORT", cars = 5, engines = 1, types = {"flatbed", "tanker", "container"}},
    {name = "Freight: Short Mixed", train = 30, id = "FREIGHT_MIXED_SHORT", cars = 7, engines = 1, types = {"container", "flatbed", "tanker"}},
    {name = "Freight: Medium Mixed", train = 3, id = "FREIGHT_MIXED_MEDIUM", cars = 8, engines = 1, types = {"flatbed", "tanker"}},
    {name = "Freight: Medium Mixed", train = 15, id = "FREIGHT_MIXED_MEDIUM", cars = 8, engines = 1, types = {"flatbed", "container", "grain"}},
    {name = "Freight: Medium Mixed", train = 37, id = "FREIGHT_MIXED_MEDIUM", cars = 8, engines = 1, types = {"grain", "flatbed", "container"}},
    {name = "Freight: Short Grain", train = 5, id = "FREIGHT_GRAIN_SHORT", cars = 6, engines = 1, types = {"grain", "flatbed"}},
    {name = "Freight: Short Grain", train = 9, id = "FREIGHT_GRAIN_SHORT", cars = 6, engines = 1, types = {"flatbed", "grain"}},
    {name = "Freight: Short Grain", train = 12, id = "FREIGHT_GRAIN_SHORT", cars = 6, engines = 1, types = {"flatbed", "grain"}},
    {name = "Freight: Short Grain", train = 31, id = "FREIGHT_GRAIN_SHORT", cars = 6, engines = 1, types = {"flatbed", "grain"}},
    {name = "Freight: Short Grain", train = 34, id = "FREIGHT_GRAIN_SHORT", cars = 6, engines = 1, types = {"flatbed", "grain"}},
    {name = "Freight: Long Grain", train = 4, id = "FREIGHT_GRAIN_LONG", cars = 9, engines = 1, types = {"grain", "flatbed"}},
    {name = "Freight: Tiny Container", train = 20, id = "FREIGHT_CONTAINER_TINY", cars = 3, engines = 1, types = {"container"}},
    {name = "Freight: Short Container", train = 8, id = "FREIGHT_CONTAINER_SHORT", cars = 7, engines = 1, types = {"flatbed", "container", "tanker"}},
    {name = "Freight: Short Container", train = 11, id = "FREIGHT_CONTAINER_SHORT", cars = 7, engines = 1, types = {"container", "flatbed"}},
    {name = "Freight: Short Container", train = 33, id = "FREIGHT_CONTAINER_SHORT", cars = 7, engines = 1, types = {"container", "flatbed"}},
    {name = "Freight: Medium Container", train = 7, id = "FREIGHT_CONTAINER_MEDIUM", cars = 8, engines = 1, types = {"flatbed", "container"}},
    {name = "Freight: Medium Container", train = 10, id = "FREIGHT_CONTAINER_MEDIUM", cars = 8, engines = 1, types = {"container", "flatbed"}},
    {name = "Freight: Medium Container", train = 14, id = "FREIGHT_CONTAINER_MEDIUM", cars = 8, engines = 1, types = {"container", "flatbed"}},
    {name = "Freight: Medium Container", train = 29, id = "FREIGHT_CONTAINER_MEDIUM", cars = 8, engines = 1, types = {"flatbed", "container"}},
    {name = "Freight: Medium Container", train = 32, id = "FREIGHT_CONTAINER_MEDIUM", cars = 8, engines = 1, types = {"container", "flatbed"}},
    {name = "Freight: Medium Container", train = 36, id = "FREIGHT_CONTAINER_MEDIUM", cars = 8, engines = 1, types = {"flatbed", "container"}},
    {name = "Freight: Long Container", train = 23, id = "FREIGHT_CONTAINER_LONG", cars = 13, engines = 1, types = {"container", "flatbed"}},
    {name = "Freight: Long Container", train = 45, id = "FREIGHT_CONTAINER_LONG", cars = 13, engines = 1, types = {"flatbed", "container"}},
    {name = "Freight: Supersize Container", train = 17, id = "FREIGHT_CONTAINER_SUPERSIZE", cars = 40, engines = 1, types = {"container"}},
    {name = "Freight: Tiny Tanker", train = 19, id = "FREIGHT_TANKER_TINY", cars = 2, engines = 1, types = {"tanker"}},
    {name = "Freight: Short Tanker", train = 16, id = "FREIGHT_TANKER_SHORT", cars = 7, engines = 1, types = {"flatbed", "tanker"}},
    {name = "Freight: Medium Tanker", train = 13, id = "FREIGHT_TANKER_MEDIUM", cars = 8, engines = 1, types = {"tanker", "flatbed"}},
    {name = "Freight: Short Tanker", train = 38, id = "FREIGHT_TANKER_SHORT", cars = 7, engines = 1, types = {"tanker", "flatbed"}},
    {name = "Freight: Medium Tanker", train = 35, id = "FREIGHT_TANKER_MEDIUM", cars = 8, engines = 1, types = {"flatbed", "tanker"}},
    {name = "Freight: Long Tanker", train = 26, id = "FREIGHT_TANKER_LONG", cars = 12, engines = 1, types = {"tanker"}},
    {name = "Freight: Engine", train = 18, id = "FREIGHT_ENGINE", cars = 0, engines = 1, types = {}},
    {name = "Metro: Unused", train = 21, id = "METRO_UNUSED", cars = 1, engines = 0, types = {"passenger"}},
    {name = "Metro: Single", train = 24, id = "METRO_SINGLE", cars = 2, engines = 0, types = {"passenger"}},
    {name = "Metro: Dual", train = 47, id = "METRO_DUAL", cars = 4, engines = 0, types = {"passenger"}},
    {name = "Metro: Triple", train = 48, id = "METRO_TRIPLE", cars = 6, engines = 0, types = {"passenger"}},
    {name = "Metro: Quadruple", train = 49, id = "METRO_QUAD", cars = 8, engines = 0, types = {"passenger"}},
    {name = "Passenger: Shinkansen E7 EMU (Tiny)", train = 51, id = "PASSENGER_E7_TINY", cars = 4, engines = 0, types = {"passenger"}},
    {name = "Passenger: Shinkansen E7 EMU (Short)", train = 25, id = "PASSENGER_E7_SHORT", cars = 6, engines = 0, types = {"passenger"}},
    {name = "Passenger: Shinkansen E7 EMU (Medium)", train = 50, id = "PASSENGER_E7_MEDIUM", cars = 8, engines = 0, types = {"passenger"}},
    {name = "Passenger: Shinkansen E7 EMU (Long)", train = 67, id = "PASSENGER_E7_LONG", cars = 10, engines = 0, types = {"passenger"}},
    {name = "Passenger: InterCity Express 3M EMU (Tiny)", train = 63, id = "PASSENGER_ICE_TINY", cars = 4, engines = 0, types = {"passenger"}},
    {name = "Passenger: InterCity Express 3M EMU (Short)", train = 27, id = "PASSENGER_ICE_SHORT", cars = 6, engines = 0, types = {"passenger"}},
    {name = "Passenger: InterCity Express 3M EMU (Short)", train = 65, id = "PASSENGER_ICE_SHORT", cars = 6, engines = 0, types = {"passenger"}},
    {name = "Passenger: InterCity Express 3M EMU (Medium)", train = 64, id = "PASSENGER_ICE_MEDIUM", cars = 8, engines = 0, types = {"passenger"}},
    {name = "Passenger: InterCity Express 3M EMU (Long)", train = 66, id = "PASSENGER_ICE_LONG", cars = 10, engines = 0, types = {"passenger"}},
    {name = "Passenger: China Railways H6 EMU (Tiny)", train = 41, id = "PASSENGER_6F_TINY", cars = 4, engines = 0, types = {"passenger"}},
    {name = "Passenger: China Railways H6 EMU (Tiny)", train = 42, id = "PASSENGER_6F_TINY", cars = 3, engines = 0, types = {"passenger"}},
    {name = "Passenger: China Railways H6 EMU (Short)", train = 40, id = "PASSENGER_6F_SHORT", cars = 5, engines = 0, types = {"passenger"}},
    {name = "Passenger: China Railways H6 EMU (Short)", train = 43, id = "PASSENGER_6F_SHORT", cars = 7, engines = 0, types = {"passenger"}},
    {name = "Passenger: China Railways H6 EMU (Medium)", train = 39, id = "PASSENGER_6F_MEDIUM", cars = 8, engines = 0, types = {"passenger"}},
    {name = "Passenger: China Railways H6 EMU (Long)", train = 68, id = "PASSENGER_6F_LONG", cars = 10, engines = 0, types = {"passenger"}},
    {name = "Passenger: Shinkansen E4 EMU (Tiny)", train = 53, id = "PASSENGER_E4_TINY", cars = 4, engines = 0, types = {"passenger"}},
    {name = "Passenger: Shinkansen E4 EMU (Short)", train = 52, id = "PASSENGER_E4_SHORT", cars = 6, engines = 0, types = {"passenger"}},
    {name = "Passenger: Shinkansen E4 EMU (Medium)", train = 54, id = "PASSENGER_E4_MEDIUM", cars = 8, engines = 0, types = {"passenger"}},
    {name = "Passenger: Shinkansen E4 EMU (Long)", train = 46, id = "PASSENGER_E4_LONG", cars = 10, engines = 0, types = {"passenger"}},

    {name = "LC Metro: Single", train = 69, id = "LIBERTY_SINGLE", cars = 1, engines = 0, types = {"passenger"}},
    {name = "LC Metro: Dual", train = 70, id = "LIBERTY_DUAL", cars = 2, engines = 0, types = {"passenger"}},
    {name = "LC Metro: Triple", train = 71, id = "LIBERTY_TRIPLE", cars = 3, engines = 0, types = {"passenger"}},

    {name = "Metro NL: Single", train = 72, id = "NL_SINGLE", cars = 2, engines = 0, types = {"passenger"}},
    {name = "Metro NL: Dual", train = 73, id = "NL_DUAL", cars = 3, engines = 0, types = {"passenger"}},
    {name = "Metro NL: Triple", train = 74, id = "NL_TRIPLE", cars = 4, engines = 0, types = {"passenger"}},
    {name = "Metro NL: QUAD", train = 75, id = "NL_QUAD", cars = 4, engines = 0, types = {"passenger"}},

    -- {name = "Metro: Train (Tiny)", train = 58, id = "METRO_TRAIN_TINY", cars = 2, engines = 0, types = {"passenger"}},
    -- {name = "Metro: Train (Short)", train = 59, id = "METRO_TRAIN_SMALL", cars = 3, engines = 0, types = {"passenger"}},
    -- {name = "Metro: Train (Medium)", train = 60, id = "METRO_TRAIN_MEDIUM", cars = 4, engines = 0, types = {"passenger"}},
    -- {name = "Metro: Train (Long)", train = 61, id = "METRO_TRAIN_LONG", cars = 5, engines = 0, types = {"passenger"}},
    -- {name = "Metro: Train (Double)", train = 62, id = "METRO_TRAIN_DOUBLE", cars = 5, engines = 0, types = {"passenger"}},

    -- {name = "", train = 48, id = "", cars = , engines = , types = {}},
}

cartypes = {
    ["flatbed"] = "Flatbed Cars",
    ["container"] = "Container Cars",
    ["tanker"] = "Tanker Cars",
    ["passenger"] = "Passenger Cars",
    ["grain"] = "Grain Cars",
}

traintypes = {
    ["FREIGHT_FLAT_TINY"] = {name = "Tiny", permissions = {"conductor.job", "@train.train.>4"}, permissionText = "Conductor Lv. 5", bonus = 1.0, price = 0},
    ["FREIGHT_FLAT_MEDIUM"] = {name = "Medium", permissions = {"conductor.job", "@train.train.>24"}, permissionText = "Conductor Lv. 25", bonus = 1.0, price = 0},
    ["FREIGHT_FLAT_LONG"] = {name = "Long", permissions = {"conductor.job", "@train.train.>49"}, permissionText = "Conductor Lv. 50", bonus = 1.0, price = 0},
    ["FREIGHT_MIXED_TINY"] = {name = "Tiny", permissions = {"conductor.job", "@train.train.>4"}, permissionText = "Conductor Lv. 5", bonus = 1.0, price = 0},
    ["FREIGHT_MIXED_SHORT"] = {name = "Short", permissions = {"conductor.job", "@train.train.>9"}, permissionText = "Conductor Lv. 10", bonus = 1.0, price = 0},
    ["FREIGHT_MIXED_MEDIUM"] = {name = "Medium", permissions = {"conductor.job", "@train.train.>24"}, permissionText = "Conductor Lv. 25", bonus = 1.0, price = 0},
    ["FREIGHT_GRAIN_SHORT"] = {name = "Short", permissions = {"conductor.job", "@train.train.>9"}, permissionText = "Conductor Lv. 10", bonus = 1.0, price = 0},
    ["FREIGHT_GRAIN_LONG"] = {name = "Long", permissions = {"conductor.job", "@train.train.>49"}, permissionText = "Conductor Lv. 50", bonus = 1.0, price = 0},
    ["FREIGHT_CONTAINER_TINY"] = {name = "Tiny", permissions = {"conductor.job", "@train.train.>4"}, permissionText = "Conductor Lv. 5", bonus = 1.0, price = 0},
    ["FREIGHT_CONTAINER_SHORT"] = {name = "Short", permissions = {"conductor.job", "@train.train.>9"}, permissionText = "Conductor Lv. 10", bonus = 1.0, price = 0},
    ["FREIGHT_CONTAINER_MEDIUM"] = {name = "Medium", permissions = {"conductor.job", "@train.train.>24"}, permissionText = "Conductor Lv. 25", bonus = 1.0, price = 0},
    ["FREIGHT_CONTAINER_LONG"] = {name = "Long", permissions = {"conductor.job", "@train.train.>49"}, permissionText = "Conductor Lv. 50", bonus = 1.0, price = 0},
    ["FREIGHT_CONTAINER_SUPERSIZE"] = {name = "Supersize", permissions = {"conductor.job", "@train.train.>99"}, permissionText = "Conductor Lv. 100", bonus = 1.0, price = 0},
    ["FREIGHT_TANKER_TINY"] = {name = "Tiny", permissions = {"conductor.job", "@train.train.>4"}, permissionText = "Conductor Lv. 5", bonus = 1.0, price = 0},
    ["FREIGHT_TANKER_SHORT"] = {name = "Short", permissions = {"conductor.job", "@train.train.>9"}, permissionText = "Conductor Lv. 10", bonus = 1.0, price = 0},
    ["FREIGHT_TANKER_MEDIUM"] = {name = "Medium", permissions = {"conductor.job", "@train.train.>24"}, permissionText = "Conductor Lv. 25", bonus = 1.0, price = 0},
    ["FREIGHT_TANKER_LONG"] = {name = "Long", permissions = {"conductor.job", "@train.train.>49"}, permissionText = "Conductor Lv. 50", bonus = 1.0, price = 0},
    ["FREIGHT_ENGINE"] = {name = "Single", permissions = {"conductor.job", "@train.train.>4"}, permissionText = "Conductor Lv. 5", bonus = 1.0, price = 0},
    ["METRO_UNUSED"] = {name = "Unused", permissions = {"trains.metro", "@train.train.>0"}, permissionText = "Train Conductor", bonus = 1.0, price = 0},
    ["METRO_SINGLE"] = {name = "Single", permissions = {"trains.metro", "@train.train.>0"}, permissionText = "Train Conductor", bonus = 1.0, price = 0},
    ["METRO_DUAL"] = {name = "Dual", permissions = {"trains.metro", "@train.train.>4"}, permissionText = "Conductor Lv. 5", bonus = 1.0, price = 0},
    ["METRO_TRIPLE"] = {name = "Triple", permissions = {"trains.metro", "@train.train.>24"}, permissionText = "Conductor Lv. 25", bonus = 1.0, price = 0},
    ["METRO_QUAD"] = {name = "Quad", permissions = {"trains.metro", "@train.train.>49"}, permissionText = "Conductor Lv. 50", bonus = 1.0, price = 0},
    ["PASSENGER_ICE_TINY"] = {name = "Tiny", permissions = {"conductor.job", "@train.train.>19"}, permissionText = "Conductor Lv. 20", bonus = 1.0, price = 0},
    ["PASSENGER_ICE_SHORT"] = {name = "Short", permissions = {"conductor.job", "@train.train.>34"}, permissionText = "Conductor Lv. 35", bonus = 1.0, price = 0},
    ["PASSENGER_ICE_MEDIUM"] = {name = "Medium", permissions = {"conductor.job", "@train.train.>59"}, permissionText = "Conductor Lv. 60", bonus = 1.0, price = 0},
    ["PASSENGER_ICE_LONG"] = {name = "Long", permissions = {"conductor.job", "@train.train.>94"}, permissionText = "Conductor Lv. 95", bonus = 1.0, price = 0},
    ["PASSENGER_E7_TINY"] = {name = "Tiny", permissions = {"conductor.job", "@train.train.>19"}, permissionText = "Conductor Lv. 20", bonus = 1.0, price = 0},
    ["PASSENGER_E7_SHORT"] = {name = "Short", permissions = {"conductor.job", "@train.train.>34"}, permissionText = "Conductor Lv. 35", bonus = 1.0, price = 0},
    ["PASSENGER_E7_MEDIUM"] = {name = "Medium", permissions = {"conductor.job", "@train.train.>59"}, permissionText = "Conductor Lv. 60", bonus = 1.0, price = 0},
    ["PASSENGER_E7_LONG"] = {name = "Long", permissions = {"conductor.job", "@train.train.>94"}, permissionText = "Conductor Lv. 95", bonus = 1.0, price = 0},
    ["PASSENGER_6F_TINY"] = {name = "Tiny", permissions = {"conductor.job", "@train.train.>19"}, permissionText = "Conductor Lv. 20", bonus = 1.0, price = 0},
    ["PASSENGER_6F_SHORT"] = {name = "Short", permissions = {"conductor.job", "@train.train.>34"}, permissionText = "Conductor Lv. 35", bonus = 1.0, price = 0},
    ["PASSENGER_6F_MEDIUM"] = {name = "Medium", permissions = {"conductor.job", "@train.train.>59"}, permissionText = "Conductor Lv. 60", bonus = 1.0, price = 0},
    ["PASSENGER_6F_LONG"] = {name = "Long", permissions = {"conductor.job", "@train.train.>94"}, permissionText = "Conductor Lv. 95", bonus = 1.0, price = 0},
    ["PASSENGER_E4_TINY"] = {name = "Tiny", permissions = {"corp2.employee", "trains.collinsco", "@train.train.>19"}, permissionText = "CollinsCo Lv. 20", bonus = 1.0, price = 0},
    ["PASSENGER_E4_SHORT"] = {name = "Short", permissions = {"corp2.employee", "trains.collinsco", "@train.train.>34"}, permissionText = "CollinsCo Lv. 35", bonus = 1.0, price = 0},
    ["PASSENGER_E4_MEDIUM"] = {name = "Medium", permissions = {"corp2.employee", "trains.collinsco", "@train.train.>59"}, permissionText = "CollinsCo Lv. 60", bonus = 1.0, price = 0},
    ["PASSENGER_E4_LONG"] = {name = "Long", permissions = {"corp2.employee", "trains.collinsco", "@train.train.>94"}, permissionText = "CollinsCo Lv. 95", bonus = 1.0, price = 0},
    ["METRO_TRAIN_TINY"] = {name = "Tiny", permissions = {"conductor.job", "@train.train.>0"}, permissionText = "Train Conductor", bonus = 1.0, price = 0},
    ["METRO_TRAIN_SMALL"] = {name = "Small", permissions = {"conductor.job", "@train.train.>0"}, permissionText = "Train Conductor", bonus = 1.0, price = 0},
    ["METRO_TRAIN_MEDIUM"] = {name = "Medium", permissions = {"conductor.job", "@train.train.>0"}, permissionText = "Train Conductor", bonus = 1.0, price = 0},
    ["METRO_TRAIN_LONG"] = {name = "Long", permissions = {"conductor.job", "@train.train.>0"}, permissionText = "Train Conductor", bonus = 1.0, price = 0},
    ["METRO_TRAIN_DOUBLE"] = {name = "Double", permissions = {"conductor.job", "@train.train.>0"}, permissionText = "Train Conductor", bonus = 1.0, price = 0},

    ["LIBERTY_SINGLE"] = {name = "Single", permissions = {"trains.metro", "@train.train.>0"}, permissionText = "Train Conductor", bonus = 1.0, price = 0},
    ["LIBERTY_DUAL"] = {name = "Dual", permissions = {"trains.metro", "@train.train.>4"}, permissionText = "Conductor Lv. 5", bonus = 1.0, price = 0},
    ["LIBERTY_TRIPLE"] = {name = "Triple", permissions = {"trains.metro", "@train.train.>24"}, permissionText = "Conductor Lv. 25", bonus = 1.0, price = 0},

    ["NL_SINGLE"] = {name = "Single", permissions = {"trains.metro", "@train.train.>0"}, permissionText = "Train Conductor", bonus = 1.0, price = 0},
    ["NL_DUAL"] = {name = "Dual", permissions = {"trains.metro", "@train.train.>4"}, permissionText = "Conductor Lv. 5", bonus = 1.0, price = 0},
    ["NL_TRIPLE"] = {name = "Triple", permissions = {"trains.metro", "@train.train.>24"}, permissionText = "Conductor Lv. 25", bonus = 1.0, price = 0},
    ["NL_QUAD"] = {name = "Quad", permissions = {"trains.metro", "@train.train.>49"}, permissionText = "Conductor Lv. 50", bonus = 1.0, price = 0},
}

traincategories = {
    {category = "METRO", name = "Metro / Subway", types = {"METRO_SINGLE","METRO_DUAL","METRO_TRIPLE","METRO_QUAD"}, notice = "", type = "metro"},
    {category = "METRO_NL", name = "Metro / Subway NL", types = {"NL_SINGLE","NL_DUAL","NL_TRIPLE","NL_QUAD"}, notice = "", type = "metro"},
    {category = "LIBERTY", name = "LC Metro / Subway", types = {"LIBERTY_SINGLE","LIBERTY_DUAL","LIBERTY_TRIPLE"}, notice = "", type = "liberty"},
    {category = "FREIGHT_FLAT", name = "Flatbed Train", types = {"FREIGHT_FLAT_TINY","FREIGHT_FLAT_MEDIUM","FREIGHT_FLAT_LONG"}, notice = "Cargo (Lv. 5+)"},
    {category = "FREIGHT_MIXED", name = "Mixed Train", types = {"FREIGHT_MIXED_TINY","FREIGHT_MIXED_SHORT","FREIGHT_MIXED_MEDIUM"}, notice = "Cargo (Lv. 5+)"},
    {category = "FREIGHT_GRAIN", name = "Grain Train", types = {"FREIGHT_GRAIN_SHORT","FREIGHT_GRAIN_LONG"}, notice = "Cargo (Lv. 5+)"},
    {category = "FREIGHT_CONTAINER", name = "Container Train", types = {"FREIGHT_CONTAINER_TINY","FREIGHT_CONTAINER_SHORT","FREIGHT_CONTAINER_MEDIUM","FREIGHT_CONTAINER_LONG","FREIGHT_CONTAINER_SUPERSIZE"}, notice = "Cargo (Lv. 5+)"},
    {category = "FREIGHT_TANKER", name = "Tanker Train", types = {"FREIGHT_TANKER_TINY","FREIGHT_TANKER_SHORT","FREIGHT_TANKER_MEDIUM","FREIGHT_TANKER_LONG"}, notice = "Cargo (Lv. 5+)"},
    {category = "PASSENGER_ICE", name = "InterCity Express 3M EMU", types = {"PASSENGER_ICE_TINY","PASSENGER_ICE_SHORT","PASSENGER_ICE_MEDIUM","PASSENGER_ICE_LONG"}, notice = "PAX (Lv. 20+)"},
    {category = "PASSENGER_6F", name = "Railways H6 EMU", types = {"PASSENGER_6F_TINY","PASSENGER_6F_SHORT","PASSENGER_6F_MEDIUM","PASSENGER_6F_LONG"}, notice = "PAX (Lv. 20+)"},
    {category = "PASSENGER_E4", name = "Shinkansen E4 EMU", types = {"PASSENGER_E4_TINY","PASSENGER_E4_SHORT","PASSENGER_E4_MEDIUM","PASSENGER_E4_LONG"}, notice = "CollinsCo."},
    {category = "PASSENGER_E7", name = "Shinkansen E7 EMU", types = {"PASSENGER_E7_TINY","PASSENGER_E7_SHORT","PASSENGER_E7_MEDIUM","PASSENGER_E7_LONG"}, notice = "PAX (Lv. 20+)"},
    -- {category = "METRO_TRAIN", name = "Metro Train", types = {"METRO_TRAIN_TINY","METRO_TRAIN_SMALL","METRO_TRAIN_MEDIUM","METRO_TRAIN_LONG","METRO_TRAIN_DOUBLE"}},
}

for _, cat in next, traincategories do
    if not cat.type then
        cat.type = "train"
    end
end

function getTrainFromIndex(trainid)
    for _, train in next, traindata do
        if train.train == trainid then
            return train
        end
    end
    return nil
end

function getTrainTypesFromCategory(cat)
    return getTrainCategory(cat).types
end

function getTrainCategory(cat)
    return traincategories[cat]
end

function getTrainsOfType(type)
    local trains = {}
    for _, train in next, traindata do
        if train.id == type then
            table.insert(trains, train)
        end
    end
    return trains
end

function getTrainTypeData(type)
    return traintypes[type]
end

function getTrainOfType(type)
    local trains = getTrainsOfType(type)
    return trains[math.random(#trains)]
end

function getAvailableTrainTypes()
    return {
        "FREIGHT_FLAT_TINY",
        "FREIGHT_FLAT_MEDIUM",
        "FREIGHT_FLAT_LONG",
        "FREIGHT_MIXED_TINY",
        "FREIGHT_MIXED_SHORT",
        "FREIGHT_MIXED_MEDIUM",
        "FREIGHT_GRAIN_SHORT",
        "FREIGHT_GRAIN_LONG",
        "FREIGHT_CONTAINER_TINY",
        "FREIGHT_CONTAINER_SHORT",
        "FREIGHT_CONTAINER_MEDIUM",
        "FREIGHT_CONTAINER_LONG",
        "FREIGHT_CONTAINER_SUPERSIZE",
        "FREIGHT_TANKER_TINY",
        "FREIGHT_TANKER_SHORT",
        "FREIGHT_TANKER_MEDIUM",
        "FREIGHT_TANKER_LONG",
        -- "FREIGHT_ENGINE",
        -- "METRO_UNUSED",
        "METRO_SINGLE",
        "METRO_DUAL",
        "METRO_TRIPLE",
        -- "METRO_QUAD",
        "PASSENGER_ICE_TINY",
        "PASSENGER_ICE_SHORT",
        "PASSENGER_ICE_MEDIUM",
        "PASSENGER_ICE_LONG",
        "PASSENGER_E7_TINY",
        "PASSENGER_E7_SHORT",
        "PASSENGER_E7_MEDIUM",
        "PASSENGER_E7_LONG",
        "PASSENGER_6F_TINY",
        "PASSENGER_6F_SHORT",
        "PASSENGER_6F_MEDIUM",
        "PASSENGER_E4_TINY",
        "PASSENGER_E4_SHORT",
        "PASSENGER_E4_MEDIUM",
        "PASSENGER_E4_LONG",
        -- "METRO_TRAIN_TINY",
        -- "METRO_TRAIN_SMALL",
        -- "METRO_TRAIN_MEDIUM",
        -- "METRO_TRAIN_LONG",
        -- "METRO_TRAIN_DOUBLE",

        "LIBERTY_SINGLE",
        "LIBERTY_DUAL",
        "LIBERTY_TRIPLE",

        "NL_SINGLE",
        "NL_DUAL",
        "NL_TRIPLE",
        "NL_QUADNL_SINGLE",
    }
end
