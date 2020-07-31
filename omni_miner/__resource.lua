name "Miner Job"
author "Collins"
contact ""
version "1.0"

description "Mining job"
usage [[

]]

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

-- Server
server_scripts {
    '@vrp/lib/utils.lua',
    'server/main.lua'
}

-- Client
client_scripts {
	'client/main.lua',
    '@omni_common/client.lua'
}
