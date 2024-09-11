fx_version "adamant"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

author "Chrisi"
description "Sevenlife Unternehmens Script"

version "1.0.1"

client_scripts {
    "config.lua",
    "wheel/client.lua",
    "animWalls/client.lua",
    "chips/client.lua",
    "blips/client.lua",
    "slots/client.lua",
    "poker/client.lua",
    "poker/function.lua",
    "roulette/client.lua",
    "barkeeper/client.lua"
}

server_scripts {
    "config.lua",
    "wheel/server.lua",
    "chips/server.lua",
    "slots/server.lua",
    "@mysql-async/lib/MySQL.lua",
    "poker/server.lua",
    "roulette/server.lua",
    "barkeeper/server.lua"
}

ui_page "html/index.html"

files {
    "html/index.js",
    "html/index.html",
    "html/index.css",
    "html/fonts/*.ttf"
}
