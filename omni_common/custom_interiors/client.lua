Citizen.CreateThread(function()
    RequestIpl("ex_exec_warehouse_placement_interior_2_int_warehouse_l_dlc_milo_")
    while not IsIplActive("ex_exec_warehouse_placement_interior_2_int_warehouse_l_dlc_milo_") do
        Wait(0)
    end
    print("yeet")
    local hash = `ex_Office_03b_bathroomArt`
    RequestModel(hash)
    if not IsModelInCdimage(hash) then
        print("not in cd")
    end
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    print("spawned")
    CreateObjectNoOffset(hash, 803.46026611328, 3784.8332519531, 53.464935302734, false, 0, false)
end)
