fx_version "adamant"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

author "Chrisi"
description "Sevenlife Unternehmens Script"

version "1.0.1"

client_scripts {
    "config.lua",
    "client/client.lua",
    "client/computer.lua",
    "client/npc.lua"
}

server_scripts {
    "config.lua",
    "server/server.lua",
    "@mysql-async/lib/MySQL.lua"
}

ui_page "html/index.html"

files {
    "html/index.js",
    "html/index.html",
    "html/index.css",
    "html/job.css",
    "html/src/*.png",
    "html/src/*.webp",
    "html/src/*.jpg",
    "html/fonts/*.ttf"
}
