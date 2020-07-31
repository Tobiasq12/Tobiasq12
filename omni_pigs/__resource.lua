name "PIGS Heist System"
author "glitchdetector"
contact "glitchdetector@gmail.com"
version "1.0"

description "Heist system, allows parties to take on waves of enemies for a prize"
usage [[

]]

resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_script 'client/gunloadout.lua'
--client_script 'client/main.lua'
client_script 'client/helper.lua'
client_script 'locations.lua'
client_script 'client/party.lua'
client_script 'client/master.lua'
client_script 'client/slave.lua'

server_script '@vrp/lib/utils.lua'
server_script 'server/main.lua'
