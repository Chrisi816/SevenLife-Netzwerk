fx_version "cerulean"

game "gta5"
version "1.2.0"

client_script {
    "client.lua"
}

lua54 "yes"
server_script {
    "server.lua",
    "@mysql-async/lib/MySQL.lua"
}

ui_page "html/index.html"

files {
    "anims.json",
    "html/src/*.png",
    "html/index.js",
    "html/index.css",
    "html/index.html",
    "Animations.json"
}
