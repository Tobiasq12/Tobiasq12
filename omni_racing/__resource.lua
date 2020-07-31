name "Racing System"
author "glitchdetector"
contact "glitchdetector@gmail.com"
version "1.0"

description "Race system with time trials-type goals"
usage [[

]]

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script 'client_race_builder.lua'

server_script '@vrp/lib/utils.lua'
server_script 'server_race_builder.lua'
client_script 'client_racing.lua'
server_script 'server_racing.lua'
