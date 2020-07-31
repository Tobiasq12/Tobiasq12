name "Paramedic Job"
author "Tycoon"
contact ""
version "1.0"

description "Paramedic Job system"
usage [[

]]

dependency 'omni_common'

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

-- es_paramedic/
-- Server
server_scripts {
    '@vrp/lib/utils.lua',
    'server/main.lua'
}

-- Client
client_scripts {
    '@omni_common/peds.lua',
    '@omni_common/d3d.lua',
    'client/cfg_paramedic_zones.lua',
    'client/cfg_paramedic.lua',
    'client/main.lua',
    'client/menu.lua'
}

config_file 'client/cfg_paramedic.lua'
config_file 'client/cfg_paramedic_zones.lua'
