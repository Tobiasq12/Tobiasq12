function SetBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

function ShowHelpText(label, value)
    BeginTextCommandDisplayHelp(label)
    EndTextCommandDisplayHelp(0, 0, true, value)
end
