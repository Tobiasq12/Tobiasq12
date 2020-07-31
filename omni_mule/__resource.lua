name "UPS Delivery Job"
author "glitchdetector"
contact "glitchdetector@gmail.com"
version "1.0"

description "Specialized job where you drive a mule around and deliver packages"
usage [[

]]

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script 'client.lua'

-- BOX JOB
client_script 'box/shared.lua'
client_script 'box/box.lua'

server_scripts {
    '@vrp/lib/utils.lua',
	'server.lua',
    -- BOX JOB
	'box/shared.lua',
	'box/server.lua',
}
