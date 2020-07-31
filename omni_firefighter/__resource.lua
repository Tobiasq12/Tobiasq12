name "FireFighter"
author "Tycoon"
contact ""
version "1.0"

description "FireFighting Job"
usage [[

]]

dependency 'omni_common'
dependencies {'instructional-buttons'}
client_script '@instructional-buttons/include.lua'

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
    '@vrp/lib/utils.lua',
    'sv_firefighter.lua',
}

client_scripts {
    '@omni_common/vehicles.lua',
    'cl_firefighter.lua',
    'cfg_firefighter.lua'
}
