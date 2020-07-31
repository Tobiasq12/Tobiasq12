name "Beach Cleanup Job"
author "Collins"
contact ""
version "1.0"

description "Beach Cleanup job"
usage [[

]]

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
    '@vrp/lib/utils.lua',
    'server.lua'
}

client_scripts {
    'dozer_client.lua'
}
