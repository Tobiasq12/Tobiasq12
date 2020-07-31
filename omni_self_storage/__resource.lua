name "Self Storages"
author "glitchdetector"
contact "glitchdetector@gmail.com"
version "1.0"

description "Allows storage of items for a configurable fee"
usage [[
    Approach a self storage location and press E to access it
]]
download "https://forum.fivem.net/t/release-vrp-self-storages/508424"

client_script 'shared.lua'
client_script 'client.lua'

server_script '@vrp/lib/utils.lua'
server_script 'shared.lua'
server_script 'server.lua'

config_file 'shared.lua'
