fx_version "cerulean"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "SevenLife_Bankingssystem"

author "꧁☬ℭ𝔥𝔯𝔦𝔰𝔦☬꧂#0001"

version "1.0.0"

client_scripts {
    "config_energy.lua",
    "client_energy.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config_energy.lua",
    "server_energy.lua"
}
