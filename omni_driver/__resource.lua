name "omni_driver"
author "CollinsAlexander"
contact "community.tycoon@gmail.com"
version "1.0"

description "an AI that drives you around, amazing right?"
usage [[

]]

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_script {
    '@vrp/lib/utils.lua',
    'server.lua',
}

client_scripts {
    'warmenu.lua',
    'client.lua',
}
