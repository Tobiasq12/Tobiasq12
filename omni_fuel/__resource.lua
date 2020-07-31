name "Fuel System"
author "glitchdetector"
contact "glitchdetector@gmail.com"
version "1.0"

description "A lightweight fuel system"
usage [[

]]

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency 'omni_common'
client_script '@omni_common/d3d.lua'

shared_script 'sh_fuel.lua'
shared_script 'stations.lua'
client_script 'cl_fuel.lua'

dependency 'vrp'
server_script '@vrp/lib/utils.lua'
server_script 'sv_fuel.lua'
