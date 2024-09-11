fx_version "cerulean"
game "gta5"
lua54 "yes"

description "Chrisi Whitelist"
version "1.0.1"

client_scripts {
    "client.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server.lua"
}
