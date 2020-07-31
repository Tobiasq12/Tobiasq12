name "Fishing"
author "Tycoon"
contact ""
version "1.0"

description "Fishing system"
usage [[

]]

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

shared_script 'shared.lua'

server_scripts {
    '@vrp/lib/utils.lua',
    'server.lua'
}

client_scripts {
    'lang.lua',
    'client.lua',
    'tug_client.lua'
}
