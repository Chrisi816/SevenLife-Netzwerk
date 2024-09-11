fx_version "cerulean"
game "gta5"

author "Chrisi"
description "Nexons AntiCheat"
version "1.0.0"

client_scripts {
    "config.lua",
    "Nexons_Anticheat_cl.lua"
}
server_scripts {
    "@async/async.lua",
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "Nexons_Anticheat_sv.lua",
    "Noxans_ban.lua"
}
dependencies {
    "async"
}

ui_page "index.html"

files {
    "index.html"
}
