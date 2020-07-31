name "Train System"
author "glitchdetector"
contact "glitchdetector@gmail.com"
version "1.0"

description "Allows spawning and driving of trains"
usage [[

]]

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

-- es_conductor/
shared_script 'shared.lua'

client_script 'warmenu.lua'
client_script 'client.lua'
client_script 'menu.lua'

server_script 'server.lua'

client_scripts {
    'tracks/*.lua',
}

client_script 'hud.lua'
