fx_version "cerulean"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

author "Chrisi"
description "Sevenlife Beard Script"

version "1.0.1"

client_scripts {
    "client.lua"
}
server_scripts {
    "server.lua",
    "@mysql-async/lib/MySQL.lua"
}
