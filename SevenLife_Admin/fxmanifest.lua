fx_version "cerulean"
game "gta5"

author "Chrisi"
description "Nexons AntiCheat"
version "1.0.0"

client_scripts {
    "config.lua",
    "client.lua"
}
server_scripts {
    "@async/async.lua",
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server.lua"
}

dependencies {
    "async"
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/index.js",
    "html/index.css",
    "html/pedoptionen.css",
    "html/src/*.png",
    "html/fonts/*.ttf"
}
