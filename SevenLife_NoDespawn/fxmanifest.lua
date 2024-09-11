fx_version "cerulean"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "SevenLife No Car Despawn System"

author "꧁☬ℭ𝔥𝔯𝔦𝔰𝔦☬꧂#0001"

version "1.0.1"

client_scripts {
    "client.lua"
}
server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server.lua"
}
