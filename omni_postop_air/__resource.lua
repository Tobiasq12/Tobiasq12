name "PostOP Air Job"
author "Collins"
contact ""
version "1.0"

description "Tycoon Postop job"
usage [[

]]

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

-- Server
server_scripts {
    '@vrp/lib/utils.lua',
    'server.lua'
}

-- Client
client_scripts {
    'cfg_postop_air.lua',
	'client.lua'
}

config_file 'client/cfg_postop_air.lua'
